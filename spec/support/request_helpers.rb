# frozen_string_literal: true

module RequestHelpers
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def sign_in(user)
    post "/api/v1/auth/login", params: { email: user.email, password: "password123" }
  end

  def auth_headers(user)
    # For cookie-based auth, we need to sign in first
    sign_in(user)
    # Return the session cookie
    { "Cookie" => response.headers["Set-Cookie"] }
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
