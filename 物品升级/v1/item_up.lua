
print (">> Loading Equipment Upgrade System For Eluna.  Code By Ayase")

local pGuid=nil
local targetID={}
local targetCX={}
local targetCP={}
local targetCZ={}
local up = {}
local cz = {}
local czl = {}
local gailv=nil
local gailv_suiji=nil
local msg_TOrF=nil --是否强化成功 判定发送信息

local c1_TOrF,c2_TOrF,c3_TOrF,c4_TOrF,c5_TOrF
local H1_TOrF,H2_TOrF,H3_TOrF,H4_TOrF,H5_TOrF

local LuckyPoint=nil
local LuckyPointHas=nil
local LuckyPointTemp=nil

function Item_upHello(event, player, item, target)
		pGuid=player:GetGUIDLow()
		--幸运点函数
		LuckyPointTemp=0
		UseLuckyPoint=CharDBQuery("SELECT UseLuckyPoint FROM characters_luckypoints WHERE pGuid="..pGuid)
		if (UseLuckyPoint==nil) then
			CharDBExecute("INSERT INTO `characters_luckypoints` (`pGuid`, `pName`) VALUES ('"..pGuid.."', '"..player:GetName().."');")
			Item_upHello(event, player, item, target)
		end
		LuckyPointCX=CharDBQuery("SELECT counter FROM character_achievement_progress WHERE criteria = 4946 and guid="..pGuid)
		if (LuckyPointCX==nil) then
			LuckyPointCount=0
		else
			LuckyPointCount=math.modf(LuckyPointCX:GetInt32(0)*LuckyPointPCH)
		end
		LuckyPointHas=LuckyPointCount-UseLuckyPoint:GetInt32(0)
		--幸运点函数
		targetID[pGuid]=target:GetEntry()
		targetCX[pGuid]=WorldDBQuery("SELECT * FROM item_up WHERE `物品序号` ="..targetID[pGuid])
		targetCZ[pGuid]=WorldDBQuery("SELECT * FROM item_up WHERE `成品序号` ="..targetID[pGuid])--搜寻重置装备上一级装备id
		
		player:GossipClearMenu()
		if (targetCX[pGuid]) then
			up[pGuid]={
			tar = targetCX[pGuid]:GetInt32(0),
			up = targetCX[pGuid]:GetInt32(1),
			c1 = targetCX[pGuid]:GetInt32(2),
			s1 = targetCX[pGuid]:GetInt32(3),
			c2 = targetCX[pGuid]:GetInt32(4),
			s2 = targetCX[pGuid]:GetInt32(5),
			c3 = targetCX[pGuid]:GetInt32(6),
			s3 = targetCX[pGuid]:GetInt32(7),
			c4 = targetCX[pGuid]:GetInt32(8),
			s4 = targetCX[pGuid]:GetInt32(9),
			c5 = targetCX[pGuid]:GetInt32(10),
			s5 = targetCX[pGuid]:GetInt32(11),
			pch = targetCX[pGuid]:GetInt32(12)
			}
			player:GossipMenuAddItem(1,"    >>  物品强化",2,10)
		end
		if (targetCZ[pGuid]) then
			cz[pGuid]={
			self = targetCZ[pGuid]:GetInt32(0),
			tar = targetCZ[pGuid]:GetInt32(1),
			c1 = targetCZ[pGuid]:GetInt32(2),
			s1 = targetCZ[pGuid]:GetInt32(3),
			c2 = targetCZ[pGuid]:GetInt32(4),
			s2 = targetCZ[pGuid]:GetInt32(5),
			c3 = targetCZ[pGuid]:GetInt32(6),
			s3 = targetCZ[pGuid]:GetInt32(7),
			c4 = targetCZ[pGuid]:GetInt32(8),
			s4 = targetCZ[pGuid]:GetInt32(9),
			c5 = targetCZ[pGuid]:GetInt32(10),
			s5 = targetCZ[pGuid]:GetInt32(11),
			}
			czl[pGuid]={
			ss1 = math.modf(cz[pGuid].s1 * CzClItemCountBl),
			ss2 = math.modf(cz[pGuid].s2 * CzClItemCountBl),
			ss3 = math.modf(cz[pGuid].s3 * CzClItemCountBl),
			ss4 = math.modf(cz[pGuid].s4 * CzClItemCountBl),
			ss5 = math.modf(cz[pGuid].s5 * CzClItemCountBl),
			cs1 = math.modf(cz[pGuid].s1),
			cs2 = math.modf(cz[pGuid].s2 * chaijieItemCountBl),
			cs3 = math.modf(cz[pGuid].s3 * chaijieItemCountBl),
			cs4 = math.modf(cz[pGuid].s4 * chaijieItemCountBl),
			cs5 = math.modf(cz[pGuid].s5 * chaijieItemCountBl)
			}
			local t2,t3,t4,t5
			if (cz[pGuid].s2 >0) then t2="\n"..GetItemLink(cz[pGuid].c2).." x "..czl[pGuid].ss2 else t2 = "" end 
			if (cz[pGuid].s3 >0) then t3="\n"..GetItemLink(cz[pGuid].c3).." x "..czl[pGuid].ss3 else t3 = "" end
			if (cz[pGuid].s4 >0) then t4="\n"..GetItemLink(cz[pGuid].c4).." x "..czl[pGuid].ss4 else t4 = "" end
			if (cz[pGuid].s5 >0) then t5="\n"..GetItemLink(cz[pGuid].c5).." x "..czl[pGuid].ss5 else t5 = "" end
			player:GossipMenuAddItem(1,"    >>  装备重置",2,11,false,"========装备重置========\n\n重置装备至初始状态，如果是装绑的装备会还原至未绑定状态。\n\n|cFFFFCC66 重置装备前请确认背包中只包含唯一的一件该装备。\n如果有两件或以上请暂时放置到银行中。 |r \n\n重置需要消耗材料：\n"..t2..t3..t4..t5)
			local tt1,tt2,tt3,tt4,tt5
			if (cz[pGuid].s1 >0) then tt1="\n"..GetItemLink(cz[pGuid].c1).." x "..czl[pGuid].cs1  else tt1 = "" end 
			if (cz[pGuid].s2 >0) then tt2="\n"..GetItemLink(cz[pGuid].c2).." x "..czl[pGuid].cs2 else tt2 = "" end 
			if (cz[pGuid].s3 >0) then tt3="\n"..GetItemLink(cz[pGuid].c3).." x "..czl[pGuid].cs3 else tt3 = "" end
			if (cz[pGuid].s4 >0) then tt4="\n"..GetItemLink(cz[pGuid].c4).." x "..czl[pGuid].cs4 else tt4 = "" end
			if (cz[pGuid].s5 >0) then tt5="\n"..GetItemLink(cz[pGuid].c5).." x "..czl[pGuid].cs5 else tt5 = "" end
			player:GossipMenuAddItem(1,"    >>  装备拆解",2,12,false,"========装备拆解========\n\n合成装备通过拆解还原至上一等级的装备。\n\n|cFFFFCC66 拆解装备前请确认背包中只包含唯一的一件该装备。\n如果有两件或以上请暂时放置到银行中。 |r \n\n 拆解后可获得：\n"..tt1..tt2..tt3..tt4..tt5)
		end
		player:GossipSendMenu(2,player,50000)	
