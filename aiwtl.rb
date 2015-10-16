require 'rest-client'
require 'json'
require 'base64'
require 'parseconfig'

class AIWTL
	CONFIG_FILE = File.join(ENV['HOME'], '.aiwtl')

	def initialize
		parse_config
		create_headers		
	end

	def am_i_working_too_long?(start_date)
		today = Date.today
		end_date = today - 1
		
		working_days = 0
		worked_hours = 0.0

		for date in start_date..end_date
			working_days += 1 unless date.saturday? || date.sunday?
			worked_hours += daily_hours(date)
			print '.'
  			$stdout.flush
		end

		puts

		working_hours = working_days * @hours_per_working_day
		diff = (worked_hours - working_hours).round(2)
		today_worked_hours = daily_hours(today)

		if diff > 0
			puts "Yes, you're working too long. You've got spare #{hours_and_minutes(diff)} until yesterday."
		else
			puts "No, you're not working too long. You need #{hours_and_minutes(-diff)} more."
		end

		puts "Working days until yesterday: #{working_days}."
		puts "Working hours until yesterday: #{working_hours}."
		puts "You worked for #{hours_and_minutes(worked_hours)} until yesterday."
		puts "Today you worked for #{hours_and_minutes(today_worked_hours)}"
	end

	def daily_hours(date)
		yday = date.yday
		year = date.year

		j = request("/daily/#{yday}/#{year}")

		j['day_entries'].reduce(0) { |sum, p| sum += p['hours'].to_f }
	end

	private

	def days_in_year(year)
		Date.new(year, 12, 31).yday
	end

	def hours_and_minutes(hours_fraction)
		hours = hours_fraction.floor
		minutes = (hours_fraction % 1.0 * 60).round 

		"#{hours}:#{minutes} h"
	end

	def parse_config
		config = ParseConfig.new(CONFIG_FILE)
		required_params = %w(subdomain user pass)

		@subdomain = config['subdomain']
		@user = config['user']
		@pass = config['pass']
		@hours_per_working_day = config['hours_per_working_day'].to_f
	end

	def create_headers
		auth = Base64.encode64("#{@user}:#{@pass}").delete("\r\n")
		@headers =  {accept: 'application/json', content_type: 'application/json', authorization: "Basic #{auth}"}
	end

	def request(params_str)
		url = "https://#{@subdomain}.harvestapp.com/#{params_str}"
		r = RestClient.get(url, @headers)
		JSON.load(r)
	end
end

start_date = Date.parse(ARGV[0])
aiwtl = AIWTL.new
aiwtl.am_i_working_too_long?(start_date)