def get_classmate_data() 
    db = SQLite3::Database.new("db/classlistbra.db")
    db.results_as_hash = true
    classmates = db.execute("SELECT * FROM classmates")
    return classmates
end

def get_grades()
    db = SQLite3::Database.new("db/classlistbra.db")
    db.results_as_hash = true
    grades = db.execute("SELECT grade FROM classmates")
    grades.uniq!
end