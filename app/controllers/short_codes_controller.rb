class ShortCodesController < ApplicationController
  def create
    @shorty = ShortCode.new(short_code_params)

    if @shorty.save
      flash.notice = "Congradulations! You've shortened a url!"

      redirect_to root_url(code: @shorty.code)
    else
      flash.alert = @shorty.errors.full_messages
      flash[:url] = @shorty.url

      redirect_to root_url
    end
  end

  def show
    code = params[:code]
    @shorty = ShortCode.lookup(code, request)

    respond_to do |format|
      format.html {
        if @shorty
          redirect_to @shorty.url
        else
          flash.alert = [
            "#{code} was not found",
            "feel free to create a new one!",
          ]
          redirect_to root_url
        end
      }
      format.json { render json: @shorty }
    end
  end

  private

  def short_code_params
    params.require(:short_code).permit(:url)
  end

  def redirect_params
    params.permit(:code)
  end
end
