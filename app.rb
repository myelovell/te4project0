require 'sqlite3'

begin
    db = SQLite3::Database.open "db/classlistbra.db"

    stm = db.prepare "SELECT * FROM classmates" 
    rs = stm.execute 
    
    rs.each do |row|
        puts row.join "\s"
    end
    
rescue SQLite3::Exception => e 
    
    puts "Exception occurred"
    puts e
    
ensure
    db.close if db
end