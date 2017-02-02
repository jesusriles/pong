local json = require "json"

local PersistentData = {}

-- variables
PersistentData.fileName = "scorefile.txt"
PersistentData.score = nil
PersistentData.money = nil

-- functions
PersistentData.setScore = nil
PersistentData.getScore = nil
PersistentData.save = nil
PersistentData.load = nil


-- set the score
PersistentData.setScore = function( score )
	PersistentData.score = score
	PersistentData.save()
end

-- get the score
PersistentData.getScore = function()
	if( PersistentData.score == nil) then return 0 end
	return PersistentData.score
end

-- write the data to a file
PersistentData.save = function()
	
	local path = system.pathForFile( PersistentData.fileName, system.DocumentsDirectory )
	local file = io.open(path, "w")

	if ( file ) then
		local contents = json.encode( PersistentData )
		file:write( contents )
		io.close( file )
		print("File saved correctly.")
	else
		print( "Error: could not read ", PersistentData.fileName, "." )
		return false
	end
	return true

end
	
-- read the data from a file
PersistentData.load = function()

	local path = system.pathForFile( PersistentData.fileName, system.DocumentsDirectory )
	local contents = nil
	local file = io.open( path, "r" )

	if ( file ) then
		local contents = file:read( "*a" )
		io.close( file )
		print( "File loaded correctly" )
		local contentsDecoded = json.decode( contents )
		PersistentData.score = contentsDecoded.score
	else
		print( "Error: could not read scores from ", PersistentData.fileName, "." )
		return false
	end
	return true

end

return PersistentData

