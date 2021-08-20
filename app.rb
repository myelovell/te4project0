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
    array_with_id = []
    classmates.each do |mate|
        array_with_id << mate["id"]
    end
    right_choice_id = array_with_id.shuffle[0] 
    slim(:"memoryGame", locals:{classmates:classmates, right_choice_id:right_choice_id, array_with_id:array_with_id})
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
    @filename = params[:file][:filename]
    file = params[:file][:tempfile]

    File.open("public/img/students/#{@filename}", "wb") do |f|
        f.write(file.read)
    end

   db.execute("INSERT INTO classmates (name, img) VALUES (?, ?)", name, @filename)
   redirect("/catalog")
end

# TODO: kolla om fil är uppladdad eller inte, eller om namn saknas (att bara bilden är ändrad)
# om fil ej är uppladdad ska endast namn ändras, vice versa // linus
post("/classlist/:id/update") do
    db = SQLite3::Database.new("db/classlistbra.db")
    db.results_as_hash = true 

    id = params[:id].to_i
    name = params[:name]
    @filename = params[:file][:filename]
    file = params[:file][:tempfile]

    File.open("public/img/students/#{@filename}", "wb") do |f|
        f.write(file.read)
    end

    db.execute("UPDATE classmates SET name=?,img=? WHERE id=?", name, @filename, id)
    redirect("/classlist")
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

post('/classlist/upload-image') do
    db = SQLite3::Database.new('db/classlistbra.db')

    redirect('/classlist')
end