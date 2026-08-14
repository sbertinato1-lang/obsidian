# Obsidian UI Library

A high-performance, dark-themed UI library for Roblox with a focus on minimalism and efficiency.

## Usage

```lua
local Obsidian = loadstring(game:HttpGet("https://raw.githubusercontent.com/user/repo/main/Init.lua"))()

-- Create a Window
local Window = Obsidian:CreateWindow({
    Title = "Obsidian",
    Badge = "v1.0.0",
    Version = "Alpha"
})

-- Create a Tab
local Tab = Window:CreateTab("Main")

-- Create a Section
local Section = Tab:CreateSection("Settings")

-- Add Components
Section:AddLabel({ Text = "Hello World!" })
Section:AddButton({ Name = "Click Me", Callback = function() print("Clicked!") end })
Section:AddToggle({ Name = "Enable Feature", Default = true, Callback = function(v) print("Toggle:", v) end })
Section:AddSlider({ Name = "Speed", Min = 0, Max = 100, Default = 50, Callback = function(v) print("Slider:", v) end })

-- Notifications
Obsidian:Notify({
    Title = "Welcome",
    Content = "Obsidian UI loaded successfully.",
    Duration = 5
})
```

## Public API

### `Obsidian`
- `CreateWindow(options)`: Returns a new Window.
- `Notify(options)`: Sends a global notification.
- `SetTheme(themeConfig)`: Updates the global theme.
- `SetToggleKey(keyCode)`: Sets the global visibility toggle key (Default: RightControl).
- `CreateConfig(options)`: Returns a Config manager.

### `Window`
- `CreateCategory(name)`: Adds a text category in the sidebar.
- `CreateTab(name, icon)`: Adds a new tab to the sidebar.
- `Destroy()`: Destroys the window and all associated UI.

### `Tab`
- `CreateSection(title)`: Adds a titled section to the page.

### `Section`
- `AddLabel({Text})`
- `AddParagraph({Text})`
- `AddButton({Name, Callback})`
- `AddToggle({Name, Default, Callback})`
- `AddSlider({Name, Min, Max, Default, Callback})`
- `AddDropdown({Name, Options, Default, Callback})`
- `AddMultiDropdown({Name, Options, Default, Callback})`
- `AddTextbox({Name, Default, Placeholder, Callback})`
- `AddKeybind({Name, Default, Callback})`
- `AddColorPicker({Name, Default, Callback})`
- `AddSeparator()`

## Styling
- Dark monochrome palette
- 1px borders
- 6px corner radius
- Gotham typography
- Minimal animations
