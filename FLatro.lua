MARV = MARV or {}
MARV.config = SMODS.current_mod.config

assert(SMODS.load_file("lib/funcs.lua"))()
assert(SMODS.load_file("lib/hooks.lua"))()
assert(SMODS.load_file("etc/deckskin.lua"))()
assert(SMODS.load_file("etc/back.lua"))()
--assert(SMODS.load_file("etc/rank.lua"))()

local handfolder = SMODS.NFS.getDirectoryItems(SMODS.current_mod.path.."/hands")

for i,v in ipairs(handfolder) do
    if i ~= 1 then
        print("loading "..v)
        assert(SMODS.load_file("hands/"..v))()
    end
end