end	

function Item_up(event, player, item, target)
	pGuid=player:GetGUIDLow()
	if(targetCX[pGuid]==nil)then 
		player:SendBroadcastMessage("装备无法升级或者已达到升级最大次数。")
		player:SendAreaTriggerMessage("装备无法升级或者已达到升级最大次数。")
	else
		targetCP[pGuid]=WorldDBQuery("SELECT * FROM item_template WHERE ENTRY ="..up[pGuid].up)		
		if (targetCP[pGuid]==nil) then
			player:SendBroadcastMessage("装备无法升级或者已达到升级最大次数。")
			player:SendAreaTriggerMessage("装备无法升级或者已达到升级最大次数。")
		else
			player:GossipClearMenu()
			player:GossipMenuAddItem(1,"升级装备:"..GetItemLink(targetID[pGuid]),1,0)
			player:GossipMenuAddItem(1,"升级为:"..GetItemLink(up[pGuid].up).."\n(点击可查看)",1,1)
			local cltrue=nil
			
			if(up[pGuid].c1 >0)then 
				if (up[pGuid].s1<=player:GetItemCount(up[pGuid].c1)) then cltrue="|cFF00FF66√ |r" else  cltrue="|cFFCC0000× |r" end
				player:GossipMenuAddItem(1,cltrue.."材料1:"..GetItemLink(up[pGuid].c1).." x "..up[pGuid].s1.." |cFFA50000( "..player:GetItemCount(up[pGuid].c1).." )|r个",1,2)
				c1_TOrF = true
			else
				c1_TOrF = false
			end		 
			if(up[pGuid].c2 >0)then 
				if (up[pGuid].s2<=player:GetItemCount(up[pGuid].c2)) then cltrue="|cFF00FF66√ |r" else  cltrue="|cFFCC0000× |r" end
				player:GossipMenuAddItem(1,cltrue.."材料2:"..GetItemLink(up[pGuid].c2).." x "..up[pGuid].s2.." |cFFA50000( "..player:GetItemCount(up[pGuid].c2).." )|r个",1,3)
				c2_TOrF = true
			else 
			c2_TOrF = false
			end	 
			if(up[pGuid].c3 >0)then 
				if (up[pGuid].s3<=player:GetItemCount(up[pGuid].c3)) then cltrue="|cFF00FF66√ |r" else  cltrue="|cFFCC0000× |r" end
				player:GossipMenuAddItem(1,cltrue.."材料3:"..GetItemLink(up[pGuid].c3).." x "..up[pGuid].s3.." |cFFA50000( "..player:GetItemCount(up[pGuid].c3).." )|r个",1,4)
				c3_TOrF = true
			else 
				c3_TOrF = false
			end	   	 			
			if(up[pGuid].c4 >0)then 
				if (up[pGuid].s4<=player:GetItemCount(up[pGuid].c4)) then cltrue="|cFF00FF66√ |r" else  cltrue="|cFFCC0000× |r" end
				player:GossipMenuAddItem(1,cltrue.."材料4:"..GetItemLink(up[pGuid].c4).." x "..up[pGuid].s4.." |cFFA50000( "..player:GetItemCount(up[pGuid].c4).." )|r个",1,5)
				c4_TOrF = true
			else 
				c4_TOrF = false
			end		 
			if(up[pGuid].c5 >0)then 
				if (up[pGuid].s5<=player:GetItemCount(up[pGuid].c5)) then cltrue="|cFF00FF66√ |r" else  cltrue="|cFFCC0000× |r" end
				player:GossipMenuAddItem(1,cltrue.."材料5:"..GetItemLink(up[pGuid].c5).." x "..up[pGuid].s5.." |cFFA50000( "..player:GetItemCount(up[pGuid].c5).." )|r个",1,6)
				c5_TOrF = true
			else 
				c5_TOrF = false
			end		 
			player:GossipMenuAddItem(1,"升级成功率:"..up[pGuid].pch + LuckyPointTemp.."%  幸运点:( |cFF0000FF"..LuckyPointTemp.."|r / |cFF0000FF"..LuckyPointHas-LuckyPointTemp.."|r )",1,7)
			player:GossipMenuAddItem(1,"确认升级",1,8)
			player:GossipSendMenu(1,player,50000)	 
		end
    end
