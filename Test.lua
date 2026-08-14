local Obsidian = require(game:GetService("ReplicatedStorage"):WaitForChild("Obsidian"):WaitForChild("Init"))

-- Create a Window
local Window = Obsidian:CreateWindow({
    Title = "Obsidian Test",
    Badge = "v1.0.0",
    Version = "Alpha"
})

-- Sidebar Category
Window:CreateCategory("General")

-- Main Tab
local MainTab = Window:CreateTab("Main")
local MainSection = MainTab:CreateSection("Information")

MainSection:AddLabel({ Text = "This is a Label" })
MainSection:AddParagraph({ Text = "This is a paragraph component used for longer descriptions or instructions within the UI." })
MainSection:AddSeparator()

MainSection:AddButton({ 
    Name = "Click Me", 
    Callback = function() 
        Obsidian:Notify({
            Title = "Success",
            Content = "Button was clicked!",
            Duration = 3
        })
    end 
})

MainSection:AddToggle({ 
    Name = "Toggle Feature", 
    Default = true, 
    Callback = function(v) 
        print("Toggle value:", v) 
    end 
})

-- Controls Tab
local ControlsTab = Window:CreateTab("Controls")
local InputSection = ControlsTab:CreateSection("Inputs")

InputSection:AddSlider({ 
    Name = "Slider Test", 
    Min = 0, 
    Max = 100, 
    Default = 50, 
    Callback = function(v) 
        print("Slider:", v) 
    end 
})

InputSection:AddTextbox({ 
    Name = "Text Input", 
    Placeholder = "Enter text...", 
    Callback = function(t) 
        print("Textbox:", t) 
    end 
})

InputSection:AddDropdown({ 
    Name = "Selection", 
    Options = {"Option 1", "Option 2", "Option 3"}, 
    Default = "Option 1", 
    Callback = function(v) 
        print("Selected:", v) 
    end 
})

InputSection:AddMultiDropdown({ 
    Name = "Multi Selection", 
    Options = {"A", "B", "C"}, 
    Default = {A = true}, 
    Callback = function(v) 
        print("Multi Selected counts items...") 
    end 
})

InputSection:AddKeybind({ 
    Name = "Toggle Key", 
    Default = Enum.KeyCode.RightControl, 
    Callback = function(key) 
        print("New keybind:", key) 
    end 
})

InputSection:AddColorPicker({ 
    Name = "Accent Color", 
    Default = Color3.fromRGB(255, 255, 255), 
    Callback = function(c) 
        print("Color selected") 
    end 
})

-- Notifications
Obsidian:Notify({
    Title = "Obsidian UI",
    Content = "Local test script initialized successfully.",
    Duration = 5
})
