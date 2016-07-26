class PostsController < ApplicationController

  def index
    if params[:tag_link].present?
      @posts = Tag.find_by(name: params[:tag_link]).posts
    else
      @posts = Post.all.order('created_at DESC')
    end

  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])

    @tags = @post.tags.pluck(:name).join(',')
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      tags_array = params[:name].split(',')

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

      params[:tags].split(',').each do |tag_string|
        tag = Tag.find_or_create_by(name: tag_string)
        @post.tags << tag
      end

      tag_list = @post.tags.map{|x| x[:name]}
      update_tags = params[:tags].split(',')

      delete_list = tag_list - update_tags

      delete_list.each do |tag_name|
        @post.tags.delete( Tag.find_by(name: tag_name) )

        # new_tags = tag_list.delete_at(tag_list.index(del))
      end

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
