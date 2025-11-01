module NotificationCenterSteps
  def notifications_store
    @notifications_store ||= {}
  end

  def ensure_current_user!
    raise 'current_user missing, use "Given I am logged in"' unless @current_user.present?
  end

  def build_pet_for(name)
    @current_user.pets.find_or_create_by!(name: name) do |pet|
      pet.species = 'Cachorro'
      pet.breed = 'SRD'
      pet.gender = 'Fêmea'
      pet.birthdate = 3.years.ago.to_date
      pet.size = 1
    end
  end

  def parse_due_at(value)
    today = Time.zone.today

    case value
    when nil, ''
      Time.zone.now.end_of_day
    when /\AHoje\z/i
      today.end_of_day
    when /\AEm (\d+) dias?\z/i
      (today + Regexp.last_match(1).to_i.days).end_of_day
    when /\AEm (\d+) semanas?\z/i
      (today + (Regexp.last_match(1).to_i * 7).days).end_of_day
    when /\AAmanhã\z/i
      (today + 1.day).end_of_day
    when /\AOntem\z/i
      (today - 1.day).end_of_day
    else
      Time.zone.parse(value).end_of_day
    end
  rescue ArgumentError
    today.end_of_day
  end

  def remember_notification!(record)
    notifications_store[record.title] = record
  end

  def find_notification!(title)
    notifications_store[title] || ReminderNotification.find_by!(title: title, user: @current_user)
  end

  def unread_counter_text
    find('[data-testid="unread-counter"]').text.strip
  end

  def unread_counter_value
    unread_counter_text[/\d+/].to_i
  end
end

World(NotificationCenterSteps)

Given('the following reminder notifications exist for me:') do |table|
  ensure_current_user!

  table.hashes.each do |row|
    pet = build_pet_for(row.fetch('pet'))

    notification = ReminderNotification.create!(
      user: @current_user,
      pet: pet,
      title: row.fetch('título'),
      description: row['descrição'],
      category: row.fetch('categoria'),
      status: row.fetch('status'),
      due_at: parse_due_at(row.fetch('vence_em'))
    )

    remember_notification!(notification)
  end
end

Given('I have a reminder notification titled {string} marked as unread') do |title|
  ensure_current_user!
  pet = build_pet_for('Thor')

  notification = ReminderNotification.create!(
    user: @current_user,
    pet: pet,
    title: title,
    description: 'Descrição padrão do lembrete',
    category: 'Saúde',
    status: :unread,
    due_at: Time.zone.now.end_of_day
  )

  remember_notification!(notification)
end

Given('I have a reminder notification titled {string} marked as read') do |title|
  ensure_current_user!
  pet = build_pet_for('Mel')

  notification = ReminderNotification.create!(
    user: @current_user,
    pet: pet,
    title: title,
    description: 'Descrição padrão do lembrete',
    category: 'Higiene',
    status: :read,
    due_at: Time.zone.now.end_of_day
  )

  remember_notification!(notification)
end

Given('I have an unread reminder notification titled {string} with description {string}') do |title, description|
  ensure_current_user!
  pet = build_pet_for('Lira')

  notification = ReminderNotification.create!(
    user: @current_user,
    pet: pet,
    title: title,
    description: description,
    category: 'Saúde',
    status: :unread,
    due_at: Time.zone.now.end_of_day
  )

  remember_notification!(notification)
end

Given('I have an unread reminder notification titled {string}') do |title|
  step %(I have a reminder notification titled "#{title}" marked as unread)
end

Given('I have multiple unread notifications') do
  ensure_current_user!

  [
    { title: 'Consulta do Thor', pet: 'Thor', category: 'Veterinário' },
    { title: 'Banho da Mel', pet: 'Mel', category: 'Higiene' },
    { title: 'Vacina da Lira', pet: 'Lira', category: 'Saúde' }
  ].each_with_index do |attrs, index|
    pet = build_pet_for(attrs[:pet])
    notification = ReminderNotification.create!(
      user: @current_user,
      pet: pet,
      title: attrs[:title],
      description: 'Lembrete automático',
      category: attrs[:category],
      status: :unread,
      due_at: (Time.zone.today + index.days).end_of_day
    )

    remember_notification!(notification)
  end
end

Given('I have no notifications') do
  ensure_current_user!
  @current_user.reminder_notifications.destroy_all
  notifications_store.clear
