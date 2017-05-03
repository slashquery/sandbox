local cache = ngx.shared.cache
local routes = {}
local slashquery = {}
local upstream_host = {}
local upstream_port = 80
local upstreams = {}

function slashquery.init()
    print("loading routes and upstreams")
    routes = require "routes"
    upstreams = require "upstreams"
    math.randomseed(ngx.time())
end

-- WAF + plugins
function slashquery.waf()
    -- check the client IP address is in our black list
    if ngx.var.remote_addr == "132.5.72.3" then
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end
end

function slashquery.router()
    local route = "*"
    for r in pairs(routes) do
        local prefix = string.sub(ngx.var.uri, 1, string.len(r)+1)
        if "/"..r == prefix then
            route = r
            break
        end
    end
    upstream = routes[route].upstream
    if routes[route].port then
        upstream = routes[route].port
    end
    ngx.var.upstream_host = routes[route].host
    for k, host in pairs(upstreams[routes[route].upstream]) do
        table.insert(upstream_host, host)
        sq.resolver(host)
    end
end

function slashquery.resolver(host)
    local resolver = require "resty.dns.resolver"

    local r, err = resolver:new{
        nameservers = {"8.8.8.8", "77.88.8.1", "84.200.70.40"},
        retrans = 5,
        timeout = 2000,
    }
    if not r then
        ngx.log(ngx.ERR, "Failed to instantiate the resolver: ", err,
        " host: ", host)
        return
    end

    if not cache:get(host) then
        local answers, err = r:query(host)
        if not answers then
            ngx.log(ngx.ERR, "Failed to query the DNS server: ", err,
            " host: ", host)
            return
        end

        if answers.errcode then
            ngx.log(ngx.ERR, "Server returned error code: ", answers.errcode,
            ": ", answers.errstr)
        end

        local records = {}
        local ttl = 0
        for i, ans in ipairs(answers) do
            table.insert(records, ans.address)
            ttl = ans.ttl
            ngx.log(ngx.DEBUG, "IP for ", host, ": ", ans.address, " ttl: ", ans.ttl)
        end
        cache:set(host, table.concat(records, ","), ttl)
    end
end

function slashquery.balancer()
    local balancer = require 'ngx.balancer'

    -- find peer's host on routes/upstreams
    local hosts, n = {}, 0
    for k, host in pairs(upstream_host) do
        for ip in string.gmatch(cache:get(host), "[^,]+") do
            hosts[n] = ip
            n = n + 1
        end
    end

    local host = hosts[0]
    local port = 80

    io.write("hosts: ", ngx.ctx.n, "\n")
    io.write("rand: ", ngx.ctx.rn, "\n")
    io.write("host: ", ngx.ctx.host, "\n")

    local ok, err = balancer.set_current_peer(host, port)
    if not ok then
        ngx.log(ngx.ERR, "failed to set the current peer: ", err)
        return ngx.exit(500)
    end
end

return slashquery
