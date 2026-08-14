local UserInputService = game:GetService("UserInputService")
local Component = require(script.Parent.Parent.Core.Component)
local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)
local Tween = require(script.Parent.Parent.Services.Tween)

local Slider = setmetatable({}, Component)
Slider.__index = Slider

function Slider.new(section, options)
    local self = Component.new()
    setmetatable(self, Slider)

    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Value = options.Default or self.Min
    self._dragging = false

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Slider",
        Size = UDim2.new(0.95, 0, 0, 44),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.Label = InstanceUtils.Create("TextLabel", {
        Text = options.Name or "Slider",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -50, 0, 20),
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    self.ValueLabel = InstanceUtils.Create("TextLabel", {
        Text = tostring(self.Value),
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("SecondaryText"),
        TextXAlignment = Enum.TextXAlignment.Right,
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -50, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    self.Track = InstanceUtils.Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 4),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Theme.Get("Surface"),
        BorderSizePixel = 0,
        Parent = self.Instance
    })
    InstanceUtils.ApplyCorner(self.Track, 2)

    self.Fill = InstanceUtils.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Get("Accent"),
        BorderSizePixel = 0,
        Parent = self.Track
    })
    InstanceUtils.ApplyCorner(self.Fill, 2)

    local function update(input)
        local pos = math.clamp((input.Position.X - self.Track.AbsolutePosition.X) / self.Track.AbsoluteSize.X, 0, 1)
        self.Value = math.floor(self.Min + (self.Max - self.Min) * pos)
        
        self.Fill.Size = UDim2.new(pos, 0, 1, 0)
        self.ValueLabel.Text = tostring(self.Value)
        
        if options.Callback then
            options.Callback(self.Value)
        end
    end

    self.Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self._dragging = true
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self._dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if self._dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)

    -- Set initial value
    local initialPos = (self.Value - self.Min) / (self.Max - self.Min)
    self.Fill.Size = UDim2.new(initialPos, 0, 1, 0)

    return self
end

return Slider
