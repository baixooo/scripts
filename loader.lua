-- loader fodastico, não é mesmo?
local DISCORD_INVITE = "https://discord.gg/7FCbjDMKUH"

-- mapa de placeIds --> URLs
local SCRIPTS = {
 [109629391874197] = "https://raw.githubusercontent.com/baixooo/scripts/refs/heads/main/mo.lua", -- Marvel Omega
 [142823291] = "https://raw.githubusercontent.com/baixooo/scripts/refs/heads/main/mm2.lua", -- Murder Mystery 2
 [121255181515820] = "https://raw.githubusercontent.com/baixooo/scripts/refs/heads/main/pcdkkkkkkkkkkkk.lua", -- Pillar Chase Recode
 [3082002798] = "https://raw.githubusercontent.com/baixooo/scripts/refs/heads/main/ttb.lua", -- T-Titans Battlegrounds
 [893973440] = "https://raw.githubusercontent.com/baixooo/scripts/refs/heads/main/ftf.lua", -- Flee The Facility
}

-- detecção de locale
local function getLocale()
 local locale = "en"
 pcall(function()
  locale = game:GetService("LocalizationService").RobloxLocaleId:lower()
 end)
 return locale
end

-- mensagens traduzidas (linha única — Roblox corta em \n\n)
local function getLocalizedKickMessage(locale)
 local msgs = {
  ["pt-br"] = "❌ Jogo incorreto! Este script não funciona aqui. Vá para o jogo correto para usá-lo.",
  ["pt"] = "❌ Jogo incorreto! Este script não funciona aqui. Vá para o jogo correto para usá-lo.",
  ["es"] = "❌ ¡Juego incorrecto! Este script no funciona aquí. Ve al juego correcto para usarlo.",
  ["es-es"] = "❌ ¡Juego incorrecto! Este script no funciona aquí. Ve al juego correcto para usarlo.",
  ["fr"] = "❌ Mauvais jeu ! Ce script ne fonctionne pas ici. Allez sur le bon jeu pour l'utiliser.",
  ["de"] = "❌ Falsches Spiel! Dieses Skript funktioniert hier nicht. Gehe zum richtigen Spiel, um es zu benutzen.",
  ["it"] = "❌ Gioco sbagliato! Questo script non funziona qui. Vai al gioco corretto per usarlo.",
  ["ru"] = "❌ Неверная игра! Этот скрипт здесь не работает. Перейдите в правильную игру, чтобы использовать его.",
  ["pl"] = "❌ Zła gra! Ten skrypt tu nie działa. Przejdź do właściwej gry, aby go użyć.",
  ["tr"] = "❌ Yanlış oyun! Bu betik burada çalışmıyor. Kullanmak için doğru oyuna gidin.",
  ["ja"] = "❌ 間違ったゲームです！このスクリプトはここでは動作しません。正しいゲームで使用してください。",
  ["ko"] = "❌ 잘못된 게임입니다! 이 스크립트는 여기서 작동하지 않습니다. 올바른 게임에서 사용하세요.",
  ["zh-cn"] = "❌ 错误的游戏！此脚本无法在此运行。请前往正确的游戏使用。",
  ["zh-tw"] = "❌ 錯誤的遊戲！此腳本無法在此執行。請前往正確的遊戲使用。",
  ["id"] = "❌ Game salah! Script ini tidak berfungsi di sini. Pergi ke game yang benar untuk menggunakannya.",
  ["hi"] = "❌ गलत गेम! यह स्क्रिप्ट यहाँ काम नहीं करती। इसका उपयोग करने के लिए सही गेम पर जाएँ।",
  ["ar"] = "❌ لعبة خاطئة! هذا السكريبت لا يعمل هنا. اذهب إلى اللعبة الصحيحة لاستخدامه.",
  ["th"] = "❌ เกมผิด! สคริปต์นี้ไม่ทำงานที่นี่ ไปที่เกมที่ถูกต้องเพื่อใช้งาน",
  ["vi"] = "❌ Sai trò chơi! Script này không hoạt động ở đây. Hãy đến đúng trò chơi để sử dụng.",
 }

 for key, msg in pairs(msgs) do
  if locale:sub(1, #key) == key then
   return msg
  end
 end
 return "❌ Wrong game! This script doesn't work here. Go to the correct game to use it."
end

-- mensagem de clipboard traduzida
local function getLocalizedClipboardMessage(locale)
 local msgs = {
  ["pt-br"] = "Entre no Discord para saber quais jogos são suportados",
  ["pt"] = "Entre no Discord para saber quais jogos são suportados",
  ["es"] = "Únete al Discord para saber qué juegos son compatibles",
  ["es-es"] = "Únete al Discord para saber qué juegos son compatibles",
  ["fr"] = "Rejoignez le Discord pour savoir quels jeux sont pris en charge",
  ["de"] = "Tritt dem Discord bei, um zu erfahren, welche Spiele unterstützt werden",
  ["it"] = "Unisciti al Discord per sapere quali giochi sono supportati",
  ["ru"] = "Присоединяйтесь к Discord, чтобы узнать, какие игры поддерживаются",
  ["pl"] = "Dołącz do Discorda, aby dowiedzieć się, które gry są obsługiwane",
  ["tr"] = "Hangi oyunların desteklendiğini öğrenmek için Discord'a katılın",
  ["ja"] = "サポートされているゲームを確認するにはDiscordに参加してください",
  ["ko"] = "지원되는 게임을 확인하려면 Discord에 참여하세요",
  ["zh-cn"] = "加入Discord了解支持哪些游戏",
  ["zh-tw"] = "加入Discord了解支援哪些遊戲",
  ["id"] = "Bergabunglah dengan Discord untuk mengetahui game mana yang didukung",
  ["hi"] = "जानें कि कौन से गेम समर्थित हैं, इसके लिए Discord से जुड़ें",
  ["ar"] = "انضم إلى Discord لمعرفة الألعاب المدعومة",
  ["th"] = "เข้าร่วม Discord เพื่อดูว่าเกมใดรองรับบ้าง",
  ["vi"] = "Tham gia Discord để biết những trò chơi nào được hỗ trợ",
 }

 for key, msg in pairs(msgs) do
  if locale:sub(1, #key) == key then
   return msg
  end
 end
 return "Join the Discord to know which games are supported"
end

-- verificação de placeId
local placeId = game.PlaceId
local scriptUrl = SCRIPTS[placeId]

if not scriptUrl then
 local locale = getLocale()
 local kickMsg = getLocalizedKickMessage(locale)
 local clipMsg = getLocalizedClipboardMessage(locale)

 -- copia mensagem traduzida + convite
 pcall(function()
  local text = clipMsg .. "\n" .. DISCORD_INVITE
  if setclipboard then
   setclipboard(text)
  elseif toclipboard then
   toclipboard(text)
  end
 end)

 pcall(function()
  game:GetService("Players").LocalPlayer:Kick(kickMsg)
 end)
 return
end

-- GUI: convite do discord + botão de copiar
local function buildUI()
 local parent
 local ok = pcall(function()
  if gethui then
   parent = gethui()
  end
 end)
 if not ok or not parent then
  parent = game:GetService("CoreGui")
 end

 local old = parent:FindFirstChild("DiscordGateLoader")
 if old then old:Destroy() end

 local gui = Instance.new("ScreenGui")
 gui.Name = "DiscordGateLoader"
 gui.ResetOnSpawn = false
 gui.IgnoreGuiInset = true
 gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 gui.Parent = parent

 local frame = Instance.new("Frame")
 frame.Name = "Main"
 frame.Size = UDim2.new(0, 340, 0, 180)
 frame.Position = UDim2.new(0.5, -170, 0.5, -90)
 frame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
 frame.BorderSizePixel = 0
 frame.Active = true
 frame.Draggable = true
 frame.Parent = gui

 local corner = Instance.new("UICorner")
 corner.CornerRadius = UDim.new(0, 10)
 corner.Parent = frame

 local stroke = Instance.new("UIStroke")
 stroke.Color = Color3.fromRGB(88, 101, 242)
 stroke.Thickness = 2
 stroke.Parent = frame

 local title = Instance.new("TextLabel")
 title.Size = UDim2.new(1, -20, 0, 30)
 title.Position = UDim2.new(0, 10, 0, 12)
 title.BackgroundTransparency = 1
 title.Text = "Join our Discord"
 title.TextColor = Color3.fromRGB(255, 255, 255)
 title.Font = Enum.Font.GothamBold
 title.TextSize = 18
 title.TextXAlignment = Enum.TextXAlignment.Left
 title.Parent = frame

 local link = Instance.new("TextLabel")
 link.Size = UDim2.new(1, -20, 0, 24)
 link.Position = UDim2.new(0, 10, 0, 46)
 link.BackgroundTransparency = 1
 link.Text = DISCORD_INVITE
 link.TextColor = Color3.fromRGB(88, 101, 242)
 link.Font = Enum.Font.GothamMedium
 link.TextSize = 14
 link.TextXAlignment = Enum.TextXAlignment.Left
 link.Parent = frame

 local hint = Instance.new("TextLabel")
 hint.Size = UDim2.new(1, -20, 0, 20)
 hint.Position = UDim2.new(0, 10, 0, 74)
 hint.BackgroundTransparency = 1
 hint.Text = "Click the button below to copy the invite and load the script."
 hint.TextColor = Color3.fromRGB(180, 180, 185)
 hint.Font = Enum.Font.Gotham
 hint.TextSize = 12
 hint.TextWrapped = true
 hint.TextXAlignment = Enum.TextXAlignment.Left
 hint.Parent = frame

 local button = Instance.new("TextButton")
 button.Size = UDim2.new(1, -20, 0, 42)
 button.Position = UDim2.new(0, 10, 1, -56)
 button.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
 button.BorderSizePixel = 0
 button.Text = "Copy Discord Invite"
 button.TextColor = Color3.fromRGB(255, 255, 255)
 button.Font = Enum.Font.GothamBold
 button.TextSize = 15
 button.AutoButtonColor = false
 button.Parent = frame

 local btnCorner = Instance.new("UICorner")
 btnCorner.CornerRadius = UDim.new(0, 8)
 btnCorner.Parent = button

 button.MouseEnter:Connect(function()
  button.BackgroundColor3 = Color3.fromRGB(110, 122, 255)
 end)
 button.MouseLeave:Connect(function()
  button.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
 end)

 return gui, button
end

-- execução do script
local function loadRealScript()
 local ok, err = pcall(function()
  local src = game:HttpGet(scriptUrl)
  local fn = loadstring(src)
  if fn then
   fn()
  else
   error("Falha ao compilar script remoto.")
  end
 end)
 if not ok then
  warn("[Loader] Erro ao executar script:", err)
 end
end

-- fluxo principal
local gui, copyBtn = buildUI()

copyBtn.MouseButton1Click:Connect(function()
 pcall(function()
  if setclipboard then
   setclipboard(DISCORD_INVITE)
  elseif toclipboard then
   toclipboard(DISCORD_INVITE)
  end
 end)

 copyBtn.Text = "Copied! Loading..."
 copyBtn.BackgroundColor3 = Color3.fromRGB(87, 242, 135)
 copyBtn.Active = false

 task.wait(0.8)
 gui:Destroy()
 loadRealScript()
end)
