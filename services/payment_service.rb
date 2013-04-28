user = "kjinfield"
amount = 1

require "zlib"

begin
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

	if level_byte >= amount then
		puts "true"
		#if user has enough experience, then remove required amount
		#{}`sudo su minecraft bash -c "screen -p 0 -S TekkitServer -X eval 'stuff \"$(eval echo "xp -#{amount}L #{user}")\"\015'"`
	end
rescue
	puts "false"
end