class PagesController < ApplicationController
  # layout 'home'

  before_action :redirect_back, only: %i[home]

  # GET /home
  #----------------------------------------------------------------------------
  def home; end

  # GET /about
  #----------------------------------------------------------------------------
  def about; end
end
