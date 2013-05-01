require "soap/rpc/standaloneServer"

#
$HOST_NAME_OF_SERVICE = 'localhost'

#Screen, the linux program
$SCREEN_NAME = "TekkitServer"
$USER_RUNNING_MC_SERVER = "minecraft"

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
        system("sudo su #{$USER_RUNNING_MC_SERVER} bash -c \"screen -p 0 -S #{$SCREEN_NAME} -X eval 'stuff #{partial}\\015'\"")
        quantity -= 64
      end
      partial = "\\\"$(eval echo \"give #{user} #{item} #{quantity}\")\\\""
      return system("sudo su #{$USER_RUNNING_MC_SERVER} bash -c \"screen -p 0 -S #{$SCREEN_NAME} -X eval 'stuff #{partial}\\015'\"")
    end
  end

  server = ItemDistributionServer.new('ItemDistributionServer', 'urn:ruby:distribute', $HOST_NAME_OF_SERVICE, 8082)
  trap('INT'){
    server.shutdown
  }
  server.start

rescue => err
  # Something went wrong... obviously.
  puts err.message
end
