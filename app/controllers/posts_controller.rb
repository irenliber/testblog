class PostsController < ApplicationController

  def index
    @posts = Post.all.order('created_at DESC')
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      tags_array = params[:name].split(' ')

      tags_array.each do |tag_string|
        tag = Tag.find_or_create_by(name: tag_string)
        @post.tags << tag
      end

      redirect_to @post
    else
        render 'new'
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(params[:post].permit(:title, :content))
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

end
