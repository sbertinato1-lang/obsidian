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
