class Ability
  include CanCan::Ability

  def build_manageable_companies(user)
    @manageable_companies = user.company.clients
  end

  def initialize(user)

    user ||= Employee.new
    build_manageable_companies user


    if user.venue_admin?

      can :masquerade, Employee

      can [:read, :update], Company do |resource|
        @manageable_companies.any? { |r| resource.id == r.id }
      end

      can :create, Company

      # can :read, Ticket do |resource|
      #   @manageable_companies.any? { |r| resource.client_id == r.id }
      # end

      can :manage, MailTemplate, company_id: user.company_id

      can :create, MailTemplate, company_id: user.company_id, locale: :en, format: :html, handler: :liquid
      # Ticket owners are in our
      can :read, Ticket, client_id: user.company.client_ids
      can :manage, [Facility, Event], company_id: user.company_id
      can :manage, FacilityLease, facility_id: user.company.facility_ids, company_id: user.company.client_ids
    end


    can :login unless user.login_disabled?

    if user.super_admin?
      can :masquerade, Employee
      can :manage, :all
    end

    unless user.super_admin?
      cannot :create, Ticket
      cannot :destroy, Ticket
    end

    # Client admin can only manage their own employees and company
    if user.client_admin?
      can :masquerade, Employee, company_id: user.company_id
      can :manage, Company
      
      can [:read, :update], Company do |resource|
        @manageable_companies.any? { |r| resource.id == r.id }
      end
      
      can :manage, Facility, company_id: user.company_id
      can :read, FacilityLease, company_id: user.company_id
      can :read, Ticket, client_id: user.company_id
      can :read, Inventory, client_id: user.company_id
      can :manage, ConfirmedInventoryOption, client_id: user.company_id
    end

  end
end
