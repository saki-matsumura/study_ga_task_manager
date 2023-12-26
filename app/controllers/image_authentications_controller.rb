class ImageAuthenticationsController < ApplicationController

  def create
    # 文字読み取りメソッドへ
    file_path = params["task"]["image"].path
    words = image_annotator(file_path)

    # 抽出した文字列を適宜振り分ける
    # 各項目、作成したデータと類似したものがあればそれを設定する
    set_words(words)

    # タイトル、取引先、工程を自動入力する
    respond_to do |format|
      format.html
      format.json { render json: {
         task_title: @title_word,
         task_client: @client_word,
         task_type_of_task: @type_of_task_word
         }}
    end
  end

  private

  def set_words(words)
    @title_word = ""
    @client_word = ""
    @type_of_task_word = ""
    # 抽出した文字列の中に、過去登録したクライアント名や工程名があれば設定
    words.each do |word|
      if Task.find_by('title like ?', '%' + word + '%') &&  @title_word = ""
        @title_word = Task.find_by('title like ?', '%' + word + '%').title
      end

      if Client.find_by('name like ?', '%' + word + '%') &&  @client_word = ""
        @client_word = Client.find_by('name like ?', '%' + word + '%').name
      end

      if TypeOfTask.find_by('name like ?', '%' + word + '%') &&  @working_process_word = ""
        @type_of_task_word = TypeOfTask.find_by('name like ?', '%' + word + '%').name
      end
    end

    # 全て文字列が入力されていれば終了
    return if @client_word != "" && @type_of_task_word != ""
    like_clients = ["株", "会社"]
    like_type_of_tasks = ["上質紙", "A紙", "B紙", "地巻紙"]

    words.each do |word|
      if @client_word == ""
        like_clients.each do |like_client|
          @client_word = word if word.include?(like_client)
        end
      end
      if @type_of_task_word == ""
        like_type_of_tasks.each do |like_type_of_task|
          @type_of_task_word = word if word.include?(like_type_of_task)
        end
      end
    end
  end

  def image_annotator(file_path)
    # APIを利用して画像を文字列化する
    require "google/cloud/vision/v1"
    image_annotator = Google::Cloud::Vision::V1::ImageAnnotator::Client.new do |config|
      config.credentials = ENV["GOOGLE_CLOUD_KEYFILE"]
    end
    # 必要な文字のみ抽出する
    response = image_annotator.text_detection(image: file_path)
    words = []
    response.responses.each do |res|
      res.text_annotations.each do |text|
        words << text.description
      end
    end
    words = words.first.split("\n")
  end
end
