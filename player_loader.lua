_G.NEXUS_ADMIN_TOKEN = nil

local H = game:GetService("HttpService")
local UID = tostring(game:GetService("Players").LocalPlayer.UserId)
local rfn = request or http_request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)

if not rfn then
    warn("[NEXUS] Executor sem HTTP.")
    return
end

local ok, res = pcall(rfn, {
    Url = "https://catalogplugins.nvlzskidd.workers.dev/auth/init",
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = '{"uid":"'..UID..'"}'
})

if not ok or not res then
    warn("[NEXUS] Falha de conexão.")
    return
end

local okD, data = pcall(function()
    return H:JSONDecode(res.Body or res.body)
end)

if okD and data and data.token then
    _G.NEXUS_SESSION_TOKEN = data.token
    print("[NEXUS] Sessão OK.")
else
    warn("[NEXUS] Falha ao obter sessão:", data)
    return
end

local URL_MAIN = "https://raw.githubusercontent.com/SEU-USER/Nexus/main/main.lua"
local code = game:HttpGet(URL_MAIN)
local fn, err = loadstring(code)
if fn then
    fn()
else
    warn("[NEXUS] Erro:", err)
end
