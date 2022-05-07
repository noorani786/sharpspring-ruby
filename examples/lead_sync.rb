require 'lib/sharpspring'

sharpspring = Sharpspring.new('account_id', 'secret_key')
page = 0
leads = []
loop do
  leads = sharpspring.get_objects('lead', page)
  page += 1
  puts "found #{leads.count} leads"
  break if leads.empty?
end

lead_list = [{emailAddress: 'test@test.com', firstName: 'nick', lastName: 'bryant'}]
result = sharpspring.create_objects('lead', lead_list)
puts "result of creating objects: #{result}"

sharpspring.delete_objects('lead', [{ "id": result[0]['id'].to_s }])
