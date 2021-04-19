# BuyEntryTest.rb

require './src/Transaction.rb'


describe Transaction do
	let(:buy) { Transaction.new("20200410", "BOND", 10, 1, :buy)}


  it "buy? returns true if transaction is buy" do
  	expect(buy.buy?).to be true
  end

  it "sell? returns false if transaction is buy" do
  	expect(buy.sell?).to be false
  end

   it "buy? returns false if transaction is sell" do
  	expect(Transaction.new("20200411", "BOND", 1, 1.3, :sell).buy?).to be false
  end

  it "sell? returns true if transaction is sell" do
  	expect(Transaction.new("20200411", "BOND", 1, 1.3, :sell).sell?).to be true
  end
 
  it "sells less than it bought before" do
    sell = Transaction.new("20200411", "BOND", 1, 1.3, :sell)

    ret = buy.apply(sell)

    expect(ret[:buy].qty).to eq(9)
    expect(ret[:sell].qty).to eq(0)
    expect(ret[:result] - 0.3).to  be < 0.001 
  end

  it "counts as negative when selling at lower price" do
	sell = Transaction.new("20200411", "BOND", 1, 0.9, :sell)

	ret = buy.apply(sell)

	expect(ret[:result]).to  be < 0
  end


  it "sells up to what it bought before" do 
	sell = Transaction.new("20200411", "BOND", 11, 1.3, :sell)

	ret = buy.apply(sell)

    expect(ret[:buy].qty).to eq(0)
    expect(ret[:sell].qty).to eq(1)
    expect(ret[:result] - 3.0).to  be < 0.001 
  end

  it "keeps constants operations when selling more than it bought" do
  	sell = Transaction.new("20200411", "BOND", 11, 1.3, :sell)

	ret = buy.apply(sell)

  	expect(ret[:buy].price).to eql buy.price
  	expect(ret[:buy].key).to eql buy.key
  	expect(ret[:buy].date).to eql buy.date


	expect(ret[:sell].price).to eql sell.price 
  	expect(ret[:sell].key).to eql sell.key
  	expect(ret[:sell].date).to eql sell.date
	end


  it "keeps constants operations when selling less than it bought" do
  	sell = Transaction.new("20200411", "BOND", 9, 1.3, :sell)

	ret = buy.apply(sell)

  	expect(ret[:buy].price).to eql buy.price
  	expect(ret[:buy].key).to eql buy.key
  	expect(ret[:buy].date).to eql buy.date


	expect(ret[:sell].price).to eql sell.price 
  	expect(ret[:sell].key).to eql sell.key
  	expect(ret[:sell].date).to eql sell.date
	end


	it "fails when keys don't match" do
		sell = Transaction.new("20200411", "STOCK", 9, 1.3, :sell)
		expect { buy.apply (sell) } .to raise_error (RuntimeError)
	end

	it "fails when sells happens before buy" do
		sell = Transaction.new("20200409", "BOND", 9, 1.3, :sell)

		expect { buy.apply (sell) } .to raise_error (RuntimeError)
	end

	it "fails when target is not a buy" do 
		sell = Transaction.new("20200411", "STOCK", 9, 1.3, :sell)

		expect { 
			sell.apply (Transaction.new("20200411", "STOCK", 9, 1.3, :sell)) 
		} .to raise_error (RuntimeError)
	end

	it "fails when parameter is not a sell" do
		expect { 
			buy.apply (Transaction.new("20200411", "BOND", 9, 1.3, :buy)) 
		} .to raise_error (RuntimeError)
	end

  it "fails when quantity is negative" do
    expect {
      Transaction.new("20200411", "BOND", -1, 1.3, :buy)
    } .to raise_error (RuntimeError)
  end

  it "fails when prive is negative" do
    expect {
      Transaction.new("20200411", "BOND", 1, -1.3, :buy)
    } .to raise_error (RuntimeError)
  end

end