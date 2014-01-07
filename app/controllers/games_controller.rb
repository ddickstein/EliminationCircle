class GamesController < ApplicationController
  include GamesHelper
  before_action :set_game, only: [:show, :destroy, :kill, :remove_player, :launch]
  before_action :check_permissions, only: [:destroy, :kill, :remove_player, :launch]
  helper_method :sort_column, :sort_direction # Sortable columns from Ryan
                                              # Bates, Railscasts #228

  # GET /games/new
  def new
    if signed_in?
      @game = Game.new
      @title = 'New game'
    else
      redirect_to signin_path
    end
  end

  # POST /games
  # POST /games.json
  def create
    if signed_in?
      @game = Game.new(game_params)
      @game.user = current_user
      if @game.preregistered?
        @game.parameters, @game.parameter_lists = get_game_parameters(params)
        @game.started = true
      end
      respond_to do |format|
        if @game.save
          format.html { redirect_to @game, notice: 'Game was successfully created.' }
          format.json { render action: 'show', status: :created, location: @game }
        else
          @num_params = params[:num_params]
          @default_param_values = {}
          1.upto(5) do |x|
            @default_param_values[x] = {
              name: params["param#{x}-name"],
              value: params["param#{x}-list"]
            }
          end
          format.html { render action: 'new' }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to signin_path
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    if not @game.finished?
      @title = @game.name
      @players = @game.players
      @signup_url = "#{root_url}signup?game=#{@game.permalink}"
    else
      @title = "#{@game.name} - Results"
      direction = sort_direction
      column = sort_column
      if column == 'name'
        sort_algorithm = "last_name #{direction}, first_name #{direction}"
      elsif column.nil?
        sort_algorithm = "died_at desc"
      else
        sort_algorithm = "#{column} #{direction}"
      end
      @players = @game.players.reorder(sort_algorithm)
      if Rails.env.development?
        if sort_algorithm == "died_at desc"
          @players.rotate!(-1)
        elsif sort_algorithm == "died_at asc"
          @players.rotate!
        end
      end
      render :results
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
  def kill
    if params.include? :player_id
      @player = GameProfile.find(params[:player_id])
      @hunter = @player.hunter
      @target = @player.target
      
      @player.hunter = nil
      @player.is_alive = false
      @player.died_at = Time.zone.now
      @player.save
      
      @target.hunter = @hunter
      @target.save
      
      @hunter.kills += 1
      @hunter.save
      
      respond_to do |format|
        format.html { redirect_to @game, notice: "#{@player.full_name} was killed."}
        format.json { render action: 'show', status: :killed, location: @game }
      end
    else
      respond_to do |format|
        format.html { redirect_to @game }
      end
    end
  end

  # POST /games/1/register
  def register
    @game, result = register_for_game(params[:id])
    respond_to do |format|
      case result
      when :not_found then format.html { redirect_to root_path, notice: 'That game does not exist' }
      when :already_playing then format.html { redirect_to @game, notice: "You are already playing #{@game.user.full_name}'s game" }
      when :already_started then format.html { redirect_to @game, notice: "#{@game.user.full_name}'s game has already started"}
      when :success then format.html { redirect_to @game, notice: "Successfully added you to #{@game.user.full_name}'s game" }
      when :failure then format.html { redirect_to root_path, error: "Failed to add you to #{@game.user.full_name}'s game" }
      else format.html { redirect_to root_path }
      end
    end
  end

  # DELETE /games/1/remove_player/1
  # DELETE /games/1/remove_player/1.json
  def remove_player
    @player = GameProfile.find(params[:profile_id])
    @player.destroy
    respond_to do |format|
      format.html { redirect_to @game }
      format.json { head :no_content }
    end
  end

  # POST /games/1/launch
  def launch
    unless @game.started? or @game.players.count < 2
      @game.parameters, @game.parameter_lists = get_game_parameters(params)
      @game.started = true
      respond_to do |format|
        if @game.save
          format.html { redirect_to @game, notice: 'Game was successfully launched.' }
          format.json { render action: 'show', status: :created, location: @game }
        else
          format.html { render action: 'show' }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to @game
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
      params.require(:game).permit(:name, :preregistered, :player_sheet)
    end
    
    def check_permissions
      if @game.user != current_user
        redirect_to '/403.html'
      end
    end
    
    def sort_column
      allowed_names = GameProfile.column_names + ['name']
      allowed_names.include?(params[:sort]) ? params[:sort] : nil
    end
    
    def sort_direction
      params[:dir] == 'desc' ? params[:dir] : 'asc'
    end
end
