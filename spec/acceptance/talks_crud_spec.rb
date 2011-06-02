require 'acceptance/acceptance_helper'

describe 'users CRUDing talks', :type => :request do
  before do
    @camp = Camp.current || Camp.make!
    @user = @camp.users.make!
    sign_in_as(@user)
  end

  it 'lets users view the talks' do
    venue = Venue.make!(:camp => @camp)
    talk = @camp.talks.order(:start_at).first
    talk.update_attributes(:name => 'Sample Talk', :venue => venue, :user => @user)

    day = @camp.talks.order(:start_at).first.day
    visit talks_path(:day => day)

    # Do we see the details for each talk on this day?
    @camp.talks.for_day(day).each do |talk|
      page.should have_content talk.name
    end
  end

  it 'lets a user create a new talk' do
    pending
    attrs = {
      :name => 'Intro to coffeescript',
      :start_at => 1.day.from_now.beginning_of_day + 8.hours,
      :end_at => 1.day.from_now.beginning_of_day + 9.hours
    }

    visit new_talk_path

    fill_in :name, :with => attrs[:name]
    fill_in :start_at, :with => attrs[:start_at].to_s
    fill_in :end_at, :with => attrs[:end_at].to_s

    click_button 'Create Talk'

    #saved flash?
    page.should have_content 'This talk has been saved.'

    #new values saved?
    attrs.each do |attr, value|
      page.should have_field(attr.to_s.humanize, :with => value)
    end
  end
end
