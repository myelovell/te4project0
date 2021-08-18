#2021-08-17
require "sinatra"
require "slim"
require "sqlite3"
require_relative "model.rb"

enable :sessions

get("/") do 
    slim(:layout)
end

get("/memory") do 
    slim(:memoryGame)
end 



get("/") do
end

get("/catalog") do 
    classmates = get_classmate_data()
    slim(:"catalog", locals:{classmates:classmates})
end
