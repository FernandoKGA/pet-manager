module ReminderNotifications
  class CreateCustomReminder
    attr_reader :notification

    def initialize(form:, notification_class: ReminderNotification)
      @form = form
      @notification_class = notification_class
    end

    def call
      attributes = normalized_attributes(form.to_notification_attributes)
      @notification = notification_class.create!(attributes)

      Result.new(success: true, toast: toast_message)
    end

    private

    attr_reader :form, :notification_class

    def normalized_attributes(attributes)
      attributes.merge(
        description: attributes[:description].presence,
        recurrence: attributes[:recurrence] || form.recurrence_key
      )
    end

    def toast_message
      case form.recurrence_key
      when 'daily'
        scheduled_hour = form.due_at.in_time_zone.strftime('%Hh')
        "Vamos te lembrar todos os dias às #{scheduled_hour}. 💊"
      else
        'Lembrete cadastrado com sucesso! 🎯'
      end
    end
  end
end
