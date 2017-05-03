local routes = {}

-- declare the routes
-- api.slashquery.com/ -> http://httpbin.org/*
routes["*"] = {
    host = "requestb.in",
    upstream = "requestb.in"
}
routes["bin"] = {
    host = "mockbin.org",
    upstream = "mockbin"
}
-- api.slashquery.com/get/ -> http://httpbin.org/get/*
routes["get"] = {
    path= "/get/*",
    host = "httpbin.org",
    upstream = "httpbin"
}
-- api.slashquery.com/anotherpath/ -> http://httpbin.org/get/*
routes["anotherpath"] = {
    path= "/get/*",
    host = "httpbin.org",
    upstream = "httpbin"
}
-- api.slashquery.com/headers/ -> http://httpbin.org/<servers>/*
routes["headers"] = {
    path= "/headers/*",
    host = "httpbin.org",
    upstream = "httpbin"
}
-- api.slashquery.com/images/ -> http://<servers>/image/*
routes["images"]= {
    path= "/image/*",
    host = "httpbin.org",
    upstream = "httpbin"
}

return routes
