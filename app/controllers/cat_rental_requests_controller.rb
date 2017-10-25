class CatRentalRequestsController < ApplicationController
  def new
    @request = CatRentalRequest.new
    render :new
  end

  def create
    @request = CatRentalRequest.new(request_params)
    if !@request.does_not_overlap_approved_request
      @request.errors[:base] << "Overlaps approved request"
      render plain: @request.errors.full_messages
    elsif @request.save
      redirect_to cat_url(@request.cat)
    else
      render plain: @request.errors.full_messages
      # render :new
    end
  end

  def approve
    @request = CatRentalRequest.find(params[:id])
    if @request.approve!
      redirect_to cat_url(@request.cat)
    else
      render plain: @request.errors.full_messages
    end
  end

  def deny
    @request = CatRentalRequest.find(params[:id])
    if @request.deny!
      redirect_to cat_url(@request.cat)
    else
      render plain: @request.errors.full_messages
    end
  end

  private

  def request_params
    params.require(:request).permit(:cat_id, :start_date, :end_date, :status)
  end
end
