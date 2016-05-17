require 'bundler/setup'
require 'scraperwiki'
require 'twitter'
require 'pry'
require 'dotenv'

Dotenv.load

def twitter
  @twitter ||= Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end
end

twitter.list_members('gov', 'uk-mps').each do |person|
  data = {
    id: person.id,
    name: person.name,
    twitter: person.screen_name,
    image: person.profile_image_url_https(:original).to_s,
  }
  ScraperWiki.save_sqlite([:id], data)
end
