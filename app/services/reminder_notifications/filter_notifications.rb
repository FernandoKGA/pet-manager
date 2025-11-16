module ReminderNotifications
  class FilterNotifications
    def initialize(user:, scope: nil)
      @user = user
      @scope = scope || user.reminder_notifications
    end

    def call(status: nil, category: nil, due_from: nil, due_to: nil)
      relation = scope.where(user: user)
      relation = apply_status_filter(relation, status)
      relation = apply_category_filter(relation, category)
      relation = apply_due_date_filter(relation, due_from, due_to)
      relation.ordered_by_due_at
    end

    private

    attr_reader :user, :scope

    def apply_status_filter(relation, status)
      return relation if status.blank?

      mapped_status = normalize_status(status)
      return relation if mapped_status.nil?

      relation.where(status: mapped_status)
    end

    def apply_category_filter(relation, category)
      return relation if category.blank?

      relation.where(category:)
    end

    def apply_due_date_filter(relation, from, to)
      from_time = from&.beginning_of_day
      to_time = to&.end_of_day

      return relation unless from_time || to_time

      if from_time && to_time
        relation.where(due_at: from_time..to_time)
      elsif from_time
        relation.where('due_at >= ?', from_time)
      else
        relation.where('due_at <= ?', to_time)
      end
    end

    def normalize_status(status)
      case status.to_s
      when 'unread', 'Não lidas', 'não lidas'
        :unread
      when 'read', 'Lidas', 'lidas'
        :read
      else
        nil
      end
    end
  end
end
