require "soap/rpc/standaloneserver"

begin
	class XpCheckServer < SOAP::RPC::StandaloneServer
		def initialize (*args)
			add_method(self, 'credit_check', 'user', 'cost', 'item', 'quantity')
		end

		def credit_check (user, cost, item, quantity)	
			require "zlib"

			begin
				#read in <user>.dat file and parse for XpLevel (58704c6576656c)
				# after XpLevel is found, the 2nd and 3rd
				# following bytes represent the level
				file = Zlib::GzipReader.new(open("#{user}.dat"))
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
						#call drew baby ;)
					end
				else
					return false
				end

			rescue
				return false
			end
		end
			
		def take_exp (user, cost, quantity)	
			#if user has enough experience, then remove required cost
			return system('su minecraft bash -c "screen -p 0 -S TekkitServer -X eval \'stuff \"$(eval echo "xp -#{amount}L #{user}")\"\015\'"')
		end
	end

	XpCheck = XpCheckServer.new("CreditChecker",
		urn:ruby:CreditChecker, orthrus.kyliejo.com, 8081)
rescue => err
	puts err.message
end