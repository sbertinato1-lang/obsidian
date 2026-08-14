--[[
    Obsidian UI Library - Smart Loader
    This file acts as the entry point for executors.
    It automatically fetches all necessary modules from GitHub.
]]

local GITHUB_USER = "sbertinato1-lang" -- USER: PLEASE CHANGE THIS TO YOUR GITHUB USERNAME
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
    if not path then error("Unknown module: " .. name) end

    local success, content = pcall(function()
        return game:HttpGet(BASE_URL .. path)
    end)

    if not success or not content then
        error("Failed to fetch module from GitHub: " .. name .. " at " .. BASE_URL .. path)
    end

    -- Transformation logic to make standard requires work with this loader
    content = content:gsub('require%(script%.Parent%.Parent%.Theme%)', 'github_require("Theme")')
    content = content:gsub('require%(script%.Parent%.Parent%.Utils%.Cleanup%)', 'github_require("Utils/Cleanup")')
    content = content:gsub('require%(script%.Parent%.Parent%.Utils%.Instance%)', 'github_require("Utils/Instance")')
    content = content:gsub('require%(script%.Parent%.Parent%.Services%.Tween%)', 'github_require("Services/Tween")')
    content = content:gsub('require%(script%.Parent%.Parent%.Core%.Component%)', 'github_require("Core/Component")')
    content = content:gsub('require%(script%.Parent%.Parent%.Systems%.Notifications%)', 'github_require("Systems/Notifications")')
    content = content:gsub('require%(script%.Parent%.Parent%.Systems%.Config%)', 'github_require("Systems/Config")')
    content = content:gsub('require%(script%.Parent%.Parent%.Components%.(.-)%)', 'github_require("Components/%1")')
    content = content:gsub('require%(script%.Parent%.Theme%)', 'github_require("Theme")')
    content = content:gsub('require%(script%.Parent%.Utils%.Cleanup%)', 'github_require("Utils/Cleanup")')
    content = content:gsub('require%(script%.Parent%.Core%.Window%)', 'github_require("Core/Window")')
    content = content:gsub('require%(script%.Parent%.Library%)', 'github_require("Library")')

    local func, err = loadstring(content)
    if not func then error("Failed to compile " .. name .. ": " .. err) end
    
    -- Set the environment so the module can call github_require
    local env = getfenv(func)
    env.github_require = github_require
    setfenv(func, env)
    
    local result = func()
    _modules[name] = result
    return result
end

-- Start by loading the Library module
return github_require("Library")
