local Component = require(script.Parent.Parent.Core.Component)
local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)
local Tween = require(script.Parent.Parent.Services.Tween)

local Textbox = setmetatable({}, Component)
Textbox.__index = Textbox

function Textbox.new(section, options)
    local self = Component.new()
    setmetatable(self, Textbox)

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Textbox",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.Label = InstanceUtils.Create("TextLabel", {
        Text = options.Name or "Textbox",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    self.InputContainer = InstanceUtils.Create("Frame", {
        Name = "InputContainer",
        Size = UDim2.new(0.5, -5, 0, 24),
        Position = UDim2.new(0.5, 5, 0.5, -12),
        BackgroundColor3 = Theme.Get("Surface"),
        Parent = self.Instance
    })
    InstanceUtils.ApplyCorner(self.InputContainer, 4)
    InstanceUtils.ApplyStroke(self.InputContainer, Theme.Get("Border"), 1)

    self.Input = InstanceUtils.Create("TextBox", {
        Text = options.Default or "",
        PlaceholderText = options.Placeholder or "Type here...",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        PlaceholderColor3 = Theme.Get("SecondaryText"),
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        ClearTextOnFocus = options.ClearOnFocus or false,
        Parent = self.InputContainer
    })

    self.Input.FocusLost:Connect(function(enterPressed)
        if options.Callback then
            options.Callback(self.Input.Text, enterPressed)
        end
    end)

    return self
end

return Textbox
