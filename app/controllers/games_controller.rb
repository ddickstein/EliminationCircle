class GamesController < ApplicationController
  before_action :set_game, only: [:show, :destroy, :kill]
  before_action :check_permissions, only: [:destroy, :kill]
  
  # GET /games/1
  # GET /games/1.json
  def show
    if @game.is_alive?
      @title = @game.name
      @players = @game.players.living + @game.players.fallen
    else
      @title = "#{@game.name} - Results"
      render :results
    end
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
      format.html { redirect_to user_path(current_user) }
      format.json { head :no_content }
    end
  end

  # POST /games/1/kill
  # POST /games/1/kill.json
  def kill
    if params.include? :player_id
      @player = Player.find(params[:player_id])
      @hunter = @player.hunter
      @target = @player.target
      
      @player.hunter = nil
      @player.is_alive = false
      @player.save
      
      @target.hunter = @hunter
      @target.save
      
      @hunter.kills += 1
      @hunter.save
      
      respond_to do |format|
        format.html { redirect_to @game, notice: "#{@player.name} was killed."}
        format.json { render action: 'show', status: :killed, location: @game }
      end
    else
      respond_to do |format|
        format.html { redirect_to @game }
        format.json { render action: 'show', location: @game }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find_by(permalink: params[:id])
      if @game.nil?
        redirect_to root_path
      end
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:name, :details_columns, :csv_format,
                                   :csv_sheet, :randomization_algorithm)
    end
    
    def check_permissions
      if @game.user != current_user
        redirect_to '/403.html'
      end
    end
end