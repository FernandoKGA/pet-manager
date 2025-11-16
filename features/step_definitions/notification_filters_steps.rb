module NotificationFiltersSteps
  def parse_filter_date(value)
    today = Time.zone.today

    case value
    when nil, '', 'Todos'
      nil
    when /\AHoje\z/i
      today
    when /\AAmanhã\z/i
      today + 1.day
    when /\AOntem\z/i
      today - 1.day
    when /\AEm (\d+) dias?\z/i
      today + Regexp.last_match(1).to_i.days
    when /\AEm (\d+) semanas?\z/i
      today + (Regexp.last_match(1).to_i * 7).days
    else
      Date.parse(value)
    end
  rescue ArgumentError
    nil
  end
end

World(NotificationFiltersSteps)

Then('I should see the filter controls for status, category and period') do
  within('[data-testid="notification-filters"]') do
    expect(page).to have_select('Status', id: 'filter-status')
    expect(page).to have_select('Categoria', id: 'filter-category')
    expect(page).to have_field('De', id: 'filter-from')
    expect(page).to have_field('Até', id: 'filter-to')
    expect(page).to have_button('Aplicar filtros')
  end
end

When('I apply the status filter {string}') do |label|
  within('[data-testid="notification-filters"]') do
    select label, from: 'filter-status'
    click_button 'Aplicar filtros'
  end
end

When('I apply the category filter {string}') do |label|
  within('[data-testid="notification-filters"]') do
    select label, from: 'filter-category'
    click_button 'Aplicar filtros'
  end
end

When('I filter notifications from {string} to {string}') do |from_label, to_label|
  within('[data-testid="notification-filters"]') do
    from_date = parse_filter_date(from_label)
    to_date = parse_filter_date(to_label)

    fill_in 'filter-from', with: from_date&.to_s
    fill_in 'filter-to', with: to_date&.to_s
    click_button 'Aplicar filtros'
  end
end

Then('I should see the active filter tag {string}') do |tag_text|
  within('[data-testid="active-filter-tags"]') do
    expect(page).to have_css('[data-testid="active-filter-tag"]', text: tag_text)
  end
end

Then('I should see the active filter summary {string}') do |summary|
  expect(find('[data-testid="active-filter-summary"]')).to have_text(summary)
end
