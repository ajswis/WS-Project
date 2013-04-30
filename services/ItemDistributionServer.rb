require "soap/rpc/standaloneServer"

begin
  class ItemDistributionServer < SOAP::RPC::StandaloneServer
    def initialize(*args)
      super(args[0], args[1], args[2], args[3])
      add_method(self, 'distribute', 'user', 'item', 'quantity')
    end

    def distribute(user, item, quantity)
      #Break up the command because " and ' get out of control otherwise.
      while quantity > 64 do
        partial = "\\\"$(eval echo \"give #{user} #{item} 64\")\\\""
        system("sudo su minecraft bash -c \"screen -p 0 -S TekkitServer -X eval 'stuff #{partial}\\015'\"")
        quantity -= 64
      end
      partial = "\\\"$(eval echo \"give #{user} #{item} #{quantity}\")\\\""
      return system("sudo su minecraft bash -c \"screen -p 0 -S TekkitServer -X eval 'stuff #{partial}\\015'\"")
    end
  end

  server = ItemDistributionServer.new('ItemDistributionServer', 'urn:ruby:distribute', 'localhost', 8082)
  trap('INT'){
    server.shutdown
  }
  server.start

rescue => err
  # Something went wrong... obviously.
  puts err.message
end
