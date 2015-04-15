class SessionsController < ApplicationController
  respond_to :json, only: [:create, :destroy, :show]

  def create
    @user = User.find_by(email: session_params[:email])

    if @user and @user.authenticate(session_params[:password])
      sign_in @user
      # Using respond_with results in:
      # => NoMethodError - undefined method `user_url' for #<SessionsController:0x007fea19a7aed0>
      render json: @user, status: 200
    else
      # Using respond_with results in:
      # => ArgumentError - Nil location provided. Can't build URI.
      # See: 
      # => http://stackoverflow.com/questions/14677646/respond-with-argumenterror-nil-location-provided-cant-build-uri
      render json: nil, status: 401
    end
  end

  def destroy
    sign_out()
    respond_with status: 204, nothing: true
  end

  def show
    if signed_in?
      respond_with current_user
    else
      render nothing: true, status: 404
    end
  end

  private
    def session_params
      params.require(:session).permit(:email, :password)
    end

    def sign_in(user)
      session[:user_id] = @user.id
    end

    def sign_out
      session[:user_id] = nil
      @_current_user    = nil
    end

    def signed_in?
      current_user
    end

end