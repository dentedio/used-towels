require 'nokogiri'
require 'open-uri'

class ItemsController < ApplicationController
  before_action :set_item, only: [:show]

  def index
    @items = Item.all.page(params[:page])
  end

  def show
  end

  def fetch
    # AsiaxpatJob.perform_now
    GeoexpatJob.perform_now
    render nothing: true
  end

  private

    def set_item
      @item = Item.find(params[:id])
    end

    def search_params
      params.permit(:q)
    end
end
