class TaskForm
  include ActiveModel::Model # 通常のモデルのようにvalidationなどを使えるようにする
  include ActiveModel::Attributes # ActiveRecordのカラムのような属性を加えられるようにする

  attribute :title, :string
  attribute :note, :string # 元text
  attribute :deadline_on, :date
  attribute :done, :boolean, default: false
  attribute :client_id, :integer
  attr_accessor :task, :client, :clients

  validates :title, presence: true
  validates :note, length: { maximum: 140 }

  def initialize(user, task, client, params = {})
    @task = task
    @user = user
    @client = client
    if params != {}
      client_params = params.delete("clients") #paramsからclient関係だけ抜き出す
      task_params = params
      task_params.each do |key, value|
        @task[key] = value
      end
      @client.name = client_params[:name] if client_params[:name]
    end
  end

  # クライアント名が存在するか確認
  def client_incrude?(name)
    return false if Client.where('name = ?', name).count.zero?
    Client.where('name = ?', name).pluck(:id).first
  end

  def save
    # binding.pry
    # return false unless valid? # バリデーション実行

    # クライアント名が存在するか確認
    if @task.client_id = client_incrude?(@client.name)
    else
      @client.save
      @task.client_id = @client.id
    end

    @task.user_id = @user.id
    @task.save

  end
end