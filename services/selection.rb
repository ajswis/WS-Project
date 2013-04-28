#!/usr/bin/ruby

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





username = " "
item = " "
amount = " "
StackValue = 64.0

username, item, amount = UserInput("Request.txt")
ids = GetIds("Ids64.txt")
itemID, cost = findIdCost(item, ids, amount)

puts username
#puts item
puts itemID
puts amount
puts cost