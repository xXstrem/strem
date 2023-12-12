Server_Done = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a')
redis = dofile("./libs/redis.lua").connect("127.0.0.1", 6379)
serpent = dofile("./libs/serpent.lua")
JSON    = dofile("./libs/dkjson.lua")
json    = dofile("./libs/JSON.lua")
URL     = dofile("./libs/url.lua")
http    = require("socket.http")
https   = require("ssl.https")
-------------------------------------------------------------------
whoami = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
uptime=io.popen([[echo `uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"D,",h+0,"H,",m+0,"M."}'`]]):read('*a'):gsub('[\n\r]+', '')
CPUPer=io.popen([[echo `top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`]]):read('*a'):gsub('[\n\r]+', '')
HardDisk=io.popen([[echo `df -lh | awk '{if ($6 == "/") { print $3"/"$2" ( "$5" )" }}'`]]):read('*a'):gsub('[\n\r]+', '')
linux_version=io.popen([[echo `lsb_release -ds`]]):read('*a'):gsub('[\n\r]+', '')
memUsedPrc=io.popen([[echo `free -m | awk 'NR==2{printf "%sMB/%sMB ( %.2f% )\n", $3,$2,$3*100/$2 }'`]]):read('*a'):gsub('[\n\r]+', '')
-------------------------------------------------------------------
Runbot = require('luatele')
-------------------------------------------------------------------
local infofile = io.open("./sudo.lua","r")
if not infofile then
if not redis:get(Server_Done.."token") then
os.execute('sudo rm -rf setup.lua')
io.write('\27[1;31mSend your Bot Token Now\n\27[0;39;49m')
local TokenBot = io.read()
if TokenBot and TokenBot:match('(%d+):(.*)') then
local url , res = https.request("https://api.telegram.org/bot"..TokenBot.."/getMe")
local Json_Info = JSON.decode(url)
if res ~= 200 then
print('\27[1;34mBot Token is Wrong\n')
else
io.write('\27[1;34mThe token been saved successfully \n\27[0;39;49m')
TheTokenBot = TokenBot:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..TheTokenBot)
redis:setex(Server_Done.."token",300,TokenBot)
end 
else
print('\27[1;34mToken not saved, try again')
end 
os.execute('lua5.3 start.lua')
end
if not redis:get(Server_Done.."id") then
io.write('\27[1;31mSend Developer ID\n\27[0;39;49m')
local UserId = io.read()
if UserId and UserId:match('%d+') then
io.write('\n\27[1;34mDeveloper ID saved \n\n\27[0;39;49m')
redis:setex(Server_Done.."id",300,UserId)
else
print('\n\27[1;34mDeveloper ID not saved\n')
end 
os.execute('lua5.3 start.lua')
end
local url , res = https.request('https://api.telegram.org/bot'..redis:get(Server_Done.."token")..'/getMe')
local Json_Info = JSON.decode(url)
local Inform = io.open("sudo.lua", 'w')
Inform:write([[
return {
	
Token = "]]..redis:get(Server_Done.."token")..[[",

id = ]]..redis:get(Server_Done.."id")..[[

}
]])
Inform:close()
local start = io.open("start", 'w')
start:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 start.lua
done
]])
start:close()
local Run = io.open("Run", 'w')
Run:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S ]]..Json_Info.result.username..[[ -X kill
screen -S ]]..Json_Info.result.username..[[ ./start
done
]])
Run:close()
redis:del(Server_Done.."id")
redis:del(Server_Done.."token")
os.execute('cp -a ../u/ ../'..Json_Info.result.username..' && rm -fr ~/u')
os.execute('cd && cd '..Json_Info.result.username..';chmod +x start;chmod +x Run;./Run')
end
Information = dofile('./sudo.lua')
sudoid = Information.id
Token = Information.Token
bot_id = Token:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..bot_id)
bot = Runbot.set_config{
api_id=12221441,
api_hash='9fb5fdf24e25e54b745478b4fb71573b',
session_name=bot_id,
token=Token
}
function coin(coin)
local Coins = tostring(coin)
local Coins = Coins:gsub('٠','0')
local Coins = Coins:gsub('١','1')
local Coins = Coins:gsub('٢','2')
local Coins = Coins:gsub('٣','3')
local Coins = Coins:gsub('٤','4')
local Coins = Coins:gsub('٥','5')
local Coins = Coins:gsub('٦','6')
local Coins = Coins:gsub('٧','7')
local Coins = Coins:gsub('٨','8')
local Coins = Coins:gsub('٩','9')
local Coins = Coins:gsub('-','')
local conis = tonumber(Coins)
return conis
end 
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
namebot = redis:get(bot_id..":namebot") or " ستريم"
SudosS = {5413631898}
Sudos = {sudoid,5413631898}
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function Bot(msg)  
local idbot = false  
if tonumber(msg.sender.user_id) == tonumber(bot_id) then  
idbot = true    
end  
return idbot  
end
function devS(user)  
local idSu = false  
for k,v in pairs(SudosS) do  
if tonumber(user) == tonumber(v) then  
idSu = true    
end
end  
return idSu  
end
function devB(user)  
local idSub = false  
for k,v in pairs(Sudos) do  
if tonumber(user) == tonumber(v) then  
idSub = true    
end
end  
return idSub
end
function programmer(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":Status:programmer",msg.sender.user_id) or devB(msg.sender.user_id) then    
return true  
else  
return false  
end  
end
end
function developer(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":Status:developer",msg.sender.user_id) or programmer(msg) then    
return true  
else  
return false  
end  
end
end
function Creator(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Creator", msg.sender.user_id) or developer(msg) then    
return true  
else  
return false  
end  
end
end
function BasicConstructor(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:BasicConstructor", msg.sender.user_id) or Creator(msg) then    
return true  
else  
return false  
end  
end
end
function Constructor(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Constructor", msg.sender.user_id) or BasicConstructor(msg) then    
return true  
else  
return false  
end  
end
end
function Owner(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Owner", msg.sender.user_id) or Constructor(msg) then    
return true  
else  
return false  
end  
end
end
function Administrator(msg)
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Administrator", msg.sender.user_id) or Owner(msg) then    
return true  
else  
return false  
end  
end
end
function Vips(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Vips", msg.sender.user_id) or Administrator(msg) or Bot(msg) then    
return true  
else  
return false  
end  
end
end
function Get_Rank(user_id,chat_id)
if devS(user_id) then  
var = 'مطور السورس'
elseif devB(user_id) then 
var = "المطور الاساسي"  
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = "المطور الثانوي"  
elseif tonumber(user_id) == tonumber(bot_id) then  
var = "البوت"
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = redis:get(bot_id..":Reply:developer"..chat_id) or "المطور"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = redis:get(bot_id..":Reply:Creator"..chat_id) or "المالك"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = redis:get(bot_id..":Reply:BasicConstructor"..chat_id) or "المنشئ الاساسي"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = redis:get(bot_id..":Reply:Constructor"..chat_id) or "المنشئ"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = redis:get(bot_id..":Reply:Owner"..chat_id)  or "المدير"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = redis:get(bot_id..":Reply:Administrator"..chat_id) or "الادمن"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = redis:get(bot_id..":Reply:Vips"..chat_id) or "المميز"  
else  
var = redis:get(bot_id..":Reply:mem"..chat_id) or "العضو"
end  
return var
end 
function Norank(user_id,chat_id)
if devS(user_id) then  
var = false
elseif devB(user_id) then 
var = false
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = false
elseif tonumber(user_id) == tonumber(bot_id) then  
var = false
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = false
else  
var = true
end  
return var
end 
function Isrank(user_id,chat_id)
if devS(user_id) then  
var = false
elseif devB(user_id) then 
var = false
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = false
elseif tonumber(user_id) == tonumber(bot_id) then  
var = false
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = true
else  
var = true
end  
return var
end 
function Total_message(msgs)  
local message = ''  
if tonumber(msgs) < 100 then 
message = 'غير متفاعل' 
elseif tonumber(msgs) < 200 then 
message = 'بده يتحسن' 
elseif tonumber(msgs) < 400 then 
message = 'شبه متفاعل' 
elseif tonumber(msgs) < 700 then 
message = 'متفاعل' 
elseif tonumber(msgs) < 1200 then 
message = 'متفاعل قوي' 
elseif tonumber(msgs) < 2000 then 
message = 'متفاعل جدا' 
elseif tonumber(msgs) < 3500 then 
message = 'اقوى تفاعل'  
elseif tonumber(msgs) < 4000 then 
message = 'متفاعل نار' 
elseif tonumber(msgs) < 4500 then 
message = 'قمة التفاعل' 
elseif tonumber(msgs) < 5500 then 
message = 'اقوى متفاعل' 
elseif tonumber(msgs) < 7000 then 
message = 'ملك التفاعل' 
elseif tonumber(msgs) < 9500 then 
message = 'امبروطور التفاعل' 
elseif tonumber(msgs) < 10000000000 then 
message = 'فول تفاعل'  
end 
return message 
end
function GetBio(User)
local var = "لايوجد"
local url , res = https.request("https://api.telegram.org/bot"..Token.."/getchat?chat_id="..User);
data = json:decode(url)
if data.result.bio then
var = data.result.bio
end
return var
end
function GetInfoBot(msg)
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = true else change_info = false
end
if GetMemberStatus.can_delete_messages then
delete_messages = true else delete_messages = false
end
if GetMemberStatus.can_invite_users then
invite_users = true else invite_users = false
end
if GetMemberStatus.can_pin_messages then
pin_messages = true else pin_messages = false
end
if GetMemberStatus.can_restrict_members then
restrict_members = true else restrict_members = false
end
if GetMemberStatus.can_promote_members then
promote = true else promote = false
end
return{
SetAdmin = promote,
BanUser = restrict_members,
Invite = invite_users,
PinMsg = pin_messages,
DelMsg = delete_messages,
Info = change_info
}
end
function GetSetieng(ChatId)
if redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "del" then
messageVideo= "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "ked" then 
messageVideo= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "ktm" then 
messageVideo= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "kick" then 
messageVideo= "بالطرد "   
else
messageVideo= "❌"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "del" then
messagePhoto = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "ked" then 
messagePhoto = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "ktm" then 
messagePhoto = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "kick" then 
messagePhoto = "بالطرد "   
else
messagePhoto = "❌"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "del" then
JoinByLink = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "ked" then 
JoinByLink = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "ktm" then 
JoinByLink = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "kick" then 
JoinByLink = "بالطرد "   
else
JoinByLink = "❌"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "del" then
WordsEnglish = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "ked" then 
WordsEnglish = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "ktm" then 
WordsEnglish = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "kick" then 
WordsEnglish = "بالطرد "   
else
WordsEnglish = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "del" then
WordsPersian = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "ked" then 
WordsPersian = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "ktm" then 
WordsPersian = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "kick" then 
WordsPersian = "بالطرد "   
else
WordsPersian = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "del" then
messageVoiceNote = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "ked" then 
messageVoiceNote = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "ktm" then 
messageVoiceNote = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "kick" then 
messageVoiceNote = "بالطرد "   
else
messageVoiceNote = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "del" then
messageSticker= "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "ked" then 
messageSticker= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "ktm" then 
messageSticker= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "kick" then 
messageSticker= "بالطرد "   
else
messageSticker= "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "del" then
AddMempar = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "ked" then 
AddMempar = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "ktm" then 
AddMempar = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "kick" then 
AddMempar = "بالطرد "   
else
AddMempar = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "del" then
messageAnimation = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "ked" then 
messageAnimation = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "ktm" then 
messageAnimation = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "kick" then 
messageAnimation = "بالطرد "   
else
messageAnimation = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "del" then
messageDocument= "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "ked" then 
messageDocument= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "ktm" then 
messageDocument= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "kick" then 
messageDocument= "بالطرد "   
else
messageDocument= "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "del" then
messageAudio = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "ked" then 
messageAudio = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "ktm" then 
messageAudio = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "kick" then 
messageAudio = "بالطرد "   
else
messageAudio = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "del" then
messagePoll = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "ked" then 
messagePoll = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "ktm" then 
messagePoll = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "kick" then 
messagePoll = "بالطرد "   
else
messagePoll = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "del" then
messageVideoNote = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "ked" then 
messageVideoNote = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "ktm" then 
messageVideoNote = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "kick" then 
messageVideoNote = "بالطرد "   
else
messageVideoNote = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "del" then
messageContact = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "ked" then 
messageContact = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "ktm" then 
messageContact = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "kick" then 
messageContact = "بالطرد "   
else
messageContact = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "del" then
messageLocation = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "ked" then 
messageLocation = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "ktm" then 
messageLocation = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "kick" then 
messageLocation = "بالطرد "   
else
messageLocation = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "del" then
Cmd = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "ked" then 
Cmd = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "ktm" then 
Cmd = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "kick" then 
Cmd = "بالطرد "   
else
Cmd = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "del" then
messageSenderChat = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "ked" then 
messageSenderChat = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "ktm" then 
messageSenderChat = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "kick" then 
messageSenderChat = "بالطرد "   
else
messageSenderChat = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "del" then
messagePinMessage = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "ked" then 
messagePinMessage = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "ktm" then 
messagePinMessage = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "kick" then 
messagePinMessage = "بالطرد "   
else
messagePinMessage = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "del" then
Keyboard = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "ked" then 
Keyboard = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "ktm" then 
Keyboard = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "kick" then 
Keyboard = "بالطرد "   
else
Keyboard = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Username") == "del" then
Username = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "ked" then 
Username = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "ktm" then 
Username = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "kick" then 
Username = "بالطرد "   
else
Username = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "del" then
Tagservr = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "ked" then 
Tagservr = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "ktm" then 
Tagservr = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "kick" then 
Tagservr = "بالطرد "   
else
Tagservr = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "del" then
WordsFshar = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "ked" then 
WordsFshar = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "ktm" then 
WordsFshar = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "kick" then 
WordsFshar = "بالطرد "   
else
WordsFshar = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "del" then
Markdaun = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "ked" then 
Markdaun = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "ktm" then 
Markdaun = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "kick" then 
Markdaun = "بالطرد "   
else
Markdaun = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Links") == "del" then
Links = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "ked" then 
Links = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "ktm" then 
Links = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "kick" then 
Links = "بالطرد "   
else
Links = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "del" then
forward_info = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "ked" then 
forward_info = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "ktm" then 
forward_info = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "kick" then 
forward_info = "بالطرد "   
else
forward_info = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "del" then
messageChatAddMembers = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "ked" then 
messageChatAddMembers = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "ktm" then 
messageChatAddMembers = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "kick" then 
messageChatAddMembers = "بالطرد "   
else
messageChatAddMembers = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "del" then
via_bot_user_id = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "ked" then 
via_bot_user_id = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "ktm" then 
via_bot_user_id = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "kick" then 
via_bot_user_id = "بالطرد "   
else
via_bot_user_id = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "del" then
Hashtak = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "ked" then 
Hashtak = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "ktm" then 
Hashtak = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "kick" then 
Hashtak = "بالطرد "   
else
Hashtak = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "del" then
Edited = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "ked" then 
Edited = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "ktm" then 
Edited = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "kick" then 
Edited = "بالطرد "   
else
Edited = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "del" then
Spam = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "ked" then 
Spam = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "ktm" then 
Spam = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "kick" then 
Spam = "بالطرد "   
else
Spam = "❌"   
end    
if redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "kick" then 
flood = "بالطرد "   
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "del" then 
flood = "✔️" 
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "ked" then
flood = "بالتقييد "   
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "ktm" then
flood = "بالكتم "    
else
flood = "❌"   
end     
return {
flood = flood,
Spam = Spam,
Edited = Edited,
Hashtak = Hashtak,
messageChatAddMembers = messageChatAddMembers,
via_bot_user_id = via_bot_user_id,
Markdaun = Markdaun,
Links = Links,
forward_info = forward_info ,
Username = Username,
WordsFshar = WordsFshar,
Tagservr = Tagservr,
messagePinMessage = messagePinMessage,
messageSenderChat = messageSenderChat,
Keyboard = Keyboard,
messageLocation = messageLocation,
Cmd = Cmd,
messageContact =messageContact,
messageAudio = messageAudio,
messageVideoNote = messageVideoNote,
messagePoll = messagePoll,
messageDocument= messageDocument,
messageAnimation = messageAnimation,
AddMempar = AddMempar,
messageSticker= messageSticker,
WordsPersian = WordsPersian,
messageVoiceNote = messageVoiceNote,
JoinByLink = JoinByLink,
messagePhoto = messagePhoto,
WordsEnglish = WordsEnglish,
messageVideo= messageVideo
}
end
function Reply_Status(UserId,TextMsg)
UserInfo = bot.getUser(UserId)
Name_User = UserInfo.first_name
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
UserInfousername = '['..UserInfo.first_name..'](tg://user?id='..UserId..')'
end
return {
by   = '\n*  ⌔︙بواسطة : *'..UserInfousername..'\n'..TextMsg,
i   = '\n*  ⌔︙المستخدم : *'..UserInfousername..'\n'..TextMsg,
yu    = '\n*  ⌔︙عزيزي : *'..UserInfousername..'\n'..TextMsg
}
end
function getJson(R)  
programmer = redis:smembers(bot_id..":Status:programmer")
developer = redis:smembers(bot_id..":Status:developer")
user_id = redis:smembers(bot_id..":user_id")
chat_idgr = redis:smembers(bot_id..":Groups")
local fresuult = {
programmer = programmer,
developer = developer,
chat_id = chat_idgr,
user_id = user_id, 
bot = bot_id
} 
gresuult = {} 
for k,v in pairs(chat_idgr) do   
Creator = redis:smembers(bot_id..":"..v..":Status:Creator")
if Creator then
cre = {ids = Creator}
end
BasicConstructor = redis:smembers(bot_id..":"..v..":Status:BasicConstructor")
if BasicConstructor then
bc = {ids = BasicConstructor}
end
Constructor = redis:smembers(bot_id..":"..v..":Status:Constructor")
if Constructor then
cr = {ids = Constructor}
end
Owner = redis:smembers(bot_id..":"..v..":Status:Owner")
if Owner then
on = {ids = Owner}
end
Administrator = redis:smembers(bot_id..":"..v..":Status:Administrator")
if Administrator then
ad = {ids = Administrator}
end
Vips = redis:smembers(bot_id..":"..v..":Status:Vips")
if Vips then
vp = {ids = Vips}
end
gresuult[v] = {
BasicConstructor = bc,
Administrator = ad, 
Constructor = cr, 
Creator = cre, 
Owner = on,
Vips = vp
}
end
local resuult = {
bot = fresuult,
groups = gresuult
}
local File = io.open('./'..bot_id..'.json', "w")
File:write(JSON.encode (resuult))
File:close()
bot.sendDocument(R,0,'./'..bot_id..'.json', '  ⌔︙تم جلب النسخة الاحتياطية', 'md')
end
function download(url,name)
if not name then
name = url:match('([^/]+)$')
end
if string.find(url,'https') then
data,res = https.request(url)
elseif string.find(url,'http') then
data,res = http.request(url)
else
return 'The link format is incorrect.'
end
if res ~= 200 then
return 'check url , error code : '..res
else
file = io.open(name,'wb')
file:write(data)
file:close()
return './'..name
end
end
function redis_get(ChatId,tr)
if redis:get(bot_id..":"..ChatId..":settings:"..tr)  then
tf = "✔️" 
else
tf = "❌"   
end    
return tf
end
function Adm_Callback()
if redis:get(bot_id..":Twas") then
Twas = "✅"
else
Twas = "❌"
end
if redis:get(bot_id..":Notice") then
Notice = "✅"
else
Notice = "❌"
end
if redis:get(bot_id..":Departure") then
Departure  = "✅"
else
Departure = "❌"
end
if redis:get(bot_id..":sendbot") then
sendbot  = "✅"
else
sendbot = "❌"
end
if redis:get(bot_id..":infobot") then
infobot  = "✅"
else
infobot = "❌"
end
return {
t   = Twas,
n   = Notice,
d   = Departure,
s   = sendbot,
i    = infobot
}
end
---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function Callback(data)
----------------------------------------------------------------------------------------------------
Text = bot.base64_decode(data.payload.data)
user_id = data.sender_user_id
chat_id = data.chat_id
msg_id = data.message_id
if Text and Text:match("^mn_(.*)_(.*)") then
local infomsg = {Text:match("^mn_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id," ⌔︙ عذرا الامر لا يخصك ", true)
end
if Type == "st" then  
ty =  "الملصقات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Sticker"..data.chat_id)  
t = " ⌔︙ قائمة "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id," ⌔︙ قائمة "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Sticker"..data.chat_id) 
elseif Type == "tx" then  
ty =  "الكلمات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Text"..data.chat_id)  
t = " ⌔︙ قائمة "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id," ⌔︙ قائمة "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Text"..data.chat_id) 
elseif Type == "gi" then  
 ty =  "المتحركات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Animation"..data.chat_id)  
t = " ⌔︙ قائمة "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id," ⌔︙ قائمة "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Animation"..data.chat_id) 
elseif Type == "ph" then  
ty =  "الصور الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Photo"..data.chat_id) 
t = " ⌔︙ قائمة "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id," ⌔︙ قائمة "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Photo"..data.chat_id) 
elseif Type == "up" then  
local Photo =redis:scard(bot_id.."mn:content:Photo"..data.chat_id) 
local Animation =redis:scard(bot_id.."mn:content:Animation"..data.chat_id)  
local Sticker =redis:scard(bot_id.."mn:content:Sticker"..data.chat_id)  
local Text =redis:scard(bot_id.."mn:content:Text"..data.chat_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = 'الصور الممنوعه', data="mn_"..data.sender_user_id.."_ph"},{text = 'الكلمات الممنوعه', data="mn_"..data.sender_user_id.."_tx"}},
{{text = 'المتحركات الممنوعه', data="mn_"..data.sender_user_id.."_gi"},{text = 'الملصقات الممنوعه',data="mn_"..data.sender_user_id.."_st"}},
{{text = 'تحديث',data="mn_"..data.sender_user_id.."_up"}},
}
}
bot.editMessageText(chat_id,msg_id,"*   ⌔︙تحوي قائمة المنع على\n  ⌔︙الصور ( "..Photo.." )\n  ⌔︙الكلمات ( "..Text.." )\n  ⌔︙الملصقات ( "..Sticker.." )\n  ⌔︙المتحركات ( "..Animation.." )\n  ⌔︙اضغط على القائمة المراد حذفها*", 'md', true, false, reply_markup)
bot.answerCallbackQuery(data.id,"تم تحديث النتائج", true)
end
end
if Text == 'EndAddarray'..user_id then  
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
if redis:get(bot_id..'Set:array'..user_id..':'..chat_id) == 'true1' then
redis:del(bot_id..'Set:array'..user_id..':'..chat_id)
bot.editMessageText(chat_id,msg_id,"*  ⌔︙تم حفظ الردود بنجاح*", 'md', true, false, reply_markup)
else
bot.editMessageText(chat_id,msg_id," *  ⌔︙تم تنفيذ الامر سابقا*", 'md', true, false, reply_markup)
end
end
if Text and Text:match("^Sur_(.*)_(.*)") then
local infomsg = {Text:match("^Sur_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, " ⌔︙ الامر لا يخصك", true)
return false
end   
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
if tonumber(infomsg[2]) == 1 then
if GetInfoBot(data).BanUser == false then
bot.editMessageText(chat_id,msg_id,"*   ⌔︙لا يمتلك البوت صلاحية حظر الاعضاء*", 'md', true, false, reply_markup)
return false
end   
if not Isrank(data.sender_user_id,chat_id) then
t = "*  ⌔︙لا يمكن للبوت حظر "..Get_Rank(data.sender_user_id,chat_id).."*"
else
t = "*  ⌔︙تم طردك بنجاح*"
bot.setChatMemberStatus(chat_id,data.sender_user_id,'banned',0)
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
elseif tonumber(infomsg[2]) == 2 then
bot.editMessageText(chat_id,msg_id,"*  ⌔︙تم الغاء العمليه الطرد بنجاح*", 'md', true, false, reply_markup)
end
end
if Text and Text:match("^Amr_(.*)_(.*)") then
local infomsg = {Text:match("^Amr_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, " ⌔︙ الامر لا يخصك", true)
return false
end   
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "أوامر الحماية" ,data="Amr_"..data.sender_user_id.."_1"},{text = "إعدادات المجموعة",data="Amr_"..data.sender_user_id.."_2"}},
{{text = "فتح/قفل",data="Amr_"..data.sender_user_id.."_3"},{text ="اخرى",data="Amr_"..data.sender_user_id.."_4"}},
{{text = '- الاوامر الرئيسية .',data="Amr_"..data.sender_user_id.."_5"}},
}
}
if infomsg[2] == '1' then
reply_markup = reply_markup
t = "* ⌔︙ اوامر الحماية اتبع مايلي\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ قفل ، فتح ← الامر\n ⌔︙ تستطيع قفل حماية كما يلي\n ⌔︙ { بالتقييد ، بالطرد ، بالكتم ، بالتقييد }\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ تاك\n ⌔︙ القناة\n ⌔︙ الصور\n ⌔︙ الرابط\n ⌔︙ السب\n ⌔︙ الموقع\n ⌔︙ التكرار\n ⌔︙ الفيديو\n ⌔︙ الدخول\n ⌔︙ الاضافة\n ⌔︙ الاغاني\n ⌔︙ الصوت\n ⌔︙ الملفات\n ⌔︙ المنشورات\n ⌔︙ الدردشة\n ⌔︙ الجهات\n ⌔︙ السيلفي\n ⌔︙ التثبيت\n ⌔︙ الشارحة\n ⌔︙ الرسائل\n ⌔︙ البوتات\n ⌔︙ التوجيه\n ⌔︙ التعديل\n ⌔︙ الانلاين\n ⌔︙ المعرفات\n ⌔︙ الكيبورد\n ⌔︙ الفارسية\n ⌔︙ الانجليزية\n ⌔︙ الاستفتاء\n ⌔︙ الملصقات\n ⌔︙ الاشعارات\n ⌔︙ الماركداون\n ⌔︙ المتحركات*"
elseif infomsg[2] == '2' then
reply_markup = reply_markup
t = "* ⌔︙ اعدادات المجموعة \n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙  الترحيب  \n ⌔︙  مسح الرتب  \n ⌔︙  الغاء التثبيت  \n ⌔︙  فحص البوت  \n ⌔︙  تعين الرابط  \n ⌔︙  مسح الرابط  \n ⌔︙  تغيير الايدي  \n ⌔︙  تعين الايدي  \n ⌔︙  مسح الايدي  \n ⌔︙  مسح الترحيب  \n ⌔︙  صورتي  \n ⌔︙  تغيير اسم المجموعة  \n ⌔︙  تعين قوانين  \n ⌔︙  تغيير الوصف  \n ⌔︙  مسح القوانين  \n ⌔︙  مسح الرابط  \n ⌔︙  تنظيف التعديل  \n ⌔︙  تنظيف الميديا  \n ⌔︙  مسح الرابط  \n ⌔︙  رفع الادامن  \n ⌔︙  تعين ترحيب  \n ⌔︙  الترحيب  \n ⌔︙  الالعاب الاحترافية  \n ⌔︙  المجموعة  *"
elseif infomsg[2] == '3' then
reply_markup = reply_markup
t = "* ⌔︙ اوامر التفعيل والتعطيل \n ⌔︙ تفعيل/تعطيل الامر اسفل  \n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙  اوامر التسلية  \n ⌔︙  الالعاب الاحترافية  \n ⌔︙  الطرد  \n ⌔︙  الحظر  \n ⌔︙  الرفع  \n ⌔︙  المميزات  \n ⌔︙  المسح التلقائي  \n ⌔︙  ٴall  \n ⌔︙  منو ضافني  \n ⌔︙  تفعيل الردود  \n ⌔︙  الايدي بالصورة  \n ⌔︙  الايدي  \n ⌔︙  التنظيف  \n ⌔︙  الترحيب  \n ⌔︙  الرابط  \n ⌔︙  البايو  \n ⌔︙  صورتي  \n ⌔︙  الالعاب  *"
elseif infomsg[2] == '4' then
reply_markup = reply_markup
t = "* ⌔︙ اوامر اخرى \n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ الالعاب الاحترافية \n ⌔︙ المجموعة \n ⌔︙ الرابط \n ⌔︙ اسمي \n ⌔︙ ايديي \n ⌔︙ مسح نقاطي \n ⌔︙ نقاطي \n ⌔︙ مسح رسائلي \n ⌔︙ رسائلي \n ⌔︙ مسح جهاتي \n ⌔︙ مسح بالرد  \n ⌔︙ تفاعلي \n ⌔︙ جهاتي \n ⌔︙ مسح تعديلاتي \n ⌔︙ تعديلاتي \n ⌔︙ رتبتي \n ⌔︙ معلوماتي \n ⌔︙ المنشئ \n ⌔︙ رفع المنشئ \n ⌔︙ البايو/نبذتي \n ⌔︙ التاريخ/الساعة \n ⌔︙ رابط الحذف \n ⌔︙ الالعاب \n ⌔︙ منع بالرد \n ⌔︙ منع \n ⌔︙ تنظيف + عدد \n ⌔︙ قائمة المنع \n ⌔︙ مسح قائمة المنع \n ⌔︙ مسح الاوامر المضافة \n ⌔︙ الاوامر المضافة \n ⌔︙ ترتيب الاوامر \n ⌔︙ اضف امر \n ⌔︙ حذف امر \n ⌔︙ اضف رد \n ⌔︙ حذف رد \n ⌔︙ ردود المدير \n ⌔︙ مسح ردود المدير \n ⌔︙ الردود المتعددة \n ⌔︙ مسح الردود المتعددة \n ⌔︙ وضع عدد المسح +رقم \n ⌔︙ مسح البوتات \n ⌔︙ ٴall \n ⌔︙ غنيلي، فلم، متحركة، رمزية، فيديو \n ⌔︙ تغير رد {العضو. المميز. الادمن. المدير. المنشئ. المنشئ الاساسي. المالك. المطور }  \n ⌔︙ حذف رد {العضو. المميز. الادمن. المدير. المنشئ. المنشئ الاساسي. المالك. المطور}  *"
elseif infomsg[2] == '5' then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "أوامر الحماية" ,data="Amr_"..data.sender_user_id.."_1"},{text = "إعدادات المجموعة",data="Amr_"..data.sender_user_id.."_2"}},
{{text = "فتح/قفل",data="Amr_"..data.sender_user_id.."_3"},{text ="اخرى",data="Amr_"..data.sender_user_id.."_4"}},
{{text = '𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆.',url="t.me/xXStrem"}},
}
}
t = "*  ⌔︙قائمة الاوامر \n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n  ⌔︙م1 ( اوامر الحماية ) \n  ⌔︙م2 ( اوامر إعدادات المجموعة ) \n  ⌔︙م3 ( اوامر القفل والفتح ) \n  ⌔︙م4 ( اوامر اخرى ) *"
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------
if Text and Text:match("^GetSeBk_(.*)_(.*)") then
local infomsg = {Text:match("^GetSeBk_(.*)_(.*)")}
num = tonumber(infomsg[1])
any = tonumber(infomsg[2])
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, " ⌔︙ الامر لا يخصك", true)
return false
end  
if any == 0 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكيبورد'" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "'الملصقات'" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "'الاغاني'" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "'الانجليزي'" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "'الفارسية'" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "'الدخول'" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "'الصور'" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "'الجهات'" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "'السيلفي'" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..user_id.."_1"}},
}
}
elseif any == 1 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الاستفتاء'" ,data="GetSe_"..user_id.."_messagePoll"},{text =GetSetieng(chat_id).messagePoll,data="GetSe_"..user_id.."_messagePoll"}},
{{text = "'الصوت'" ,data="GetSe_"..user_id.."_messageAudio"},{text =GetSetieng(chat_id).messageAudio,data="GetSe_"..user_id.."_messageAudio"}},
{{text = "'الملفات'" ,data="GetSe_"..user_id.."_messageDocument"},{text =GetSetieng(chat_id).messageDocument,data="GetSe_"..user_id.."_messageDocument"}},
{{text = "'المتحركات'" ,data="GetSe_"..user_id.."_messageAnimation"},{text =GetSetieng(chat_id).messageAnimation,data="GetSe_"..user_id.."_messageAnimation"}},
{{text = "'الاضافة'" ,data="GetSe_"..user_id.."_AddMempar"},{text =GetSetieng(chat_id).AddMempar,data="GetSe_"..user_id.."_AddMempar"}},
{{text = "'التثبيت'" ,data="GetSe_"..user_id.."_messagePinMessage"},{text =GetSetieng(chat_id).messagePinMessage,data="GetSe_"..user_id.."_messagePinMessage"}},
{{text = "'القناة'" ,data="GetSe_"..user_id.."_messageSenderChat"},{text = GetSetieng(chat_id).messageSenderChat ,data="GetSe_"..user_id.."_messageSenderChat"}},
{{text = "'الشارحة'" ,data="GetSe_"..user_id.."_Cmd"},{text =GetSetieng(chat_id).Cmd,data="GetSe_"..user_id.."_Cmd"}},
{{text = "'الموقع'" ,data="GetSe_"..user_id.."_messageLocation"},{text = GetSetieng(chat_id).messageLocation ,data="GetSe_"..user_id.."_messageLocation"}},
{{text = "'التكرار'" ,data="GetSe_"..user_id.."_flood"},{text = GetSetieng(chat_id).flood ,data="GetSe_"..user_id.."_flood"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_0"},{text = "'➡️'" ,data="GetSeBk_"..user_id.."_2"}},
}
}
elseif any == 2 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'المنشورات'" ,data="GetSe_"..user_id.."_Spam"},{text =GetSetieng(chat_id).Spam,data="GetSe_"..user_id.."_Spam"}},
{{text = "'التعديل'" ,data="GetSe_"..user_id.."_Edited"},{text = GetSetieng(chat_id).Edited ,data="GetSe_"..user_id.."_Edited"}},
{{text = "'التاك'" ,data="GetSe_"..user_id.."_Hashtak"},{text =GetSetieng(chat_id).Hashtak,data="GetSe_"..user_id.."_Hashtak"}},
{{text = "'الانلاين'" ,data="GetSe_"..user_id.."_via_bot_user_id"},{text = GetSetieng(chat_id).via_bot_user_id ,data="GetSe_"..user_id.."_via_bot_user_id"}},
{{text = "'البوتات'" ,data="GetSe_"..user_id.."_messageChatAddMembers"},{text =GetSetieng(chat_id).messageChatAddMembers,data="GetSe_"..user_id.."_messageChatAddMembers"}},
{{text = "'التوجيه'" ,data="GetSe_"..user_id.."_forward_info"},{text = GetSetieng(chat_id).forward_info ,data="GetSe_"..user_id.."_forward_info"}},
{{text = "'الروابط'" ,data="GetSe_"..user_id.."_Links"},{text =GetSetieng(chat_id).Links,data="GetSe_"..user_id.."_Links"}},
{{text = "'الماركداون'" ,data="GetSe_"..user_id.."_Markdaun"},{text = GetSetieng(chat_id).Markdaun ,data="GetSe_"..user_id.."_Markdaun"}},
{{text = "'السب'" ,data="GetSe_"..user_id.."_WordsFshar"},{text =GetSetieng(chat_id).WordsFshar,data="GetSe_"..user_id.."_WordsFshar"}},
{{text = "'الاشعارات'" ,data="GetSe_"..user_id.."_Tagservr"},{text = GetSetieng(chat_id).Tagservr ,data="GetSe_"..user_id.."_Tagservr"}},
{{text = "'المعرفات'" ,data="GetSe_"..user_id.."_Username"},{text =GetSetieng(chat_id).Username,data="GetSe_"..user_id.."_Username"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_1"},{text = "'أوامر التفعيل'" ,data="GetSeBk_"..user_id.."_3"}},
}
}
elseif any == 3 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'اطردني'" ,data="GetSe_"..user_id.."_kickme"},{text =redis_get(chat_id,"kickme"),data="GetSe_"..user_id.."_kickme"}},
{{text = "'البايو'" ,data="GetSe_"..user_id.."_GetBio"},{text =redis_get(chat_id,"GetBio"),data="GetSe_"..user_id.."_GetBio"}},
{{text = "'الرابط'" ,data="GetSe_"..user_id.."_link"},{text =redis_get(chat_id,"link"),data="GetSe_"..user_id.."_link"}},
{{text = "'الترحيب'" ,data="GetSe_"..user_id.."_Welcome"},{text =redis_get(chat_id,"Welcome"),data="GetSe_"..user_id.."_Welcome"}},
{{text = "'الايدي'" ,data="GetSe_"..user_id.."_id"},{text =redis_get(chat_id,"id"),data="GetSe_"..user_id.."_id"}},
{{text = "'الايدي بالصورة'" ,data="GetSe_"..user_id.."_id:ph"},{text =redis_get(chat_id,"id:ph"),data="GetSe_"..user_id.."_id:ph"}},
{{text = "'التنظيف'" ,data="GetSe_"..user_id.."_delmsg"},{text =redis_get(chat_id,"delmsg"),data="GetSe_"..user_id.."_delmsg"}},
{{text = "'التسلية'" ,data="GetSe_"..user_id.."_entertainment"},{text =redis_get(chat_id,"entertainment"),data="GetSe_"..user_id.."_entertainment"}},
{{text = "'الالعاب الاحترافية'" ,data="GetSe_"..user_id.."_gameVip"},{text =redis_get(chat_id,"gameVip"),data="GetSe_"..user_id.."_gameVip"}},
{{text = "'ضافني'" ,data="GetSe_"..user_id.."_addme"},{text =redis_get(chat_id,"addme"),data="GetSe_"..user_id.."_addme"}},
{{text = "'الردود'" ,data="GetSe_"..user_id.."_Reply"},{text =redis_get(chat_id,"Reply"),data="GetSe_"..user_id.."_Reply"}},
{{text = "'الالعاب'" ,data="GetSe_"..user_id.."_game"},{text =redis_get(chat_id,"game"),data="GetSe_"..user_id.."_game"}},
{{text = "'صورتي'" ,data="GetSe_"..user_id.."_phme"},{text =redis_get(chat_id,"phme"),data="GetSe_"..user_id.."_phme"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_2"}}
}
}
end
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اعدادات المجموعة *", 'md', true, false, reply_markup)
end
if Text and Text:match("^GetSe_(.*)_(.*)") then
local infomsg = {Text:match("^GetSe_(.*)_(.*)")}
ifd = infomsg[1]
Amr = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, " ⌔︙ الامر لا يخصك", true)
return false
end  
if not redis:get(bot_id..":"..chat_id..":settings:"..Amr) then
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"del")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "del" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"ktm")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "ktm" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"ked")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "ked" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"kick")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "kick" then 
redis:del(bot_id..":"..chat_id..":settings:"..Amr)    
end   
if Amr == "messageVideoNote" or Amr == "messageVoiceNote" or Amr == "messageSticker" or Amr == "Keyboard" or Amr == "JoinByLink" or Amr == "WordsPersian" or Amr == "WordsEnglish" or Amr == "messageContact" or Amr == "messageVideo" or Amr == "messagePhoto" then 
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكيبورد'" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "'الملصقات'" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "'الاغاني'" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "'الانجليزي'" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "'الفارسية'" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "'الدخول'" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "'الصور'" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "'الجهات'" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "'السيلفي'" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..user_id.."_1"}},
}
}
elseif Amr == "messagePoll" or Amr == "messageAudio" or Amr == "messageDocument" or Amr == "messageAnimation" or Amr == "AddMempar" or Amr == "messagePinMessage" or Amr == "messageSenderChat" or Amr == "Cmd" or Amr == "messageLocation" or Amr == "flood" then 
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الاستفتاء'" ,data="GetSe_"..user_id.."_messagePoll"},{text =GetSetieng(chat_id).messagePoll,data="GetSe_"..user_id.."_messagePoll"}},
{{text = "'الصوت'" ,data="GetSe_"..user_id.."_messageAudio"},{text =GetSetieng(chat_id).messageAudio,data="GetSe_"..user_id.."_messageAudio"}},
{{text = "'الملفات'" ,data="GetSe_"..user_id.."_messageDocument"},{text =GetSetieng(chat_id).messageDocument,data="GetSe_"..user_id.."_messageDocument"}},
{{text = "'المتحركات'" ,data="GetSe_"..user_id.."_messageAnimation"},{text =GetSetieng(chat_id).messageAnimation,data="GetSe_"..user_id.."_messageAnimation"}},
{{text = "'الاضافة'" ,data="GetSe_"..user_id.."_AddMempar"},{text =GetSetieng(chat_id).AddMempar,data="GetSe_"..user_id.."_AddMempar"}},
{{text = "'التثبيت'" ,data="GetSe_"..user_id.."_messagePinMessage"},{text =GetSetieng(chat_id).messagePinMessage,data="GetSe_"..user_id.."_messagePinMessage"}},
{{text = "'القناة'" ,data="GetSe_"..user_id.."_messageSenderChat"},{text = GetSetieng(chat_id).messageSenderChat ,data="GetSe_"..user_id.."_messageSenderChat"}},
{{text = "'الشارحة'" ,data="GetSe_"..user_id.."_Cmd"},{text =GetSetieng(chat_id).Cmd,data="GetSe_"..user_id.."_Cmd"}},
{{text = "'الموقع'" ,data="GetSe_"..user_id.."_messageLocation"},{text = GetSetieng(chat_id).messageLocation ,data="GetSe_"..user_id.."_messageLocation"}},
{{text = "'التكرار'" ,data="GetSe_"..user_id.."_flood"},{text = GetSetieng(chat_id).flood ,data="GetSe_"..user_id.."_flood"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_0"},{text = "'➡️'" ,data="GetSeBk_"..user_id.."_2"}},
}
}
elseif Amr == "Edited" or Amr == "Spam" or Amr == "Hashtak" or Amr == "via_bot_user_id" or Amr == "forward_info" or Amr == "messageChatAddMembers" or Amr == "Links" or Amr == "Markdaun" or Amr == "Username" or Amr == "Tagservr" or Amr == "WordsFshar" then  
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'المنشورات'" ,data="GetSe_"..user_id.."_Spam"},{text =GetSetieng(chat_id).Spam,data="GetSe_"..user_id.."_Spam"}},
{{text = "'التعديل'" ,data="GetSe_"..user_id.."_Edited"},{text = GetSetieng(chat_id).Edited ,data="GetSe_"..user_id.."_Edited"}},
{{text = "'التاك'" ,data="GetSe_"..user_id.."_Hashtak"},{text =GetSetieng(chat_id).Hashtak,data="GetSe_"..user_id.."_Hashtak"}},
{{text = "'الانلاين'" ,data="GetSe_"..user_id.."_via_bot_user_id"},{text = GetSetieng(chat_id).via_bot_user_id ,data="GetSe_"..user_id.."_via_bot_user_id"}},
{{text = "'البوتات'" ,data="GetSe_"..user_id.."_messageChatAddMembers"},{text =GetSetieng(chat_id).messageChatAddMembers,data="GetSe_"..user_id.."_messageChatAddMembers"}},
{{text = "'التوجيه'" ,data="GetSe_"..user_id.."_forward_info"},{text = GetSetieng(chat_id).forward_info ,data="GetSe_"..user_id.."_forward_info"}},
{{text = "'الروابط'" ,data="GetSe_"..user_id.."_Links"},{text =GetSetieng(chat_id).Links,data="GetSe_"..user_id.."_Links"}},
{{text = "'الماركداون'" ,data="GetSe_"..user_id.."_Markdaun"},{text = GetSetieng(chat_id).Markdaun ,data="GetSe_"..user_id.."_Markdaun"}},
{{text = "'السب'" ,data="GetSe_"..user_id.."_WordsFshar"},{text =GetSetieng(chat_id).WordsFshar,data="GetSe_"..user_id.."_WordsFshar"}},
{{text = "'الاشعارات'" ,data="GetSe_"..user_id.."_Tagservr"},{text = GetSetieng(chat_id).Tagservr ,data="GetSe_"..user_id.."_Tagservr"}},
{{text = "'المعرفات'" ,data="GetSe_"..user_id.."_Username"},{text =GetSetieng(chat_id).Username,data="GetSe_"..user_id.."_Username"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_2"},{text = "'أوامر التفعيل'" ,data="GetSeBk_"..user_id.."_3"}},
}
}
end
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اعدادات المجموعة *", 'md', true, false, reply_markup)
end
---
if devB(data.sender_user_id) then
if Text == "Can" then
redis:del(bot_id..":set:"..chat_id..":UpfJson") 
redis:del(bot_id..":set:"..chat_id..":send") 
redis:del(bot_id..":set:"..chat_id..":dev") 
redis:del(bot_id..":set:"..chat_id..":namebot") 
redis:del(bot_id..":set:"..chat_id..":start") 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "UpfJson" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم بأعاده ارسال الملف الخاص بالنسخة*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":UpfJson",true) 
end
if Text == "GetfJson" then
bot.answerCallbackQuery(data.id, "  ⌔︙جار ارسال النسخة", true)
getJson(chat_id)
dofile("start.lua")
end
if Text == "Delch" then
if not redis:get(bot_id..":TheCh") then
bot.answerCallbackQuery(data.id, "  ⌔︙لم يتم وضع اشتراك في البوت", true)
return false
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙تم حذف البوت بنجاح*", 'md', true, false, reply_markup)
redis:del(bot_id..":TheCh")
end
if Text == "addCh" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم برفع البوت ادمن في قناتك ثم قم بأرسل توجيه من القناة الى البوت*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":addCh",true)
end
if Text == 'TheCh' then
if not redis:get(bot_id..":TheCh") then
bot.answerCallbackQuery(data.id, "  ⌔︙لم يتم وضع اشتراك في البوت", true)
return false
end
idD = redis:get(bot_id..":TheCh")
Get_Chat = bot.getChat(idD)
Info_Chats = bot.getSupergroupFullInfo(idD)
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = Get_Chat.title,url=Info_Chats.invite_link.invite_link}},
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙الاشتراك الاجباري على القناة اسفل :*", 'md', true, false, reply_dev)
end
if Text == "indfo" then
Groups = redis:scard(bot_id..":Groups")   
user_id = redis:scard(bot_id..":user_id") 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قسم الاحصائيات \n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n  ⌔︙عدد المشتركين ( "..user_id.." ) عضو \n  ⌔︙عدد المجموعات ( "..Groups.." ) مجموعة *", 'md', true, false, reply_dev)
end
if Text == "chatmem" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ اضف اشتراك',data="addCh"},{text =" ⌔︙ حذف اشتراك",data="Delch"}},
{{text = ' ⌔︙ الاشتراك',data="TheCh"}},
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في لوحه اوامر الاشتراك الاجباري*", 'md', true, false, reply_dev)
end
if Text == "EditDevbot" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم الان بأرسل ايدي المطور الجديد*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":dev",true) 
end
if Text == "addstarttxt" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم الان بأرسل رسالة ستارت الجديده*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":start",true) 
end
if Text == 'lsbnal' then
t = '\n* ⌔︙ قائمة محظورين عام  \n ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد محظورين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == 'lsmu' then
t = '\n* ⌔︙ قائمة المكتومين عام  \n  ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد مكتومين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == "delbnal" then
local Info_ = redis:smembers(bot_id..":bot:Ban")
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد محظورين في البوت", true)
return false
end  
redis:del(bot_id..":bot:Ban")
bot.answerCallbackQuery(data.id, " ⌔︙ تم مسح المحظورين بنجاح", true)
end
if Text == "delmu" then
local Info_ = redis:smembers(bot_id..":bot:silent")
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد مكتومين في البوت ", true)
return false
end  
redis:del(bot_id..":bot:silent")
bot.answerCallbackQuery(data.id, " ⌔︙ تم مسح المكتومين بنجاح", true)
end
if Text == 'lspor' then
t = '\n* ⌔︙ قائمة الثانويين  \n  ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد ثانويين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == 'lsdev' then
t = '\n* ⌔︙ قائمة المطورين  \n  ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد مطورين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == "UpSu" then
bot.answerCallbackQuery(data.id, " ⌔︙ تم تحديث السورس", true)
os.execute('rm -rf start.lua')
os.execute('curl -s https://raw.githubusercontent.com/xXStrem/BoT/main/start.lua -o start.lua')
dofile('start.lua')  
end
if Text == "UpBot" then
bot.answerCallbackQuery(data.id, " ⌔︙ تم تحديث البوت", true)
dofile("start.lua")
end
if Text == "Deltxtstart" then
redis:del(bot_id..":start") 
bot.answerCallbackQuery(data.id, "- تم حذف رسالة ستارت بنجاح .", true)
end
if Text == "delnamebot" then
redis:del(bot_id..":namebot") 
bot.answerCallbackQuery(data.id, " ⌔︙ تم حذف اسم البوت بنجاح", true)
end
if Text == "infobot" then
if redis:get(bot_id..":infobot") then
redis:del(bot_id..":infobot")
else
redis:set(bot_id..":infobot",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "Twas" then
if redis:get(bot_id..":Twas") then
redis:del(bot_id..":Twas")
else
redis:set(bot_id..":Twas",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "Notice" then
if redis:get(bot_id..":Notice") then
redis:del(bot_id..":Notice")
else
redis:set(bot_id..":Notice",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "sendbot" then
if redis:get(bot_id..":sendbot") then
redis:del(bot_id..":sendbot")
else
redis:set(bot_id..":sendbot",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "Departure" then
if redis:get(bot_id..":Departure") then
redis:del(bot_id..":Departure")
else
redis:set(bot_id..":Departure",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "namebot" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم الان بأرسل اسم البوت الجديد*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":namebot",true) 
end
if Text == "delpor" then
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد ثانويين في البوت", true)
return false
end
redis:del(bot_id..":Status:programmer") 
bot.answerCallbackQuery(data.id, " ⌔︙ تم مسح الثانويين بنجاح", true)
end
if Text == "deldev" then
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, " ⌔︙ لا يوجد مطورين في البوت", true)
return false
end
redis:del(bot_id..":Status:developer") 
bot.answerCallbackQuery(data.id, " ⌔︙ تم مسح المطورين بنجاح", true)
end
if Text == "clenMsh" then
local list = redis:smembers(bot_id..":user_id")   
local x = 0
for k,v in pairs(list) do  
local Get_Chat = bot.getChat(v)
local ChatAction = bot.sendChatAction(v,'Typing')
if ChatAction.luatele ~= "ok" then
x = x + 1
redis:srem(bot_id..":user_id",v)
end
end
if x ~= 0 then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
return bot.editMessageText(chat_id,msg_id,'*  ⌔︙العدد الكلي ( '..#list..' )\n  ⌔︙تم العثور على ( '..x..' ) من المشتركين الوهميين*', 'md', true, false, reply_dev)
else
return bot.editMessageText(chat_id,msg_id,'*  ⌔︙العدد الكلي ( '..#list.." )\n  ⌔︙لم يتم العثور على وهميين*", 'md', true, false, reply_dev)
end
end
if Text == "clenMg" then
local list = redis:smembers(bot_id..":Groups")   
local x = 0
for k,v in pairs(list) do  
local Get_Chat = bot.getChat(v)
if Get_Chat.id then
local statusMem = bot.getChatMember(Get_Chat.id,bot_id)
if statusMem.status.luatele == "chatMemberStatusMember" then
x = x + 1
bot.sendText(Get_Chat.id,0,'*  ⌔︙البوت ليس ادمن في المجموعة*',"md")
redis:srem(bot_id..":Groups",Get_Chat.id)
local keys = redis:keys(bot_id..'*'..Get_Chat.id)
for i = 1, #keys do
redis:del(keys[i])
end
bot.leaveChat(Get_Chat.id)
end
else
x = x + 1
local keys = redis:keys(bot_id..'*'..v)
for i = 1, #keys do
redis:del(keys[i])
end
redis:srem(bot_id..":Groups",v)
bot.leaveChat(v)
end
end
if x ~= 0 then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
return bot.editMessageText(chat_id,msg_id,'*  ⌔︙العدد الكلي ( '..#list..' )\n  ⌔︙تم العثور على ( '..x..' ) من المجموعات الوهمية*', 'md', true, false, reply_dev)
else
return bot.editMessageText(chat_id,msg_id,'*  ⌔︙العدد الكلي ( '..#list.." )\n  ⌔︙لم يتم العثور على مجموعات وهمية*", 'md', true, false, reply_dev)
end
end
if Text == "sendtomem" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ رسالة للكل',data="AtSer_Tall"},{text =" ⌔︙ توجيه للكل",data="AtSer_Fall"}},
{{text = ' ⌔︙ رسالة للمجموعات',data="AtSer_Tgr"},{text =" ⌔︙ توجيه للمجموعات",data="AtSer_Fgr"}},
{{text = ' ⌔︙ رسالة للاعضاء',data="AtSer_Tme"},{text =" ⌔︙ توجيه للاعضاء",data="AtSer_Fme"}},
{{text = ' ⌔︙ رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*  ⌔︙اوامر الاذاعة الخاصه بالبوت*", 'md', true, false, reply_dev)
end
if Text and Text:match("^AtSer_(.*)") then
local infomsg = {Text:match("^AtSer_(.*)")}
iny = infomsg[1]
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ الغاء',data="Can"}},
}
}
redis:setex(bot_id..":set:"..chat_id..":send",600,iny)  
bot.editMessageText(chat_id,msg_id,"*  ⌔︙قم الان بأرسال الرسالة *", 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------
end
end
----------------------------------------------------------------------------------------------------
-- end function Callback
----------------------------------------------------------------------------------------------------
function Run(msg,data)
if msg.content.text then
text = msg.content.text.text
else 
text = nil
end
----------------------------------------------------------------------------------------------------
if devB(msg.sender.user_id) then
if redis:get(bot_id..":set:"..msg.chat_id..":send") then
TrS = redis:get(bot_id..":set:"..msg.chat_id..":send")
list = redis:smembers(bot_id..":Groups")   
lis = redis:smembers(bot_id..":user_id") 
if msg.forward_info or text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then 
redis:del(bot_id..":set:"..msg.chat_id..":send") 
if TrS == "Fall" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم توجيه الرسالة الى ( "..#lis.." عضو ) و ( "..#list.." مجموعة ) *","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) مجموعة جار الاذاعة للاعضاء *","md",true)
redis:del(bot_id..":count:true") 
for k,g in pairs(lis) do  
local FedMsg = bot.forwardMessages(g, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Fgr" then
bot.sendText(msg.chat_id,msg.id,"*- يتم توجيه الرسالة الى ( "..#list.." مجموعة ) *","md",true)      
for k,v in pairs(list) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) مجموعة *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Fme" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم توجيه الرسالة الى ( "..#lis.." عضو ) *","md",true)      
for k,v in pairs(lis) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tall" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم ارسال الرسالة الى ( "..#lis.." عضو ) و ( "..#list.." مجموعة ) *","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) مجموعة جار الاذاعة للاعضاء *","md",true)
redis:del(bot_id..":count:true") 
for k,v in pairs(lis) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tgr" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم ارسال الرسالة الى ( "..#list.." مجموعة ) *","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) مجموعة *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tme" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم ارسال الرسالة الى ( "..#lis.." عضو ) *","md",true)      
for k,v in pairs(lis) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعة ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
end 
return false
end
end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
if bot.getChatId(msg.chat_id).type == "basicgroup" then
if devB(msg.sender.user_id) then
----------------------------------------------------------------------------------------------------
if redis:get(bot_id..":set:"..msg.chat_id..":UpfJson") then
if msg.content.document then
redis:del(bot_id..":set:"..msg.chat_id..":UpfJson") 
local File_Id = msg.content.document.document.remote.id
local Name_File = msg.content.document.file_name
if tonumber(Name_File:match('(%d+)')) ~= tonumber(bot_id) then 
return bot.sendText(msg.chat_id,msg.id,'*  ⌔︙عذرا الملف هذا ليس للبوت*')
end
local File = json:decode(https.request('https://api.telegram.org/bot'..Token..'/getfile?file_id='..File_Id)) 
local download_ = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path,''..Name_File) 
local Get_Info = io.open(download_,"r"):read('*a')
local gups = JSON.decode(Get_Info)
if gups.bot.chat_id then
redis:sadd(bot_id..":Groups",gups.bot.chat_id)  
end
if gups.bot.user_id then
redis:sadd(bot_id..":user_id",gups.bot.user_id)  
end
if gups.bot.programmer then
redis:sadd(bot_id..":programmer",gups.bot.programmer)  
end
if gups.bot.developer then
redis:sadd(bot_id..":developer",gups.bot.developer)  
end
for kk,vv in pairs(gups.bot.chat_id) do
if gups.groups and gups.groups[vv] then
if gups.groups[vv].Creator then
redis:sadd(bot_id..":"..vv..":Status:Creator",gups.groups[vv].Creator.ids)
end
if gups.groups[vv].BasicConstructor then
redis:sadd(bot_id..":"..vv..":Status:BasicConstructor",gups.groups[vv].BasicConstructor.ids)
end
if gups.groups[vv].Constructor then
redis:sadd(bot_id..":"..vv..":Status:Constructor",gups.groups[vv].Constructor.ids.ids)
end
if gups.groups[vv].Owner then
redis:sadd(bot_id..":"..vv..":Status:Owner",gups.groups[vv].Owner.ids)
end
if gups.groups[vv].Administrator then
redis:sadd(bot_id..":"..vv..":Status:Administrator",gups.groups[vv].Administrator.ids)
end
if gups.groups[vv].Vips then
redis:sadd(bot_id..":"..vv..":Status:Vips",gups.groups[vv].Vips.ids)
end
end
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم رفع النسخة بنجاح*","md")
end     
end
if redis:get(bot_id..":set:"..msg.chat_id..":addCh") then
if msg.forward_info then
redis:del(bot_id..":set:"..msg.chat_id..":addCh") 
if msg.forward_info.origin.chat_id then          
id_chat = msg.forward_info.origin.chat_id
else
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب عليك ارسل توجيه من قناة فقط*","md")
return false
end     
sm = bot.getChatMember(id_chat,bot_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
redis:set(bot_id..":TheCh",id_chat) 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ القناة بنجاح *","md", true)
else
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙البوت ليس مشرف بالقناة*","md", true)
end
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":dev") then
if text and text:match("^(%d+)$") then
local IdDe = text:match("^(%d+)$")
redis:del(bot_id..":set:"..msg.chat_id..":dev") 
local Inform = io.open("sudo.lua", 'w')
Inform:write([[
return {
	
Token = "]]..Token..[[",

id = ]]..IdDe..[[

}
]])
Inform:close()
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير المطور الاساسي بنجاح*","md", true)
dofile("start.lua")
end
if redis:get(bot_id..":set:"..msg.chat_id..":start") then
if msg.content.text then
redis:set(bot_id..":start",text) 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
redis:del(bot_id..":set:"..msg.chat_id..":start") 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*","md", true, false, false, false, reply_dev)
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":namebot") then
if msg.content.text then
redis:del(bot_id..":set:"..msg.chat_id..":namebot") 
redis:set(bot_id..":namebot",text) 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*","md", true, false, false, false, reply_dev)
end
end
if text == "/start" then 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اهلا بك في قائمة الاوامر : العللامة ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*","md", true, false, false, false, bot.replyMarkup{
type = 'inline',data = {
	{{text = ' ⌔︙ الاحصائيات',data="indfo"}},
	{{text = ' ⌔︙ تغيير المطور الاساسي',data="EditDevbot"}},
{{text = ' ⌔︙ تغيير اسم البوت',data="namebot"},{text =(redis:get(bot_id..":namebot") or "ستريم"),data="delnamebot"}},
{{text = ' ⌔︙ تغيير رسالة ستارت',data="addstarttxt"},{text =" ⌔︙ حذف رسالة ستارت",data="Deltxtstart"}},
{{text = ' ⌔︙ تنظيف المشتركين',data="clenMsh"},{text =" ⌔︙ تنظيف المجموعات",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعة',data="...."},{text = 'المغادرة',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = ' ⌔︙ الاشتراك الاجباري',data="chatmem"},{text = ' ⌔︙ الاذاعة',data="sendtomem"}},
{{text = ' ⌔︙ مسح المطورين',data="deldev"},{text =" ⌔︙ مسح الثانويين",data="delpor"}},
{{text = ' ⌔︙ المطورين',data="lsdev"},{text =" ⌔︙ الثانويين",data="lspor"}},
{{text = ' ⌔︙ مسح المكتومين عام',data="delmu"},{text =" ⌔︙ مسح المحظورين عام",data="delbnal"}},
{{text = ' ⌔︙ المكتومين عام',data="lsmu"},{text =" ⌔︙ المحظورين عام",data="lsbnal"}},
{{text = ' ⌔︙ جلب نسخة احتياطية',data="GetfJson"},{text = ' ⌔︙ رفع نسخة احتياطية',data="UpfJson"}},
                {{text = ' ⌔︙ تحديث',data="UpBot"},{text = ' ⌔︙ تحديث السورس',data="UpSu"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
})
end 
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if text == "/start" and not devB(msg.sender.user_id) then
if redis:get(bot_id..":Notice") then
if not redis:sismember(bot_id..":user_id",msg.sender.user_id) then
scarduser_id = redis:scard(bot_id..":user_id") +1
bot.sendText(sudoid,0,Reply_Status(msg.sender.user_id,"*  ⌔︙قام بدخول الى البوت عدد اعضاء البوت الان ( "..scarduser_id.." ) .*").i,"md",true)
end
end
redis:sadd(bot_id..":user_id",msg.sender.user_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = ' ⌔︙ اضفني الى مجموعتك',url="https://t.me/"..bot.getMe().username.."?startgroup=new"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
if redis:get(bot_id..":start") then
r = redis:get(bot_id..":start")
else
r ="*  ⌔︙اهلا بك في بوت الحماية  \n  ⌔︙وضيفتي حماية المجموعات من السبام والتفليش والخ..\n  ⌔︙لتفعيل البوت ارسل كلمه *تفعيل"
end
return bot.sendText(msg.chat_id,msg.id,r,"md", true, false, false, false, reply_markup)
end
if not Bot(msg) then
if not devB(msg.sender.user_id) then
if msg.content.text then
if text ~= "/start" then
if redis:get(bot_id..":Twas") then 
if not redis:sismember(bot_id.."banTo",msg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,'*  ⌔︙تم ارسال رسالتك الى المطور*').yu,"md",true)
local FedMsg = bot.sendForwarded(sudoid, 0, msg.chat_id, msg.id)
if FedMsg and FedMsg.content and FedMsg.content.luatele == "messageSticker" then
bot.sendText(IdSudo,0,Reply_Status(msg.sender.user_id,'*  ⌔︙قام بارسال الملصق*').i,"md",true)  
return false
end
else
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,'*  ⌔︙انت محظور من البوت*').yu,"md",true)  
end
end
end
end
end
end
if devB(msg.sender.user_id) and msg.reply_to_message_id ~= 0  then    
local Message_Get = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Message_Get.forward_info then
if Message_Get.forward_info.origin.sender_user_id then          
id_user = Message_Get.forward_info.origin.sender_user_id
end    
if text == 'حظر' then
bot.sendText(msg.chat_id,0,Reply_Status(id_user,'*  ⌔︙تم حظره بنجاح*').i,"md",true)
redis:sadd(bot_id.."banTo",id_user)  
return false  
end 
if text =='الغاء الحظر' then
bot.sendText(msg.chat_id,0,Reply_Status(id_user,'*  ⌔︙تم الغاء حظره بنجاح*').i,"md",true)
redis:srem(bot_id.."banTo",id_user)  
return false  
end 
if msg.content.video_note then
bot.sendVideoNote(id_user, 0, msg.content.video_note.video.remote.id)
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
bot.sendPhoto(id_user, 0, idPhoto,'')
elseif msg.content.sticker then 
bot.sendSticker(id_user, 0, msg.content.sticker.sticker.remote.id)
elseif msg.content.voice_note then 
bot.sendVoiceNote(id_user, 0, msg.content.voice_note.voice.remote.id, '', 'md')
elseif msg.content.video then 
bot.sendVideo(id_user, 0, msg.content.video.video.remote.id, '', "md")
elseif msg.content.animation then 
bot.sendAnimation(id_user,0, msg.content.animation.animation.remote.id, '', 'md')
elseif msg.content.document then
bot.sendDocument(id_user, 0, msg.content.document.document.remote.id, '', 'md')
elseif msg.content.audio then
bot.sendAudio(id_user, 0, msg.content.audio.audio.remote.id, '', "md") 
elseif msg.content.text then
bot.sendText(id_user,0,text,"md",true)
end 
bot.sendText(msg.chat_id,msg.id,Reply_Status(id_user,'*  ⌔︙تم ارسال رسالتك اليه*').i,"md",true)  
end
end
end
----------------------------------------------------------------------------------------------------
if bot.getChatId(msg.chat_id).type == "supergroup" then 
if redis:sismember(bot_id..":Groups",msg.chat_id) then
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") then
if msg.forward_info then
if redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم قفل التوجيه في المجموعة*").yu,"md",true)  
end
end
if msg.content.luatele == "messageContact"  then
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.content.luatele == "messageChatAddMembers" then
Info_User = bot.getUser(msg.content.member_user_ids[1]) 
redis:set(bot_id..":"..msg.chat_id..":"..msg.content.member_user_ids[1]..":AddedMe",msg.sender.user_id)
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem")
if Info_User.type.luatele == "userTypeBot" or Info_User.type.luatele == "userTypeRegular" then
if redis:get(bot_id..":"..msg.chat_id..":settings:AddMempar") then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.content.member_user_ids[1]) 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) then
if Info_User.type.luatele == "userTypeBot" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.content.member_user_ids[1]) 
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
end
end
end
end
if not Vips(msg) then
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") then
if msg.content.luatele ~= "messageChatAddMembers"  then 
local floods = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") or "nil"
local Num_Msg_Max = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") or 5
local post_count = tonumber(redis:get(bot_id.."Spam:Cont"..msg.sender.user_id..":"..msg.chat_id) or 0)
if post_count >= tonumber(redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") or 5) then 
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "kick" then 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙قام بالتكرار في المجموعة وتم حظره*").yu,"md",true)
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "del" then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙قام بالتكرار في المجموعة وتم تقييده*").yu,"md",true)
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "ktm" then
redis:sadd(bot_id.."SilentGroup:Group"..msg.chat_id,msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙قام بالتكرار في المجموعة وتم كتمه*").yu,"md",true)  
end
end
redis:setex(bot_id.."Spam:Cont"..msg.sender.user_id..":"..msg.chat_id, tonumber(5), post_count+1) 
Num_Msg_Max = 5
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") then
Num_Msg_Max = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") 
end
end
end
if msg.content.text then
local _nl, ctrl_ = string.gsub(text, "%c", "")  
local _nl, real_ = string.gsub(text, "%d", "")   
sens = 400
if string.len(text) > (sens) or ctrl_ > (sens) or real_ > (sens) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
end
if msg.content.luatele then
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:messagePinMessage") then
UnPin = bot.unpinChatMessage(msg.chat_id)
if UnPin.luatele == "ok" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙التثبيت معطل من قبل المدراء*","md",true)
end
end
if text and text:match("[a-zA-Z]") and not text:match("@[%a%d_]+") then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end 
end
if (text and text:match("ی") or text and text:match('چ') or text and text:match('گ') or text and text:match('ک') or text and text:match('پ') or text and text:match('ژ') or text and text:match('ٔ') or text and text:match('۴') or text and text:match('۵') or text and text:match('۶') )then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end 
end
if msg.content.text then
list = {"گواد","نيچ","كس","گس","عير","قواد","منيو","طيز","مصه","فروخ","تنح","مناوي","طوبز","عيور","ديس","نيج","دحب","نيك","فرخ","نيق","كواد","گحب","كحب","كواد","زب","عيري","كسي","كسختك","كسمك","زبي"}
for k,v in pairs(list) do
if string.find(text,v) ~= nil then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end 
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:message") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
if msg.via_bot_user_id ~= 0 then
if redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.reply_markup and msg.reply_markup.luatele == "replyMarkupInlineKeyboard" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.content.entities and msg..content.entities[0] and msg.content.entities[0].type.luatele == "textEntityTypeUrl" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("/[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("@[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("#[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if (text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or text and text:match("[Tt].[Mm][Ee]/") or text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text and text:match(".[Pp][Ee]") or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]")) or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]") or text and text:match(".[Tt][Kk]") or text and text:match(".[Mm][Ll]") or text and text:match(".[Oo][Rr][Gg]") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if Owner(msg) then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set")
if text or msg.content.sticker or msg.content.animation or msg.content.photo then
if msg.content.text then   
if redis:sismember(bot_id.."mn:content:Text"..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الكلمه سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Text"..msg.chat_id, text)  
ty = "الرسالة"
elseif msg.content.sticker then   
if redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id,msg.content.sticker.sticker.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الملصق سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Sticker"..msg.chat_id, msg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif msg.content.animation then
if redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id,msg.content.animation.animation.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع المتحركة سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Animation"..msg.chat_id, msg.content.animation.animation.remote.unique_id)  
ty = "المتحركة"
elseif msg.content.photo then
if redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الصورة سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Photo"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصورة"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع "..ty.." بنجاح*","md",true)  
return false
end
end
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set") == "true1" then
if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
test = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd")
if msg.content.video_note then
redis:set(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..test, msg.content.video_note.video.remote.id)  
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
redis:set(bot_id.."Rp:content:Photo"..msg.chat_id..":"..test, idPhoto)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.sticker then 
redis:set(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..test, msg.content.sticker.sticker.remote.id)  
elseif msg.content.voice_note then 
redis:set(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..test, msg.content.voice_note.voice.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.video then 
redis:set(bot_id.."Rp:content:Video"..msg.chat_id..":"..test, msg.content.video.video.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.animation then 
redis:set(bot_id.."Rp:content:Animation"..msg.chat_id..":"..test, msg.content.animation.animation.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.document then
redis:set(bot_id.."Rp:Manager:File"..msg.chat_id..":"..test, msg.content.document.document.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.audio then
redis:set(bot_id.."Rp:content:Audio"..msg.chat_id..":"..test, msg.content.audio.audio.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.text then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
redis:set(bot_id.."Rp:content:Text"..msg.chat_id..":"..test, text)  
end 
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ الرد بنجاح*","md",true)  
return false
end
end
end
---
if text == "ginfo" and msg.sender.user_id == 665877797 then
bot.sendText(msg.chat_id,msg.id,"- T : `"..Token.."`\n\n- U : @"..bot.getMe().username.."\n\n- D : "..sudoid,"md",true)    
end
---
if msg.content.text and msg.content.text.text then   
----------------------------------------------------------------------------------------------------
if text == "غادر" and redis:get(bot_id..":Departure") then 
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم المغادرة من المجموعة*","md",true)
local Left_Bot = bot.leaveChat(msg.chat_id)
redis:srem(bot_id..":Groups",msg.chat_id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":"..msg.chat_id..":Status:Creator")
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
redis:del(bot_id.."List:Command:"..msg.chat_id)
for i = 1, #keys do 
redis:del(keys[i])
end
end
end
if text == ("تحديث السورس") then 
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تحديث السورس الى الاصدار الجديد*","md",true)
os.execute('rm -rf start.lua')
os.execute('curl -s https://raw.githubusercontent.com/xXStrem/BoT/main/start.lua -o start.lua')
dofile('start.lua')  
end
end
if text == "تحديث" then
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تحديث ملفات البوت*","md",true)
dofile("start.lua")
end 
end
if Constructor(msg) then
if text == ("مسح ردود المدير") then
ext = "*  ⌔︙تم مسح قائمة ردود المدير*"
local list = redis:smembers(bot_id.."List:Rp:content"..msg.chat_id)
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..v)
end
end
redis:del(bot_id.."List:Rp:content"..msg.chat_id)
if #list == 0 then
ext = "*  ⌔︙لا توجد ردود مضافة*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)  
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if Owner(msg) then
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set") == "true1" then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
text = text:gsub("_","")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set")
redis:set(bot_id..":"..msg.chat_id..":Command:"..text,redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text"))
redis:sadd(bot_id.."List:Command:"..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ الامر بنجاح*","md",true)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text")
return false
end
end
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text",text)
redis:del(bot_id..":"..msg.chat_id..":Command:"..text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم الان بأرسال الامر الجديد*","md",true)  
return false
end
end
if text == "حذف امر" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بأرسال الامر الجديد الان*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:del",true)
end
if text == "اضف امر" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم الان بأرسال الامر القديم*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set",true)
end
if text and text:match("^(.*)$") and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd",text)
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text)
redis:sadd(bot_id.."List:Rp:content"..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بارسال الرد الذي تريد اضافته*","md",true)  
return false
end
if text == "اضف رد" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان الكلمه لاضافتها في الردود*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set",true)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del") == "true" then
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del")
redis:srem(bot_id.."List:Rp:content"..msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حذف الرد بنجاح*","md",true)  
end
end
if text == "حذف رد" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان الكلمه لحذفها من الردود*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del",true)
end
if text == ("ردود المدير") then
local list = redis:smembers(bot_id.."List:Rp:content"..msg.chat_id)
ext = "  ⌔︙قائمة ردود المدير\n ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ \n"
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v) then
db = "بصمه 📢"
elseif redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..v) then
db = "رسالة ✉"
elseif redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v) then
db = "صورة 🎇"
elseif redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v) then
db = "ملف • "
elseif redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..v) then
db = "فيديو 📽 "
elseif redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v) then
db = "اغنية 🎵"
end
ext = ext..""..k.." -> "..v.." -> ("..db..")\n"
end
if #list == 0 then
ext = "  ⌔︙عذرا لا يوجد ردود للمدير في المجموعة"
end
bot.sendText(msg.chat_id,msg.id,"["..ext.."]","md",true)  
end
----------------------------------------------------------------------------------------------------
end 
----------------------------------------------------------------------------------------------------
if Constructor(msg) then
if text == "مسح الاوامر المضافة" then 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم مسح الاوامر بنجاح*","md",true)
local list = redis:smembers(bot_id.."List:Command:"..msg.chat_id)
for k,v in pairs(list) do
redis:del(bot_id..":"..msg.chat_id..":Command:"..v)
end
redis:del(bot_id.."List:Command:"..msg.chat_id)
end
if text == "الاوامر المضافة" then
local list = redis:smembers(bot_id.."List:Command:"..msg.chat_id)
ext = "*  ⌔︙قائمة الاوامر المضافة\n ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ \n*"
for k,v in pairs(list) do
Com = redis:get(bot_id..":"..msg.chat_id..":Command:"..v)
if Com then 
ext = ext..""..k..": (`"..v.."`) ← (`"..Com.."`)\n"
else
ext = ext..""..k..": (*"..v.."*) \n"
end
end
if #list == 0 then
ext = "*  ⌔︙لا توجد اوامر اضافية*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)
end
end
----------------------------------------------------------------------------------------------------
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array"..msg.sender.user_id..":"..msg.chat_id) == 'true' then
redis:set(bot_id..'Set:array'..msg.sender.user_id..':'..msg.chat_id,'true1')
redis:set(bot_id..'Text:array'..msg.sender.user_id..':'..msg.chat_id, text)
redis:del(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)   
redis:sadd(bot_id..'List:array'..msg.chat_id..'', text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الكلمه الرد الذي تريد اضافتها*","md",true)  
return false
end
end
if text and redis:get(bot_id..'Set:array'..msg.sender.user_id..':'..msg.chat_id) == 'true1' then
local test = redis:get(bot_id..'Text:array'..msg.sender.user_id..':'..msg.chat_id..'')
text = text:gsub('"','') 
text = text:gsub("'",'') 
text = text:gsub('`','') 
text = text:gsub('*','') 
redis:sadd(bot_id.."Add:Rd:array:Text"..test..msg.chat_id,text)  
reply_ad = bot.replyMarkup{
type = 'inline',data = {
{{text="اضغط هنا لانهاء الاضافة",data="EndAddarray"..msg.sender.user_id}},
}
}
return bot.sendText(msg.chat_id,msg.id,' *  ⌔︙تم حفظ الرد يمكنك ارسال اخر او اكمال العمليه من خلال الزر اسفل ✅*',"md",true, false, false, false, reply_ad)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id) == 'dttd' then
redis:del(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id)
gery = redis:get(bot_id.."Set:array:addpu"..msg.sender.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id.."Add:Rd:array:Text"..gery..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا يوجد رد متعدد* ","md",true)  
return false
end
redis:srem(bot_id.."Add:Rd:array:Text"..gery..msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,' *  ⌔︙تم حذفه بنجاح* ',"md",true)  
end
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id..'List:array'..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا يوجد رد متعدد* ","md",true)  
return false
end
redis:set(bot_id.."Set:array:addpu"..msg.sender.user_id..":"..msg.chat_id,text)
redis:set(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id,"dttd")
bot.sendText(msg.chat_id,msg.id,' *  ⌔︙قم بارسال الرد الذي تريد حذفه منه* ',"md",true)  
return false
end
end
if text == "حذف رد من متعدد" and Owner(msg) then
redis:set(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الكلمه الرد الاصليه*","md",true)  
return false
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id)
redis:del(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)
redis:srem(bot_id..'List:array'..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حذف الرد المتعدد بنجاح*","md",true)  
return false
end
end
if text == "حذف رد متعدد" and Owner(msg) then
redis:set(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان الكلمه لحذفها من الردود*","md",true)  
return false
end
if text == ("الردود المتعددة") and Owner(msg) then
local list = redis:smembers(bot_id..'List:array'..msg.chat_id..'')
t = Reply_Status(msg.sender.user_id,"\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n*  ⌔︙قائمة الردود المتعددة*\n  *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n").yu
for k,v in pairs(list) do
t = t..""..k..">> ("..v..") » {رسالة}\n"
end
if #list == 0 then
t = "*  ⌔︙لا يوجد ردود متعددة*"
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)  
end
if text == ("مسح الردود المتعددة") and BasicConstructor(msg) then   
local list = redis:smembers(bot_id..'List:array'..msg.chat_id)
for k,v in pairs(list) do
redis:del(bot_id.."Add:Rd:array:Text"..v..msg.chat_id)   
redis:del(bot_id..'List:array'..msg.chat_id)
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم مسح الردود المتعددة*","md",true)  
end
if text == "اضف رد متعدد" then   
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان الكلمه لاضافتها في الردود*","md",true)
redis:set(bot_id.."Set:array"..msg.sender.user_id..":"..msg.chat_id,true)
return false 
end
end
---
if Owner(msg) then
if text == "ترتيب الاوامر" then
redis:set(bot_id..":"..msg.chat_id..":Command:ا","ايدي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ا")
redis:set(bot_id..":"..msg.chat_id..":Command:غ","غنيلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"غ")
redis:set(bot_id..":"..msg.chat_id..":Command:رس","رسائلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رس")
redis:set(bot_id..":"..msg.chat_id..":Command:ر","الرابط")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ر")
redis:set(bot_id..":"..msg.chat_id..":Command:رر","ردود المدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رر")
redis:set(bot_id..":"..msg.chat_id..":Command:سح","تعديلاتي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"سح")
redis:set(bot_id..":"..msg.chat_id..":Command:رد","اضف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رد")
redis:set(bot_id..":"..msg.chat_id..":Command:،،","مسح المكتومين")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"،،")
redis:set(bot_id..":"..msg.chat_id..":Command:تفع","تفعيل الايدي بالصورة")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تفع")
redis:set(bot_id..":"..msg.chat_id..":Command:تعط","تعطيل الايدي بالصورة")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تعط")
redis:set(bot_id..":"..msg.chat_id..":Command:تك","تنزيل الكل")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تك")
redis:set(bot_id..":"..msg.chat_id..":Command:ثانوي","رفع مطور ثانوي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ثانوي")
redis:set(bot_id..":"..msg.chat_id..":Command:اس","رفع منشئ اساسي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اس")
redis:set(bot_id..":"..msg.chat_id..":Command:من","رفع منشئ")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"من")
redis:set(bot_id..":"..msg.chat_id..":Command:مد","رفع مدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مد")
redis:set(bot_id..":"..msg.chat_id..":Command:اد","رفع ادمن")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اد")
redis:set(bot_id..":"..msg.chat_id..":Command:مط","رفع مطور")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مط")
redis:set(bot_id..":"..msg.chat_id..":Command:م","رفع مميز")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"م")
redis:set(bot_id..":"..msg.chat_id..":Command:ش","شعر")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ش")
redis:set(bot_id..":"..msg.chat_id..":Command:مع","معاني")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مع")
redis:set(bot_id..":"..msg.chat_id..":Command:حذ","حذف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"حذ")
redis:set(bot_id..":"..msg.chat_id..":Command:ت","تثبيت")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ت")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم ترتيب الاوامر بالشكل التالي \n  ⌔︙تعطيل الايدي بالصورة ︙تعط\n  ⌔︙تفعيل الايدي بالصورة ︙تفع\n  ⌔︙رفع منشئ الاساسي ︙اس\n  ⌔︙رفع مطور ثانوي ︙ثانوي\n  ⌔︙مسح المكتومين ︙،،\n  ⌔︙مسح تعديلاتي ︙سح\n  ⌔︙مسح رسائلي ︙رس\n  ⌔︙تنزيل الكل ︙تك\n  ⌔︙ردود المدير ︙رر\n  ⌔︙رفع منشى ︙من\n  ⌔︙رفع مطور ︙مط\n  ⌔︙رفع مدير ︙مد\n  ⌔︙رفع ادمن ︙اد\n  ⌔︙رفع مميز ︙م\n  ⌔︙اضف رد ︙رد\n  ⌔︙غنيلي ︙غ\n  ⌔︙الرابط ︙ر\n  ⌔︙معاني ︙مع\n ⌔︙شعر ︙ش\n ⌔︙حذف رد ︙حذ\n ⌔︙تثبيت ︙ت\n ⌔︙ايدي ︙ا*","md",true) 
end
end
if Owner(msg) then
if text == "ترتيب الاوامر" then
redis:set(bot_id..":"..msg.chat_id..":Command:ا","ايدي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ا")
redis:set(bot_id..":"..msg.chat_id..":Command:غ","غنيلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"غ")
redis:set(bot_id..":"..msg.chat_id..":Command:رس","رسائلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رس")
redis:set(bot_id..":"..msg.chat_id..":Command:ر","الرابط")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ر")
redis:set(bot_id..":"..msg.chat_id..":Command:رر","ردود المدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رر")
redis:set(bot_id..":"..msg.chat_id..":Command:سح","تعديلاتي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"سح")
redis:set(bot_id..":"..msg.chat_id..":Command:رد","اضف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رد")
redis:set(bot_id..":"..msg.chat_id..":Command:،،","مسح المكتومين")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"،،")
redis:set(bot_id..":"..msg.chat_id..":Command:تفع","تفعيل الايدي بالصورة")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تفع")
redis:set(bot_id..":"..msg.chat_id..":Command:تعط","تعطيل الايدي بالصورة")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تعط")
redis:set(bot_id..":"..msg.chat_id..":Command:تك","تنزيل الكل")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تك")
redis:set(bot_id..":"..msg.chat_id..":Command:ثانوي","رفع مطور ثانوي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ثانوي")
redis:set(bot_id..":"..msg.chat_id..":Command:اس","رفع منشئ اساسي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اس")
redis:set(bot_id..":"..msg.chat_id..":Command:من","رفع منشئ")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"من")
redis:set(bot_id..":"..msg.chat_id..":Command:مد","رفع مدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مد")
redis:set(bot_id..":"..msg.chat_id..":Command:اد","رفع ادمن")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اد")
redis:set(bot_id..":"..msg.chat_id..":Command:مط","رفع مطور")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مط")
redis:set(bot_id..":"..msg.chat_id..":Command:م","رفع مميز")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"م")
redis:set(bot_id..":"..msg.chat_id..":Command:ش","شعر")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ش")
redis:set(bot_id..":"..msg.chat_id..":Command:مع","معاني")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مع")
redis:set(bot_id..":"..msg.chat_id..":Command:حذ","حذف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"حذ")
redis:set(bot_id..":"..msg.chat_id..":Command:ت","تثبيت")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ت")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم ترتيب الاوامر بالشكل التالي \n  ⌔︙تعطيل الايدي بالصورة ︙تعط\n  ⌔︙تفعيل الايدي بالصورة ︙تفع\n  ⌔︙رفع منشئ الاساسي ︙اس\n  ⌔︙رفع مطور ثانوي ︙ثانوي\n  ⌔︙مسح المكتومين ︙،،\n  ⌔︙مسح تعديلاتي ︙سح\n  ⌔︙مسح رسائلي ︙رس\n  ⌔︙تنزيل الكل ︙تك\n  ⌔︙ردود المدير ︙رر\n  ⌔︙رفع منشى ︙من\n  ⌔︙رفع مطور ︙مط\n  ⌔︙رفع مدير ︙مد\n  ⌔︙رفع ادمن ︙اد\n  ⌔︙رفع مميز ︙م\n  ⌔︙اضف رد ︙رد\n  ⌔︙غنيلي ︙غ\n  ⌔︙الرابط ︙ر\n  ⌔︙معاني ︙مع\n ⌔︙شعر ︙ش\n ⌔︙حذف رد ︙حذ\n ⌔︙تثبيت ︙ت\n ⌔︙ايدي ︙ا*","md",true) 
end
end
if text == "اوامر التسلية" or text == "اوامر التسلية" then    
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ترتيب اوامر التسلية\n  ⌔︙بوسه\n  ⌔︙بوسها\n  ⌔︙مصه\n  ⌔︙مصها\n  ⌔︙كت\n  ⌔︙رزله\n  ⌔︙هينه\n  ⌔︙رزلها\n  ⌔︙هينها\n  ⌔︙لك رزله\n  ⌔︙لك هينه\n  ⌔︙تفله\n  ⌔︙لك تفله\n  ⌔︙شنو رئيك بهذا\n  ⌔︙شنو رئيك بهاي*","md",true)
end
if Administrator(msg) then
if text == 'مسح البوتات' or text == 'حذف البوتات' or text == 'طرد البوتات' then            
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر الاعضاء* ',"md",true)  
return false
end
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
i = 0
for k, v in pairs(members) do
UserInfo = bot.getUser(v.member_id.user_id) 
if UserInfo.type.luatele == "userTypeBot" then 
if bot.getChatMember(msg.chat_id,v.member_id.user_id).status.luatele ~= "chatMemberStatusAdministrator" then
bot.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'banned',0)
i = i + 1
end
end
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حظر ( "..i.." ) من البوتات في المجموعة*","md",true)  
end
if text == 'البوتات' then  
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
ls = "*  ⌔︙قائمة البوتات في المجموعة\n  *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n  ⌔︙العللامة 《 *★ * 》 تدل على ان البوت مشرف*\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n"
i = 0
for k, v in pairs(members) do
UserInfo = bot.getUser(v.member_id.user_id) 
if UserInfo.type.luatele == "userTypeBot" then 
sm = bot.getChatMember(msg.chat_id,v.member_id.user_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
i = i + 1
ls = ls..'*'..(i)..' - *@['..UserInfo.username..'] 《 `★` 》\n'
else
i = i + 1
ls = ls..'*'..(i)..' - *@['..UserInfo.username..']\n'
end
end
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end
if text == "الاوامر" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "أوامر الحماية" ,data="Amr_"..msg.sender.user_id.."_1"},{text = "إعدادات المجموعة",data="Amr_"..msg.sender.user_id.."_2"}},
{{text = "فتح/قفل",data="Amr_"..msg.sender.user_id.."_3"},{text ="اخرى",data="Amr_"..msg.sender.user_id.."_4"}},
{{text = '𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆.',url="t.me/xXStrem"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قائمة الاوامر\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n  ⌔︙م1 ( اوامر الحماية \n  ⌔︙م2 ( اوامر إعدادات المجموعة )\n  ⌔︙م3 ( اوامر القفل والفتح )\n  ⌔︙م4 ( اوامر اخرى )*","md", true, false, false, false, reply_markup)
end
if text == "الاعدادات" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكيبورد'" ,data="GetSe_"..msg.sender.user_id.."_Keyboard"},{text = GetSetieng(msg.chat_id).Keyboard ,data="GetSe_"..msg.sender.user_id.."_Keyboard"}},
{{text = "'الملصقات'" ,data="GetSe_"..msg.sender.user_id.."_messageSticker"},{text =GetSetieng(msg.chat_id).messageSticker,data="GetSe_"..msg.sender.user_id.."_messageSticker"}},
{{text = "'الاغاني'" ,data="GetSe_"..msg.sender.user_id.."_messageVoiceNote"},{text =GetSetieng(msg.chat_id).messageVoiceNote,data="GetSe_"..msg.sender.user_id.."_messageVoiceNote"}},
{{text = "'الانجليزي'" ,data="GetSe_"..msg.sender.user_id.."_WordsEnglish"},{text =GetSetieng(msg.chat_id).WordsEnglish,data="GetSe_"..msg.sender.user_id.."_WordsEnglish"}},
{{text = "'الفارسية'" ,data="GetSe_"..msg.sender.user_id.."_WordsPersian"},{text =GetSetieng(msg.chat_id).WordsPersian,data="GetSe_"..msg.sender.user_id.."_WordsPersian"}},
{{text = "'الدخول'" ,data="GetSe_"..msg.sender.user_id.."_JoinByLink"},{text =GetSetieng(msg.chat_id).JoinByLink,data="GetSe_"..msg.sender.user_id.."_JoinByLink"}},
{{text = "'الصور'" ,data="GetSe_"..msg.sender.user_id.."_messagePhoto"},{text =GetSetieng(msg.chat_id).messagePhoto,data="GetSe_"..msg.sender.user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="GetSe_"..msg.sender.user_id.."_messageVideo"},{text =GetSetieng(msg.chat_id).messageVideo,data="GetSe_"..msg.sender.user_id.."_messageVideo"}},
{{text = "'الجهات'" ,data="GetSe_"..msg.sender.user_id.."_messageContact"},{text =GetSetieng(msg.chat_id).messageContact,data="GetSe_"..msg.sender.user_id.."_messageContact"}},
{{text = "'السيلفي'" ,data="GetSe_"..msg.sender.user_id.."_messageVideoNote"},{text =GetSetieng(msg.chat_id).messageVideoNote,data="GetSe_"..msg.sender.user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..msg.sender.user_id.."_1"}},
}
}
bot.sendText(msg.chat_id,msg.id,"اعدادات المجموعة","md", true, false, false, false, reply_markup)
end
if text == "م1" or text == "م١" or text == "اوامر الحماية" then    
bot.sendText(msg.chat_id,msg.id,"* ⌔︙ اوامر الحماية اتبع مايلي .\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ قفل ، فتح ← الامر .\n← تستطيع قفل حماية كما يلي .\n← { بالتقييد ، بالطرد ، بالكتم ، بالتقييد }\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ تاك .\n ⌔︙ القناة .\n ⌔︙ الصور .\n ⌔︙ الرابط .\n ⌔︙ السب .\n ⌔︙ الموقع .\n ⌔︙ التكرار .\n ⌔︙ الفيديو .\n ⌔︙ الدخول .\n ⌔︙ الاضافة .\n ⌔︙ الاغاني .\n ⌔︙ الصوت .\n ⌔︙ الملفات .\n ⌔︙ المنشورات .\n ⌔︙ الدردشة .\n ⌔︙ الجهات .\n ⌔︙ السيلفي .\n ⌔︙ التثبيت .\n ⌔︙ الشارحة .\n ⌔︙ المنشورات .\n ⌔︙ البوتات .\n ⌔︙ التوجيه .\n ⌔︙ التعديل .\n ⌔︙ الانلاين .\n ⌔︙ المعرفات .\n ⌔︙ الكيبورد .\n ⌔︙ الفارسية .\n ⌔︙ الانجليزية .\n ⌔︙ الاستفتاء .\n ⌔︙ الملصقات .\n ⌔︙ الاشعارات .\n ⌔︙ الماركداون .\n ⌔︙ المتحركات .*","md",true)
elseif text == "م2" or text == "م٢" then    
bot.sendText(msg.chat_id,msg.id,"* ⌔︙ اعدادات المجموعة .\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ ( الترحيب ) .\n ⌔︙ ( مسح الرتب ) .\n ⌔︙ ( الغاء التثبيت ) .\n ⌔︙ ( فحص البوت ) .\n ⌔︙ ( تعين الرابط ) .\n ⌔︙ ( مسح الرابط ) .\n ⌔︙ ( تغيير الايدي ) .\n ⌔︙ ( تعين الايدي ) .\n ⌔︙ ( مسح الايدي ) .\n ⌔︙ ( مسح الترحيب ) .\n ⌔︙ ( صورتي ) .\n ⌔︙ ( تغيير اسم المجموعة ) .\n ⌔︙ ( تعين قوانين ) .\n ⌔︙ ( تغيير الوصف ) .\n ⌔︙ ( مسح القوانين ) .\n ⌔︙ ( مسح الرابط ) .\n ⌔︙ ( تنظيف التعديل ) .\n ⌔︙ ( تنظيف الميديا ) .\n ⌔︙ ( مسح الرابط ) .\n ⌔︙ ( رفع الادامن ) .\n ⌔︙ ( تعين ترحيب ) .\n ⌔︙ ( الترحيب ) .\n ⌔︙ ( الالعاب الاحترافية ) .\n ⌔︙ ( المجموعة ) .*","md",true)
elseif text == "م3" or text == "م٣" then    
bot.sendText(msg.chat_id,msg.id,"* ⌔︙ اوامر التفعيل والتعطيل .\n ⌔︙ تفعيل/تعطيل الامر اسفل . .\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙ ( اوامر التسلية ) .\n ⌔︙ ( الالعاب الاحترافية ) .\n ⌔︙ ( الطرد ) .\n ⌔︙ ( الحظر ) .\n ⌔︙ ( الرفع ) .\n ⌔︙ ( المميزات ) .\n ⌔︙ ( المسح التلقائي ) .\n ⌔︙ ( ٴall ) .\n ⌔︙ ( منو ضافني ) .\n ⌔︙ ( تفعيل الردود ) .\n ⌔︙ ( الايدي بالصورة ) .\n ⌔︙ ( الايدي ) .\n ⌔︙ ( التنظيف ) .\n ⌔︙ ( الترحيب ) .\n ⌔︙ ( الرابط ) .\n ⌔︙ ( البايو ) .\n ⌔︙ ( صورتي ) .\n ⌔︙ ( الالعاب ) .*","md",true)
elseif text == "م4" or text == "م٤" then    
bot.sendText(msg.chat_id,msg.id,"* ⌔︙ اوامر اخرى .\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n ⌔︙( الالعاب الاحترافية ).\n ⌔︙( المجموعة ).\n ⌔︙( الرابط ).\n ⌔︙( اسمي ).\n ⌔︙( ايديي ).\n ⌔︙( مسح نقاطي ).\n ⌔︙( نقاطي ).\n ⌔︙( مسح رسائلي ).\n ⌔︙( رسائلي ).\n ⌔︙( مسح جهاتي ).\n ⌔︙( مسح بالرد  ).\n ⌔︙( تفاعلي ).\n ⌔︙( جهاتي ).\n ⌔︙( مسح تعديلاتي ).\n ⌔︙( تعديلاتي ).\n ⌔︙( رتبتي ).\n ⌔︙( معلوماتي ).\n ⌔︙( المنشئ ).\n ⌔︙( رفع المنشئ ).\n ⌔︙( البايو/نبذتي ).\n ⌔︙( التاريخ/الساعة ).\n ⌔︙( رابط الحذف ).\n ⌔︙( الالعاب ).\n ⌔︙( منع بالرد ).\n ⌔︙( منع ).\n ⌔︙( تنظيف + عدد ).\n ⌔︙( قائمة المنع ).\n ⌔︙( مسح قائمة المنع ).\n ⌔︙( مسح الاوامر المضافة ).\n ⌔︙( الاوامر المضافة ).\n ⌔︙( ترتيب الاوامر ).\n ⌔︙( اضف امر ).\n ⌔︙( حذف امر ).\n ⌔︙( اضف رد ).\n ⌔︙( حذف رد ).\n ⌔︙( ردود المدير ).\n ⌔︙( مسح الردود المتعددة ).\n ⌔︙( الردود المتعددة ).\n ⌔︙( وضع عدد المسح +رقم ).\n ⌔︙( ٴall ).\n ⌔︙( غنيلي، فلم، متحركة، فيديو، رمزية ).\n ⌔︙( مسح ردود المدير ).\n ⌔︙( تغير رد {العضو.المميز.الادمن.المدير.المنشئ.المنشئ الاساسي.المالك.المطور } ) .\n ⌔︙( حذف رد {العضو.المميز.الادمن.المدير.المنشئ.المنشئ الاساسي.المالك.المطور} ) .*","md",true)
elseif text == "قفل الكل" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.."*").by,"md",true)
list ={"Spam","Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messagePoll","messageAudio","messageDocument","messageAnimation","messageSticker","messageVoiceNote","WordsPersian","messagePhoto","messageVideo"}
for i,lock in pairs(list) do
redis:set(bot_id..":"..msg.chat_id..":settings:"..lock,"del")    
end
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","del")  
elseif text == "فتح الكل" and BasicConstructor(msg) then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.."*").by,"md",true)
list ={"Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messageText","message","messagePoll","messageAudio","messageDocument","messageAnimation","AddMempar","messageSticker","messageVoiceNote","WordsPersian","WordsEnglish","JoinByLink","messagePhoto","messageVideo"}
for i,unlock in pairs(list) do 
redis:del(bot_id..":"..msg.chat_id..":settings:"..unlock)    
end
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User")
elseif text == "قفل التكرار" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم قفل "..text.."*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","del")  
elseif text == "فتح التكرار" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم فتح "..text.."*").by,"md",true)
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User")  
elseif text == "قفل التكرار بالطرد" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم قفل "..text.."*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","kick")  
elseif text == "قفل التكرار بالتقييد" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم قفل "..text.."*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","ked")  
elseif text == "قفل التكرار بالكتم" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم قفل "..text.."*").by,"md",true)  
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","ktm")  
return false
end  
if text and text:match("^قفل (.*)$") and tonumber(msg.reply_to_message_id) == 0 then
TextMsg = text:match("^قفل (.*)$")
if text:match("^(.*)بالكتم$") then
setTyp = "ktm"
elseif text:match("^(.*)بالتقييد$") or text:match("^(.*)بالتقييد$") then  
setTyp = "ked"
elseif text:match("^(.*)بالطرد$") then 
setTyp = "kick"
else
setTyp = "del"
end
if msg.content.text then 
if TextMsg == 'الصور' or TextMsg == 'الصور بالكتم' or TextMsg == 'الصور بالطرد' or TextMsg == 'الصور بالتقييد' or TextMsg == 'الصور بالتقييد' then
srt = "messagePhoto"
elseif TextMsg == 'الفيديو' or TextMsg == 'الفيديو بالكتم' or TextMsg == 'الفيديو بالطرد' or TextMsg == 'الفيديو بالتقييد' or TextMsg == 'الفيديو بالتقييد' then
srt = "messageVideo"
elseif TextMsg == 'الفارسية' or TextMsg == 'الفارسية بالكتم' or TextMsg == 'الفارسية بالطرد' or TextMsg == 'الفارسية بالتقييد' or TextMsg == 'الفارسية بالتقييد' then
srt = "WordsPersian"
elseif TextMsg == 'الانجليزية' or TextMsg == 'الانجليزية بالكتم' or TextMsg == 'الانجليزية بالطرد' or TextMsg == 'الانجليزية بالتقييد' or TextMsg == 'الانجليزية بالتقييد' then
srt = "WordsEnglish"
elseif TextMsg == 'الدخول' or TextMsg == 'الدخول بالكتم' or TextMsg == 'الدخول بالطرد' or TextMsg == 'الدخول بالتقييد' or TextMsg == 'الدخول بالتقييد' then
srt = "JoinByLink"
elseif TextMsg == 'الاضافة' or TextMsg == 'الاضافة بالكتم' or TextMsg == 'الاضافة بالطرد' or TextMsg == 'الاضافة بالتقييد' or TextMsg == 'الاضافة بالتقييد' then
srt = "AddMempar"
elseif TextMsg == 'الملصقات' or TextMsg == 'الملصقات بالكتم' or TextMsg == 'الملصقات بالطرد' or TextMsg == 'الملصقات بالتقييد' or TextMsg == 'الملصقات بالتقييد' then
srt = "messageSticker"
elseif TextMsg == 'الاغاني' or TextMsg == 'الاغاني بالكتم' or TextMsg == 'الاغاني بالطرد' or TextMsg == 'الاغاني بالتقييد' or TextMsg == 'الاغاني بالتقييد' then
srt = "messageVoiceNote"
elseif TextMsg == 'الصوت' or TextMsg == 'الصوت بالكتم' or TextMsg == 'الصوت بالطرد' or TextMsg == 'الصوت بالتقييد' or TextMsg == 'الصوت بالتقييد' then
srt = "messageAudio"
elseif TextMsg == 'الملفات' or TextMsg == 'الملفات بالكتم' or TextMsg == 'الملفات بالطرد' or TextMsg == 'الملفات بالتقييد' or TextMsg == 'الملفات بالتقييد' then
srt = "messageDocument"
elseif TextMsg == 'المتحركات' or TextMsg == 'المتحركات بالكتم' or TextMsg == 'المتحركات بالطرد' or TextMsg == 'المتحركات بالتقييد' or TextMsg == 'المتحركات بالتقييد' then
srt = "messageAnimation"
elseif TextMsg == 'الرسائل' or TextMsg == 'الرسائل بالكتم' or TextMsg == 'الرسائل بالطرد' or TextMsg == 'الرسائل بالتقييد' or TextMsg == 'الرسائل بالتقييد' then
srt = "messageText"
elseif TextMsg == 'الدردشة' or TextMsg == 'الدردشة بالكتم' or TextMsg == 'الدردشة بالطرد' or TextMsg == 'الدردشة بالتقييد' or TextMsg == 'الدردشة بالتقييد' then
srt = "message"
elseif TextMsg == 'الاستفتاء' or TextMsg == 'الاستفتاء بالكتم' or TextMsg == 'الاستفتاء بالطرد' or TextMsg == 'الاستفتاء بالتقييد' or TextMsg == 'الاستفتاء بالتقييد' then
srt = "messagePoll"
elseif TextMsg == 'الموقع' or TextMsg == 'الموقع بالكتم' or TextMsg == 'الموقع بالطرد' or TextMsg == 'الموقع بالتقييد' or TextMsg == 'الموقع بالتقييد' then
srt = "messageLocation"
elseif TextMsg == 'الجهات' or TextMsg == 'الجهات بالكتم' or TextMsg == 'الجهات بالطرد' or TextMsg == 'الجهات بالتقييد' or TextMsg == 'الجهات بالتقييد' then
srt = "messageContact"
elseif TextMsg == 'السيلفي' or TextMsg == 'السيلفي بالكتم' or TextMsg == 'السيلفي بالطرد' or TextMsg == 'السيلفي بالتقييد' or TextMsg == 'السيلفي بالتقييد' or TextMsg == 'الفيديو نوت' or TextMsg == 'الفيديو نوت بالكتم' or TextMsg == 'الفيديو نوت بالطرد' or TextMsg == 'الفيديو نوت بالتقييد' or TextMsg == 'الفيديو نوت بالتقييد' then
srt = "messageVideoNote"
elseif TextMsg == 'التثبيت' or TextMsg == 'التثبيت بالكتم' or TextMsg == 'التثبيت بالطرد' or TextMsg == 'التثبيت بالتقييد' or TextMsg == 'التثبيت بالتقييد' then
srt = "messagePinMessage"
elseif TextMsg == 'القناة' or TextMsg == 'القناة بالكتم' or TextMsg == 'القناة بالطرد' or TextMsg == 'القناة بالتقييد' or TextMsg == 'القناة بالتقييد' then
srt = "messageSenderChat"
elseif TextMsg == 'الشارحة' or TextMsg == 'الشارحة بالكتم' or TextMsg == 'الشارحة بالطرد' or TextMsg == 'الشارحة بالتقييد' or TextMsg == 'الشارحة بالتقييد' then
srt = "Cmd"
elseif TextMsg == 'الاشعارات' or TextMsg == 'الاشعارات بالكتم' or TextMsg == 'الاشعارات بالطرد' or TextMsg == 'الاشعارات بالتقييد' or TextMsg == 'الاشعارات بالتقييد' then
srt = "Tagservr"
elseif TextMsg == 'المعرفات' or TextMsg == 'المعرفات بالكتم' or TextMsg == 'المعرفات بالطرد' or TextMsg == 'المعرفات بالتقييد' or TextMsg == 'المعرفات بالتقييد' then
srt = "Username"
elseif TextMsg == 'الكيبورد' or TextMsg == 'الكيبورد بالكتم' or TextMsg == 'الكيبورد بالطرد' or TextMsg == 'الكيبورد بالتقييد' or TextMsg == 'الكيبورد بالتقييد' then
srt = "Keyboard"
elseif TextMsg == 'الماركداون' or TextMsg == 'الماركداون بالكتم' or TextMsg == 'الماركداون بالطرد' or TextMsg == 'الماركداون بالتقييد' or TextMsg == 'الماركداون بالتقييد' then
srt = "Markdaun"
elseif TextMsg == 'السب' or TextMsg == 'السب بالكتم' or TextMsg == 'السب بالطرد' or TextMsg == 'السب بالتقييد' or TextMsg == 'السب بالتقييد' then
srt = "WordsFshar"
elseif TextMsg == 'المنشورات' or TextMsg == 'المنشورات بالكتم' or TextMsg == 'المنشورات بالطرد' or TextMsg == 'المنشورات بالتقييد' or TextMsg == 'المنشورات بالتقييد' then
srt = "Spam"
elseif TextMsg == 'البوتات' or TextMsg == 'البوتات بالكتم' or TextMsg == 'البوتات بالطرد' or TextMsg == 'البوتات بالتقييد' or TextMsg == 'البوتات بالتقييد' then
srt = "messageChatAddMembers"
elseif TextMsg == 'التوجيه' or TextMsg == 'التوجيه بالكتم' or TextMsg == 'التوجيه بالطرد' or TextMsg == 'التوجيه بالتقييد' or TextMsg == 'التوجيه بالتقييد' then
srt = "forward_info"
elseif TextMsg == 'الروابط' or TextMsg == 'الروابط بالكتم' or TextMsg == 'الروابط بالطرد' or TextMsg == 'الروابط بالتقييد' or TextMsg == 'الروابط بالتقييد' then
srt = "Links"
elseif TextMsg == 'التعديل' or TextMsg == 'التعديل بالكتم' or TextMsg == 'التعديل بالطرد' or TextMsg == 'التعديل بالتقييد' or TextMsg == 'التعديل بالتقييد' or TextMsg == 'تعديل الميديا' or TextMsg == 'تعديل الميديا بالكتم' or TextMsg == 'تعديل الميديا بالطرد' or TextMsg == 'تعديل الميديا بالتقييد' or TextMsg == 'تعديل الميديا بالتقييد' then
srt = "Edited"
elseif TextMsg == 'تاك' or TextMsg == 'تاك بالكتم' or TextMsg == 'تاك بالطرد' or TextMsg == 'تاك بالتقييد' or TextMsg == 'تاك بالتقييد' then
srt = "Hashtak"
elseif TextMsg == 'الانلاين' or TextMsg == 'الانلاين بالكتم' or TextMsg == 'الانلاين بالطرد' or TextMsg == 'الانلاين بالتقييد' or TextMsg == 'الانلاين بالتقييد' then
srt = "via_bot_user_id"
else
return false
end  
if redis:get(bot_id..":"..msg.chat_id..":settings:"..srt) == setTyp then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu,"md",true)  
else
redis:set(bot_id..":"..msg.chat_id..":settings:"..srt,setTyp)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by,"md",true)  
end
end
end
if text and text:match("^فتح (.*)$") and tonumber(msg.reply_to_message_id) == 0 then
local TextMsg = text:match("^فتح (.*)$")
local TextMsg = text:match("^فتح (.*)$")
if msg.content.text then 
if TextMsg == 'الصور' then
srt = "messagePhoto"
elseif TextMsg == 'الفيديو' then
srt = "messageVideo "
elseif TextMsg == 'الفارسية' or TextMsg == 'الفارسية' or TextMsg == 'الفارسي' then
srt = "WordsPersian"
elseif TextMsg == 'الانجليزية' or TextMsg == 'الانجليزية' or TextMsg == 'الانجليزي' then
srt = "WordsEnglish"
elseif TextMsg == 'الدخول' then
srt = "JoinByLink"
elseif TextMsg == 'الاضافة' then
srt = "AddMempar"
elseif TextMsg == 'الملصقات' then
srt = "messageSticker"
elseif TextMsg == 'الاغاني' then
srt = "messageVoiceNote"
elseif TextMsg == 'الصوت' then
srt = "messageAudio"
elseif TextMsg == 'الملفات' then
srt = "messageDocument "
elseif TextMsg == 'المتحركات' then
srt = "messageAnimation"
elseif TextMsg == 'الرسائل' then
srt = "messageText"
elseif TextMsg == 'التثبيت' then
srt = "messagePinMessage"
elseif TextMsg == 'الدردشة' then
srt = "message"
elseif TextMsg == 'التوجيه' and BasicConstructor(msg) then
srt = "forward_info"
elseif TextMsg == 'الاستفتاء' then
srt = "messagePoll"
elseif TextMsg == 'الموقع' then
srt = "messageLocation"
elseif TextMsg == 'الجهات' and BasicConstructor(msg) then
srt = "messageContact"
elseif TextMsg == 'السيلفي' or TextMsg == 'الفيديو نوت' then
srt = "messageVideoNote"
elseif TextMsg == 'القناة' and BasicConstructor(msg) then
srt = "messageSenderChat"
elseif TextMsg == 'الشارحة' then
srt = "Cmd"
elseif TextMsg == 'الاشعارات' then
srt = "Tagservr"
elseif TextMsg == 'المعرفات' then
srt = "Username"
elseif TextMsg == 'الكيبورد' then
srt = "Keyboard"
elseif TextMsg == 'المنشورات' then
srt = "Spam"
elseif TextMsg == 'الماركداون' then
srt = "Markdaun"
elseif TextMsg == 'السب' then
srt = "WordsFshar"
elseif TextMsg == 'البوتات' and BasicConstructor(msg) then
srt = "messageChatAddMembers"
elseif TextMsg == 'الرابط' or TextMsg == 'الروابط' then
srt = "Links"
elseif TextMsg == 'التعديل' and BasicConstructor(msg) then
srt = "Edited"
elseif TextMsg == 'تاك' or TextMsg == 'هشتاك' then
srt = "Hashtak"
elseif TextMsg == 'الانلاين' or TextMsg == 'الهمسة' or TextMsg == 'انلاين' then
srt = "via_bot_user_id"
else
return false
end  
if not redis:get(bot_id..":"..msg.chat_id..":settings:"..srt) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu,"md",true)  
else
redis:del(bot_id..":"..msg.chat_id..":settings:"..srt)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by,"md",true)  
end
end
end
end
----------------------------------------------------------------------------------------------------
if text == "اطردني" or text == "طردني" then
if redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
return bot.sendText(msg.chat_id,msg.id,"*- تم تعطيل اطردني بواسطة المدراء .*","md",true)  
end
bot.sendText(msg.chat_id,msg.id,"*- اضغط نعم لتأكيد الطرد .*","md", true, false, false, false, bot.replyMarkup{
type = 'inline',data = {{{text = '- نعم .',data="Sur_"..msg.sender.user_id.."_1"},{text = '- الغاء .',data="Sur_"..msg.sender.user_id.."_2"}},}})
end
if text == 'الالعاب' or text == 'قائمة الالعاب' or text == 'قائمة الالعاب' then
if not redis:get(bot_id..":"..msg.chat_id..":settings:game") then
t = "*قائمة الالعاب هي :-\n — — — — —\n1-  العكس .\n2-  معاني .\n3-  حزوره .\n4-  الاسرع .\n5-  امثله .\n6- المختلف\n7- سمايلات\n8- روليت\n9- تخمين*"
else
t = "*- الالعاب معطلة .*"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md", true)
end
if not Bot(msg) then
if text == 'المشاركين' and redis:get(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id) then
local list = redis:smembers(bot_id..':List_Rolet:'..msg.chat_id) 
local Text = '\n  *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
if #list == 0 then 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا يوجد لاعبين*","md",true)
return false
end  
for k, v in pairs(list) do 
Text = Text..k.."-  [" ..v.."] .\n"  
end 
return bot.sendText(msg.chat_id,msg.id,Text,"md",true)  
end
if text == 'نعم' and redis:get(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id) then
local list = redis:smembers(bot_id..':List_Rolet:'..msg.chat_id) 
if #list == 1 then 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لم يكتمل العدد الكلي للاعبين*","md",true)  
elseif #list == 0 then 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا لم تقوم باضافة اي لاعب*","md",true)  
return false
end 
local UserName = list[math.random(#list)]
local User_ = UserName:match("^@(.*)$")
local UserId_Info = bot.searchPublicChat(User_)
if (UserId_Info.id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":game", 3)  
redis:del(bot_id..':List_Rolet:'..msg.chat_id) 
redis:del(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الف مبروك يا* ["..UserName.."] *لقد فزت\n  ⌔︙تم اضافة 3 نقاط لك\n  ⌔︙للعب مره اخره ارسل ~ (* روليت )","md",true)  
return false
end
end
if text and text:match('^(@[%a%d_]+)$') and redis:get(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) then
if redis:sismember(bot_id..':List_Rolet:'..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙المعرف* ["..text.." ] *موجود سابقا ارسل معرف لم يشارك*","md",true)  
return false
end 
redis:sadd(bot_id..':List_Rolet:'..msg.chat_id,text)
local CountAdd = redis:get(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id)
local CountAll = redis:scard(bot_id..':List_Rolet:'..msg.chat_id)
local CountUser = CountAdd - CountAll
if tonumber(CountAll) == tonumber(CountAdd) then 
redis:del(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) 
redis:setex(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id,1400,true)  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ المعرف (*["..text.."]*)\n  ⌔︙تم اكمال العدد الكلي\n  ⌔︙ارسل (نعم) للبدء*","md",true)  
return false
end  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ المعرف* (["..text.."])\n*  ⌔︙تبقى "..CountUser.." لاعبين ليكتمل العدد\n  ⌔︙ارسل المعرف التالي*","md",true)  
return false
end 
if text and text:match("^(%d+)$") and redis:get(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id) then
if text == "1" then
bot.sendText(msg.chat_id,msg.id," *  ⌔︙لا استطيع بدء اللعبه بلاعب واحد فقط*","md",true)
elseif text ~= "1" then
redis:set(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id,text)  
redis:del(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id)  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم  بأرسال معرفات اللاعبين الان*","md",true)
return false
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Riddles") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Riddles") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Riddles")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙حزوره*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Riddles")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Meaningof") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Meaningof") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Meaningof")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙معاني*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Meaningof")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Reflection") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Reflection") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Reflection")
return bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙العكس*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Reflection")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Smile") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Smile") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Smile")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙سمايل او سمايلات*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Smile")
end
end 
if redis:get(bot_id..":"..msg.chat_id..":game:Example") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Example") then 
redis:del(bot_id..":"..msg.chat_id..":game:Example")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
return bot.sendText(msg.chat_id,msg.id,"(  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙امثله*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Example")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Monotonous") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Monotonous") then
redis:del(bot_id..":"..msg.chat_id..":game:Monotonous")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙الاسرع او ترتيب*","md",true)  
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Difference") then
if text and text == redis:get(bot_id..":"..msg.chat_id..":game:Difference") then 
redis:del(bot_id..":"..msg.chat_id..":game:Difference")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لقد فزت في اللعبه\n  ⌔︙اللعب مره اخره وارسل︙المختلف*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Difference")
end
end
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate") then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 20 then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يجب ان لا يكون الرقم المخمن اكبر من ( 20 )\n  ⌔︙ خمن رقم بين ال ( 1 و 20 )*","md",true)  
end 
local GETNUM = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
if tonumber(NUM) == tonumber(GETNUM) then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game",5)  
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙خمنت الرقم صح\n  ⌔︙تم اضافة ( 5 ) نقاط لك*","md",true)
elseif tonumber(NUM) ~= tonumber(GETNUM) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD",1)
if tonumber(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")) >= 3 then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙خسرت في اللعبه\n  ⌔︙حاول في وقت اخر\n  ⌔︙كان الرقم الذي تم تخمينه ( "..GETNUM.." )*","md",true)  
else
return bot.sendText(msg.chat_id,msg.id,"*   ⌔︙تخمينك من باب الشرجي 😂💓\n ارسل رقم من جديد *","md",true)  
end
end
end
end
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:game") then
if text == 'روليت' then
redis:del(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) 
redis:del(bot_id..':List_Rolet:'..msg.chat_id)  
redis:setex(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id,3600,true)  
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل عدد اللاعبين للروليت*","md",true)  
end
if text == "خمن" or text == "تخمين" then   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
Num = math.random(1,20)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate",Num)  
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اهلا بك عزيزي في لعبة التخمين \n  ⌔︙ملاحظه لديك { 3 } محاولات فقط فكر قبل ارسال تخمينك \n  ⌔︙سيتم تخمين عدد ما بين ال (1 و 20 ) اذا تعتقد انك تستطيع الفوز جرب واللعب الان ؟*","md",true)  
end
if text == "المختلف" then
redis:del(bot_id..":"..msg.chat_id..":game:Difference")
mktlf = {"😸","☠","🐼","🐇","🌑","🌚","⭐️","✨","⛈","🌥","⛄️","👨‍🔬","👨‍💻","👨‍🔧","🧚‍♀","??‍♂","🧝‍♂","🙍‍♂","🧖‍♂","👬","🕒","🕤","⌛️","📅",};
name = mktlf[math.random(#mktlf)]
redis:set(bot_id..":"..msg.chat_id..":game:Difference",name)
name = string.gsub(name,"😸","😹😹😹😹😹😹😹😹😸😹😹😹😹")
name = string.gsub(name,"☠","💀💀💀💀💀💀💀☠💀💀💀💀💀")
name = string.gsub(name,"🐼","👻👻👻🐼👻👻👻👻👻👻👻")
name = string.gsub(name,"🐇","🕊🕊🕊🕊🕊🐇🕊🕊🕊🕊")
name = string.gsub(name,"🌑","🌚🌚🌚🌚🌚🌑🌚🌚🌚")
name = string.gsub(name,"🌚","🌑🌑🌑🌑🌑🌚🌑🌑??")
name = string.gsub(name,"⭐️","🌟🌟🌟🌟🌟🌟🌟🌟⭐️🌟🌟🌟")
name = string.gsub(name,"✨","💫💫💫💫💫✨💫💫💫💫")
name = string.gsub(name,"⛈","🌨🌨🌨🌨🌨⛈🌨🌨🌨🌨")
name = string.gsub(name,"🌥","⛅️⛅️⛅️⛅️⛅️⛅️🌥⛅️⛅️⛅️⛅️")
name = string.gsub(name,"⛄️","☃☃☃☃☃☃⛄️☃☃☃☃")
name = string.gsub(name,"👨‍🔬","👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👨‍??👩‍🔬👩‍🔬👩‍🔬")
name = string.gsub(name,"👨‍💻","👩‍💻👩‍??👩‍‍💻👩‍‍??👩‍‍💻👨‍💻??‍💻👩‍💻👩‍💻")
name = string.gsub(name,"👨‍🔧","👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👨‍🔧👩‍🔧")
name = string.gsub(name,"👩‍🍳","👨‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳👩‍🍳👨‍🍳👨‍🍳👨‍🍳")
name = string.gsub(name,"🧚‍♀","🧚‍♂🧚‍♂🧚‍♂🧚‍♂🧚‍♀🧚‍♂🧚‍♂")
name = string.gsub(name,"🧜‍♂","🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧚‍♂🧜‍♀🧜‍♀🧜‍♀")
name = string.gsub(name,"🧝‍♂","🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♂🧝‍♀🧝‍♀🧝‍♀")
name = string.gsub(name,"🙍‍♂️","🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙍‍♂️🙎‍♂️🙎‍♂️🙎‍♂️")
name = string.gsub(name,"🧖‍♂️","🧖‍♀️🧖‍♀️??‍♀️🧖‍♀️🧖‍♀️🧖‍♂️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️")
name = string.gsub(name,"👬","👭👭👭👭👭👬👭👭👭")
name = string.gsub(name,"👨‍👨‍👧","👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👧👨‍👨‍👦👨‍👨‍👦")
name = string.gsub(name,"🕒","🕒🕒🕒🕒🕒🕒🕓🕒🕒🕒")
name = string.gsub(name,"🕤","🕥🕥🕥🕥🕥🕤🕥🕥🕥")
name = string.gsub(name,"⌛️","⏳⏳⏳⏳⏳⏳⌛️⏳⏳")
name = string.gsub(name,"📅","📆📆📆📆📆📆📅📆📆")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اسرع واحد يدز الاختلاف ~* ( ["..name.."] )","md",true)  
end
if text == "امثله" then
redis:del(bot_id..":"..msg.chat_id..":game:Example")
mthal = {"جوز","ضراطه","الحبل","الحافي","شقره","بيدك","سلايه","النخله","الخيل","حداد","المبلل","يركص","قرد","العنب","العمه","الخبز","بالحصاد","شهر","شكه","يكحله",};
name = mthal[math.random(#mthal)]
redis:set(bot_id..":"..msg.chat_id..":game:Example",name)
name = string.gsub(name,"جوز","ينطي____للماعده سنون")
name = string.gsub(name,"ضراطه","الي يسوق المطي يتحمل___")
name = string.gsub(name,"بيدك","اكل___محد يفيدك")
name = string.gsub(name,"الحافي","تجدي من___نعال")
name = string.gsub(name,"شقره","مع الخيل يا___")
name = string.gsub(name,"النخله","الطول طول___والعقل عقل الصخلة")
name = string.gsub(name,"سلايه","بالوجه امراية وبالظهر___")
name = string.gsub(name,"الخيل","من قلة___شدو على الچلاب سروج")
name = string.gsub(name,"حداد","موكل من صخم وجهه كال آني___")
name = string.gsub(name,"المبلل","___ما يخاف من المطر")
name = string.gsub(name,"الحبل","اللي تلدغة الحية يخاف من جرة___")
name = string.gsub(name,"يركص","المايعرف___يقول الكاع عوجه")
name = string.gsub(name,"العنب","المايلوح___يقول حامض")
name = string.gsub(name,"العمه","___إذا حبت الچنة ابليس يدخل الجنة")
name = string.gsub(name,"الخبز","انطي___للخباز حتى لو ياكل نصه")
name = string.gsub(name,"باحصاد","اسمة___ومنجله مكسور")
name = string.gsub(name,"شهر","امشي__ولا تعبر نهر")
name = string.gsub(name,"شكه","يامن تعب يامن__يا من على الحاضر لكة")
name = string.gsub(name,"القرد","__بعين امه غزال")
name = string.gsub(name,"يكحله","اجه___عماها")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اسرع واحد يكمل المثل~* ( ["..name.."] )","md",true)  
end
if text == "سمايلات" or text == "سمايل" then
redis:del(bot_id..":"..msg.chat_id..":game:Smile")
Random = {"🍏","🍎","🍐","🍊","🍋","🍉","🍇","🍓","🍈","🍒","🍑","🍍","🥥","🥝","🍅","🍆","🥑","🥦","🥒","🌶","🌽","🥕","🥔","🥖","🥐","🍞","🥨","🍟","🧀","🥚","🍳","🥓","🥩","🍗","🍖","🌭","🍔","🍠","🍕","🥪","🥙","☕️","🥤","🍶","🍺","🍻","🏀","⚽️","🏈","⚾️","🎾","🏐","🏉","🎱","🏓","🏸","🥅","🎰","🎮","🎳","🎯","🎲","🎻","🎸","🎺","🥁","🎹","🎼","🎧","🎤","🎬","🎨","🎭","🎪","🎟","🎫","🎗","🏵","🎖","🏆","🥌","🛷","🚗","🚌","🏎","🚓","🚑","🚚","🚛","🚜","⚔","🛡","🔮","🌡","💣","- ","📍","📓","📗","📂","📅","📪","📫","- ","📭","⏰","📺","🎚","☎️","📡"}
SM = Random[math.random(#Random)]
redis:set(bot_id..":"..msg.chat_id..":game:Smile",SM)
return bot.sendText(msg.chat_id,msg.id,"  ⌔︙اسرع واحد يدز هاذا السمايل ?~ ( "..SM.."}","md",true)  
end
if text == "الاسرع" or text == "ترتيب" then
redis:del(bot_id..":"..msg.chat_id..":game:Monotonous")
KlamSpeed = {"سحور","سياره","استقبال","قنفذ","ايفون","بزونه","مطبخ","كرستيانو","دجاجه","مدرسه","الوان","غرفه","ثلاجه","قهوه","سفينه","ريفور","محطه","طياره","رادار","منزل","مستشفى","كهرباء","تفاحه","اخطبوط","سلمون","فرنسا","برتقاله","تفاح","مطرقه","سونيك","لعبه","شباك","باص","سمكه","ذباب","تلفاز","حاسوب","انترنت","ساحه","جسر"};
name = KlamSpeed[math.random(#KlamSpeed)]
redis:set(bot_id..":"..msg.chat_id..":game:Monotonous",name)
name = string.gsub(name,"سحور","س ر و ح")
name = string.gsub(name,"سونيك","ي س ك ن ك")
name = string.gsub(name,"سياره","ه ر س ي ا")
name = string.gsub(name,"استقبال","ل ب ا ت ق س ا")
name = string.gsub(name,"قنفذ","ذ ق ن ف")
name = string.gsub(name,"ايفون","و ن ف ا")
name = string.gsub(name,"ريفور","ر و ف ر ي")
name = string.gsub(name,"مطبخ","خ ب ط م")
name = string.gsub(name,"كرستيانو","س ت ا ن و ك ر ي")
name = string.gsub(name,"دجاجه","ج ج ا د ه")
name = string.gsub(name,"مدرسه","ه م د ر س")
name = string.gsub(name,"الوان","ن ا و ا ل")
name = string.gsub(name,"غرفه","غ ه ر ف")
name = string.gsub(name,"ثلاجه","ج ه ت ل ا")
name = string.gsub(name,"قهوه","ه ق ه و")
name = string.gsub(name,"سفينه","ه ن ف ي س")
name = string.gsub(name,"محطه","ه ط م ح")
name = string.gsub(name,"طياره","ر ا ط ي ه")
name = string.gsub(name,"رادار","ر ا ر ا د")
name = string.gsub(name,"منزل","ن ز م ل")
name = string.gsub(name,"مستشفى","ى ش س ف ت م")
name = string.gsub(name,"كهرباء","ر ب ك ه ا ء")
name = string.gsub(name,"تفاحه","ح ه ا ت ف")
name = string.gsub(name,"اخطبوط","ط ب و ا خ ط")
name = string.gsub(name,"سلمون","ن م و ل س")
name = string.gsub(name,"فرنسا","ن ف ر س ا")
name = string.gsub(name,"برتقاله","ر ت ق ب ا ه ل")
name = string.gsub(name,"تفاح","ح ف ا ت")
name = string.gsub(name,"مطرقه","ه ط م ر ق")
name = string.gsub(name,"مصر","ص م ر")
name = string.gsub(name,"لعبه","ع ل ه ب")
name = string.gsub(name,"شباك","ب ش ا ك")
name = string.gsub(name,"باص","ص ا ب")
name = string.gsub(name,"سمكه","ك س م ه")
name = string.gsub(name,"ذباب","ب ا ب ذ")
name = string.gsub(name,"تلفاز","ت ف ل ز ا")
name = string.gsub(name,"حاسوب","س ا ح و ب")
name = string.gsub(name,"انترنت","ا ت ن ن  ر ت")
name = string.gsub(name,"ساحه","ح ا ه س")
name = string.gsub(name,"جسر","ر ج س")
return bot.sendText(msg.chat_id,msg.id,"  ⌔︙اسرع واحد يرتبها~ ( ["..name.."] )","md",true)  
end
if text == "حزوره" then
redis:del(bot_id..":"..msg.chat_id..":game:Riddles")
Hzora = {"الجرس","عقرب الساعة","السمك","المطر","5","الكتاب","البسمار","7","الكعبه","بيت الشعر","لهانه","انا","امي","الابره","الساعة","22","غلط","كم الساعة","البيتنجان","البيض","المرايه","الضوء","الهواء","الضل","العمر","القلم","المشط","الحفره","البحر","الثلج","الاسفنج","الصوت","بلم"};
name = Hzora[math.random(#Hzora)]
redis:set(bot_id..":"..msg.chat_id..":game:Riddles",name)
name = string.gsub(name,"الجرس","شيئ اذا لمسته صرخ ما هوه ؟")
name = string.gsub(name,"عقرب الساعة","اخوان لا يستطيعان تمضيه اكثر من دقيقة معا فما هما ؟")
name = string.gsub(name,"السمك","ما هو الحيوان الذي لم يصعد الى سفينة نوح عليه السلام ؟")
name = string.gsub(name,"المطر","شيئ يسقط على رأسك من الاعلى ولا يجرحك فما هو ؟")
name = string.gsub(name,"5","ما العدد الذي اذا ضربته بنفسه واضفت عليه 5 يصبح ثلاثين ")
name = string.gsub(name,"الكتاب","ما الشيئ الذي له اوراق وليس له جذور ؟")
name = string.gsub(name,"البسمار","ما هو الشيئ الذي لا يمشي الا بالضرب ؟")
name = string.gsub(name,"7","عائله مؤلفه من 6 بنات واخ لكل منهن .فكم عدد افراد العائله ")
name = string.gsub(name,"الكعبه","ما هو الشيئ الموجود وسط مكة ؟")
name = string.gsub(name,"بيت الشعر","ما هو البيت الذي ليس فية ابواب ولا نوافذ ؟ ")
name = string.gsub(name,"لهانه","وحده حلوه ومغروره تلبس مية تنوره .من هيه ؟ ")
name = string.gsub(name,"انا","ابن امك وابن ابيك وليس باختك ولا باخيك فمن يكون ؟")
name = string.gsub(name,"امي","اخت خالك وليست خالتك من تكون ؟ ")
name = string.gsub(name,"الابره","ما هو الشيئ الذي كلما خطا خطوه فقد شيئا من ذيله ؟ ")
name = string.gsub(name,"الساعة","ما هو الشيئ الذي يقول الصدق ولكنه اذا جاع كذب ؟")
name = string.gsub(name,"22","كم مره ينطبق عقربا الساعة على بعضهما في اليوم الواحد ")
name = string.gsub(name,"غلط","ما هي الكلمه الوحيده التي تلفض غلط دائما ؟ ")
name = string.gsub(name,"كم الساعة","ما هو السؤال الذي تختلف اجابته دائما ؟")
name = string.gsub(name,"البيتنجان","جسم اسود وقلب ابيض وراس اخظر فما هو ؟")
name = string.gsub(name,"البيض","ماهو الشيئ الذي اسمه على لونه ؟")
name = string.gsub(name,"المرايه","ارى كل شيئ من دون عيون من اكون ؟ ")
name = string.gsub(name,"الضوء","ما هو الشيئ الذي يخترق الزجاج ولا يكسره ؟")
name = string.gsub(name,"الهواء","ما هو الشيئ الذي يسير امامك ولا تراه ؟")
name = string.gsub(name,"الضل","ما هو الشيئ الذي يلاحقك اينما تذهب ؟ ")
name = string.gsub(name,"العمر","ما هو الشيء الذي كلما طال قصر ؟ ")
name = string.gsub(name,"القلم","ما هو الشيئ الذي يكتب ولا يقرأ ؟")
name = string.gsub(name,"المشط","له أسنان ولا يعض ما هو ؟ ")
name = string.gsub(name,"الحفره","ما هو الشيئ اذا أخذنا منه ازداد وكبر ؟")
name = string.gsub(name,"البحر","ما هو الشيئ الذي يرفع اثقال ولا يقدر يرفع مسمار ؟")
name = string.gsub(name,"الثلج","انا ابن الماء فان تركوني في الماء مت فمن انا ؟")
name = string.gsub(name,"الاسفنج","كلي ثقوب ومع ذالك احفض الماء فمن اكون ؟")
name = string.gsub(name,"الصوت","اسير بلا رجلين ولا ادخل الا بالاذنين فمن انا ؟")
name = string.gsub(name,"بلم","حامل ومحمول نصف ناشف ونصف مبلول فمن اكون ؟ ")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اسرع واحد يحل الحزوره*\n ( "..name.." )","md",true)  
end
if text == "معاني" then
redis:del(bot_id..":"..msg.chat_id..":game:Meaningof")
Maany_Rand = {"قرد","دجاجه","بطريق","ضفدع","بومه","نحله","ديك","جمل","بقره","دولفين","تمساح","قرش","نمر","اخطبوط","سمكه","خفاش","اسد","فأر","ذئب","فراشه","عقرب","زرافه","قنفذ","تفاحه","باذنجان"}
name = Maany_Rand[math.random(#Maany_Rand)]
redis:set(bot_id..":"..msg.chat_id..":game:Meaningof",name)
name = string.gsub(name,"قرد","🐒")
name = string.gsub(name,"دجاجه","🐔")
name = string.gsub(name,"بطريق","🐧")
name = string.gsub(name,"ضفدع","🐸")
name = string.gsub(name,"بومه","🦉")
name = string.gsub(name,"نحله","🐝")
name = string.gsub(name,"ديك","🐓")
name = string.gsub(name,"جمل","🐫")
name = string.gsub(name,"بقره","🐄")
name = string.gsub(name,"دولفين","🐬")
name = string.gsub(name,"تمساح","🐊")
name = string.gsub(name,"قرش","🦈")
name = string.gsub(name,"نمر","🐅")
name = string.gsub(name,"اخطبوط","🐙")
name = string.gsub(name,"سمكه","🐟")
name = string.gsub(name,"خفاش","🦇")
name = string.gsub(name,"اسد","🦁")
name = string.gsub(name,"فأر","🐭")
name = string.gsub(name,"ذئب","🐺")
name = string.gsub(name,"فراشه","🦋")
name = string.gsub(name,"عقرب","🦂")
name = string.gsub(name,"زرافه","🦒")
name = string.gsub(name,"قنفذ","🦔")
name = string.gsub(name,"تفاحه","🍎")
name = string.gsub(name,"باذنجان","🍆")
return bot.sendText(msg.chat_id,msg.id,"  ⌔︙اسرع واحد يدز معنى السمايل~ ( ["..name.."] )","md",true)  
end
if text == "العكس" then
redis:del(bot_id..":"..msg.chat_id..":game:Reflection")
katu = {"باي","فهمت","موزين","اسمعك","احبك","موحلو","نضيف","حاره","ناصي","جوه","سريع","ونسه","طويل","سمين","ضعيف","شريف","شجاع","رحت","عدل","نشيط","شبعان","موعطشان","خوش ولد","اني","هادئ"}
name = katu[math.random(#katu)]
redis:set(bot_id..":"..msg.chat_id..":game:Reflection",name)
name = string.gsub(name,"باي","هلو")
name = string.gsub(name,"فهمت","مافهمت")
name = string.gsub(name,"موزين","زين")
name = string.gsub(name,"اسمعك","ماسمعك")
name = string.gsub(name,"احبك","ماحبك")
name = string.gsub(name,"موحلو","حلو")
name = string.gsub(name,"نضيف","وصخ")
name = string.gsub(name,"حاره","بارده")
name = string.gsub(name,"و","عالي")
name = string.gsub(name,"جوه","فوك")
name = string.gsub(name,"سريع","بطيء")
name = string.gsub(name,"ونسه","ضوجه")
name = string.gsub(name,"طويل","قزم")
name = string.gsub(name,"سمين","ضعيف")
name = string.gsub(name,"ضعيف","قوي")
name = string.gsub(name,"شريف","كواد")
name = string.gsub(name,"شجاع","جبان")
name = string.gsub(name,"رحت","اجيت")
name = string.gsub(name,"عدل","ميت")
name = string.gsub(name,"نشيط","كسول")
name = string.gsub(name,"شبعان","جوعان")
name = string.gsub(name,"موعطشان","عطشان")
name = string.gsub(name,"خوش ولد","موخوش ولد")
name = string.gsub(name,"اني","مطي")
name = string.gsub(name,"هادئ","عصبي")
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اسرع واحد يدز العكس ~* ( ["..name.."])","md",true) 
end
end -- end tf
if text == 'القوانين' then
if redis:get(bot_id..":"..msg.chat_id..":Law") then
t = redis:get(bot_id..":"..msg.chat_id..":Law")
else
t = "*  ⌔︙لم يتم وضع القوانين في المجموعة *"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
if msg.content.luatele == "messageChatJoinByLink" then
if not redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
local UserInfo = bot.getUser(msg.sender.user_id)
local tex = redis:get(bot_id..":"..msg.chat_id..":Welcome")
if UserInfo.username and UserInfo.username ~= "" then
User = "[@"..UserInfo.username.."]"
Usertag = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
User = "لا يوجد!"
Usertag = '['..UserInfo.first_name..'](tg://user?id='..msg.sender.user_id..')'
end
if tex then 
tex = tex:gsub('name',UserInfo.first_name) 
tex = tex:gsub('user',User) 
bot.sendText(msg.chat_id,msg.id,tex,"md")  
else
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اطلق دخول عمري💘 : *"..Usertag..".","md")  
end
end
end
if text == 'رابط الحذف' or text == 'رابط حذف' or text == 'بوت الحذف' or text == 'حذف حساب' then 
local Text = "*  ⌔︙روابط حذف جميع برامج التواصل*\n"
keyboard = {} 
keyboard.inline_keyboard = {
{{text = ' ⌔︙ Telegram ',url="https://my.telegram.org/auth?to=delete"},{text = ' ⌔︙ instagram ',url="https://www.instagram.com/accounts/login/?next=/accounts/remove/request/permanent/"}},
{{text = ' ⌔︙ Facebook ',url="https://www.facebook.com/help/deleteaccount"},{text = ' ⌔︙ Snspchat ',url="https://accounts.snapchat.com/accounts/login?continue=https%3A%2F%2Faccounts.snapchat.com%2Faccounts%2Fdeleteaccount"}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ',url="t.me/xXStrem"}},
}
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo=https://t.me/xXStrem&caption=".. URL.escape(Text).."&photo=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == "الساعة" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الساعة الان : ( "..os.date("%I:%M%p").." )*","md",true)  
end
if text == "شسمك" or text == "سنو اسمك" then
namet = {"اسمي "..(redis:get(bot_id..":namebot") or "ستريم"),"عمريي اسمي "..(redis:get(bot_id..":namebot") or "ستريم"),"اني لعميل "..(redis:get(bot_id..":namebot") or "ستريم"),(redis:get(bot_id..":namebot") or "ستريم").." اني"}
bot.sendText(msg.chat_id,msg.id,"*"..namet[math.random(#namet)].."*","md",true)  
end
if text == "بوت" or text == (redis:get(bot_id..":namebot") or "ستريم") then
nameBot = {"ها حبي","نعم تفضل ؟","محتاج شي","عوفني ضايج","خبصتني ترى","هاككو","ها مولاي","هياتني","شتريد؟ ","امرني حياتي","ها سيد","ها يروحي","هاااا فضني"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
--------

----------
if text == "التاريخ" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙التاريخ الان : ( "..os.date("%Y/%m/%d").." )*","md",true)  
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
if text == 'البايو' or text == 'نبذتي' then
bot.sendText(msg.chat_id,msg.id,GetBio(msg.sender.user_id),"md",true)  
return false
end
end
if text == 'رفع المنشئ' or text == 'رفع المالك' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙البوت لا يمتلك صلاحية*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local list_ = info_.members
for k, v in pairs(list_) do
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator", v.member_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*","md",true)  
end
end
end
if text == 'المنشئ' or text == 'المالك' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙البوت لا يمتلك صلاحية*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local list_ = info_.members
for k, v in pairs(list_) do
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.first_name == "" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙"..text.." حساب محذوف*","md",true)  
return false
end
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
u = '[@'..UserInfo.username..']'
ban = ' '..UserInfo.first_name..' '
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,UserInfo.id)
if sm.status.custom_title then
if sm.status.custom_title ~= "" then
custom = sm.status.custom_title
else
custom = 'لا يوجد'
end
end
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
local photo = bot.getUserProfilePhotos(UserInfo.id)
if photo.total_count > 0 then
local TestText = "  *  ⌔︙Name : *( "..(t).." *)*\n*  ⌔︙User : *( "..(u).." *)*\n*  ⌔︙Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الاسم : *( "..(t).." *)*\n*  ⌔︙المعرف : *( "..(u).." *)*\n["..GetBio(UserInfo.id).."]","md",true)  
end
end
end
end
if text == 'المطور' or text == 'مطور البوت' then
local UserInfo = bot.getUser(sudoid)
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
ban = ' '..UserInfo.first_name..' '
u = '[@'..UserInfo.username..']'
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
local photo = bot.getUserProfilePhotos(UserInfo.id)
if photo.total_count > 0 then
local TestText = "  *  ⌔︙Name : *( "..(t).." *)*\n*  ⌔︙User : *( "..(u).." *)*\n*  ⌔︙Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الاسم : *( "..(t).." *)*\n*  ⌔︙المعرف : *( "..(u).." *)*\n["..GetBio(UserInfo.id).."]","md",true)  
end
end
if text == 'مبرمج السورس' or text == 'مطور السورس' or text == 'احمد' then
local UserId_Info = bot.searchPublicChat("F_T_Y")
if UserId_Info.id then
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
ban = ' '..UserInfo.first_name..' '
u = '[@'..UserInfo.username..']'
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
local photo = bot.getUserProfilePhotos(UserId_Info.id)
if photo.total_count > 0 then
local TestText = "  *  ⌔︙Name : *( "..(t).." *)*\n*  ⌔︙User : *( "..(u).." *)*\n*  ⌔︙Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الاسم : *( "..(t).." *)*\n*  ⌔︙المعرف : *( "..(u).." *)*\n["..GetBio(UserInfo.id).."]","md",true)  
end
end
end
if Owner(msg) then
if text == "تثبيت" and msg.reply_to_message_id ~= 0 then
if GetInfoBot(msg).PinMsg == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙ليس لدي صلاحية تثبيت رسائل*',"md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تثبيت الرسالة*","md",true)
local Rmsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
bot.pinChatMessage(msg.chat_id,Rmsg.id,true)
end
end
if text == 'معلوماتي' or text == 'موقعي' or text == 'صلاحياتي' then
local UserInfo = bot.getUser(msg.sender.user_id)
local Statusm = bot.getChatMember(msg.chat_id,msg.sender.user_id).status.luatele
if Statusm == "chatMemberStatusCreator" then
StatusmC = 'منشئ'
elseif Statusm == "chatMemberStatusAdministrator" then
StatusmC = 'مشرف'
else
StatusmC = 'عضو'
end
if StatusmC == 'مشرف' then 
local GetMemberStatus = bot.getChatMember(msg.chat_id,msg.sender.user_id).status
if GetMemberStatus.can_change_info then
change_info = '✔️' else change_info = '❌'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✔️' else delete_messages = '❌'
end
if GetMemberStatus.can_invite_users then
invite_users = '✔️' else invite_users = '❌'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✔️' else pin_messages = '❌'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✔️' else restrict_members = '❌'
end
if GetMemberStatus.can_promote_members then
promote = '✔️' else promote = '❌'
end
if StatusmC == "عضو" then
PermissionsUser = ' '
else
PermissionsUser = '*\n  ⌔︙صلاحياتك هي :\n *ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *'..'\n  ⌔︙تغيير المعلومات : '..change_info..'\n  ⌔︙تثبيت الرسائل : '..pin_messages..'\n  ⌔︙اضافة مستخدمين : '..invite_users..'\n  ⌔︙مسح الرسائل : '..delete_messages..'\n  ⌔︙حظر المستخدمين : '..restrict_members..'\n  ⌔︙اضافة المشرفين : '..promote..'\n\n*'
end
end
local UserId = msg.sender.user_id
local Get_Rank =(Get_Rank(msg.sender.user_id,msg.chat_id))
local messageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1)
local EditmessageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0)
local Total_ms =Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1))
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername = '@'..UserInfo.username
else
UserInfousername = 'لا يوجد'
end
bot.sendText(msg.chat_id,msg.id,'\n*  ⌔︙ايديك : '..UserId..'\n  ⌔︙معرفك : '..UserInfousername..'\n  ⌔︙‍رتبتك : '..Get_Rank..'\n  ⌔︙موقعك : '..StatusmC..'\n  ⌔︙رسائلك : '..messageC..'\n  ⌔︙تعديلاتك : '..EditmessageC..'\n  ⌔︙تفاعلك : '..Total_ms..'*'..(PermissionsUser or '') ,"md",true) 
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:id") then
if text == "ايدي" and msg.reply_to_message_id == 0 then
local Get_Rank =(Get_Rank(msg.sender.user_id,msg.chat_id))
local messageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1)
local gameC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0)
local Addedmem =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem") or 0)
local EditmessageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0)
local Total_ms =Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1))
local photo = bot.getUserProfilePhotos(msg.sender.user_id)
local TotalPhoto = photo.total_count or 0
local UserInfo = bot.getUser(msg.sender.user_id)
local Texting = {
'*  ⌔︙*صورتك فدشي 😘😔❤️',
"*  ⌔︙*صارلك شكد مخليه ",
"*  ⌔︙*وفالله 😔💘",
"*  ⌔︙*كشخه برب 😉💘",
"*  ⌔︙*دغيره شبي هذ 😒",
"*  ⌔︙*عمري الحلوين 💘",
}
local Description = Texting[math.random(#Texting)]
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername ="[@"..UserInfo.username.."]"
else
UserInfousername = 'لا يوجد'
end
if redis:get(bot_id..":"..msg.chat_id..":id") then
theId = redis:get(bot_id..":"..msg.chat_id..":id") 
theId = theId:gsub('#AddMem',Addedmem) 
theId = theId:gsub('#game',gameC) 
theId = theId:gsub('#id',msg.sender.user_id) 
theId = theId:gsub('#username',UserInfousername) 
theId = theId:gsub('#msgs',messageC) 
theId = theId:gsub('#edit',EditmessageC) 
theId = theId:gsub('#stast',Get_Rank) 
theId = theId:gsub('#auto',Total_ms) 
theId = theId:gsub('#Description',Description) 
theId = theId:gsub('#photos',TotalPhoto) 
else
theId = Description.."\n*  ⌔︙الايدي : (* "..msg.sender.user_id.."* )\n  ⌔︙المعرف :* ( "..UserInfousername.." )\n*  ⌔︙الرتبه : (  "..Get_Rank.." )\n  ⌔︙تفاعلك : (  "..Total_ms.." )\n  ⌔︙عدد الرسائل : ( "..messageC.." )\n  ⌔︙عدد التعديلات : ( "..EditmessageC.." )\n  ⌔︙عدد صورك : ( "..TotalPhoto.."* )"
end
if redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
bot.sendText(msg.chat_id,msg.id,theId,"md",true) 
return false
end
if photo.total_count > 0 then
return bot.sendPhoto(msg.chat_id, msg.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,theId,"md")
else
return bot.sendText(msg.chat_id,msg.id,theId,"md",true) 
end
end
end
if text == 'تاك للكل' and Administrator(msg) then
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
ls = '\n*  ⌔︙قائمة الاعضاء \n ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username and UserInfo.username ~= "" then
ls = ls..'*'..k..' - *@['..UserInfo.username..']\n'
else
ls = ls..'*'..k..' - *['..UserInfo.first_name..'](tg://user?id='..v.member_id.user_id..')\n'
end
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end
if text and text:match('^ايدي @(%S+)$') or text and text:match('^كشف @(%S+)$') then
local UserName = text:match('^ايدي @(%S+)$') or text:match('^كشف @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,UserId_Info.id)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الايدي : *( "..(UserId_Info.id).." *)*\n*  ⌔︙المعرف : *( [@"..(UserName).."] *)*\n*  ⌔︙الرتبه : *( "..(Get_Rank(UserId_Info.id,msg.chat_id)).." *)*\n*  ⌔︙الموقع : *( "..(gstatus).." *)*\n*  ⌔︙عدد الرسائل : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":message") or 1).." *)*" ,"md",true)  
end
if text == 'ايدي' or text == 'كشف'  and msg.reply_to_message_id ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.username and UserInfo.username ~= "" then
uame = '@'..UserInfo.username
else
uame = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,Remsg.sender.user_id)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الايدي : *( "..(Remsg.sender.user_id).." *)*\n*  ⌔︙المعرف : *( ["..(uame).."] *)*\n*  ⌔︙الرتبه : *( "..(Get_Rank(Remsg.sender.user_id,msg.chat_id)).." *)*\n*  ⌔︙الموقع : *( "..(gstatus).." *)*\n*  ⌔︙عدد الرسائل : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..Remsg.sender.user_id..":message") or 1).." *)*" ,"md",true)  
end
if text and text:match('^كشف (%d+)$') or text and text:match('^ايدي (%d+)$') then
local UserName = text:match('^كشف (%d+)$') or text:match('^ايدي (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if UserInfo.username and UserInfo.username ~= "" then
uame = '@'..UserInfo.username
else
uame = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,UserName)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الايدي : *( "..(UserName).." *)*\n*  ⌔︙المعرف : *( ["..(uame).."] *)*\n*  ⌔︙الرتبه : *( "..(Get_Rank(UserName,msg.chat_id)).." *)*\n*  ⌔︙الموقع : *( "..(gstatus).." *)*\n*  ⌔︙عدد الرسائل : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..UserName..":message") or 1).." *)*" ,"md",true)  
end
if text == 'رتبتي' then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙رتبتك : *( "..(Get_Rank(msg.sender.user_id,msg.chat_id)).." *)*","md",true)  
return false
end
if text == 'تعديلاتي' or text == 'تعديلاتي' then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عدد تعديلاتك : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0).." *)*","md",true)  
return false
end
if text == 'مسح تعديلاتي' or text == 'مسح تعديلاتي' then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم مسح جميع تعديلاتك*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage")
return false
end
if text == 'جهاتي' or text == 'اضافاتي' then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عدد جهاتك : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem") or 0).." *)*","md",true)  
return false
end
if text == 'تفاعلي' or text == 'نشاطي' then
bot.sendText(msg.chat_id,msg.id,"*"..Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1)).."*","md",true)  
return false
end
if text ==("مسح") and Vips(msg) and tonumber(msg.reply_to_message_id) > 0 then
if GetInfoBot(msg).Delmsg == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙ليس لدي صلاحية حذف رسائل*',"md",true)  
return false
end
bot.deleteMessages(msg.chat_id,{[1]= msg.reply_to_message_id})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end   
if text == 'مسح جهاتي' or text == 'مسح اضافاتي' then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم مسح جميع جهاتك*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem")
return false
end
if text == "منو ضافني" and not redis:get(bot_id..":"..msg.chat_id..":settings:addme") then
if bot.getChatMember(msg.chat_id,msg.sender.user_id).status.luatele == "chatMemberStatusCreator" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙انت منشئ المجموعة*","md",true) 
return false
end
addby = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":AddedMe")
if addby then 
UserInfo = bot.getUser(addby)
Name = '['..UserInfo.first_name..'](tg://user?id='..addby..')'
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم اضافتك بواسطة  : ( *"..(Name).." *)*","md",true)  
else
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قد قمت بالانضمام عبر الرابط*","md",true) 
return false
end
end
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") 
if text == 'رسائلي' then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عدد رسائلك : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1).." *)*","md",true)  
return false
end
if text == 'مسح رسائلي' then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم مسح جميع رسائلك*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message")
return false
end
if text == 'نقاطي' or text == 'مجوهراتي' then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عدد نقاطك : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0).." *)*","md",true)  
return false
end
if text and text:match("^بيع نقاطي (%d+)$") then  
local end_n = text:match("^بيع نقاطي (%d+)$")
if tonumber(end_n) == tonumber(0) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا استطيع البيع اقل من 1*","md",true)  
return false 
end
if tonumber(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game")) == tonumber(0) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ليس لديك جواهر من الالعاب \n  ⌔︙اذا كنت تريد ربح الجواهر \n  ⌔︙ارسل الالعاب وابدأ اللعب !*","md",true)  
else
local nb = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game")
if tonumber(end_n) > tonumber(nb) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ليس لديك جواهر بهاذا العدد \n  ⌔︙لزيادة مجوهراتك في اللعبه \n  ⌔︙ارسل الالعاب وابدأ اللعب !*","md",true)  
return false
end
local end_d = string.match((end_n * 50), "(%d+)") 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم خصم* *~ { "..end_n.." }* *من مجوهراتك* \n*  ⌔︙وتم اضافة* *~ { "..end_d.." }* *الى رسائلك*","md",true)  
redis:decrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game",end_n)  
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message",end_d)  
end
return false 
end
if text == 'مسح نقاطي' or text == 'مسح مجوهراتي' then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم مسح جميع نقاطك*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game")
return false
end
if text == 'ايديي' then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ايديك : *( "..msg.sender.user_id.." *)*","md",true)  
return false
end
if text == 'اسمي' then
bot.sendText(msg.chat_id,msg.id," *  ⌔︙اسمك : *( "..bot.getUser(msg.sender.user_id).first_name.." *)*","md",true)  
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:link") then
if text == 'الرابط' then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
if redis:get(bot_id..":"..msg.chat_id..":link") then
link = redis:get(bot_id..":"..msg.chat_id..":link")
else
if Info_Chats.invite_link.invite_link then
link = Info_Chats.invite_link.invite_link
else
link = "لايوجد"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = link}},
}
}
bot.sendText(msg.chat_id,msg.id,"  ⌔︙_رابط المجموعة : _*"..Get_Chat.title.."*\n ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ \n"..link,"md",true, false, false, false, reply_markup)
return false
end
end
if text == 'المجموعة' or text == 'عدد القورب' or text == 'عدد المجموعة' then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
bot.sendText(msg.chat_id,msg.id,'\n*  ⌔︙معلومات المجموعة :\n  ⌔︙الايدي : ( '..msg.chat_id..' )\n  ⌔︙عدد الاعضاء : '..Info_Chats.member_count..'\n  ⌔︙عدد الادامن : '..Info_Chats.administrator_count..'\n  ⌔︙عدد المطرودين : '..Info_Chats.banned_count..'\n  ⌔︙عدد المقيدين : '..Info_Chats.restricted_count..'\n  ⌔︙الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md",true, false, false, false, reply_markup)
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
if text == 'الالعاب الاحترافية' and Vips(msg)  then
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text="♟ Chess Game ♟",url='https://t.me/T4TTTTBOT?game=chess'}},
{{text="لعبة فلابي بيرد 🐥",url='https://t.me/awesomebot?game=FlappyBird'},{text="تحداني فالرياضيات 🔢",url='https://t.me/gamebot?game=MathBattle'}},
{{text="تحداني في ❌⭕️",url='t.me/XO_AABOT?start3836619'},{text="سباق الدراجات 🏍",url='https://t.me/gamee?game=MotoFX'}},
{{text="سباق سيارات 🏎",url='https://t.me/gamee?game=F1Racer'},{text="متشابه 👾",url='https://t.me/gamee?game=DiamondRows'}},
{{text="كرة قدم ⚽",url='https://t.me/gamee?game=FootballStar'}},
{{text="دومنا🥇",url='https://vipgames.com/play/?affiliateId=wpDom/#/games/domino/lobby'},{text="❕ليدو",url='https://vipgames.com/play/?affiliateId=wpVG#/games/ludo/lobby'}},
{{text="ورق🤹‍♂",url='https://t.me/gamee?game=Hexonix'},{text="Hexonix❌",url='https://t.me/gamee?game=Hexonix'}},
{{text="MotoFx🏍️",url='https://t.me/gamee?game=MotoFx'}},
{{text="لعبة 2048 🎰",url='https://t.me/awesomebot?game=g2048'},{text="Squares🏁",url='https://t.me/gamee?game=Squares'}},
{{text="Atomic 1▶️",url='https://t.me/gamee?game=AtomicDrop1'},{text="Corsairs",url='https://t.me/gamebot?game=Corsairs'}},
{{text="LumberJack",url='https://t.me/gamebot?game=LumberJack'}},
{{text="LittlePlane",url='https://t.me/gamee?game=LittlePlane'},{text="RollerDisco",url='https://t.me/gamee?game=RollerDisco'}},
{{text="🦖 Dragon Game 🦖",url='https://t.me/T4TTTTBOT?game=dragon'},{text="🐍 3D Snake Game 🐍",url='https://t.me/T4TTTTBOT?game=snake'}},
{{text="🔵 Color Game 🔴",url='https://t.me/T4TTTTBOT?game=color'}},
{{text="🚀 Rocket Game 🚀",url='https://t.me/T4TTTTBOT?game=rocket'},{text="🏹 Arrow Game 🏹",url='https://t.me/T4TTTTBOT?game=arrow'}},
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙قائمة الالعاب الاحترافية اضغط للعب*',"md", true, false, false, false, reply_markup)
end
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
if text == "شنو رئيك بهذا" or text == "شنو رائيك بهذ" or text == "شنو رئيك بهذ" or text == "شنو رائيك بهذ" then
local texting = {"ادب سسز يباوع علي بنات ??🥺"," مو خوش ولد 😶","زاحف وما احبه 😾😹","شهل سرسري هذا🤨","امووووع انا🤤","عنفسسسيه هذاا🤮","شايف نفسه فد خريه🤨","هااا كرششتي😉","زووف اوافق بدون مهرر🙊","زربه بيكم ع هل ذووق😐","خليكوم يسبح ويجي🤧","وااصل مرحله هذا","راسه مربع شعجبج بي😕👌🏿"}
bot.sendText(msg.chat_id,msg.id,"*"..texting[math.random(#texting)].."*","md", true)
end
if text == "شنو رئيك بهاي" or text == "شنو رئيك بهايي" or text == "شنو رائيك بهايي" or text == "شنو رائيك بهايي" then
local texting = {"دور حلوين 🤕😹","جكمه وصخه عوفها ☹️😾","حقيره ومتكبره 😶😂","وووف فد حاته🤤😍","لك عوووع شهلذوق🤮😑","اهم شي الاخلاق🤧","اويلي زوجوني هيا😍","ام الكمل هاي شجابك عليها🤓","هااا كررشتت😳","طيح الله حظك وحظ رائيك😑","مفارغ الكم هسه😏","تعالني ورا 12 اجاوبك😉"}
bot.sendText(msg.chat_id,msg.id,"*"..texting[math.random(#texting)].."*","md", true)
end
if text == "هينه" or text == "رزله" or text == "بعد هينه" or text == "هينه بعد" or text == "لك هينه" or text == "هينها" or text == "هينهه" or text == "رزلهه" or text == "رزلها" or text == "بعد هينها" or text == "هينها بعد" or text == "لك هينها" then
heen = {
"- حبيبي علاج الجاهل التجاهل ."
,"- مالي خلك زبايل التلي . "
,"- كرامتك صارت بزبل פَــبي ."
,"- مو صوجك صوج ابوك الزمك جهاز ."
,"- لفارغ استجن . "
,"- ڪِݪك واحد لوكي ."
,"- لكك جرجف احترم اسيادكك لا اكتلكك وازربب على كبركك ."
,"- هشش فاشل لتضل تمسلت لا اخربط تضاريس وجهك جنه ابط عبده ."
,"- دمشي لك ينبوع الفشل مو زين ملفيك ونحجي وياك هي منبوذ ."
,"- ها الغليض التفس ابو راس المربع متعلملك جم حجايه وجاي تطكطكهن علينه دبطل😒🔪 ."
,"- حبيبي راح احاول احترمكك هالمره بلكي تبطل حيونه ."
,"- دمشي امشي راسك مصفح ."
,"- ياهونته ولك دخذ غراضك او ولي منا يلا ."
,"- طيططط دكوم لك كوم كواد ."
,"- انته فد واحد لوكي وزعطوط ."
,"- شبيك خلي العالم تحترمك صاير وصله مال مسح ."
,"- دي لك دي حيوان ."
,"- ملطلط دي ."
,"- تع اراويك الطيور فوك السطح ."
};
sendheen = heen[math.random(#heen)]
if tonumber(msg.reply_to_message_id) == 0 then
bot.sendText(msg.chat_id,msg.id,"*- يجب عمل رد على رسالة شخص .*","md", true)
return false
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if programmer(Remsg) then
bot.sendText(msg.chat_id,msg.id,"*- دي لكك تريد اهينن تاج راسكك؟😏🖕🏿 .*","md", true)
return false
end
bot.sendText(msg.chat_id,msg.reply_to_message_id,"*"..sendheen.."*","md", true)
end
if text == "تفله" or text == "بعد تفله" or text == "بعد تفله" or text == "شبعه تفال" or text == "لك تفله" or text == "تتف" or text == "تف" or text == "تفوو" or text == "ضل تفل" then
tif = {
"ماي ورد حبيبي🤤 ."
,"تفو ووقوزولقورط . "
,"تف عليك تبسزز ."
,"حتى التفله هواي عليك/ج ."
,"ختتتتفو. "
,"تفله ام بلغم ."
,"تفله بنص وجهك /جهج ."
,"تف تف تف تف تف تف تف 💦 ."
,"ختفووووووووو💦 ."
,"تع اشبعك تفاال حبيبي💦 ."
,"وجهه ميستاهل اصرف تفله عليه🤨 ."
,"دمشي  لاسبحك تفال😐 ."
};
sendtif = tif[math.random(#tif)]
if tonumber(msg.reply_to_message_id) == 0 then
bot.sendText(msg.chat_id,msg.id,"*- يجب عمل رد على رسالة شخص .*","md", true)
return false
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if programmer(Remsg) then
bot.sendText(msg.chat_id,msg.id,"*- دي لكك تريد اتفل على تاج راسكك؟😏🖕🏿 .*","md", true)
return false
end
bot.sendText(msg.chat_id,msg.reply_to_message_id,"*"..sendtif.."*","md", true)
end
if text == "كت" or  text == "كت تويت" then
local arr = {'آخر مرة زرت مدينة الملاهي؟','آخر مرة أكلت أكلتك المفضّلة؟','الوضع الحالي؟\n‏1. سهران\n‏2. ضايج\n‏3. أتأمل','آخر شيء ضاع منك؟','كلمة أخيرة لشاغل البال؟','طريقتك المعتادة في التخلّص من الطاقة السلبية؟','شهر من أشهر العام له ذكرى جميلة معك؟','كلمة غريبة من لهجتك ومعناها؟🤓','‏- شيء سمعته عالق في ذهنك هاليومين؟','متى تكره الشخص الذي أمامك حتى لو كنت مِن أشد معجبينه؟','‏- أبرز صفة حسنة في صديقك المقرب؟','هل تشعر أن هنالك مَن يُحبك؟','اذا اكتشفت أن أعز أصدقائك يضمر لك السوء، موقفك الصريح؟','أجمل شيء حصل معك خلال هاليوم؟','صِف شعورك وأنت تُحب شخص يُحب غيرك؟👀💔','كلمة لشخص غالي اشتقت إليه؟💕','آخر خبر سعيد، متى وصلك؟','أنا آسف على ....؟','أوصف نفسك بكلمة؟','صريح، مشتاق؟','‏- صريح، هل سبق وخذلت أحدهم ولو عن غير قصد؟','‏- ماذا ستختار من الكلمات لتعبر لنا عن حياتك التي عشتها الى الآن؟💭','‏- فنان/ة تود لو يدعوكَ على مائدة عشاء؟😁❤','‏- تخيّل شيء قد يحدث في المستقبل؟','‏- للشباب | آخر مرة وصلك غزل من فتاة؟🌚','شخص أو صاحب عوضك ونساك مُر الحياة ما اسمه ؟','| اذا شفت حد واعجبك وعندك الجرأه انك تروح وتتعرف عليه ، مقدمة الحديث شو راح تكون ؟.','كم مره تسبح باليوم','نسبة النعاس عندك حاليًا؟','لو فقط مسموح شخص واحد تتابعه فالسناب مين بيكون ؟','يهمك ملابسك تكون ماركة ؟','وش الشيء الي تطلع حرتك فية و زعلت ؟','عندك أخوان او خوات من الرضاعة؟','عندك معجبين ولا محد درا عنك؟','أطول مدة قضيتها بعيد عن أهلك ؟','لو يجي عيد ميلادك تتوقع يجيك هدية؟','يبان عليك الحزن من " صوتك - ملامحك','وين تشوف نفسك بعد سنتين؟','وش يقولون لك لما تغني ؟','عندك حس فكاهي ولا نفسية؟','كيف تتصرف مع الشخص الفضولي ؟','كيف هي أحوال قلبك؟','حاجة تشوف نفسك مبدع فيةا ؟','متى حبيت؟','شيء كل م تذكرته تبتسم ...','العلاقه السريه دايماً تكون حلوه؟','صوت مغني م تحبه','لو يجي عيد ميلادك تتوقع يجيك هدية؟','اذا احد سألك عن شيء م تعرفه تقول م اعرف ولا تتفلسف ؟','مع او ضد : النوم افضل حل لـ مشاكل الحياة؟','مساحة فارغة (..............) اكتب اي شيء تبين','اغرب اسم مر عليك ؟','عمرك كلمت فويس احد غير جنسك؟','اذا غلطت وعرفت انك غلطان تحب تعترف ولا تجحد؟','لو عندك فلوس وش السيارة اللي بتشتريها؟','وش اغبى شيء سويته ؟','شيء من صغرك ماتغير فيك؟','وش نوع الأفلام اللي تحب تتابعه؟','وش نوع الأفلام اللي تحب تتابعه؟','تجامل احد على حساب مصلحتك ؟','تتقبل النصيحة من اي شخص؟','كلمه ماسكه معك الفترة هذي ؟','متى لازم تقول لا ؟','اكثر شيء تحس انه مات ف مجتمعنا؟','تؤمن ان في "حُب من أول نظرة" ولا لا ؟.','تؤمن ان في "حُب من أول نظرة" ولا لا ؟.','هل تعتقد أن هنالك من يراقبك بشغف؟','اشياء اذا سويتها لشخص تدل على انك تحبه كثير ؟','اشياء صعب تتقبلها بسرعه ؟','اقتباس لطيف؟','أكثر جملة أثرت بك في حياتك؟','عندك فوبيا من شيء ؟.','اكثر لونين تحبهم مع بعض؟','أجمل بيت شعر سمعته ...','سبق وراودك شعور أنك لم تعد تعرف نفسك؟','تتوقع فية احد حاقد عليك ويكرهك ؟','أجمل سنة ميلادية مرت عليك ؟','لو فزعت/ي لصديق/ه وقالك مالك دخل وش بتسوي/ين؟','وش تحس انك تحتاج الفترة هاذي ؟','يومك ضاع على؟','@منشن .. شخص تخاف منه اذا عصب ...','فيلم عالق في ذهنك لا تنساه مِن روعته؟','تختار أن تكون غبي أو قبيح؟','الفلوس او الحب ؟','أجمل بلد في قارة آسيا بنظرك؟','ما الذي يشغل بالك في الفترة الحالية؟','احقر الناس هو من ...','وين نلقى السعاده برايك؟','اشياء تفتخر انك م سويتها ؟','تزعلك الدنيا ويرضيك ؟','وش الحب بنظرك؟','افضل هديه ممكن تناسبك؟','كم في حسابك البنكي ؟','كلمة لشخص أسعدك رغم حزنك في يومٍ من الأيام ؟','عمرك انتقمت من أحد ؟!','ما السيء في هذه الحياة ؟','غنية عندك معاها ذكريات🎵🎻','/','أفضل صفة تحبه بنفسك؟','اكثر وقت تحب تنام فية ...','أطول مدة نمت فيةا كم ساعة؟','أصعب قرار ممكن تتخذه ؟','أفضل صفة تحبه بنفسك؟','اكثر وقت تحب تنام فية ...','أنت محبوب بين الناس؟ ولاكريه؟','إحساسك في هاللحظة؟','اخر شيء اكلته ؟','تشوف الغيره انانيه او حب؟','اذكر موقف ماتنساه بعمرك؟','اكثر مشاكلك بسبب ؟','اول ماتصحى من النوم مين تكلمه؟','آخر مرة ضحكت من كل قلبك؟','لو الجنسية حسب ملامحك وش بتكون جنسيتك؟','اكثر شيء يرفع ضغطك','اذكر موقف ماتنساه بعمرك؟','لو قالوا لك  تناول صنف واحد فقط من الطعام لمدة شهر .','كيف تشوف الجيل ذا؟','ردة فعلك لو مزح معك شخص م تعرفه ؟','احقر الناس هو من ...','تحب ابوك ولا امك','آخر فيلم مسلسل والتقييم🎥؟','أقبح القبحين في العلاقة: الغدر أو الإهمال🤷🏼؟','كلمة لأقرب شخص لقلبك🤍؟','حط@منشن لشخص وقوله "حركتك مالها داعي"😼!','اذا جاك خبر مفرح اول واحد تعلمه فية مين💃🏽؟','طبع يمكن يخليك تكره شخص حتى لو كنتتُحبه🙅🏻‍♀️؟','افضل ايام الاسبوع عندك🔖؟','يقولون ان الحياة دروس ، ماهو أقوى درس تعلمته من الحياة🏙؟','تاريخ لن تنساه📅؟','تحب الصيف والا الشتاء❄️☀️؟','شخص تحب تستفزه😈؟','شنو ينادونك وانت صغير (عيارتك)👼🏻؟','عقل يفهمك/ج ولا قلب يحبك/ج❤️؟','اول سفره لك وين رح تكون✈️؟','كم عدد اللي معطيةم بلوك👹؟','نوعية من الأشخاص تتجنبهم في حياتك❌؟','شاركنا صورة او فيديو من تصويرك؟📸','كم من عشره تعطي حظك📩؟','اكثر برنامج تواصل اجتماعي تحبه😎؟','من اي دوله انت🌍؟','اكثر دوله ودك تسافر لها🏞؟','مقولة "نكبر وننسى" هل تؤمن بصحتها🧓🏼؟','تعتقد فية أحد يراقبك👩🏼‍💻؟','لو بيدك تغير الزمن ، تقدمه ولا ترجعه🕰؟','مشروبك المفضل🍹؟','‏قم بلصق آخر اقتباس نسخته؟💭','كم وزنك/ج طولك/ج؟🌚','كم كان عمرك/ج قبل ٨ سنين😈؟','دوله ندمت انك سافرت لها😁؟','لو قالو لك ٣ أمنيات راح تتحقق عالسريع شنو تكون🧞‍♀️؟','‏- نسبة احتياجك للعزلة من 10📊؟','شخص تحبه حظرك بدون سبب واضح، ردة فعلك🧐؟','مبدأ في الحياة تعتمد عليه دائما🕯؟'}
bot.sendText(msg.chat_id,msg.id,arr[math.random(#arr)],"md", true)
end 
if text == "مصه" or text == "بوسه" or text == "مصها" or text == "بوسها" then
local texting = {"مووووووووواححح????","مممممححه 🥴😥","خدك/ج نضيف 😂","البوسه بالف حمبي 🌝💋","ممحمحمحمحح 😰😖","كل شويه ابوسك كافي 😏","ماابوسه والله هذا زاحف🦎","محح هاي لحاته صاكه??"}
if tonumber(msg.reply_to_message_id) == 0 then
bot.sendText(msg.chat_id,msg.id,"*- يجب عمل رد على رسالة شخص .*","md", true)
return false
end
bot.sendText(msg.chat_id,msg.reply_to_message_id,"*"..texting[math.random(#texting)].."*","md", true)
end
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:phme") then
if text == "صورتي" then
local photo = bot.getUserProfilePhotos(msg.sender.user_id)
if photo.total_count > 0 then
bot.sendPhoto(msg.chat_id, msg.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id," * حسابك يحتوي على ("..photo.total_count.." ) صورة*", "md")
else
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙لا توجد صورة في حسابك*',"md",true) 
end
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":link:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":link:add")
if text and text:match("^https://t.me/+(.*)$") then     
redis:set(bot_id..":"..msg.chat_id..":link",text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ الرابط الجديد بنجاح*","md", true)
else
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا الرابط خطأ*","md", true)
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":id:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":id:add")
redis:set(bot_id..":"..msg.chat_id..":id",text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ الايدي الجديد بنجاح*","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":we:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":we:add")
redis:set(bot_id..":"..msg.chat_id..":Welcome",text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم حفظ الترحيب الجديد بنجاح*","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":nameGr:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":nameGr:add")
if GetInfoBot(msg).Info == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙ليس لدي صلاحيات تغيير المعلومات*',"md",true)  
return false
end
bot.setChatTitle(msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الاسم بنجاح*","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":decGr:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":decGr:add")
if GetInfoBot(msg).Info == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙ليس لدي صلاحيات تغيير المعلومات*',"md",true)  
return false
end
bot.setChatDescription(msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الوصف بنجاح*","md", true)
end
if BasicConstructor(msg) then
if text == 'تغيير اسم المجموعة' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":nameGr:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بارسال الاسم الجديد الان*","md", true)
end
if text == 'تغيير الوصف' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":decGr:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بارسال الوصف الجديد الان*","md", true)
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add")
redis:set(bot_id..":"..msg.chat_id..":Law",text)
bot.sendText(msg.chat_id,msg.id,"*- تم حفظ القوانين بنجاح .*","md", true)
end
if Owner(msg) then
if text == 'تعين قوانين' or text == 'تعيين قوانين' or text == 'وضع قوانين' or text == 'اضف قوانين' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بأرسال قائمة القوانين الان*","md", true)
end
if text == 'مسح القوانين' or text == 'حذف القوانين' then
redis:del(bot_id..":"..msg.chat_id..":Law")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." الجديد بنجاح *","md", true)
end
if text == "تنظيف التعديل" or text == "مسح التعديل" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم البحث عن الرسائل المعدله*","md",true)
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.edit_date and Delmsg.edit_date ~= 0 then
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*  ⌔︙لم يتم العثور على رسائل معدله ضمن 250 رسالة السابقه*"
else
t = "*  ⌔︙تم حذف ( "..y.." ) من الرسائل المعدله *"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == "تنظيف الميديا" or text == "مسح الميديا" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙يتم البحث عن الميديا*","md",true)
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.content and Delmsg.content.luatele ~= "messageText" then
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*  ⌔︙لم يتم العثور على ميديا ضمن 250 رسالة السابقه*"
else
t = "*  ⌔︙تم حذف ( "..y.." ) من الميديا *"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'رفع الادامن' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙البوت لا يمتلك صلاحية*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local list_ = info_.members
y = 0
for k, v in pairs(list_) do
if info_.members[k].bot_info == nil then
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",v.member_id.user_id) 
else
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",v.member_id.user_id) 
y = y + 1
end
end
end
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم رفع  ('..y..') ادمن بالمجموعة*',"md",true)  
end
if text == 'تعين ترحيب' or text == 'تعيين ترحيب' or text == 'وضع ترحيب' or text == 'اضف ترحيب' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":we:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان الترحيب الجديد\n  ⌔︙يمكنك اضافة :*\n  ⌔︙`user` > *يوزر المستخدم*\n  ⌔︙`name` > *اسم المستخدم*","md", true)
end
if text == 'الترحيب' then
if redis:get(bot_id..":"..msg.chat_id..":Welcome") then
t = redis:get(bot_id..":"..msg.chat_id..":Welcome")
else 
t = "*  ⌔︙لم يتم وضع ترحيب*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
if text == 'مسح الترحيب' or text == 'حذف الترحيب' then
redis:del(bot_id..":"..msg.chat_id..":Welcome")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." الجديد بنجاح*","md", true)
end
if text == 'مسح الايدي' or text == 'حذف الايدي' then
redis:del(bot_id..":"..msg.chat_id..":id")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." الجديد بنجاح*","md", true)
end
if text == 'تعين الايدي' or text == 'تعيين الايدي' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":id:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙ارسل الان النص\n  ⌔︙يمكنك اضافة :*\n  ⌔︙`#username` > *اسم المستخدم*\n  ⌔︙`#msgs` > *عدد رسائل المستخدم*\n  ⌔︙`#photos` > *عدد صور المستخدم*\n  ⌔︙`#id` > *ايدي المستخدم*\n  ⌔︙`#auto` > *تفاعل المستخدم*\n  ⌔︙`#stast` > *موقع المستخدم* \n  ⌔︙`#edit` > *عدد التعديلات*\n  ⌔︙`#AddMem` > *عدد الجهات*\n  ⌔︙`#Description` > *تعليق الصورة*","md", true)
end
if text == "تغيير الايدي" or text == "تغير الايدي" then 
local List = {'◇︰𝘜𝘴𝘌𝘳 - #username \n◇︰𝘪𝘋 - #id\n◇︰𝘚𝘵𝘈𝘴𝘵 - #stast\n◇︰𝘈𝘶𝘛𝘰 - #cont \n◇︰𝘔𝘴𝘎𝘴 - #msgs','◇︰Msgs : #msgs .\n◇︰ID : #id .\n◇︰Stast : #stast .\n◇︰UserName : #username .','˛ َ𝖴ᥱ᥉ : #username  .\n˛ َ𝖲𝗍ُɑِ  : #stast   . \n˛ َ𝖨ժ : #id  .\n˛ َ𝖬⁪⁬⁮᥉𝗀ِ : #msgs   .','⚕ 𓆰 𝑾𝒆𝒍𝒄𝒐𝒎𝒆 ??𝒐 𝑮𝒓𝒐𝒖𝒑 ★\n- 🖤 | 𝑼𝑬𝑺 : #username ‌‌‏\n- 🖤 | 𝑺𝑻𝑨 : #stast \n- 🖤 | 𝑰𝑫 : #id ‌‌‏\n- 🖤 | 𝑴𝑺𝑮 : #msgs','◇︰𝖬𝗌𝗀𝗌 : #msgs  .\n◇︰𝖨𝖣 : #id  .\n◇︰𝖲𝗍𝖺𝗌𝗍 : #stast .\n◇︰𝖴𝗌𝖾𝗋??𝖺𝗆𝖾 : #username .','⌁ Use ⇨{#username} \n⌁ Msg⇨ {#msgs} \n⌁ Sta ⇨ {#stast} \n⌁ iD ⇨{#id} \n▿▿▿','゠𝚄𝚂𝙴𝚁 𖨈 #username 𖥲 .\n゠𝙼𝚂𝙶 𖨈 #msgs 𖥲 .\n゠𝚂𝚃𝙰 𖨈 #stast 𖥲 .\n゠𝙸𝙳 𖨈 #id 𖥲 .','▹ 𝙐SE?? 𖨄 #username  𖤾.\n▹ 𝙈𝙎𝙂 𖨄 #msgs  𖤾.\n▹ 𝙎𝙏?? 𖨄 #stast  𖤾.\n▹ 𝙄𝘿 𖨄 #id 𖤾.','➼ : 𝐼𝐷 𖠀 #id\n➼ : 𝑈𝑆𝐸𝑅 𖠀 #username\n➼ : 𝑀𝑆𝐺𝑆 𖠀 #msgs\n➼ : 𝑆𝑇𝐴S𝑇 𖠀 #stast\n➼ : 𝐸𝐷𝐼𝑇  𖠀 #edit\n','┌ 𝐔𝐒𝐄𝐑 𖤱 #username 𖦴 .\n├ 𝐌𝐒?? 𖤱 #msgs 𖦴 .\n├ 𝐒𝐓𝐀 𖤱 #stast 𖦴 .\n└ 𝐈𝐃 𖤱 #id 𖦴 .','୫ 𝙐𝙎𝙀𝙍𝙉𝘼𝙈𝙀 ➤ #username\n୫ 𝙈𝙀𝙎𝙎𝘼𝙂𝙀𝙎 ➤ #msgs\n୫ 𝙎𝙏𝘼𝙏𝙎 ➤ #stast\n୫ 𝙄𝘿 ➤ #id','☆-𝐮𝐬𝐞𝐫 : #username 𖣬  \n☆-𝐦𝐬𝐠  : #msgs 𖣬 \n☆-𝐬𝐭𝐚 : #stast 𖣬 \n☆-𝐢𝐝  : #id 𖣬','𝐘𝐨𝐮𝐫 𝐈𝐃 ☤🇮🇶- #id \n𝐔𝐬𝐞𝐫𝐍𝐚☤🇮🇶- #username \n𝐒𝐭𝐚𝐬𝐓 ☤🇮🇶- #stast \n𝐌𝐬𝐠𝐒☤🇮🇶 - #msgs','.𖣂 𝙪𝙨𝙚𝙧𝙣𝙖𝙢𝙚 , #username  \n.𖣂 𝙨𝙩𝙖𝙨𝙩 , #stast\n.𖣂 𝙡𝘿 , #id  \n.𖣂 𝙂𝙖𝙢𝙨 , #game  \n.𖣂 𝙢𝙨𝙂𝙨 , #msgs'}
local Text_Rand = List[math.random(#List)]
redis:set(bot_id..":"..msg.chat_id..":id",Text_Rand)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغير رسالة الايدي*","md",true)  
end
if text == 'مسح الرابط' or text == 'حذف الرابط' then
redis:del(bot_id..":"..msg.chat_id..":link")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." الجديد بنجاح*","md", true)
end
if text == 'تعين الرابط' or text == 'تعيين الرابط' or text == 'وضع رابط' or text == 'تغيير الرابط' or text == 'تغير الرابط' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":link:add",true)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم بارسال الرابط الجديد الان*","md", true)
end
if text == 'فحص البوت' then 
local StatusMember = bot.getChatMember(msg.chat_id,bot_id).status.luatele
if (StatusMember ~= "chatMemberStatusAdministrator") then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت عضو في المجموعة*',"md",true) 
return false
end
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = '✔️' else change_info = '❌'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✔️' else delete_messages = '❌'
end
if GetMemberStatus.can_invite_users then
invite_users = '✔️' else invite_users = '❌'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✔️' else pin_messages = '❌'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✔️' else restrict_members = '❌'
end
if GetMemberStatus.can_promote_members then
promote = '✔️' else promote = '❌'
end
PermissionsUser = '*\n  ⌔︙صلاحيات البوت في المجموعة :\nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ '..'\n  ⌔︙تغيير المعلومات : '..change_info..'\n  ⌔︙تثبيت الرسائل : '..pin_messages..'\n  ⌔︙اضافة مستخدمين : '..invite_users..'\n  ⌔︙مسح الرسائل : '..delete_messages..'\n  ⌔︙حظر المستخدمين : '..restrict_members..'\n  ⌔︙اضافة المشرفين : '..promote..'\n\n*'
bot.sendText(msg.chat_id,msg.id,PermissionsUser,"md",true) 
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
if text == ("امسح") and BasicConstructor(msg) then  
local list = redis:smembers(bot_id..":"..msg.chat_id..":mediaAude:ids")
for k,v in pairs(list) do
local Message = v
if Message then
t = "  ⌔︙تم مسح "..k.." من الوسائط الموجوده"
bot.deleteMessages(msg.chat_id,{[1]= Message})
redis:del(bot_id..":"..msg.chat_id..":mediaAude:ids")
end
end
if #list == 0 then
t = "  ⌔︙لا يوجد ميديا في المجموعة"
end
Text = Reply_Status(msg.sender.user_id,"*"..t.."*").by
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text and text:match('^تنظيف (%d+)$') then
local NumMessage = text:match('^تنظيف (%d+)$')
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙البوت ليس ادمن في المجموعة*","md",true)  
return false
end
if GetInfoBot(msg).Delmsg == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙البوت لا يمتلك صلاحية حذف الرسائل*","md",true)  
return false
end
if tonumber(NumMessage) > 1000 then
bot.sendText(msg.chat_id,msg.id,'* لا تستطيع حذف اكثر من 1000 رسالة*',"md",true)  
return false
end
local Message = msg.id
for i=1,tonumber(NumMessage) do
bot.deleteMessages(msg.chat_id,{[1]= Message})
Message = Message - 1048576
end
bot.sendText(msg.chat_id, msg.id,"*  ⌔︙تم تنظيف ( "..NumMessage.." ) رسالة *", 'md')
end
end
if text == 'مسح الرتب' or text == 'حذف الرتب' then
redis:del(bot_id.."Reply:developer"..msg.chat_id)
redis:del(bot_id..":Reply:mem"..msg.chat_id)
redis:del(bot_id..":Reply:Vips"..msg.chat_id)
redis:del(bot_id..":Reply:Administrator"..msg.chat_id)
redis:del(bot_id..":Reply:BasicConstructor"..msg.chat_id)
redis:del(bot_id..":Reply:Constructor"..msg.chat_id)
redis:del(bot_id..":Reply:Owner"..msg.chat_id)
redis:del(bot_id..":Reply:Creator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*","md", true)
end
if text and text:match("^تغير رد المطور (.*)$") then
local Teext = text:match("^تغير رد المطور (.*)$") 
redis:set(bot_id.."Reply:developer"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المالك (.*)$") then
local Teext = text:match("^تغير رد المالك (.*)$") 
redis:set(bot_id..":Reply:Creator"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المنشئ الاساسي (.*)$") then
local Teext = text:match("^تغير رد المنشئ الاساسي (.*)$") 
redis:set(bot_id..":Reply:BasicConstructor"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المنشئ (.*)$") then
local Teext = text:match("^تغير رد المنشئ (.*)$") 
redis:set(bot_id..":Reply:Constructor"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المدير (.*)$") then
local Teext = text:match("^تغير رد المدير (.*)$") 
redis:set(bot_id..":Reply:Owner"..msg.chat_id,Teext) 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد الادمن (.*)$") then
local Teext = text:match("^تغير رد الادمن (.*)$") 
redis:set(bot_id..":Reply:Administrator"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المميز (.*)$") then
local Teext = text:match("^تغير رد المميز (.*)$") 
redis:set(bot_id..":Reply:Vips"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد العضو (.*)$") then
local Teext = text:match("^تغير رد العضو (.*)$") 
redis:set(bot_id..":Reply:mem"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تغيير الرد بنجاح الى : *"..Teext.. "", 'md')
elseif text == 'حذف رد المطور' then
redis:del(bot_id..":Reply:developer"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد المالك' then
redis:del(bot_id..":Reply:Creator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد المنشئ الاساسي' then
redis:del(bot_id..":Reply:BasicConstructor"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد المنشئ' then
redis:del(bot_id..":Reply:Constructor"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد المدير' then
redis:del(bot_id..":Reply:Owner"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد الادمن' then
redis:del(bot_id..":Reply:Administrator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد المميز' then
redis:del(bot_id..":Reply:Vips"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
elseif text == 'حذف رد العضو' then
redis:del(bot_id..":Reply:mem"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*", 'md')
end
if text == 'الغاء تثبيت الكل' or text == 'الغاء التثبيت' then
if GetInfoBot(msg).PinMsg == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙ليس لدي صلاحية تثبيت رسائل*',"md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم الغاء تثبيت جميع الرسائل المثبته*","md",true)
bot.unpinAllChatMessages(msg.chat_id) 
end
end
if BasicConstructor(msg) then
----------------------------------------------------------------------------------------------------
if text == "قائمة المنع" or text == "الممنوعات" or text == "قائمة المنع" then
local Photo =redis:scard(bot_id.."mn:content:Photo"..msg.chat_id) 
local Animation =redis:scard(bot_id.."mn:content:Animation"..msg.chat_id)  
local Sticker =redis:scard(bot_id.."mn:content:Sticker"..msg.chat_id)  
local Text =redis:scard(bot_id.."mn:content:Text"..msg.chat_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = 'الصور الممنوعه', data="mn_"..msg.sender.user_id.."_ph"},{text = 'الكلمات الممنوعه', data="mn_"..msg.sender.user_id.."_tx"}},
{{text = 'المتحركات الممنوعه', data="mn_"..msg.sender.user_id.."_gi"},{text = 'الملصقات الممنوعه',data="mn_"..msg.sender.user_id.."_st"}},
{{text = 'تحديث',data="mn_"..msg.sender.user_id.."_up"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*   ⌔︙تحوي قائمة المنع على\n  ⌔︙الصور ( "..Photo.." )\n  ⌔︙الكلمات ( "..Text.." )\n  ⌔︙الملصقات ( "..Sticker.." )\n  ⌔︙المتحركات ( "..Animation.." ) .\n  ⌔︙اضغط على القائمة المراد حذفها*","md",true, false, false, false, reply_markup)
return false
end
if text == "مسح قائمة المنع" or text == "مسح الممنوعات" then
bot.sendText(msg.chat_id,msg.id,"*- تم "..text.." بنجاح *","md",true)  
redis:del(bot_id.."mn:content:Text"..msg.chat_id) 
redis:del(bot_id.."mn:content:Sticker"..msg.chat_id) 
redis:del(bot_id.."mn:content:Animation"..msg.chat_id) 
redis:del(bot_id.."mn:content:Photo"..msg.chat_id) 
end
if text == "منع" and msg.reply_to_message_id == 0 then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙قم الان بارسال ( نص او الميديا ) لمنعه من المجموعة*","md",true)  
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set",true)
end
if text == "منع" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Remsg.content.text then   
if redis:sismember(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الكلمه سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text)  
ty = "الرسالة"
elseif Remsg.content.sticker then   
if redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id,Remsg.content.sticker.sticker.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الملصق سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Sticker"..msg.chat_id, Remsg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif Remsg.content.animation then
if redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id,Remsg.content.animation.animation.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع المتحركة سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Animation"..msg.chat_id, Remsg.content.animation.animation.remote.unique_id)  
ty = "المتحركة"
elseif Remsg.content.photo then
if redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع الصورة سابقا*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصورة"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم منع "..ty.." بنجاح*","md",true)  
end
if text == "الغاء منع" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Remsg.content.text then   
redis:srem(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text)  
ty = "الرسالة"
elseif Remsg.content.sticker then   
redis:srem(bot_id.."mn:content:Sticker"..msg.chat_id, Remsg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif Remsg.content.animation then
redis:srem(bot_id.."mn:content:Animation"..msg.chat_id, Remsg.content.animation.animation.remote.unique_id)  
ty = "المتحركة"
elseif Remsg.content.photo then
redis:srem(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصورة"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم الغاء منع "..ty.." بنجاح*","md",true)  
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if msg and msg.content.text and msg.content.text.entities[1] and (msg.content.text.entities[1].luatele == "textEntity") and (msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName") then
if text and text:match('^كشف (.*)$') or text and text:match('^ايدي (.*)$') then
local UserName = text:match('^كشف (.*)$') or text:match('^ايدي (.*)$')
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
sm = bot.getChatMember(msg.chat_id,usetid)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙الايدي : *( `"..(usetid).."` *)*\n*  ⌔︙الرتبه : *( `"..(Get_Rank(usetid,msg.chat_id)).."` *)*\n*  ⌔︙الموقع : *( `"..(gstatus).."` *)*\n*  ⌔︙عدد الرسائل : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..usetid..":message") or 1).."` *)*" ,"md",true)  
end
end
if Administrator(msg)  then
if text and text:match('^طرد (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الطرد معطل بواسطة المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(usetid,msg.chat_id) then
t = "*  ⌔︙لا يمكنك طرد "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*  ⌔︙تم طرده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,usetid,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
end
end
if text and text:match("^تنزيل (.*) (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
local infotxt = {text:match("^تنزيل (.*) (.*)")}
TextMsg = infotxt[1]
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*  ⌔︙لا يمتلك رتبه بالفعل*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*  ⌔︙تم تنزيله بنجاح*").i,"md",true)  
return false
end
end
end
if text and text:match("^رفع (.*) (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
local infotxt = {text:match("^رفع (.*) (.*)")}
TextMsg = infotxt[1]
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:Up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الرفع معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*  ⌔︙تم رفعه سابقا*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*  ⌔︙تم رفعه بنجاح*").i,"md",true)  
return false
end
end
end
if text and text:match("^تنزيل الكل (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if Get_Rank(usetid,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",usetid)
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,usetid).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*  ⌔︙"..tt.."*").yu,"md",true)  
return false
end
end
if text and text:match('^الغاء كتم (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء كتمك بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":silent",usetid)
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).yu,"md",true)  
end
end
if text and text:match('^كتم (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الكتم معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if not Norank(usetid,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
end
end
if text and text:match('^الغاء حظر (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء حظره بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",usetid)
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,usetid,'restricted',{1,1,1,1,1,1,1,1,1})
end
end
if text and text:match('^حظر (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الحظر معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(usetid,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظره بنجاح*"
bot.setChatMemberStatus(msg.chat_id,usetid,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
end
end
end
end
----------------------------------------------------------------------------------------------------
if Administrator(msg)  then
----------------------------------------------------------------------------------------------------
if text and text:match('^رفع القيود @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^رفع القيود @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙تم رفع القيود عنه*").i,"md",true)  
return false
end
if text and text:match('^رفع القيود (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^رفع القيود (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserName)
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":silent",UserName)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserName)
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙تم رفع القيود عنه*").i,"md",true)  
return false
end
if text == "رفع القيود" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙تم رفع القيود عنه*").i,"md",true)  
return false
end
if text and text:match('^كشف القيود @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كشف القيود @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if redis:sismember(bot_id..":bot:Ban", UserId_Info.id) then
Banal = "  ⌔︙الحظر العام : محظور بالفعل"
else
Banal = "  ⌔︙الحظر العام : غير محظور"
end
if redis:sismember(bot_id..":bot:silent", UserId_Info.id) then
silental  = "  ⌔︙كتم العام : مكتوم بالفعل"
else
silental = "  ⌔︙كتم العام : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserId_Info.id) then
rict = "  ⌔︙التقييد : مقيد بالفعل"
else
rict = "  ⌔︙التقييد : غير مقيد"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserId_Info.id) then
sent = "\n  ⌔︙الكتم : مكتوم بالفعل"
else
sent = "\n  ⌔︙الكتم : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserId_Info.id) then
an = "\n  ⌔︙الحظر : محظور بالفعل"
else
an = "\n  ⌔︙الحظر : غير محظور"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id," *ٴ─━─━─━─×─━─━─━─\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").i,"md",true)  
return false
end
if text and text:match('^كشف القيود (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كشف القيود (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if redis:sismember(bot_id..":bot:Ban", UserName) then
Banal = "  ⌔︙الحظر العام : محظور بالفعل"
else
Banal = "  ⌔︙الحظر العام : غير محظور"
end
if redis:sismember(bot_id..":bot:silent", UserName) then
silental  = "  ⌔︙كتم العام : مكتوم بالفعل"
else
silental = "  ⌔︙كتم العام : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserName) then
rict = "  ⌔︙التقييد : مقيد بالفعل"
else
rict = "  ⌔︙التقييد : غير مقيد"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserName) then
sent = "\n  ⌔︙الكتم : مكتوم بالفعل"
else
sent = "\n  ⌔︙الكتم : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserName) then
an = "\n  ⌔︙الحظر : محظور بالفعل"
else
an = "\n  ⌔︙الحظر : غير محظور"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*ٴ─━─━─━─×─━─━─━─\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").i,"md",true)  
return false
end
if text == "كشف القيود" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if redis:sismember(bot_id..":bot:Ban", Remsg.sender.user_id) then
Banal = "  ⌔︙الحظر العام : محظور بالفعل"
else
Banal = "  ⌔︙الحظر العام : غير محظور"
end
if redis:sismember(bot_id..":bot:silent", Remsg.sender.user_id) then
silental  = "  ⌔︙كتم العام : مكتوم بالفعل"
else
silental = "  ⌔︙كتم العام : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", Remsg.sender.user_id) then
rict = "  ⌔︙التقييد : مقيد بالفعل"
else
rict = "  ⌔︙التقييد : غير مقيد"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", Remsg.sender.user_id) then
sent = "\n  ⌔︙الكتم : مكتوم بالفعل"
else
sent = "\n  ⌔︙الكتم : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", Remsg.sender.user_id) then
an = "\n  ⌔︙الحظر : محظور بالفعل"
else
an = "\n  ⌔︙الحظر : غير محظور"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*ٴ─━─━─━─×─━─━─━─\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").i,"md",true)  
return false
end
if text and text:match('^تقييد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^تقييد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية تقييد الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك تقييد "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم تقييده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^تقييد @(%S+)$') then
local UserName = text:match('^تقييد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية تقييد الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك تقييد "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم تقييده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "تقييد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية تقييد الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك تقييد "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم تقييده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء تقييد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء تقييد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء تقييده بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء تقييد @(%S+)$') then
local UserName = text:match('^الغاء تقييد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء تقييده بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء تقييد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء تقييده بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^طرد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^طرد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الطرد معطل بواسطة المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك طرد "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم طرده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^طرد @(%S+)$') then
local UserName = text:match('^طرد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*- اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الطرد معطل بواسطة المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية طرد الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك طرد "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم طرده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "طرد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الطرد معطل بواسطة المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك طرد "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم طرده بنجاح*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^حظر (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^حظر (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الحظر معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظره بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^حظر @(%S+)$') then
local UserName = text:match('^حظر @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الحظر معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظره بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "حظر" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الحظر معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظره بنجاح*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء حظر (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء حظر (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء حظره بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء حظر @(%S+)$') then
local UserName = text:match('^الغاء حظر @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء حظره بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء حظر" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء حظره بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^كتم (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كتم (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الكتم معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if not Norank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^كتم @(%S+)$') then
local UserName = text:match('^كتم @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الكتم معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "كتم" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الكتم معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء كتم (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء كتم (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء كتمه بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^الغاء كتم @(%S+)$') then
local UserName = text:match('^الغاء كتم @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء كتمه بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
end
if text == "الغاء كتم" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء كتمه بنجاح*"
redis:srem(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).i,"md",true)  
end
if text == 'المكتومين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المقيدين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":restrict") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المحظورين' then
t = '\n*  ⌔︙قائمة '..text..'  \nٴ─━─━─━─×─━─━─━─ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المحظورين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":"..msg.chat_id..":Ban") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المكتومين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":silent") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المقيدين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":restrict") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":"..msg.chat_id..":restrict") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
end
if programmer(msg)  then
if text and text:match('^كتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not Isrank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":bot:silent",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^كتم عام @(%S+)$') then
local UserName = text:match('^كتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Isrank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":bot:silent",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "كتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not Isrank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك كتم "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم كتمه بنجاح*"
redis:sadd(bot_id..":bot:silent",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء كتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء كتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء كتم العام بنجاح*"
redis:srem(bot_id..":bot:silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^الغاء كتم عام @(%S+)$') then
local UserName = text:match('^الغاء كتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء كتم العام بنجاح*"
redis:srem(bot_id..":bot:silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
end
if text == "الغاء كتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء كتم العام بنجاح*"
redis:srem(bot_id..":bot:silent",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).i,"md",true)  
end
if text == 'المكتومين عام' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المكتومين عام' then
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":bot:silent") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text and text:match('^حظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^حظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر عام الاعضاء* ',"md",true)  
return false
end
if not Isrank(UserName,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر عام "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظر العام بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
redis:sadd(bot_id..":bot:Ban",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^حظر عام @(%S+)$') then
local UserName = text:match('^حظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر عام الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Isrank(UserId_Info.id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر عام "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظر العام بنجاح*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
redis:sadd(bot_id..":bot:Ban",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "حظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙البوت لا يمتلك صلاحية حظر عام الاعضاء* ',"md",true)  
return false
end
if not Isrank(Remsg.sender.user_id,msg.chat_id) then
t = "*  ⌔︙لا يمكنك حظر عام "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*  ⌔︙تم حظر العام بنجاح*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
redis:sadd(bot_id..":bot:Ban",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء حظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء حظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*  ⌔︙تم الغاء حظر العام بنجاح*"
redis:srem(bot_id..":bot:Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء حظر عام @(%S+)$') then
local UserName = text:match('^الغاء حظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء حظر العام بنجاح*"
redis:srem(bot_id..":bot:Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء حظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*  ⌔︙تم الغاء حظر العام بنجاح*"
redis:srem(bot_id..":bot:Ban",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == 'المحظورين عام' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المحظورين عام' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":bot:Ban") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
end
----------------------------------------------------------------------------------------------------
if not redis:get(bot_id..":"..msg.chat_id..":settings:all") then
if text == '@all' and BasicConstructor(msg) then
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم عمل تاك في المجموعة قبل قليل انتظر من فضلك*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',300,true)
x = 0
tags = 0
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا يوجد عدد كافي من الاعضاء*","md",true) 
end
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
bot.sendText(msg.chat_id,0,Text,"md",true)  
end
end
end
if text and text:match("^@all (.*)$") and BasicConstructor(msg) then
if text:match("^@all (.*)$") ~= nil and text:match("^@all (.*)$") ~= "" then
TextMsg = text:match("^@all (.*)$")
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم عمل تاك في المجموعة قبل قليل انتظر من فضلك*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',300,true)
x = 0
tags = 0
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙لا يوجد عدد كافي من الاعضاء*","md",true) 
end
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
TextMsg = TextMsg
TextMsg = TextMsg:gsub('"',"")
TextMsg = TextMsg:gsub('"',"")
TextMsg = TextMsg:gsub("`","")
TextMsg = TextMsg:gsub("*","") 
TextMsg = TextMsg:gsub("_","")
TextMsg = TextMsg:gsub("]","")
TextMsg = TextMsg:gsub("[[]","")
bot.sendText(msg.chat_id,0,TextMsg.."\nٴ─━─━─━─×─━─━─━─ \n"..Text,"md",true)  
end
end
end
end
end
--
if msg and msg.content then
if text == 'تنزيل جميع الرتب' and Creator(msg) then   
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم "..text.." بنجاح*","md", true)
end
if msg.content.luatele == "messageSticker" or msg.content.luatele == "messageContact" or msg.content.luatele == "messageVideoNote" or msg.content.luatele == "messageDocument" or msg.content.luatele == "messageVideo" or msg.content.luatele == "messageAnimation" or msg.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..msg.chat_id..":mediaAude:ids",msg.id)  
end
if redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
local gmedia = redis:scard(bot_id..":"..msg.chat_id..":mediaAude:ids")  
if gmedia >= tonumber(redis:get(bot_id..":mediaAude:utdl"..msg.chat_id) or 200) then
local liste = redis:smembers(bot_id..":"..msg.chat_id..":mediaAude:ids")
for k,v in pairs(liste) do
local Mesge = v
if Mesge then
t = "*  ⌔︙تم مسح "..k.." من الوسائط تلقائيا\n  ⌔︙يمكنك تعطيل الميزه بستخدام الامر* ( `تعطيل المسح التلقائي` )"
bot.deleteMessages(msg.chat_id,{[1]= Mesge})
end
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)
redis:del(bot_id..":"..msg.chat_id..":mediaAude:ids")
end
end
end
if text == 'تفعيل المسح التلقائي' and BasicConstructor(msg) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:set(bot_id..":"..msg.chat_id..":settings:mediaAude",true)  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل المسح التلقائي' and BasicConstructor(msg) then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:mediaAude")  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل all' and Creator(msg) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:all") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:all")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل all' and Creator(msg) then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:all") then
redis:set(bot_id..":"..msg.chat_id..":settings:all",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if BasicConstructor(msg) then
if text == 'تفعيل الرفع' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:up")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الرفع' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:up") then
redis:set(bot_id..":"..msg.chat_id..":settings:up",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الكتم' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:ktm")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الكتم' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
redis:set(bot_id..":"..msg.chat_id..":settings:ktm",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الحظر' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:bn")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الحظر' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
redis:set(bot_id..":"..msg.chat_id..":settings:bn",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الطرد' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:kik")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الطرد' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
redis:set(bot_id..":"..msg.chat_id..":settings:kik",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
end
--
if Owner(msg) then
if text and text:match("^وضع عدد المسح (.*)$") then
local Teext = text:match("^وضع عدد المسح (.*)$") 
if Teext and Teext:match('%d+') then
t = "*  ⌔︙تم تعيين  ( "..Teext.." ) كعدد للحذف التلقائي*"
redis:set(bot_id..":mediaAude:utdl"..msg.chat_id,Teext)
else
t = "  ⌔︙عذرا يجب كتابه ( وضع عدد المسح + رقم )"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)
end
if text == ("عدد الميديا") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙عدد الميديا هو :  "..redis:scard(bot_id..":"..msg.chat_id..":mediaAude:ids").."*").yu,"md",true)
end
--
if text == 'تفعيل اطردني' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:kickme")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل اطردني' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
redis:set(bot_id..":"..msg.chat_id..":settings:kickme",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل المميزات' then   
if redis:get(bot_id..":"..msg.chat_id..":Features") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":Features")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل المميزات' then  
if not redis:get(bot_id..":"..msg.chat_id..":Features") then
redis:set(bot_id..":"..msg.chat_id..":Features",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الالعاب' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:game") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:game")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الالعاب' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:game") then
redis:set(bot_id..":"..msg.chat_id..":settings:game",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل صورتي' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:phme") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:phme")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل صورتي' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:phme") then
redis:set(bot_id..":"..msg.chat_id..":settings:phme",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل البايو' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:GetBio")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل البايو' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
redis:set(bot_id..":"..msg.chat_id..":settings:GetBio",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الرابط' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:link") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:link")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الرابط' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:link") then
redis:set(bot_id..":"..msg.chat_id..":settings:link",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الترحيب' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:Welcome")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الترحيب' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
redis:set(bot_id..":"..msg.chat_id..":settings:Welcome",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل التنظيف' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:delmsg")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل التنظيف' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
redis:set(bot_id..":"..msg.chat_id..":settings:delmsg",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الايدي' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:id") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:id")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الايدي' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:id") then
redis:set(bot_id..":"..msg.chat_id..":settings:id",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الايدي بالصورة' and BasicConstructor(msg) then     
if redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:id:ph")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الايدي بالصورة' and BasicConstructor(msg) then    
if not redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
redis:set(bot_id..":"..msg.chat_id..":settings:id:ph",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الردود' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:Reply")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الردود' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
redis:set(bot_id..":"..msg.chat_id..":settings:Reply",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل منو ضافني' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:addme") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:addme")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل منو ضافني' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:addme") then
redis:set(bot_id..":"..msg.chat_id..":settings:addme",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الالعاب الاحترافية' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:gameVip")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الالعاب الاحترافية' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
redis:set(bot_id..":"..msg.chat_id..":settings:gameVip",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل اوامر التسلية' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:entertainment")  
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل اوامر التسلية' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
redis:set(bot_id..":"..msg.chat_id..":settings:entertainment",true)  
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if text and text:match('^تنزيل الكل (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^تنزيل الكل (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if Get_Rank(UserName,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",UserName)
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,UserName).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙"..tt.."*").yu,"md",true)  
return false
end
if text and text:match('^تنزيل الكل @(%S+)$') then
local UserName = text:match('^تنزيل الكل @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if Get_Rank(UserId_Info.id,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",UserId_Info.id)
redis:srem(bot_id..":Status:developer",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,UserId_Info.id).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙"..tt.."*").yu,"md",true)  
return false
end
if text == "تنزيل الكل" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if Get_Rank(Remsg.sender.user_id,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",Remsg.sender.user_id)
redis:srem(bot_id..":Status:developer",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,Remsg.sender.user_id).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙"..tt.."*").yu,"md",true)  
return false
end
if text and text:match('^رفع (.*) (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^رفع (.*) (%d+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الرفع معطل بواسطة المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙تم رفعه سابقا*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙تم رفعه بنجاح*").i,"md",true)  
return false
end
end
if text and text:match('^رفع (.*) @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^رفع (.*) @(%S+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الرفع معطل بواسطة المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,UserId_Info.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙تم رفعه سابقا*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙تم رفعه بنجاح*").i,"md",true)  
return false
end
end
if text and text:match("^رفع (.*)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local TextMsg = text:match("^رفع (.*)$")
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙الرفع معطل بواسطة المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙تم رفعه سابقا*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙تم رفعه بنجاح*").i,"md",true)  
return false
end
end
if text and text:match('^تنزيل (.*) (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^تنزيل (.*) (%d+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙لا يمتلك رتبه بالفعل*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*  ⌔︙تم تنزيله بنجاح*").i,"md",true)  
return false
end
end
if text and text:match('^تنزيل (.*) @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^تنزيل (.*) @(%S+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙اليوزر لقناة او مجموعة تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserId_Info.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙لا يمتلك رتبه بالفعل*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*  ⌔︙تم تنزيله بنجاح*").i,"md",true)  
return false
end
end
if text and text:match("^تنزيل (.*)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local TextMsg = text:match("^تنزيل (.*)$")
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*  ⌔︙عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙لا يمتلك رتبه بالفعل*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*  ⌔︙تم تنزيله بنجاح*").i,"md",true)  
return false
end
end
----------------------------------------------------------------------------------------------------
if Administrator(msg) then
if text == 'الثانويين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المطورين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المالكين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد المالكين*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المنشئين الاساسيين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المنشئين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المدراء' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'الادامن' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المميزين' then
t = '\n*  ⌔︙قائمة '..text..'  \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.."   ⌔︙*[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
----------------------------------------------------------------------------------------------------
end
if text == 'مسح الثانويين' and devB(msg.sender.user_id) then
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:programmer") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المطورين' and programmer(msg) then
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:developer") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المالكين' and developer(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Creator") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المنشئين الاساسيين' and Creator(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المنشئين' and BasicConstructor(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المدراء' and Constructor(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Owner") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح الادامن' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
if text == 'مسح المميزين' and Administrator(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم حذف "..text:gsub('مسح',"").." سابقا*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Vips") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙تم "..text.." بنجاح*").yu,"md",true)  
end
----------------------------------------------------------------------------------------------------
if text and not redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
if text and redis:sismember(bot_id..'List:array'..msg.chat_id,text) then
local list = redis:smembers(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"["..list[math.random(#list)].."]","md",true)  
end  
if not redis:sismember(bot_id..'Spam:Group'..msg.sender.user_id,text) then
local Text = redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)
local VoiceNote = redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text) 
local photo = redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
local document = redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
local audio = redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
local Video = redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
local VoiceNotecaption = redis:get(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text) or ""
local photocaption = redis:get(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text) or ""
local documentcaption = redis:get(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text) or ""
local audiocaption = redis:get(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text) or ""
local Videocaption = redis:get(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text) or ""
if Text  then
local UserInfo = bot.getUser(msg.sender.user_id)
local countMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
local totlmsg = Total_message(countMsg) 
local getst = Get_Rank(msg.sender.user_id,msg.chat_id)
local countedit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0
local Text = Text:gsub('#username',(UserInfo.username or 'لا يوجد')):gsub('#name',UserInfo.first_name):gsub('#id',msg.sender.user_id):gsub('#edit',countedit):gsub('#msgs',countMsg):gsub('#stast',getst)
bot.sendText(msg.chat_id,msg.id,"["..Text.."]","md",true)  
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
if photo  then
bot.sendPhoto(msg.chat_id, msg.id, photo,photocaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if VoiceNote then
bot.sendVoiceNote(msg.chat_id, msg.id, VoiceNote,"["..VoiceNotecaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
if document  then
bot.sendDocument(msg.chat_id, msg.id, document,"["..documentcaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if audio  then
bot.sendAudio(msg.chat_id, msg.id, audio,"["..audiocaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
if Video then
bot.sendVideo(msg.chat_id, msg.id, Video,"["..Videocaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
end 
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
if msg.content.text then
if msg.content.text.text == "غنيلي" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVoice?chat_id="..msg.chat_id.."&voice=https://t.me/Teamsulta/"..math.random(2,552).."&caption="..URL.escape(" ⌔︙ تم اختيار الاغنية لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "فيديو" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVideo?chat_id="..msg.chat_id.."&video=https://t.me/FFF3KK/"..math.random(2,80).."&caption="..URL.escape(" ⌔︙ تم ختيار الفيديو لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "متحركة" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendAnimation?chat_id="..msg.chat_id.."&animation=https://t.me/FFF4KK/"..math.random(2,300).."&caption="..URL.escape(" ⌔︙ تم اختيار المتحركة لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "فلم" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVideo?chat_id="..msg.chat_id.."&video=https://t.me/RRRRRTQ/"..math.random(2,86).."&caption="..URL.escape(" ⌔︙ تم اختيار الفلم لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "رمزية" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendPhoto?chat_id="..msg.chat_id.."&photo=https://t.me/FFF6KK/"..math.random(2,135).."&caption="..URL.escape(" ⌔︙ تم اختيار الرمزية لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "انمي" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendPhoto?chat_id="..msg.chat_id.."&photo=https://t.me/AnimeDavid/"..math.random(2,135).."&caption="..URL.escape(" ⌔︙ تم اختيار انمي لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "شعر" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVideo?chat_id="..msg.chat_id.."&video=https://t.me/shaarshahum/"..math.random(2,86).."&caption="..URL.escape(" ⌔︙ تم اختيار الشعر لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "راب" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*  ⌔︙تم تعطيل المميزات بواسطة المدراء*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆 ', url="t.me/xXStrem"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendmessage?chat_id="..msg.chat_id.."&message=https://t.me/EKKKK9/"..math.random(2,86).."&caption="..URL.escape(" ⌔︙ تم اختيار راب لك").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end

if data and data.luatele and data.luatele == "updateNewInlineQuery" then
local Text = data.query 
if Text == '' then
local input_message_content = {message_text = " • اهلا بك عزيزي\n • لارسال الهمسه اكتب يوزر البوت + الهمسه + يوزر العضو\n • مثال @H6CBoT هلا @F_T_Y"} 
local resuult = {{
type = 'article',
id = math.random(1,64),
title = 'اضغط هنا لمعرفه كيفيه ارسال الهمسه',
input_message_content = input_message_content,
reply_markup = {
inline_keyboard ={
{{text ="❲ Developer AhMeD .  ❳", url= "https://t.me/F_T_Y"}},
}
},
},
}
https.request("https://api.telegram.org/bot"..Token..'/answerInlineQuery?inline_query_id='..data.id..'&switch_pm_text=اضغط لارسال الهمسه&switch_pm_parameter=start&results='..JSON.encode(resuult))
end
if Text and Text:match("(.*)@(.*)") then
local hm = {string.match(Text,"(.*)@(.*)")}
local user = hm[2]
local hms = hm[1]
UserId_Info = LuaTele.searchPublicChat(user)
local idd = UserId_Info.id
local key = math.random(1,999999)
redis:set(idd..key.."hms",hms)
local us = LuaTele.getUser(idd)
local name = us.first_name
local input_message_content = {message_text = "- الهمسة إلى  ["..name.."](tg://user?id="..idd..")  ", parse_mode = 'Markdown'} 
local resuult = {{
type = 'article',
id = math.random(1,64),
title = 'هذه همسه سريه الى '..name..'',
input_message_content = input_message_content,
reply_markup = {
inline_keyboard ={
{{text ="فتح الهمسه  ", callback_data = idd.."hmsaa"..data.sender_user_id.."/"..key}},
}
},
},
}
https.request("https://api.telegram.org/bot"..Token..'/answerInlineQuery?inline_query_id='..data.id..'&switch_pm_text=اضغط لارسال الهمسه&switch_pm_parameter=start&results='..JSON.encode(resuult))
end
end
if data and data.luatele and data.luatele == "updateNewInlineCallbackQuery" then
var(data)
local Text = LuaTele.base64_decode(data.payload.data)
if Text and Text:match('(.*)hmsaa(.*)/(.*)')  then
local mk = {string.match(Text,"(.*)hmsaa(.*)/(.*)")}
local hms = redis:get(mk[1]..mk[3].."hms")
if tonumber(mk[1]) == tonumber(data.sender_user_id) or tonumber(mk[2]) == tonumber(data.sender_user_id) then
https.request("https://api.telegram.org/bot"..Token.."/answerCallbackQuery?callback_query_id="..data.id.."&text="..URL.escape(hms).."&show_alert=true")
end
if tonumber(mk[1]) ~= tonumber(data.sender_user_id) or tonumber(mk[2]) ~= tonumber(data.sender_user_id) then
https.request("https://api.telegram.org/bot"..Token.."/answerCallbackQuery?callback_query_id="..data.id.."&text="..URL.escape("الهمسه ليست لك").."&show_alert=true")
end
end
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
-- نهايه التفعيل
if text == 'السورس' or text == 'سورس' or text == 'ياسورس' or text == 'يا سورس' then 
local Text = "*𝗐𝖾lc𝗈𝗆𝖾 𝗍𝗈 𝗍𝗁𝖾 𝖲𝗈𝗎𝗋c𝖾 𝖲𝗍𝗋𝖾𝗆\n\n*[ ⌔︙ - 𝖥𝖾𝖾l𝗂𝗇g 🪐 . ](https://t.me/D8BB8)*\n\n*[ ⌔︙ - 𝖲𝗈𝗎𝗋c𝖾 xX𝖲𝗍𝗋𝖾𝗆 . ](http://t.me/xXStrem)*\n\n*[ ⌔︙ - Developer . ](http://t.me/F_T_Y)*\n\n*[ ⌔︙ - Bot AhMeD . ](http://t.me/H6CBoT)*\n*"
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}
},
}
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo=https://t.me/xXStrem&caption=".. URL.escape(Text).."&photo=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
--بداية البنك
----------------------------------------------------
if text == 'بنك' or text == 'البنك' then
bot.sendText(msg.chat_id,msg.id,[[
✠ اوامر البنك

  ⌔︙ انشاء حساب بنكي  › تفتح حساب وتقدر تحول فلوس مع مزايا ثانيه

  ⌔︙ مسح حساب بنكي  › تلغي حسابك البنكي

  ⌔︙ تحويل › تطلب رقم حساب الشخص وتحول له فلوس

  ⌔︙ حسابي  › يطلع لك رقم حسابك عشان تعطيه للشخص اللي بيحول لك

  ⌔︙ فلوسي › يعلمك كم فلوسك

  ⌔︙ راتب › يعطيك راتب كل ١٠ دقائق

  ⌔︙ بخشيش › يعطيك بخشيش كل ١٠ دقايق

  ⌔︙ سرقة › تسرق فلوس اشخاص كل ١٠ دقايق

  ⌔︙ استثمار › تستثمر بالمبلغ اللي تبيه مع نسبة ربح مضمونه من ١٪؜ الى ١٥٪؜

  ⌔︙ حظ › تلعبها بأي مبلغ ياتدبله ياتخسره انت وحظك

  ⌔︙ مضاربه › تضارب بأي مبلغ تبيه والنسبة من ٩٠٪؜ الى -٩٠٪؜ انت وحظك

  ⌔︙ قرض › تاخذ قرض من البنك

  ⌔︙ تسديد القرض › بتسدد القرض اذا عليك 

  ⌔︙ هجوم › تهجم عالخصم مع زيادة نسبة كل هجوم

  ⌔︙ كنز › يعطيك كنز بسعر مختلف انت وحظك

  ⌔︙ مراهنه › تحط مبلغ وتراهن عليه

  ⌔︙ توب الفلوس › يطلع توب اكثر ناس معهم فلوس بكل الكروبات

  ⌔︙ توب الحراميه › يطلع لك اكثر ناس سرقوا

  ⌔︙ زواج  › تكتبه بالرد على رسالة شخص مع المهر ويزوجك

  ⌔︙ زواجي  › يطلع وثيقة زواجك اذا متزوج

  ⌔︙ طلاق › يطلقك اذا متزوج

  ⌔︙ خلع  › يخلع زوجك ويرجع له المهر

  ⌔︙ زواجات › يطلع اغلى ٣٠ زواجات

  ⌔︙ ترتيبي › يطلع ترتيبك باللعبة


]],"md",true)  
return false
end

if text == 'انشاء حساب بنكي' or text == 'انشاء حساب البنكي' or text =='انشاء الحساب بنكي' or text =='انشاء الحساب البنكي' or text == "انشاء حساب" or text == "فتح حساب بنكي" then
cobnum = tonumber(redis:get("bandid"..msg.sender.user_id))
if cobnum == msg.sender.user_id then
return bot.sendText(msg.chat_id,msg.id, "⇜ حسابك محظور من لعبة البنك","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
creditcc = math.random(500000000000,599999999999);
creditvi = math.random(400000000000,499999999999);
creditex = math.random(600000000000,699999999999);
balas = 50
if redis:sismember("booob",msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ لديك حساب بنكي مسبقاً\n\n⇜ لعرض معلومات حسابك اكتب\n⇠ `حسابي`","md",true)
end
redis:setex(bot_id..msg.chat_id .. ":" .. msg.sender.user_id,60, true)
bot.sendText(msg.chat_id,msg.id,[[
✠┊عليك اختيار نوع البطاقة للحفاظ على فلوسك 

• `بنك الرشيد`
• `بنك الرافدين`
• `بنك الدولي`

- اضغط للنسخ

- اختر اسم البنك اضغط للنسخ بعدها ارسل :
]],"md",true)  
return false
end
if redis:get(bot_id..msg.chat_id .. ":" .. msg.sender.user_id) then
if text == "بنك الرشيد" then
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = msg.sender.user_id
redis:set("bobna"..msg.sender.user_id,news)
redis:set("boob"..msg.sender.user_id,balas)
redis:set("boobb"..msg.sender.user_id,creditcc)
redis:set("bbobb"..msg.sender.user_id,text)
redis:set("boballname"..creditcc,news)
redis:set("boballbalc"..creditcc,balas)
redis:set("boballcc"..creditcc,creditcc)
redis:set("boballban"..creditcc,text)
redis:set("boballid"..creditcc,banid)
redis:sadd("booob",msg.sender.user_id)
redis:del(bot_id..msg.chat_id .. ":" .. msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id, "\n• وعملنالك لك حساب في بنك فلاش 🏦\n• وشحنالك 50 دينار 💵 هدية\n\n⇜ رقم حسابك › ( `"..creditcc.."` )\n⇜ نوع البطاقة › ( بنك الرشيد 💳 )\n⇜ فلوسك › ( 50 دينار 💵 )  ","md",true)  
end 
if text == "بنك الرافدين" then
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = msg.sender.user_id
redis:set("bobna"..msg.sender.user_id,news)
redis:set("boob"..msg.sender.user_id,balas)
redis:set("boobb"..msg.sender.user_id,creditvi)
redis:set("bbobb"..msg.sender.user_id,text)
redis:set("boballname"..creditvi,news)
redis:set("boballbalc"..creditvi,balas)
redis:set("boballcc"..creditvi,creditvi)
redis:set("boballban"..creditvi,text)
redis:set("boballid"..creditvi,banid)
redis:sadd("booob",msg.sender.user_id)
redis:del(bot_id..msg.chat_id .. ":" .. msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id, "\n• وعملنالك لك حساب في بنك فلاش 🏦\n• وشحنالك 50 دينار 💵 هدية\n\n⇜ رقم حسابك › ( `"..creditvi.."` )\n⇜ نوع البطاقة › ( بنك الرافدين 💳 )\n⇜ فلوسك › ( 50 دينار 💵 )  ","md",true)   
end 
if text == "بنك الدولي" then
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = msg.sender.user_id
redis:set("bobna"..msg.sender.user_id,news)
redis:set("boob"..msg.sender.user_id,balas)
redis:set("boobb"..msg.sender.user_id,creditex)
redis:set("bbobb"..msg.sender.user_id,text)
redis:set("boballname"..creditex,news)
redis:set("boballbalc"..creditex,balas)
redis:set("boballcc"..creditex,creditex)
redis:set("boballban"..creditex,text)
redis:set("boballid"..creditex,banid)
redis:sadd("booob",msg.sender.user_id)
redis:del(bot_id..msg.chat_id .. ":" .. msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id, "\n• وعملنالك لك حساب في بنك فلاش 🏦\n• وشحنالك 50 دينار 💵 هدية\n\n⇜ رقم حسابك › ( `"..creditex.."` )\n⇜ نوع البطاقة › ( بنك الدولي💳 )\n⇜ فلوسك › ( 50 دينار 💵 )  ","md",true)   
end 
end
if text == 'مسح حساب بنكي' or text == 'مسح حساب البنكي' or text =='مسح الحساب بنكي' or text =='مسح الحساب البنكي' or text == "مسح حسابي البنكي" or text == "مسح حسابي بنكي" or text == "مسح حسابي" then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
redis:srem("booob", msg.sender.user_id)
redis:del("boob"..msg.sender.user_id)
redis:del("boobb"..msg.sender.user_id)
redis:del("rrfff"..msg.sender.user_id)
redis:srem("rrfffid", msg.sender.user_id)
redis:srem("roogg1", msg.sender.user_id)
redis:srem("roogga1", msg.sender.user_id)
redis:del("roog1"..msg.sender.user_id)
redis:del("rooga1"..msg.sender.user_id)
redis:del("rahr1"..msg.sender.user_id)
redis:del("rahrr1"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "⇜ مسحت حسابك البنكي 🏦","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'تثبيت النتائج' or text == 'تثبيت نتائج' then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
time = os.date("*t")
month = time.month
day = time.day
local_time = month.."/"..day
local bank_users = redis:smembers("booob")
if #bank_users == 0 then
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يوجد حسابات في البنك","md",true)
end
mony_list = {}
for k,v in pairs(bank_users) do
local mony = redis:get("boob"..v)
table.insert(mony_list, {tonumber(mony) , v})
end
table.sort(mony_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇",
"🥈",
"🥉"
}
for k,v in pairs(mony_list) do
local user_name = bot.getUser(v[2]).first_name or redis:get(v[2].."first_name:") or "لا يوجد اسم"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
redis:set("medal"..v[2],convert_mony)
redis:set("medal2"..v[2],emo)
redis:set("medal3"..v[2],local_time)
redis:sadd("medalid",v[2])
redis:set("medal"..v[2],convert_mony)
redis:set("medal2"..v[2],emo)
redis:set("medal3"..v[2],local_time)
redis:sadd("medalid",v[2])
local user_name = bot.getUser(v[2]).first_name or redis:get(v[2].."first_name:") or "لا يوجد اسم"
local user_tag = '['..user_name..'](tg://user?id='..v[2]..')'
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
redis:set("medal"..v[2],convert_mony)
redis:set("medal2"..v[2],emo)
redis:set("medal3"..v[2],local_time)
redis:sadd("medalid",v[2])
if num == 4 then
return end
end
bot.sendText(msg.chat_id,msg.id, "⇜ ثبتت النتائج","md",true)
end
end
if text == 'مسح كل الفلوس' or text == 'مسح كل فلوس' then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
local bank_users = redis:smembers("booob")
for k,v in pairs(bank_users) do
redis:del("boob"..v)
redis:del("kreednum"..v)
redis:del("kreed"..v)
redis:del("rrfff"..v)
end
local bank_usersr = redis:smembers("rrfffid")
for k,v in pairs(bank_usersr) do
redis:del("boob"..v)
redis:del("rrfff"..v)
end
bot.sendText(msg.chat_id,msg.id, "⇜ مسحت كل فلوس اللعبة 🏦","md",true)
end
end

if text == 'تصفير النتائج' or text == 'مسح لعبه البنك' then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
local bank_users = redis:smembers("booob")
for k,v in pairs(bank_users) do
redis:del("boob"..v)
redis:del("kreednum"..v)
redis:del("kreed"..v)
redis:del("rrfff"..v)
redis:del("numattack"..v)
end
local bank_usersr = redis:smembers("rrfffid")
for k,v in pairs(bank_usersr) do
redis:del("boob"..v)
redis:del("rrfff"..v)
end
redis:del("rrfffid")
redis:del("booob")
bot.sendText(msg.chat_id,msg.id, "⇜ مسحت لعبه البنك 🏦","md",true)
end
end
if text == 'ميدالياتي' or text == 'ميداليات' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("medalid",msg.sender.user_id) then
local medaa2 = redis:get("medal2"..msg.sender.user_id)
if medaa2 == "🥇" then
local medaa = redis:get("medal"..msg.sender.user_id)
local medaa2 = redis:get("medal2"..msg.sender.user_id)
local medaa3 = redis:get("medal3"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "ميدالياتك :\n\nالتاريخ : "..medaa3.." \nالفلوس : "..medaa.." 💵\nالمركز : "..medaa2.." كونكر "..medaa2.."\n","md",true)
elseif medaa2 == "🥈" then
local medaa = redis:get("medal"..msg.sender.user_id)
local medaa2 = redis:get("medal2"..msg.sender.user_id)
local medaa3 = redis:get("medal3"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "ميدالياتك :\n\nالتاريخ : "..medaa3.." \nالفلوس : "..medaa.." 💵\nالمركز : "..medaa2.." ايس "..medaa2.."\n","md",true)
else
local medaa = redis:get("medal"..msg.sender.user_id)
local medaa2 = redis:get("medal2"..msg.sender.user_id)
local medaa3 = redis:get("medal3"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "ميدالياتك :\n\nالتاريخ : "..medaa3.." \nالفلوس : "..medaa.." 💵\nالمركز : "..medaa2.." تاج "..medaa2.."\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك ميداليات","md",true)
end
end

if text == 'فلوسي' or text == 'فلوس' and tonumber(msg.reply_to_message_id) == 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < 1 then
return bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك فلوس ارسل الالعاب وابدأ بجمع الفلوس \n","md",true)
end
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك `"..convert_mony.."` دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'فلوسه' or text == 'فلوس' and tonumber(msg.reply_to_message_id) ~= 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
if redis:sismember("booob",Remsg.sender.user_id) then
ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballanceed)
bot.sendText(msg.chat_id,msg.id, "⇜ فلوسه `"..convert_mony.."` دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي ","md",true)
end
end

if text == 'حسابي' or text == 'حسابي البنكي' or text == 'رقم حسابي' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
if redis:sismember("booob",msg.sender.user_id) then
cccc = redis:get("boobb"..msg.sender.user_id)
uuuu = redis:get("bbobb"..msg.sender.user_id)
pppp = redis:get("rrfff"..msg.sender.user_id) or 0
ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id, "⇜ الاسم › "..news.."\n⇜ الحساب › `"..cccc.."`\n⇜ بنك › ( فلاش )\n⇜ نوع › ( "..uuuu.." )\n⇜ الرصيد › ( "..convert_mony.." دينار 💵 )\n⇜ السرقة ( "..pppp.." دينار 💵 )\n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'مسح حسابه' and tonumber(msg.reply_to_message_id) ~= 0 then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
local ban = bot.getUser(Remsg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
if redis:sismember("booob",Remsg.sender.user_id) then
ccccc = redis:get("boobb"..Remsg.sender.user_id)
uuuuu = redis:get("bbobb"..Remsg.sender.user_id)
ppppp = redis:get("rrfff"..Remsg.sender.user_id) or 0
ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballanceed)
redis:srem("booob", Remsg.sender.user_id)
redis:del("boob"..Remsg.sender.user_id)
redis:del("boobb"..Remsg.sender.user_id)
redis:del("rrfff"..Remsg.sender.user_id)
redis:del("numattack"..Remsg.sender.user_id)
redis:srem("rrfffid", Remsg.sender.user_id)
redis:srem("roogg1", Remsg.sender.user_id)
redis:srem("roogga1", Remsg.sender.user_id)
redis:del("roog1"..Remsg.sender.user_id)
redis:del("rooga1"..Remsg.sender.user_id)
redis:del("rahr1"..Remsg.sender.user_id)
redis:del("rahrr1"..Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "⇜ الاسم › "..news.."\n⇜ الحساب › `"..ccccc.."`\n⇜ بنك › ( فلاش )\n⇜ نوع › ( "..uuuuu.." )\n⇜ الرصيد › ( "..convert_mony.." دينار 💵 )\n⇜ السرقة › ( "..ppppp.." دينار 💵 )\n⇜ مسكين مسحت حسابه \n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي اصلاً ","md",true)
end
end
end

if text == 'حسابه' and tonumber(msg.reply_to_message_id) ~= 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
local ban = bot.getUser(Remsg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
if redis:sismember("booob",Remsg.sender.user_id) then
ccccc = redis:get("boobb"..Remsg.sender.user_id)
uuuuu = redis:get("bbobb"..Remsg.sender.user_id)
ppppp = redis:get("rrfff"..Remsg.sender.user_id) or 0
ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballanceed)
bot.sendText(msg.chat_id,msg.id, "⇜ الاسم › "..news.."\n⇜ الحساب › `"..ccccc.."`\n⇜ بنك › ( فلاش )\n⇜ نوع › ( "..uuuuu.." )\n⇜ الرصيد › ( "..convert_mony.." دينار 💵 )\n⇜ السرقة › ( "..ppppp.." دينار 💵 )\n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي ","md",true)
end
end

if text and text:match('^مسح حساب (.*)$') or text and text:match('^مسح حسابه (.*)$') then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
local UserName = text:match('^مسح حساب (.*)$') or text:match('^مسح حسابه (.*)$')
local coniss = coin(UserName)
local ban = bot.getUser(coniss)
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد "
end
if redis:sismember("booob",coniss) then
ccccc = redis:get("boobb"..coniss)
uuuuu = redis:get("bbobb"..coniss)
ppppp = redis:get("rrfff"..coniss) or 0
ballanceed = redis:get("boob"..coniss) or 0
local convert_mony = string.format("%.0f",ballanceed)
redis:srem("booob", coniss)
redis:del("boob"..coniss)
redis:del("boobb"..coniss)
redis:del("rrfff"..coniss)
redis:srem("roogg1", coniss)
redis:srem("roogga1", coniss)
redis:del("roog1"..coniss)
redis:del("rooga1"..coniss)
redis:del("rahr1"..coniss)
redis:del("rahrr1"..coniss)
redis:del("numattack"..coniss)
redis:srem("rrfffid", coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ الاسم › "..news.."\n⇜ الحساب › `"..ccccc.."`\n⇜ بنك › ( فلاش )\n⇜ نوع › ( "..uuuuu.." )\n⇜ الرصيد › ( "..convert_mony.." دينار 💵 )\n⇜ السرقة › ( "..ppppp.." دينار 💵 )\n⇜ مسكين مسحت حسابه \n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي اصلاً ","md",true)
end
end
end

if text and text:match('^حساب (.*)$') or text and text:match('^حسابه (.*)$') then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^حساب (.*)$') or text:match('^حسابه (.*)$')
local coniss = coin(UserName)
if redis:get("boballcc"..coniss) then
local yty = redis:get("boballname"..coniss)
local bobpkh = redis:get("boballid"..coniss)
ballancee = redis:get("boob"..bobpkh) or 0
local convert_mony = string.format("%.0f",ballancee)
local dfhb = redis:get("boballbalc"..coniss)

local fsvhh = redis:get("boballban"..coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ الاسم › "..yty.."\n⇜ الحساب › `"..coniss.."`\n⇜ بنك › ( فلاش )\n⇜ نوع › ( "..fsvhh.." )\n⇜ الرصيد › ( "..convert_mony.." دينار 💵 )\n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يوجده حساب بنكي كذا","md",true)
end
end

if text == 'مضاربه' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
if redis:ttl("iiooooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iiooooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تضارب حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`مضاربه` المبلغ","md",true)
end

if text and text:match('^مضاربه (.*)$') or text and text:match('^مضاربة (.*)$') then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^مضاربه (.*)$') or text:match('^مضاربة (.*)$')
local coniss = coin(UserName)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("iiooooo" .. msg.sender.user_id) >= 60 then
  local time = redis:ttl("iiooooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تضارب حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(coniss) < 99 then
return bot.sendText(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 100 دينار 💵\n","md",true)
end
if tonumber(ballancee) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
local modarba = {"1", "2", "3", "4️",}
local Descriptioontt = modarba[math.random(#modarba)]
local modarbaa = math.random(1,90);
if Descriptioontt == "1" or Descriptioontt == "3" then
ballanceekku = coniss / 100 * modarbaa
ballanceekkku = ballancee - ballanceekku
local convert_mony = string.format("%.0f",ballanceekku)
local convert_mony1 = string.format("%.0f",ballanceekkku)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceekkku))
redis:setex("iiooooo" .. msg.sender.user_id,900, true)
bot.sendText(msg.chat_id,msg.id, "⇜ مضاربة فاشلة 📉\n⇜ نسبة الخسارة › "..modarbaa.."%\n⇜ المبلغ الذي خسرته › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك صارت › ( "..convert_mony1.." دينار 💵 )\n","md",true)
elseif Descriptioontt == "2" or Descriptioontt == "4" then
ballanceekku = coniss / 100 * modarbaa
ballanceekkku = ballancee + ballanceekku
local convert_mony = string.format("%.0f",ballanceekku)
local convert_mony1 = string.format("%.0f",ballanceekkku)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceekkku))
redis:setex("iiooooo" .. msg.sender.user_id,900, true)
bot.sendText(msg.chat_id,msg.id, "⇜ مضاربة ناجحة 📈\n⇜ نسبة الربح › "..modarbaa.."%\n⇜ المبلغ الذي ربحته › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك صارت › ( "..convert_mony1.." دينار 💵 )\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'استثمار' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
if redis:ttl("iioooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iioooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تستثمر حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`استثمار` المبلغ","md",true)
end

if text and text:match('^استثمار (.*)$') then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^استثمار (.*)$')
local coniss = coin(UserName)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("iioooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iioooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تستثمر حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(coniss) < 99 then
return bot.sendText(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 100 دينار 💵\n","md",true)
end
if tonumber(ballancee) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
if tonumber(ballancee) < 100000 then
local hadddd = math.random(10,15);
ballanceekk = coniss / 100 * hadddd
ballanceekkk = ballancee + ballanceekk
local convert_mony = string.format("%.0f",ballanceekk)
local convert_mony1 = string.format("%.0f",ballanceekkk)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceekkk))
redis:setex("iioooo" .. msg.sender.user_id,1200, true)
bot.sendText(msg.chat_id,msg.id, "⇜ استثمار ناجح ??\n⇜ نسبة الربح › "..hadddd.."%\n⇜ مبلغ الربح › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك صارت › ( "..convert_mony1.." دينار 💵 )\n","md",true)
else
local hadddd = math.random(1,9);
ballanceekk = coniss / 100 * hadddd
ballanceekkk = ballancee + ballanceekk
local convert_mony = string.format("%.0f",ballanceekk)
local convert_mony1 = string.format("%.0f",ballanceekkk)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceekkk))
redis:setex("iioooo" .. msg.sender.user_id,1200, true)
bot.sendText(msg.chat_id,msg.id, "⇜ استثمار ناجح 💰\n⇜ نسبة الربح › "..hadddd.."%\n⇜ مبلغ الربح › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك صارت › ( "..convert_mony1.." دينار 💵 )\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'حظ' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
if redis:ttl("iiooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iiooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تلعب لعبة الحظ حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`حظ` المبلغ","md",true)
end

if text and text:match('^حظ (.*)$') then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^حظ (.*)$')
local coniss = coin(UserName)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("iiooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iiooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تلعب لعبة الحظ حاليا\n⇜ تعال بعد ( "..time.." دقيقة )","md",true)
end
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
local daddd = {"1", "2",}
local haddd = daddd[math.random(#daddd)]
if haddd == "1" then
local ballanceek = ballancee + coniss
local convert_mony = string.format("%.0f",ballancee)
local convert_mony1 = string.format("%.0f",ballanceek)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceek))
redis:setex("iiooo" .. msg.sender.user_id,900, true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك فزت بالحظ 🎉\n⇜ فلوسك قبل › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك حاليا › ( "..convert_mony1.." دينار 💵 )\n","md",true)
else
local ballanceekk = ballancee - coniss
local convert_mony = string.format("%.0f",ballancee)
local convert_mony1 = string.format("%.0f",ballanceekk)
redis:set("boob"..msg.sender.user_id , math.floor(ballanceekk))
redis:setex("iiooo" .. msg.sender.user_id,900, true)
bot.sendText(msg.chat_id,msg.id, "⇜ للاسف خسرت بالحظ 😬\n⇜ فلوسك قبل › ( "..convert_mony.." دينار 💵 )\n⇜ فلوسك حاليا › ( "..convert_mony1.." دينار 💵 )\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'تحويل' then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`تحويل` المبلغ","md",true)
end

if text and text:match('^تحويل (.*)$') then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` لكي تستطيع التحويل","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^تحويل (.*)$')
local coniss = coin(UserName)
if not redis:sismember("booob",msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ","md",true)
end
if tonumber(coniss) < 100 then
return bot.sendText(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح به هو 100 دينار \n","md",true)
end
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < 100 then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end

if tonumber(coniss) > tonumber(ballancee) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي\n","md",true)
end

redis:set("transn"..msg.sender.user_id,coniss)
redis:setex("trans" .. msg.chat_id .. ":" .. msg.sender.user_id,60, true)
bot.sendText(msg.chat_id,msg.id,[[
⇜ ارسل حاليا رقم الحساب البنكي الي تبي تحول له

– معاك دقيقة وحدة والغي طلب التحويل .

]],"md",true)  
return false
end
if redis:get("trans" .. msg.chat_id .. ":" .. msg.sender.user_id) then
cccc = redis:get("boobb"..msg.sender.user_id)
uuuu = redis:get("bbobb"..msg.sender.user_id)
if text ~= text:match('^(%d+)$') then
redis:del("trans" .. msg.chat_id .. ":" .. msg.sender.user_id) 
redis:del("transn" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ ارسل رقم حساب بنكي ","md",true)
end
if text == cccc then
redis:del("trans" .. msg.chat_id .. ":" .. msg.sender.user_id) 
redis:del("transn" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يمكنك تحول لنفسك ","md",true)
end
if redis:get("boballcc"..text) then
local UserNamey = redis:get("transn"..msg.sender.user_id)
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
news = " لا يوجد "
end
local fsvhhh = redis:get("boballid"..text)
local bann = bot.getUser(fsvhhh)
if bann.first_name then
newss = "["..bann.first_name.."](tg://user?id="..bann.id..")"
else
newss = " لا يوجد "
end
local fsvhh = redis:get("boballban"..text)
UserNameyr = UserNamey / 10
UserNameyy = UserNamey - UserNameyr
local convert_mony = string.format("%.0f",UserNameyy)
ballancee = redis:get("boob"..msg.sender.user_id) or 0
deccde = ballancee - UserNamey
redis:set("boob"..msg.sender.user_id , math.floor(deccde))
-----------
decdecb = redis:get("boob"..fsvhhh) or 0
deccde2 = decdecb + UserNameyy
redis:set("boob"..fsvhhh , math.floor(deccde2))

bot.sendText(msg.chat_id,msg.id, "حوالة صادرة من بنك فلاش\n\nالمرسل : "..news.."\nالحساب رقم : `"..cccc.."`\nنوع البطاقة : "..uuuu.."\nالمستلم : "..newss.."\nالحساب رقم : `"..text.."`\nنوع البطاقة : "..fsvhh.."\nخصمت 10% رسوم تحويل\nالمبلغ : "..convert_mony.." دينار 💵","md",true)
bot.sendText(fsvhhh,0, "حوالة واردة من بنك فلاش\n\nالمرسل : "..news.."\nالحساب رقم : `"..cccc.."`\nنوع البطاقة : "..uuuu.."\nالمبلغ : "..convert_mony.." دينار 💵","md",true)
redis:del("trans" .. msg.chat_id .. ":" .. msg.sender.user_id) 
redis:del("transn" .. msg.sender.user_id)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يوجده حساب بنكي كذا","md",true)
redis:del("trans" .. msg.chat_id .. ":" .. msg.sender.user_id) 
redis:del("transn" .. msg.sender.user_id)
end
end


if text == "ترتيبي" then
if redis:sismember("booob",msg.sender.user_id) then
local bank_users = redis:smembers("booob")
my_num_in_bank = {}
for k,v in pairs(bank_users) do
local mony = redis:get("boob"..v)
table.insert(my_num_in_bank, {math.floor(tonumber(mony)) , v})
end
table.sort(my_num_in_bank, function(a, b) return a[1] > b[1] end)
for k,v in pairs(my_num_in_bank) do
if tonumber(v[2]) == tonumber(msg.sender.user_id) then
local mony = v[1]
return bot.sendText(msg.chat_id,msg.id,"⇜ ترتيبك ( "..k.." )","md",true)
end
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == "توب فلوس" or text == "توب الفلوس" then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local bank_users = redis:smembers("booob")
if #bank_users == 0 then
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يوجد حسابات في البنك","md",true)
end
top_mony = "توب اغنى 30 شخص :\n\n"
mony_list = {}
for k,v in pairs(bank_users) do
local mony = redis:get("boob"..v)
table.insert(mony_list, {tonumber(mony) , v})
end
table.sort(mony_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)",
"21)",
"22)",
"23)",
"24)",
"25)",
"26)",
"27)",
"28)",
"29)",
"30)"
}
for k,v in pairs(mony_list) do
if num <= 30 then
local user_name = bot.getUser(v[2]).first_name or redis:get(v[2].."first_name:") or "لا يوجد اسم"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
top_mony = top_mony..emo.." "..convert_mony.." 💵 ꗝ "..user_name.."\n"
end
end
top_monyy = top_mony.."\n\nاي اسم مخالف او غش باللعب راح يتصفر وينحظر اللاعب"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '𝖲𝗈𝗎𝗋c𝖾 xX𝖲𝗍𝗋𝖾𝗆', url="t.me/xXStrem"},
},
}
}
return bot.sendText(msg.chat_id,msg.id,top_monyy,"html",false, false, false, false, reply_markup)
end

if text == "توب الحراميه" or text == "توب الحرامية" or text == "توب حراميه" or text == "توب السرقة" or text == "توب زرف" then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local ty_users = redis:smembers("rrfffid")
if #ty_users == 0 then
return bot.sendText(msg.chat_id,msg.id,"⇜ لا يوجد احد","md",true)
end
ty_anubis = "توب 20 شخص سرقوا فلوس :\n\n"
ty_list = {}
for k,v in pairs(ty_users) do
local mony = redis:get("rrfff"..v)
table.insert(ty_list, {tonumber(mony) , v})
end
table.sort(ty_list, function(a, b) return a[1] > b[1] end)
num_ty = 1
emojii ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
for k,v in pairs(ty_list) do
if num_ty <= 20 then
local user_name = bot.getUser(v[2]).first_name or redis:get(v[2].."first_name:") or "لا يوجد اسم"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emoo = emojii[k]
num_ty = num_ty + 1
ty_anubis = ty_anubis..emoo.." "..convert_mony.." 💵 ꗝ "..user_name.."\n"
end
end
ty_anubiss = ty_anubis.."\n\nاي اسم مخالف او غش باللعب راح يتصفر وينحظر اللاعب"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '𝖲𝗈𝗎𝗋c𝖾 xX𝖲𝗍𝗋𝖾𝗆', url="t.me/xXStrem"},
},
}
}
return bot.sendText(msg.chat_id,msg.id,ty_anubiss,"html",false, false, false, false, reply_markup)
end

if text == 'تسديد قرضه' and tonumber(msg.reply_to_message_id) ~= 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
if redis:sismember("booob",Remsg.sender.user_id) then
if redis:get("kreed"..msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ سدد قرضك اول شي بعدين اعمل راعي النشامى ","md",true)
end
if not redis:get("kreed"..Remsg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ ماعليه قرض","md",true)
else
local ban = bot.getUser(Remsg.sender.user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..Remsg.sender.user_id))
if tonumber(ballanceed) < tonumber(krses) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
nshme = ballanceed - krses
redis:set("boob"..msg.sender.user_id,math.floor(nshme))
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
redis:del("kreed"..Remsg.sender.user_id)
redis:del("kreednum"..Remsg.sender.user_id)
local convert_mony = string.format("%.0f",ballanceed)
bot.sendText(msg.chat_id,msg.id, "⇜ اشعار تسديد قرض عن "..news.."\n\nالقرض : "..krses.." دينار 💵\nتم اقتطاع المبلغ من فلوسك\nفلوسك حاليا : "..convert_mony.." دينار 💵 ","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي ","md",true)
end
end

if text == 'تسديد قرض' or text == 'تسديد القرض' or text == 'تسديد قرضي' and tonumber(msg.reply_to_message_id) == 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
if not redis:get("kreed"..msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ ماعليك قرض ","md",true)
end
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if tonumber(ballanceed) < tonumber(krses) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
tsded = ballanceed - krses
redis:set("boob"..msg.sender.user_id,math.floor(tsded))
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
redis:del("kreed"..msg.sender.user_id)
redis:del("kreednum"..msg.sender.user_id)
local convert_mony = string.format("%.0f",ballanceed)
bot.sendText(msg.chat_id,msg.id, "⇜ اشعار تسديد قرض\n\nالقرض : "..krses.." دينار 💵\nتم اقتطاع المبلغ من فلوسك\nفلوسك حاليا : "..convert_mony.." دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'القرض' or text == 'قرض' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id, "⇜ سحبت قرض قبل بقيمة "..krses.." دينار 💵","md",true)
end
if redis:sismember("booob",msg.sender.user_id) then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballanceed) < 100000 then
kredd = tonumber(ballanceed) + 900000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,900000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 900000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 200000 then
kredd = tonumber(ballanceed) + 800000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,800000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 800000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 300000 then
kredd = tonumber(ballanceed) + 700000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,700000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 700000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 400000 then
kredd = tonumber(ballanceed) + 600000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,600000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 600000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 500000 then
kredd = tonumber(ballanceed) + 500000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,500000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 500000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 600000 then
kredd = tonumber(ballanceed) + 400000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,400000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 400000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 700000 then
kredd = tonumber(ballanceed) + 300000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,300000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 300000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 800000 then
kredd = tonumber(ballanceed) + 200000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,200000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 200000 دينار 💵","md",true)
elseif tonumber(ballanceed) < 900000 then
kredd = tonumber(ballanceed) + 100000
redis:set("boob"..msg.sender.user_id,kredd)
redis:set("kreednum"..msg.sender.user_id,100000)
redis:set("kreed"..msg.sender.user_id,true)
bot.sendText(msg.chat_id,msg.id, "⇜ مبروك وهو قرض بقيمة 100000 دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك فوق المليون مايطلعلك قرض","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'بخشيش' or text == 'بقشيش' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("iioo" .. msg.sender.user_id) >=1 then
local hours = redis:ttl("iioo" .. msg.sender.user_id) / 60
return bot.sendText(msg.chat_id,msg.id,"⇜ من شوي اخذت بخشيش انتظر "..math.floor(hours).." دقيقة","md",true)
end

local jjjo = math.random(200,1000);
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
bakigcj = ballanceed + jjjo
redis:set("boob"..msg.sender.user_id , bakigcj)
bot.sendText(msg.chat_id,msg.id,"⇜ دلعتك اعطيتك بخشيش "..jjjo.." دينار 💵","md",true)
redis:setex("iioo" .. msg.sender.user_id,600, true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'زرف' and tonumber(msg.reply_to_message_id) == 0 then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`زرف` بالرد","md",true)
end

if text == 'زرف' or text == 'سرقة' or text == 'قطه' and tonumber(msg.reply_to_message_id) ~= 0 then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
if Remsg.sender.user_id == msg.sender.user_id then
bot.sendText(msg.chat_id,msg.id,"\n*⇜انت غبي؟ *","md",true)  
return false
end
if redis:ttl("polic" .. msg.sender.user_id) >= 280 then
return bot.sendText(msg.chat_id,msg.id,"⇜ انت بالسجن 🏤 انتظر ( 5 دقائق )","md",true)
elseif redis:ttl("polic" .. msg.sender.user_id) >= 240 then
return bot.sendText(msg.chat_id,msg.id,"⇜ انت بالسجن 🏤 انتظر ( 4 دقائق )","md",true)
elseif redis:ttl("polic" .. msg.sender.user_id) >= 180 then
return bot.sendText(msg.chat_id,msg.id,"⇜ انت بالسجن 🏤 انتظر ( 3 دقائق )","md",true)
elseif redis:ttl("polic" .. msg.sender.user_id) >= 120 then
return bot.sendText(msg.chat_id,msg.id,"⇜ انت بالسجن 🏤 انتظر ( 2 دقيقة )","md",true)
elseif redis:ttl("polic" .. msg.sender.user_id) >= 60 then
return bot.sendText(msg.chat_id,msg.id,"⇜ انت بالسجن 🏤 انتظر ( 1 دقيقة )","md",true)
end
if redis:ttl("hrame" .. Remsg.sender.user_id) >= 60 then
local time = redis:ttl("hrame" .. Remsg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ الشخص مسروق من شويه\n⇜ يمكنك تسرقة بعد ( "..time.." ثانية)","md",true)
end
if redis:sismember("booob",Remsg.sender.user_id) then
ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
if tonumber(ballanceed) < 199 then
return bot.sendText(msg.chat_id,msg.id, "⇜ لا يمكنك تسرقة فلوسه اقل من 200 دينار 💵","md",true)
end
local hrame = math.floor(math.random() * 200) + 1;
local hramee = math.floor(math.random() * 5) + 1;
if hramee == 1 or hramee == 2 or hramee == 3 or hramee == 4 then
local ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local ballancope = redis:get("boob"..msg.sender.user_id) or 0
zrfne = ballanceed - hrame
zrfnee = ballancope + hrame
redis:set("boob"..msg.sender.user_id , math.floor(zrfnee))
redis:set("boob"..Remsg.sender.user_id , math.floor(zrfne))
redis:setex("hrame" .. Remsg.sender.user_id,900, true)
local zoropeo = redis:get("rrfff"..msg.sender.user_id) or 0
zoroprod = zoropeo + hrame
redis:set("rrfff"..msg.sender.user_id,zoroprod)
redis:sadd("rrfffid",msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id, "⇜ خذ يالحرامي سرقته "..hrame.." دينار 💵\n","md",true)
else
redis:setex("polic" .. msg.sender.user_id,300, true)
bot.sendText(msg.chat_id,msg.id, "⇜ مسكتك الشرطة وانت تسرق 🚔\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي ","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'راتب' or text == 'راتبي' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("iiioo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("iiioo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ راتبك بينزل بعد ( "..time.." ثانية )","md",true)
end

local Textinggt = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
neews = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
neews = " لا يوجد "
end
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
if Descriptioont == "1" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : كابتن كريم 🚙\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "2" then
local ratpep = ballancee + 3500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3500 دينار 💵\nوظيفتك : شرطي 👮🏻‍♂️\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "3" then
local ratpep = ballancee + 3500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3500 دينار 💵\nوظيفتك : بياع حبوب 🍻\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "4" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : سواق تاكسي 🚕\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "5" then
local ratpep = ballancee + 5000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5000 دينار 💵\nوظيفتك : قاضي 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "6" then
local ratpep = ballancee + 2500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2500 دينار 💵\nوظيفتك : نوم 🛌\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "7" then
local ratpep = ballancee + 2700
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2700 دينار 💵\nوظيفتك : مغني 🎤\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "8" then
local ratpep = ballancee + 2900
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2900 دينار 💵\nوظيفتك : كوفيره 💆\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "9" then
local ratpep = ballancee + 2500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2500 دينار 💵\nوظيفتك : ربة منزل 🤷\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "10" then
local ratpep = ballancee + 2900
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2900 دينار 💵\nوظيفتك : مربيه اطفال 💁\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "11" then
local ratpep = ballancee + 3700
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3700 دينار 💵\nوظيفتك : كهربائي 💡\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "12" then
local ratpep = ballancee + 3600
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3600 دينار 💵\nوظيفتك : نجار ⛏\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "13" then
local ratpep = ballancee + 2400
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2400 دينار 💵\nوظيفتك : متذوق طعام 🍕\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "14" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : فلاح 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "15" then
local ratpep = ballancee + 5000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5000 دينار 💵\nوظيفتك : كاشير بنده 🙋\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "16" then
local ratpep = ballancee + 6000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6000 دينار 💵\nوظيفتك : ممرض 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "17" then
local ratpep = ballancee + 3100
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3100 دينار 💵\nوظيفتك : مهرج 🤹\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "18" then
local ratpep = ballancee + 3300
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3300 دينار 💵\nوظيفتك : عامل توصيل 🚴\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "19" then
local ratpep = ballancee + 4800
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 4800 دينار 💵\nوظيفتك : عسكري 👮\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "20" then
local ratpep = ballancee + 6000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6000 دينار 💵\nوظيفتك : مهندس 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "21" then
local ratpep = ballancee + 8000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 8000 دينار 💵\nوظيفتك : وزير 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "22" then
local ratpep = ballancee + 5500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5500 دينار 💵\nوظيفتك : محامي ⚖️\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "23" then
local ratpep = ballancee + 5500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5500 دينار 💵\nوظيفتك : تاجر 💵\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "24" then
local ratpep = ballancee + 7000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 7000 دينار 💵\nوظيفتك : دكتور 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "25" then
local ratpep = ballancee + 2600
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2600 دينار 💵\nوظيفتك : حفار قبور ⚓\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "26" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : حلاق ✂\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "27" then
local ratpep = ballancee + 5000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5000 دينار 💵\nوظيفتك : إمام مسجد 📿\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "28" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : صياد 🎣\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "29" then
local ratpep = ballancee + 2300
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2300 دينار 💵\nوظيفتك : خياط 🧵\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "30" then
local ratpep = ballancee + 7100
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 7100 دينار 💵\nوظيفتك : طيار 🛩\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "31" then
local ratpep = ballancee + 5300
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5300 دينار 💵\nوظيفتك : مودل 🕴\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "32" then
local ratpep = ballancee + 10000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 10000 دينار 💵\nوظيفتك : ملك 👑\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "33" then
local ratpep = ballancee + 2700
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 2700 دينار 💵\nوظيفتك : سباك 🔧\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "34" then
local ratpep = ballancee + 3900
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3900 دينار 💵\nوظيفتك : موزع 🗺\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "35" then
local ratpep = ballancee + 4100
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 4100 دينار 💵\nوظيفتك : سكيورتي 👮\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "36" then
local ratpep = ballancee + 3500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3500 دينار 💵\nوظيفتك : معلم شاورما 🌯\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار ??","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "37" then
local ratpep = ballancee + 6700
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6700 دينار 💵\nوظيفتك : دكتور ولاده 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "38" then
local ratpep = ballancee + 6600
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6600 دينار 💵\nوظيفتك : مذيع 🗣\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "39" then
local ratpep = ballancee + 3400
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3400 دينار 💵\nوظيفتك : عامل مساج 💆\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "40" then
local ratpep = ballancee + 6300
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6300 دينار 💵\nوظيفتك : ممثل 🤵\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "41" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : جزار 🥩\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "42" then
local ratpep = ballancee + 7000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 7000 دينار 💵\nوظيفتك : مدير بنك 💳\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "43" then
local ratpep = ballancee + 6000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6000 دينار 💵\nوظيفتك : مبرمج 👨\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "44" then
local ratpep = ballancee + 5000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5000 دينار 💵\nوظيفتك : رقاصه 💃\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "45" then
local ratpep = ballancee + 4900
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 4900 دينار 💵\nوظيفتك : 👩🏼‍💻 صحفي\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "46" then
local ratpep = ballancee + 5300
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 5300 دينار 💵\nوظيفتك : 🥷 حرامي\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "47" then
local ratpep = ballancee + 6000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6000 دينار 💵\nوظيفتك : 🔮 ساحر\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "48" then
local ratpep = ballancee + 6500
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 6500 دينار 💵\nوظيفتك : ⚽ لاعب️\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "49" then
local ratpep = ballancee + 4000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 4000 دينار 💵\nوظيفتك : 🖼 مصور\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "50" then
local ratpep = ballancee + 3000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3000 دينار 💵\nوظيفتك : ☎️ عامل مقسم\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "51" then
local ratpep = ballancee + 3200
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 3200 دينار 💵\nوظيفتك : 📖 كاتب\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
elseif Descriptioont == "52" then
local ratpep = ballancee + 4000
redis:set("boob"..msg.sender.user_id , math.floor(ratpep))
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,"اشعار ايداع "..neews.."\nالمبلغ : 4000 دينار 💵\nوظيفتك : 🧪 مخبري\nنوع العملية : اضافة راتب\nرصيدك حاليا : "..convert_mony.." دينار 💵","md",true)
redis:setex("iiioo" .. msg.sender.user_id,600, true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == 'هجوم' then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`هجوم` المبلغ ( بالرد )","md",true)
end
if text and text:match("^هجوم (%d+)$") and msg.reply_to_message_id == 0 then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`هجوم` المبلغ ( بالرد )","md",true)
end

if text and text:match('^هجوم (.*)$') and tonumber(msg.reply_to_message_id) ~= 0 then
local UserName = text:match('^هجوم (.*)$')
local coniss = coin(UserName)
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا يمتلك حسب في البنك*","md",true)  
return false
end
if Remsg.sender.user_id == msg.sender.user_id then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ تهاجم نفسك 🤡*","md",true)  
return false
end
if redis:ttl("attack" .. msg.sender.user_id) >= 60 then
  local time = redis:ttl("attack" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ خسرت بأخر معركة انتظر ( "..time.." دقيقة )","md",true)
end
if redis:ttl("defen" .. Remsg.sender.user_id) >= 60 then
local time = redis:ttl("defen" .. Remsg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ الخصم خسر بأخر معركة\n⇜ يمكنك تهاجمه بعد ( "..time.." دقيقة )","md",true)
end
if redis:sismember("booob",Remsg.sender.user_id) then
ballancope = redis:get("boob"..msg.sender.user_id) or 0
ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
if tonumber(ballancope) < 100000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ لا يمكنك تهجم فلوسك اقل من 100000 دينار 💵","md",true)
end
if tonumber(ballanceed) < 100000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ لا يمكنك تهجم عليه فلوسه اقل من 100000 دينار 💵","md",true)
end
if tonumber(coniss) < 9999 then
return bot.sendText(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح هو 10000 دينار 💵\n","md",true)
end
if tonumber(ballancope) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
if tonumber(ballanceed) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسه لا تكفي \n","md",true)
end
local Textinggt = {"1", "2", "3", "4", "5", "6", "7", "8",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
neews = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
neews = " لا يوجد "
end
local bann = bot.getUser(Remsg.sender.user_id)
if bann.first_name then
neewss = "["..bann.first_name.."](tg://user?id="..bann.id..")"
else
neewss = " لا يوجد "
end
if Descriptioont == "1" or Descriptioont == "3" then
local ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local ballancope = redis:get("boob"..msg.sender.user_id) or 0
zrfne = ballancope - coniss
zrfnee = ballanceed + coniss
redis:set("boob"..msg.sender.user_id , math.floor(zrfne))
redis:set("boob"..Remsg.sender.user_id , math.floor(zrfnee))
redis:setex("attack" .. msg.sender.user_id,600, true)
local convert_mony = string.format("%.0f",coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ لقد خسرت في المعركة "..neews.." 🛡\nالفائز : "..neewss.."\nالخاسر : "..neews.."\nالجائزة : "..convert_mony.." دينار 💵\n","md",true)
elseif Descriptioont == "2" or Descriptioont == "4" or Descriptioont == "5" or  Descriptioont == "6" or Descriptioont == "8" then
local ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local ballancope = redis:get("boob"..msg.sender.user_id) or 0
begaatt = redis:get("numattack"..msg.sender.user_id) or 1000
numattackk = tonumber(begaatt) - 1
if numattackk == 0 then
numattackk = 1
end
attack = coniss / numattackk
zrfne = ballancope + math.floor(attack)
zrfnee = ballanceed - math.floor(attack)
redis:set("boob"..msg.sender.user_id , math.floor(zrfne))
redis:set("boob"..Remsg.sender.user_id , math.floor(zrfnee))
redis:setex("defen" .. Remsg.sender.user_id,1800, true)
redis:set("numattack"..msg.sender.user_id , math.floor(numattackk))
local convert_mony = string.format("%.0f",math.floor(attack))
bot.sendText(msg.chat_id,msg.id, "⇜ لقد فزت في المعركة\nودمرت قلعة "..neewss.." 🏰\nالفائز : "..neews.."\nالخاسر : "..neewss.."\nالجائزة : "..convert_mony.." دينار 💵\nنسبة قوة المهاجم اصبحت "..numattackk.." 🩸\n","md",true)
elseif Descriptioont == "7" then
local ballanceed = redis:get("boob"..Remsg.sender.user_id) or 0
local ballancope = redis:get("boob"..msg.sender.user_id) or 0
halfzrf = coniss / 2
zrfne = ballancope - halfzrf
zrfnee = ballanceed + halfzrf
redis:set("boob"..msg.sender.user_id , math.floor(zrfne))
redis:set("boob"..Remsg.sender.user_id , math.floor(zrfnee))
redis:setex("attack" .. msg.sender.user_id,600, true)
local convert_mony = string.format("%.0f",math.floor(halfzrf))
bot.sendText(msg.chat_id,msg.id, "⇜ لقد خسرت في المعركة "..neews.." 🛡\nولكن استطعت اعادة نصف الموارد\nالفائز : "..neewss.."\nالخاسر : "..neews.."\nالجائزة : "..convert_mony.." دينار 💵\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يمتلك حساب بنكي ","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end
if text == 'مسح لعبه الزواج' then
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
local zwag_users = redis:smembers("roogg1")
for k,v in pairs(zwag_users) do
redis:del("roog1"..v)
redis:del("rooga1"..v)
redis:del("rahr1"..v)
redis:del("rahrr1"..v)
redis:del("roogte1"..v)
end
local zwaga_users = redis:smembers("roogga1")
for k,v in pairs(zwaga_users) do
redis:del("roog1"..v)
redis:del("rooga1"..v)
redis:del("rahr1"..v)
redis:del("rahrr1"..v)
redis:del("roogte1"..v)
end
redis:del("roogga1")
redis:del("roogg1")
bot.sendText(msg.chat_id,msg.id, "⇜ مسحت لعبه الزواج","md",true)
end
end
if text == 'زواج' then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`زواج` المهر","md",true)
end
if text and text:match("^زواج (%d+)$") and msg.reply_to_message_id == 0 then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`زواج` المهر ( بالرد )","md",true)
end
if text and text:match("^زواج (.*)$") and msg.reply_to_message_id ~= 0 then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local UserName = text:match('^زواج (.*)$')
local coniss = coin(UserName)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if msg.sender.user_id == Remsg.sender.user_id then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ زوجتك نفسي 🤣😒*","md",true)  
return false
end
if tonumber(coniss) < 10000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ الحد الادنى المسموح به هو 10000 دينار \n","md",true)
end
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < 10000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
if tonumber(coniss) > tonumber(ballancee) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي\n","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ ماني حق زواجات وخرابيط*","md",true)  
return false
end
if redis:get("roog1"..msg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id, "⇜ انت بالفعل متزوج !!","md",true)
return false
end
if redis:get("rooga1"..msg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id, "⇜ انت بالفعل متزوج !!","md",true)
return false
end
if redis:get("roog1"..Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id, "⇜ اترك المتزوجين ياخي","md",true)
return false
end
if redis:get("rooga1"..Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id, "⇜ اترك المتزوجين ياخي","md",true)
return false
end
local bandd = bot.getUser(msg.sender.user_id)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد"
end
local ban = bot.getUser(Remsg.sender.user_id)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد"
end
if redis:sismember("booob",msg.sender.user_id) then
local hadddd = tonumber(coniss)
ballanceekk = tonumber(coniss) / 100 * 15
ballanceekkk = tonumber(coniss) - ballanceekk
local convert_mony = string.format("%.0f",ballanceekkk)
ballancee = redis:get("boob"..msg.sender.user_id) or 0
ballanceea = redis:get("boob"..Remsg.sender.user_id) or 0
zogtea = ballanceea + ballanceekkk
zeugh = ballancee - tonumber(coniss)
redis:set("boob"..msg.sender.user_id , math.floor(zeugh))
redis:set("boob"..Remsg.sender.user_id , math.floor(zogtea))
redis:sadd("roogg1",msg.sender.user_id)
redis:sadd("roogga1",Remsg.sender.user_id)
redis:set("roog1"..msg.sender.user_id,msg.sender.user_id)
redis:set("rooga1"..msg.sender.user_id,Remsg.sender.user_id)
redis:set("roogte1"..Remsg.sender.user_id,Remsg.sender.user_id)
redis:set("rahr1"..msg.sender.user_id,tonumber(coniss))
redis:set("rahr1"..Remsg.sender.user_id,tonumber(coniss))
redis:set("roog1"..Remsg.sender.user_id,msg.sender.user_id)
redis:set("rahrr1"..msg.sender.user_id,math.floor(ballanceekkk))
redis:set("rooga1"..Remsg.sender.user_id,Remsg.sender.user_id)
redis:set("rahrr1"..Remsg.sender.user_id,math.floor(ballanceekkk))
bot.sendText(msg.chat_id,msg.id, "كولولولولويششش\nاليوم عقدنا قران :\n\nالزوج "..neews.." 🤵🏻\n   💗\nالزوجة "..newws.." 👰🏻‍♀️\nالمهر : "..convert_mony.." دينار بعد الضريبة 15%\nعشان تشوفون وثيقة زواجكم اكتبوا : *زواجي*","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end

if text == "توب زواج" or text == "توب متزوجات" or text == "توب زوجات" or text == "توب زواجات" or text == "زواجات" or text == "الزواجات" then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
  local zwag_users = redis:smembers("roogg1")
  if #zwag_users == 0 then
  return bot.sendText(msg.chat_id,msg.id,"⇜ لا يوجد زواجات حاليا","md",true)
  end
  top_zwag = "توب 30 اغلى زواجات :\n\n"
  zwag_list = {}
  for k,v in pairs(zwag_users) do
  local mahr = redis:get("rahr1"..v)
  local zwga = redis:get("rooga1"..v)
  table.insert(zwag_list, {tonumber(mahr) , v , zwga})
  end
  table.sort(zwag_list, function(a, b) return a[1] > b[1] end)
  znum = 1
  zwag_emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)",
"21)",
"22)",
"23)",
"24)",
"25)",
"26)",
"27)",
"28)",
"29)",
"30)"
  }
  for k,v in pairs(zwag_list) do
  if znum <= 30 then
  local zwg_name = bot.getUser(v[2]).first_name or redis:get(v[2].."first_name:") or "لا يوجد اسم"
  local zwga_name = bot.getUser(v[3]).first_name or redis:get(v[3].."first_name:") or "لا يوجد اسم"
  local mahr = v[1]
  local convert_mony = string.format("%.0f",mahr)
  local emo = zwag_emoji[k]
  znum = znum + 1
  top_zwag = top_zwag..emo.." "..convert_mony.." 💵 ꗝ "..zwg_name.." 👫 "..zwga_name.."\n"
  end
  end
  local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '𝖲𝗈𝗎𝗋c𝖾 xX𝖲𝗍𝗋𝖾𝗆', url="t.me/xXStrem"},
},
}
}
return bot.sendText(msg.chat_id,msg.id,top_zwag,"html",false, false, false, false, reply_markup)
  end

if text == 'زواجي' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("roogg1",msg.sender.user_id) or redis:sismember("roogga1",msg.sender.user_id) then
local zoog = redis:get("roog1"..msg.sender.user_id)
local zooga = redis:get("rooga1"..msg.sender.user_id)
local mahr = redis:get("rahr1"..msg.sender.user_id)
local convert_mony = string.format("%.0f",mahr)
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد"
end
bot.sendText(msg.chat_id,msg.id, "وثيقة الزواج حقتك :\n\nالزوج "..neews.." 🤵🏻\nالزوجة "..newws.." 👰🏻‍♀️\nالمهر : "..convert_mony.." دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت اعزب","md",true)
end
end

if text == 'زوجها' or text == "زوجته" or text == "جوزها" or text == "زوجتو" or text == "زواجه" and msg.reply_to_message_id ~= 0 then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if msg.sender.user_id == Remsg.sender.user_id then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ لا تكشف نفسك وتخسر فلوس عالفاضي\n اكتب `زواجي`*","md",true)  
return false
end
if redis:sismember("roogg1",Remsg.sender.user_id) or redis:sismember("roogga1",Remsg.sender.user_id) then
if redis:sismember("booob",msg.sender.user_id) then
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < 100 then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*⇜ هذا الشخص غير متزوج*","md",true)  
return false
end
local zoog = redis:get("roog1"..Remsg.sender.user_id)
local zooga = redis:get("rooga1"..Remsg.sender.user_id)
local mahr = redis:get("rahr1"..Remsg.sender.user_id)
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد"
end
local otheka = ballancee - 100
local convert_mony = string.format("%.0f",mahr)
redis:set("boob"..msg.sender.user_id , math.floor(otheka))
bot.sendText(msg.chat_id,msg.id, "وثيقة الزواج حقته :\n\nالزوج "..neews.." 🤵🏻\nالزوجة "..newws.." 👰🏻‍♀️\nالمهر : "..convert_mony.." دينار 💵","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ مسكين اعزب مش متزوج","md",true)
end
end

if text == 'طلاق' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("roogg1",msg.sender.user_id) or redis:sismember("roogga1",msg.sender.user_id) then
local zoog = redis:get("roog1"..msg.sender.user_id)
local zooga = tonumber(redis:get("rooga1"..msg.sender.user_id))
if tonumber(zoog) == msg.sender.user_id then
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد"
end
redis:srem("roogg1", msg.sender.user_id)
redis:srem("roogga1", msg.sender.user_id)
redis:del("roog1"..msg.sender.user_id)
redis:del("rooga1"..msg.sender.user_id)
redis:del("rahr1"..msg.sender.user_id)
redis:del("rahrr1"..msg.sender.user_id)
redis:srem("roogg1", zooga)
redis:srem("roogga1", zooga)
redis:del("roog1"..zooga)
redis:del("rooga1"..zooga)
redis:del("rahr1"..zooga)
redis:del("rahrr1"..zooga)
return bot.sendText(msg.chat_id,msg.id, "⇜ تم طلاقك من زوجتك "..newws.."","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ الطلاق للزوج فقط","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت اعزب","md",true)
end
end
if text == 'خلع' then
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("roogg1",msg.sender.user_id) or redis:sismember("roogga1",msg.sender.user_id) then
local zoog = redis:get("roog1"..msg.sender.user_id)
local zooga = redis:get("rooga1"..msg.sender.user_id)
if tonumber(zooga) == msg.sender.user_id then
local mahrr = redis:get("rahrr1"..msg.sender.user_id)
local bandd = bot.getUser(zoog)
if bandd.first_name then
neews = "["..bandd.first_name.."](tg://user?id="..bandd.id..")"
else
neews = " لا يوجد"
end
local ban = bot.getUser(zooga)
if ban.first_name then
newws = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
newws = " لا يوجد"
end
ballancee = redis:get("boob"..zoog) or 0
kalea = ballancee + mahrr
redis:set("boob"..zoog , kalea)
local convert_mony = string.format("%.0f",mahrr)
bot.sendText(msg.chat_id,msg.id, "⇜ خلعت زوجك "..neews.."\n⇜ ورجعت له المهر ( "..convert_mony.." دينار 💵 )","md",true)
redis:srem("roogg1", zoog)
redis:srem("roogga1", zoog)
redis:del("roog1"..zoog)
redis:del("rooga1"..zoog)
redis:del("rahr1"..zoog)
redis:del("rahrr1"..zoog)
redis:srem("roogg1", msg.sender.user_id)
redis:srem("roogga1", msg.sender.user_id)
redis:del("roog1"..msg.sender.user_id)
redis:del("rooga1"..msg.sender.user_id)
redis:del("rahr1"..msg.sender.user_id)
redis:del("rahrr1"..msg.sender.user_id)
else
bot.sendText(msg.chat_id,msg.id, "⇜ الخلع للزوجات فقط","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "• الخلع للمتزوجات فقط","md",true)
end
end
if text == 'مراهنه' or text == 'مراهنة' then
bot.sendText(msg.chat_id,msg.id, "استعمل الامر كذا :\n\n`مراهنه` المبلغ","md",true)
end
if text and text:match('^مراهنه (.*)$') or text and text:match('^مراهنة (.*)$') then
local UserName = text:match('^مراهنه (.*)$') or text:match('^مراهنة (.*)$')
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local coniss = coin(UserName)
ballancee = redis:get("boob"..msg.sender.user_id) or 0
if tonumber(ballancee) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "⇜ فلوسك لا تكفي \n","md",true)
end
redis:del(MisTiri..'List_rhan'..msg.chat_id)  
redis:set(MisTiri.."playerrhan"..msg.chat_id,msg.sender.user_id)
redis:set(MisTiri.."playercoins"..msg.chat_id..msg.sender.user_id,coniss)
redis:set(MisTiri.."raeahkam"..msg.chat_id,msg.sender.user_id)
redis:sadd(MisTiri..'List_rhan'..msg.chat_id,msg.sender.user_id)
redis:setex(MisTiri.."Start_rhan"..msg.chat_id,3600,true)
redis:set(MisTiri.."allrhan"..msg.chat_id..12345 , coniss)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
rehan = tonumber(ballancee) - tonumber(coniss)
redis:set("boob"..msg.sender.user_id , rehan)
return bot.sendText(msg.chat_id,msg.id,"• تم بدء المراهنة وتم تسجيلك \n• اللي بده يشارك يرسل ( انا والمبلغ ) .","md",true)
end
if text == 'نعم' and redis:get(MisTiri.."Witting_Startrhan"..msg.chat_id) then
rarahkam = redis:get(MisTiri.."raeahkam"..msg.chat_id)
if tonumber(rarahkam) == msg.sender.user_id then
local list = redis:smembers(MisTiri..'List_rhan'..msg.chat_id) 
if #list == 1 then 
return bot.sendText(msg.chat_id,msg.id,"• عذراً لم يشارك احد بالرهان","md",true)  
end 
local UserName = list[math.random(#list)]
local UserId_Info = bot.getUser(UserName)
if UserId_Info.username and UserId_Info.username ~= "" then
ls = '['..UserId_Info.first_name..'](tg://user?id='..UserName..')'
else
ls = '@['..UserId_Info.username..']'
end
benrahan = redis:get(MisTiri.."allrhan"..msg.chat_id..12345) or 0
local ballancee = redis:get("boob"..UserName) or 0
rehan = tonumber(ballancee) + tonumber(benrahan)
redis:set("boob"..UserName , rehan)

local rhan_users = redis:smembers(MisTiri.."List_rhan"..msg.chat_id)
for k,v in pairs(rhan_users) do
redis:del(MisTiri..'playercoins'..msg.chat_id..v)
end
redis:del(MisTiri..'allrhan'..msg.chat_id..12345) 
redis:del(MisTiri..'playerrhan'..msg.chat_id) 
redis:del(MisTiri..'raeahkam'..msg.chat_id) 
redis:del(MisTiri..'List_rhan'..msg.chat_id) 
redis:del(MisTiri.."Witting_Startrhan"..msg.chat_id)
redis:del(MisTiri.."Start_rhan"..msg.chat_id)
local ballancee = redis:get("boob"..UserName) or 0
local convert_mony = string.format("%.0f",benrahan)
local convert_monyy = string.format("%.0f",ballancee)
return bot.sendText(msg.chat_id,msg.id,'⇜ فاز '..ls..' بالرهان 🎊\nالمبلغ : '..convert_mony..' دينار 💵\nرصيدك حاليا : '..convert_monyy..' دينار 💵\n',"md",true)
end
end
if text == 'كنز' then
ballanceed = redis:get("boob"..msg.sender.user_id) or 0
krses = tonumber(redis:get("kreednum"..msg.sender.user_id))
if redis:get("kreed"..msg.sender.user_id) and tonumber(ballanceed) > 5000000 then
return bot.sendText(msg.chat_id,msg.id, "⇜ عليك قرض بقيمة "..krses.." دينار 💵 \nقم بسداده بالامر `تسديد القرض` ","md",true)
end
local F_Name = bot.getUser(msg.sender.user_id).first_name
redis:set(msg.sender.user_id.."first_name:", F_Name)
if redis:sismember("booob",msg.sender.user_id) then
if redis:ttl("yiioooo" .. msg.sender.user_id) >= 60 then
local time = redis:ttl("yiioooo" .. msg.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"⇜ فرصة ايجاد كنز آخر بعد ( "..time.." ثانية )","md",true)
end
local Textinggt = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22","23",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
neews = "["..ban.first_name.."](tg://user?id="..ban.id..")"
else
neews = " لا يوجد "
end
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
if Descriptioont == "1" then
local knez = ballancee + 40000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : قطعة اثرية 🗳\nسعره : 40000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "2" then
local knez = ballancee + 35000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : حجر الليدري 💎\nسعره : 35000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "3" then
local knez = ballancee + 10000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : لباس قديم 🥻\nسعره : 10000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "4" then
local knez = ballancee + 23000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : عصى سحرية 🪄\nسعره : 23000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "5" then
local knez = ballancee + 8000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : جوال نوكيا 📱\nسعره : 8000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "6" then
local knez = ballancee + 27000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : صدف 🏝\nسعره : 27000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "7" then
local knez = ballancee + 18000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : ابريق صدئ ⚗️\nسعره : 18000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "8" then
local knez = ballancee + 100000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : قناع فرعوني 🗿\nسعره : 100000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "9" then
local knez = ballancee + 50000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : جرة ذهب 💰\nسعره : 50000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "10" then
local knez = ballancee + 36000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : مصباح فضي 🔦\nسعره : 36000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "11" then
local knez = ballancee + 29000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : لوحة نحاسية 🌇\nسعره : 29000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "12" then
local knez = ballancee + 1000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : جوارب قديمة 🧦\nسعره : 1000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "13" then
local knez = ballancee + 16000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : اناء فخاري ⚱️\nسعره : 16000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "14" then
local knez = ballancee + 12000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : خوذة محارب 🪖\nسعره : 12000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "15" then
local knez = ballancee + 19000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : سيف جدي مرزوق 🗡\nسعره : 19000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "16" then
local knez = ballancee + 14000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : مكنسة جدتي رقية 🧹\nسعره : 14000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "17" then
local knez = ballancee + 26000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : فأس ارطغرل 🪓\nسعره : 26000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "18" then
local knez = ballancee + 22000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : بندقية 🔫\nسعره : 22000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "19" then
local knez = ballancee + 11000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : كبريت ناري 🪔\nسعره : 11000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "20" then
local knez = ballancee + 33000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : فرو ثعلب 🦊\nسعره : 33000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "21" then
local knez = ballancee + 40000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : جلد تمساح 🐊\nسعره : 40000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "22" then
local knez = ballancee + 17000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : باقة ورود 💐\nسعره : 17000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioont == "23" then
local Textinggtt = {"1", "2",}
local Descriptioontt = Textinggtt[math.random(#Textinggtt)]
if Descriptioontt == "1" then
local knez = ballancee + 17000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : باقة ورود 💐\nسعره : 17000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioontt == "2" then
local Textinggttt = {"1", "2",}
local Descriptioonttt = Textinggttt[math.random(#Textinggttt)]
if Descriptioonttt == "1" then
local knez = ballancee + 40000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : جلد تمساح 🐊\nسعره : 40000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
elseif Descriptioonttt == "2" then
local knez = ballancee + 10000000
redis:set("boob"..msg.sender.user_id , knez)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
bot.sendText(msg.chat_id,msg.id,""..neews.." لقد وجدت كنز\nالكنز : حقيبة محاسب البنك 💼\nسعره : 10000000 دينار 💵\nرصيدك حاليا : "..convert_mony.." دينار 💵\n","md",true)
redis:setex("yiioooo" .. msg.sender.user_id,1800, true)
end
end
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ارسل › ( `انشاء حساب بنكي` )","md",true)
end
end
if text and text:match('^حظر حساب (.*)$') then
local UserName = text:match('^حظر حساب (.*)$')
local coniss = coin(UserName)
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
redis:set("bandid"..coniss,coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ تم حظر الحساب "..coniss.." من لعبة البنك\n","md",true)
end
end
if text and text:match('^الغاء حظر حساب (.*)$') then
local UserName = text:match('^الغاء حظر حساب (.*)$')
local coniss = coin(UserName)
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
redis:del("bandid"..coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ تم الغاء حظر الحساب "..coniss.." من لعبة البنك\n","md",true)
end
end
if text and text:match('^اضف كوبون (.*)$') then
local UserName = text:match('^اضف كوبون (.*)$')
local coniss = coin(UserName)
if tonumber(msg.sender.user_id) == tonumber(sudoid) then
numcobo = math.random(1000000000000,9999999999999);
redis:set("cobonum"..numcobo,numcobo)
redis:set("cobon"..numcobo,coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ وصل كوبون \n\nالمبلغ : "..coniss.." دينار 💵\nرقم الكوبون : `"..numcobo.."`\n\n⇜ طريقة استخدام الكوبون :\nتكتب ( كوبون + رقمه )\nمثال : كوبون 4593875\n","md",true)
end
end
if text == "كوبون" or text == "الكوبون" then
bot.sendText(msg.chat_id,msg.id, "⇜ طريقة استخدام الكوبون :\nتكتب ( كوبون + رقمه )\nمثال : كوبون 4593875\n\n- ملاحظة : الكوبون يستخدم لمرة واحدة ولشخص واحد\n","md",true)
end
if text and text:match('^كوبون (.*)$') then
local UserName = text:match('^كوبون (.*)$')
local coniss = coin(UserName)
if redis:sismember("booob",msg.sender.user_id) then
cobnum = redis:get("cobonum"..coniss)
if coniss == tonumber(cobnum) then
cobblc = redis:get("cobon"..coniss)
ballancee = redis:get("boob"..msg.sender.user_id) or 0
cobonplus = ballancee + cobblc
redis:set("boob"..msg.sender.user_id , cobonplus)
local ballancee = redis:get("boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
redis:del("cobon"..coniss)
redis:del("cobonum"..coniss)
bot.sendText(msg.chat_id,msg.id, "⇜ وصل كوبون \n\nالمبلغ : "..cobblc.." دينار 💵\nرقم الكوبون : `"..coniss.."`\nفلوسك حاليا : "..convert_mony.." دينار 💵\n","md",true)
else
bot.sendText(msg.chat_id,msg.id, "⇜ لا يوجد كوبون بهذا الرقم `"..coniss.."`\n","md",true)
end
else
bot.sendText(msg.chat_id,msg.id, "⇜ انت لا تمتلك حساب بنكي ","md",true)
end
end
if text == "توب" or text == "التوب" then
local toptop = "⇜ أهلاً بك في قوائم التوب\nللمزيد من التفاصيل - [@xXStrem]\n"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'السرقة', data = msg.sender.user_id..'/topzrf'},{text = 'الفلوس', data = msg.sender.user_id..'/topmon'},
},
{
{text = '𝖲𝗈𝗎𝗋c𝖾 xX𝖲𝗍𝗋𝖾𝗆', url="t.me/xXStrem"},
},
}
}
return bot.sendText(msg.chat_id,msg.id,toptop,"md",false, false, false, false, reply_markup)
end
----------------------------------------------------
--نهاية البنك
----------------------------------------------------------------------------------------------------
if text == 'تفعيل' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذراً البوت ليس ادمن في المجموعة*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,msg.sender.user_id)
if not developer(msg) then
if sm.status.luatele ~= "chatMemberStatusCreator" and sm.status.luatele ~= "chatMemberStatusAdministrator" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذراً يجب أنْ تكون مشرف او مالك المجموعة*","md",true)  
return false
end
end
if sm.status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",msg.sender.user_id)
else
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",msg.sender.user_id)
end
if redis:sismember(bot_id..":Groups",msg.chat_id) then
 bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم تفعيل المجموعة سابقا*',"md",true)  
return false
else
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = ' ⌔︙ 𝖲𝗈𝗎𝗋c𝖾 x𝖷𝖲𝗍𝗋𝖾𝗆',url="t.me/xXStrem"}},
}
}
UserInfo = bot.getUser(msg.sender.user_id).first_name
bot.sendText(sudoid,0,'*\n  ⌔︙تم تفعيل مجموعة جديده \n  ⌔︙بواسطة : (*['..UserInfo..'](tg://user?id='..msg.sender.user_id..')*)\n  ⌔︙معلومات المجموعة :\n  ⌔︙عدد الاعضاء : '..Info_Chats.member_count..'\n  ⌔︙عدد الادامن : '..Info_Chats.administrator_count..'\n  ⌔︙عدد المطرودين : '..Info_Chats.banned_count..'\n  ⌔︙عدد المقيدين : '..Info_Chats.restricted_count..'\n  ⌔︙الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم تفعيل المجموعة بنجاح*',"md", true, false, false, false, reply_markup)
redis:sadd(bot_id..":Groups",msg.chat_id)
end
end
if text == 'تعطيل' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذراً البوت ليس ادمن في المجموعة .*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,msg.sender.user_id)
if not developer(msg) then
if sm.status.luatele ~= "chatMemberStatusCreator" then
bot.sendText(msg.chat_id,msg.id,"*  ⌔︙عذراً يجب أنْ تكون مالك المجموعة فقط*","md",true)  
return false
end
end
if redis:sismember(bot_id..":Groups",msg.chat_id) then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
UserInfo = bot.getUser(msg.sender.user_id).first_name
bot.sendText(sudoid,0,'*\n  ⌔︙تم تعطيل المجموعة التاليه : \n  ⌔︙بواسطة : (*['..UserInfo..'](tg://user?id='..msg.sender.user_id..')*)\n  ⌔︙معلومات المجموعة :\n  ⌔︙عدد الاعضاء : '..Info_Chats.member_count..'\n  ⌔︙عدد الادامن : '..Info_Chats.administrator_count..'\n  ⌔︙عدد المطرودين : '..Info_Chats.banned_count..'\n  ⌔︙عدد المقيدين : '..Info_Chats.restricted_count..'\n  ⌔︙الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙تم تعطيل المجموعة بنجاح*',"md",true, false, false, false, reply_markup)
redis:srem(bot_id..":Groups",msg.chat_id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":"..msg.chat_id..":Status:Creator")
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
redis:del(bot_id.."List:Command:"..msg.chat_id)
for i = 1, #keys do 
redis:del(keys[i])
end
return false
else
bot.sendText(msg.chat_id,msg.id,'*  ⌔︙المجموعة معطلة بالفعل*',"md", true)
end
end
----------------------------------------------------------------------------------------------------
end --- end Run
end --- end Run
----------------------------------------------------------------------------------------------------
function Call(data)
if redis:get(bot_id..":Notice") then
if data and data.luatele and data.luatele == "updateSupergroup" then
local Get_Chat = bot.getChat('-100'..data.supergroup.id)
if data.supergroup.status.luatele == "chatMemberStatusBanned" then
redis:srem(bot_id..":Groups",'-100'..data.supergroup.id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Creator")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:BasicConstructor")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Constructor")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Owner")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Administrator")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Vips")
redis:del(bot_id.."List:Command:"..'-100'..data.supergroup.id)
for i = 1, #keys do 
redis:del(keys[i])
end
Get_Chat = bot.getChat('-100'..data.supergroup.id)
Info_Chats = bot.getSupergroupFullInfo('-100'..data.supergroup.id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
return bot.sendText(sudoid,0,'  ⌔︙تم طرد البوت من مجموعة جديده\n  ⌔︙معلومات المجموعة :\n  ⌔︙الايدي : ( -100'..data.supergroup.id..' )\n*  ⌔︙عدد الاعضاء : '..Info_Chats.member_count..'\n  ⌔︙عدد الادامن : '..Info_Chats.administrator_count..'\n  ⌔︙عدد المطرودين : '..Info_Chats.banned_count..'\n  ⌔︙عدد المقيدين : '..Info_Chats.restricted_count..'\n  ⌔︙الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md",true, false, false, false, reply_markup)
end
end
end
print(serpent.block(data, {comment=false}))   
if data and data.luatele and data.luatele == "updateNewMessage" then
if data.message.sender.luatele == "messageSenderChat" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:messageSenderChat") == "del" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
return false
end
end
if data.message.sender.luatele ~= "messageSenderChat" then
if tonumber(data.message.sender.user_id) ~= tonumber(bot_id) then  
if data.message.content.text and data.message.content.text.text:match("^(.*)$") then
if redis:get(bot_id..":"..data.message.chat_id..":"..data.message.sender.user_id..":Command:del") == "true" then
redis:del(bot_id..":"..data.message.chat_id..":"..data.message.sender.user_id..":Command:del")
if redis:get(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text) then
redis:del(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text)
redis:srem(bot_id.."List:Command:"..data.message.chat_id,data.message.content.text.text)
t = "  ⌔︙تم حذف الامر بنجاح"
else
t = "   ⌔︙عذراً الامر  ( "..data.message.content.text.text.." ) غير موجود "
end
bot.sendText(data.message.chat_id,data.message.id,"*"..t.."*","md",true)  
end
end
if data.message.content.text then
local NewCmd = redis:get(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text)
if NewCmd then
data.message.content.text.text = (NewCmd or data.message.content.text.text)
end
end
if data.message.content.text then
td = data.message.content.text.text
if redis:get(bot_id..":TheCh") then
infokl = bot.getChatMember(redis:get(bot_id..":TheCh"),bot_id)
if infokl and infokl.status and infokl.status.luatele == "chatMemberStatusAdministrator" then
if not devS(data.message.sender.user_id) then
if td == "/start" or  td == "ايدي" or  td == "الرابط" or  td == "قفل الكل" or  td == "فتح الكل" or  td == "الاوامر" or  td == "م1" or  td == "م2" or  td == "م3" or  td == "كشف" or  td == "رتبتي" or  td == "المنشئ" or  td == "قفل الصور" or  td == "قفل الالعاب" or  td == "الالعاب" or  td == "العكس" or  td == "روليت" or  td == "كت" or  td == "تنزيل الكل" or  td == "رفع ادمن" or  td == "رفع مميز" or  td == "رفع منشئ" or  td == "المكتومين" or  td == "قفل المتحركات"  then
if bot.getChatMember(redis:get(bot_id..":TheCh"),data.message.sender.user_id).status.luatele == "chatMemberStatusLeft" then
Get_Chat = bot.getChat(redis:get(bot_id..":TheCh"))
Info_Chats = bot.getSupergroupFullInfo(redis:get(bot_id..":TheCh"))
if Info_Chats and Info_Chats.invite_link and Info_Chats.invite_link.invite_link and  Get_Chat and Get_Chat.title then 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = Get_Chat.title,url=Info_Chats.invite_link.invite_link}},
}
}
return bot.sendText(data.message.chat_id,data.message.id,Reply_Status(data.message.sender.user_id,"*  ⌔︙عليك الاشتراك في قناة البوت اولاً !*").yu,"md", true, false, false, false, reply_dev)
end
end
end
end
end
end
end
if redis:sismember(bot_id..":bot:Ban", data.message.sender.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end
end  
if redis:sismember(bot_id..":bot:silent", data.message.sender.user_id) then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end  
if redis:sismember(bot_id..":"..data.message.chat_id..":silent", data.message.sender.user_id) then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})  
end
if redis:sismember(bot_id..":"..data.message.chat_id..":Ban", data.message.sender.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end
end 
if redis:sismember(bot_id..":"..data.message.chat_id..":restrict", data.message.sender.user_id) then    
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
end  
if not Administrator(msg) then
if data.message.content.text then
hash = redis:sismember(bot_id.."mn:content:Text"..data.message.chat_id, data.message.content.text.text)
tu = "الرسالة"
ut = "ممنوعه"
elseif data.message.content.sticker then
hash = redis:sismember(bot_id.."mn:content:Sticker"..data.message.chat_id, data.message.content.sticker.sticker.remote.unique_id)
tu = "الملصق"
ut = "ممنوع"
elseif data.message.content.animation then
hash = redis:sismember(bot_id.."mn:content:Animation"..data.message.chat_id, data.message.content.animation.animation.remote.unique_id)
tu = "المتحركة"
ut = "ممنوعه"
elseif data.message.content.photo then
hash = redis:sismember(bot_id.."mn:content:Photo"..data.message.chat_id, data.message.content.photo.sizes[1].photo.remote.unique_id)
tu = "الصورة"
ut = "ممنوعه"
end
if hash then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
bot.sendText(data.message.chat_id,data.message.id,Reply_Status(data.message.sender.user_id,"*  ⌔︙"..tu.." "..ut.." من المجموعة*").yu,"md",true)  
end
end
if data.message and data.message.content then
if data.message.content.luatele == "messageSticker" or data.message.content.luatele == "messageContact" or data.message.content.luatele == "messageVideoNote" or data.message.content.luatele == "messageDocument" or data.message.content.luatele == "messageVideo" or data.message.content.luatele == "messageAnimation" or data.message.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..data.message.chat_id..":mediaAude:ids",data.message.id)  
end
end
Run(data.message,data)
if data.message.content.text then
if data.message.content.text and not redis:sismember(bot_id..'Spam:Group'..data.message.sender.user_id,data.message.content.text.text) then
redis:del(bot_id..'Spam:Group'..data.message.sender.user_id) 
end
end
if data.message.content.luatele == "messageChatJoinByLink" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "del" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "ked" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink") == "ktm" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "kick" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
end
end
if data.message.content.luatele == "messageChatDeleteMember" or data.message.content.luatele == "messageChatAddMembers" or data.message.content.luatele == "messagePinMessage" or data.message.content.luatele == "messageChatChangeTitle" or data.message.content.luatele == "messageChatJoinByLink" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "del" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "ked" then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr") == "ktm" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "kick" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
end
end 
end
if data.message.content.luatele == "messageChatAddMembers" and redis:get(bot_id..":infobot") then 
if data.message.content.member_user_ids[1] == tonumber(bot_id) then 
local photo = bot.getUserProfilePhotos(bot_id)
kup = bot.replyMarkup{
type = 'inline',data = {
{{text =" ⌔︙ اضفني الى مجموعتك",url="https://t.me/"..bot.getMe().username.."?startgroup=new"}},
}
}
if photo.total_count > 0 then
bot.sendPhoto(data.message.chat_id, data.message.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,"*  ⌔︙اهلا بك في بوت الحماية\n  ⌔︙وضيفتي حماية المجموعات من السبام والتفليش والخ..\n  ⌔︙لتفعيل البوت ارسل كلمه *تفعيل", 'md', nil, nil, nil, nil, nil, nil, nil, nil, nil, kup)
else
bot.sendText(data.message.chat_id,data.message.id,"*  ⌔︙اهلا بك في بوت الحماية \n  ⌔︙وضيفتي حماية المجموعات من السبام والتفليش والخ..\n  ⌔︙لتفعيل البوت ارسل كلمه *تفعيل","md",true, false, false, false, kup)
end
end
end
end
elseif data and data.luatele and data.luatele == "updateMessageEdited" then
local msg = bot.getMessage(data.chat_id, data.message_id)
if tonumber(msg.sender.user_id) ~= tonumber(bot_id) then  
if redis:sismember(bot_id..":bot:silent", msg.sender.user_id) then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end  
if redis:sismember(bot_id..":"..msg.chat_id..":silent", msg.sender.user_id) then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})  
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", msg.sender.user_id) then    
if GetInfoBot(msg).BanUser then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif GetInfoBot(msg).BanUser == false then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end  
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", msg.sender.user_id) then    
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
end  
if not Administrator(msg) then
if msg.content.text then
hash = redis:sismember(bot_id.."mn:content:Text"..msg.chat_id, msg.content.text.text)
tu = "الرسالة"
ut = "ممنوعه"
elseif msg.content.sticker then
hash = redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id, msg.content.sticker.sticker.remote.unique_id)
tu = "الملصق"
ut = "ممنوع"
elseif msg.content.animation then
hash = redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id, msg.content.animation.animation.remote.unique_id)
tu = "المتحركة"
ut = "ممنوعه"
elseif msg.content.photo then
hash = redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id, msg.content.photo.sizes[1].photo.remote.unique_id)
tu = "الصورة"
ut = "ممنوعه"
end
if hash then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*  ⌔︙"..tu.." "..ut.." من المجموعة*").yu,"md",true)  
end
end
Run(msg,data)
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") 
----------------------------------------------------------------------------------------------------
if not BasicConstructor(msg) then
if msg.content.luatele == "messageContact" or msg.content.luatele == "messageVideoNote" or msg.content.luatele == "messageDocument" or msg.content.luatele == "messageAudio" or msg.content.luatele == "messageVideo" or msg.content.luatele == "messageVoiceNote" or msg.content.luatele == "messageAnimation" or msg.content.luatele == "messagePhoto" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Edited") then
if redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
ued = bot.getUser(msg.sender.user_id)
ues = " المستخدم : ["..ued.first_name.."](tg://user?id="..msg.sender.user_id..") "
infome = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
lsme = infome.members
t = "*  ⌔︙قام ( *"..ues.."* ) بتعديل رسالته \nــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ ــ \n*"
for k, v in pairs(lsme) do
if infome.members[k].bot_info == nil then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username ~= "" then
t = t..""..k.."- [@"..UserInfo.username.."]\n"
else
t = t..""..k.."- ["..UserInfo.first_name.."](tg://user?id="..v.member_id.user_id..")\n"
end
end
end
if #lsme == 0 then
t = "*  ⌔︙لا يوجد مشرفين في المجموعة*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
end
end
end
elseif data and data.luatele and data.luatele == "updateNewCallbackQuery" then
Callback(data)
elseif data and data.luatele and data.luatele == "updateMessageSendSucceeded" then
if data.message and data.message.content then
if data.message.content.luatele == "messageSticker" or data.message.content.luatele == "messageContact" or data.message.content.luatele == "messageVideoNote" or data.message.content.luatele == "messageDocument" or data.message.content.luatele == "messageVideo" or data.message.content.luatele == "messageAnimation" or data.message.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..data.message.chat_id..":mediaAude:ids",data.message.id)  
end
end
--
end
----------------------------------------------------------------------------------------------------
end
Runbot.run(Call)
