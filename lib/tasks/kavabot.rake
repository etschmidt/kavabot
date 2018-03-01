namespace :kavabot do

	require 'twitter'

	client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV["CONSUMER_KEY"]
	  config.consumer_secret     = ENV["CONSUMER_SECRET"]
	  config.access_token        = ENV["ACCESS_TOKEN"]
	  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
	end

	@topic = ["#kava", "#kava", "#kava", "#kava", "#kavabars", "#hawaii", "#vanuatu", "#fiji", "#organic", "#rawjuice"].sample

	search_options = {	}

	task :favorite => :environment do
		
		client.search(@topic, search_options).take(10).each do |tweet|

			client.favorite(tweet)
		
		end

	end

	task :retweet => :environment do

		client.search(@topic, search_options).take(1).each do |tweet|

	    	client.retweet!(tweet)
	    	client.favorite(tweet)

	    end

	end

    task :stressed => :environment do 

		client.search("#stressed", search_options).take(2).each do |tweet|
		  
			client.favorite(tweet)
			client.update("@#{tweet.user.screen_name} Stressed? Try some delicious, relaxing #Kava!", attachment_url: tweet.url,
				in_reply_to_status_id: tweet.id)
		
		end

  	end

  	task :follow => :environment do
  	
  		client.search(@topic, search_options).take(2).each do |tweet|
  		
  			user = tweet.user

  			client.follow(user)

  		end

  	end


end
