local UserInputService = game:GetService("UserInputService")
local Theme = require(script.Parent.Parent.Theme)
local InstanceUtils = require(script.Parent.Parent.Utils.Instance)
local Tween = require(script.Parent.Parent.Services.Tween)
local Cleanup = require(script.Parent.Parent.Utils.Cleanup)

local Window = {}
Window.__index = Window

function Window.new(options)
    local self = setmetatable({
        _cleanup = Cleanup.new(),
        _tabs = {},
        _currentTab = nil,
        _dragging = false,
        _dragStart = nil,
        _startPos = nil
    }, Window)

    -- Root GUI
    self.ScreenGui = InstanceUtils.Create("ScreenGui", {
        Name = "Obsidian_" .. options.Title,
        ResetOnSpawn = false,
        DisplayOrder = 100,
        Parent = game:GetService("CoreGui")
    })
    self._cleanup:Add(self.ScreenGui)

    -- Main Window
    self.Main = InstanceUtils.Create("Frame", {
        Name = "Main",
        Size = Theme.Get("WindowSize"),
        Position = UDim2.new(0.5, -Theme.Get("WindowSize").X.Offset/2, 0.5, -Theme.Get("WindowSize").Y.Offset/2),
        BackgroundColor3 = Theme.Get("Background"),
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    InstanceUtils.ApplyCorner(self.Main, Theme.Get("CornerRadius"))
    InstanceUtils.ApplyStroke(self.Main, Theme.Get("Border"), Theme.Get("BorderThickness"))

    -- Header
    self.Header = InstanceUtils.Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, Theme.Get("HeaderHeight")),
        BackgroundColor3 = Theme.Get("Secondary"),
        BorderSizePixel = 0,
        Parent = self.Main
    })
    InstanceUtils.ApplyCorner(self.Header, Theme.Get("CornerRadius")) -- Corner mask will be tricky, maybe just use a flat frame top
    
    -- Title & Info
    self.Title = InstanceUtils.Create("TextLabel", {
        Name = "Title",
        Text = options.Title:upper(),
        Font = Theme.Get("FontWindow"),
        TextSize = Theme.Get("TextSizeWindow"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Parent = self.Header
    })

    if options.Badge and options.Badge ~= "" then
        self.Badge = InstanceUtils.Create("Frame", {
            Name = "Badge",
            BackgroundColor3 = Theme.Get("Surface"),
            BorderSizePixel = 0,
            Parent = self.Header
        })
        InstanceUtils.ApplyCorner(self.Badge, 4)
        InstanceUtils.ApplyStroke(self.Badge, Theme.Get("Border"), 1)

        local badgeLabel = InstanceUtils.Create("TextLabel", {
            Text = options.Badge,
            Font = Theme.Get("FontDescription"),
            TextSize = 10,
            TextColor3 = Theme.Get("SecondaryText"),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = self.Badge
        })

        self.Badge.Size = UDim2.new(0, badgeLabel.TextBounds.X + 8, 0, 18)
        self.Badge.Position = UDim2.new(0, self.Title.Position.X.Offset + self.Title.TextBounds.X + 8, 0.5, -9)
    end

    -- Controls
    self.Controls = InstanceUtils.Create("Frame", {
        Name = "Controls",
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(1, -100, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.Header
    })

    local function createControl(name, text, color, callback)
        local btn = InstanceUtils.Create("TextButton", {
            Name = name,
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -35 * (#self.Controls:GetChildren() + 1), 0.5, -15),
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 16,
            TextColor3 = color or Theme.Get("SecondaryText"),
            BackgroundTransparency = 1,
            Parent = self.Controls
        })
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    createControl("Close", "×", Color3.fromRGB(200, 50, 50), function() self:Destroy() end)
    createControl("Minimize", "−", nil, function() self:SetVisible(not self.Main.Visible) end)

    -- Sidebar
    self.Sidebar = InstanceUtils.Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, Theme.Get("SidebarWidth"), 1, -Theme.Get("HeaderHeight")),
        Position = UDim2.new(0, 0, 0, Theme.Get("HeaderHeight")),
        BackgroundColor3 = Theme.Get("Secondary"),
        BorderSizePixel = 0,
        Parent = self.Main
    })
    
    self.SidebarContent = InstanceUtils.Create("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, -10),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Sidebar
    })
    InstanceUtils.Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.SidebarContent
    })

    -- Container
    self.Container = InstanceUtils.Create("Frame", {
        Name = "Container",
        Size = UDim2.new(1, -Theme.Get("SidebarWidth"), 1, -Theme.Get("HeaderHeight")),
        Position = UDim2.new(0, Theme.Get("SidebarWidth"), 0, Theme.Get("HeaderHeight")),
        BackgroundColor3 = Theme.Get("Background"),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.Main
    })

    -- Dragging Logic
    self.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self._dragging = true
            self._dragStart = input.Position
            self._startPos = self.Main.Position

            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    self._dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if self._dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - self._dragStart
            self.Main.Position = UDim2.new(
                self._startPos.X.Scale,
                self._startPos.X.Offset + delta.X,
                self._startPos.Y.Scale,
                self._startPos.Y.Offset + delta.Y
            )
        end
    end)

    return self
