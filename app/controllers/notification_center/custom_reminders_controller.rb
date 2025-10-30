module NotificationCenter
  class CustomRemindersController < ApplicationController
    include NotificationCenterContext

    before_action :authenticate_user

    def new
      redirect_to user_path(current_user, notifications: 'open', reminder_modal: 'new')
    end

    def create
      @custom_reminder_form = ReminderNotifications::CustomReminderForm.new(user: current_user)

      if @custom_reminder_form.submit(custom_reminder_params)
        result = ReminderNotifications::CreateCustomReminder.new(form: @custom_reminder_form).call
        redirect_to user_path(current_user, notifications: 'open'),
                    notice: result.toast
      else
        render_invalid_form
      end
    end

    private

    def authenticate_user
      return if logged_in?

      redirect_to login_path, alert: 'Faça login para cadastrar lembretes personalizados'
    end

    def render_invalid_form
      @user = current_user
      @pets = @user.pets
      prepare_notification_center_context(
        user: @user,
        panel_open: true,
        custom_reminder_form: @custom_reminder_form
      )

      flash.now[:alert] = 'Não foi possível salvar o lembrete. Verifique os campos destacados.'
      render 'users/show', status: :unprocessable_entity
    end

    def custom_reminder_params
      params
        .require(:reminder_notifications_custom_reminder_form)
        .permit(:title, :pet_id, :category, :scheduled_date, :time, :recurrence, :notes)
    end
  end
end
