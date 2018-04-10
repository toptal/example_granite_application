require 'rails_helper'

RSpec.describe "books/index", type: :view do

  include Devise::TestHelpers

  before(:each) do
    assign(:books, [
      Book.create!(
        :title => "Title"
      ),
      Book.create!(
        :title => "Title"
      )
    ])
  end

  it "renders a list of books" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
