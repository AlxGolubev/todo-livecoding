class ListsController < ApplicationController
  # skip_before_action :verify_authenticity_token
  before_action :set_list, only: %i[ edit update destroy ]

  # GET /lists or /lists.json
  def index
    @lists = current_user.lists
    @shared_lists = current_user.shared_lists
  end

  # GET /lists/1 or /lists/1.json
  def show
    @list = current_user.lists.find_by(id: params[:id]) || current_user.shared_lists.find_by(id: params[:id])

    if @list.blank?
      raise ActiveRecord::RecordNotFound
    end

    @items = @list.items.order(completed: :asc)
  end

  # GET /lists/new
  def new
    @list = List.new
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists or /lists.json
  def create
    @list = current_user.lists.build(list_params) # => user_id: current_user.id

    respond_to do |format|
      if @list.save!
        format.html { redirect_to list_url(@list), notice: "List was successfully created." }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to list_url(@list), notice: "List was successfully updated." }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  def destroy
    @list.destroy

    respond_to do |format|
      format.html { redirect_to lists_url, notice: "List was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = current_user.lists.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.require(:list).permit(:title, :body, affiliated_user_ids: [])
    end
end
