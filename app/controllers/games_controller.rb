class GamesController < ApplicationController
  before_action :set_game, only: [:show, :destroy]
  before_action :check_permissions, only: :destroy
  
  # GET /games/1
  # GET /games/1.json
  def show
    @title = @game.name
  end

  # GET /games/new
  def new
    if signed_in?
      @game = Game.new
      @title = 'New game'
    else
      redirect_to root_path
    end
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(game_params)
    @game.user = current_user
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find_by(permalink: params[:id])
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:name, :details_title, :csv_format,
                                   :csv_sheet, :randomize_details)
    end
    
    def check_permissions
      if @user != current_user
        redirect_to '/403.html'
      end
    end
end
