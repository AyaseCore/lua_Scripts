print(">>  Loading ItemUpSystem Code by Ayase")

local EquipUpItemEntry = 70000
local pSelectGos={}
local clNum = nil

local SlotName = {
	[0]="|cFF0000FF    头部：|r",		[1]="|cFF0000FF    项链：|r",		[2]="|cFF0000FF    肩膀：|r",	[3]="|cFF0000FF    衬衣：|r",
	[4]="|cFF0000FF    胸部：|r",		[5]="|cFF0000FF    腰带：|r",		[6]="|cFF0000FF    腿部：|r",	[7]="|cFF0000FF    脚部：|r",
	[8]="|cFF0000FF    手腕：|r",		[9]="|cFF0000FF    手套：|r",		[10]="|cFF0000FF    戒指A：|r",	[11]="|cFF0000FF    戒指B：|r",
	[12]="|cFF0000FF    饰品A：|r",		[13]="|cFF0000FF    饰品B：|r",		[14]="|cFF0000FF    背部：|r",	[15]="|cFF0000FF    主手装备：|r",
	[16]="|cFF0000FF    副手装备：|r",	[17]="|cFF0000FF    远程武器：|r",	[18]="|cFF0000FF    战袍：|r",
}

local ItemDisplay = {}
local ItemUpData = {}
local DBItemData = {}

local function LoadDBItemUP()
	local query = WorldDBQuery("SELECT * FROM item_up;")
	local a = 0
	if (query) then
		local Time1 = os.clock() * 1000
		clNum = (query:GetColumnCount()-4)/2
		repeat 
			ItemUpData[query:GetUInt32(0)] = {
				["up"] = query:GetUInt32(1),
				["jl"] = query:GetUInt32(2),
				["num"] = query:GetUInt32(3),
				["cl"] = {}
				}
				for i=1,clNum do
					ItemUpData[query:GetUInt32(0)]["cl"]["id"..i] = query:GetUInt32(2*i+2)
					ItemUpData[query:GetUInt32(0)]["cl"]["num"..i] = query:GetUInt32(2*i+3)
				end
			a = a+1
		until not query:NextRow()
		local Time2 = os.clock() * 1000
		print("     ItemUP->Loading "..a.." ItemUpData in "..Time2-Time1.." ms")
	end
end

