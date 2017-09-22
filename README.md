# stackconnect

Ruby API for making StackOverflow queries. This is a limited number of the API calls that can be made to the StackOverflow API, mainly dealing with tags, questions, and users. 

## Software Versions

This has been tested and written for Rails 4.0 and above, and Ruby 2.0.0 and above. 

## Installation

In your Gemfile, add this line:

    gem 'stackconnect'

And then execute:

    $ bundle 

Or install it yourself as:

    $ gem install stackconnect

If you want the most current version of the gem, in your Gemfile, add this:
    
    gem 'stackconnect', :git => 'git://github.com/stackgems/stackconnect.git'

## Usage

These methods are quota restricted. The Stack Exchange API only allows a quota of 10,000 without an API key: http://api.stackexchange.com/docs/authentication. Once you get over that quota without a key, your IP address will be throttled from making any more requests until the next day. 

If you get an API key, your limit will still be 10,000 (per application), with a limit of 5 applications. 

### Retrieve Total Number of Questions 
```
 sc = StackConnect.new
 total = sc.retrieve_total_questions(from_date)
```

This will return a Ruby Fixnum.

`fromdate` has to be in Unix date format. So for example, to retrieve the total number of questions from yesterday:

```
 date = Date.today.to_time.to_i
 total = sc.retrieve_total_questions(from_date)
```

### Retrieve Most Popular Tags of All Time

The default sort is `popular`, and the order is `desc` in order to list the most popular tags first. 

`data = sc.retrieve_most_popular_tags`

This will return a JSON data object which you can then parse. An example:

```
data["items"].each do |trend|
   puts trend["name"]
end
```

The data looks like this:
```json 
{
  "items": [
    {
      "has_synonyms": false,
      "is_moderator_only": false,
      "is_required": false,
      "count": 127787,
      "name": "c"
    },
    {
      "has_synonyms": true,
      "is_moderator_only": false,
      "is_required": false,
      "count": 268773,
      "name": "python"
    },
    {
      "has_synonyms": true,
      "is_moderator_only": false,
      "is_required": false,
      "count": 18729,
      "name": "variables"
    },
  ],
  "has_more": true,
  "backoff": 10,
  "quota_max": 10000,
  "quota_remaining": 9973
}
```

### Retrieving the Most Popular Tags from a Particular Date

The way StackOverflow handles date ranges for tags is not what you would expect: the count returned with each tag is actually the all-time count for that tag, not the count of the tag for that particular day, or date range. If you want to get the total number of tags for a particular day, you would have to parse the `/questions` API call return data, and iterate through all the questions for that day.

When you give a date range for the `/tags` call, the `'todate'` parameter is ignored, and will give the same response if it wasn't included at all. However, querying StackOverflow with a `'fromdate'` and sorting on `'popular'` will return the most popular tags for that particular time. Therefore, given the way the data is returned, `retrieve_tags(from_date)` already sorts on popular by default, otherwise, the data isn't very meaningful.

The date range is also restricted to be after January 1st, 2009. If a date before this time is given inside the query, an exception will be thrown. 

If the API call is given any other sort type, such as `'popular'` or `'name'`, and the fromdate is before January 1st, 2009, StackOverflow will return the most popular tags of all time. If the sort type is `'activity'`, no data will be returned. 

The order is also `'desc'` (descending) by default, so that the most popular tags are shown first. 

`data = StackConnect.retrieve_tags(from_date)`

Sample Data:

```json
{
  "items": [
    {
      "has_synonyms": false,
      "is_moderator_only": false,
      "is_required": false,
      "count": 1,
      "name": "microsoft-net-http"
    },
    {
      "has_synonyms": false,
      "is_moderator_only": false,
      "is_required": false,
      "count": 1,
      "name": "mlt"
    },
  ],
  "has_more": true,
  "quota_max": 10000,
  "quota_remaining": 9972
}
```

### Retrieving User Data

This call will retrieve all time user data, since the creation of the site. When making this API call, check for the `'has_more'` attribute to see if there are more pages. If `'has_more'` returns true, then increase the `'page'` parameter before calling the function again to retrieve the next page of data.

The query is called with a sort on `'reputation'`, and ordered in descending order. Therefore, the users with the highest reputation will appear first. 

```
  sc = StackConnect.new
  data = sc.retrieve_users(1)
```

Sample data:

```
{
  "items": [
    {
      "badge_counts": {
        "bronze": 5498,
        "silver": 4081,
        "gold": 261
      },
      "account_id": 11683,
      "is_employee": false,
      "last_modified_date": 1394538684,
      "last_access_date": 1394629373,
      "reputation_change_year": 21465,
      "reputation_change_quarter": 21465,
      "reputation_change_month": 3600,
      "reputation_change_week": 1085,
      "reputation_change_day": 215,
      "reputation": 656402,
      "creation_date": 1222430705,
      "user_type": "registered",
      "user_id": 22656,
      "age": 37,
      "accept_rate": 83,
      "location": "Reading, United Kingdom",
      "website_url": "http://csharpindepth.com",
      "link": "http://stackoverflow.com/users/22656/jon-skeet",
      "display_name": "Jon Skeet",
      "profile_image": "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=128&d=identicon&r=PG"
    }
  ],
  "has_more": true,
  "quota_max": 10000,
  "quota_remaining": 9990
}
```
The sample data here only has one item, normally, you'd get the first 30 results. In order to check if there is more data:

```
has_more = data["has_more"]
```
If `'has_more'` returns true, then increase the page count, and call again:

```
page = 1
begin
  data = sc.retrieve_users(page)

  # work with data
  ..

  has_more = data["has_more"]
  page += 1
  sleep(1)
end while has_more == true
 
```

Make sure that in before making the call, you call `sleep()` for at least one second, otherwise, the StackExchange API will throttle your requests and require you to wait a certain amount of time before making another request. Usually increasing this time to about 10 seconds will guarantee your calls won't get throttled for the remainder of the pages. 

## Contributing

1. Fork it ( http://github.com/[my-github-username]/stack-connect/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
