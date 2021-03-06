# frozen_string_literal: true

module Harvest
  module Resources
    # @param id [Integer]
    #   Unique ID for the user assignment.
    # @param project [Struct]
    #   An object containing the id, name, and code of the associated project.
    # @param user [Struct]
    #   An object containing the id and name of the associated user.
    # @param is_active [Boolean]
    #   Whether the user assignment is active or archived.
    # @param is_project_manager [Boolean]
    #   Determines if the user has Project Manager permissions for the project.
    # @param use_default_rates [Boolean]
    #   Determines which billable rates will be used on the project for this user
    #   when bill_by is People. When true, the project will use the users
    #   default billable rates. When false, the project will use the custom rate
    #   defined on this user assignment.
    # @param hourly_rate [decimal]
    #   Custom rate used when the projects bill_by is People and use_default_rates is false.
    # @param budget [decimal]
    #   Budget used when the projects budget_by is person.
    # @param created_at [DateTime]
    #   Date and time the user assignment was created.
    # @param updated_at [DateTime]
    #   Date and time the user assignment was last updated.
    UserAssignment = Struct.new(
      'UserAssignment',
      :id,
      :project,
      :user,
      :is_active,
      :is_project_manager,
      :use_default_rates,
      :hourly_rate,
      :budget,
      :created_at,
      :updated_at,
      keyword_init: true
    )
  end
end
