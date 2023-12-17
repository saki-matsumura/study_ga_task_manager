class TypeOfTasksController < ApplicationController
  before_action :set_type_of_task, only: [:show, :edit, :update, :destroy] 

  def index
    @type_of_tasks = TypeOfTask.all
  end

  def new
    @type_of_task = TypeOfTask.new
  end

  def create
    @type_of_task = TypeOfTask.new(type_of_task_params)
    if @type_of_task.save
      redirect_to type_of_tasks_path, notice: "作業工程を登録しました"
    else
      render :new
    end
  end

  def edit
  end

  def show
  end

  def update
    if @type_of_task.update(type_of_task_params)
      redirect_to type_of_tasks_path, notice: "作業工程情報を編集しました"
    else
      render :edit
    end
  end

  def destroy
    @type_of_task.destroy
    redirect_to tasks_path, notice: "工程を削除しました"
  end

  private
  
  def set_type_of_task
    @type_of_task = TypeOfTask.find(params[:id])
  end

  def type_of_task_params
    params.require(:type_of_task).permit(:name,
      working_processes_attributes: [:id, :_destroy])
  end
end
