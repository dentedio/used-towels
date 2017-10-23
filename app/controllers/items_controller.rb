class ItemsController < ApplicationController
  before_action :set_item, only: [:show]

  def index
    @items = Item.all
    if search_params.present?
      @items = @items.search(search_params[:q])
    end
    @items = @items.ordering(:created_at, :desc).page(params[:page])
  end

  def show
  end

  def fetch
    # After Adding Sidekiq
    # AsiaxpatJob.perform_later
    # GeoexpatJob.perform_later

    # AsiaxpatJob.perform_now
    GeoexpatJob.perform_now
    redirect_to action: :index
  end

  private

  def set_item
    @item = Item.find_by(id: params[:id])
  end

  def search_params
    params.permit(:q)
  end

end
