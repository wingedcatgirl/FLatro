---@diagnostic disable: duplicate-set-field
local suitless = SMODS.has_no_suit
SMODS.has_no_suit = function (card)
    --if card.base.id == SMODS.Ranks.marv_joker.id then return true end
    return suitless(card)
end

local getid = Card.get_id
function Card:get_id()
    if self.config.center.set ~= "Default" and self.config.center.set ~= "Enhanced" then return -math.random(100, 1000000) end
    return getid(self)
end