local function LoadDBItemData()
	local query = WorldDBQuery("SELECT entry,displayid FROM item_template;")
	if (query) then
		local Time1 = os.clock() * 1000
		repeat 
			DBItemData[query:GetUInt32(0)] = query:GetUInt32(1)
		until not query:NextRow()
		local Time2 = os.clock() * 1000
		print("     ItemUP->Loading "..#DBItemData.." ItemData in "..Time2-Time1.."ms")
	end
end

local function LoadDBItemIcons()
	local query = WorldDBQuery("SELECT displayid,icon FROM item_icon;")
	if (query) then
		local Time1 = os.clock() * 1000
		repeat
			ItemDisplay[query:GetUInt32(0)] = query:GetCString(1)
		until not query:NextRow()
		local Time2 = os.clock() * 1000
		print("     ItemUP->Loading "..#ItemDisplay.." ItemIcon in "..Time2-Time1.."ms")
	end
end

LoadDBItemUP()
LoadDBItemData()
LoadDBItemIcons()

local function EquipmentUpgradeSystemEvent(event, p, item, target)
	local pGuid = p:GetGUIDLow()
	pSelectGos[pGuid] = 10086
	EquipmentUpgradeSystem(_,p,_,_)
end

function EquipmentUpgradeSystem(_,p,_,_)
	local pGuid = p:GetGUIDLow()
	p:GossipClearMenu()
	if pSelectGos[pGuid] == 10086 then
		for i=0,18 do
			local equip = p:GetEquippedItemBySlot(i)
			if equip then
				p:GossipMenuAddItem(0,"     "..SlotName[i].."\n|TInterface/ICONS/"..ItemDisplay[equip:GetDisplayId()]..":40:40:-15:12|t"..equip:GetItemLink(),1,i)
			end
		end
		p:GossipSendMenu(1,p,50021)
	else
		local equip = p:GetEquippedItemBySlot(pSelectGos[pGuid])
		if ItemUpData[equip:GetEntry()] == nil or DBItemData[ItemUpData[equip:GetEntry()]["up"]]==nil then
			p:SendBroadcastMessage("物品不可升级~") 
			p:GossipComplete()
		else
			local UpEntry = ItemUpData[equip:GetEntry()]["up"]
			p:GossipMenuAddItem(0,"         可升级至：\n|TInterface/ICONS/"..ItemDisplay[DBItemData[UpEntry]]..":40:40:-15:12|t"..GetItemLink(UpEntry),1,1000)
			local TextTem = "|TInterface/ICONS/"..ItemDisplay[equip:GetDisplayId()]..":40:40:-15:12|t"
			if ItemUpData[equip:GetEntry()]["num"] ~= 0 then 
				p:GossipMenuAddItem(0,"         |cFF0066CC需原物品： |r\n"..TextTem..GetItemLink(equip:GetEntry()).." x "..ItemUpData[equip:GetEntry()]["num"],1,1000)
			end
			for i=1,clNum do
				if ItemUpData[equip:GetEntry()]["cl"]["id"..i] ~=0 then
					local ItemIcon = "|TInterface/ICONS/"..ItemDisplay[DBItemData[ItemUpData[equip:GetEntry()]["cl"]["id"..i]]]..":40:40:-15:12|t"..GetItemLink(ItemUpData[equip:GetEntry()]["cl"]["id"..i])
					p:GossipMenuAddItem(0,"         |cFF666699 需要物品"..i.."：|r\n"..ItemIcon.." x "..ItemUpData[equip:GetEntry()]["cl"]["num"..i],1,1000)
				end
			end
			p:GossipMenuAddItem(0,"升级几率："..ItemUpData[equip:GetEntry()]["jl"].."%",1,1000)
			p:GossipMenuAddItem(0,"确认升级",1,999)
			p:GossipSendMenu(1,p,50021)
		end
	end
end

local function EquipmentUpgradeSystem_GossipSelect(event, player, object, sender, intid, code, menu_id)
	local pGuid = player:GetGUIDLow()
	if intid == 1000 then
		player:GossipComplete()
	elseif intid == 999 then
		if player:IsInCombat()==false then 
			local equip = player:GetEquippedItemBySlot(pSelectGos[pGuid])
			local ItemId = equip:GetEntry()
			local UpCheck = true
			if ItemUpData[ItemId]["num"]-1 >0 then
				if player:HasItem(ItemId,ItemUpData[ItemId]["num"]-1) == false then
					UpCheck = false
					player:SendBroadcastMessage("材料："..GetItemLink(ItemId).."数量不足.") 
				end
			end
			for i=1,clNum do
				if ItemUpData[ItemId]["cl"]["id"..i] ~=0 then
					if player:HasItem(ItemUpData[ItemId]["cl"]["id"..i],ItemUpData[ItemId]["cl"]["num"..i]) == false then
						UpCheck = false
						player:SendBroadcastMessage("材料："..GetItemLink(ItemUpData[ItemId]["cl"]["id"..i]).."数量不足.") 
					end
				end
			end
			if UpCheck then
				local jl = math.random(1,100)
				if jl <= ItemUpData[ItemId]["jl"] then
					local pEnchantment = {}
					for i=0,6 do
						pEnchantment[i] = equip:GetEnchantmentId(i)
					end
					player:RemoveItem(equip,1)
					player:RemoveItem(ItemId,ItemUpData[ItemId].num - 1)
					player:EquipItem(ItemUpData[ItemId]["up"],pSelectGos[pGuid])
					local pItem = player:GetEquippedItemBySlot(pSelectGos[pGuid])
					for i=0,6 do
						if pEnchantment[i]~= 0 then
							pItem:SetEnchantment(pEnchantment[i], i)
						end
					end
					pEnchantment=nil
					player:SendBroadcastMessage("装备升级成功。获得物品"..GetItemLink(ItemUpData[ItemId]["up"])) 
				else
					player:SendBroadcastMessage("装备升级失败。") 
				end
				for i=1,clNum do
					if ItemUpData[ItemId]["cl"]["id"..i] ~=0 then
						player:RemoveItem(ItemUpData[ItemId]["cl"]["id"..i],ItemUpData[ItemId]["cl"]["num"..i])
					end
				end
			end
		else
			player:SendBroadcastMessage("你正在战斗状态中，不可使用，除非你要作死~ ") 
		end
		player:GossipComplete()
	else
		for i=0,18 do
			if intid == i then
				local item = player:GetEquippedItemBySlot(i)
					pSelectGos[pGuid] = i
				return EquipmentUpgradeSystem(event,player,item,_)
			end
		end
	end
end

RegisterItemEvent(EquipUpItemEntry, 2, EquipmentUpgradeSystemEvent)
RegisterPlayerGossipEvent(50021,2,EquipmentUpgradeSystem_GossipSelect)

