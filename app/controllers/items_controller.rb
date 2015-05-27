class ItemsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    Item.create permit_params

    respond_to do |format|
      @items = Item.all
      format.js { render action: "show"}
    end
  end

  def update
    item = Item.find(params["id"])
    item.update_attributes permit_params

    respond_to do |format|  
      @items = Item.all
      format.js { render action: "show"}
    end
  end

  def destroy
    Item.destroy(params["id"])

    respond_to do |format|
      @items = Item.all
      format.js { render action: "show"}
    end
  end

  private

  def permit_params
    params.require(:item).permit :x, :y, :keywords
  end
end