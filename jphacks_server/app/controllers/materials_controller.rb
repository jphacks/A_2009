class MaterialsController < ApplicationController
  # include ::MaterialsHelper
  # before_action :set_material, only: [:show, :edit, :update, :destroy]

  # GET /materials
  # GET /materials.json
  def index
    @materials = Material.order(updated_at: :desc)
  end

  def show; end

  def new
    @material = Material.new
  end

  def edit; end

  def create
    @material = Material.new(material_params.merge(uuid: SecureRandom.alphanumeric()))

    respond_to do |format|
      if @material.save
        format.html { redirect_to material_path(@material.uuid), notice: 'Material was successfully created.' }
        format.json { render :show, status: :created, location: @material }
      else
        format.html { render :new }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if material.update(material_params)
        format.html { redirect_to @material, notice: 'Material was successfully updated.' }
        format.json { render :show, status: :ok, location: @material }
      else
        format.html { render :edit }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    material.destroy
    respond_to do |format|
      format.html { redirect_to materials_url, notice: 'Material was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def material
      @material = Material.find_by(uuid: params[:uuid])
    end
    helper_method :material

    def material_params
      params
        .require(
          :material
        )
        .permit(
          :url,
          :author,
          :password_digest,
          :title
        )
    end
end
