# Transations.rb
require './src/Transaction.rb'

# Your Transactions here

TRANSACTIONS = [
	Transaction.new("20171021", "BTC", 0.03294,	6071.64, :buy),
	Transaction.new("20171102", "BTC", 0.00712561, 7016.94, :sell),
	Transaction.new("20171111", "BTC", 0.007827, 6388.14, :buy),
	Transaction.new("20171113", "BTC", 0.014845, 6736.27, :buy),
	Transaction.new("20171117", "BTC", 0.00652550, 7662.24, :buy),
	Transaction.new("20171128", "BTC", 0.00509294, 9817.51, :sell),
	Transaction.new("20171130", "BTC", 0.00537050, 9310.12, :buy),
	Transaction.new("20171206", "BTC", 0.00384857, 12991.82, :sell),
	Transaction.new("20171208", "BTC", 0.01246513, 16044.75, :sell),
	Transaction.new("20171223", "BTC", 0.01982141, 15135.14, :buy),
	Transaction.new("20180116", "BTC", 0.01749522, 11431.68, :buy),
	Transaction.new("20200410", "BTC", 0.00145963, 6758.06, :buy), # Balance Adjustment
]