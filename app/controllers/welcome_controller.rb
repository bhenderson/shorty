class WelcomeController < ApplicationController
  def index
    if code = params[:code]
      @shorty = ShortCode.find_by(code: code)
    end
  end
end
