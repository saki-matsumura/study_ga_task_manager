class ImageAuthenticationsController < ApplicationController

  def create
    require "google/cloud/vision/v1"
    image_annotator = Google::Cloud::Vision::V1::ImageAnnotator::Client.new do |config|
      config.credentials = ENV["GOOGLE_CLOUD_KEYFILE"]
    end
    file_path = params["task"]["image"].path

    response = image_annotator.text_detection(image: file_path).to_s

    @note = response.to_s
    @data = { note: @note }
    
    respond_to do |format|
      format.html
      format.json { render json: { task_note: @note }}
    end
  end
  private
end
