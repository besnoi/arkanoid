--[[
	iTable Library for Lua/Love2D
	By Neer (you CAN remove this header if you want)
	:-A very very simple library but can be very useful.
	By default Lua doesn't support many table operations even important ones such
	as indexOf and slice, etc. So this library is to fill that gap. 
	Just require it and then u can use table.indexOf/table.firstIndexOf,table.slice,etc...
	
	
	P.S. : Note that most of the functions here will work only with tables as arrays (those working with all types of table will have a *generic* written above) and i guess
	that's why they dont have these functions in the standard table library - cause they are not generic enough.
	(i.e. these functions wont work with hashtables or associative arrays -- name's same)
	But most luaites use tables as array, so this library should prove useful I believe
]]

--returns the index of the first occurence of element el in table tbl

local function tableassert(tbl,fncname,_type)
	_type=_type or 'table'
	assert(type(tbl)==_type,("Oops! %s expected in table.%s, got '%s'"):format(_type,fncname,type(tbl)))	
end

function table.firstIndexOf(tbl,element)
	tableassert(tbl,"firstIndexOf")
	for i,el in ipairs(tbl) do
		if el==element then return i end
	end
	return nil
end

function table.lastIndexOf(tbl,element)
	--returns the index of the last occurence of element el in table tbl	
	local index=nil
	tableassert(tbl,"lastIndexOf")	
	for i,el in ipairs(tbl) do
		if el==element then index=i end
	end
	return index
end

--same as table.firstIndexOf
table.indexOf=function(tbl,el) return table.firstIndexOf(tbl,el) end

--checks whether or not an element exists in a table
table.exists=function(tbl,el) return not (table.indexOf(tbl,el)==nil) end

function table.slice(tbl, first, last, step)
	--returns a subset of a table
	tableassert(tbl,"slice")	
    local sliced = {}
    for i = first or 1, last or #tbl, step or 1 do
      sliced[#sliced+1] = tbl[i]
    end
    return sliced
end

--same as table.slice (just little faster for HUGE tables)
table.subset=function(tbl,first,last) return table.slice(tbl,first,last,1) end

--push a value at the end
table.push_back=function(tbl,value) tableassert(tbl,"push_back") tbl[#tbl+1]=value end
table.push=function(tbl,value) table.push_back(tbl,value) end

--push a value at the front
table.push_front=function(tbl,value) tableassert(tbl,"push_front") tbl[1]=value end

function table.append(tbl,...)
	--appends all the values 
	--eg if tbl={1,2,3} then append(tbl,4,5) will make tb={1,2,3,4,5}
	tableassert(tbl,"append")
	for _,i in ipairs{...} do
		tbl[#tbl+1]=i
	end
end

function table.merge(tbl,...)
	--merges tbl with n number of tables
	--eg if tbl={1,2} then merge(tbl,{3,4},{5}) will make tbl will be {1,2,3,4,5}
	tableassert(tbl,"merge")
	for _,i in ipairs{...} do
		if type(i)=='table' then 
			for _,j in ipairs(i) do
				tbl[#tbl+1]=j
			end
		end
	end
end


function table.join(tbl,...)
	--different than table.merge in the sense that it supports only hashtables not arrays 
	--so if tbl={['a']=5,['b']=6} then merge(tbl,{['c']=5}) will make tbl will be {['a']=5,['b']=6,['c']=5}
	-- tableassert(tbl,"join")
	for _,i in pairs{...} do
		if type(i)=='table' then 
			for k,j in pairs(i) do
				tbl[k]=j
			end
		end
	end
end

--*generic*
function table.subdivide(tbl,n)
	--divide a table into an array of sub-tables (each sub-table containing less than or n number of elements) of the original table and return that array and along with the size of the array
	--eg if tbl={1,2,3,4,5} then subdivide(tbl,2) will return {{1,2},{['3']=3,['4']=4},{['5']=5}}
	--and if tbl={['a']=5,['b']=6,c=8} then subdivide(tbl,1) will return {{['a']=5},{['b']=6},{['c']=8}}
	tableassert(tbl,"subdivide")
	local array,index,i={},1,1
	for key,value in pairs(tbl) do
		if i==n+1 then i=1 index=index+1 end
		if not array[index] then array[index]={} end
		array[index][key]=value
		i=i+1
	end
	return array,index
end

function table.divide(tbl,n)
	--unlike table.subdivide, divide works only on arrays. It differs from subdivide only in one aspect here illustrated by eg
	--e.g. if tbl={1,2,3,4,5} then subdivide(tbl,2) will return {{1,2},{['3']=3,['4']=4},{['5']=5}}
	--but divide(tbl,2) will return {{1,2},{3,4},{5,6}}
	tableassert(tbl,"divide")	
	local array,index,i={},1,1
	for key,value in ipairs(tbl) do
		if i==n+1 then i=1 index=index+1 end
		if not array[index] then array[index]={} end
		array[index][i]=value
		i=i+1
	end
	return array,index
end

--kinda like table.sort only differece is that it is not in-place, i.e.no change is made to the original table rather the sorted table is returned
function table.isort(tbl,funcn)
	tableassert(tbl,'isort')
	tableassert(funcn,'isort','function')
	local tmp=tbl
	table.sort(tmp,funcn)
	return tmp
end