module NotificationCenterContext
  extend ActiveSupport::Concern

  private

  def prepare_notification_center_context(user:, panel_open: nil, custom_reminder_form: nil)
    filters = extract_notification_filters
    filter_service = ReminderNotifications::FilterNotifications.new(user:)

    @notifications = filter_service.call(**filters.slice(:status, :category, :due_from, :due_to)).includes(:pet)
    @unread_count = user.reminder_notifications.unread.count

    default_panel_state = params[:notifications] == 'open' || params[:selected_notification_id].present?
    @notifications_panel_open = panel_open.nil? ? default_panel_state : panel_open

    selected_id = params[:selected_notification_id]&.to_i
    @selected_notification = @notifications.find { |item| item.id == selected_id } if selected_id

    @custom_reminder_form = custom_reminder_form
    @show_custom_reminder_modal = false

    if @custom_reminder_form.present?
      @show_custom_reminder_modal = true
    elsif params[:reminder_modal] == 'new'
      @custom_reminder_form = ReminderNotifications::CustomReminderForm.new(user:)
      @show_custom_reminder_modal = true
    end

    @active_filter_tags = build_active_filter_tags(filters)
    @active_filter_summary = build_active_filter_summary(@active_filter_tags)
    @filter_selections = filters
  end

  def extract_notification_filters
    {
      status: normalize_status_filter(params[:status_filter]),
      category: params[:category_filter].presence,
      due_from: parse_filter_date(params[:due_from]),
      due_to: parse_filter_date(params[:due_to])
    }
  end

  def normalize_status_filter(value)
    case value.to_s
    when 'unread', 'Não lidas', 'não lidas'
      'unread'
    when 'read', 'Lidas', 'lidas'
      'read'
    else
      nil
    end
  end

  def parse_filter_date(value)
    return nil if value.blank?

    today = Time.zone.today

    case value
    when /\AHoje\z/i
      today
    when /\AAmanhã\z/i
      today + 1.day
    when /\AOntem\z/i
      today - 1.day
    when /\AEm (\d+) dias?\z/i
      today + Regexp.last_match(1).to_i.days
    when /\AEm (\d+) semanas?\z/i
      today + (Regexp.last_match(1).to_i * 7).days
    else
      Date.parse(value)
    end
  rescue ArgumentError
    nil
  end

  def build_active_filter_tags(filters)
    tags = []

    status_label = status_tag_label(filters[:status])
    category_label = filters[:category].presence
    period_label = period_tag_label(filters[:due_from], filters[:due_to])

    tags << "Status: #{status_label}" if status_label
    tags << "Categoria: #{category_label}" if category_label
    tags << "Período: #{period_label}" if period_label

    tags
  end

  def build_active_filter_summary(tags)
    return nil if tags.empty?

    tags.join(' • ')
  end

  def status_tag_label(status)
    case status
    when 'unread'
      'Não lidas'
    when 'read'
      'Lidas'
    else
      nil
    end
  end

  def period_tag_label(from, to)
    return nil unless from || to

    from_label = date_label(from) || 'Qualquer data'
    to_label = date_label(to) || 'Sem limite'

    "#{from_label} até #{to_label}"
  end

  def date_label(date)
    return nil unless date

    today = Time.zone.today
    diff = (date - today).to_i

    case diff
    when 0
      'Hoje'
    when 1
      'Amanhã'
    when -1
      'Ontem'
    when 2..45
      "Em #{diff} #{diff == 1 ? 'dia' : 'dias'}"
    when (-45)..-2
      "Há #{diff.abs} #{diff.abs == 1 ? 'dia' : 'dias'}"
    else
      I18n.l(date, format: :short)
    end
  end
end
