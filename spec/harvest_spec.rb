# frozen_string_literal: true

require 'pry'

RSpec.describe Harvest do
  let(:config) do
    {
      domain: 'https://exampledomain.harvestapp.com',
      account_id: 'example_account_id',
      personal_token: 'example_personal_token'
    }
  end
  let(:harvest) do
    body = { 'id' => 1_234_567 }
    stub_request(:get, "#{config[:domain]}/api/v2/users/me")
      .to_return(body: body.to_json, status: 200)
    Harvest::Client.new(config)
  end

  it 'has a version number' do
    expect(Harvest::VERSION).not_to be nil
  end

  context 'with harvest' do
    it 'has active user id' do
      expect(harvest.active_user.id).to eq(1_234_567)
    end

    it 'change active state to projects' do
      expect(harvest.projects.state[:active]).to eq(:projects)
    end

    it 'change active state to time_entry' do
      expect(harvest.time_entry.state[:active]).to eq(:time_entry)
    end

    it 'find project' do
      body = { 'id' => 983_754 }
      stub_request(:get, "#{config[:domain]}/api/v2/projects/983754")
        .to_return(body: body.to_json, status: 200)
      expect(harvest.projects.find(body['id']).state[:projects][0].id).to eq(body['id'])
    end

    it 'select a project' do
      body = {
        project_assignments: [
          { 'id' => 349_832, project: { 'name' => 'Bob Co' } },
          { 'id' => 97_836_415, project: { name: 'George Co' } }
        ]
      }
      stub_request(
        :get,
        "#{config[:domain]}/api/v2/users/#{harvest.active_user.id}/project_assignments"
      ).to_return(body: body.to_json, status: 200)
      projects = harvest.projects.discover.select { |pa| pa.project.name == 'Bob Co' }
      expect(projects.state[:filtered][:projects][0].project.name).to eq('Bob Co')
    end
  end
end
