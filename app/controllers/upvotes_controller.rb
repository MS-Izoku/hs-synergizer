class UpvotesController < ApplicationController
    def upvote
        @upvote = Upvote.new(upvote_params)

    end

    def remove_upvote
        @upvote = Upvote.find_by(id: params[:id])
        @upvote.delete
    end

    private 
    def upvote_params
        params.require(:upvote)
    end

end