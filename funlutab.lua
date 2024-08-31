---@meta

---@class funlutab
local M={}

---Module version
M.VERSION='2.2'

--Proxy
do
	local edit_error=function() return error("You can't edit this table!", 2) end
	---Returns proxy for `table`
	---@param table table
	---@param index? table|fun(table: table, key: any): any The 'index' field in the metatable. If param is nil, field is `table`.
	---@param new_index? boolean|table|fun(table: table, key: any, value: any) The 'newindex' field in the metatable. If param is true, field is missing. If param is false or nil, field is default error.
	---@param meta? any The 'metatable' field in the metatable. If param is true, field is missing. If param is false or nil, field is default string.
	---@return table
	function M.Proxy(table, index, new_index, meta)
		local proxy={}
		local metatable={}
		if index then metatable.__index=index
		else metatable.__index=table
		end
		if new_index~=true then
			if new_index then metatable.__newindex=new_index
			else metatable.__newindex=edit_error
			end
		end
		if meta~=true then
			metatable.__metatable=meta or "You can't get the metatable of this table!"
		end
		setmetatable(proxy, metatable)
		return proxy
	end
end

---Inserts values at the end of `table`. It's equivalent to
---```lua
---table[#table+1]=value_1
---table[#table+2]=value_2
---...
---table[#table+n]=value_n
---```
---@param table table
---@param ... any
function M.add(table, ...)
	local v1, v2=...
	if v2 then for _, value in ipairs({...}) do table[#table+1]=value end
	else table[#table+1]=v1
	end
end

---Deletes all elements from tables
---@param ... table
function M.clear(...)
	local t1, t2=...
	if t2 then
		for _, table in ipairs({...}) do
			for k in pairs(table) do table[k]=nil end
		end
	else for k in pairs(t1) do t1[k]=nil end
	end
end

---Concatenates the specified tables (creates new table)
---@param ... table
---@return table
function M.concat(...)
	local tables={}
	for i, table in ipairs({...}) do tables[i]=M.copy(table, true) end
	for i=2, #tables do M.shift(tables[i], #tables[i-1]) end
	local table=M.overlay(M.unpack(tables, 'i'))
	return table
end

---Returns a copy of `table`. These tables are different objects so editing the 1st table doesn't edit the 2nd table.
---@param table table
---@param recursive? boolean whether to copy subtables
---@param to? table Table where `table` needs to be copied. It DOES NOT CLEAR before copying
---@return table
function M.copy(table, recursive, to)
	local t=to or {}
	if type(to)~='table' then error('Funlutab: param `to` must be table', 2) end
	for k, v in pairs(table) do
		if type(v)=='table' and recursive then v=M.copy(v, true) end
		t[k]=v
	end
	return t
end

---Deletes the element of `table` with `index`
---
---If `shift`<=0 then indexes of all elements after the element with `index` will decrease by 1. Otherwise indexes of all elements before the element with `index` will increase by 1.
---@param table table
---@param index integer
---@param shift? number -1 (default) or 1
function M.delete(table, index, shift)
	if type(index)~='number' then error('Funlutab: param `index` must be number', 2) end
	if shift and type(shift)~='number' then error('Funlutab: param `shift` must be number', 2) end
	if shift and shift>0 then shift=1
	else shift=-1
	end
	local end_=1
	if shift==-1 then end_=#table end
	for i=index, end_, -shift do table[i]=table[i-shift] end
end

---Deletes elements with the specified keys from `table`
---@param table table
---@param ... any
function M.exclude(table, ...)
	for _, k in ipairs({...}) do table[k]=nil end
end

---Returns a new table containing the elements with the specified keys from `table`
---@param table table
---@param ... any
---@return table
function M.get(table, ...)
	local t={}
	for _, k in ipairs({...}) do t[k]=table[k] end
	return t
end

---Inserts `value` with `index` into `table`
---
---If `shift`>=0 then indexes of all elements after the element with `index` will increase by 1. Otherwise indexes of all elements before the element with `index` will decrease by 1.
---@param table table
---@param value any
---@param index? integer default: 1
---@param shift? number 1 (default) or -1
function M.insert(table, value, index, shift)
	index=index or 1
	if shift and shift<0 then shift=-1
	else shift=1
	end
	local start=1
	if shift==1 then start=#table end
	for i=start, index, -shift do table[i+shift]=table[i] end
	table[index]=value
end

--max, min, multiply, sum
do
	---@alias funlutab.apply_mode
	---|>'v' Apply to values
	---|'k' Apply to keys

	local apply_mode_values={v=true, k=true}
	local default_types={number=true}

	---Returns the max value of `table` and a table containing keys it belongs to\
	---If no values can be found (`table` is empty or there are no values/keys of specified `types`), returns nil and an empty table\
	---If `mode` param is 'k', on the contrary it returns the max key of `table` and a table containing values belonging to it
	---@param table table
	---@param mode? funlutab.apply_mode
	---@param types? {number?: boolean, string?: boolean, table?: boolean, userdata?: boolean} Value of what types this function will look for. Default: `{number=true}`
	---@return any, any[]
	function M.max(table, mode, types)
		mode=mode or 'v'
		if not apply_mode_values[mode] then error('Funlutab: `mode` param must be "k" or "v"', 2) end
		types=types or default_types
		if type(types)~='table' then error('Funlutab: `types` param must be table', 2) end
		local main
		local extras={}
		for extra, value in pairs(table) do
			if mode=='k' then extra, value=value, extra end
			if types[type(value)] and (not main or main<=value) then
				if main~=value then
					main=value
					M.clear(extras)
				end
				M.add(extras, extra)
			end
		end
		return main, extras
	end

	---Returns the min value of `table` and a table containing keys it belongs to\
	---If no values can be found (`table` is empty or there are no values/keys of specified `types`), returns nil and an empty table\
	---If `mode` param is 'k', on the contrary it returns the min key of `table` and a table containing values belonging to it
	---@param table table
	---@param mode? funlutab.apply_mode
	---@param types? {number?: boolean, string?: boolean, table?: boolean, userdata?: boolean} Value of what types this function will look for. Default: `{number=true}`
	---@return any, any[]
	function M.min(table, mode, types)
		mode=mode or 'v'
		if not apply_mode_values[mode] then error('Funlutab: mode param must be "k" or "v"', 2) end
		types=types or default_types
		if type(types)~='table' then error('Funlutab: `types` param must be table', 2) end
		local main
		local extras={}
		for extra, value in pairs(table) do
			if mode=='k' then extra, value=value, extra end
			if types[type(value)] and (not main or main>=value) then
				if main~=value then
					main=value
					M.clear(extras)
				end
				M.add(extras, extra)
			end
		end
		return main, extras
	end

	---Multiplies all `table` values of specified `types`\
	---If no values can be found (`table` is empty or there are no values/keys of specified `types`), returns nil
	---@param table table
	---@param types? {number?: boolean, table?: boolean, userdata?: boolean} Value of what types this function will multiply. Default: `{number=true}`
	---@return any
	function M.multiply(table, types)
		types=types or default_types
		local result
		for _, value in pairs(table) do
			if types[type(value)] then result=(result or 1)*value end
		end
		return result
	end

	---Sums all `table` values of specified `types`\
	---If no values can be found (`table` is empty or there are no values/keys of specified `types`), returns nil
	---@param table table
	---@param types? {number?: boolean, table?: boolean, userdata?: boolean} Value of what types this function will multiply. Default: `{number=true}`
	---@return any
	function M.sum(table, types)
		types=types or default_types
		local result=0
		for _, value in pairs(table) do
			if types[type(value)] then result=(result or 0)+value end
		end
		return result
	end
end

---Overlays tables on top of each other\
---Returns a new table with the fields of the 1st table are replaced by the fields of the 2nd table, etc. If a field is nil, it doesn't replace the previous field.\
---If `recursive`, it also overlays subtables
---@param recursive boolean
---@param ... table
---@return table
function M.overlay(recursive, ...)
	local t={}
	local subtables
	if recursive then subtables={} end
	for _, table in ipairs({...}) do
		for k, v in pairs(table) do
			if recursive then
				if type(v)=='table' then
					if subtables[k] then subtables[k][#subtables[k]+1]=v
					else subtables[k]={v}
					end
					v=nil
				elseif subtables[k] then subtables[k]=nil
				end
			end
			t[k]=v
		end
	end
	if recursive then
		for k, tables in pairs(subtables) do
			t[k]=M.overlay(true, M.unpack(tables, 'i'))
		end
	end
	return t
end

---Reverses `table` *in-place*
---@param table table
---@return table
function M.reverse(table)
	local original=M.copy(table)
	local max=M.max(original, 'k')
	local min=M.min(original, 'k')
	for i=max, min, -1 do
		table[min+(max-i)]=original[i]
	end
	return table
end

---Changes indexes of every element of `table` by `distance`
---@param table table
---@param distance integer
function M.shift(table, distance)
	if type(distance)~='number' then error('Funlutab: param `distance` must be number', 2) end
	distance=math.floor(distance)
	if distance>0 then
		for i=#table, -distance, -1 do table[i+distance]=table[i] end
	elseif distance<0 then
		for i=1, #table-distance do table[i+distance]=table[i] end
	end
end

---Returns a new table with every `step` element from `table` with indexes between `start` and `end_`
---@param table table
---@param start? integer default: 1
---@param end_? integer default: `#table`
---@param step? integer default: 1
---@return table
function M.slice(table, start, end_, step)
	start=start or 1
	end_=end_ or #table
	step=step or 1
	if type(start)~='number' then error('Funlutab: param `start` must be number', 2) end
	if type(end_)~='number' then error('Funlutab: param `end_` must be number', 2) end
	if type(step)~='number' then error('Funlutab: param `step` must be number', 2) end
	local t={}
	for i=start, end_, step do t[i]=table[i] end
	return t
end

---@alias funlutab.unpack_mode
---|>'a' Returns elements with any key
---|'i' Returns elements with integer key>0. It is equivalent to table.unpack

---Returns elements from `table`
---@param table table
---@param mode? funlutab.unpack_mode
function M.unpack(table, mode)
	mode=mode or 'a'
	if mode~='a' and mode~='i' then error('Funlutab: param `mode` must be "a" or "i"', 2) end
	local elements={}
	local specific={}
	if mode=='i' then
		for i in ipairs(table) do elements[#elements+1]='table['..i..']' end
	else
		for k in pairs(table) do
			local type=type(k)
			if type=="string" then k='"'..k..'"'
			elseif type=="boolean" then k=tostring(k)
			elseif type~="number" then
				M.add(specific, k)
				k='specific['..#specific..']'
			end
			M.add(elements, 'table['..k..']')
		end
	end
	return load('return function(table, specific) return '.._G.table.concat(elements, ', ')..' end')()(table, specific)
end

return M
