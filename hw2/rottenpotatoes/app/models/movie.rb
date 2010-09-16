class Movie < ActiveRecord::Base

  def appropriate_for_birthdate?(date)
    rating = self.rating
    age = (date - Time.now)
  end

end
