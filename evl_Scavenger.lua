local frame = CreateFrame("Frame")

local COLOR_COPPER = "eda55f"
local COLOR_SILVER = "c7c7cf"
local COLOR_GOLD = "ffd700"

local formatMoney = function(value)
	local gold = value / 10000
	local silver = mod(value / 100, 100)
	local copper = mod(value, 100)
	
	if value >= 10000 then
		return format("|cff%s%dg|r |cff%s%ds|r |cff%s%dc|r", COLOR_GOLD, gold, COLOR_SILVER, silver, COLOR_COPPER, copper)
	elseif value >= 100 then
		return format("|cff%s%ds|r |cff%s%dc|r", COLOR_SILVER, silver, COLOR_COPPER, copper)
	else
		return format("|cff%s%dc|r", COLOR_COPPER, copper)
	end
end

local onEvent = function()
	local sellCount = 0
	local sellAmount = 0
  
	for bag = 0, 4 do
    if GetContainerNumSlots(bag) > 0 then
      for slot = 1, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				
				if link then
					local _, _, quality, _, _, _, _, _, _, _, vendorPrice = GetItemInfo(link)
					local _, count = GetContainerItemInfo(bag, slot)
					
					if quality == 0 then
						UseContainerItem(bag, slot)
						sellCount = sellCount + count
						sellAmount = sellAmount + vendorPrice
					end
				end
      end
    end
  end
	
	if sellCount > 0 then
		DEFAULT_CHAT_FRAME:AddMessage(string.format("Selling %d trash item%s for %s.", sellCount, sellCount ~= 1 and "s" or "", formatMoney(sellAmount)))
	end
end


frame:SetScript("OnEvent", onEvent)

frame:RegisterEvent("MERCHANT_SHOW")