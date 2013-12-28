#curb gem
require 'Curl'

#json gem
require 'json'


require 'pp'

$api_username = 'justin@mkshft.org'
$api_secret_file = '../supersecret.txt'
$api_useragent_string = 'User-Agent: UUAnalyticator (justin@mkshft.org)'
$api_project_number = '2378353'

#shhh
def import_secret(filename)
  File.open("#{filename}", "r").read
end

def make_api_call(method_string)
  c = Curl::Easy.new("https://basecamp.com/#{$api_project_number}/api/v1/#{method_string}")
  c.http_auth_types = :basic
  c.username = $api_username
  c.password = import_secret($api_secret_file)
  c.useragent = $api_useragent_string
  c.perform
  return c.body_str
end


def get_events_since(time)
  count = 1
  
  events_response = JSON.parse(make_api_call("events.json?since=#{time}"))
  events_array = events_response
  
  until events_response.empty?
    count += 1
    events_response = JSON.parse(make_api_call("events.json?since=#{time}&page=#{count}"))
    events_array += events_response
  end
  puts "Added #{count} arrays"
  return events_array
end
    
    
  
events_array = get_events_since("2013-12-01T11:00:00-06:00")

events_array.each do |event|
  puts "On #{event['created_at']}, #{event['creator']['name']} #{event['action']}"
end

