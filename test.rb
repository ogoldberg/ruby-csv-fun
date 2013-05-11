require 'csv'

def newfiles
	@tempfile = File.new(Time.now.to_s + ".csv", "a")
	@endfile = File.new(Time.now.to_s + ".csv", "a")
end

def add_headers
	File.open(@tempfile, 'w+') do |f| 
		f.puts("LastName FirstName Gender FavoriteColor DateOfBirth")
	end
end

def import_csv
	data_files = Dir["data/*"]
	data_files.each do |d|
		replace = " "
		File.open(@tempfile, 'a') do |f|
			f << File.open(d).read.gsub(/, | \|/, " ").gsub(/-/, "/") + "\n"
		end

	end
end

def csv(separator)
	File.open(@endfile)
		File.open(@tempfile) do |f|
			columns = f.readline.chomp.split(separator)
			table = []
			until f.eof?
				row = f.readline.chomp.split(separator)
				row = columns.zip(row).flatten
				table << Hash[*row]
			end
			File.open(@endfile, 'a') do |e|
				table.each do |r|
					newrow = "#{r['LastName']} #{r['FirstName']} #{r['Gender']} #{r['DateOfBirth']} #{r['FavoriteColor']}"
					e.puts(newrow)
				end
				puts "wahooo!"
				puts File.read(@endfile)

			end
		end
end

# def csv_to_hash
# 	@people = {}
# 	CSV.foreach(@tempfile, :headers => true, :header_converters => :symbol, :converters => :all) do |row|
# 	  @people[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
# 	end
# 	puts @people
# end



# def hash_to_csv(people)
# 	CSV.open("data.csv", "wb") {|csv| people.to_a.each {|elem| csv << elem} }
# end

# def sort_by(value)
# 	@sort_me = []
# 	@people.each do |person|
# 		@sort_me.push(person)
# 		puts '1'*50
# 		puts @sort_me
# 	end
# 	sorted = @sort_me.sort_by { |k| k[value] }
# 	puts '8'*80
# 	puts @sort_me
# end

#COMMA.TXT
#add appropriate headers to new file
newfiles
add_headers
#append content from comma.txt to new file
import_csv
#convert newfile csv contents to hash, using top row as headers
#csv_to_hash
#hash_to_csv(@people)
#sort_csv
csv(',')
