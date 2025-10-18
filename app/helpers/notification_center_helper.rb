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
end
