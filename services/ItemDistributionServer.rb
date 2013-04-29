require "soap/rpc/standaloneserver"
begin
  class ItemDistributionServer < Soap::RPC::StandaloneServer
    def initialize(*args)
      add_method(self, 'distribute', 'user', 'item', 'quantity')
    end

    def distribute(user, item, quantity)
      #Break up the command because " and ' get out of control otherwise.
      partial = "\\\"$(eval echo \"give #{user} #{item} #{quantity}\")\\\""
      system("sudo su minecraft bash -c \"screen -p 0 -S TekkitServer -X eval 'stuff "+partial+"\\015'\"")
    end
  end

  server = ItemDistributionServer.new('ItemDistributionServer', 'urn:ruby:distribute', 'localhost', 8082)
  trap('INT'){
    server.shutdown
  }
  server.start
rescue
  # Do nothing.
end
