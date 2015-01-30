class PropertiesController < ApplicationController
  def new
  end

  def create
    @property = Property.new(params.require(:property).permit(:name, :price, :description, :property_type))
    @property.save
    redirect_to @property
  end

  def show
    @property = Property.find(params[:id])
  end
end
