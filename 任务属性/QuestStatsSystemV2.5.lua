print(">>  Loading QuestToStatsSystemV2 Code By Ayase")
--[[
完成任务获取属性加点lua脚本
by ayase
]]--
local StatsItemEntry = 60009 					--惯例的物品id 自己填
local QuestToStatsMagnification = 1		--任务数转化潜力点数倍率
local SetStatsPointsOnClick = 1					--每次点击加点的数量（默认：1）

local Stats={}


local Stats = {
--[[
算是完成了 ~\(≧▽≦)/~  下面的内容可以自行改动，现在是只有5属性的 可以取消注释(也就是下面的双减号"--")恢复额外的属性，也可以自行添加别的属性
因为做成半框架形式，所以在下面添加新的属性应该是可以直接加载并处理的 不过要注意的是不要写错了。。
★★★★注意最好不要直接用系统自带的文本编辑这个文件

以下是参数[1]核心定义的对应值 （别的只要复制一行 对照着改就没问题的了 数据库字段如果添加了新的属性的话需要在数据库表添加新的列，然后在数据库字段写上对应列的名字。。）
0→力量;1→敏捷;2→耐力;3→智力;4→精神;12→防御等级;13→躲闪等级;14→招架等级;15→盾牌格挡;16→近战命中;17→远程命中等级;18→法术命中等级;19→近战暴击;20→远程暴击等级;
21→法术暴击等级;22→近战躲闪等级;23→远程躲闪等级;24→法术躲闪等级;25→近战暴击躲闪等级;26→远程暴击躲闪等级;27→法术暴击躲闪等级;28→近战急速;29→远程急速;30→法术急速;
31→命中等级;32→暴击等级;33→命中躲闪等级;34→暴击躲闪等级;35→韧性等级;36→急速等级;37→精准等级;38→攻击强度;39→远程攻击强度;43→5秒回蓝;44→护甲穿透;45→法术伤害;46→法术治疗效果;
47→法术穿透;48→法术格挡？;998→HP(貌似无效);997→MP(貌似无效);

		核心定义；	需要多少点提升一点对应属性；限制各个属性加点数量；	显示的字符 可以加入颜色什么的			数据库字段							图标-双引号内留空表示不显示，格式： |T 路径:长:宽|t]]--
		{[1]=0,		["Consume"]=1,					["MAX"]=1000,		["Name"]="|cFFCC0000 力量|r",		["DBName"]="Strength",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=1,		["Consume"]=1,					["MAX"]=1000,		["Name"]="|cFFCC0000 敏捷|r",		["DBName"]="Agility",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=2,		["Consume"]=1,					["MAX"]=1000,		["Name"]="|cFFCC0000 耐力|r",		["DBName"]="Stamina",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=3,		["Consume"]=1,					["MAX"]=1000,		["Name"]="|cFFCC0000 智力|r",		["DBName"]="Intellect",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=4,		["Consume"]=1,					["MAX"]=1000,		["Name"]="|cFFCC0000 精神|r",		["DBName"]="Spirit",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=12,	["Consume"]=3,					["MAX"]=500,		["Name"]="|cFF0066FF 防御等级|r",	["DBName"]="CR_DEFENSE_SKILL",		["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=13,	["Consume"]=3,					["MAX"]=500,		["Name"]="|cFF0066FF 躲闪等级|r",	["DBName"]="CR_DODGE",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=14,	["Consume"]=3,					["MAX"]=500,		["Name"]="|cFF0066FF 招架等级|r",	["DBName"]="CR_PARRY",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=15,	["Consume"]=3,					["MAX"]=500,		["Name"]="|cFF0066FF 格挡等级|r",	["DBName"]="CR_BLOCK",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=31,	["Consume"]=3,					["MAX"]=500,		["Name"]="命中等级",				["DBName"]="CR_HIT",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=32,	["Consume"]=3,					["MAX"]=500,		["Name"]="暴击等级",				["DBName"]="CR_CRIT",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=36,	["Consume"]=3,					["MAX"]=500,		["Name"]="急速等级",				["DBName"]="CR_HASTE",				["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		--{[1]=35,	["Consume"]=0.4,				["MAX"]=999999,		["Name"]="|cFF0066FF 韧性等级",		["DBName"]="CR_CRIT_TAKEN",			["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		--{[1]=33,	["Consume"]=1,					["MAX"]=9999,		["Name"]="命中躲闪等级",			["DBName"]="CR_HIT_TAKEN",			["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=37,	["Consume"]=3,					["MAX"]=500,		["Name"]="精准等级",				["DBName"]="CR_EXPERTISE",			["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=38,	["Consume"]=2,					["MAX"]=2000,		["Name"]="攻击强度",				["DBName"]="ATTACK_POWER",			["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=39,	["Consume"]=2,					["MAX"]=2000,		["Name"]="远程攻强",				["DBName"]="ATTACK_POWER_RANGED",	["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=43,	["Consume"]=4,					["MAX"]=300,		["Name"]="每5秒回蓝",				["DBName"]="ManaRegenBonus",		["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=44,	["Consume"]=3,					["MAX"]=500,		["Name"]="护甲穿透",				["DBName"]="CR_ARMOR_PENETRATION",	["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=45,	["Consume"]=3,					["MAX"]=1500,		["Name"]="法术强度",				["DBName"]="SpellPowerBonus",		["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=46,	["Consume"]=2,					["MAX"]=1000,		["Name"]="治疗效果",				["DBName"]="HealthRegenBonus",		["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		{[1]=47,	["Consume"]=3,					["MAX"]=500,		["Name"]="法术穿透",				["DBName"]="SpellPenetrationBonus",	["Icon"]="|TInterface/ICONS/INV_Misc_Orb_04:20:20|t"},
		}

--不要改动这部分
local PlayerStats = {}	
local pStats = {}		
local pGUID = nil		
local pQuest = {}		
local pQuestNum = {}	
--不要改动这部分

function StatsSystem_Player_Onlogin_Event(player)
	local pGUID = player:GetGUIDLow()
	pStats = nil
	local DBNameTemp = "pGUID,"
	for k,v in pairs(Stats) do
		DBNameTemp = DBNameTemp..Stats[k]["DBName"]..","
	end
	pStats = CharDBQuery("SELECT "..string.sub(DBNameTemp,1,#DBNameTemp-1).." FROM character_QusetToStats WHERE pGUID="..pGUID)
	pQuest[pGUID] = CharDBQuery("SELECT counter FROM character_achievement_progress WHERE criteria=3631 and guid="..pGUID.." LIMIT 1")
	if (pQuest[pGUID]) then 
		pQuestNum[pGUID] = {["QuestNum"] = pQuest[pGUID]:GetInt32(0)}
	else 
		pQuestNum[pGUID] = {["QuestNum"] = 0}
	end
	PlayerStats[pGUID]={}
	if (pStats) then
		for k,v in pairs(Stats) do
			PlayerStats[pGUID][k] = {["Points"] = pStats:GetInt32(k)}
			player:SetState(Stats[k][1],PlayerStats[pGUID][k]["Points"],0)
		end
		player:SetHealth(player:GetMaxHealth())
	else
		for k,v in pairs(Stats) do
			PlayerStats[pGUID][k] = {["Points"] = 0}
		end
		CharDBExecute("INSERT INTO `character_qusettostats` (`pGUID`) VALUES ("..pGUID..")")
	end
	PlayerStats[pGUID]["Temp"]={}
	for k,v in pairs(Stats) do
		PlayerStats[pGUID]["Temp"][k] = 0
	end
	--Stats_AddGossid(event, player, item, target, intid)		--调试
end

function Stats_AddGossid(event, player, item, target, intid)
	local pGUID = player:GetGUIDLow()
	pQuestNum[pGUID]["AllStatsPoints"] = math.modf(pQuestNum[pGUID]["QuestNum"] * QuestToStatsMagnification) 
	pQuestNum[pGUID]["UseStatsPoints"] = 0
	for k,v in pairs(Stats) do
		pQuestNum[pGUID]["UseStatsPoints"] = pQuestNum[pGUID]["UseStatsPoints"] +  PlayerStats[pGUID][k]["Points"] * Stats[k]["Consume"]
	end
	pQuestNum[pGUID]["UseStatsPointsTemp"] = 0
	for k,v in pairs(Stats) do
		pQuestNum[pGUID]["UseStatsPointsTemp"] = pQuestNum[pGUID]["UseStatsPointsTemp"] + PlayerStats[pGUID]["Temp"][k] * Stats[k]["Consume"]
	end
	pQuestNum[pGUID]["CanUseStatsPoints"] = pQuestNum[pGUID]["AllStatsPoints"]-pQuestNum[pGUID]["UseStatsPoints"]-pQuestNum[pGUID]["UseStatsPointsTemp"]
	player:GossipMenuAddItem(4,"当前你完成任务数量为：|cFF006600 "..pQuestNum[pGUID]["QuestNum"].."|r个。\n 可用/总潜力点数 ( |cFFCC0000"..pQuestNum[pGUID]["CanUseStatsPoints"].."|r / |cFF0000CC"..pQuestNum[pGUID]["AllStatsPoints"].." )|r \n每次点击加"..SetStatsPointsOnClick.."点属性。",1,999)
	for k,v in pairs(Stats) do 	
		player:GossipMenuAddItem(4,Stats[k]["Icon"].." |cFF990066 <"..Stats[k]["Consume"].."潜力点> |r"..Stats[k]["Name"].." + |cFF006699"..PlayerStats[pGUID][k]["Points"]+PlayerStats[pGUID]["Temp"][k].."|R",1,k)	
	end
	player:GossipMenuAddItem(4,"|TInterface/ICONS/Spell_Priest_DivineStar:20:20|t >>  保存|R",1,10)	
	player:GossipSendMenu(1,player,50009)
end

function StatsSystem_Player_Onlogin(event, player)		
	StatsSystem_Player_Onlogin_Event(player)			
end


function SaveStatsPoints(event, player, item, target,intid)
	local pGUID = player:GetGUIDLow()
	local numTemp = 0
	local Stats_msg = true
	local TextTemp = ""
	for k,v in pairs(Stats) do
		if PlayerStats[pGUID]["Temp"][k] >0 then
			if Stats_msg ==true then
				player:SendBroadcastMessage("|cFF00FFFF 保存完毕,以下属性获得提升。|r") 
				Stats_msg = false
			end
			numTemp = numTemp + 1
			player:SetState(Stats[k][1],PlayerStats[pGUID]["Temp"][k],0) --(StateName,StateNum,bool)
			PlayerStats[pGUID][k]["Points"]	= PlayerStats[pGUID][k]["Points"] + PlayerStats[pGUID]["Temp"][k]
			TextTemp = TextTemp..Stats[k]["DBName"].."="..Stats[k]["DBName"].."+"..PlayerStats[pGUID]["Temp"][k]..","
			player:SendBroadcastMessage("|cFFFF9933  >>> |R"..Stats[k]["Name"].." + "..PlayerStats[pGUID]["Temp"][k])
			PlayerStats[pGUID]["Temp"][k] = 0
		end
	end	
	if numTemp == 0 then
		player:SendBroadcastMessage("|cFF00FFFF 保存失败，并没有加点数据需要保存。|r") 
	else
		CharDBExecute("update character_QusetToStats set "..string.sub(TextTemp,1,#TextTemp-1).." where pGUID="..pGUID)
	end
	player:GossipComplete()	
end

function Stats_seleGossid(event, player, item, target,intid,code)
	local pGUID = player:GetGUIDLow()
	if intid==999 then --Reload
		pQuestNum[pGUID]["UseStatsPoints"] = 0
		for k,v in pairs(Stats) do
			pQuestNum[pGUID]["UseStatsPoints"] = pQuestNum[pGUID]["UseStatsPoints"] +  PlayerStats[pGUID][k]["Points"]
		end		
			pQuestNum[pGUID]["AllStatsPoints"] = math.modf(pQuestNum[pGUID]["QuestNum"] * QuestToStatsMagnification)
		for k,v in pairs(Stats) do
			PlayerStats[pGUID]["Temp"][k] = 0
		end
		return Stats_AddGossid(event, player, item, target,intid,Spell,PlayerStats)
	elseif intid ==10 then --Save
		SaveStatsPoints(event, player, item, target,intid)
	else
		if pQuestNum[pGUID]["CanUseStatsPoints"] >= SetStatsPointsOnClick then
			for k,v in pairs(Stats) do
				if intid == k then
						
					if (PlayerStats[pGUID]["Temp"][k] + PlayerStats[pGUID][k]["Points"] + SetStatsPointsOnClick <= Stats[k]["MAX"]) then
						PlayerStats[pGUID]["Temp"][k] = PlayerStats[pGUID]["Temp"][k] + SetStatsPointsOnClick
						return Stats_AddGossid(event, player, item, target,intid)
					else
						player:SendBroadcastMessage("["..Stats[k]["Name"].."] 已被限制最大只能提升 "..Stats[k]["MAX"].." 点。")
						return Stats_AddGossid(event, player, item, target,intid)
					end
				end
			end
		else
			player:SendBroadcastMessage("可分配潜力点数不足。")
			return Stats_AddGossid(event, player, item, target,intid)
		end	
	end
end	

CharDBExecute([[
CREATE TABLE IF NOT EXISTS `character_qusettostats` (
`pGUID` int(10) NOT NULL,
  `Strength` int(10) NOT NULL DEFAULT '0' COMMENT '力量',
  `Agility` int(10) NOT NULL DEFAULT '0' COMMENT '敏捷',
  `Stamina` int(10) NOT NULL DEFAULT '0' COMMENT '耐力',
  `Intellect` int(10) NOT NULL DEFAULT '0' COMMENT '智力',
  `Spirit` int(10) NOT NULL DEFAULT '0' COMMENT '精神',
  `CR_DEFENSE_SKILL` int(10) NOT NULL DEFAULT '0' COMMENT '防御等级',
  `CR_DODGE` int(10) NOT NULL DEFAULT '0' COMMENT '躲闪等级',
  `CR_PARRY` int(10) NOT NULL DEFAULT '0' COMMENT '招架等级',
  `CR_BLOCK` int(10) NOT NULL DEFAULT '0' COMMENT '盾牌格挡',
  `CR_HIT` int(10) NOT NULL DEFAULT '0' COMMENT '命中',
  `CR_CRIT` int(10) NOT NULL DEFAULT '0' COMMENT '暴击',
  `CR_HASTE` int(10) NOT NULL DEFAULT '0' COMMENT '急速',
  `CR_CRIT_TAKEN` int(10) NOT NULL DEFAULT '0' COMMENT '韧性',
  `CR_HIT_TAKEN` int(10) NOT NULL DEFAULT '0' COMMENT '命中躲闪等级',
  `CR_EXPERTISE` int(10) NOT NULL DEFAULT '0' COMMENT '精准',
  `ATTACK_POWER` int(10) NOT NULL DEFAULT '0' COMMENT '攻击强度',
  `ATTACK_POWER_RANGED` int(10) NOT NULL DEFAULT '0' COMMENT '远程攻击强度',
  `ManaRegenBonus` int(10) NOT NULL DEFAULT '0' COMMENT '每5秒回蓝',
  `CR_ARMOR_PENETRATION` int(10) NOT NULL DEFAULT '0' COMMENT '护甲穿透',
  `SpellPowerBonus` int(10) NOT NULL DEFAULT '0' COMMENT '法术强度',
  `HealthRegenBonus` int(10) NOT NULL DEFAULT '0' COMMENT '法术治疗强度',
  `SpellPenetrationBonus` int(10) NOT NULL DEFAULT '0' COMMENT '法术穿透',
  `UNIT_MOD_HEALTH` int(10) NOT NULL DEFAULT '0' COMMENT '生命上限',
  `UNIT_MOD_MANA` int(10) NOT NULL DEFAULT '0' COMMENT '法力值上限',
  PRIMARY KEY (`pGUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

RegisterPlayerEvent(3,StatsSystem_Player_Onlogin)
RegisterItemGossipEvent(StatsItemEntry, 1, Stats_AddGossid)
--RegisterItemGossipEvent(StatsItemEntry, 1, StatsSystem_Player_Onlogin)
RegisterPlayerGossipEvent(50009,2,Stats_seleGossid)
