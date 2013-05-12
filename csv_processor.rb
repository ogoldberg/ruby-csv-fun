#!/usr/bin/env ruby
require 'csv'
require 'tempfile'
# create temp files
@commatemp = Tempfile.new("commatemp")
@pipetemp = Tempfile.new("pipetemp")
@spacetemp = Tempfile.new("spacetemp")
@tempfiles = [@commatemp, @pipetemp, @spacetemp]
@final_result = File.new("output.txt", "w+")

begin
	# import each data file into a temp file with matching header row and correct formatting
	def import_to_csv
		col = ["LastName ", "FirstName ", "Gender ", "DateOfBirth ", "FavoriteColor "]
		File.open(@commatemp, 'a') do |f|
			f.write("#{col[0]} #{col[1]} #{col[2]} #{col[4]} #{col[3]}\n")
			f << File.open("data/comma.txt").read.gsub(/, /, " ") + "\n"
			puts File.read(f)
		end
		File.open(@pipetemp, 'a') do |f|
			f.write("#{col[0]} #{col[1]} MiddleInitial #{col[2]} #{col[4]} #{col[3]}\n")
			f << File.open("data/pipe.txt").read.gsub(/ \| /, " ").gsub(/-/, "/") + "\n"
		end
		File.open(@spacetemp, 'a') do |f|
			f.write("#{col[0]} #{col[1]} MiddleInitial #{col[2]} #{col[3]} #{col[4]}\n")
			f << File.open("data/space.txt").read.gsub(/-/, "/") + "\n"
		end
	end

	# convert each new, properly formatted (but separate) csv into a collection of hashes 
	# then process the hashes into a single data set with consistent gender labeling
	def process_csv
		@sort_table = []
		@tempfiles.each do |datafile|
			File.open(datafile) do |file|
				hashify(file)
				gender_fix(file)
			end
		end
	end

ensure
	#take out the trash
	@tempfiles.each do |file|
		file.close
		file.unlink
	end
end

def hashify(file)
	columns = file.readline.chomp.split(" ")
	until file.eof?
		row = file.readline.chomp.split(" ")
		row = columns.zip(row).flatten
		@sort_table << Hash[*row]
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

#sort by various critera and write to output.txt using the required column order
def output
	File.open(@final_result, "a")
	#output1
	@final_result.puts("Output 1:")
	@sort_table = @sort_table.sort{|a,b| [a['Gender'], a['LastName']] <=> [b['Gender'], b['LastName']]}
	print_it

	#output2
	@final_result.puts("\nOutput 2:")
	@sort_table.each {|p| p['DateOfBirth'] = Date.strptime(p['DateOfBirth'], "%m/%d/%Y") }
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

import_to_csv
process_csv
output