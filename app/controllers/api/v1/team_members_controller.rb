# frozen_string_literal: true

module Api
  module V1
    class TeamMembersController < BaseController
      before_action :set_team
      before_action :require_admin!, only: %i[create destroy]

      def index
        render json: {
          members: TeamMembershipSerializer.render_as_hash(@team.team_memberships.includes(:user), view: :with_user)
        }
      end

      def create
        user = User.find(params[:user_id])
        membership = @team.team_memberships.build(user: user, role: params[:role] || "member")

        if membership.save
          render json: {
            member: TeamMembershipSerializer.render_as_hash(membership, view: :with_user)
          }, status: :created
        else
          render json: { error: membership.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        membership = @team.team_memberships.find_by!(user_id: params[:user_id])
        membership.destroy!
        head :no_content
      end

      private

      def set_team
        @team = Team.find_by!(key: params[:team_key].upcase)
      end
    end
  end
end
