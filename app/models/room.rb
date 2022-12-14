class Room < ApplicationRecord

  belongs_to :user
  has_many :bookings
  has_many :guests, through: :bookings, source: :users
  
  has_many_attached :avatars
  has_many_attached :photos

  validates :home_type, :room_type, :max_occupancy, :bedrooms, :bathrooms, :summary, :address, :price, :checkin_start_at, :checkin_end_at, :checkout_time, presence: true

  enum home_type: [:boutique_hotel, :hotel, :bed_and_breakfast, :aparthotel, :hostel, :minsu , :nature_lodge, :resort, :ryokan]

  enum room_type: [:entire_place, :private_rooms, :hotel_rooms, :shared_rooms]

  scope :not_deleted, -> { where(deleted_at: nil) }
end