require 'rails_helper'

RSpec.feature 'User Login', type: :feature do
  let(:user) { create(:user, email: 'user@example.com', password: 'password') }

  scenario 'User visits the login page and logs in successfully' do
    visit login_path

    expect(page).to have_content('Login to your account')
    expect(page).to have_field('email')
    expect(page).to have_field('password')

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'Login'

    expect(page).to have_content('Select bank account')
    expect(current_path).to eq(root_path)
  end

  scenario 'User enters incorrect credentials' do
    visit login_path

    fill_in 'email', with: 'wrong@example.com'
    fill_in 'password', with: 'wrongpassword'
    click_button 'Login'

    expect(page).to have_content('Invalid email or password')
    expect(current_path).to eq(login_path)
  end
end
