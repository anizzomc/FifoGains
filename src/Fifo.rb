# Fifo.rb
require './src/CapitalDifference.rb'
require './src/VoidReporter.rb'
require './src/NegativeAmountError.rb'

class Fifo

	def initialize (transactions, reporter = VoidReporter.new)
		@transactions = transactions.clone
		@holdings = Hash.new (0)
		@reporter = reporter
	end

	def process
		transactions = @transactions.clone
		result = []

		for i in 0..@transactions.size-1

			record(@transactions[i])

			if @transactions[i].sell? and @transactions[i].qty > 0
				key = @transactions[i].key
				date = @transactions[i].date
				diff = 0


				for j in 0..i-1
					if @transactions[j].buy? and @transactions[j].key == key and @transactions[j].qty > 0
						ret = @transactions[j].apply(@transactions[i])

						sell = ret[:sell]						

						@reporter.report("#{sell.date} Selling #{ret[:qty]} #{sell.key} for #{sell.price} - Capital Gain: #{ret[:result]}")

						diff += ret[:result]


						@transactions[j] = ret[:buy]
						@transactions[i] = ret[:sell]

						break if ret[:sell].qty == 0

					end
				end
				result.push(CapitalDifference.new(date, key, diff))

			end
		end
		result
	end


	def record (transaction)
		holding = @holdings[transaction.key]

		if transaction.sell?
			raise NegativeAmountError.new("Cannot hold negative amount : #{transaction}") if holding - transaction.qty < 0
			holding -= transaction.qty
		else
			holding += transaction.qty
		end

		@holdings[transaction.key] = holding

		@reporter.report("#{transaction.date} #{transaction.sell?? "SELL" : "BUY"} #{transaction.qty} #{transaction.key} : Result #{holding} Value: #{holding*transaction.price}")
	end






end
