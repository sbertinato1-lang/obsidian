local Component = require(script.Parent.Parent.Core.Component)
local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)
local Tween = require(script.Parent.Parent.Services.Tween)

local Toggle = setmetatable({}, Component)
Toggle.__index = Toggle

function Toggle.new(section, options)
    local self = Component.new()
    setmetatable(self, Toggle)

    self.Value = options.Default or false

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Toggle",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.Label = InstanceUtils.Create("TextLabel", {
        Text = options.Name or "Toggle",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -40, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    self.Container = InstanceUtils.Create("Frame", {
        Name = "Container",
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, -36, 0.5, -9),
        BackgroundColor3 = Theme.Get("Surface"),
        Parent = self.Instance
    })
    InstanceUtils.ApplyCorner(self.Container, 9)
    InstanceUtils.ApplyStroke(self.Container, Theme.Get("Border"), 1)

    self.Indicator = InstanceUtils.Create("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 3, 0.5, -6),
        BackgroundColor3 = Theme.Get("SecondaryText"),
        Parent = self.Container
    })
    InstanceUtils.ApplyCorner(self.Indicator, 6)

    local function update()
        local targetPos = self.Value and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        local targetColor = self.Value and Theme.Get("Accent") or Theme.Get("SecondaryText")
        
        Tween.Play(self.Indicator, {
            Position = targetPos,
            BackgroundColor3 = targetColor
        })
        
        if options.Callback then
            options.Callback(self.Value)
        end
    end

    self.Instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Value = not self.Value
            update()
        end
    end)

    update()

    return self
end

return Toggle
