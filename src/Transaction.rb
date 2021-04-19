class Transaction 
	attr_reader :date, :key, :qty, :price, :type

	def initialize(date, key, qty, price, type) 
		@date = date
		@key = key
		@qty = qty
		@price = price
		@type = type
		raise "qty cannot be negative! #{qty}" if qty < 0
		raise "price cannot be negative! #{price}" if price < 0
	end

	def value
		qty * price
	end


	def apply (sell)
		check (sell)
	
		to_sell = (sell.qty <= qty) ? sell.qty : qty
		{
			buy: Transaction.new(date, key, qty - to_sell, price, :buy),
			sell: Transaction.new(sell.date, sell.key, sell.qty - to_sell, sell.price, :sell),
			qty: to_sell,
			sell_value: to_sell*sell.price,
			result: to_sell*(sell.price - price)
		}
	end

	def check(sell)
	    raise "Cannot apply to a non buy transaction" if !buy?
    	raise "parameter is not a sell transaction" if !sell.sell?
		raise "Intput key #{sell.key} doesn't match #{key}" if !key.eql? (sell.key)
		raise "Sell #{sell.date} happens before buy #{date}" if sell.date < date
	end

	def to_s
		"#{type}:#{date}:#{key}:#{qty}:#{price}"
	end


	def sell?
		type == :sell
	end

	def buy?
		type == :buy
	end

end