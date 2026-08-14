local Component = require(script.Parent.Parent.Core.Component)
local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)

local Separator = setmetatable({}, Component)
Separator.__index = Separator

function Separator.new(section)
    local self = Component.new()
    setmetatable(self, Separator)

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Separator",
        Size = UDim2.new(0.95, 0, 0, 1),
        BackgroundColor3 = Theme.Get("Border"),
        BorderSizePixel = 0,
        Parent = section.Content
    })

    return self
end

return Separator
