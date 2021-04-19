#CapitalDifference

class CapitalDifference
	attr_accessor :date, :key, :buy_price, :sell_price, :units

	def initialize(date, key, buy_price, sell_price, units)
		@date = date
		@key = key
		@buy_price = buy_price
		@sell_price = sell_price
		@units = units
	end

	def to_s
		"#{date} - #{key} : Buy for #{buy_price.round(2)}$ - Sell for #{sell_price.round(2)}$ - Result: #{(sell_price-buy_price).round(2)}$ - Units : #{units}"
	end


end