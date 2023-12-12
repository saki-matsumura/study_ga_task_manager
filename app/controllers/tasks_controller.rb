class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :back_to_index, only: [:edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def new
    if params[:back]
      @task_form = TaskForm.new(current_user, Task.new, Client.new, task_params)
    else
      @task_form = TaskForm.new(current_user, Task.new, Client.new)
    end
  end
  
  def create
    @task_form = TaskForm.new(current_user, Task.new, Client.new, task_params)
    if params[:back]
      render :new
    else
      if @task_form.save
        redirect_to task_path(@task_form.task), notice: "タスクを作成しました"
      else
        render :new
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task_form.update(current_user, @task.client, @task, task_params)
      redirect_to task_path(@task_form.task), notice: "タスクを編集しました"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました"
  end

  private


  def task_params
    params.require(:task).permit(:title, :note, :deadline_on, :done, :client_id,
      clients: [:name],
      type_of_tasks: [:name],
      working_processes: [
        :type_of_task_id, 
        :workload, 
        :working_hour, 
        :unit,
        :_destroy
      ]

    # ,
    #                               clients_attributes: [
    #                                 :id,
    #                                 :name
    #                               ],
    #                               type_of_tasks_attributes: [
    #                                 :id, 
    #                                 :name
    #                               ],
    #                               working_processes_attributes: [
    #                                 :id,
    #                                 :type_of_task_id, 
    #                                 :workload, 
    #                                 :working_hour, 
    #                                 :unit,
    #                                 :_destroy
    #                               ]
                                  )
  end

  def client_params
    params.require(:clients).permit(:name)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def back_to_index
    # 自分以外のユーザーが編集・削除しようとするとタスク一覧画面に遷移
    # binding.pry
     if current_user != @task_form.user
      redirect_to tasks_path
     end
  end

end
