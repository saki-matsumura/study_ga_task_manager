class WorkingProcess < ApplicationRecord
  belongs_to :type_of_task
  belongs_to :task

  enum unit: {
    day: 0,
    hour: 1
  }
end
