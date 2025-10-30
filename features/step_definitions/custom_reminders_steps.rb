When('I click the call to action button {string}') do |label|
  if page.has_css?('[data-testid="empty-state-cta"]', wait: 0)
    find('[data-testid="empty-state-cta"]').click
  elsif page.has_css?('[data-testid="open-custom-reminder"]', wait: 0)
    find('[data-testid="open-custom-reminder"]').click
  else
    click_on label
  end
end

def translate_date_input(value)
  case value
  when /\AHoje\z/i
    Time.zone.today.to_s
  when /\AAmanhã\z/i
    (Time.zone.today + 1.day).to_s
  else
    value
  end
end

When('I fill the reminder form with:') do |table|
  within('[data-testid="custom-reminder-form"]') do
    table.rows_hash.each do |field, value|
      next if value.blank?

      if page.has_field?(field, type: 'date')
        fill_in field, with: translate_date_input(value)
      elsif page.has_select?(field)
        select value, from: field
      else
        fill_in field, with: value
      end
    end
  end
end

When('I click the primary action button {string}') do |label|
  within('[data-testid="custom-reminder-modal"]') do
    click_on label
  end
end

When('I click the secondary action button {string}') do |label|
  within('[data-testid="custom-reminder-modal"]') do
    click_on label
  end
end

When('I submit the reminder form without filling required fields') do
  within('[data-testid="custom-reminder-modal"]') do
    click_on 'Salvar lembrete'
  end
end

When('I try to access the new custom reminder form') do
  visit new_notification_center_custom_reminder_path
end

Then('I should see the modal heading {string}') do |heading|
  within('[data-testid="custom-reminder-modal"]') do
    expect(page).to have_css('[data-testid="modal-heading"]', text: heading)
  end
end

Then('I should see the following fields in the reminder form:') do |table|
  within('[data-testid="custom-reminder-form"]') do
    table.raw.flatten.each do |label|
      expect(page).to have_css('label', text: label)
    end
  end
end

Then('I should see the secondary action button {string}') do |label|
  within('[data-testid="custom-reminder-modal"]') do
    if page.has_button?(label)
      expect(page).to have_button(label)
    else
      expect(page).to have_link(label)
    end
  end
end

Then('I should not see the reminder modal') do
  expect(page).to have_no_css('[data-testid="custom-reminder-modal"]', visible: true)
end

Then('I should see the field error {string}') do |message|
  within('[data-testid="custom-reminder-form"]') do
    expect(page).to have_css('[data-testid="field-error"]', text: message)
  end
end

Then('I should see the recurrence badge {string} on the notification card {string}') do |badge_text, title|
  card = find(%(div[data-testid="notification-card"][data-title="#{title}"]))
  expect(card).to have_css('[data-testid="recurrence-badge"]', text: badge_text)
end
