class ItineraryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    record.user.admin == true
  end

  def new?
    create?
  end

  def update?
    record.user.admin == true
  end

  def edit?
    update?
  end

  def destroy?
    record.user.admin == true
  end

end
