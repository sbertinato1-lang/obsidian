-- Obsidian UI Library Bundled
local _modules = {}
local function _require(name)
    name = tostring(name):gsub("script%.Parent%.Parent%.", ""):gsub("script%.Parent%.", ""):gsub("%.", "/")
    if _modules[name] then
        if type(_modules[name]) == "function" then
            _modules[name] = _modules[name]()
        end
        return _modules[name]
    end
    error("Module not found: " .. tostring(name))
end

_modules["Utils/Cleanup"] = function()
local Cleanup = {}
Cleanup.__index = Cleanup

--[[
	A robust memory management class (similar to Maid/Trove).
	Handles cleaning up RBXScriptConnections, Instances, Threads, and functions.
]]

function Cleanup.new()
	local self = setmetatable({
		_tasks = {}
	}, Cleanup)
	return self
end

function Cleanup:Add(task)
	if not task then return end
	table.insert(self._tasks, task)
	return task
end

function Cleanup:Clean()
	for i = #self._tasks, 1, -1 do
		local task = self._tasks[i]
		
		if type(task) == "function" then
			task()
		elseif typeof(task) == "RBXScriptConnection" then
			task:Disconnect()
		elseif typeof(task) == "Instance" then
			task:Destroy()
		elseif type(task) == "thread" then
			task.cancel(task)
		elseif type(task) == "table" and type(task.Destroy) == "function" then
			task:Destroy()
		elseif type(task) == "table" and type(task.Clean) == "function" then
			task:Clean()
		end
		
		self._tasks[i] = nil
	end
end

function Cleanup:Destroy()
	self:Clean()
end

return Cleanup

end

_modules["Utils/Instance"] = function()
local InstanceUtils = {}

--[[
	Wrapper for creating UI instances with properties and children cleanly.
]]

function InstanceUtils.Create(className, properties, children)
	local instance = Instance.new(className)
	
	if properties then
		for k, v in pairs(properties) do
			if k ~= "Parent" then
				instance[k] = v
			end
		end
		
		-- Apply Parent last to avoid unnecessary rendering calculations during setup
		if properties.Parent then
			instance.Parent = properties.Parent
		end
	end
	
	if children then
		for _, child in pairs(children) do
			child.Parent = instance
		end
	end
	
	return instance
end

function InstanceUtils.ApplyCorner(instance, radius)
	if not radius or radius <= 0 then return nil end
	return InstanceUtils.Create("UICorner", {
		CornerRadius = UDim.new(0, radius),
		Parent = instance
	})
end

function InstanceUtils.ApplyStroke(instance, color, thickness, transparency)
	return InstanceUtils.Create("UIStroke", {
		Color = color or Color3.fromRGB(0, 0, 0),
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = instance
	})
end

return InstanceUtils

end

_modules["Utils/Table"] = function()
local TableUtils = {}

--[[
	Utility functions for table manipulation.
]]

function TableUtils.DeepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = TableUtils.DeepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

function TableUtils.Merge(target, source)
	for k, v in pairs(source) do
		if type(v) == "table" and type(target[k]) == "table" then
			TableUtils.Merge(target[k], v)
		else
			target[k] = v
		end
	end
	return target
end

return TableUtils

end

