class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: [:show, :edit, :update, :destroy]
  # GET /users/1
  # GET /users/1.json
  def show
    @title = "Profile"
    @all_games = Game.joins("LEFT OUTER JOIN game_profiles ON games.id = " +
                        "game_profiles.game_id").where("games.user_id = :id " +
                        "OR game_profiles.user_id = :id", {id: @user.id}).uniq
    @pending_games     = @all_games.select(&:pending?)
    @progressing_games = @all_games.select(&:progressing?)
    @finished_games    = @all_games.select(&:finished?)
  end

  # GET /users/new
  def new
    if signed_in?
      if params[:game]
        redirect_to register_game_path(params[:game])
      else
        redirect_to root_path
      end
    else
      @user = User.new
      @title = "Sign up"
      if params[:game]
        @game = Game.find_by(permalink: params[:game])
      end
    end
  end

  # GET /users/1/edit
  def edit
    @title = "Edit info"
  end

  # POST /users
  # POST /users.json
  def create
    if signed_in?
      redirect_to root_path
    else
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          sign_in @user
          if params[:game]
            format.html { redirect_to register_game_path(params[:game]) }
          else
            format.html { redirect_to @user, notice: 'User was successfully created.' }
          end
          format.json { render action: 'show', status: :created, location: @user }
        else
          @game = Game.find_by(permalink: params[:game])
          format.html { render action: 'new' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      if @user.nil?
        redirect_to root_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :mobile, :password,
                                   :password_confirmation)
    end
    
    def check_permissions
      if @user != current_user
        redirect_to '/403.html'
      end
    end
end