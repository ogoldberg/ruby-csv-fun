require 'csv'
 
csv_text = File.read('test.csv')
csv = CSV.parse(csv_text, :headers => true)
 
csv.each do |row|                                       
    puts "Name: #{row['name']} - Age: #{row['age']} -  Sex: #{row['sex']}"
end