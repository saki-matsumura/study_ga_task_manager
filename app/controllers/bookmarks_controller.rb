class BookmarksController < ApplicationController
  def create
    bookmark = current_user.bookmarks.create(task_id: params[:task_id])
    redirect_to redirect_path, notice: "#{bookmark.task.title}をブックマークしました"
  end

  def destroy
    bookmark = current_user.bookmarks.find_by(id: params[:id]).destroy
    redirect_to redirect_path, notice: "#{bookmark.task.title}のブックマークを解除しました"
  end

  private

  def redirect_path
    before_uri = URI.parse(request.referer)
    path = Rails.application.routes.recognize_path(before_uri.path)
    path
  end

end
