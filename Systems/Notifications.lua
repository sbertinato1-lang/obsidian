local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)
local Tween = require(script.Parent.Parent.Services.Tween)

local Notifications = {}
Notifications.__index = Notifications

local Container = nil

function Notifications.Init()
    if Container then return end
    
    Container = InstanceUtils.Create("ScreenGui", {
        Name = "Obsidian_Notifications",
        ResetOnSpawn = false,
        DisplayOrder = 200,
        Parent = game:GetService("CoreGui")
    })

    InstanceUtils.Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Container
    })
    InstanceUtils.Create("UIPadding", {
        PaddingBottom = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20),
        Parent = Container
    })
end

function Notifications.Notify(options)
    Notifications.Init()

    local frame = InstanceUtils.Create("Frame", {
        Size = UDim2.new(0, 250, 0, 0),
        BackgroundColor3 = Theme.Get("Secondary"),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = Container
    })
    InstanceUtils.ApplyCorner(frame, Theme.Get("CornerRadius"))
    InstanceUtils.ApplyStroke(frame, Theme.Get("Border"), 1)

    local title = InstanceUtils.Create("TextLabel", {
        Text = options.Title or "Notification",
        Font = Theme.Get("FontTitle"),
        TextSize = Theme.Get("TextSizeTitle"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 20),
        BackgroundTransparency = 1,
        Parent = frame
    })

    local content = InstanceUtils.Create("TextLabel", {
        Text = options.Content or "",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("SecondaryText"),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Position = UDim2.new(0, 10, 0, 25),
        Size = UDim2.new(1, -20, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = frame
    })
    
    InstanceUtils.Create("UIPadding", {
        PaddingBottom = UDim.new(0, 10),
        Parent = frame
    })

    -- Entrance Animation
    frame.Position = UDim2.new(1, 260, 0, 0)
    Tween.Play(frame, {Position = UDim2.new(1, -260, 0, 0)}, 0.3)

    task.delay(options.Duration or 5, function()
        local tween = Tween.Play(frame, {Position = UDim2.new(1, 260, 0, 0)}, 0.3)
        tween.Completed:Wait()
        frame:Destroy()
    end)
end

return Notifications