_modules["Utils/Icons"] = function()
return {
	["accessibility"] = "rbxassetid://114029945302017",
	["activity"] = "rbxassetid://94212016861936",
	["app-window"] = "rbxassetid://93142176757189",
	["archive"] = "rbxassetid://122180020814574",
	["arrow-down"] = "rbxassetid://98764963621439",
	["arrow-left"] = "rbxassetid://102531941843733",
	["arrow-right"] = "rbxassetid://113692007244654",
	["arrow-up"] = "rbxassetid://89282378235317",
	["axe"] = "rbxassetid://132405197863294",
	["backpack"] = "rbxassetid://140420225386018",
	["badge-check"] = "rbxassetid://76078495178149",
	["badge-info"] = "rbxassetid://131995373201472",
	["badge-plus"] = "rbxassetid://100325578561866",
	["ban"] = "rbxassetid://90767043015246",
	["bell"] = "rbxassetid://97392696311902",
	["binary"] = "rbxassetid://91751953950088",
	["blocks"] = "rbxassetid://72212693357737",
	["bolt"] = "rbxassetid://102881251417484",
	["bookmark"] = "rbxassetid://121093149326239",
	["bot"] = "rbxassetid://80451686744860",
	["box"] = "rbxassetid://101768155599700",
	["braces"] = "rbxassetid://117761094704041",
	["brackets"] = "rbxassetid://74368995728099",
	["bug"] = "rbxassetid://83626408925438",
	["calculator"] = "rbxassetid://74915716529646",
	["calendar"] = "rbxassetid://114792700814035",
	["camera"] = "rbxassetid://79950339943067",
	["car"] = "rbxassetid://121065933462582",
	["cast"] = "rbxassetid://98202245922071",
	["castle"] = "rbxassetid://119275077187784",
	["chart-bar"] = "rbxassetid://105389816384108",
	["chart-line"] = "rbxassetid://101833156055618",
	["chart-pie"] = "rbxassetid://113412261630136",
	["check"] = "rbxassetid://93898873302694",
	["chevron-down"] = "rbxassetid://134243273101015",
	["chevron-left"] = "rbxassetid://73780377692148",
	["chevron-right"] = "rbxassetid://92473583511724",
	["chevron-up"] = "rbxassetid://122444883127455",
	["circle-alert"] = "rbxassetid://83898160590116",
	["circle-check"] = "rbxassetid://85262178816537",
	["circle-dot"] = "rbxassetid://82947033619201",
	["circle-ellipsis"] = "rbxassetid://91687150884779",
	["circle-minus"] = "rbxassetid://133556159576809",
	["circle-pause"] = "rbxassetid://139337739700879",
	["circle-play"] = "rbxassetid://120408917249739",
	["circle-plus"] = "rbxassetid://113157136350384",
	["circle-power"] = "rbxassetid://140676030155098",
	["circle-question-mark"] = "rbxassetid://97516698664325",
	["circle-stop"] = "rbxassetid://87400503942659",
	["circle-user"] = "rbxassetid://136220511671311",
	["circle-x"] = "rbxassetid://76821953846248",
	["clipboard"] = "rbxassetid://89601995828423",
	["clipboard-check"] = "rbxassetid://92649798577170",
	["clipboard-copy"] = "rbxassetid://125851897718493",
	["clipboard-list"] = "rbxassetid://96460215958908",
	["clock"] = "rbxassetid://121808839832144",
	["cloud"] = "rbxassetid://121226497050352",
	["cloud-download"] = "rbxassetid://121435581993566",
	["cloud-upload"] = "rbxassetid://93307473217005",
	["code"] = "rbxassetid://107380207681249",
	["code-xml"] = "rbxassetid://130150477351734",
	["cog"] = "rbxassetid://116544501716299",
	["coins"] = "rbxassetid://116510979641930",
	["command"] = "rbxassetid://93648221906330",
	["compass"] = "rbxassetid://115123411028382",
	["computer"] = "rbxassetid://77480056459407",
	["copy"] = "rbxassetid://78979572434545",
	["crosshair"] = "rbxassetid://134242818164054",
	["crown"] = "rbxassetid://127843403295538",
	["database"] = "rbxassetid://126791525623846",
	["delete"] = "rbxassetid://126279426372342",
	["download"] = "rbxassetid://134814648082393",
	["drill"] = "rbxassetid://108644821412796",
	["droplet"] = "rbxassetid://100597455015098",
	["ellipsis"] = "rbxassetid://140019550645825",
	["equal"] = "rbxassetid://123467780715624",
	["expand"] = "rbxassetid://137492887754537",
	["external-link"] = "rbxassetid://129331830773832",
	["eye"] = "rbxassetid://100033680381365",
	["eye-off"] = "rbxassetid://135928786788378",
	["file"] = "rbxassetid://74748492079329",
	["file-code"] = "rbxassetid://130978036895504",
	["file-cog"] = "rbxassetid://101385347151368",
	["file-input"] = "rbxassetid://124728604166044",
	["file-key"] = "rbxassetid://118790255921100",
	["file-lock"] = "rbxassetid://72170228691242",
	["file-output"] = "rbxassetid://92146832572911",
	["file-play"] = "rbxassetid://89006821567838",
	["file-search"] = "rbxassetid://97780235974933",
	["file-sliders"] = "rbxassetid://85787771732439",
	["file-terminal"] = "rbxassetid://116757454755476",
	["file-text"] = "rbxassetid://90496405707281",
	["file-user"] = "rbxassetid://99552018455009",
	["file-x"] = "rbxassetid://107333775515154",
	["files"] = "rbxassetid://102806336233202",
	["fingerprint"] = "rbxassetid://112173305232811",
	["fish"] = "rbxassetid://124360663785796",
	["flag"] = "rbxassetid://78183383236196",
	["flame"] = "rbxassetid://98218034436456",
	["focus"] = "rbxassetid://87493973153317",
	["folder"] = "rbxassetid://80846616596607",
	["folder-code"] = "rbxassetid://70624096349370",
	["folder-open"] = "rbxassetid://76018996254888",
	["folder-plus"] = "rbxassetid://91865663406119",
	["folder-search"] = "rbxassetid://110568075123861",
	["folder-x"] = "rbxassetid://91699618247635",
	["forward"] = "rbxassetid://97545944739523",
	["fuel"] = "rbxassetid://106447647274511",
	["fullscreen"] = "rbxassetid://77793665526178",
	["funnel"] = "rbxassetid://108829540827529",
	["gamepad"] = "rbxassetid://121607283959010",
	["gamepad-directional"] = "rbxassetid://84342305212226",
	["gauge"] = "rbxassetid://110273524101447",
	["gem"] = "rbxassetid://112904952151156",
	["ghost"] = "rbxassetid://113822048130017",
	["globe"] = "rbxassetid://114238209622913",
	["hammer"] = "rbxassetid://83545120140895",
	["hard-drive"] = "rbxassetid://88183305858463",
	["heart"] = "rbxassetid://116559368303288",
	["history"] = "rbxassetid://123980022019922",
	["hourglass"] = "rbxassetid://86160434939203",
	["house"] = "rbxassetid://98755624629571",
	["image"] = "rbxassetid://112751259236831",
	["info"] = "rbxassetid://124560466474914",
	["joystick"] = "rbxassetid://99416790224739",
	["key"] = "rbxassetid://96510194465420",
	["keyboard"] = "rbxassetid://121474456068237",
	["layers"] = "rbxassetid://81973586053257",
	["layout-dashboard"] = "rbxassetid://139929981863901",
	["link"] = "rbxassetid://131607023382430",
	["list"] = "rbxassetid://113179976918783",
	["list-check"] = "rbxassetid://72374358471156",
	["loader"] = "rbxassetid://78408734580845",
	["lock"] = "rbxassetid://134724289526879",
	["log-in"] = "rbxassetid://103768533135201",
	["log-out"] = "rbxassetid://84895399304975",
	["map"] = "rbxassetid://95107167260947",
	["map-pin"] = "rbxassetid://84279202219901",
	["maximize"] = "rbxassetid://76045941763188",
	["menu"] = "rbxassetid://77021539815611",
	["message-circle"] = "rbxassetid://127255077587058",
	["mic"] = "rbxassetid://89640799126523",
	["minus"] = "rbxassetid://118026365011536",
	["monitor"] = "rbxassetid://72664649203050",
	["mouse"] = "rbxassetid://73096068864710",
	["mouse-pointer"] = "rbxassetid://72322454962935",
	["move"] = "rbxassetid://116138709011735",
	["network"] = "rbxassetid://127410729922644",
	["package"] = "rbxassetid://97261141732706",
	["palette"] = "rbxassetid://86350350950064",
	["pause"] = "rbxassetid://74873705394436",
	["pen"] = "rbxassetid://72037878096321",
	["percent"] = "rbxassetid://130155041032013",
	["phone"] = "rbxassetid://128804946640049",
	["pickaxe"] = "rbxassetid://105888023317688",
	["pin"] = "rbxassetid://120978111007514",
	["play"] = "rbxassetid://135609604299893",
	["plus"] = "rbxassetid://111774323017047",
	["power"] = "rbxassetid://96479131758775",
	["radio"] = "rbxassetid://85611589536956",
	["refresh-cw"] = "rbxassetid://138133190015277",
	["repeat"] = "rbxassetid://121886242955173",
	["rocket"] = "rbxassetid://87412317685854",
	["rotate-ccw"] = "rbxassetid://110116685948665",
	["rotate-cw"] = "rbxassetid://84183336178654",
	["save"] = "rbxassetid://126116963775616",
	["scan"] = "rbxassetid://123104789658180",
	["search"] = "rbxassetid://121018724060431",
	["send"] = "rbxassetid://127751956873796",
	["server"] = "rbxassetid://92188766517878",
	["settings"] = "rbxassetid://80758916183665",
	["shield"] = "rbxassetid://110987169760162",
	["shield-check"] = "rbxassetid://87354736164608",
	["shield-off"] = "rbxassetid://133426959132690",
	["shopping-cart"] = "rbxassetid://128420521375441",
	["sliders-horizontal"] = "rbxassetid://85538382643347",
	["sparkles"] = "rbxassetid://138635884129147",
	["square"] = "rbxassetid://86304921356806",
	["star"] = "rbxassetid://136141469398409",
	["sun"] = "rbxassetid://110150589884127",
	["sword"] = "rbxassetid://124448418211665",
	["swords"] = "rbxassetid://81872698913435",
	["target"] = "rbxassetid://87563802520297",
	["terminal"] = "rbxassetid://106783148545356",
	["timer"] = "rbxassetid://85473888890506",
	["toggle-left"] = "rbxassetid://85887872573050",
	["toggle-right"] = "rbxassetid://90411952142550",
	["trash"] = "rbxassetid://106723740584310",
	["trophy"] = "rbxassetid://131545003268773",
	["upload"] = "rbxassetid://138212042425501",
	["user"] = "rbxassetid://81589895647169",
	["users"] = "rbxassetid://115398113982385",
	["video"] = "rbxassetid://107587444636945",
	["volume"] = "rbxassetid://103236289817396",
	["volume-2"] = "rbxassetid://89344380902620",
	["wallet"] = "rbxassetid://132331555762628",
	["wand"] = "rbxassetid://114580617777835",
	["wrench"] = "rbxassetid://112148279212860",
	["x"] = "rbxassetid://110786993356448",
	["zap"] = "rbxassetid://130551565616516",
	["zoom-in"] = "rbxassetid://127956924984803",
	["zoom-out"] = "rbxassetid://108334162607319",
}

