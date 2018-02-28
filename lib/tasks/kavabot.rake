namespace :kavabot do

	require 'twitter'

	client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV["CONSUMER_KEY"]
	  config.consumer_secret     = ENV["CONSUMER_SECRET"]
	  config.access_token        = ENV["ACCESS_TOKEN"]
	  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
	end

	@topic = ["#kava", "#kava", "#kava", "#kava", "#kavabars", "#hawaii", "#vanuatu", "#fiji"].sample

	search_options = {
		result_type: "recent"
	}

	task :favorite => :environment do
		
		tweets = client.search(@topic, search_options).take(10) || ""

		tweets.each do |tw|
			if !tw.favorited?
				client.favorite(tw.id)
			end
		end

	end

	task :retweet => :environment do

		tweet = client.search(@topic, search_options).take(1) || ""

    	client.retweet!(tweet)
    	client.favorite(tweet)

	end

    task :stressed => :environment do 

		client.search("#stressed", search_options).take(1).each do |tweet|
		
		text = "@#{tweet.user.screen_name} Stressed? Try some delicious, relaxing #Kava!"

		client.favorite(tweet)
		client.retweet!(tweet, text, in_reply_to_status_id: tweet.id)
		
		end

  	end

end
