local frame = CreateFrame("Frame", nil, UIParent)

local COLOR_COPPER = "eda55f"
local COLOR_SILVER = "c7c7cf"
local COLOR_GOLD = "ffd700"

local lastUpdate = 0
local lastMoney
local lastCount = 0

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

local onUpdate = function(self, elapsed)
	local profit = GetMoney() - lastMoney
	
	if profit ~= 0 then
		self:SetScript("OnUpdate", nil)
		
		if profit > 0 then
			DEFAULT_CHAT_FRAME:AddMessage(string.format("Sold %d trash item%s for %s.", lastCount, lastCount ~= 1 and "s" or "", formatMoney(profit)))
		end
	end 
end

local onEvent = function(self)
  local bag, slot
	
	lastMoney = GetMoney()
	lastCount = 0
  
	for bag = 0, 4 do
    if GetContainerNumSlots(bag) > 0 then
      for slot = 0, GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				
				if link then
					local itemName, itemLink, itemRarity = GetItemInfo(link)
					
					if itemRarity == 0 then
						UseContainerItem(bag, slot)
						lastCount = lastCount + GetItemCount(link)
					end
				end
      end
    end
  end
	
	if lastCount > 0 then
		self:SetScript("OnUpdate", onUpdate)
	end
end


frame:SetScript("OnEvent", onEvent)

frame:RegisterEvent("MERCHANT_SHOW")
