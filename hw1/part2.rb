Numeric.class_eval do
  def factorial
    x = self
    if x > 0
      output = x
      while x>1
        x = x - 1
        output = output * x
      end
      return output
    elsif x == 0
      return 1
    else
      return "undef"
    end
  end
end

class NewsStory

  def initialize(title, guid, pub_date)
    @title = title
    @guid = guid
    @pub_date = pub_date
  end

  def set_title(x)
    @title= x
  end

  def set_guid(x)
    @guid = x
  end

  def set_pub_date(x)
    @pub_date = x
  end

  def get_title
    @title
  end
  
  def get_guid
    @guid
  end

  def get_pub_date(x)
    @pub_date
  end

  def to_s
    @title.to_s + " published on " + @pub_date.to_s + " with id " + @guid.to_s
  end

end

def string_of_all_stories(newStories)
  output = ""
  newStories.each do |story|
    output += story.to_s + "\n"
  end
  output
end

Time.class_eval do
  def self.tomorrow
    Time.now + (60 * 60 *24)
  end
end
