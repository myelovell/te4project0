#2021-08-17
require "sinatra"
require "slim"
require "sqlite3"

enable :sessions

get("/") do 
    slim(:layout)
end

get("/memory") do 
    slim(:memoryGame)
end 

get("/catalog") do 
    slim(:catalog)
end

