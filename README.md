# The Sharpspring Ruby Gem

This gem still requires some extensive testing, but should be a decent starting place if you are integrating sharpspring with your app. This gem is not yet published and is in a pre-alpha state.

## Example Usage
```
require 'sharpspring'

sharpspring = Sharpspring.new('my_account_id', 'my_secret_key')
page = 0
loop do
  leads = sharpspring.get_objects('lead', page)
  page += 1
  puts "found #{leads.count} leads"
  break if leads.empty?
end

lead_list = [{emailAddress: 'test@test.com', firstName: 'nick', lastName: 'bryant'}]
result = sharpspring.create_objects('lead', lead_list)
puts "result of creating objects: #{result}"
```
