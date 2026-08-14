local UserInputService = game:GetService("UserInputService")
local Component = require(script.Parent.Parent.Core.Component)
local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)
local Tween = require(script.Parent.Parent.Services.Tween)

local MultiDropdown = setmetatable({}, Component)
MultiDropdown.__index = MultiDropdown

function MultiDropdown.new(section, options)
    local self = Component.new()
    setmetatable(self, MultiDropdown)

    self.Options = options.Options or {}
    self.Value = options.Default or {}
    self.Opened = false

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "MultiDropdown",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.Button = InstanceUtils.Create("TextButton", {
        Text = "",
        BackgroundColor3 = Theme.Get("Surface"),
        Size = UDim2.new(1, 0, 1, 0),
        AutoButtonColor = false,
        Parent = self.Instance
    })
    InstanceUtils.ApplyCorner(self.Button, 4)
    InstanceUtils.ApplyStroke(self.Button, Theme.Get("Border"), 1)

    self.TitleLabel = InstanceUtils.Create("TextLabel", {
        Text = options.Name or "Multi Dropdown",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, -10, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Button
    })

    self.ValueLabel = InstanceUtils.Create("TextLabel", {
        Text = "...",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("SecondaryText"),
        TextXAlignment = Enum.TextXAlignment.Right,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.5, -30, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Button
    })

    self.Icon = InstanceUtils.Create("TextLabel", {
        Text = "▼",
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = Theme.Get("SecondaryText"),
        Position = UDim2.new(1, -25, 0, 0),
        Size = UDim2.new(0, 20, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Button
    })

    self.Container = InstanceUtils.Create("Frame", {
        Name = "Container",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BackgroundColor3 = Theme.Get("Secondary"),
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10,
        Parent = self.Button
    })
    InstanceUtils.ApplyCorner(self.Container, 4)
    InstanceUtils.ApplyStroke(self.Container, Theme.Get("Border"), 1)

    self.Scroll = InstanceUtils.Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Get("Border"),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Container
    })
    InstanceUtils.Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.Scroll
    })

    local function updateValueLabel()
        local count = 0
        for _ in pairs(self.Value) do count = count + 1 end
        self.ValueLabel.Text = count > 0 and (count .. " selected") or "None"
    end

    local function updateOptions()
        for _, child in pairs(self.Scroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, opt in pairs(self.Options) do
            local isSelected = self.Value[opt]
            local btn = InstanceUtils.Create("TextButton", {
                Text = tostring(opt),
                Font = Theme.Get("FontDescription"),
                TextSize = Theme.Get("TextSizeDescription"),
                TextColor3 = isSelected and Theme.Get("Text") or Theme.Get("SecondaryText"),
                BackgroundColor3 = Theme.Get("Surface"),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                AutoButtonColor = false,
                Parent = self.Scroll
            })

            btn.MouseButton1Click:Connect(function()
                self.Value[opt] = not self.Value[opt]
                if not self.Value[opt] then self.Value[opt] = nil end
                
                updateValueLabel()
                updateOptions()
                
                if options.Callback then
                    options.Callback(self.Value)
                end
            end)
        end

        self.Container.Size = UDim2.new(1, 0, 0, math.min(#self.Options * 28, 140))
    end

    self.Button.MouseButton1Click:Connect(function()
        self.Opened = not self.Opened
        self.Container.Visible = self.Opened
        self.Icon.Text = self.Opened and "▲" or "▼"
    end)

    updateOptions()
    updateValueLabel()

    return self
end

return MultiDropdown