end

function re_add_item(event, player, item, target)  --装备重置
	pGuid=player:GetGUIDLow()
	if (player:GetItemCount(targetID[pGuid]) >1) then
		player:SendBroadcastMessage("装备重置失败，请检查背包，当前"..GetItemLink(targetID[pGuid]).."有"..player:GetItemCount(targetID[pGuid]).."件放置在您的背包中。")
		player:SendAreaTriggerMessage("装备重置失败，请检查背包，当前"..GetItemLink(targetID[pGuid]).."有"..player:GetItemCount(targetID[pGuid]).."件放置在您的背包中。")
	else
			local cz1_TorF,cz2_TorF,cz3_TorF,cz4_TorF,cz5_TorF
			local czH1_TorF,czH2_TorF,czH3_TorF,czH4_TorF,czH5_TorF
			if (czl[pGuid].ss1 >0) then cz1_TorF=true else cz1_TorF=false end
			if (czl[pGuid].ss2 >0) then cz2_TorF=true else cz2_TorF=false end
			if (czl[pGuid].ss3 >0) then cz3_TorF=true else cz3_TorF=false end
			if (czl[pGuid].ss4 >0) then cz4_TorF=true else cz4_TorF=false end
			if (czl[pGuid].ss5 >0) then cz5_TorF=true else cz5_TorF=false end
			if (cz1_TorF==true) then
				if (player:HasItem(cz[pGuid].c1, czl[pGuid].ss1)) then
					czH1_TorF = true
				else
					czH1_TorF = false
				end
			else
				czH1_TorF = true
			end
		
			if (cz2_TorF==true) then
				if (player:HasItem(cz[pGuid].c2, czl[pGuid].ss2)) then
					czH2_TorF = true
				else
					czH2_TorF = false
				end
			else
				czH2_TorF = true
			end
		
			if (cz3_TorF==true) then
				if (player:HasItem(cz[pGuid].c3, czl[pGuid].ss3)) then
					czH3_TorF = true
				else
					czH3_TorF = false
				end
			else
				czH3_TorF = true
			end
		
			if (cz4_TorF==true) then
				if (player:HasItem(cz[pGuid].c4, czl[pGuid].ss4)) then
					czH4_TorF = true
				else
					czH4_TorF = false
				end
			else
				czH4_TorF = true
			end
		
			if (cz5_TorF==true) then
				if (player:HasItem(cz[pGuid].c5, czl[pGuid].ss5)) then
					czH5_TorF = true
				else
					czH5_TorF = false
				end
			else
				czH5_TorF = true
			end
			if (czH1_TorF and czH2_TorF and czH3_TorF and czH4_TorF and czH5_TorF) then 
				if cz2_TorF then player:RemoveItem(cz[pGuid].c2, czl[pGuid].ss2) end
				if cz3_TorF then player:RemoveItem(cz[pGuid].c3, czl[pGuid].ss3) end
				if cz4_TorF then player:RemoveItem(cz[pGuid].c4, czl[pGuid].ss4) end
				if cz5_TorF then player:RemoveItem(cz[pGuid].c5, czl[pGuid].ss5) end
				player:RemoveItem(targetID[pGuid], 1)
				player:AddItem(targetID[pGuid], 1)
			else
			player:SendBroadcastMessage("重置失败，材料不足！")
			player:SendAreaTriggerMessage("重置失败，材料不足！")
			end
			player:GossipComplete()	
	end	
	targetID[pGuid]=nil
	targetCX[pGuid]=nil
	targetCZ[pGuid]=nil
	targetCP[pGuid]=nil
