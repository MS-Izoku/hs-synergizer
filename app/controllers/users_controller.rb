class UsersController < ApplicationController
    def create
        user = User.create(user_creation_params)
        if user.valid?
            render json: UserSerializer.new(user)
        else
            render json: {message: "Error creating user" , error: user.errors} , status: 400
        end
    end

    def profile
        render json: UserSerializer.new(current_user) , status: :accepted
    end

    def delete
        
    end

    private
    def user_params
    end

    def user_creation_params
        params.require(:user).permit(:username , :password , :email)
    end
end
