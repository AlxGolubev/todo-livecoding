class ItemsController < ApplicationController
  before_action :set_list

  def new
    @item = @list.items.new
  end

  def create
    @item = @list.items.build(item_params)

    if @item.save
      redirect_to list_path(@list)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @item = @list.items.find(params[:id])
    @item.completed = !@item.completed

    @item.save

    redirect_to list_path(@list)
  end

  def destroy
    @list.items.find(params[:id]).destroy

    redirect_to list_path(@list)
  end

  private

  def set_list
    @list ||= List.find(params[:list_id])
  end

  def item_params
    params.require(:item).permit(:title)
  end
end
