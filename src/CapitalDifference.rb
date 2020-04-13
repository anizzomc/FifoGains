#CapitalDifference

class CapitalDifference
	attr_accessor :date, :key, :difference

	def initialize(date, key, difference)
		@date = date
		@key = key
		@difference = difference
	end

	def to_s
		"#{date} - #{key} : #{difference}"
	end


end