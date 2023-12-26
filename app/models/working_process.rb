class WorkingProcess < ApplicationRecord
  belongs_to :type_of_task
  belongs_to :task

  enum unit: {
    day: 0,
    hour: 1
  }

  private

  def check_and_save
    return false unless type_of_task_id_blank?
  end

  def type_of_task_id_blank?
    !self.type_of_task_id.blank?
  end
end
