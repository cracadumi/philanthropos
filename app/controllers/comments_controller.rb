class CommentsController < ApplicationController
  before_action :load_comment, except: [:create]
  authorize_resource
  
  def create
    article = Post.find(params[:post_id])
    comment = article.comments.create(comment_params)
    redirect_to :back
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to :back
  end  

  def update
    @comment = Comment.find(params[:id])
    # @comment.update_attributes(content: params[:comment][:content])
    respond_to do |format|
      if @comment.update_attributes(content: params[:comment][:content])
        format.html { redirect_to(@comment, :notice => 'User was successfully updated.') }
        format.json { respond_with_bip(@comment) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@comment) }
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit!
  end

  def load_comment
    @comment = Comment.find(params[:id])
  end

    
end
