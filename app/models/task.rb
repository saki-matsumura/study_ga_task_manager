class Task < ApplicationRecord
  belongs_to :client
  belongs_to :working_process
  belongs_to :user
end
