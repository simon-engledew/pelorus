class CommentsController < ApplicationController

  cache_sweeper :graph_sweeper
  before_filter :authenticate_user!

  def new
    @comment = parent_node.comments.build
  end
  
  def create
    @comment = parent_node.comments.build(params[:comment])
    @comment.user = current_user
    @comment.override_status = false unless current_user.admin
    if @comment.save
      Event.create!(:controller => self, :model => resource)
      return redirect_to(@comment.parent_node.hierarchy)
    end
    render :action => :new
  end
  
  def destroy
    Event.create!(:controller => self, :model => resource) if comment.destroy
    redirect_to comment.parent_node.hierarchy
  end

protected

  def write_permission?
    user_signed_in?
  end

  def parent_node
    params[:parent_node_type].camelize.singularize.constantize.find_by_id(params[:parent_node_id])
  end

  def comment
    @comment ||= (parent_node.comments.find_by_id!(params[:id]) if params[:id])
  end
  
  helper_method :parent_node

end
