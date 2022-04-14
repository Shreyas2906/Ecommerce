require "application_system_test_case"

class AadressesTest < ApplicationSystemTestCase
  setup do
    @aadress = aadresses(:one)
  end

  test "visiting the index" do
    visit aadresses_url
    assert_selector "h1", text: "Aadresses"
  end

  test "creating a Aadress" do
    visit aadresses_url
    click_on "New Aadress"

    fill_in "Country", with: @aadress.country
    fill_in "Email", with: @aadress.email
    fill_in "Line1", with: @aadress.line1
    fill_in "Name", with: @aadress.name
    fill_in "Phone", with: @aadress.phone
    fill_in "Pincode", with: @aadress.pincode
    fill_in "State", with: @aadress.state
    fill_in "User", with: @aadress.user_id
    click_on "Create Aadress"

    assert_text "Aadress was successfully created"
    click_on "Back"
  end

  test "updating a Aadress" do
    visit aadresses_url
    click_on "Edit", match: :first

    fill_in "Country", with: @aadress.country
    fill_in "Email", with: @aadress.email
    fill_in "Line1", with: @aadress.line1
    fill_in "Name", with: @aadress.name
    fill_in "Phone", with: @aadress.phone
    fill_in "Pincode", with: @aadress.pincode
    fill_in "State", with: @aadress.state
    fill_in "User", with: @aadress.user_id
    click_on "Update Aadress"

    assert_text "Aadress was successfully updated"
    click_on "Back"
  end

  test "destroying a Aadress" do
    visit aadresses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Aadress was successfully destroyed"
  end
end
