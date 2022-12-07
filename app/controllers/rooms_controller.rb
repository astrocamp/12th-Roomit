class RoomsController < ApplicationController
  before_action :find_rooms, only: [:edit, :update, :destroy, :show]

  def index
    @rooms = Room.not_deleted
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to rooms_path ,notice: '新增成功'
    else
      flash.alert = '新增失敗'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to rooms_path, notice: '更新成功'
    else
      flash.alert = '更新失敗'
      render :new
    end
  end

  def destroy
    @room.update(deleted_at: Time.current)
    redirect_to rooms_path, notice: '已刪除'
  end

  private

  def find_rooms
    @room = Room.not_deleted.find_by!(id: params[:id])
  end

  def room_params
    params.require(:room).permit(:home_type, :room_type, :max_occupancy, :bedrooms, :bathrooms, :has_bathtub, :has_kitchen, :has_air_con, :has_wifi, :summary, :address, :price, :checkin_start_at, :checkin_end_at, :checkout_time)
  end

end
