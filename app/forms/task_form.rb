class TaskForm
  include ActiveModel::Model # 通常のモデルのようにvalidationなどを使えるようにする
  include ActiveModel::Attributes # ActiveRecordのカラムのような属性を加えられるようにする
  extend CarrierWave::Mount

  mount_uploader :image, ImageUploader

  attr_accessor  :task, 
    :client, 
    :clients,
    :type_of_task,
    :type_of_tasks,
    :working_process,
    :image
  
  attribute :task_title, :string
  attribute :task_note, :string # 元text
  attribute :task_deadline_on, :date
  attribute :task_done, :boolean, default: false
  attribute :task_image, :string
  attribute :task_image_cache, :string
  attribute :task_client_id, :integer
  
  attribute :clients_name, :string

  # validates :task_title, presence: true
  # validates :task_note, length: { maximum: 140 }
  # validates :clients_name, presence: true
  # validates :type_of_tasks_name, presence: true

  def initialize(user, params = {})
    @user = user
    @task = Task.new
    # binding.pry
    @client = Client.new
    @type_of_task = TypeOfTask.new
    @working_process = WorkingProcess.new

    @task[:user_id] = @user.id
    
    set_params(params) if params != {}
    # binding.pry
  end

  def set_params(params)
    # パラメータをモデルごとに切り分け 
    # binding.pry
    params_copy = params
    @client_params = params_copy.dig("clients") #paramsからclient関係だけ抜き出す
    @type_of_task_params = params_copy.dig("type_of_tasks")
    @working_process_params = params_copy.dig("working_process")
    
    # 不要なパラメータ削除
    params_copy.delete("clients")
    params_copy.delete("type_of_tasks")
    params_copy.delete("working_process")

    # 残ったパラメータをタスクパラメータに設定
    @task_params = params_copy

    # 各インスタンスにパラメータを設定
    @client = Client.new unless @client
    @client.assign_attributes(@client_params)
    @type_of_task.assign_attributes(@type_of_task_params)
    @working_process.assign_attributes(@working_process_params)
    @task.assign_attributes(@task_params)
  end

  # クライアント名が存在するか確認
  def client_incrude?(name)
    return false if name == ""
    if Client.where('name = ?', name).count.zero?
      @client.save
      @task.client_id = @client.id
    else
      @task.client_id = Client.where('name = ?', name).pluck(:id).first
    end
  end

  # 工程名が存在するか確認
  def type_of_task_incrude?(name)
    return false if name == ""
    if TypeOfTask.where('name = ?', name).count.zero?
      # 工程名が存在しない場合、新規作成
      @type_of_task.save
      @working_process.type_of_task_id = @type_of_task.id
      @working_process_params["type_of_task_id"] = @type_of_task.id
    else
      @working_process.type_of_task_id = TypeOfTask.where('name = ?', name).pluck(:id).first
      @working_process_params["type_of_task_id"] = TypeOfTask.where('name = ?', name).pluck(:id).first
    end
  end

  def save
    client_incrude?(@client_params[:name])  # クライアント名が存在するか確認
    type_of_task_incrude?(@type_of_task_params[:name]) # 工程名が存在するか確認
    @task.save

    if @working_process.type_of_task 
      @working_process.task_id = @task.id
      @working_process.save
    end
    @task.valid?
  end

  def update(user, params = {})
    @user = user
    set_params(params)

    if @client.name
      client_incrude?(@client.name)  # クライアント名が存在するか確認
      @client.update(@client_params) 
      @task.client_id = nil if @client.name == ""
    end

    if @type_of_task
      type_of_task_incrude?(@type_of_task.name)  # 工程名が存在するか確認
    end

    @task.update(@task_params)
    
    if @working_process
      @working_process_params["task_id"] = @task.id
      @working_process.update(@working_process_params)
      # 工程名が空欄であれば、削除する
      # binding.pry
      # @working_process.destroy if @working_process.type_of_task.name == "" && @working_process.type_of_task.name != nil
    end
    @task.valid?
  end
end