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
    studentId = params[:stidentId].to_i
    firstName = params[:firstName]
    surName = params[:surname]
    imgUrl = params[:imgUrl]

    result = db.execute("SELECT * From classlist WHERE studentId=?", studentId)
    slim(:catalog, locals:{studentId:result})

end

get("/classlist/new") do
    slim(:classlist/new)
end 

post("/classlist/new") do
   db = SQLite3::Database.new("db/classlistbra.db")
   firstName = params[:firstName]
   surName = params[:surname]
   #imgUrl = params[:imgUrl] fix correct input later

   db.execute("INSERT INTO classlist (firstName, surname, imgUrl) VALUES (?, ?, ?)", firstName, surname, imgUrl) 

end

post("/classlist/:studentId/update") do
    db = SQLite3::Database("bd/classlistbra.db")
    db.result_as_hash = true 

    studentId = params[:studentId].to_i
    firstName = params[:firstName]
    surname = params[:surname]
    #imgUrl = params[:imgUrl] fix correct input later

    db.execute("UPDATE classlist SET firstName=?, surname=?, imgUrl=?", firstName, surname, imgUrl)
    redirect("/catalog")
end

post("/classlist/:studentId/edit") do 
    db = SQLite3::Database("bd/classlistbra.db")
    db.result_as_hash = true 

    studentId = params[:studentId].to_i

    result = db.execute("SELECT * FROM classlist WHERE studentId=?", studentId).first
    slim(:"/classlist/edit", locals{result:result})
end



post("/classlist/:studentId/delete") do 
    db = SQLite3::Database("bd/classlistbra.db")
    studentId = params[:studentId].to_i

    db.execute("DELETE FROM classlist WHERE studentId=?", studentId)

end 







