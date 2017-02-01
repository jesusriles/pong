-- variables
local PersistentData = {}
PersistentData.fileName = "scorefile.txt"


function PersistentData.setScore( score )
	PersistentData.score = score
	PersistentData.save()
end


function PersistentData.getScore()
	return PersistentData.load()
end


function PersistentData.save()
	
	local path = system.pathForFile( PersistentData.fileName, system.DocumentsDirectory )
	local file = io.open(path, "w")

	if ( file ) then
		local contents = tostring( PersistentData.score )
		file:write( contents )
		io.close( file )
		print("File saved correctly.")
		return true
	else
		print( "Error: could not read ", PersistentData.fileName, "." )
		return false
	end

end


function PersistentData.load()

	local path = system.pathForFile( PersistentData.fileName, system.DocumentsDirectory )
	local contents = nil
	local file = io.open( path, "r" )

	if ( file ) then
		local contents = file:read( "*a" )
		local score = tonumber(contents);
		io.close( file )
		print( "File loaded correctly" )
		return score
	else
		print( "Error: could not read scores from ", PersistentData.fileName, "." )
	end
	return nil

end

return PersistentData

