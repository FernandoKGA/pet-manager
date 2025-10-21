module ReminderNotifications
  class MarkAllAsRead
    def initialize(user:)
      @user = user
    end

    def call
      updated = ReminderNotification
        .where(user: user, status: ReminderNotification.statuses[:unread])
        .update_all(status: ReminderNotification.statuses[:read], updated_at: Time.current)

      Result.new(
        success: true,
        toast: 'Tudo certo! Você está em dia com os lembretes.',
        updated_count: updated
      )
    end

    private

    attr_reader :user
  end
end
