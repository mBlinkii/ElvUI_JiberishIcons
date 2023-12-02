local AddOnName, Engine = ...
_G[AddOnName] = Engine

local E = unpack(ElvUI)
local module = E:NewModule(AddOnName)
module.Version = GetAddOnMetadata(AddOnName, 'Version')
module.Title = GetAddOnMetadata(AddOnName, 'Title')
module.Configs = {}

local iconStyles = Engine.iconStyles
local minSize, maxSize = Engine.iconMinSize, Engine.iconMaxSize
local classIcon, classIcons = Engine.classIcon, Engine.classIcons

local function GetOptions()
	for _, func in pairs(module.Configs) do
		func()
	end
end

for iconStyle, tagTitle in next, iconStyles do
	local tag = format('%s:%s', 'jiberish:icon', iconStyle)

	E:AddTag(tag, 'PLAYER_TARGET_CHANGED', function(unit, _, args)
		if not UnitIsPlayer(unit) then return end
	
		local size = strsplit(':', args or '')
		size = (size and size >= minSize and size <= maxSize) and size or '64'	
		local _, class = UnitClass(unit)
		local icon = classIcons[class]

		if icon then
			return format(classIcon, iconStyle, size, size, icon)
		end
	end)
	
	local description = format("This tag will display the %s icon style from Jiberish's class icon plugin!", tagTitle or '')
	E:AddTagInfo(tag, 'Jiberish', description)
end

function module:Initialize()
	E.Libs.EP:RegisterPlugin(AddOnName, GetOptions)
end

E.Libs.EP:HookInitialize(module, module.Initialize)
