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
    classmates = get_classmate_data()
    slim(:"/classlist/index", locals:{classlist:classmates})
end

get("/classlist/new") do
    slim(:"classlist/new")
end

post("/classlist/new") do
   db = SQLite3::Database.new("db/classlistbra.db")

   name = params[:name]
   img = params[:img]

   db.execute("INSERT INTO classmates (name, img) VALUES (?, ?)", name, img)
   redirect("/catalog")
end

post("/classlist/:id/update") do
    db = SQLite3::Database.new("db/classlistbra.db")
    db.results_as_hash = true 

    id = params[:id].to_i
    name = params[:name]
    img = params[:img]

    db.execute("UPDATE classmates SET name=?,img=? WHERE id=?", name, img, id)
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
    db = SQLite3::Database.new("db/classlistbra.db")
    id = params[:id].to_i

    db.execute("DELETE FROM classmates WHERE id=?", id)
    redirect("/classlist")
end 







