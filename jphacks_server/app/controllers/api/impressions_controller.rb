module Api
  class ImpressionsController < ApplicationController
    protect_from_forgery

    def create
      @impression = Impression.new(impression_params)
  
      if @impression.save
        render json: @impression, status: :created
      else
        render json: { message: @impression.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
      def material
        @material ||= Material.find_by(uuid: params[:material_uuid])
      end
      helper_method :material
  
      def impression_params
        params
          .permit(
            :value
          )
          .merge(
            material_id: material.id
          )
      end
  end
  
end