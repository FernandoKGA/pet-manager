module NotificationCenterHelper
  def unread_pill_text(count)
    case count
    when 0
      '0 não lidas'
    when 1
      '1 não lida'
    else
      "#{count} lembretes pendentes"
    end
  end

  def notification_due_badge_class(record)
    base_classes = 'badge'
    return "#{base_classes} text-bg-info" unless record.respond_to?(:due_at) && record.due_at.present?

    record.due_at.to_date < Time.zone.today ? "#{base_classes} text-bg-danger" : "#{base_classes} text-bg-info"
  end
end
