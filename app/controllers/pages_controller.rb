class PagesController < ApplicationController
  def home
    @title = 'Home'
  end

  def ideas
    @title = 'Ideas'
  end
end
