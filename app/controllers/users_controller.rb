class UsersController < ApplicationController
    skip_before_action :authorized , only: [:create]
    def create
        user = User.create(user_params)
        if user.valid?
            token = encode_token({user_id: user.id})
            render json: { user: UserSerializer.new(user) , jwt: token } , status: :created
        else
            render json: {message: "Error creating user" , error: user.errors} , status: :not_acceptable
        end
    end

    def profile
        render json: UserSerializer.new(current_user) , status: :accepted
    end

    def delete
        
    end

    private
    def user_params
        params.require(:user).permit(:username , :password , :email)
    end
end
