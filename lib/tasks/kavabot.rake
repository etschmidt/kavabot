namespace :kavabot do

	require 'twitter'

	client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV["CONSUMER_KEY"]
	  config.consumer_secret     = ENV["CONSUMER_SECRET"]
	  config.access_token        = ENV["ACCESS_TOKEN"]
	  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
	end

	@topic = ["#kava", "#kava", "#kava", "#kava", "#kavabars", "#hawaii", "#vanuatu", "#fiji"].sample

	task :favorite => :environment do
		
		tweets = client.search(@topic, lang: "en").take(10) || ""

		tweets.each do |tw|
			if !tw.favorited?
				client.favorite(tw.id)
			end
		end

	end

	task :retweet => :environment do

		tweet = client.search(@topic, lang: "en").take(1) || ""

    client.retweet!(tweet)
    client.favorite(tweet)

  end

end