end

function chaijie_item(event, player, item, target)  --装备拆解
	pGuid=player:GetGUIDLow()
		if (player:GetItemCount(targetID[pGuid]) >1) then
			player:SendBroadcastMessage("装备拆解失败，请检查背包，当前"..GetItemLink(targetID[pGuid]).."有"..player:GetItemCount(targetID[pGuid]).."件放置在您的背包中。")
			player:SendAreaTriggerMessage("装备拆解失败，请检查背包，当前"..GetItemLink(targetID[pGuid]).."有"..player:GetItemCount(targetID[pGuid]).."件放置在您的背包中。")
		else
			if (czl[pGuid].cs1>0) then player:AddItem(cz[pGuid].c1,czl[pGuid].cs1) end
			if (czl[pGuid].cs2>0) then player:AddItem(cz[pGuid].c2,czl[pGuid].cs2) end
			if (czl[pGuid].cs3>0) then player:AddItem(cz[pGuid].c3,czl[pGuid].cs3) end
			if (czl[pGuid].cs4>0) then player:AddItem(cz[pGuid].c4,czl[pGuid].cs4) end
			if (czl[pGuid].cs5>0) then player:AddItem(cz[pGuid].c5,czl[pGuid].cs5) end
			player:SendBroadcastMessage("装备拆解成功。")
			player:SendAreaTriggerMessage("装备拆解成功。")
			player:RemoveItem(targetID[pGuid], 1)

		end
		player:GossipComplete()	
		targetID[pGuid]=nil
		targetCX[pGuid]=nil
		targetCZ[pGuid]=nil
		targetCP[pGuid]=nil
end