end

When('I open the notification center from the dashboard') do
  ensure_current_user!
  visit user_path(@current_user, notifications: 'open')
  @previous_unread_count = unread_counter_value
end

When('I click the {string} action for the notification {string}') do |action, title|
  card = find(%(div[data-testid="notification-card"][data-title="#{title}"]))

  case action
  when 'Ver detalhes'
    card.find('a', text: action).click
  when 'Marcar como lida'
    card.find('form').click_button(action)
  else
    raise "Unsupported action: #{action}"
  end
end

When('I click the toolbar button {string}') do |label|
  within('[data-testid="notification-panel"]') do
    click_button label
  end
end

When('I try to access the notification center directly') do
  visit '/notification_center'
end

Then('I should see the page heading {string}') do |expected|
  expect(find('[data-testid="notification-heading"]')).to have_text(expected)
end

Then('I should see the subtitle {string}') do |expected|
  expect(find('[data-testid="notification-subtitle"]')).to have_text(expected)
end

Then('I should see the unread counter pill with text {string}') do |expected|
  expect(unread_counter_text).to eq(expected)
end

Then('I should see the notification cards in this order:') do |table|
  expected_titles = table.raw.flatten
  actual_titles = all('[data-testid="notification-card"]').map { |node| node[:'data-title'] }

  expect(actual_titles).to eq(expected_titles)
end

Then('the notification card {string} should display the badge {string}') do |title, badge_text|
  card = find(%(div[data-testid="notification-card"][data-title="#{title}"]))
  if badge_text == 'Nova'
    expect(card.find('[data-testid="new-badge"]')).to have_text(badge_text)
  else
    expect(card.find('[data-testid="due-badge"]')).to have_text(badge_text)
  end
end

Then('each notification card should show the pet name and the category pill') do
  all('[data-testid="notification-card"]').each do |card|
    title = card[:'data-title']
    record = find_notification!(title)

    expect(card.find('.fw-semibold')).to have_text(record.pet.name)
    expect(card.find('[data-testid="category-pill"]')).to have_text(record.category)
  end
end

Then('the notification card {string} should not display the badge {string}') do |title, badge_text|
  card = find(%(div[data-testid="notification-card"][data-title="#{title}"]))
  expect(card).not_to have_css('[data-testid="new-badge"]', text: badge_text)
end

Then('the notification card {string} should appear without the badge {string}') do |title, badge_text|
  step %(the notification card "#{title}" should not display the badge "#{badge_text}")
end

Then('the unread counter pill should show {string}') do |expected|
  expect(unread_counter_text).to eq(expected)
end

Then('I should see the side panel with title {string}') do |title|
  expect(find('[data-testid="notification-details"]')).to have_css('h2', text: title)
end

Then('I should see the text {string}') do |text|
  expect(find('[data-testid="notification-details"]')).to have_text(text)
end

Then('I should see the information chip {string}') do |label|
  expect(find('[data-testid="detail-due"]')).to have_text(label)
end

Then('I should see the primary action button {string}') do |label|
  if page.has_css?('[data-testid="custom-reminder-modal"]', wait: 0)
    within('[data-testid="custom-reminder-modal"]') do
      expect(page).to have_button(label)
    end
  else
    within('[data-testid="notification-details"]') do
      expect(page).to have_css('button', text: label)
    end
  end
end

Then('the unread counter pill should decrease by 1') do
  current = unread_counter_value
  expect(current).to eq(@previous_unread_count - 1)
  @previous_unread_count = current
end

Then('I should see a toast message {string}') do |message|
  expect(page).to have_css('.alert', text: message)
end

Then('all notification cards should appear without the badge {string}') do |badge_text|
  expect(all('[data-testid="notification-card"]').all? do |card|
    card.has_no_css?('[data-testid="new-badge"]', text: badge_text)
  end).to be(true)
end

Then('I should see the illustration {string}') do |illustration|
  empty_state = find('[data-testid="empty-state"]')
  expect(empty_state).to have_text(illustration)
end

Then('I should see the helper text {string}') do |text|
  expect(page).to have_text(text)
end

Then('I should see the call to action button {string}') do |label|
  expect(find('[data-testid="empty-state"]')).to have_link(label)
end

Then('I should see the alert {string}') do |message|
  expect(page).to have_css('.alert', text: message)
end
