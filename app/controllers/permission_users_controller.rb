# frozen_string_literal: true

class PermissionUsersController < ApplicationController
    before_action :set_permission_user, only: %i[show destroy]

    def index
        @admins = Admin.all
        @permission_users = PermissionUser.all
        @permissions = Permission.all
    end

    def new
        @permissions = Permission.all
        @admins = Admin.all
        # if @permission_users.find(user_id_id: @admins.find(params[:user_id]), permissions_id_id: params[:permission_id] )
        #   puts('testing')
        # end
        @permission_user = PermissionUser.new(user_id: @admins.find(params[:user_id]),
                                              created_by_id: params[:user_id],
                                              updated_by_id: params[:user_id],
                                              permissions_id_id: params[:permission_id]
                                             )
        # @user = Admin.find(params[:user_id])
        # @permission_user = PermissionUser.new(permission_user_params)

        respond_to do |format|
            if @permission_user.save
                format.html { redirect_to('/permission_users', notice: 'Permission User was successfully created.') }
                format.json { render(:show, status: :created, location: @permission) }
            else
                format.html { render(:new, status: :unprocessable_entity) }
                format.json { render(json: @permission.errors, status: :unprocessable_entity) }
            end
        end
    end

    def show
        @permissions = Permission.all
        @admins = Admin.all
    end

    def destroy
        # @permission_users.destroy(self.inspect)
        @permission_users.destroy(@permission_users.where(user_id_id: params[:user_id], permissions_id_id: params[:permission_id]))
    end
    helper_method :destroy

    private

    # Only allow a list of trusted paramaters through.
    def permission_user_params
        params.permit(:user_id, :created_by, :updated_by, :permissions_id)
    end
end
