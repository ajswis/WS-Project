require "soap/rpc/standaloneServer"
require 'soap/rpc/driver'
require "zlib"

# Namespace/URL for next service
$NAMESPACE = 'urn:ruby:distribute'
$URL = 'http://localhost:8082/'

begin
  class XpCheckServer < SOAP::RPC::StandaloneServer
    def initialize (*args)
      super(args[0], args[1], args[2], args[3])
      add_method(self, 'credit_check', 'user', 'cost', 'item', 'quantity')
    end

    def credit_check (user, cost, item, quantity)
      begin
        # Read in <user>.dat file and parse for XpLevel (58704c6576656c)
        # after XpLevel is found, the 2nd and 3rd
        # following bytes represent the level
        file = Zlib::GzipReader.new(open("/home/minecraft/TekkitServer/players/#{user}.dat"))
        rite_bites = [0x58, 0x70, 0x4c, 0x65, 0x76, 0x65, 0x6c, 0x00]

        rb_counter = 0
        level_byte_index = 0
        level_byte = 0
        file.each_byte do |byte|
          if rb_counter == rite_bites.length then
            level_byte_index += 1
            if level_byte_index == 3 then
              level_byte = byte
              break
            end
          elsif byte == rite_bites[rb_counter] then
            rb_counter += 1
          else
            rb_counter = 0
          end
        end

        if level_byte >= cost then
          if take_exp(user, cost, quantity) then
            begin
              driver = SOAP::RPC::Driver.new($URL, $NAMESPACE)
              driver.add_method('distribute', 'user', 'item', 'quantity')

              return driver.distribute(user, item, quantity)
            rescue
              # Error calling the next service function
              puts "Failed to call distribution service."
              return false
            end
          end
        else
          # Not enough levels to fund item purchase
          puts "Not enough levels."
          return false
        end

      rescue => err
        # Something went wrong find available levels.
        puts err.message
        return false
      end
    end

    def take_exp (user, cost, quantity)
      #if user has enough experience, then remove required cost
      partial = "\\\"$(eval echo \"xp -#{cost}L #{user}\")\\\""
      return system("sudo su minecraft bash -c \"screen -p 0 -S TekkitServer -X eval 'stuff #{partial}\\015'\"")
    end
  end

  XpCheck = XpCheckServer.new("CreditChecker",
                              'urn:ruby:creditChecker', 'localhost', 8081)
  trap ('INT') {
    XpCheck.shutdown
  }
  XpCheck.start

rescue => err
  puts err.message
end
