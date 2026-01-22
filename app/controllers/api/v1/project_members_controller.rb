# frozen_string_literal: true

module Api
  module V1
    class ProjectMembersController < BaseController
      before_action :set_project
      before_action :require_admin!, only: %i[create destroy]

      def index
        render json: {
          members: UserSerializer.render_as_hash(@project.members)
        }
      end

      def create
        user = User.find(params[:user_id])
        membership = @project.project_memberships.build(user: user, role: params[:role] || "member")

        if membership.save
          render json: {
            member: UserSerializer.render_as_hash(user)
          }, status: :created
        else
          render json: { error: membership.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        membership = @project.project_memberships.find_by!(user_id: params[:user_id])
        membership.destroy!
        head :no_content
      end

      private

      def set_project
        @project = Project.find_by!(slug: params[:project_slug])
      end
    end
  end
end
