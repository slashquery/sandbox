local routes = {}

-- declare the routes
-- api.slashquery.com/ -> http://httpbin.org/*
routes["/"] = {
    path = "/*",
    uptream = httpbin
}
-- api.slashquery.com/get/ -> http://httpbin.org/get/*
routes["get"] = {
    path= "/get/*",
    upstream= httpbin
}
-- api.slashquery.com/anotherpath/ -> http://httpbin.org/get/*
routes["anotherpath"] = {
    path= "/get/*",
    uptream= httpbin
}
-- api.slashquery.com/headers/ -> http://httpbin.org/<servers>/*
routes["headers"] = {
    path= "/headers/*",
    servers= {"httpbin.org", "eu.httpbin.org"}
}
-- api.slashquery.com/images/ -> http://<servers>/image/*
routes["images"]= {
    path= "/image/*",
    servers= {"httpbin.org", "eu.httpbin.org"}
}

return routes
