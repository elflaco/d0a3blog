# encoding: UTF-8
class PostsController < ApplicationController

  def index
    @headers = Post.where(:main => true).order('id DESC').limit(5)
    if params[:user_id]
      query = User.find(params[:user_id]).posts
    elsif params[:tag_id]
      query = Tag.find_by_name(params[:tag_id]).posts
    else 
      query = Post.all
    end
    @posts = query.order('id DESC').page(params[:page])
    @hots = Post.all.order('view DESC').limit(5)
  end

  def show
  	@post = Post.find(params[:id])
    @prev_post = Post.all.order('id DESC').where("id < #{@post.id}").limit(1).first || Post.last
    @next_post = Post.all.order('id ASC').where("id > #{@post.id}").limit(1).first || Post.first
    @post.save
  end

  def new
  	@post = Post.new({
      user_id: current_user.id,
      title: "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
      credits: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Saepe consequatur ipsum sunt soluta quidem deleniti delectus nostrum quas, dolore eos fugit consequuntur ipsa ad ex voluptatum! Voluptates ipsam, architecto nemo."
      })
    if @post.save
      redirect_to edit_post_path(@post)
    else
      flash[:warning] = "Ocurrió un error al crear el post"
    end
  end

  def tags
    @post = @post.find(params[:post_id]) || Post.new
    @post.title = params[:tags]
    @post.save
  end

  def create
  	# @post = current_user.posts.build(post_params)
  	# if @post.save
  	# 	flash[:success] = "Post creado correctamente"
   #    redirect_to posts_path
  	# else
  	# 	render 'new'
  	# end
  end

  def edit
  	@post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "Post actualizado exitosamente"
      redirect_to @post
    else
      render "edit"
    end
  end

  def destroy
  	Post.find(params[:id]).destroy
  end

  private

  	def post_params
  		params.require(:post).permit(:title, :cover_id, :text, :main, :post_type_id, :user_id, :credits)
  	end

end