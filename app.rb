#2021-08-17
require "sinatra"
require "slim"
require "sqlite3"

enable :sessions

get("/")