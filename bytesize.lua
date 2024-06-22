#!/usr/bin/lua

VERSION = '1.0'

UNIT_PREFIXES = {
	'K',
	'M',
	'G',
	'T',
	'P',
	'E',
	'Z',
	'Y',
	'R',
	'Q',
}

UNITS_SI = {
	[0] = 'B',
	'kB',
	'MB',
	'GB',
	'TB',
	'PB',
	'EB',
	'ZB',
	'YB',
	'RB',
	'QB',
}

UNITS_COMMON = {
	[0] = 'bytes',
	'KiB',
	'MiB',
	'GiB',
	'TiB',
	'PiB',
	'EiB',
	'ZiB',
	'YiB',
	'RiB',
	'QiB',
}

function main(args)
	local input = args[1]
	if not input or input == '--help' then
		print_help()
		return true
	elseif input == '--version' then
		print_msg(arg[0] .. ' ' .. VERSION)
		return true
	end
	
	local size, unit, is_bytes = parse_size(input)
	if size == nil then
		print_msg("Invalid number!", true)
		return false
	end
	
	if is_bytes then
		local standard = false
		repeat
			standard = not standard
			local value, unit = bytes_to_human(size, standard)
			local output = string.format('%.2f %s', value, unit)
			print_msg(output)
		until not standard
	else
		local bytes = human_to_bytes(size, unit)
		if bytes == nil then
			print_msg('NaN')
			print_msg("Invalid units!", true)
			return false
		else
			print_msg(bytes)
		end
	end
end

function print_msg(msg, error)
	local stream = error and io.stderr or io.stdout
	stream:write(msg)
	stream:write('\n')
end

function print_help()
	local help = [[
Convert BYTES to SIZE and vice versa, BYTES is the no. of bytes without
a suffix and SIZE accepts both SI (1KB = 1000 bytes) and non-SI (1KiB = 
1024 bytes) suffixes without case-sensitivity.

Usage: $@ BYTES
   or: $@ SIZE

Examples:

$ $@ 1024 # Simple bytes to human readable output
1.024 kB
1.0 KiB

$ $@ 2147483647 # Y2K38
2.15 GB
2.00 GiB

$ $@ 1TB # SI units
1000000000000

$ $@ 1TiB # non-SI units, they are powers of 2
1099511627776

$ $@ 16G # non-SI with short and ambiguous suffix
17179869184
]]
	help = string.gsub(help, '%$@', arg[0])
	io.stdout:write(help)
end

function parse_size(raw)
	local _start, _end, value, unit = string.find(raw, '([%de%.]*)%s*(%a*)')
	local size = tonumber(value)
	return size, unit, unit == '', value
end

function bytes_to_human(size, si)
	local magnitude = 0
	local unit = si and 1000 or 1024
	local magnitude_max = #(si and UNITS_SI or UNITS_COMMON)
	
	local last_size = size
	while true do
		size = size / unit
		if size < 1 then break end
		last_size = size
		magnitude = magnitude + 1
		if magnitude == magnitude_max then break end
	end
	
	local postfix = (si and UNITS_SI or UNITS_COMMON)[magnitude]
	return last_size, postfix
end

function human_to_bytes(size, unit)
	unit = string.upper(unit)
	
	if unit == 'B' then
		return size
	end
	
	local prefix = string.sub(unit, 1, 1)
	local si = ({
		['B'] = true, -- XB (SI)
		['IB'] = false, -- XiB (Powers of 2, -ibi bytes)
		[''] = false, -- X (ambiguous, assume not SI)
	})[string.sub(unit, 2)]
	if si == nil then return nil end
	
	local magnitude = nil
	for i = 1, #UNIT_PREFIXES do
		if UNIT_PREFIXES[i] == prefix then
			magnitude = i
			break
		end
	end
	if not magnitude then return nil end
	
	local multiplier = integer_pow(si and 1000 or 1024, magnitude)
	return size * multiplier
end

function integer_pow(int, pow)
	local result = 1
	
	if pow ~= 0 then
		for i = 1, pow do
			result = result * int
		end
	end
	
	return result
end

os.exit(main(arg))
