class HomeController < ApplicationController
  def index
    @elections = Election.order(created_at: :desc)
  end
end
