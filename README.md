# boardeffect

Ruby client for [Version 3 of the BoardEffect API].


## Install

```
$ gem install boardeffect
```


## Quick start

```ruby
require 'boardeffect'

boardeffect = BoardEffect::Client.new(access_token: 'API KEY', host: 'https://yourportalname.boardeffect.com/')

announcement = boardeffect.create_announcement({title: "This is a test from the console", body: "This is a body description"}, { workroom_id: 2 })
p announcement.inspect

attributes = {title: "Testing api", description: "This is a description", location: "Test location", eventcolor_id: "1", datetime_start: Time.now.to_s, datetime_end: Time.now.to_s}
event = boardeffect.create_event(attributes, { workroom_id: 2 })
p event.inspect
```