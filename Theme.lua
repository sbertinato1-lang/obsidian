local Theme = {}

--[[
	Centralized visual constants for the Obsidian UI library.
	All components should consume these values rather than hardcoding.
]]

Theme.Default = {
	-- Colors
	Background       = Color3.fromRGB(13, 14, 17),
	Secondary        = Color3.fromRGB(17, 18, 22),
	Surface          = Color3.fromRGB(21, 23, 27),
	Border           = Color3.fromRGB(29, 31, 36),
	
	Text             = Color3.fromRGB(230, 231, 234),
	SecondaryText    = Color3.fromRGB(135, 137, 144),
	DisabledText     = Color3.fromRGB(82, 84, 89),
	
	Accent           = Color3.fromRGB(220, 220, 225),
	
	-- Typography
	FontWindow       = Enum.Font.GothamMedium,
	FontCategory     = Enum.Font.GothamSemibold,
	FontTab          = Enum.Font.GothamMedium,
	FontTitle        = Enum.Font.GothamMedium,
	FontDescription  = Enum.Font.Gotham,
	
	-- Text Sizes
	TextSizeWindow       = 14,
	TextSizeCategory     = 13,
	TextSizeTab          = 13,
	TextSizeTitle        = 13,
	TextSizeDescription  = 12,
	
	-- Geometry & Spacing
	CornerRadius     = 6,
	BorderThickness  = 1,
	
	Padding          = 12,
	SectionSpacing   = 8,
	ElementSpacing   = 6,
	
	-- Component Dimensions
	WindowSize       = UDim2.new(0, 650, 0, 400),
	HeaderHeight     = 36,
	SidebarWidth     = 160,
	ComponentHeight  = 32,
	
	-- Animations
	AnimDuration     = 0.15,
}

Theme.Current = Theme.Default

function Theme.Set(newTheme)
	for k, v in pairs(newTheme) do
		Theme.Current[k] = v
	end
end

function Theme.Get(key)
	return Theme.Current[key]
end

return Theme
