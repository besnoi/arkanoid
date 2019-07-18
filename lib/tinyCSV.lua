--[[
    LICENSED UNDER GPLV3
        Author: Neer
        https://github.com/YoungNeer
        You can do ANYTHING YOU WANT with this PARTICULAR CODE. NO CREDIT NEEDED
        (However that is not to say that 'you mustn't give credit.') 
    More Lua/LOVE2D libraries at https://github.com/YoungNeer/love-lib/
]]
local csvfile={}

function csvfile:parse(infile,sep,format,looping)
    --sep means the seperational character which seperates the key from value, key1=value1,..,keyn=valuen format is mostly used
    --format (1 or 2) means how should the table store the data - 1. in table[key]=value format or 2. in table={{key1,value1},...,{{keyn,valuen}}} format so you'd access it like table[1][1],table[1][2],...table[2][1],etc , format is 1 by default in parse function and 2 by default in read function. Unlike sep, format is not about choice you have to know which format would be more suitable. Another way to think about this is that format 1 means primary key (keys cannot be duplicate) useful for storing evironment variables and format 2 means non-primary key which is useful when dealing with highscores - the same player can top the chart many times with same or different scores
    --looping (true or false) means whether you plan to loop over the table that is to be returned (by default seen as true unless you explicitly say 'false' just so you can use the free (and useless unless you like the format) functions like add and getValue)

    local entries=0
    if io.open(infile,'r') then
        sep=sep or "="    
        local db,counter,s={},1
        for i in io.lines(infile) do
            s=i;
            for key,value in s:gmatch(string.format("%s%s%s","([%w_-]+)",sep,"([%w_-]+)")) do
                entries=entries+1
                if format~=2 then
                    db[key]=value
                else
                    db[counter]={key,value}
                    counter=counter+1
                end
            end
        end
        if looping==false then
            function db:add(key,value)
                db[key]=value
            end
            function db:getValue(key)
                return db[key]
            end
        end
        if entries==0 then
            return false
        else
            return db
        end            
    else
        return nil;
    end
end

function csvfile:parseFile(filename,sep,format,looping)
    return csvfile:parse(love.filesystem.getAppdataDirectory()..filename,sep,format,looping)
end

function csvfile:read(infile,sep)
    return csvfile:parse(infile,sep,2,true)
end

function csvfile:readFile(filename,sep)
    return csvfile:parse(love.filesystem.getAppdataDirectory()..filename,sep,2,true)
end


function csvfile:write(infile,tbl,sep,format)
    sep=sep or "="
    fout=io.open(infile,'w')
    for k,v in pairs(tbl) do
        if tostring(v):sub(1,8)~='function' then
            if format~=2 then fout:write(string.format("%s%s%s,\n",k,sep,tbl[k]))
            else fout:write(string.format("%s%s%s,\n",v[1],sep,v[2])) end
        end
    end
    fout:close()
end

function csvfile:writeFile(filename,tbl,sep,format)
    csvfile:write(love.filesystem.getAppdataDirectory()..filename,tbl,sep,format)
end

function csvfile:append(infile,tbl,sep,format)
    --note that for this particular function you must require the itable library (again part of love2dlib)
    if format==1 then
        table.join(tbl,csvfile:parse(infile,sep,format,true))        
    else
        table.merge(tbl,csvfile:parse(infile,sep,format,true))
    end
    csvfile:write(infile,tbl,sep,format)
end

function csvfile:appendFile(filename,tbl,sep,format)
    csvfile:append(love.filesystem.getAppdataDirectory()..filename,tbl,sep,format)
end

return csvfile
