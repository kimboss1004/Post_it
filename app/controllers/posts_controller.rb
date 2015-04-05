class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show, :vote]
  before_action :creator_of_post, only: [:edit, :update]

  def index
    @posts = Post.all.sort_by{|x| x.total_votes}
  end

  def show
    #before action method
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = "Your post was created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
    #before action method
  end

  def update
    #before action method
    if @post.update(post_params)
      flash[:notice] = "This post was updated."
      redirect_to posts_path
    else
      render :edit
    end
  end

  def vote
    vote = Vote.create(creator: current_user, vote: params[:vote], voteable: @post)

    if vote.valid?
      flash[:notice] = "Your vote was counted."
    else
      flash[:error] = "You cannot vote more than once"
    end 

    redirect_to :back
  end


  private

  def post_params
    params.require(:post).permit!
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def creator_of_post
    if current_user != @post.creator
      flash[:error] = 'You must be the creator to see that page'
      redirect_to root_path
    end
  end

end
