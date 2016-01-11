class PostsController < ApplicationController
  before_action :load_post, except: [:new, :create, :posts_for_category]
  authorize_resource

  def new
    @post = Post.new
  end

  def create
    post = current_user.posts.new(post_params)
    authorize! :create, post 
    if post.save
      flash[:notice] = "Votre publication a été créée avec succès"
      redirect_to posts_for_category_post_path(params[:post][:category_id])
    else
      flash[:alert] = "Une erreur inattendue est apparue(assurez-vous que le titre et le contenu ne sont pas vides)"
      redirect_to :back
    end  
  end

  def posts_for_category
    @category = Category.find(params[:id])
    @sub_category = Subcategory.all
    authorize! :posts_for_category, @category 
    if params[:sub_cat_id].present?
      @posts = Post.where(category_id: 4, subcategory_id: params[:sub_cat_id]).paginate(:page => params[:page], :per_page => 10).order('id desc')
    else  
      @posts = Post.where(category_id: params[:id]).paginate(:page => params[:page], :per_page => 10).order('id desc')
    end
  end  

  def destroy
    # post = Post.find(params[:id])
    @post.destroy
    redirect_to :back
  end

  def edit
    # @post = Post.find(params[:id])
  end  

  def update
    # authorize! :update, @user
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "Publication mise à jour avec succès"
      redirect_to posts_for_category_post_path(params[:post][:category_id])
    else
      flash[:alert] = "Une erreur inattendue est apparue"
      redirect_to :back
    end  
  end  

  def show

  end

    

  private
  def post_params
    params.require(:post).permit!
  end

  def load_post
    @post = Post.find(params[:id])
  end 

end
