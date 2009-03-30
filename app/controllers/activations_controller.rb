class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new]
  
  def new
    @user = User.find_using_perishable_token(params[:activation_code], 1.week)
    if @user.nil?
      flash[:notice] = "No user found for this activation code"
    elsif @user.active?
      flash[:notice] = "User already activated"
    else
      flash[:notice] = "User activated"
      # Activate and redirect
      @user.activate!()
      @user.deliver_activation_confirmation!
      redirect_to account_url
    end
  end
  
  def create
    @user = User.find(params[:id])
    if @user.valid? && @user.activate!()
      @user.deliver_activation_confirmation!
      flash[:notice] = "Your account has been activated."
      redirect_to account_url
    else
      render :action => :new
    end
  end  
end