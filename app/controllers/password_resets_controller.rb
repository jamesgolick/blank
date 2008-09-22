class PasswordResetsController < ApplicationController
  def create
    @person = Person.find_by_email(params[:email])
    
    if @person.nil?
      flash.now[:notice] = "Sorry, we cannot find a user by that email address. Please check your entry and try again."
      render :action => "new"
    else
      flash.now[:notice] = "We've sent you an email with instructions on how to reset your password."
    end
  end
end
