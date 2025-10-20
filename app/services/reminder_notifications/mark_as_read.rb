module ReminderNotifications
  class MarkAsRead
    def initialize(notification:, actor:)
      @notification = notification
      @actor = actor
    end

    def call
      authorize!

      notification.mark_as_read!

      Result.new(
        success: true,
        toast: toast_message,
        updated_count: 1
      )
    end

    private

    attr_reader :notification, :actor

    def authorize!
      return if notification.user_id == actor.id

      raise AuthorizationError, 'Você não tem acesso a este lembrete.'
    end

    def toast_message
      "#{notification.pet.name} está em dia! ✅"
    end
  end
end
