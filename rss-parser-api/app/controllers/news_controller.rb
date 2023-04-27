class NewsController < ApplicationController
  before_action :set_news, only: %i[ show edit update destroy ]

  # GET /news or /news.json
  def index
    # TO DO: Move Business Logic in a Service then inject that Service
    @doc = Nokogiri::XML(URI.open("https://rss.nytimes.com/services/xml/rss/nyt/World.xml"))
    
    titles = @doc.xpath("//item//title").map { |e| e.content }
    links = @doc.xpath("//item//link").map { |e| e.content }
    descriptions = @doc.xpath("//item//description").map { |e| e.content }
    publication_dates = @doc.xpath("//item/pubDate").children.map { |e| DateTime.parse(e.content) }

    news = []
    titles.each_with_index do |_, index|
      news << {
        'title': titles[index],
        'links': links[index],
        'description': descriptions[index],
        'pubDate': publication_dates[index],
      }
    end

    # sort by title increasing
    news.sort! { |a, b| a[:title] <=> b[:title] } if params[:order_by] == 'title' && params[:ordering] == 'ASC'

    # sort by title decreasing
    news.sort! { |a, b| b[:title] <=> a[:title] } if params[:order_by] == 'title' && params[:ordering] == 'DESC'

    # sort by publication_date increasing
    news.sort! { |a, b| a[:pubDate] <=> b[:pubDate] } if params[:order_by] == 'pubDate' && params[:ordering] == 'ASC'
    
    # sort by publication_date decreasing
    news.sort! { |a, b| b[:pubDate] <=> a[:pubDate] } if params[:order_by] == 'pubDate' && params[:ordering] == 'DESC'

    # filter news that contains search_word
    news.select! { |current_news| current_news[:title].include?(params[:search_word]) || current_news[:description].include?(params[:search_word]) } if params[:search_word].present?

    render xml: news.to_xml(root: "Items")
  end

  # GET /news/1 or /news/1.json
  def show
  end

  # GET /news/new
  def new
    @news = News.new
  end

  # GET /news/1/edit
  def edit
  end

  # POST /news or /news.json
  def create
    @news = News.new(news_params)

    respond_to do |format|
      if @news.save
        format.html { redirect_to news_url(@news), notice: "News was successfully created." }
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news/1 or /news/1.json
  def update
    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to news_url(@news), notice: "News was successfully updated." }
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1 or /news/1.json
  def destroy
    @news.destroy

    respond_to do |format|
      format.html { redirect_to news_index_url, notice: "News was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def news_params
      params.fetch(:news, {})
    end
end
