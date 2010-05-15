class CommentsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @comment = parent_node.comments.build
  end
  
  def create
    @comment = parent_node.comments.build(params[:comment])
    @comment.user = current_user
    return redirect_to(@comment.parent_node.hierarchy) if @comment.save
    render :action => :new
  end

protected

  def write_permission?
    user_signed_in?
  end

  def parent_node
    params[:parent_node_type].camelize.singularize.constantize.find_by_id(params[:parent_node_id])
  end

  def comment
    @comment ||= (parent_node.comments.find(params[:id]) if params[:id])
  end
  
  helper_method :parent_node

end
