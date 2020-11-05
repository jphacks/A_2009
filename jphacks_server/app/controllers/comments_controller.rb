class CommentsController < ApplicationController
  def index
    @comments = material.comments.order(created_at: :desc)
  end

  private

  def material
    @material ||= Material.find_by(uuid: params[:material_uuid])
  end
  helper_method :material
end
