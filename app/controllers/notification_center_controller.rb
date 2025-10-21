class NotificationCenterController < ApplicationController
  def index
    redirect_to user_path(current_user, notifications: 'open', anchor: 'notification-center-card')
  end

  def show
    notification = find_notification(params[:id])

    ReminderNotifications::MarkAsRead.new(notification:, actor: current_user).call if notification.unread?

    redirect_to user_path(
      current_user,
      notifications: 'open',
      selected_notification_id: notification.id,
      anchor: 'notification-center-card'
    )
  rescue ActiveRecord::RecordNotFound
    redirect_to user_path(current_user, notifications: 'open', anchor: 'notification-center-card'),
                alert: 'Lembrete não encontrado.'
  end

  def mark_as_read
    notification = find_notification(params[:id])
    result = ReminderNotifications::MarkAsRead.new(notification:, actor: current_user).call

    redirect_to user_path(current_user, notifications: 'open', anchor: 'notification-center-card'),
                notice: result.toast
  rescue ReminderNotifications::AuthorizationError
    redirect_to user_path(current_user, notifications: 'open', anchor: 'notification-center-card'),
                alert: 'Você não tem acesso a este lembrete.'
  end

  def mark_all_as_read
    result = ReminderNotifications::MarkAllAsRead.new(user: current_user).call
    message = result.updated_count.positive? ? result.toast : 'Nenhum lembrete precisava ser atualizado.'

    redirect_to user_path(current_user, notifications: 'open', anchor: 'notification-center-card'),
                notice: message
  end

  private

  def authenticate_user
    return if logged_in?

    redirect_to login_path, alert: 'Faça login para acessar a central de notificações'
  end

  def find_notification(id)
    current_user.reminder_notifications.find(id)
  end
end
