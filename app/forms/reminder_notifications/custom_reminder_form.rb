module ReminderNotifications
  class CustomReminderForm
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    CATEGORY_OPTIONS = [
      'Saúde',
      'Compras',
      'Higiene',
      'Bem-estar',
      'Consultas'
    ].freeze

    RECURRENCE_OPTIONS = {
      'Não repetir' => 'none',
      'Diariamente' => 'daily'
    }.freeze

    attr_reader :user

    attribute :title, :string
    attribute :pet_id, :integer
    attribute :category, :string
    attribute :scheduled_date, :date
    attribute :time, :string
    attribute :recurrence, :string, default: 'Não repetir'
    attribute :notes, :string

    validates :title, presence: { message: 'Informe um título para o lembrete' }
    validates :pet_id, presence: { message: 'Selecione um pet para vincular o lembrete' }
    validates :category, presence: { message: 'Selecione uma categoria' }
    validates :scheduled_date, presence: { message: 'Escolha uma data válida' }
    validates :time, presence: { message: 'Escolha um horário válido' }

    validate :validate_user_presence
    validate :validate_pet_belongs_to_user
    validate :validate_category_option
    validate :validate_scheduled_date
    validate :validate_time_option
    validate :validate_recurrence_option

    def initialize(user:, **attributes)
      @user = user
      super(attributes)
    end

    def submit(params)
      assign_attributes(params)
      valid?
    end

    def due_at(_reference_time = Time.zone.now)
      return if scheduled_date.blank?

      parse_time_option(scheduled_date)
    end

    def recurrence_key
      RECURRENCE_OPTIONS.fetch(recurrence, 'none')
    end

    def to_notification_attributes
      {
        user: user,
        pet_id: pet_id,
        title: title,
        description: notes,
        category: category,
        due_at: due_at,
        recurrence: recurrence_key
      }
    end

    private

    def validate_user_presence
      errors.add(:base, 'Usuário obrigatório') if user.blank?
    end

    def validate_pet_belongs_to_user
      return if user.blank? || pet_id.blank?

      return if user.pets.active.exists?(pet_id)

      errors.add(:pet_id, 'Selecione um pet válido')
    end

    def validate_category_option
      return if category.blank?
      return if CATEGORY_OPTIONS.include?(category)

      errors.add(:category, 'Categoria inválida')
    end

    def validate_scheduled_date
      if scheduled_date.blank?
        errors.add(:scheduled_date, 'Escolha uma data válida')
        return
      end

      if scheduled_date < Time.zone.today
        errors.add(:scheduled_date, 'Escolha uma data válida')
      end
    end

    def validate_time_option
      return if time.blank?

      parse_time(time)
    rescue ArgumentError
      errors.add(:time, 'Escolha um horário válido')
    end

    def validate_recurrence_option
      return if recurrence.blank?
      return if RECURRENCE_OPTIONS.key?(recurrence)

      errors.add(:recurrence, 'Repetição inválida')
    end

    def parse_time_option(date)
      parsed_time = parse_time(time)
      Time.zone.local(date.year, date.month, date.day, parsed_time.hour, parsed_time.min)
    rescue ArgumentError
      nil
    end

    def parse_time(value)
      parsed = Time.zone.parse(value.to_s)
      raise ArgumentError, 'invalid time' unless parsed

      parsed
    end

  end
end
