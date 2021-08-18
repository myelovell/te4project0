def get_classmate_data() 
    db = SQLite3::Database.new("classlistbra.db")
    db.results_as_hash = true
    classmates = db.execute("SELECT * FROM classmates")
    return classmates
end