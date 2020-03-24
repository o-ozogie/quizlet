class AuthsController < ApplicationController
  before_action :oauth_required, only: :sign_in
  before_action :refresh_token_required, only: :refresh

  def sign_in
    user = User.find_by_email(@resp['email'])
    return render status: 404 unless user

    render json: { access_token: @@jwt_base.create_access_token(user_id: user.id),
                   refresh_token: @@jwt_base.create_refresh_token(user_id: user.id)},
           status: 200
  end

  def refresh
    render json: { access_token: @@jwt_base.create_refresh_token(@payload) },
           status: 200
  end
end
