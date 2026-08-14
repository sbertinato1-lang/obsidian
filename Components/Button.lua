local Component = require(script.Parent.Parent.Core.Component)
local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)
local Tween = require(script.Parent.Parent.Services.Tween)

local Button = setmetatable({}, Component)
Button.__index = Button

function Button.new(section, options)
    local self = Component.new()
    setmetatable(self, Button)

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Button",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.Button = InstanceUtils.Create("TextButton", {
        Text = options.Name or "Button",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        BackgroundColor3 = Theme.Get("Surface"),
        Size = UDim2.new(1, 0, 1, 0),
        AutoButtonColor = false,
        Parent = self.Instance
    })
    InstanceUtils.ApplyCorner(self.Button, 4)
    InstanceUtils.ApplyStroke(self.Button, Theme.Get("Border"), 1)

    self.Button.MouseEnter:Connect(function()
        Tween.Play(self.Button, {BackgroundColor3 = Theme.Get("Border")})
    end)

    self.Button.MouseLeave:Connect(function()
        Tween.Play(self.Button, {BackgroundColor3 = Theme.Get("Surface")})
    end)

    self.Button.MouseButton1Down:Connect(function()
        Tween.Play(self.Button, {BackgroundColor3 = Theme.Get("Background")})
    end)

    self.Button.MouseButton1Up:Connect(function()
        Tween.Play(self.Button, {BackgroundColor3 = Theme.Get("Border")})
        if options.Callback then
            options.Callback()
        end
    end)

    return self
end

return Button
