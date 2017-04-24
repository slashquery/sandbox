local slashquery = {}
local routes = {}
local upstreams = {}

function slashquery.init()
    print("loading routes and upstreams")
    routes = require "routes"
    upstreams = require "upstreams"
end

-- WAF + plugins
function slashquery.access()
    -- check the client IP address is in our black list
    if ngx.var.remote_addr == "132.5.72.3" then
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end

    io.write("HOST: ", ngx.var.host, "\n")
    io.write("URI: ", ngx.var.uri, "\n")
    ngx.var.upstream_host = "httpbin.org"
end

function slashquery.resolver()
    local resolver = require "resty.dns.resolver"
    local cache = ngx.shared.cache

    local r, err = resolver:new{
        nameservers = {"8.8.8.8", "77.88.8.1", "84.200.70.40"},
        retrans = 5,
        timeout = 2000,
    }
    if not r then
        ngx.say("failed to instantiate the resolver: ", err)
        return
    end

    if not cache:get("httpbin.org") then
        local answers, err = r:query("httpbin.org")
        if not answers then
            ngx.say("failed to query the DNS server: ", err)
            return
        end

        if answers.errcode then
            ngx.say("server returned error code: ", answers.errcode,
            ": ", answers.errstr)
        end

        local records = {}
        local ttl = 0
        for i, ans in ipairs(answers) do
            table.insert(records, ans.address)
            ttl = ans.ttl
        end
        cache:set("httpbin.org", table.concat(records, ","), ttl)
    end
end

function slashquery.balancer()
    local balancer = require 'ngx.balancer'

    -- find peer's host on routes/upstreams
    local host = "50.19.93.247"
    local port = 80

    local ok, err = balancer.set_current_peer(host, port)
    if not ok then
        ngx.log(ngx.ERR, "failed to set the current peer: ", err)
        return ngx.exit(500)
    end
end

return slashquery
