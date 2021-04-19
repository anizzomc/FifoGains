# CSVReporter.rb

class CSVReporter

	def initialize(filename="report.csv")
		@file = File.open(filename)

	end

	def report (entry)
		@file.write(entry)
	end

end