class CommentsController < ApplicationController
    
    def create
        comment = Comment.create(user_id: params[:user_id] , body: params[:body])
        render json: CommentSerializer.new(comment)
    end

    def update
        comment = Comment.find_by(id: params[:id])
        comment.update(comment_params)
        render json: CommentSerializer.new(comment)
    end

    def delete
        comment = Comment.find_by(id: params[:id])
        comment.delete
        render json: CommentSerializer.new(comment)
    end

    private
    def comment_params
        params.require(:comment).permit(:body)
    end
end