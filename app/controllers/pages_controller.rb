class PagesController < ApplicationController
  def home
    @title = 'Home'
    if params[:game]
      @game = Game.find_by(permalink: params[:game])
    end
  end

  def ideas
    @title = 'Ideas'
    if params[:game]
      @game = Game.find_by(permalink: params[:game])
    end
  end
end