end

_modules["Services/Tween"] = function()
local TweenService = game:GetService("TweenService")

local Tween = {}

--[[
	Wrapper for TweenService to standardize animations and manage memory cleanly.
]]

function Tween.Create(instance, properties, duration, easingStyle, easingDirection)
	duration = duration or 0.15
	easingStyle = easingStyle or Enum.EasingStyle.Sine
	easingDirection = easingDirection or Enum.EasingDirection.Out
	
	local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
	local tween = TweenService:Create(instance, tweenInfo, properties)
	
	return tween
end

function Tween.Play(instance, properties, duration, easingStyle, easingDirection)
	local tween = Tween.Create(instance, properties, duration, easingStyle, easingDirection)
	tween:Play()
	
	-- Return tween so it can be managed by Cleanup if needed
	return tween
end

return Tween

end

_modules["Theme"] = function()
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
	TextSizeWindow       = 16,
	TextSizeCategory     = 14,
	TextSizeTab          = 12,
	TextSizeTitle        = 13,
	TextSizeDescription  = 12,
	
	-- Geometry & Spacing
	CornerRadius     = 0,
	BorderThickness  = 1,
	
	Padding          = 14,
	SectionSpacing   = 10,
	ElementSpacing   = 8,
	
	-- Component Dimensions
	WindowSize       = UDim2.new(0, 500, 0, 500),
	HeaderHeight     = 42,
	SidebarWidth     = 170,
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

