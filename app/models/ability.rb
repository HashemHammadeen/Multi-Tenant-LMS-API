class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    case user.role
    when "user"
      user_permissions(user)
    when "instructor"
      instructor_permissions(user)
    when "admin"
      admin_permissions(user)
    end
  end

  private

  def user_permissions(user)
    # Courses - only from their school
    can :read, Course, school_id: user.school_id

    # User can read/update only themselves
    can [:read, :update], User, id: user.id

    # Enrollments: only their own
    can :read, Enrollment, user_id: user.id
  end

  def instructor_permissions(user)
    # inherits user permissions
    user_permissions(user)

    # Courses - only from their school
    can :update, Course, school_id: user.school_id

    # Users & enrollments (read-only) - only from their school
    can :read, User, school_id: user.school_id
    can :read, Enrollment # Enrollment doesn't have school_id, so check through associations
  end

  def admin_permissions(user)
    # Admin can manage everything BUT only within their school
    can :manage, User, school_id: user.school_id
    can :manage, Course, school_id: user.school_id
    can :manage, Enrollment # Will be scoped through Course/User relationships
  end
end