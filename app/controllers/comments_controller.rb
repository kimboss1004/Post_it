class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(params.require(:comment).permit!)
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "Your comment has been submitted"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    comment = Comment.find(params[:id])
    vote = Vote.create(vote: params[:vote], creator: current_user, voteable: comment)

    if vote.valid?
      flash[:notice] = "Your vote has been counted."
    else
      flash[:error] = "You cannot vote more than once."
    end

    redirect_to :back
  end

end