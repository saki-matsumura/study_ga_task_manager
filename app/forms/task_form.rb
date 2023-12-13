class TaskForm
  include ActiveModel::Model # 通常のモデルのようにvalidationなどを使えるようにする
  include ActiveModel::Attributes # ActiveRecordのカラムのような属性を加えられるようにする

  attribute :title, :string
  attribute :note, :string # 元text
  attribute :deadline_on, :date
  attribute :done, :boolean, default: false
  attribute :client_id, :integer
  attr_accessor  :task, 
    :client, 
    :clients,
    :type_of_task,
    :type_of_tasks,
    :working_process

  validates :title, presence: true
  validates :note, length: { maximum: 140 }

  def initialize(user, params = {})

    @user = user
    @task = Task.new
    @client = Client.new
    @type_of_task = TypeOfTask.new
    @working_process = WorkingProcess.new

    set_params(params) if params != {}
  end

  def set_params(params)
    # パラメータをモデルごとに切り分け
      @client_params = params.delete("clients") #paramsからclient関係だけ抜き出す
      @type_of_task_params = params.delete("type_of_tasks")
      @working_process_params = params.delete("working_process")
      @task_params = params

      # paramsの値を設定
      @task_params.each do |key, value|
        @task[key] = value
      end
      @client.name = @client_params[:name] if @client_params[:name]
      @type_of_task.name = @type_of_task_params[:name] if @type_of_task_params[:name]
      @working_process_params.each do |key, value|
        @working_process[key] = value
      end
  end

  # クライアント名が存在するか確認
  def client_incrude?(name)
    if Client.where('name = ?', name).count.zero?
      @client.save
      @task.client_id = @client.id
    else
      @task.client_id = Client.where('name = ?', name).pluck(:id).first
    end
  end

  # 工程名が存在するか確認
  def type_of_task_incrude?(name)
    if TypeOfTask.where('name = ?', name).count.zero?
      @type_of_task.save
      @working_process.type_of_task_id = @type_of_task.id
      @working_process_params["type_of_task_id"] = @type_of_task.id
    else
      @working_process.type_of_task_id = TypeOfTask.where('name = ?', name).pluck(:id).first
      @working_process_params["type_of_task_id"] = TypeOfTask.where('name = ?', name).pluck(:id).first
    end
  end

  def save

    client_incrude?(@client.name)  # クライアント名が存在するか確認
    type_of_task_incrude?(@type_of_task.name)  # 工程名が存在するか確認
    
    @task.user_id = @user.id
    @task.save

    @working_process.task_id = @task.id
    @working_process.save

  end

  def update(user, params = {})
    @user = user
    set_params(params)

    client_incrude?(@client.name)  # クライアント名が存在するか確認
    type_of_task_incrude?(@type_of_task.name)  # 工程名が存在するか確認
    
    @task.user_id = @user.id
    @task.update(@task_params)
    @client.update(@client_params)
    @working_process_params["task_id"] = @task.id
    @working_process.update(@working_process_params)
  end

end