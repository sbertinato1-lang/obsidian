local Component = require(script.Parent.Parent.Core.Component)
local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)

local Label = setmetatable({}, Component)
Label.__index = Label

function Label.new(section, options)
    local self = Component.new()
    setmetatable(self, Label)

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Label",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.TextLabel = InstanceUtils.Create("TextLabel", {
        Text = options.Text or "Label",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    return self
end

function Label:SetText(text)
    self.TextLabel.Text = text
end

return Label
