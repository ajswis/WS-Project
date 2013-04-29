#!/usr/bin/ruby
require 'soap/rpc/StandaloneServer'
require 'soap/rpc/driver'

NAMESPACE = 'urn:ruby:creditCheck'
URL = 'orthrus.kyliejo.com:8081'

begin
	class ItemSelection < SOAP::RPC::StandaloneServer

		def initialize (*args)
      super(args[0], args[1], args[2], args[3])
			add_method(self, 'main', args)
		end



		username = " "
		item = " "
		amount = " "
		StackValue = 64.0





		def main(string)

			username, item, amount = UserInput(string)
			ids = GetIds("Ids64.txt")
			itemID, cost = findIdCost(item, ids, amount)

			begin
				driver = SOAP::RPC::Driver.new(URL, NAMESPACE)

				driver.add_method('credit_check', 'user', 'cost', 'item', 'quantity')



				return driver.add(username, cost, itemID, amount)
			rescue
				return false
			end

		end





		def UserInput(filename)

			file = File.open(filename, "r")
			ids = file.read.split(" ")

			username = ids[0]
			item = ids[1]
			amount = ids[2]

			item.downcase!

			return username, item, amount
		end





		def GetIds(filename)
			file = File.open(filename, "r")
			ids = file.read.split("\n")

			(0..ids.length-1).each do |i|
		 	  ids[i] = ids[i].split(" ")
			end

			return ids
		end





		def findIdCost(item, ids, amount)
			itemID = 0
			cost = 0

			(0..ids.length-1).each do |i|
				ids[i][0].downcase!
		   		if item == ids[i][0] then
		   			itemID = ids[i][1]
					cost = ids[i][2]
				end
			end

			if itemID == 0 or cost == 0 then
				#Error Code
			end

			cost =  cost.to_i / (StackValue / amount.to_i)
			if cost == 0
				cost = 1
			end

			cost = cost.round(0)

			return itemID, cost
		end




		username, itemID, amount, cost = main("Request.txt")

		puts username
		puts itemID
		puts amount
		puts cost


<<<<<<< HEAD
	Items = ItemSelection.new("Main", urn:ruby:ItemSelection, orthrus.kyliejo.com, 8080)
=======
	Items = ItemSelection.new("Main",
		'urn:ruby:ItemSelection', 'orthrus.kyliejo.com', 8080)
>>>>>>> db0e7ffd53da5f53c57b7d870f1e2dcc3bc46466
	trap ('INT') {
		Items.shutdown
	}
	Items.start




	end
rescue
end
<<<<<<< HEAD
=======
#c = ItemSelection.new
>>>>>>> db0e7ffd53da5f53c57b7d870f1e2dcc3bc46466
