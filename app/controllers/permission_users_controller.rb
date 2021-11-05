# frozen_string_literal: true

class PermissionUsersController < ApplicationController
  before_action :set_permission_user, only: %i[destroy]

  def index
    @admins = Admin.all
    @permission_users = PermissionUser.all
    @permissions = Permission.all
  end

  # creates a new active record on the permission_users
  # table with the resourceful path below
  # /permission_users/new?permission_id=(:id)&user_id=(:id)&created_by=(:id)&updated_by=(:id)
  def new
    @permission_users = PermissionUser.all
    if @permission_users.exists?(user_id_id: params[:user_id],
                                 permissions_id_id: params[:permission_id]
                                )

      respond_to do |format|
        format.html { redirect_to('/permission_users', notice: 'The user already has that permission!') }
        format.json { render(json: @permission.errors, status: :unprocessable_entity) }
      end
    else
      @permission_user = PermissionUser.new(user_id_id: params[:user_id],
                                            created_by_id: params[:created_by],
                                            updated_by_id: params[:updated_by],
                                            permissions_id_id: params[:permission_id]
                                           )

      respond_to do |format|
        if @permission_user.save
          format.html { redirect_to('/permission_users', notice: 'The user\'s permission has been successfully updated!') }
          format.json { render(:show, status: :created, location: @permission) }
        else
          format.html { render(:new, status: :unprocessable_entity) }
          format.json { render(json: @permission.errors, status: :unprocessable_entity) }
        end
      end
    end
  end

  # DELETE /permissions/1 or /permissions/1.json
  def destroy
    @permission_user.destroy!
    respond_to do |format|
      format.html { redirect_to('/permission_users', notice: 'Permission was successfully destroyed.') }
      format.json { head(:no_content) }
    end
  end

  def set_permission_user
    @permission_user = PermissionUser.find(params[:id])
  end
end
