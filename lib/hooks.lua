---@diagnostic disable: duplicate-set-field
local suitless = SMODS.has_no_suit
SMODS.has_no_suit = function (card)
    --if card.base.id == SMODS.Ranks.marv_joker.id then return true end
    if card.config.center.set ~= "Default" and card.config.center.set ~= "Enhanced" then return true end
    return suitless(card)
end

local rankless = SMODS.has_no_rank
SMODS.has_no_rank = function (card)
    --if card.base.id == SMODS.Ranks.marv_joker.id then return true end
    if card.config.center.set ~= "Default" and card.config.center.set ~= "Enhanced" then return true end
    return rankless(card)
end

local fourfingers = SMODS.four_fingers
SMODS.four_fingers = function (hand_type)
    local amt = {
        marv_String = 3,
        marv_Tragedy = 4,
        marv_Procedure = 4,
    }
    if amt[hand_type] then
        return amt[hand_type] - (next(SMODS.find_card("j_four_fingers")) and 1 or 0)
    end
    return fourfingers(hand_type)
end

local ize = localize
function localize(args, misc_cat)
    local suits = {
        Spades = true,
        Clubs = true,
        Diamonds = true,
        Hearts = true,
    }
    --
    if suits[args] and G.SETTINGS.CUSTOM_DECK.Collabs[args] == "marv_FLatro_"..args:sub(1,1):lower() and string.find(misc_cat, "suits_") then
        args = "marv_"..args
    end
    return ize(args, misc_cat)
end

local getid = Card.get_id
function Card:get_id()
    if self.config.center.set ~= "Default" and self.config.center.set ~= "Enhanced" then return -math.random(100, 1000000) end
    return getid(self)
end