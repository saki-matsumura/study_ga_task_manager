class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy] 

  def index
    @clients = Client.all
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to clients_path, notice: "取引先を登録しました"
    else
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if @client.update(client_params)
      redirect_to clients_path, notice: "取引先情報を編集しました"
    else
      render :edit
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: "取引先を削除しました"
  end

  private
  
  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name)
  end
end
