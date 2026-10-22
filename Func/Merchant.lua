local _,ns = ...
ns.event("PLAYER_LOGIN", function()
if AddUIDB.mh ==  true  then
-- Automatically sell junk (grey items)
ns.event("MERCHANT_SHOW", function() 
	local p,N,c,n=0
		for b=0,4 do
		    for s=1,C_Container.GetContainerNumSlots (b) do
			    n=C_Container.GetContainerItemLink(b,s)--https://warcraft.wiki.gg/wiki/UI_escape_sequences 
                    if n and string.find(n,"|cnIQ0") then--9d9d9d--Q0 grey 123456---https://warcraft.wiki.gg/wiki/Enum.ItemQuality
					    N={C_Item.GetItemInfo(n)} 
                        c=C_Item.GetItemCount(n)
						p= p+(N[11]*c)
						C_Container.UseContainerItem(b,s)
					end
			end
		end 
		--C_MerchantFrame.SellAllJunkItems()
    if p ~= 0 then
	    print("|cff44CCFFJunk sold: |r"..C_CurrencyInfo.GetCoinText(p))
	end
end)
end

-- One-click NPC sell button for equipment
-- Equipment to exclude from selling
local nosell = {
	[63352] = true,-- Cloak of Coordination
	[63206] = true,-- Cape of Coordination
	[65360] = true,-- Cloak of Cooperation
	[63353] = true,-- Horde Cloak of Coordination
	[63207] = true,-- Horde Cape of Coordination
	[65274] = true,-- Horde Cloak of Cooperation
	[152094]= true,-- Taeshalach
	[103678]= true,-- Teleport to Timeless Isle
}

-- 带使用效果的装备一律不卖（传送装备、收藏道具等都有“使用：”效果，比维护 ID 可靠）
local function HasUseEffect(link)
	local spellName = C_Item.GetItemSpell(link)
	if spellName == nil then
		-- 物品信息未缓存时无法判断，保守按“不卖”处理，避免误售传送装备
		return C_Item.GetItemInfo(link) == nil
	end
	return spellName ~= ""
end

StaticPopupDialogs.MerchantFrame_Sell = {
    text = "About to auto-sell\nSell equipment below which item level?",  -- Prompt text
    button1 = "Confirm",       -- Confirm button
    button2 = "Cancel",        -- Cancel button
    timeout = 0,               -- Do not auto-close
    whileDead = true,          -- Usable while dead
    hideOnEscape = true,       -- Close on ESC
    hasEditBox = true,         -- Include an input box
    -- “ESC to close uses Blizzard’s native callback (since 12.1, EditBox is no longer set via SetScript by addons, to avoid tainting shared popup objects)”
    EditBoxOnEscapePressed = StaticPopup_StandardEditBoxOnEscapePressed,
    OnAccept = function(self)  -- Callback after clicking Confirm
		local BoxLevel = tonumber(self.EditBox:GetText())
		if not BoxLevel then return end

		local total, money, rounds = 0, 0, 0

		local function SellOnce()
			local sold = 0
			for b = 0, 4 do
				for s = 1, C_Container.GetContainerNumSlots(b) do
					local link = C_Container.GetContainerItemLink(b, s)
					if link then
						local level = C_Item.GetDetailedItemLevelInfo(link)
						local N = {C_Item.GetItemInfo(link)}
						local itemID = tonumber(string.match(link, "item:(%d+)")) or 1
						if level and BoxLevel > level and level > 1 and (N[6] == ARMOR or N[6] == WEAPON) and not nosell[itemID] and not string.find(link, "|cnIQ5") and not HasUseEffect(link) then
							local info = C_Container.GetContainerItemInfo(b, s)
							total = total + 1
							money = money + (N[11] or 0) * (info and info.stackCount or 1)
							C_Container.UseContainerItem(b, s)
							sold = sold + 1
						end
					end
				end
			end
			rounds = rounds + 1
			-- 一轮没卖完就隔 0.3 秒继续，直到没有符合条件的装备（规避单次批量出售节流）
			if sold > 0 and rounds < 30 then
				C_Timer.After(0.3, SellOnce)
			elseif total > 0 then
				print("|cff44CCFF一Key sales: |r" .. total .. " pieces, total " .. C_CurrencyInfo.GetCoinText(money))
			end
		end

		SellOnce()
    end,
}
local Sell = CreateFrame("Button", "AddUISell", MerchantFrame.NineSlice, "UIPanelButtonTemplate")
Sell:SetText("Sell")
Sell:SetWidth(55)
Sell:SetHeight(22)
Sell:SetPoint("TOPLEFT", 57, 0)
Sell:SetScript("OnClick", function()
	StaticPopup_Show("MerchantFrame_Sell")
end)

-- Fast looting (fastest: grab everything the instant LOOT_READY fires)
-- Approach inspired by Plumber (author Peterodox) Modules/LootUI/FastLoot.lua
if AddUIDB.sq == true then
	local slotProcessed, retryPending
	local function LootAll()
		for i = 1, GetNumLootItems() do
			if LootSlotHasItem(i) and not (slotProcessed and slotProcessed[i]) then
				slotProcessed = slotProcessed or {}
				slotProcessed[i] = true
				LootSlot(i)
			end
		end
	end

	ns.event("LOOT_READY", function()
		LootAll()
	end)
	ns.event("LOOT_CLOSED", function()
		slotProcessed, retryPending = nil, nil
	end)
	ns.event("LOOT_SLOT_CLEARED", function(_, slot)
		if slotProcessed then slotProcessed[slot] = true end
	end)
	ns.event("LOOT_SLOT_CHANGED", function(_, slot)
		if not slotProcessed or retryPending then return end
		slotProcessed[slot] = false
		retryPending = true
		C_Timer.After(0.4, function()
			retryPending = nil
			LootAll()
		end)
	end)
end

end)
