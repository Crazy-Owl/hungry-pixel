function filter(tab, predicate)
    local out = {}
    for i = 1, #tab do
        if predicate(tab[i]) then
            table.insert(out, tab[i])
        end
    end
    return out
end
