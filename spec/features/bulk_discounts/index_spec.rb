require 'rails_helper'

describe "merchant bulk discounts" do
  include ApplicationHelper

  before :each do
    Timecop.freeze(Time.local(2023, 3, 6))
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Pets R Us')

    @discount1 = BulkDiscount.create!(percentage_discount: 0.25, quantity_threshold: 50, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage_discount: 0.15, quantity_threshold: 25, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage_discount: 0.10, quantity_threshold: 10, merchant_id: @merchant2.id)
    @discount4 = BulkDiscount.create!(percentage_discount: 0.05, quantity_threshold: 5, merchant_id: @merchant2.id)
  end

  it "I see all of my bulk discounts including their percentage discount and quantity thresholds" do
    visit merchant_bulk_discounts_path(@merchant1)

    expect(page).to have_content(float_to_percent(@discount1.percentage_discount))
    expect(page).to have_content("#{@discount1.quantity_threshold}")
    expect(page).to have_content(float_to_percent(@discount2.percentage_discount))
    expect(page).to have_content("#{@discount2.quantity_threshold}")
    expect(page).to_not have_content("#{@discount3.percentage_discount}")
    expect(page).to_not have_content("#{@discount4.percentage_discount}")
  end

  it "I see each bulk discount listed includes a link to it's show page" do
    visit merchant_bulk_discounts_path(@merchant1)
    
    expect(page).to have_link("#{@discount1.id}")
    expect(page).to have_link("#{@discount2.id}")

    click_link("Discount: #{@discount1.id}")
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))
  end

  it "I see a link to create a new discount and when I click this link Im taken to a new page where I see a form to add a new bulk discount" do
    visit merchant_bulk_discounts_path(@merchant1)
    
    expect(page).to have_link('Create a new bulk discount')
    click_link('Create a new bulk discount')

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))
    expect(page).to have_field('Percentage discount')
    expect(page).to have_field('Quantity threshold')
  end

  it "I fill in the the form with valid data, click submit and I'm redirected back to the bulk discount index and I see my new bulk discount listed" do
    visit new_merchant_bulk_discount_path(@merchant1)

    fill_in('Percentage discount', with: 0.10)
    fill_in('Quantity threshold', with: 12)
    click_button('Submit')

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))
    expect(page).to have_content("Discounted: 10%, Quantity Threshhold(items): 12")
  end

  it "I fill in the the form with invalid data, click submit and the current page does not change and I see a error message" do
    visit new_merchant_bulk_discount_path(@merchant1)

    fill_in('Quantity threshold', with: 12)
    click_button('Submit')

    expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts")
    expect(page).to have_content("Invalid input")
  end

  it "I see next to each bulk discount a link to delete it. When I click this link I am redirected back to the bulk discounts index page and I no longer see this discount listed" do
    visit merchant_bulk_discounts_path(@merchant1)
  
    expect(page).to have_link("Delete: #{@discount1.id}")
    expect(page).to have_link("Delete: #{@discount2.id}")

    click_link("Delete: #{@discount1.id}")

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

    within("#discounts") do
      expect(page).to have_content(@discount2.id)
      expect(page).to_not have_content(@discount1.id)
    end
  end

  it "I see a section with a header of 'Upcoming Holidays.' In this section the name and date of the next 3 upcoming US holidays are listed." do
    visit merchant_bulk_discounts_path(@merchant1)
 
    expect(page).to have_content("Holiday: Good Friday, Date: 2023-04-07")
    expect(page).to have_content("Holiday: Memorial Day, Date: 2023-05-29")
    expect(page).to have_content("Holiday: Juneteenth, Date: 2023-06-19")

    expect("Holiday: Good Friday, Date: 2023-04-07").to appear_before("Holiday: Memorial Day, Date: 2023-05-29")
    expect("Holiday: Memorial Day, Date: 2023-05-29").to appear_before("Holiday: Juneteenth, Date: 2023-06-19")
  end
end
