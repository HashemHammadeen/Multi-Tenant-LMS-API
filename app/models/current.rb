# ActiveSupport::CurrentAttributes uses thread-local storage
# Current stores attributes per request/thread.
# When the request ends, Rails clears thread-local storage automatically,
# so Current.school becomes nil for the next request in the same thread.
class Current < ActiveSupport::CurrentAttributes

  attribute :school
  attribute :user

  # this is important it makes each query specified to the specific school
end
# Without this, you'd have to pass the current school through every method call.
# This global-but-thread-safe storage makes the current tenant always accessible.
