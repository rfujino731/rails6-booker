class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @selected = params[:selected]
    # @users = User.looks(params[:search], params[:word])
    if @selected == "User"
      @users = User.looks(params[:parameter], params[:word])
    else
      @books = Book.looks(params[:parameter], params[:word])
    end
  end
end
