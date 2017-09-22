require File.expand_path("../../lib/stackconnect", __FILE__)

describe StackConnect do 
  before do 
    @connect = StackConnect.new
    puts @connect.api
  end

  it "retrieve questions should return an integer " do
    date = Date.today.to_time.to_i
    @connect.retrieve_total_questions(date).to_i.should be_a(Fixnum)
  end

  it "retrieve popular tags should return json object" do
    @connect.retrieve_most_popular_tags.should be_a(Hash)
  end 

  it "retrieve tags should be hash" do
    date = Date.today.to_time.to_i
    @connect.retrieve_tags(date).should be_a(Hash)
  end

  it "should raise date error" do
    date = 1230793200
    lambda {@connect.retrieve_tags(date)}.should raise_error
  end

  it "retrieve hot questions returns json object" do 
    date = Date.today.to_time.to_i
    @connect.retrieve_hot_questions(date, 1).should be_a(Hash)
  end

  it "retrieve users returns object" do 
    @connect.retrieve_users(1).should be_a(Hash)
  end
end
    
