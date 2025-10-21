module ReminderNotifications
  class Result
    attr_reader :toast, :updated_count

    def initialize(success:, toast:, updated_count: nil)
      @success = success
      @toast = toast
      @updated_count = updated_count
    end

    def success?
      @success
    end

    alias success success?
  end
end
