require 'sinatra'
require 'browser'
require 'date'
require 'pony'
require 'instagram'
require 'sinatra/flash'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => (ENV['SESSION_KEY'] || 'super secret')

Instagram.configure do |config|
  config.client_id = ENV['INSTAGRAM_CLIENT_ID']
  config.client_secret = ENV['INSTAGRAM_CLIENT_SECRET']
end

get '/' do
  ua = request.user_agent
  @browser = Browser.new(:ua => ua, :accept_language => "en-us")
  erb :home
end

get '/fun' do
  @couple_start = Date.parse('2005-07-29')
  @wedding = Date.parse('2014-09-27')
  @today = Date.today()
  erb :fun
end

get '/rsvp' do
  erb :rsvp
end

post '/rsvp' do
  Pony.mail(
    :to => 'elgt1014@gmail.com',
    :cc => 'brendansudol@gmail.com',
    :subject => "Wedding RSVP",
    :body => params,
    :port => '587',
    :via => :smtp,
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => 'thenitpickster',
      :password             => ENV['EMAIL_PASSWORD'],
      :authentication       => :plain,
      :domain               => 'gmail.com'
    })
  flash[:success] = "Success!"
  redirect '/'
end

get '/details' do
  erb :details
end

get '/stay_and_play' do
  erb :stay_and_play
end

get '/people' do
  erb :people
end

get '/registry' do
  erb :registry
end

get '/pics' do
  begin
    access_token = ENV['INSTAGRAM_ACCESS_TOKEN'] || ''
    @media = get_all_pics(access_token)
  rescue
    @media = []
  end
  erb :pics
end

def get_all_pics(access_token)
  client = Instagram.client(:access_token => access_token)
  pics = []
  next_id=1e100
  while next_id != nil
    data = client.tag_recent_media("meetthesudols", {:max_id => next_id, :count => 100})
    next_id = data.pagination.next_max_id
    pics.concat(data)
  end
  return pics
end
