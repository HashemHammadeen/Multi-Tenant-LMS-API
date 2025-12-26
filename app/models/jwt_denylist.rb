class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
  self.table_name = 'jwt_denylists'
end
# This saves the expired JWT tokens
# or when user logout


# maybe we need background job to clear the model from unused tokens
