# FifoTest.rb

require './src/Fifo.rb'
require './src/Transaction.rb'
require './src/NegativeAmountError.rb'

describe Fifo do

	it "calculates capital gain between 2 transactions" do
		transactions = [
			Transaction.new("20200412", "BOND", 1, 1, :buy),
			Transaction.new("20200413", "BOND", 1, 1.1, :sell)
		]

		result = Fifo.new(transactions).process

		expect(result.size).to eq(1)
		expect(result[0].key).to eql "BOND"
		expect(result[0].date).to eql "20200413"
		expect(result[0].difference - 0.1).to be < 0.0001
	end

	it "calculates capital gain between 3 transactions" do
		transactions = [
			Transaction.new("20200412", "BOND", 2, 1, :buy),
			Transaction.new("20200413", "BOND", 1, 1.1, :sell),
			Transaction.new("20200414", "BOND", 1, 1.2, :sell)
		]

		result = Fifo.new(transactions).process

		expect(result.size).to eq(2)
		expect(result[0].difference - 0.1).to be < 0.0001
		expect(result[1].difference - 0.2).to be < 0.0001

	end

	it "calculates capital gain with 2 species" do
		transactions = [
			Transaction.new("20200412", "BOND", 1, 1, :buy),
			Transaction.new("20200412", "STOCK", 1, 2, :buy),
			Transaction.new("20200413", "STOCK", 1, 2.2, :sell),
			Transaction.new("20200413", "BOND", 1, 1.1, :sell)
		]

		result = Fifo.new(transactions).process

		expect(result.size).to eq(2)

		expect(result[0].difference - 0.2).to be < 0.0001
		expect(result[0].key).to eql "STOCK"
		expect(result[0].date).to eql "20200413"

		expect(result[1].difference - 0.1).to be < 0.0001
		expect(result[1].key).to eql "BOND"
		expect(result[1].date).to eql "20200413"
	end

	it "calculates capital loss" do 
		transactions = [
			Transaction.new("20200412", "BOND", 1, 1, :buy),
			Transaction.new("20200412", "BOND", 1, 0.9, :sell)
		]

		result = Fifo.new(transactions).process

		expect(result.size).to eq(1)

		expect(result[0].difference - (-0.1)).to be < 0.0001
		expect(result[0].key).to eql "BOND"
		expect(result[0].date).to eql "20200412"

	end



	it "raises exception when sell goes to negative" do
		transactions = [
			Transaction.new("20200412", "BOND", 1, 1, :buy),
			Transaction.new("20200413", "BOND", 2, 1, :sell)
		]

		fifo = Fifo.new(transactions)

		expect { fifo.process } .to raise_error (NegativeAmountError)
	end


end