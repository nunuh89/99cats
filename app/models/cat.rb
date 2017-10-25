class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper

  COLORS = %w(white black gray orange brown)
  validates :color, inclusion: { in: COLORS,
    message: "%{value} is not a valid color" }, presence: true
  validates :sex, inclusion: { in: %w(M F),
    message: "%{value} is not a valid sex" }, presence: true
  validates :name, :birth_date, :description, presence: true

  has_many :cat_rental_requests
  
  def age
    Date.today.year - birth_date.year
    # time_ago_in_words(birth_date)
  end
end
