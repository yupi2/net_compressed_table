local net = net

if von == nil then
	local vonfile = "autorun/von.lua"
	local errorstr = "vON (GMOD Lua Table serialization) is not available!" ..
		" Download https://github.com/vercas/vON/blob/master/von.lua and" ..
		" put it as garrysmod/lua/autorun/von.lua"

	if file.Exists(vonfile, "LUA") then
		if SERVER then AddCSLuaFile(vonfile) end
		include(vonfile)
	else
		-- assert + print for emphasis!
		print(errorstr)
		assert(von ~= nil, errorstr)
	end
end

net.OrigWriteTable = net.OrigWriteTable or net.WriteTable
net.OrigReadTable = net.OrigReadTable or net.ReadTable

-- Read compressed tables.
function net.ReadCompressedTable()
	local size = net.ReadUInt(32)
	--print("(r)compressed table size: ", size)

	if size == 0 then
		return {}
	end

	return von.deserialize(util.Decompress(net.ReadData(size)))
end

-- Write compressed tables.
function net.WriteCompressedTable(tbl)
	assert(istable(tbl))

	local tableIsEmpty = true
	local size = 0

	for k, v in pairs(tbl) do
		tableIsEmpty = false
		break
	end

	if tableIsEmpty then
		net.WriteUInt(size, 32)
	else
		local compressedTbl = util.Compress(von.serialize(tbl))
		size = compressedTbl:len()
		net.WriteUInt(size, 32)
		net.WriteData(compressedTbl, size)
	end

	--print("(w)compressed table size: ", size)
end

-- Make WriteTable and ReadTable be the compressed versions.
net.WriteTable = net.WriteCompressedTable
net.ReadTable = net.ReadCompressedTable
