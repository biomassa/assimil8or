local string = require("string")
local io = require("io")

allInputs = {}
channelNumber = nil

-- checking if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

-- select lines with CV inputs in them only
function selectInputs(curLine)
	local inputNames = {"Channel ","1A","1B","1C","2A","2B","2C","3A","3B","3C","4A","4B","4C","5A","5B","5C","6A","6B","6C","7A","7B","7C","8A","8B","8C"}
	for k,v in pairs(inputNames) do
		if string.find(curLine, v) then
			if string.find(curLine, "Data2asCV") or string.find(curLine, "XfadeACV") then return(false)
		else return(true)
		end
	end
	end
-- if a line contains "1A 1B and so on" then add this line to the library
end

-- tests the functions above
local file = arg[1]
local lines = lines_from(file)

-- print all line numbers and their contents
for k,v in pairs(lines) do
--  print('line[' .. k .. ']', v)

  -- if the string contains the name of one of the CV inputs we put it in the allInputs table
  if (selectInputs(v)) then
	-- stripping all the tab chars from the string
	v = string.gsub(v, "%s+", "")
	table.insert(allInputs, v)
  end
end

sortTable = {}

for k,v in pairs(allInputs) do

	if string.find(v, "Channel") then
		channelNumber = string.match(v, "%d")
	end
		inputNum = string.match(v, ":(..)")
		
		-- losing inputNum from the string
		v = string.gsub(v, ":(..)", "")

		-- inserting some spaces
		v = string.gsub(v, "^(%a+)", "%1 ")

		-- composing our string back
		v = "\n" .. tostring(inputNum) .. " @ Ch " .. tostring(channelNumber) .. " -> " .. v 

		--writing the final, sortable table
			table.insert(sortTable, k, v) 
end
--end

-- cleaning it up a bit...
for q,w in pairs(sortTable) do
	if string.find(w, "nil") then
		table.remove(sortTable, q)
	end
end

table.sort(sortTable)

print ("\nAssimil8or CV Inputs and their routings (" .. arg[1] .. "):")
print (table.unpack(sortTable))