local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local LocalPlayer = Players.LocalPlayer

-- Map de jogos: PlaceId -> URL do Script
local Games = {
    [109629391874197] = "https://raw.githubusercontent.com/baixooo/scripts/refs/heads/main/mo.lua", -- Marvel Omega
    [142823291] = "https://raw.githubusercontent.com/baixooo/scripts/refs/heads/main/mm2.lua", -- Murder Mystery 2
    [3082002798] = "https://raw.githubusercontent.com/baixooo/scripts/refs/heads/main/ttb.lua", -- T-Titans Battlegrounds
    [893973440] = "https://raw.githubusercontent.com/baixooo/scripts/refs/heads/main/ftf.lua" -- Flee The Facility
}

-- Dicionário de fallback para garantir traduções exatas
local Translations = {
    ["pt"] = {
        title = "Entre na nossa Comunidade do Discord",
        desc = "Copie o link de convite abaixo para obter acesso e carregar o script.",
        button = "Copiar Convite do Discord e Executar",
        copied = "Copiado! Carregando Script...",
        kick = "Este script não é compatível com este jogo. Por favor, entre em um jogo suportado."
    },
    ["es"] = {
        title = "Únete a nuestra Comunidad de Discord",
        desc = "Copia el enlace de invitación abajo para obtener acceso y cargar el script.",
        button = "Copiar Invitación de Discord y Ejecutar",
        copied = "¡Copiado! Cargando Script...",
        kick = "Este script no es compatible con este juego. Por favor, entra a un juego compatible."
    },
    ["en"] = {
        title = "Join our Discord Community",
        desc = "Copy the invite link below to get access and load the script.",
        button = "Copy Discord Invite & Execute",
        copied = "Copied! Loading Script...",
        kick = "This script is not compatible with this game. Please join a supported game."
    }
}

-- Detecta o idioma do usuário (ex: pt-br -> pt)
local playerLocale = string.sub(LocalizationService.RobloxLocaleId, 1, 2)
local currentLang = Translations[playerLocale] or Translations["en"]

-- Função de Tradução com Fallback
local function GetText(textKey, defaultString)
    local result = defaultString
    pcall(function()
        local translator = LocalizationService:GetTranslatorForPlayerAsync(LocalPlayer)
        result = translator:Translate(game, defaultString)
    end)
    
    -- Se o serviço da Roblox não traduzir, usa o dicionário de fallback
    if result == defaultString and currentLang[textKey] then
        return currentLang[textKey]
    end
    return result
end

local currentPlaceId = game.PlaceId
local scriptUrl = Games[currentPlaceId]

-- 1. Verificação do PlaceId e Kick Traduzido
if not scriptUrl then
    local kickMessage = GetText("kick", "Este script não é compatível com este jogo. Por favor, entre em um jogo suportado.")
    LocalPlayer:Kick(kickMessage)
    return
end

-- Função para definir o parent de forma segura (gethui / CoreGui / PlayerGui)
local function GetSafeParent()
    if gethui then
        return gethui()
    elseif get_hidden_gui then
        return get_hidden_gui()
    elseif CoreGui and pcall(function() local _ = CoreGui.Name end) then
        return CoreGui
    else
        return LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- 2. Criação da UI de Convite do Discord
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DiscordLoaderUI"
screenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(screenGui)
end

screenGui.Parent = GetSafeParent()

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 160)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 31, 34)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = GetText("title", "Join our Discord Community")
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local descLabel = Instance.new("TextLabel")
descLabel.Name = "DescLabel"
descLabel.Size = UDim2.new(1, -20, 0, 35)
descLabel.Position = UDim2.new(0, 10, 0, 40)
descLabel.BackgroundTransparency = 1
descLabel.Text = GetText("desc", "Copy the invite link below to get access and load the script.")
descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
descLabel.TextSize = 13
descLabel.TextWrapped = true
descLabel.Font = Enum.Font.SourceSans
descLabel.Parent = mainFrame

local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Size = UDim2.new(0, 270, 0, 40)
copyButton.Position = UDim2.new(0.5, -135, 1, -50)
copyButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
copyButton.Text = GetText("button", "Copy Discord Invite & Execute")
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 13
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = copyButton

-- 3. Ação ao Clicar no Botão
local discordLink = "https://discord.gg/7FCbjDMKUH"

copyButton.MouseButton1Click:Connect(function()
    -- Copia para a área de transferência do sistema
    if setclipboard then
        setclipboard(discordLink)
    elseif toclipboard then
        toclipboard(discordLink)
    end
    
    -- Atualiza o texto confirmando a cópia
    copyButton.Text = GetText("copied", "Copied! Loading Script...")
    copyButton.BackgroundColor3 = Color3.fromRGB(57, 138, 61)
    
    task.wait(0.8)
    screenGui:Destroy()
    
    -- Executa o script do jogo correspondente
    local success, err = pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)
    
    if not success then
        warn("Erro ao carregar o script:", err)
    end
end)
