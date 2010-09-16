require 'spec_helper'

describe Movie do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :description => "value for description",
      :rating => "value for rating",
      :released_on => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    Movie.create!(@valid_attributes)
  end
end
