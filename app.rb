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

get("/classlist") do 
    db = SQLite3::Database.new("db/classlistbra.db")
    db.result_as_hash = true

    #check actual var names later
    id = params[:id].to_i
    name = params[:name]
    img = params[:img]

    result = db.execute("SELECT * From classmates WHERE id=?", id)
    slim(:catalog, locals:{result:result})
end

get("/classlist/new") do
    slim(:"classlist/new")
end 

# TODO: fixa id-ökning
get("/classlist/ids") do
    db = SQLite3::Database.new("db/classlistbra.db")
    db.results_as_hash = true
    
    result = db.execute("SELECT id, name From classmates")
    str = ""
    result.each do |id|
        puts id
    end
    str
end

post("/classlist/new") do
   db = SQLite3::Database.new("db/classlistbra.db")

   name = params[:name]
   img = params[:img]

   db.execute("INSERT INTO classmates (name, img) VALUES (?, ?)", name, img)
   redirect("/catalog")
end

post("/classlist/:id/update") do
    db = SQLite3::Database("db/classlistbra.db")
    db.result_as_hash = true 

    id = params[:id].to_i
    name = params[:name]
    img = params[:img]

    db.execute("UPDATE classmates SET id=?, name=?, img=?", id, name, img)
    redirect("/catalog")
end

get("/classlist/:id/edit") do
    db = SQLite3::Database.new("db/classlistbra.db")
    db.results_as_hash = true 

    id = params[:id].to_i

    result = db.execute("SELECT * FROM classmates WHERE id=?", id).first
    slim(:"/classlist/edit", locals:{result:result})
end

post("/classlist/:id/delete") do 
    db = SQLite3::Database("db/classlistbra.db")
    id = params[:id].to_i

    db.execute("DELETE FROM classmates WHERE id=?", id)
end 







