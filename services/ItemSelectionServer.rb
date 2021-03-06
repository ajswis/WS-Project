#!/usr/bin/ruby
require 'soap/rpc/standaloneServer'
require 'soap/rpc/driver'

# Namespace/URL for next service
$NAMESPACE_NEXT_SERVICE = 'urn:ruby:creditChecker'
$URL_NEXT_SERVICE = 'http://localhost:8081/'

# Location of this service
$HOST_NAME_OF_SERVICE = 'orthrus.kyliejo.com'

begin
  class ItemSelectionServer < SOAP::RPC::StandaloneServer

    @@ids = {
      "Stone" => [1, 1],
      "Grass" => [2, 2],
      "Dirt" => [3, 1],
      "Cobblestone" => [4, 1],
      "Planks" => [5, 2],
      "Sand" => [12, 2],
      "Gravel" => [13, 1],
      "Wood" => [17, 2],
      "Glass" => [20, 3],
      "Lapis" => [21, 128],
      "Sandstone" => [24, 8],
      "Wool" => [35, 4],
      "Mossy" => [48, 2],
      "Obsidiam" => [49, 6],
      "Restone" => [73, 3],
      "Ice" => [79, 4],
      "Cactus" => [81, 5],
      "Clay" => [82, 5],
      "Cane" => [83, 8],
      "Pumpkin" => [86, 6],
      "Netherrack" => [87, 1],
      "Soul" => [88, 2],
      "Melon" => [103, 6],
      "Netherbrink" => [112, 4],
      "Netherwart" => [115, 10],
      "EndStone" => [121, 64],
      "Anvil" => [145, 128],
      "Apple" => [260, 6],
      "Coal" => [263, 4],
      "Diamond" => [264, 320],
      "Gold" => [265, 256],
      "Iron" => [266, 192],
      "String" => [287, 1],
      "Feather" => [288, 1],
      "Sulphur" => [289, 2],
      "Gunpowder" => [289, 2],
      "Wheat" => [296, 6],
      "Flint" => [318, 1],
      "Pockchop" => [319, 4],
      "Redstone" => [331, 4],
      "Snowball" => [332, 1],
      "Snow" => [332, 1],
      "Leather" => [334, 2],
      "Slime" => [341, 5],
      "Slimeball" => [341, 5],
      "Egg" => [344, 2],
      "Glowstone" => [348, 10],
      "Fish" => [349, 3],
      "Inksack" => [351, 1],
      "Bone" => [352, 4],
      "Beef" => [363, 4],
      "Chicken" => [365, 4],
      "RottenFlesh" => [1, 2],
      "EnderPearl" => [368, 128],
      "BlazeRod" => [369, 128],
      "GhastTear" => [370, 192],
      "SpiderEye" => [375, 5],
      "Carrots" => [391, 6],
      "Potatoes" => [392, 6],
      "Pie" => [400, 16],
      "Quartz" => [406, 4]
    }

    def initialize (*args)
      super(args[0], args[1], args[2], args[3])
      add_method(self, 'item_select', 'username', 'item', 'amount')
    end

    def item_select(username, item, amount)
      if amount == 0 then
        return false
      end

      itemID, cost = find_id_cost(item, amount)
      begin
        driver = SOAP::RPC::Driver.new($URL_NEXT_SERVICE, $NAMESPACE_NEXT_SERVICE)
        driver.add_method('credit_check', 'user', 'cost', 'item', 'quantity')
        return driver.credit_check(username, cost, itemID, amount)
      rescue
        return false
      end
    end

    def find_id_cost(item, amount)
      if not (item.is_a? String and amount.is_a? Integer) then
        return false
      end

      itemID, cost = 0, 0

      if not @@ids[item].nil? then
        itemID, cost = @@ids[item][0], @@ids[item][1]
      else
        return false
      end

      if itemID == 0 or cost == 0 then
        return false
      end

      # 64 is how many items are in -most- item stacks.
      cost =  cost / (64.0 / amount.to_i)
      cost = cost.round()
      if cost == 0
        cost = 1
      end


      return itemID, cost
    end

  end

  server = ItemSelectionServer.new("ItemSelection", 'urn:ruby:ItemSelection', $HOST_NAME_OF_SERVICE, 8080)
  trap ('INT') {
    server.shutdown
  }
  server.start

rescue => err
  puts err.message
end

