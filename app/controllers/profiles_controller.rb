# frozen_string_literal: true

class ProfilesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def home
    @user = Admin.info(current_admin)
  end

  def edit
    @user = Admin.info(current_admin)
  end

  def update
    @user = Admin.info(current_admin)
    @user.full_name = params[:full_name]

    respond_to do |format|
      if @user.save
        format.html { redirect_to(action: 'home', notice: 'Profile Full Name was successfully updated.') }
        format.json { render(:home, status: :ok, location: @user) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @user.errors, status: :unprocessable_entity) }
      end
    end
  end
end
