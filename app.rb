require 'sqlite3'
require_relative "model.rb"
require "sinatra"
require "slim"

enable :sessions

get("/") do 
    slim(:"index")
end

get("/memory") do 
    classmates = get_classmate_data()
    length = classmates.length
    right_choice_id = rand(1..length) 
    slim(:"memoryGame", locals:{classmates:classmates, right_choice_id:right_choice_id})
end 

get("/catalog") do 
    classmates = get_classmate_data()
    slim(:"catalog", locals:{classmates:classmates})
end



# begin
#     db = SQLite3::Database.open "db/classlistbra.db"

#     stm = db.prepare "SELECT * FROM classmates" 
#     rs = stm.execute 
    
#     rs.each do |row|
#         puts row.join "\s"
#     end
    
# rescue SQLite3::Exception => e 
    
#     puts "Exception occurred"
#     puts e
    
# end







