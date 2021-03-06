# frozen_string_literal: true

module Harvest
  module HTTP
    # lower level class which create the Client for making api calls
    class Client
      def initialize(state: {})
        @state = state
      end

      attr_reader :state

      def method_missing(meth, *args)
        if allowed?(meth)
          Client.new(
            state: @state.merge(meth => args.first)
          )
        else
          super
        end
      end

      def allowed?(meth)
        %i[
          domain
          headers
          client
        ].include?(meth)
      end

      def respond_to_missing?(*)
        super
      end

      def headers(personal_token, account_id)
        Client.new(
          state: @state.merge(
            {
              headers: {
                'User-Agent' => 'harvest-ruby API Client',
                'Authorization' => "Bearer #{personal_token}",
                'Harvest-Account-ID' => account_id
              }
            }
          )
        )
      end

      def client
        RestClient::Resource.new(
          "#{@state[:domain].chomp('/')}/api/v2",
          headers: @state[:headers]
        )
      end
    end
    # Make
    class Api
      def initialize(domain:, account_id:, personal_token:)
        @domain = domain
        @account_id = account_id
        @personal_token = personal_token
      end

      def client
        Harvest::HTTP::Client
          .new
          .domain(@domain)
          .headers(@personal_token, @account_id)
          .client
      end

      # Make a api call to an endpoint.
      # @api public
      # @param struct [ApiCall]
      def api_call(struct)
        JSON.parse(
          send(struct.http_method.to_sym, struct).tap do
            # require 'pry'; binding.pry
          end
        )
      end

      # Pagination through request
      # @api public
      # @param struct [Struct::Pagination]
      def pagination(struct)
        struct.param[:page] = struct.page_count
        page = api_call(struct.to_api_call).tap do
          # require 'pry'; binding.pry
        end
        struct.rows.concat(page[struct.data_key])

        return struct.rows if struct.page_count >= page['total_pages']

        struct.page_count += 1
        pagination(struct)
      end

      # Create Paginaation struct message to pass to pagination call
      def paginator(http_method: 'get', page_count: 1, param: {}, entries: [], headers: {})
        Struct::Pagination.new(
          {
            http_method: http_method,
            param: param,
            rows: entries,
            page_count: page_count,
            headers: headers
          }
        )
      end

      def api_caller(path, http_method: 'get', param: {}, payload: nil, headers: {})
        ApiCall.new(
          {
            path: path,
            http_method: http_method.to_sym,
            params: param,
            payload: payload,
            headers: headers
          }
        )
      end

      private

      def get(struct)
        client[struct.path].get(struct.headers)
      end

      def delete(struct)
        client[struct.path].delete(struct.headers)
      end

      def post(struct)
        client[struct.path].post(struct.payload, struct.headers)
      end

      def patch(struct)
        client[struct.path].patch(struct.payload, struct.headers)
      end
    end

    class NoOptionProvided; end

    class ApiCall
      attr_accessor :path, :http_method, :payload, :headers

      def initialize(path:, payload: {}, http_method: 'get', headers: {}, params: {})
        @path = path
        @http_method = http_method
        @payload = payload
        @headers = headers
        param(params)
      end

      def param(params = NoOptionProvided)
        if params == NoOptionProvided
          @headers['params']
        else
          @headers['params'] = params
        end
      end

      def param=(params)
        param(params)
        self
      end
    end

    Struct.new(
      'Pagination',
      :path,
      :data_key,
      :http_method,
      :page_count,
      :param,
      :payload,
      :rows,
      :headers,
      keyword_init: true
    ) do
      def to_api_call
        ApiCall.new(
          **{
            path: path,
            http_method: http_method,
            params: param,
            payload: payload,
            headers: headers
          }
        )
      end

      def increment_page
        self.page_count += 1
        self
      end
    end
  end
end
