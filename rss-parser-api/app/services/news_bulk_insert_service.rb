
class NewsBulkInsertService

  # TO DO: move all constants in separate file or in a dotenv
  URL_RSS_NYTIMES = 'https://rss.nytimes.com/services/xml/rss/nyt/World.xml'
  
  def initialize
    @doc = Nokogiri::XML(URI.open(URL_RSS_NYTIMES))
    @news_ruby_obj = []
    @publisher_ruby_obj = {}
  end

  def call
    parse_news
    bulk_insert
  end

  private

  def parse_news_data
    @titles = @doc.xpath("//item//title").map { |e| e.content }
    @links = @doc.xpath("//item//link").map { |e| e.content }
    @descriptions = @doc.xpath("//item//description").map { |e| e.content }
    @publication_dates = @doc.xpath("//item/pubDate").children.map { |e| DateTime.parse(e.content) }
  end

  def parse_publisher_data
    @publisher_title = @doc.xpath("//channel//title").map { |e| e.content }
    @publisher_link = @doc.xpath("//channel//link").map { |e| e.content }
  end

  def parse_group_data

  end

  def parse_news
    parse_news_data
    parse_publisher_data
    parse_group_data
  end

  def create_news_ruby_obj
    @titles.each_with_index do |_, index|
      @news_ruby_obj << {
        'title': @titles[index],
        'link': @links[index],
        'description': @descriptions[index],
        'publication_date': @publication_dates[index],
        'publisher_id': @publisher_db_obj.id 
      }
    end
  end

  def create_publisher_ruby_obj
    @publisher_ruby_obj = {
      'title': @publisher_title.first,
      'link': @publisher_link.first,
    }
  end

  def bulk_insert
    ActiveRecord::Base.transaction do
      create_publisher_ruby_obj
      @publisher_db_obj = Publisher.create(@publisher_ruby_obj)
      create_news_ruby_obj
      News.create(@news_ruby_obj)
    end
  end
end
