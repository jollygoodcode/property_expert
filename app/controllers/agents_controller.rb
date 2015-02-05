class AgentsController < ApplicationController
  before_action :find_agent, only: [:show, :edit, :update, :destroy]

  def index
    @agents = Agent.all
  end

  def new
    @agent = Agent.new
  end

  def create
    @agent = Agent.new(model_params)

    if @agent.save
      redirect_to @agent, notice: "Agent created successfully."
    else
      flash.now[:error] = "Could not save agent."
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @agent.update(model_params)
      redirect_to @agent, notice: "Agent created successfully."
    else
      flash.now[:error] = "Could not save agent."
      render :edit
    end
  end

  def destroy
    @agent.destroy
    redirect_to agents_path, notice: "Agent deleted successfully."
  end

  private

    def model_params
      params.require(:agent).permit(:name, :company, :mobile, :photo)
    end

    def find_agent
      @agent = Agent.find(params[:id])
    end
end
