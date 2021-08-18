#2021-08-17
require "sinatra"
require "slim"
require "sqlite3"
require_relative "model.rb"

enable :sessions

get("/")


get("/catalog") do 
    classmates = get_classmate_data()
    slim(:"/catalog", locals:{classmates:classmates})
end