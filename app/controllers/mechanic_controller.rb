class MechanicController < ApplicationController
    def index
        mechanics = Mechanic.all
        render json: MechanicSerializer.new(mechanics)
    end

    def show
        mechanic = Mechanic.find_by(id: params[:id])
        render json: MechanicSerializer.new(mechanic)
    end
end
