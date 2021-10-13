# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_player, only: %i[show edit update destroy]

  # GET /players or /players.json
  def index
    user = Admin.where(email: current_admin.email).first
    @players = Player.where(admin_id: user.id).order('name ASC')
  end

  # GET /players/1 or /players/1.json
  def show; end

  # GET /players/new
  def new
    @player = Player.new(losses: 0, wins: 0)
  end

  # GET /players/1/edit
  def edit; end

  # POST /players or /players.json
  def create
    @player = Player.new(player_params)
    # need to add admin id for the new player that is being created to indicate ownership of that player information
    # and let this user and only this user have access to that information when querying
    user = Admin.where(email: current_admin.email).first
    @player.admin_id = user.id

    respond_to do |format|
      if @player.save
        format.html { redirect_to(@player, notice: 'Player was successfully created.') }
        format.json { render(:show, status: :created, location: @player) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @player.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    # no need to udpate admin_id b/c it is already there
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to(@player, notice: 'Player was successfully updated.') }
        format.json { render(:show, status: :ok, location: @player) }
      else
        format.html { render(:edit, status: :unprocessable_entity) }
        format.json { render(json: @player.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @player.destroy!
    respond_to do |format|
      format.html { redirect_to(players_url, notice: 'Player was successfully destroyed.') }
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_player
    @player = Player.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def player_params
    params.require(:player).permit(:name, :losses, :wins, :strengths, :weaknesses, :additional_info)
  end
end
