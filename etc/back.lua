SMODS.Back{
    key = "consecrated",
    unlocked = false,
    check_for_unlock = function (self, args)
        if args and args.type == "win_stage" then
            return MARV.is_above_stake(SMODS.stake_from_index(get_deck_win_stake()), "stake_gold")
        end
    end,
    apply = function (self, back)
        G.GAME.marv_marvellous = true
        --[[    --Too many crash workarounds, done trying for now
        G.E_MANAGER:add_event(Event{
            func = function ()
                for _=1,2 do
                    local card = SMODS.add_card{
                        set = "Joker",
                        key = "j_joker",
                        area = G.deck
                    }
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    card.playing_card = G.playing_card
                    card.base.suit = "Diamonds"
                    card.base.value = 2
                    table.insert(G.playing_cards, card)
                end
                return true
            end
        })
        --]]
        if MARV.config.force_deckskins then
            for _,suit in pairs{
                "Hearts", "Clubs", "Diamonds", "Spades"
            } do
                local index
                for i,v in ipairs(G.COLLABS.options[suit]) do
                    if v == "marv_FLatro_"..suit:sub(1,1):lower() then index = i end
                end
                assert(type(index) == "number", "not like that")
                G.FUNCS.change_collab{
                    cycle_config = {
                        curr_suit = suit
                    },
                    to_key = index
                }
            end
        end
    end,
    calculate = function (self, back, context)
        if context.modify_hand then
            local shrinkable = {
                marv_String = true,
                marv_Tragedy = true,
                marv_Procedure = true,
                marv_Mirror = true
            }
            if shrinkable[context.scoring_name] then
                local diff = #context.scoring_hand - SMODS.four_fingers(context.scoring_name)
                print(diff)
                if diff == 0 then return nil end
                return {
                    func = function ()
                        for _,parameter in pairs(SMODS.Scoring_Parameters) do
                            parameter:modify(math.floor(parameter.current * 0.2 * diff))
                        end
                    end
                }
            end
        end

        if context.debuff_hand and (context.scoring_name == "marv_Fall6" or context.scoring_name == "marv_Fall7") then
            return {
                debuff = true,
                debuff_text = localize{
                    type = "variable",
                    key = "marv_disallowed_falls",
                    vars = {
                        localize(context.scoring_name, "poker_hands")
                    }
                }
            }
        end

        if context.pre_discard and not G.GAME.marv_discarded_this_round then
            G.GAME.marv_discarded_this_round = true
            SMODS.change_play_limit(1)
        end

        if context.drawing_cards and G.GAME.marv_discarded_this_round then
            return {
                modify = context.amount + 1
            }
        end

        if context.end_of_round and G.GAME.marv_discarded_this_round then
            SMODS.change_play_limit(-1)
            G.GAME.marv_discarded_this_round = nil
        end
    end
}

SMODS.Achievement{
    key = "hearts_desire",
    reset_on_startup = true,
    bypass_all_unlocked = true,
    unlock_condition = function (self, args)
        if args and args.type == "win_custom" then
            if G.GAME.selected_back_key == "b_marv_consecrated" and MARV.is_above_stake(SMODS.stake_from_index(G.GAME.stake), "stake_gold") then
                return true
            end
        end
    end
}