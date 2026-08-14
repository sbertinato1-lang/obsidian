--[[
    Obsidian UI Library - Ultra Loader
    Fetches all modules from GitHub and handles environment injection.
]]

local GITHUB_USER = "sbertinato1-lang" 
local GITHUB_REPO = "Obsidian"
local BRANCH = "main"

-- Cache buster ensures you get the latest version immediately
local CACHE_BUSTER = "?t=" .. tick()
local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/", GITHUB_USER, GITHUB_REPO, BRANCH)

local _modules = {}

local function github_require(name)
    -- Normalize name (change Core.Window to Core/Window)
    name = name:gsub("%.", "/")
    if _modules[name] then return _modules[name] end

    local paths = {
        ["Theme"] = "Theme.lua",
        ["Utils/Cleanup"] = "Utils/Cleanup.lua",
        ["Utils/Instance"] = "Utils/Instance.lua",
        ["Utils/Table"] = "Utils/Table.lua",
        ["Services/Tween"] = "Services/Tween.lua",
        ["Core/Component"] = "Core/Component.lua",
        ["Core/Window"] = "Core/Window.lua",
        ["Systems/Notifications"] = "Systems/Notifications.lua",
        ["Systems/Config"] = "Systems/Config.lua",
        ["Library"] = "Library.lua",
        ["Init"] = "Init.lua",
        ["Components/Label"] = "Components/Label.lua",
        ["Components/Button"] = "Components/Button.lua",
        ["Components/Toggle"] = "Components/Toggle.lua",
        ["Components/Slider"] = "Components/Slider.lua",
        ["Components/Dropdown"] = "Components/Dropdown.lua",
        ["Components/MultiDropdown"] = "Components/MultiDropdown.lua",
        ["Components/Textbox"] = "Components/Textbox.lua",
        ["Components/Keybind"] = "Components/Keybind.lua",
        ["Components/ColorPicker"] = "Components/ColorPicker.lua",
        ["Components/Paragraph"] = "Components/Paragraph.lua",
        ["Components/Separator"] = "Components/Separator.lua",
    }

    local path = paths[name]
    if not path then error("[Obsidian] Path not found for module: " .. tostring(name)) end

    local url = BASE_URL .. path .. CACHE_BUSTER
    local success, content = pcall(function() return game:HttpGet(url) end)

    if not success or not content or content == "404: Not Found" then
        error("[Obsidian] Failed to fetch " .. name .. " from " .. url)
    end

    -- Replace ALL require patterns: require(script.Parent...), require(script.Parent.Parent...)
    -- This handles any amount of whitespace or quotes
    content = content:gsub('require%s*%(%s*script.-%.(.-)%)', function(p)
        return string.format('github_require("%s")', p)
    end)

    local func, err = loadstring(content)
    if not func then error("[Obsidian] Syntax error in " .. name .. ": " .. err) end
    
    -- Inject the loader into the new module's environment
    local env = getfenv(func)
    env.github_require = github_require
    setfenv(func, env)
    
    local result = func()
    _modules[name] = result
    return result
end

print("[Obsidian] Smart Loader Initialized. Fetching Library...")
return github_require("Library")
