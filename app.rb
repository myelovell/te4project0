require 'sqlite3'
require_relative "model.rb"
require "sinatra"
require "slim"

enable :sessions

get("/") do 
    slim(:layout)
end

get("/memory") do 
    slim(:memoryGame)
end 

get("/catalog") do 
    classmates = get_classmate_data()
    slim(:"catalog", locals:{classmates:classmates})
end



begin
    db = SQLite3::Database.open "db/classlistbra.db"

    stm = db.prepare "SELECT * FROM classmates" 
    rs = stm.execute 
    
    rs.each do |row|
        puts row.join "\s"
    end
    
rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    puts e
    
end







