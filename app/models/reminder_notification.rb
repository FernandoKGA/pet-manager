class ReminderNotification < ApplicationRecord
  belongs_to :user
  belongs_to :pet

  enum status: { unread: 0, read: 1 }, _default: :unread

  validates :title, presence: true
  validates :category, presence: true
  validates :due_at, presence: true

  scope :ordered_by_due_at, -> { order(due_at: :asc, created_at: :asc) }

  def due_label(reference_time = Time.zone.now)
    reference_date = reference_time.to_date
    due_date = due_at.to_date
    days_diff = (due_date - reference_date).to_i

    case days_diff
    when 0
      'Hoje'
    when 1
      'Amanhã'
    when -1
      'Ontem'
    when 2..45
      "Em #{days_diff} #{pluralize_days(days_diff)}"
    when (-45)..-2
      "Há #{days_diff.abs} #{pluralize_days(days_diff.abs)}"
    else
      I18n.l(due_date, format: :short)
    end
  end

  def mark_as_read!
    return if read?

    update!(status: :read)
  end

  private

  def pluralize_days(count)
    count == 1 ? 'dia' : 'dias'
  end

end
