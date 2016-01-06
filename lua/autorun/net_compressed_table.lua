local net = net

if von == nil then
	local vonfile = "autorun/von.lua"
	local errorstr = [[vON (GMOD Lua Table serialization) is not available!
Download https://github.com/vercas/vON/blob/master/von.lua and
save it as garrysmod/lua/autorun/von.lua]]

	if file.Exists(vonfile, "LUA") then
		if SERVER then AddCSLuaFile(vonfile) end
		include(vonfile)
	else
		-- assert + print for emphasis! EDIT: why...
		print(errorstr)
		assert(false, errorstr)
	end
end

net.OrigWriteTable = net.OrigWriteTable or net.WriteTable
net.OrigReadTable = net.OrigReadTable or net.ReadTable

function net.ReadCompressedTable()
	local size = net.ReadUInt(32)

	-- size of zero indicates an empty table
	if size == 0 then
		return {}
	end

	return von.deserialize(util.Decompress(net.ReadData(size)))
end

function net.WriteCompressedTable(tbl)
	if next(tbl) == nil then -- is table empty
		-- send a size of zero to indicate an empty table
		net.WriteUInt(0, 32)
	else
		local compressedTbl = util.Compress(von.serialize(tbl))
		local size = compressedTbl:len()
		net.WriteUInt(size, 32)
		net.WriteData(compressedTbl, size)
	end
end

-- Make WriteTable and ReadTable be the compressed versions.
net.WriteTable = net.WriteCompressedTable
net.ReadTable = net.ReadCompressedTable
