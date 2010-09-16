require 'spec_helper'

describe Movie do
  before(:each) do
    @valid_attributes = {
      :title => "Pocahontas",
      :description => "A movie about the new world.",
      :rating => "G",
      :released_on => Time.parse("1/1/1995")
    }
    @g = Movie.create!({
      :title => "Snow White",
      :description => "Disney movie about snow white",
      :rating => "G",
    })
    @lionking = Movie.create!({
      :title => "Lion King",
      :description => "Disney movie about lion king",
      :rating => "G",
    })
    @pg = Movie.create!({
      :title => "Some PG Movie",
      :description => "Some description of a pg movie",
      :rating => "PG",
    })
    @pg13 = Movie.create!({
      :title => "Some PG-13 Movie",
      :description => "Some pg13 movie with mild violence",
      :rating => "PG-13",
    })
    Movie.create!({
      :title => "Some PG-13 Movie2",
      :description => "Some pg13 movie with swear words",
      :rating => "PG-13",
    })
    @r = Movie.create!({
      :title => "Some R Movie",
      :description => "Some R lots of violents",
      :rating => "R",
    })
    @nc17 = Movie.create!({
      :title => "Some NC-17 Movie",
      :description => "Some NC-17 lots of gore",
      :rating => "NC-17",
    })
  end


  it "should create a new instance given valid attributes" do
    Movie.create(@valid_attributes).should be_true
  end

  describe "when validating a movie" do
    it "should not allow a movie with no title" do
      @no_title_attributes = {
        :description => "A movie about the new world.",
        :rating => "G",
        :released_on => Time.parse("1/1/1995")
      }
      @movie = Movie.new(@no_title_attributes)
      @movie.should_not be_valid
    end

    it "should not allow a movie with no description" do
      @no_description_attributes = {
        :title => "title of a movie",
        :rating => "G",
        :released_on => Time.parse("1/1/1995")
      }
      @movie = Movie.new(@no_description_attributes)
      @movie.should_not be_valid
    end

    it "should not allow a movie with a title that is not unique" do
      @lionking2 = {
        :title => "Lion King",
        :description => "illegal copy of the lion king",
        :rating => "G",
      }
      @movie = Movie.new(@lionking2)
      @movie.should_not be_valid
    end

    it "should not allow a movie with a description less than 10 characters long" do
      @lionking2 = {
        :title => "too short description",
        :description => "copy",
        :rating => "G",
      }
      @movie = Movie.new(@lionking2)
      @movie.should_not be_valid
    end
    
    it "should allow a movie with a valid movie rating" do
      @validRating = {
        :title => "unique title",
        :description => "a very long description",
        :rating => "G",
      }
      @movie = Movie.new(@validRating)
      @movie.should be_valid
    end
    
    it "should not allow a movie with an invalid movie rating" do
      @invalidRating = {
        :title => "unique title",
        :description => "a very long description",
        :rating => "not yet rated",
      }
      @movie = Movie.new(@invalidRating)
      @movie.should_not be_valid
    end

  end

  # Add more specs here!
  describe "when checking valid ratings for birthdays" do
    it "should return valid ratings for >=17 birthday" do
      Movie.appropriate_rating_for_birthday(Time.parse("Jan 1 1989")).should == ["G", "PG", "PG-13", "R", "NC-17"]
    end
    it "should return valid ratings for >=13 birthday" do
      Movie.appropriate_rating_for_birthday(Time.parse("Jan 1 1994")).should == ["G", "PG", "PG-13"]
    end
    it "should return valid ratings for < 13 birthday" do
      Movie.appropriate_rating_for_birthday(Time.parse("Jan 1 1998")).should == ["G", "PG"]
    end
  end

  describe "when checking age-appropriateness" do
    it "should return valid ratings for >=17 birthday" do
      @g.appropriate_for_birthdate?(Time.parse("Jan 1 1989")).should == true
      @pg.appropriate_for_birthdate?(Time.parse("Jan 1 1989")).should == true
      @pg13.appropriate_for_birthdate?(Time.parse("Jan 1 1989")).should == true
      @r.appropriate_for_birthdate?(Time.parse("Jan 1 1989")).should == true
      @nc17.appropriate_for_birthdate?(Time.parse("Jan 1 1989")).should == true
    end 
    it "should return valid ratings for >=13 birthday" do
      @g.appropriate_for_birthdate?(Time.parse("Jan 1 1994")).should == true
      @pg.appropriate_for_birthdate?(Time.parse("Jan 1 1994")).should == true
      @pg13.appropriate_for_birthdate?(Time.parse("Jan 1 1994")).should == true
      @r.appropriate_for_birthdate?(Time.parse("Jan 1 1994")).should == false 
      @nc17.appropriate_for_birthdate?(Time.parse("Jan 1 1994")).should == false
    end
    it "should return valid ratings for < 13 birthday" do
      @g.appropriate_for_birthdate?(Time.parse("Jan 1 1998")).should == true
      @pg.appropriate_for_birthdate?(Time.parse("Jan 1 1998")).should == true
      @pg13.appropriate_for_birthdate?(Time.parse("Jan 1 1998")).should == false
      @r.appropriate_for_birthdate?(Time.parse("Jan 1 1998")).should == false 
      @nc17.appropriate_for_birthdate?(Time.parse("Jan 1 1998")).should == false
    end
  end

  describe "database finder for age-appropriateness" do
    it "should always include all rated movies" do
      Movie.find_all_appropriate_for_birthdate(Time.parse("Jan 1 1989")).each do |movie|
        ["G", "PG", "PG-13", "R", "NC-17"].should include movie.rating
      end
    end
    it "should exclude NC-17 and R rated movies if age is less than 17" do 
      Movie.find_all_appropriate_for_birthdate(Time.parse("Jan 1 1994")).each do |movie|
        ["G", "PG", "PG-13"].should include movie.rating
      end
    end
    it "should only have G, PG movies if age is less than 13" do
      Movie.find_all_appropriate_for_birthdate(Time.parse("Jan 1 1998")).each do |movie|
        ["G", "PG"].should include movie.rating
      end
    end
  end

end
