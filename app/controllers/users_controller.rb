class UsersController < ApplicationController
  before_action :oauth_required

  def create
    return render status: 409 if User.find_by_email(@resp['email'])

    user = User.create!(name: @resp['name'],
                        email: @resp['email'])

    render json: { user_id: user.id },
           status: 201
  end
end