function item_up_en(event, player, item, sender, intid, code)
	pGuid=player:GetGUIDLow()
		gailv_suiji= math.random(1,100)
		gailv=gailv_suiji-LuckyPointTemp
		if (c1_TOrF==true) then
			if (player:HasItem(up[pGuid].c1, up[pGuid].s1)) then
				H1_TOrF = true
			else
				H1_TOrF = false
			end
		else
			H1_TOrF = true
		end
		
		if (c2_TOrF==true) then
			if (player:HasItem(up[pGuid].c2, up[pGuid].s2)) then
				H2_TOrF = true
			else
				H2_TOrF = false
			end
		else
			H2_TOrF = true
		end
		
		if (c3_TOrF==true) then
			if (player:HasItem(up[pGuid].c3, up[pGuid].s3)) then
				H3_TOrF = true
			else
				H3_TOrF = false
			end
		else
			H3_TOrF = true
		end
		
		if (c4_TOrF==true) then
			if (player:HasItem(up[pGuid].c4, up[pGuid].s4)) then
				H4_TOrF = true
			else
				H4_TOrF = false
			end
		else
			H4_TOrF = true
		end
		
		if (c5_TOrF==true) then
			if (player:HasItem(up[pGuid].c5, up[pGuid].s5)) then
				H5_TOrF = true
			else
				H5_TOrF = false
			end
		else
			H5_TOrF = true
		end
		
		if(H1_TOrF and H2_TOrF and H3_TOrF and H4_TOrF and H5_TOrF) then
			if c2_TOrF then player:RemoveItem(up[pGuid].c2, up[pGuid].s2) end
			if c3_TOrF then player:RemoveItem(up[pGuid].c3, up[pGuid].s3) end
			if c4_TOrF then player:RemoveItem(up[pGuid].c4, up[pGuid].s4) end
			if c5_TOrF then player:RemoveItem(up[pGuid].c5, up[pGuid].s5) end
			if(gailv<=up[pGuid].pch)then
				player:AddItem(up[pGuid].up, 1)
				player:RemoveItem(up[pGuid].c1, up[pGuid].s1)
				msg_TOrF=true
			else
				msg_TOrF=false
			end
			CharDBExecute("update characters_luckypoints set UseLuckyPoint=UseLuckyPoint+"..LuckyPointTemp..",pName='"..player:GetName().."' where pGuid="..pGuid..";")
		else
			player:SendBroadcastMessage("升级材料不足。")
			msg_TOrF=nil
		end
		
		if msg_TOrF==true then
			SendWorldMessage("恭喜玩家|cFF33FFFF"..player:GetName().."|r强化物品"..GetItemLink(targetID[pGuid]).. "至"..GetItemLink(up[pGuid].up).."成功。\n |cFF33FFFF 概览：随机数("..gailv_suiji..")-幸运点("..LuckyPointTemp..")=判定数("..gailv..")≤几率("..up[pGuid].pch..")。|r")
		elseif msg_TOrF==false then
			SendWorldMessage("玩家|cFF33FFFF"..player:GetName().."|r强化物品"..GetItemLink(targetID[pGuid]).. "至"..GetItemLink(up[pGuid].up).."失败，急需安慰。\n |cFF33FFFF 概览：随机数("..gailv_suiji..")-幸运点("..LuckyPointTemp..")=判定数("..gailv..")≥几率("..up[pGuid].pch..")。|r")
		end 
		player:GossipComplete()
	--	print("gailv:"..gailv)
	--	print("temp:"..LuckyPointTemp)
	--	print("jilv:"..up[pGuid].pch + LuckyPointTemp)
		targetID[pGuid]=nil
		targetCX[pGuid]=nil
		targetCZ[pGuid]=nil
		targetCP[pGuid]=nil
end

function Item_upOnSelect(event, player, item, sender, intid, code)
	pGuid=player:GetGUIDLow()
	if(intid == 7)then	
		if (up[pGuid].pch + LuckyPointTemp==100) then
			return Item_up(event, player, item, target)
		else
			if (LuckyPointTemp<25) then
				if (LuckyPointTemp<LuckyPointHas) then
					LuckyPointTemp=LuckyPointTemp+1
				else
					player:SendBroadcastMessage("幸运点数不足。")
				end
			else 
				return Item_up(event, player, item, target)
			end
		end	
			return Item_up(event, player, item, target)
	elseif(intid==10) then --装备升级
		Item_up(event, player, item, target)
	elseif(intid==11) then  --装备重置
		re_add_item(event, player, item, target)
	elseif(intid==12) then  --装备拆解
		chaijie_item(event, player, item, target)
	elseif(intid==1) then 
		player:SendBroadcastMessage("升级为:"..GetItemLink(up[pGuid].up))
		Item_up(event, player, item, target)
	elseif(intid == 8)then	
		item_up_en(event, player, item, sender, intid, code)
	end
end



--注册函数
	  RegisterItemEvent(UpItemEntry, 2, Item_upHello)
	  RegisterPlayerGossipEvent(50000,2,Item_upOnSelect)

	