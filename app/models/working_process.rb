class WorkingProcess < ApplicationRecord
  belongs_to :type_of_task
  has_many :tasks
end