end

_modules["Core/Component"] = function()
local Cleanup = _require("Utils/Cleanup")

local Component = {}
Component.__index = Component

--[[
	Base class for all UI components.
	Provides consistent initialization and memory management.
]]

function Component.new()
	local self = setmetatable({
		_cleanup = Cleanup.new(),
		Instance = nil,
		Value = nil,
		Enabled = true,
		Visible = true,
	}, Component)
	
	return self
end

function Component:SetValue(value)
	self.Value = value
	-- To be overridden by subclass
end

function Component:GetValue()
	return self.Value
end

function Component:SetVisible(visible)
	self.Visible = visible
	if self.Instance then
		self.Instance.Visible = visible
	end
end

function Component:SetEnabled(enabled)
	self.Enabled = enabled
	-- To be overridden by subclass for visual state changes
end

function Component:Destroy()
	self._cleanup:Destroy()
	-- The _cleanup handles destroying self.Instance if we add it to the cleanup tasks
	setmetatable(self, nil)
end

return Component

end

_modules["Systems/Notifications"] = function()
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")
local Tween = _require("Services/Tween")

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

end

_modules["Systems/Config"] = function()
local HttpService = game:GetService("HttpService")

local Config = {}
Config.__index = Config

function Config.new(library, options)
    local self = setmetatable({
        Library = library,
        Folder = options.Folder or "ObsidianConfigs",
        File = options.File or "default.json",
        Settings = {}
    }, Config)

    return self
end

