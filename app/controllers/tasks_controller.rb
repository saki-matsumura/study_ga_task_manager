class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy] 
  before_action :back_to_index, only: [:edit, :update, :destroy]

  def index
    @tasks = Task.all.default

    if params[:bookmarks]
      bookmarks = Bookmark.where(user_id: current_user.id).pluck(:task_id)
      @tasks = Task.find(bookmarks)
    end
  end

  def calendar
     @tasks = Task.all
  end

  def bookmark
    bookmarks = Bookmark.where(user_id: current_user.id).pluck(:task_id)
    @tasks = Task.find(bookmarks)
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
    if @task_form.save
      # msg：タスクを作成しました
      redirect_to task_path(@task_form.task), notice: t('notice.task_create')
    else
      render :new
    end
  end

  def show
    @working_processes = WorkingProcess.where('task_id = ?', @task.id)
    @bookmark = current_user.bookmarks.find_by(task_id: @task.id)
    # binding.pry
  end

  def edit
    @task_form = TaskForm.new(current_user)
    task_form_params
  end

  def update
    set_task_form
    task_form_params
    if @task_form.update(current_user, task_params)
      # msg：タスクを更新しました
      redirect_to task_path(@task), notice: t('notice.task_update')
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
    # msg：タスクを削除しました
    redirect_to tasks_path, notice: t('danger.task_delete')
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
