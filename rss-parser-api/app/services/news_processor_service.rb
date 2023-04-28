
class NewsProcessorService

  URL_RSS_NYTIMES = 'https://rss.nytimes.com/services/xml/rss/nyt/World.xml'
  
  def initialize(params)
    @params = params
    @doc = Nokogiri::XML(URI.open(URL_RSS_NYTIMES))
    @news = []
  end

  def call
    parse_news
    create_news_dto
    sort_news_dto
    filter_news_dto
  end
  
  def parse_news
    @titles = @doc.xpath("//item//title").map { |e| e.content }
    @links = @doc.xpath("//item//link").map { |e| e.content }
    @descriptions = @doc.xpath("//item//description").map { |e| e.content }
    @publication_dates = @doc.xpath("//item/pubDate").children.map { |e| DateTime.parse(e.content) }
  end

  def create_news_dto
    @titles.each_with_index do |_, index|
      @news << {
        'title': @titles[index],
        'links': @links[index],
        'description': @descriptions[index],
        'pubDate': @publication_dates[index],
      }
    end
  end

  def sort_news_dto
    @news.sort! { |a, b| a[:title] <=> b[:title] } if @params[:order_by] == 'title' && @params[:ordering] == 'ASC'

    @news.sort! { |a, b| b[:title] <=> a[:title] } if @params[:order_by] == 'title' && @params[:ordering] == 'DESC'

    @news.sort! { |a, b| a[:pubDate] <=> b[:pubDate] } if @params[:order_by] == 'pubDate' && @params[:ordering] == 'ASC'
    
    @news.sort! { |a, b| b[:pubDate] <=> a[:pubDate] } if @params[:order_by] == 'pubDate' && @params[:ordering] == 'DESC'
  end

  def filter_news_dto
    @news.select! { |current_news| current_news[:title].include?(@params[:search_word]) || current_news[:description].include?(@params[:search_word]) } if @params[:search_word].present?
  end

  def get_news_dto_xml_format
    @news.to_xml(root: "Items")
  end
end
