require "./Transactions.rb"
require "./src/Fifo.rb"


fifo = Fifo.new (TRANSACTIONS)

result =  fifo.process
puts "------ Capital Gains ------"
puts result

