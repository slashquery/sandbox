local cjson = require "cjson"

text = cjson.encode({a=1,b=2})

print(text)
