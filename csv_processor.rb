#!/usr/bin/env ruby
require 'csv'

@final_result = File.new("output.txt", "w+")

# import each data file directly into one big hash
def import_data
	col = ["LastName", "FirstName", "MiddleInitial", "Gender", "DateOfBirth", "FavoriteColor"]
	
	@sort_table = []
	keys = [col[0], col[1], col[3], col[5], col[4]]
	hashify("data/comma.txt", ", ", keys)

	keys = [col[0], col[1], col[2], col[3], col[5], col[4]]
	hashify("data/pipe.txt", " | ", keys)

	keys = [col[0], col[1], col[2], col[3], col[4], col[5]]
	hashify("data/space.txt", " ", keys)
end

def hashify(file, delimiter, keys)
	temp_array = CSV.read(file, { :col_sep => delimiter}).map {|a| Hash[*keys.zip(a).flatten]}
	temp_array.each do |p|
		@sort_table << p
	end
end

def clean_data
	@sort_table.each do |row|
		if row["Gender"] == "M"
			male = {"Gender" => "Male"}
			row.merge!(male)
		elsif row["Gender"] == "F"
			female = {"Gender" => "Female"}
			row.merge!(female)
		end
		row['DateOfBirth'] = row['DateOfBirth'].gsub(/-/, "/")		
	end
end

#sort by user requested criteria and write to output.txt using the desired column order
def output
	File.open(@final_result, "a")
	#output1
	@final_result.puts("Output 1:")
	@sort_table = @sort_table.sort{|a,b| [a['Gender'], a['LastName']] <=> [b['Gender'], b['LastName']]}
	print_it

	#output2
	@final_result.puts("\nOutput 2:")
	#convert the DateOfBirth string into a Date object, use it to sort, and then convert it back to a string again
	@sort_table.each do |p| 
		p['DateOfBirth'] = Date.strptime(p['DateOfBirth'], "%m/%d/%Y")
	end
	@sort_table = @sort_table.sort{|a,b| [a['DateOfBirth'], a['LastName']] <=> [b['DateOfBirth'], b['LastName']]}
	@sort_table.each {|r| r['DateOfBirth'] = r['DateOfBirth'].strftime("%-m/%-d/%Y")}
	print_it

	#output3
	@final_result.puts("\nOutput 3:")
	@sort_table = @sort_table.sort{|a,b| a['LastName']<=>b['LastName']}.reverse
	print_it

	puts "All your data is now processed. Please open output.txt to find your results."
end

def print_it
	@sort_table.each do |r| 
		@final_result.puts(
		"#{r['LastName']} #{r['FirstName']} #{r['Gender']} #{r['DateOfBirth']} #{r['FavoriteColor']}\n")
	end
end

import_data
clean_data
output