function Config:Save(data)
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)

    if not success then return end

    if writefile then
        if not isfolder(self.Folder) then
            makefolder(self.Folder)
        end
        writefile(self.Folder .. "/" .. self.File, encoded)
    else
        warn("[Obsidian] writefile not supported in this environment.")
    end
end

function Config:Load()
    if readfile and isfile(self.Folder .. "/" .. self.File) then
        local success, content = pcall(function()
            return readfile(self.Folder .. "/" .. self.File)
        end)

        if success then
            local success2, decoded = pcall(function()
                return HttpService:JSONDecode(content)
            end)
            if success2 then
                self.Settings = decoded
                return decoded
            end
        end
    end
    return nil
end

return Config

end

_modules["Components/Label"] = function()
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")

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
        RichText = true,
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

end

_modules["Components/Paragraph"] = function()
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")

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
        RichText = true,
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

end

_modules["Components/Button"] = function()
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")
local Tween = _require("Services/Tween")

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
        RichText = true,
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

end

_modules["Components/Toggle"] = function()
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")
local Tween = _require("Services/Tween")

local Toggle = setmetatable({}, Component)
Toggle.__index = Toggle

function Toggle.new(section, options)
    local self = Component.new()
    setmetatable(self, Toggle)

    self.Value = options.Default or false

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Toggle",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.Label = InstanceUtils.Create("TextLabel", {
        Text = options.Name or "Toggle",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true,
        Size = UDim2.new(1, -40, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    self.Container = InstanceUtils.Create("Frame", {
        Name = "Container",
        Size = UDim2.new(0, 36, 0, 18),
        Position = UDim2.new(1, -36, 0.5, -9),
        BackgroundColor3 = Theme.Get("Surface"),
        Parent = self.Instance
    })
    InstanceUtils.ApplyCorner(self.Container, 9)
    InstanceUtils.ApplyStroke(self.Container, Theme.Get("Border"), 1)

    self.Indicator = InstanceUtils.Create("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 3, 0.5, -6),
        BackgroundColor3 = Theme.Get("SecondaryText"),
        Parent = self.Container
    })
    InstanceUtils.ApplyCorner(self.Indicator, 6)

    local function update()
        local targetPos = self.Value and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        local targetColor = self.Value and Theme.Get("Accent") or Theme.Get("SecondaryText")
        
        Tween.Play(self.Indicator, {
            Position = targetPos,
            BackgroundColor3 = targetColor
        })
        
        if options.Callback then
            options.Callback(self.Value)
        end
    end

    self.Instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Value = not self.Value
            update()
        end
    end)

    update()

    return self
end

return Toggle

end

_modules["Components/Slider"] = function()
local UserInputService = game:GetService("UserInputService")
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")
local Tween = _require("Services/Tween")

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
        RichText = true,
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
        RichText = true,
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

end

_modules["Components/Dropdown"] = function()
local UserInputService = game:GetService("UserInputService")
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")
local Tween = _require("Services/Tween")

local Dropdown = setmetatable({}, Component)
Dropdown.__index = Dropdown

