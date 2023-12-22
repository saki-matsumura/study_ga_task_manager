class BookmarksController < ApplicationController
  def create
    bookmark = current_user.bookmarks.create(task_id: params[:task_id])
    redirect_to tasks_path, notice: "#{bookmark.task.title}をブックマークしました"
  end

  def destroy
    bookmark = current_user.bookmarks.find_by(id: params[:id]).destroy
    redirect_to tasks_path, notice: "#{bookmark.task.title}のブックマークを解除しました"
  end

  private

end
