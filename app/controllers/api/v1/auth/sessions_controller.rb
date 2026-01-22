# frozen_string_literal: true

module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        skip_before_action :authenticate_user!, only: %i[signup login]

        def signup
          # First user becomes owner, subsequent users are members
          is_first_user = User.count.zero?

          user = User.new(signup_params)
          user.role = is_first_user ? "owner" : "member"

          if user.save
            session[:user_id] = user.id
            cookies.encrypted[:user_id] = { value: user.id, httponly: true }

            render json: auth_response(user), status: :created
          else
            render json: { error: user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def login
          user = User.find_by_email(params[:email])

          if user&.authenticate(params[:password])
            session[:user_id] = user.id
            cookies.encrypted[:user_id] = { value: user.id, httponly: true }

            render json: auth_response(user)
          else
            render json: { error: "Invalid email or password" }, status: :unauthorized
          end
        end

        def logout
          session.delete(:user_id)
          cookies.delete(:user_id)
          head :no_content
        end

        def me
          render json: auth_response(current_user)
        end

        private

        def signup_params
          params.permit(:name, :email, :password)
        end

        def auth_response(user)
          {
            user: UserSerializer.render_as_hash(user),
            teams: TeamSerializer.render_as_hash(Team.ordered, view: :minimal),
            projects: ProjectSerializer.render_as_hash(Project.active.ordered, view: :minimal)
          }
        end
      end
    end
  end
end