function Dropdown.new(section, options)
    local self = Component.new()
    setmetatable(self, Dropdown)

    self.Options = options.Options or {}
    self.Value = options.Default or self.Options[1]
    self.Opened = false

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Dropdown",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        ClipsDescendants = false,
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
        Text = options.Name or "Dropdown",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, -10, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = self.Button
    })

    self.ValueLabel = InstanceUtils.Create("TextLabel", {
        Text = tostring(self.Value),
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("SecondaryText"),
        TextXAlignment = Enum.TextXAlignment.Right,
        RichText = true,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.5, -30, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 5,
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
        ZIndex = 5,
        Parent = self.Button
    })

    self.Container = InstanceUtils.Create("Frame", {
        Name = "Container",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BackgroundColor3 = Theme.Get("Secondary"),
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 100,
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

    local function updateOptions()
        for _, child in pairs(self.Scroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, opt in pairs(self.Options) do
            local btn = InstanceUtils.Create("TextButton", {
                Text = tostring(opt),
                Font = Theme.Get("FontDescription"),
                TextSize = Theme.Get("TextSizeDescription"),
                TextColor3 = opt == self.Value and Theme.Get("Text") or Theme.Get("SecondaryText"),
                BackgroundColor3 = Theme.Get("Surface"),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                AutoButtonColor = false,
                Parent = self.Scroll
            })

            btn.MouseButton1Click:Connect(function()
                self.Value = opt
                self.ValueLabel.Text = tostring(opt)
                self:Toggle(false)
                if options.Callback then
                    options.Callback(opt)
                end
                updateOptions()
            end)
        end

        self.Container.Size = UDim2.new(1, 0, 0, math.min(#self.Options * 28, 140))
    end

    function self:Toggle(state)
        self.Opened = state
        self.Container.Visible = state
        self.Icon.Text = state and "▲" or "▼"
        -- In a real lib, we'd handle ZIndex of the whole section here too
    end

    self.Button.MouseButton1Click:Connect(function()
        self:Toggle(not self.Opened)
    end)

    updateOptions()

    return self
end

return Dropdown

end

_modules["Components/MultiDropdown"] = function()
local UserInputService = game:GetService("UserInputService")
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")
local Tween = _require("Services/Tween")

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
        RichText = true,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, -10, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = self.Button
    })

    self.ValueLabel = InstanceUtils.Create("TextLabel", {
        Text = "...",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("SecondaryText"),
        TextXAlignment = Enum.TextXAlignment.Right,
        RichText = true,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.5, -30, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 5,
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
        ZIndex = 5,
        Parent = self.Button
    })

    self.Container = InstanceUtils.Create("Frame", {
        Name = "Container",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BackgroundColor3 = Theme.Get("Secondary"),
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 100,
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

end

_modules["Components/Textbox"] = function()
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")
local Tween = _require("Services/Tween")

local Textbox = setmetatable({}, Component)
Textbox.__index = Textbox

function Textbox.new(section, options)
    local self = Component.new()
    setmetatable(self, Textbox)

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Textbox",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.Label = InstanceUtils.Create("TextLabel", {
        Text = options.Name or "Textbox",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true,
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    self.InputContainer = InstanceUtils.Create("Frame", {
        Name = "InputContainer",
        Size = UDim2.new(0.5, -5, 0, 24),
        Position = UDim2.new(0.5, 5, 0.5, -12),
        BackgroundColor3 = Theme.Get("Surface"),
        Parent = self.Instance
    })
    InstanceUtils.ApplyCorner(self.InputContainer, 4)
    InstanceUtils.ApplyStroke(self.InputContainer, Theme.Get("Border"), 1)

    self.Input = InstanceUtils.Create("TextBox", {
        Text = options.Default or "",
        PlaceholderText = options.Placeholder or "Type here...",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        PlaceholderColor3 = Theme.Get("SecondaryText"),
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        ClearTextOnFocus = options.ClearOnFocus or false,
        Parent = self.InputContainer
    })

    self.Input.FocusLost:Connect(function(enterPressed)
        if options.Callback then
            options.Callback(self.Input.Text, enterPressed)
        end
    end)

    return self
end

return Textbox

end

_modules["Components/Keybind"] = function()
local UserInputService = game:GetService("UserInputService")
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")
local Tween = _require("Services/Tween")

local Keybind = setmetatable({}, Component)
Keybind.__index = Keybind

function Keybind.new(section, options)
    local self = Component.new()
    setmetatable(self, Keybind)

    self.Value = options.Default or Enum.KeyCode.F
    self.Binding = false

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "Keybind",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.Label = InstanceUtils.Create("TextLabel", {
        Text = options.Name or "Keybind",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true,
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    self.Button = InstanceUtils.Create("TextButton", {
        Text = self.Value.Name,
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("SecondaryText"),
        BackgroundColor3 = Theme.Get("Surface"),
        Size = UDim2.new(0, 60, 0, 22),
        Position = UDim2.new(1, -60, 0.5, -11),
        AutoButtonColor = false,
        Parent = self.Instance
    })
    InstanceUtils.ApplyCorner(self.Button, 4)
    InstanceUtils.ApplyStroke(self.Button, Theme.Get("Border"), 1)

    local function startBinding()
        self.Binding = true
        self.Button.Text = "..."
        self.Button.TextColor3 = Theme.Get("Accent")
    end

    local function stopBinding(key)
        self.Binding = false
        self.Value = key
        self.Button.Text = key.Name
        self.Button.TextColor3 = Theme.Get("SecondaryText")
        if options.Callback then
            options.Callback(key)
        end
    end

    self.Button.MouseButton1Click:Connect(function()
        startBinding()
    end)

    UserInputService.InputBegan:Connect(function(input)
        if self.Binding then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                stopBinding(input.KeyCode)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                -- Optional: handle mouse buttons as binds
            end
        elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self.Value then
            if options.Callback then
                options.Callback(self.Value)
            end
        end
    end)

    return self
end

return Keybind

end

_modules["Components/ColorPicker"] = function()
local UserInputService = game:GetService("UserInputService")
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")
local Tween = _require("Services/Tween")

local ColorPicker = setmetatable({}, Component)
ColorPicker.__index = ColorPicker

function ColorPicker.new(section, options)
    local self = Component.new()
    setmetatable(self, ColorPicker)

    self.Value = options.Default or Color3.fromRGB(255, 255, 255)
    self.Opened = false

    self.Instance = InstanceUtils.Create("Frame", {
        Name = "ColorPicker",
        Size = UDim2.new(0.95, 0, 0, Theme.Get("ComponentHeight")),
        BackgroundTransparency = 1,
        Parent = section.Content
    })

    self.Label = InstanceUtils.Create("TextLabel", {
        Text = options.Name or "Color Picker",
        Font = Theme.Get("FontDescription"),
        TextSize = Theme.Get("TextSizeDescription"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true,
        Size = UDim2.new(1, -40, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.Instance
    })

    self.Button = InstanceUtils.Create("TextButton", {
        Text = "",
        BackgroundColor3 = self.Value,
        Size = UDim2.new(0, 30, 0, 18),
        Position = UDim2.new(1, -30, 0.5, -9),
        AutoButtonColor = false,
        Parent = self.Instance
    })
    InstanceUtils.ApplyCorner(self.Button, 4)
    InstanceUtils.ApplyStroke(self.Button, Theme.Get("Border"), 1)

    -- Color Picker UI
    self.PickerFrame = InstanceUtils.Create("Frame", {
        Name = "Picker",
        Size = UDim2.new(0, 150, 0, 100),
        Position = UDim2.new(1, 5, 0, 0),
        BackgroundColor3 = Theme.Get("Secondary"),
        Visible = false,
        ZIndex = 50,
        Parent = self.Button
    })
    InstanceUtils.ApplyCorner(self.PickerFrame, 4)
    InstanceUtils.ApplyStroke(self.PickerFrame, Theme.Get("Border"), 1)

    local grid = InstanceUtils.Create("Frame", {
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        Parent = self.PickerFrame
    })
    InstanceUtils.Create("UIGridLayout", {
        CellSize = UDim2.new(0, 22, 0, 22),
        Padding = UDim2.new(0, 4, 0, 4),
        Parent = grid
    })

    local colors = {
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200), Color3.fromRGB(100, 100, 100), Color3.fromRGB(50, 50, 50),
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 128, 0), Color3.fromRGB(128, 0, 255)
    }

    for _, color in pairs(colors) do
        local colorBtn = InstanceUtils.Create("TextButton", {
            Text = "",
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            Parent = grid
        })
        InstanceUtils.ApplyCorner(colorBtn, 2)
        
        colorBtn.MouseButton1Click:Connect(function()
            self:SetValue(color)
            self.PickerFrame.Visible = false
            self.Opened = false
            if options.Callback then
                options.Callback(color)
            end
        end)
    end

    self.Button.MouseButton1Click:Connect(function()
        self.Opened = not self.Opened
        self.PickerFrame.Visible = self.Opened
    end)

    return self
end

function ColorPicker:SetValue(color)
    self.Value = color
    self.Button.BackgroundColor3 = color
end

return ColorPicker

end

_modules["Components/Separator"] = function()
local Component = _require("Core/Component")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")

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

end

_modules["Core/Window"] = function()
local UserInputService = game:GetService("UserInputService")
local Theme = _require("Theme")
local InstanceUtils = _require("Utils/Instance")
local Tween = _require("Services/Tween")
local Cleanup = _require("Utils/Cleanup")

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
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
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
        ClipsDescendants = true,
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
    
    -- Title & Info
    self.Title = InstanceUtils.Create("TextLabel", {
        Name = "Title",
        Text = options.Title:upper(),
        Font = Theme.Get("FontWindow"),
        TextSize = Theme.Get("TextSizeWindow"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true,
        Position = UDim2.new(0, 24, 0, 0),
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
            Size = UDim2.new(0, 36, 0, 36),
            Position = UDim2.new(1, -40 * (#self.Controls:GetChildren() + 1), 0.5, -18),
            Text = text,
            Font = Enum.Font.Gotham,
            TextSize = 20,
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
        Expanded = true,
        Tabs = {},
        _cleanup = Cleanup.new()
    }

    -- Category Container for proper layout pushing
    category.Container = InstanceUtils.Create("Frame", {
        Name = name .. "_Category",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = self.SidebarContent
    })
    InstanceUtils.Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = category.Container
    })

    category.Button = InstanceUtils.Create("TextButton", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = "",
        Parent = category.Container
    })

    category.Label = InstanceUtils.Create("TextLabel", {
        Text = name:upper(),
        Font = Theme.Get("FontCategory"),
        TextSize = Theme.Get("TextSizeCategory"),
        TextColor3 = Theme.Get("Text"),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Parent = category.Button
    })

    category.Icon = InstanceUtils.Create("TextLabel", {
        Text = "▼",
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = Theme.Get("SecondaryText"),
        TextXAlignment = Enum.TextXAlignment.Right,
        Size = UDim2.new(1, -15, 1, 0),
        BackgroundTransparency = 1,
        Parent = category.Button
    })

    category.TabHolder = InstanceUtils.Create("Frame", {
        Name = "Tabs",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = category.Container
    })
    InstanceUtils.Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = category.TabHolder
    })

    local function toggle()
        category.Expanded = not category.Expanded
        category.Icon.Text = category.Expanded and "▼" or "►"
        category.TabHolder.Visible = category.Expanded
    end

    category.Button.MouseButton1Click:Connect(toggle)

    function category:CreateTab(tabName, icon)
        local tab = self._window:CreateTab(tabName, icon)
        tab.Button.Parent = category.TabHolder
        
        -- Adjust tab button style for sub-item look
        tab.Button.Size = UDim2.new(1, -35, 0, 28)
        tab.Button.Position = UDim2.new(0, 30, 0, 0)
        tab.Button.TextSize = Theme.Get("TextSizeTab")
        tab.Button.TextColor3 = Theme.Get("SecondaryText")
        
        table.insert(category.Tabs, tab)
        return tab
    end
    
    category._window = self
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
            local component = _require("Components/Label").new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddButton(options)
            local component = _require("Components/Button").new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddToggle(options)
            local component = _require("Components/Toggle").new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddSlider(options)
            local component = _require("Components/Slider").new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddDropdown(options)
            local component = _require("Components/Dropdown").new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddMultiDropdown(options)
            local component = _require("Components/MultiDropdown").new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddTextbox(options)
            local component = _require("Components/Textbox").new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddKeybind(options)
            local component = _require("Components/Keybind").new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddColorPicker(options)
            local component = _require("Components/ColorPicker").new(self, options)
            table.insert(self.Components, component)
            return component
        end

        function section:AddSeparator()
            local component = _require("Components/Separator").new(self)
            table.insert(self.Components, component)
            return component
        end

        function section:AddParagraph(options)
            local component = _require("Components/Paragraph").new(self, options)
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

end

_modules["Library"] = function()
local Theme = _require("Theme")
local Cleanup = _require("Utils/Cleanup")
local Window = _require("Core/Window")
local Notifications = _require("Systems/Notifications")
local Config = _require("Systems/Config")
local Icons = _require("Utils/Icons")
local UserInputService = game:GetService("UserInputService")

--[[
	Core UI Manager for Obsidian.
]]

local Library = {}
Library.__index = Library
Library.Icons = Icons

function Library.new()
	local self = setmetatable({
		_cleanup = Cleanup.new(),
		Windows = {},
		ToggleKey = Enum.KeyCode.RightControl,
		Visible = true
	}, Library)

	-- Global Visibility Toggle
	UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.KeyCode == self.ToggleKey then
			self:Toggle()
		end
	end)

	return self
end

function Library:CreateWindow(options)
	options = options or {}
	options.Title = options.Title or "Obsidian"
	options.Badge = options.Badge or ""
	options.Version = options.Version or ""
	
	local window = Window.new(options)
	self._cleanup:Add(window)
	table.insert(self.Windows, window)
	return window
end

function Library:Notify(options)
	Notifications.Notify(options)
end

function Library:CreateConfig(options)
	return Config.new(self, options)
end

function Library:SetToggleKey(key)
	self.ToggleKey = key
end

function Library:Toggle()
	self.Visible = not self.Visible
	for _, window in pairs(self.Windows) do
		window:SetVisible(self.Visible)
	end
end

function Library:SetTheme(themeConfig)
	Theme.Set(themeConfig)
end

function Library:Destroy()
	self._cleanup:Destroy()
end

-- Create a singleton instance for global access if needed, or return the class
return Library.new()

end

return _modules["Library"]()
