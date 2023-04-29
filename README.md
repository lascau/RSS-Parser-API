# RSS-Parser-API

3a) Done \
3b) Done \
3c) In progress

news_db
tables:
- news:
 title
 description
 pubDate
 publisher_id
- publishers:
 title
 link
- news_group:
 news_id
 group_id
- groups:
 title

Endpoints:
- GET /news
- GET /news?order_by=title&ordering=ASC
- GET /news?order_by=title&ordering=DESC
- GET /news?order_by=pubDate&ordering=ASC
- GET /news?order_by=pubDate&ordering=DESC
- GET /news?search_word=test => case sensitive search
- POST /news/bulk_insert

Important files:
- rss-parser-api/app/services/news_bulk_insert_service.rb
- rss-parser-api/app/services/news_processor_service.rb
- rss-parser-api/app/controllers/news_controller.rb

Video:

https://user-images.githubusercontent.com/32646125/235296770-f26ad9d3-88ec-4de7-aa33-1a15fb8700b5.mp4



To do:
- a file to keep all constants
- a variable true/false if the builk_insert was succesful or not and based on that return http status code 200/417
- change http verb from GET to POST on news/bulk_insert endpoint
- unit tests
- add group table and many to many relationship with news
- try to parse items xml children tags while iterating over items(counter intuitive)
- speed up inserts - insert in batches

Extra task sol using Regex:

```ruby
pp ["2.5.0-dev.1", "2.4.2-5354", "2.4.2-test.675", "2.4.1-integration.1"].select! { |e| e.match('[0-9]+.[0-9]+.[0-9]+-[0-9]+') }
```

Links:

- https://regex101.com/
- https://onecompiler.com/ruby/
