Feature: Manage Veterinary Appointments
As a pet owner
I want to register veterinary appointments
To keep my pet's medical history up-to-date

Background: Initial Data 
Given I am logged in with a valid username
And I have an existing pet recorded
And I am logged into my valid account

Scenario: Registering a new appointment
When I visit the medical appointments page for "Oliver"
And I click on "Nova Consulta"
And I fill in the medical appointment form with valid information
And I click the button "Salvar Consulta"
Then I should see the following message "Consulta Veterinária cadastrada com sucesso!"

