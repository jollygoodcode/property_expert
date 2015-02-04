class AgentsController < ApplicationController
  def index
    @agents = Agent.all
  end

  def new
    @agent = Agent.new
  end

  def create
    @agent = Agent.new(params.require(:agent).permit(:name, :company, :mobile))

    if @agent.save
      redirect_to @agent
    else
      render :new
    end
  end

  def show
    @agent = Agent.find(params[:id])
  end

  def edit
    @agent = Agent.find(params[:id])
  end

  def update
    @agent = Agent.find(params[:id])

    if @agent.update(params.require(:agent).permit(:name, :company, :mobile))
      redirect_to @agent
    else
      render :edit
    end
  end

  def destroy
    @agent = Agent.find(params[:id])
    @agent.destroy

    redirect_to agents_path
  end
end
