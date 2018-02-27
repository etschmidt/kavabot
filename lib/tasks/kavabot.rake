namespace :wodbot do

	task :post => :environment do
		require 'twitter'

		client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = ENV["CONSUMER_KEY"]
		  config.consumer_secret     = ENV["CONSUMER_SECRET"]
		  config.access_token        = ENV["ACCESS_TOKEN"]
		  config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
		end

		wod = Wod.new
		client.update(wod.print_ss + "\n#fitness #workouts www.GymBull.com\n")
		client.update(wod.print_wod + "\n#fitness #workouts www.GymBull.com\n")
	end

	task :test_post => :environment do
		wod = Wod.new
		print wod.print_wod.length - 19
		print "\n\n"
		print wod.print_wod 
		print "\n\n"
		print wod.print_ss
	end
end

namespace :thegymbull do

	require 'twitter'

	client = Twitter::REST::Client.new do |config|
	  config.consumer_key        = ENV["GYM_CONSUMER_KEY"]
	  config.consumer_secret     = ENV["GYM_CONSUMER_SECRET"]
	  config.access_token        = ENV["GYM_ACCESS_TOKEN"]
	  config.access_token_secret = ENV["GYM_ACCESS_TOKEN_SECRET"]
	end

	@topic = ["#fitness", "#crossfit", "#wod", "#weigtlifting", 
		"#workout", "#gymlife", "#personaltrainer", "#excerise",
		"#bodybuilding", "#nutrition"].sample

	task :wod => :environment do
		wod = Wod.new
		client.update(wod.print_wod + "\n#fitness #workouts https://diogn.es/u/141\n")
		client.update(wod.print_ss + "\n#fitness #workouts https://diogn.es/u/141\n")	
	end

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

  task :quote => :environment do

  	quote = Quote.new

		client.update(quote.print_quote + "\nwww.GymBull.com\n")  
		
	end	

end
