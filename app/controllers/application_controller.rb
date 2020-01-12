# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload)
    JWT.encode(payload, my_secret)
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, my_secret, true, algorithm: 'HS256')
      rescue JWT.decode_error
        nil
      end
    end
  end

  def auth_header
    request.headers['Authorization']
  end

  def current_user
    User.find_by(id: decoded_token[0].user_id) if decoded_token
    # else return nil
  end

  def authorized
    render json: { message: 'Please Log In' }, status: :unauthorized unless logged_in?
  end

  def logged_in?
    !!current_user
  end

  private

  def my_secret
    'I am the lord your god, you will have no other gods before me'
  end
end
