SMODS.Back{
    key = "consecrated",
    unlocked = false,
    check_for_unlock = function (self, args)
        local function is_above_stake(current, target)
            if not (G.P_STAKES[current] and G.P_STAKES[target]) then return false end
            if current == target then return true end
            for _,stake in ipairs(G.P_STAKES[current].applied_stakes or {}) do
                if is_above_stake(stake, target) then return true end
            end
            return false
        end
        if args and args.type == "win_stage" then
            return is_above_stake(SMODS.stake_from_index(get_deck_win_stake()), "stake_gold")
        end
    end,
    apply = function (self, back)
        G.GAME.marv_marvellous = true
        G.E_MANAGER:add_event(Event{
            func = function ()
                SMODS.add_card{
                    set = "Joker",
                    key = "j_joker",
                    area = G.deck
                }
            end
        })
        for _,suit in pairs{
            "Hearts", "Clubs", "Diamonds", "Spades"
        } do
            G.FUNCS.change_collab{
                cycle_config = {
                    curr_suit = suit
                },
                to_key = "marv_FLatro_"..suit:sub(1,1):lower()
            }
        end
    end
}