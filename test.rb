#!/usr/bin/env ruby
require 'csv'

# create temp files
@commatemp = File.new("tmp/" + Time.now.to_s + "commatemp.csv", "a")
@pipetemp = File.new("tmp/" + Time.now.to_s+ "pipetemp.csv", "a")
@spacetemp = File.new("tmp/" + Time.now.to_s + "spacetemp.csv", "a")
@tempfiles = [@commatemp, @pipetemp, @spacetemp]
@organized_file = File.new("organized_file.csv", "w+")
@final_result = File.new("output.txt", "w+")

@col = ["LastName ", "FirstName ", "Gender ", "DateOfBirth ", "FavoriteColor "]

# import each data file into a new file with matching header row and correct formatting
def import_to_csv
	File.open(@commatemp, 'a') do |f|
		f.write("#{@col[0]} #{@col[1]} #{@col[2]} #{@col[4]} #{@col[3]}\n")
		f << File.open("data/comma.txt").read.gsub(/, /, " ").gsub(/-/, "/") + "\n"
		puts File.read(f)
	end
	File.open(@pipetemp, 'a') do |f|
		f.write("#{@col[0]} #{@col[1]} MiddleInitial #{@col[2]} #{@col[4]} #{@col[3]}\n")
		f << File.open("data/pipe.txt").read.gsub(/ \| /, " ").gsub(/-/, "/") + "\n"
	end
	File.open(@spacetemp, 'a') do |f|
		f.write("#{@col[0]} #{@col[1]} MiddleInitial #{@col[2]} #{@col[3]} #{@col[4]}\n")
		f << File.open("data/space.txt").read.gsub(/-/, "/") + "\n"
	end
end

def gender_fix(row)
	@sort_table.each do |row|
		if row["Gender"] == "M"
			male = {"Gender" => "Male"}
			row.merge!(male)
		elsif row["Gender"] == "F"
			female = {"Gender" => "Female"}
			row.merge!(female)
		end
	end
end

def hashify(file)
	columns = file.readline.chomp.split(" ")
	@table = []
	until file.eof?
		row = file.readline.chomp.split(" ")
		row = columns.zip(row).flatten
		@table << Hash[*row]
		@sort_table << Hash[*row]
	end
end

# convert each new, properly formatted (but separate) csv into a collection of hashes 
# then process the hashes into a new csv as a single data set in the correct column order
def process_csv
	@sort_table = []
	File.open(@organized_file)
	@col.each do |i|
		@organized_file.write(i)
	end
	@organized_file.write("\n")
	@tempfiles.each do |datafile|
		File.open(datafile) do |file|
			hashify(file)
			gender_fix(file)
		end
		@table.each do |r|
			@organized_file.puts("#{r['LastName']} #{r['FirstName']} #{r['Gender']} #{r['DateOfBirth']} #{r['FavoriteColor']}\n")
		end
	end
end



def output1
	File.open(@final_result, "a")
	@final_result.puts("Output 1:")
	@sort_table = @sort_table.sort{|a,b| [a['Gender'], a['LastName']] <=> [b['Gender'], b['LastName']]}
	@sort_table.each do |r|
		@final_result.puts("#{r['LastName']} #{r['FirstName']} #{r['Gender']} #{r['DateOfBirth']} #{r['FavoriteColor']}\n")
	end
end

def output2
	File.open(@final_result, "a")
	@final_result.puts("\nOutput 2:")
	@sort_table.each do |p|
		p['DateOfBirth'] = Date.strptime(p['DateOfBirth'], "%m/%d/%Y")
	end

	@sort_table = @sort_table.sort{|a,b| a['DateOfBirth']<=>b['DateOfBirth']}
	@sort_table.each do |r|
		r['DateOfBirth'] = r['DateOfBirth'].to_s.gsub(/-/,'/')
		@final_result.puts("#{r['LastName']} #{r['FirstName']} #{r['Gender']} #{r['DateOfBirth']} #{r['FavoriteColor']}\n")
	end
end

def output3
	File.open(@final_result, "a")
	@final_result.puts("\nOutput 3:")
	@sort_table = @sort_table.sort{|a,b| a['LastName']<=>b['LastName']}.reverse
	@sort_table.each do |r|
		@final_result.puts("#{r['LastName']} #{r['FirstName']} #{r['Gender']} #{r['DateOfBirth']} #{r['FavoriteColor']}\n")
	end
end

import_to_csv
process_csv
output1
output2
output3



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

