function sum(n)
    return (n*n - n)/2;
end

local s = 0
for i=1,100 do
    s = s + i
    assert(sum(i) == s, "Case "..i.." failed: expected "..s.." but got "..sum(i).." instead.")
end
