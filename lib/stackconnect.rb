require 'open-uri'
require 'uri'

class StackConnect
  attr_accessor :api, :site, :uri
  
  @@VERSION = "0.2.0"
  @@api = 'http://api.stackexchange.com/'
  @@site = 'stackoverflow'
  @@api_v = '/2.2/'
  @@uri = URI(@@api)
  @@earliest_date = 1230793200

  def retrieve_users(page)
    args = {:sort=> 'reputation', :page=>page, :pagesize=> 100, :order=>'desc'}
    form_query(@@api_v + 'users', args)
  end

  def retrieve_total_questions(from_date)
    args = {:fromdate=>from_date, :filter => '!--Me6hWI5gUs'}
    data = form_query(@@api_v + 'questions', args) 
    count = data["total"]
  end

  def retrieve_day_popular_tags(from_date)
    args = {:fromdate=>from_date, :sort=>'popular'}
    form_query(@@api_v + 'tags', args)
  end

  def retrieve_most_popular_tags
    args = {:sort=>'popular', :order=>'desc'}
    form_query(@@api_v + 'tags', args)
  end

  def retrieve_tags(from_date, to_date)
    raise "Date is too early, must be after January 1, 2009" if from_date < @@earliest_date
    args = { :fromdate => from_date, :sort=>'popular', :order=>'desc', :todate => to_date}
    form_query(@@api_v + 'tags', args)
  end 

  def retrieve_hot_questions(from_date, page)
    args = {:fromdate => from_date, :sort=>'hot', :order=>'desc', :page=>page, :pagesize=>100}
    form_query(@@api_v + 'questions', args)
  end

  def form_query (path, args)
    args.merge!(:site=>'stackoverflow')
    @@uri.path = path
    @@uri.query = args.to_query
    puts @@uri
    parse
  end

  def parse
    JSON.parse(@@uri.open.read)
  end
   
  def self.return_version
    @@VERSION
  end

end

