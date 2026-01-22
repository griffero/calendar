# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # Try session-based auth first
      if (user_id = cookies.encrypted[:user_id])
        User.find_by(id: user_id)
      # Then try API token
      elsif (token = request.params[:token])
        api_token = ApiToken.find_by_token(token)
        api_token&.user
      else
        reject_unauthorized_connection
      end
    end
  end
end
