# Lemur

Api for Odnoklassniki Social Network

Lemur is a lightweight, flexible Ruby SDK for Odnoklassniki. It allows read/write access to Odnoklassniki API. To work with Lemur you need VALUABLE ACCESS to odnoklassniki api. This api work only with access_token that gives you odnoklassniki, when you authorize with omniauth. 

## Installation

Add this line to your application's Gemfile:

   gem "lemur", "~> 0.0.5"
or instal gem with latest changes
    gem 'lemur', :git => "git@github.com:edikgat/lemur.git"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lemur

## Usage
To use odnoklassniki api methods you should have [VALUABLE ACCESS](http://dev.odnoklassniki.ru/wiki/pages/viewpage.action?pageId=12878032) to odnoklassniki.
###Initialize

    api = Lemur::API.newe(application_secret_key, application_key,  access_token, application_id = nil, refresh_token = nil)

application_id and refresh_token parameter needed only for 'get_new_token' action

###Methods examples

    api.get({method: 'friends.get')

    api.get({method: 'users.getCurrentUser'})

    api.get_new_token

    api.get({method: 'users.getInfo', uids: uid, fields: 'uid,first_name,last_name,current_location,gender,pic_1,pic_2,pic_3,pic_4,pic_5'})
    
[See all api methods here](http://dev.odnoklassniki.ru/wiki/display/ok/Odnoklassniki+REST+API+ru)

    api.get_request({method: 'users.getInfo', uids: uid, fields: 'uid,first_name,last_name,current_location,gender,pic_1,pic_2,pic_3,pic_4,pic_5'})

get_request methods don't use JSON parsing and returns Foreman response

###Gem parameters methods
    api.security_options
    api.request_options
    api.response



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
