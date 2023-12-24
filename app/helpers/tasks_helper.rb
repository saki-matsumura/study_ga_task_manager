module TasksHelper
  def choose_new_or_edit
    if action_name == "create"
      tasks_path
    elsif action_name == "edit"
      task_path
    end
  end

  def redirect
    before_uri = URI.parse(request.referer)
    path = Rails.application.routes.recognize_path(before_uri.path)
    # もし直前のアクションがindex、bookmark、calendarだったら
    # 各アクションへのパスを指定。それ以外の場合はカレンダーへ戻る
    valid_actions = ["index", "bookmark", "calendar"]
    return path if valid_actions.include?(path[:action])
    calendar_tasks_path
  end
end
