class PropertiesController < ApplicationController
  before_action :find_property, only: [:show, :edit, :update, :destroy]

  def index
    @properties = Property.all
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(model_params)

    if @property.save
      redirect_to @property, notice: "Property created successfully."
    else
      flash.now[:error] = "Could not save property."
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @property.update(model_params)
      redirect_to @property, notice: "Property updated successfully."
    else
      flash.now[:error] = "Could not save property."
      render :edit
    end
  end

  def destroy
    @property.destroy
    redirect_to properties_path, notice: "Property deleted successfully."
  end

  def interested
    ContactMailer.interested_in(params[:id]).deliver_now
    redirect_to root_path, notice: "Thanks for your feedback!"
  end

  private

  def model_params
    params.require(:property).permit(:name, :price, :description, :property_type, photos_attributes: [:id, :file, :_destroy])
  end

  def find_property
    @property = Property.find(params[:id])
  end
end
