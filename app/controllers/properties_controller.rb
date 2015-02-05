class PropertiesController < ApplicationController
  def index
    @properties = Property.all
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(params.require(:property).permit(:name, :price, :description, :property_type, :agent_id))

    if @property.save
      redirect_to @property, notice: "Property created successfully."
    else
      flash.now[:error] = "Could not save property."
      render :new
    end
  end

  def show
    @property = Property.find(params[:id])
  end

  def edit
    @property = Property.find(params[:id])
  end

  def update
    @property = Property.find(params[:id])

    if @property.update(params.require(:property).permit(:name, :price, :description, :property_type, :agent_id))
      redirect_to @property, notice: "Property updated successfully."
    else
      flash.now[:error] = "Could not save property."
      render :edit
    end
  end

  def destroy
    @property = Property.find(params[:id])
    @property.destroy

    redirect_to properties_path, notice: "Property deleted successfully."
  end

  def interested
    ContactMailer.interested_in(params[:id]).deliver_now
    redirect_to root_path, notice: "Thanks for your feedback!"
  end
end
