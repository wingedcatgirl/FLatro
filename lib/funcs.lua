MARV.is_above_stake = function(current, target)
    if not (G.P_STAKES[current] and G.P_STAKES[target]) then return false end
    if current == target then return true end
    for _,stake in ipairs(G.P_STAKES[current].applied_stakes or {}) do
        if MARV.is_above_stake(stake, target) then return true end
    end
    return false
end

--Checks whether Marvellous rules are active.
MARV.is_marvellous = function ()
    return G.GAME.marv_marvellous
end