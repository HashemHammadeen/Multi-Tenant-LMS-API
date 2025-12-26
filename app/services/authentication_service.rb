class AuthenticationService
  def self.sign_up(email:, password:, name:, role: "user")
    school = Current.school # Already set by your middleware

    # The safe navigation operator [&.] prevents errors if school is nil.
    # first if school is exist ==> then calls active
    # if not raise error and do not call active this prevents errors
    raise StandardError, "School not found or inactive" unless school&.active?

    if school.users.exists?(email: email)
      raise StandardError, "Email already exists in this school"
    end

    user = User.new(
      email: email,
      password: password,
      name: name,
      role: role
    )

    if user.save
      { user: user, token: generate_token(user) }
    else
      raise StandardError, user.errors.full_messages.to_sentence
    end
  end

  def self.sign_in(email:, password:)
    school = Current.school
    raise StandardError, "School not found or inactive" unless school&.active?

    # here I searched user via the school because user might be
    # in one school but not in the other
    # default scope in user model is not enough because
    # Someone could call .unscoped somewhere
    user = school.users.find_by(email: email)
    raise StandardError, "Invalid credentials" unless user

    raise StandardError, "User is inactive" unless user.active?
    raise StandardError, "Invalid credentials" unless user.valid_password?(password)

    { user: user, token: generate_token(user) }
end

  def self.sign_out(token:)
    payload = Warden::JWTAuth::TokenDecoder.new.call(token)

    # we just add the jwt token to the deny list
    JwtDenylist.create!(
      jti: payload["jti"],
      exp: Time.at(payload["exp"])
    )

    { success: true }
  end

  private

  def self.generate_token(user)
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end
end