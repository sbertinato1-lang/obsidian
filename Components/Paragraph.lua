local Component = require(script.Parent.Parent.Core.Component)
local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)

local Paragraph = setmetatable({}, Component)
Paragraph.__index = Paragraph

function Paragraph.new(section, options)
    local self = Component.new()
    setmetatable(self, Paragraph)

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Paragraph",
        Size = UDim2.new(0.95, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = section.Content
    })

    self.TextLabel = InstanceUtils.Create("TextLabel", {
        Text = options.Text or "Paragraph text goes here.",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("SecondaryText"),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    return self
end

function Paragraph:SetText(text)
    self.TextLabel.Text = text
end

return Paragraph
