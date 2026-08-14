local UserInputService = game:GetService("UserInputService")
local Component = require(script.Parent.Parent.Core.Component)
local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)
local Tween = require(script.Parent.Parent.Services.Tween)

local Keybind = setmetatable({}, Component)
Keybind.__index = Keybind

function Keybind.new(section, options)
    local self = Component.new()
    setmetatable(self, Keybind)

    self.Value = options.Default or Enum.KeyCode.F
    self.Binding = false

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Keybind",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.Label = InstanceUtils.Create("TextLabel", {
        Text = options.Name or "Keybind",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    self.Button = InstanceUtils.Create("TextButton", {
        Text = self.Value.Name,
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("SecondaryText"),
        BackgroundColor3 = Theme.Get("Surface"),
        Size = UDim2.new(0, 60, 0, 22),
        Position = UDim2.new(1, -60, 0.5, -11),
        AutoButtonColor = false,
        Parent = self.Instance
    })
    InstanceUtils.ApplyCorner(self.Button, 4)
    InstanceUtils.ApplyStroke(self.Button, Theme.Get("Border"), 1)

    local function startBinding()
        self.Binding = true
        self.Button.Text = "..."
        self.Button.TextColor3 = Theme.Get("Accent")
    end

    local function stopBinding(key)
        self.Binding = false
        self.Value = key
        self.Button.Text = key.Name
        self.Button.TextColor3 = Theme.Get("SecondaryText")
        if options.Callback then
            options.Callback(key)
        end
    end

    self.Button.MouseButton1Click:Connect(function()
        startBinding()
    end)

    UserInputService.InputBegan:Connect(function(input)
        if self.Binding then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                stopBinding(input.KeyCode)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                -- Optional: handle mouse buttons as binds
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.Value then
            if options.Callback then
                options.Callback(self.Value)
            end
        end
    end)

    return self
end

return Keybind
