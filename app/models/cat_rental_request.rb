class CatRentalRequest < ApplicationRecord
  STATUSES = %w(PENDING APPROVED DENIED)
  attribute :status, :string, default: 'PENDING'
  validates :status, inclusion: { in: STATUSES,
    message: "%{value} is not a valid status" }, presence: true
  validates :cat_id, :start_date, :end_date, presence: true

  belongs_to :cat,
  dependent: :destroy

  def overlapping_requests
    self.class
      .select("*")
      .where("( start_date <= ? AND ? <= end_date )
      OR (start_date <= ? AND ? <= end_date )
      OR (start_date >= ? AND ? >= end_date )",
        self.start_date, self.start_date, self.end_date, self.end_date, self.start_date, self.end_date)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

  def does_not_overlap_approved_request
    !overlapping_approved_requests.exists?
  end

  def approve!
    if self.status != 'PENDING'
      self.errors[:base] << "status is not PENDING"
      return false
    end
    self.class.transaction do
      self.update_column(:status, 'APPROVED')
      overlapping_requests.each do |request|
        request.deny!
      end
    end
  end

  def deny!
    if self.status != 'PENDING'
      self.errors[:base] << "status is not PENDING"
      return false
    end
    self.update_column(:status, 'DENIED')
  end
end
