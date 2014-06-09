require "math"

function filter(tab, predicate)
    local out = {}
    for i = 1, #tab do
        if predicate(tab[i]) then
            table.insert(out, tab[i])
        end
    end
    return out
end

function sign(x)
    if x == math.abs(x) then
        return 1
    else
        return -1
    end
end