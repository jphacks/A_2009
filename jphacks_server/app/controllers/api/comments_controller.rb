module Api
  class CommentsController < ApplicationController
    protect_from_forgery

    def index
      @comments = material.comments.order(number: :asc).order(created_at: :desc)
    end

    def create
      @comment = Comment.new(comment_params)
      if @comment.save
        render :show, format: :json, status: :ok
      else
        render json: { message: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def plus
      render json: { message: '予期せぬエラーが起こりました' }, status: :unprocessable_entity and return unless comment_for_plus.present?

      count = comment_for_plus.count + 1
      if @comment.update(count: count)
        render :show, format: :json, status: :ok
      else
        render json: { message: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    private

    def material
      @material ||= Material.find_by(uuid: params[:material_uuid])
    end
    helper_method :material

    def comment_for_plus
      @comment ||= Comment.find_by(uuid: params[:comment_uuid])
    end

    def comment_params
      params
        .permit(
          :text,
          :number
        )
        .merge(
          uuid: SecureRandom.alphanumeric(),
          count: 0,
          material_id: material&.id
        )
    end
  end
end