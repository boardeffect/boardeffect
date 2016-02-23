# boardeffect

Ruby client for [Version 2 of the BoardEffect API].


## Install

```
$ gem install boardeffect
```


## Quick start

```ruby
require 'boardeffect'

boardeffect = BoardEffect::Client.new(access_token: 'YOUR PERSONAL ACCESS TOKEN', host: 'https://yourportalname.boardeffect.com/')
```