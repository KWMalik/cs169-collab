require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'part2'

def get_breaking_news(min)
  doc = Hpricot(open("http://rss.cnn.com/rss/cnn_topstories.rss"))
  stories = []
  doc.search("item").each do |item|
    pubDate = Time.parse(removeTags(Hpricot(item.to_s).search("item/pubDate[1]")))
    minutesAgo = (Time.now - pubDate)/60
    if minutesAgo < min
      title = removeTags(Hpricot(item.to_s).search("item/title[1]"))
      guid = removeTags(Hpricot(item.to_s).search("item/guid[1]"))
      stories << NewsStory.new(title, guid, pubDate)
    end
  end
  stories
end

def removeTags(str)
  str.to_s.gsub(/<\/?[^>]*>/, "")
end
