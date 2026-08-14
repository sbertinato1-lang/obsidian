--[[
    Obsidian UI Library - Smart Loader
    This file acts as the entry point for executors.
    It automatically fetches all necessary modules from GitHub.
]]

local GITHUB_USER = "sbertinato1-lang" -- Set this to your actual username
local GITHUB_REPO = "Obsidian"
local BRANCH = "main"

local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/", GITHUB_USER, GITHUB_REPO, BRANCH)

local _modules = {}

local function github_require(name)
    if _modules[name] then
        return _modules[name]
    end

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
        -- Components
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
    if not path then error("[Obsidian] Unknown module: " .. name) end

    local success, content = pcall(function()
        return game:HttpGet(BASE_URL .. path)
    end)

    if not success or not content then
        error("[Obsidian] Failed to fetch: " .. name .. " from " .. BASE_URL .. path)
    end

    -- ROBUST REPLACEMENT: This catches require(script.Parent...), require(script.Parent.Parent...), etc.
    content = content:gsub('require%s*%(%s*script%.Parent%.Parent%.(.-)%)', function(p)
        return string.format('github_require("%s")', p:gsub('%.', '/'))
    end)
    content = content:gsub('require%s*%(%s*script%.Parent%.(.-)%)', function(p)
        return string.format('github_require("%s")', p:gsub('%.', '/'))
    end)

    local func, err = loadstring(content)
    if not func then error("[Obsidian] Syntax error in " .. name .. ": " .. err) end
    
    -- Inject loader into the module's environment
    local env = getfenv(func)
    env.github_require = github_require
    setfenv(func, env)
    
    local result = func()
    _modules[name] = result
    return result
end

-- Start by loading the Library
return github_require("Library")
