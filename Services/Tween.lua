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
