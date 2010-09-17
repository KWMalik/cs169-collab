class Movie < ActiveRecord::Base
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title
  validates_length_of :description, :minimum => 10
  validates_inclusion_of :rating, :in => ['G', 'PG', 'PG-13', 'R', 'NC-17']

  def appropriate_for_birthdate?(date)
    rating = self.rating
    age = (Time.now - date)/60/60/24/365
    Movie.appropriate_rating_for_birthday(date).include? rating
  end

  def self.find_all_appropriate_for_birthdate(birthday)
    allowed_movies = []
    Movie.appropriate_rating_for_birthday(birthday).each do |rating|
       Movie.find_all_by_rating(rating).each do |movie|
         allowed_movies << movie
       end
    end
    allowed_movies
  end

  def self.appropriate_rating_for_birthday(birthday)
    age = (Time.now - birthday)/60/60/24/365
    case
    when age >= 17
      return ['G','PG','PG-13','R','NC-17']
    when age >= 13
      return ['G','PG','PG-13']
    else 
      return ['G','PG']
    end
  end

end
