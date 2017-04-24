function readAll(file)
    local f = io.open(file, "rb")
    if not f then
        return false
    end
    local content = f:read("*all")
    f.close()
    return content
end

-- Load routes
local file = conf
local sq = readAll(file)

if not sq then
    return io.write(string.format("File not found: %s\n", file))
end

-- parse slashquery.yml
--    local lyaml = require "lyaml"
local t = lyaml.load(sq)


-- create routes tables
routes = {}
for k,v in pairs(t.slashquery.routes) do
    routes[k] = v
end

-- create upstream
upstreams = {}
for k,v in pairs(t.slashquery.upstreams) do
    upstreams[k] = v.servers
end
