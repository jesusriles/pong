--[[ 

Everything related to storing the data in disk must be here.

]]

local json = require "json"

local PersistentData = {}

-- variables
PersistentData.fileName = "database.json"
PersistentData.score = nil
PersistentData.score = nil

-- functions
PersistentData.setScore = nil
PersistentData.setPoints = nil
PersistentData.getScore = nil
PersistentData.getPoints = nil
PersistentData.save = nil
PersistentData.load = nil


-- set the score
PersistentData.setScore = function( score )

	if( score ~= nil ) then
		PersistentData.score = score
	else
		PersistentData.score = 0
	end

end

-- set the points
PersistentData.setPoints = function( points )

	if( points ~= nil ) then 
		PersistentData.points = points
	else
		PersistentData.points = 0
	end

end

-- get the score
PersistentData.getScore = function()

	if( PersistentData.score == nil ) then return 0 end
	return PersistentData.score

end

-- get the points
PersistentData.getPoints = function()

	if( PersistentData.points == nil ) then return 0 end
	return PersistentData.points

end

-- write the data to a file
PersistentData.save = function()
	
	local path = system.pathForFile( PersistentData.fileName, system.DocumentsDirectory )
	local file = io.open(path, "w")

	if( file ) then
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

		-- information to load
		PersistentData.score = contentsDecoded.score
		PersistentData.points = contentsDecoded.points

	else
		print( "Error: could not read scores from ", PersistentData.fileName, "." )
		return false
	end
	return true

end

return PersistentData

