class InstructionsController < ApplicationController
  skip_before_action :login_required, only: [:index]
  def index
    @title_off = true
  end
end
