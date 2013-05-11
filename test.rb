require 'csv'

# create temp files
@commatemp = File.new("tmp/" + Time.now.to_s + "commatemp.csv", "a")
@pipetemp = File.new("tmp/" + Time.now.to_s+ "pipetemp.csv", "a")
@spacetemp = File.new("tmp/" + Time.now.to_s + "spacetemp.csv", "a")
@tempfiles = [@commatemp, @pipetemp, @spacetemp]
@organized_file = File.new("endfile.csv", "w+")

# import each data file into a new file with matching header row and correct formatting
def import_to_csv
	File.open(@commatemp, 'a') do |f|
		f.puts("LastName FirstName Gender FavoriteColor DateOfBirth")
		f << File.open("data/comma.txt").read.gsub(/,/, " ").gsub(/-/, "/") + "\n"
		puts File.read(f)
	end
	File.open(@pipetemp, 'a') do |f|
		f.puts("LastName FirstName MiddleInitial Gender FavoriteColor DateOfBirth")
		f << File.open("data/pipe.txt").read.gsub(/\|/, " ").gsub(/-/, "/") + "\n"
	end
	File.open(@spacetemp, 'a') do |f|
		f.puts("LastName FirstName MiddleInitial Gender DateOfBirth FavoriteColor")
		f << File.open("data/space.txt").read.gsub(/-/, "/") + "\n"
	end
end

# convert each new, properly formatted (but separate) csv into a collection of hashes 
# then process the hashes into a new csv as a single data set in the correct column order
def process_csv
	File.open(@organized_file)
	@organized_file.puts("LastName FirstName Gender DateOfBirth FavoriteColor")
	@tempfiles.each do |datafile|
		File.open(datafile) do |f|
			columns = f.readline.chomp.split(" ")
			table = []
			until f.eof?
				row = f.readline.chomp.split(" ")
				row = columns.zip(row).flatten
				table << Hash[*row]
				#puts table
			end
			table.each do |r|
				newrow = "#{r['LastName']} #{r['FirstName']} #{r['Gender']} #{r['DateOfBirth']} #{r['FavoriteColor']}"
				@organized_file.puts(newrow)
			end
		end
	end
end

import_to_csv
process_csv




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

#append content from comma.txt to new file

#convert newfile csv contents to hash, using top row as headers
#csv_to_hash
#hash_to_csv(@people)
#sort_csv

