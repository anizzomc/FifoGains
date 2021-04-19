# Fifo.rb
require './src/CapitalDifference.rb'
require './src/VoidReporter.rb'
require './src/NegativeAmountError.rb'

class Fifo

	def initialize (transactions, reporter = VoidReporter.new)
		@transactions = transactions.clone
		@holdings = Hash.new {|hash, key| hash[key] = {:qty => 0, :bookcost=>0} }
		@reporter = reporter
	end

	def process
		transactions = @transactions.clone
		result = []

		for i in 0..@transactions.size-1
			record(@transactions[i])

			transaction = @transactions[i]
			holding = @holdings[transaction.key]

			if transaction.buy?
				holding[:qty] += transaction.qty
				holding[:bookcost] += transaction.value
			end

			if @transactions[i].sell? and @transactions[i].qty > 0
				raise NegativeAmountError.new("Cannot hold negative amount : #{transaction}") if holding[:qty] - transaction.qty < 0
				holding[:qty] -= transaction.qty

				key = @transactions[i].key
				date = @transactions[i].date
				diff = 0
				bookcost = 0
				sell_value = 0
				units = 0


				for j in 0..i-1
					if @transactions[j].buy? and @transactions[j].key == key and @transactions[j].qty > 0
						ret = @transactions[j].apply(@transactions[i])

						sell = ret[:sell]						
						holding[:bookcost] -= ret[:qty]*@transactions[j].price
						bookcost += ret[:qty]*@transactions[j].price
						sell_value += ret[:sell_value]
						units += ret[:qty]

						@reporter.report("#{sell.date} Selling #{ret[:qty]} #{sell.key} for #{sell.price} - Capital Gain: #{ret[:result]}")

						diff += ret[:result]


						@transactions[j] = ret[:buy]
						@transactions[i] = ret[:sell]


						break if ret[:sell].qty == 0

					end
				end
				result.push(CapitalDifference.new(date, key, bookcost, sell_value, units))

			end


			@holdings[transaction.key] = holding
			@reporter.report("Holding #{holding[:qty]} #{transaction.key} with Bookcost of #{holding[:bookcost]}")
		end
		result
	end


	def record (transaction)
		@reporter.report("#{transaction.date} #{transaction.sell?? "SELL" : "BUY"} #{transaction.qty} #{transaction.key} for $#{transaction.price}$ each - Total: $#{transaction.value}" )
	end






end
