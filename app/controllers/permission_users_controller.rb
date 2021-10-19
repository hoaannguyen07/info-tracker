class PermissionUsersController < ApplicationController
    before_action :set_permission_users, only: %i[ destroy ]
    def index
        @admins = Admin.all
    end

    
    def show
        puts("hello world")
    end
    
end