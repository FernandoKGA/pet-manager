class DiaryEntry < ApplicationRecord
  belongs_to :pet

  validates :content, presence: true
  validates :entry_date, presence: true
end
