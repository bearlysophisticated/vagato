class CommentController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to @comment.booking, notice: 'Vélemény mentve!'
    end
  end


  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:stars, :text, :guest_id, :accommodation_id, :booking_id)
  end
end