end

function Window:CreateCategory(name)
    local category = {
        Name = name,
        _cleanup = Cleanup.new()
    }

    category.Label = InstanceUtils.Create("TextLabel", {
        Text = name:upper(),
        Font = Theme.Get("FontCategory"),
        TextSize = Theme.Get("TextSizeCategory"),
        TextColor3 = Theme.Get("SecondaryText"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -10, 0, 24),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.SidebarContent
    })

    return category
end

function Window:CreateTab(name, icon)
    local tab = {
        Name = name,
        Sections = {},
        _cleanup = Cleanup.new()
    }

    -- Tab Button in Sidebar
    tab.Button = InstanceUtils.Create("TextButton", {
        Name = name,
        Size = UDim2.new(1, -10, 0, 32),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundColor3 = Theme.Get("Surface"),
        BackgroundTransparency = 1,
        Text = name,
        Font = Theme.Get("FontTab"),
        TextSize = Theme.Get("TextSizeTab"),
        TextColor3 = Theme.Get("SecondaryText"),
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        Parent = self.SidebarContent
    })
    InstanceUtils.ApplyCorner(tab.Button, 4)
    InstanceUtils.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        Parent = tab.Button
    })

    -- Tab Page in Container
    tab.Page = InstanceUtils.Create("ScrollingFrame", {
        Name = name .. "_Page",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Get("Border"),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.Container
    })
    InstanceUtils.Create("UIListLayout", {
        Padding = UDim.new(0, Theme.Get("SectionSpacing")),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tab.Page
    })
    InstanceUtils.Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = tab.Page
    })

    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)

    table.insert(self._tabs, tab)
    if not self._currentTab then
        self:SelectTab(tab)
    end

    function tab:CreateSection(title)
        local section = {
            Title = title,
            Components = {},
            _cleanup = Cleanup.new()
        }

        section.Frame = InstanceUtils.Create("Frame", {
            Name = title,
            Size = UDim2.new(0.95, 0, 0, 0),
            BackgroundColor3 = Theme.Get("Secondary"),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = tab.Page
        })
        InstanceUtils.ApplyCorner(section.Frame, Theme.Get("CornerRadius"))
        InstanceUtils.ApplyStroke(section.Frame, Theme.Get("Border"), 1)

        section.Content = InstanceUtils.Create("Frame", {
            Name = "Content",
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = section.Frame
        })
        InstanceUtils.Create("UIListLayout", {
            Padding = UDim.new(0, Theme.Get("ElementSpacing")),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = section.Content
        })
        InstanceUtils.Create("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 10),
            Parent = section.Content
        })

        section.TitleLabel = InstanceUtils.Create("TextLabel", {
            Text = title:upper(),
            Font = Theme.Get("FontTitle"),
            TextSize = Theme.Get("TextSizeTitle"),
            TextColor3 = Theme.Get("Text"),
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundTransparency = 1,
            Parent = section.Frame
        })

        function section:AddLabel(options)
            local component = require(script.Parent.Parent.Components.Label).new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddButton(options)
            local component = require(script.Parent.Parent.Components.Button).new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddToggle(options)
            local component = require(script.Parent.Parent.Components.Toggle).new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddSlider(options)
            local component = require(script.Parent.Parent.Components.Slider).new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddDropdown(options)
            local component = require(script.Parent.Parent.Components.Dropdown).new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddMultiDropdown(options)
            local component = require(script.Parent.Parent.Components.MultiDropdown).new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddTextbox(options)
            local component = require(script.Parent.Parent.Components.Textbox).new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddKeybind(options)
            local component = require(script.Parent.Parent.Components.Keybind).new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddColorPicker(options)
            local component = require(script.Parent.Parent.Components.ColorPicker).new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddSeparator()
            local component = require(script.Parent.Parent.Components.Separator).new(self)
            table.insert(self.Components, component)
            return component
        end

        function section:AddParagraph(options)
            local component = require(script.Parent.Parent.Components.Paragraph).new(self, options)
            table.insert(self.Components, component)
            return component
        end
        
        return section
    end

    return tab
end

function Window:SelectTab(tab)
    if self._currentTab then
        self._currentTab.Page.Visible = false
        Tween.Play(self._currentTab.Button, {
            BackgroundTransparency = 1,
            TextColor3 = Theme.Get("SecondaryText")
        })
    end

    self._currentTab = tab
    tab.Page.Visible = true
    Tween.Play(tab.Button, {
        BackgroundTransparency = 0,
        TextColor3 = Theme.Get("Text")
    })
end

function Window:SetVisible(visible)
    self.Main.Visible = visible
end

function Window:Destroy()
    self._cleanup:Destroy()
end

return Window
