class PagesController < ApplicationController
  layout 'home'

  before_action :redirect_back, only: %i[ home ]

  def home
  end

  def about
  end
end
