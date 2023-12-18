class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy] 
  before_action :back_to_index, only: [:edit, :update, :destroy]

  def index
    @tasks = Task.all.default
  end

  def new
    if params[:back]
      set_task_form
    else
      @task_form = TaskForm.new(current_user)
    end
  end
  
  def create
    set_task_form
    # binding.pry
    if @task_form.save
      # binding.pry
      redirect_to task_path(@task_form.task), notice: "タスクを作成しました"
    else
      # binding.pry
      render :new
    end
  end

  def show
    @working_processes = WorkingProcess.where('task_id = ?', @task.id)
  end

  def edit
    @task_form = TaskForm.new(current_user)
    task_form_params
  end

  def update
    set_task_form
    task_form_params
    binding.pry
    if @task_form.update(current_user, task_params)
      redirect_to task_path(@task), notice: "タスクを編集しました"
    else
      render :edit
    end
  end

  def destroy
    @working_processes = WorkingProcess.where('task_id = ?', @task.id)
    @working_processes.each do | working_process |
      working_process.destroy
    end
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました"
  end

  private

  def set_task_form
    @task_form = TaskForm.new(current_user, task_params)
  end

  def task_params
    params.require(:task).permit(
      :title, 
      :note, 
      :deadline_on, 
      :done, 
      :client_id, 
      :image, 
      :image_cache,
      clients: [
        :id,
        :name],
      type_of_tasks: [
        :id,
        :name],
      working_process: [
        :type_of_task_id, 
        :workload, 
        :working_hour, 
        :unit,
        :task_id,
        :_destroy
      ])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_form_params
    @task_form.task = @task
    @task_form.client = @task.client
    @working_processes = WorkingProcess.where('task_id = ?', @task.id)
    unless @working_processes.count.zero?
      @task_form.type_of_task = @working_processes.first.type_of_task
      # 複数登録できるように変更予定
      @task_form.working_process = @working_processes.first
    end
  end

  def back_to_index
    # 自分以外のユーザーが編集・削除しようとするとタスク一覧画面に遷移
     if current_user != @task.user
      redirect_to tasks_path
     end
  end
end
