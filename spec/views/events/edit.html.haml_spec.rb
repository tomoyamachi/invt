require 'spec_helper'

describe "events/edit.html.haml" do
  before(:each) do
    @event = assign(:event, stub_model(Event,
      :title => "MyString",
      :category => "MyString",
      :note => "MyText",
      :open_flag => ""
    ))
  end

  it "renders the edit event form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => events_path(@event), :method => "post" do
      assert_select "input#event_title", :name => "event[title]"
      assert_select "input#event_category", :name => "event[category]"
      assert_select "textarea#event_note", :name => "event[note]"
      assert_select "input#event_open_flag", :name => "event[open_flag]"
    end
  end
end
