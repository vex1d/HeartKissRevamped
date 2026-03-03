local MarketplaceService = game:GetService("MarketplaceService")

local function GetInfo()
	local info = MarketplaceService:GetProductInfoAsync(game.PlaceId)

	for i, v in info do
		print(i, v)
	end

	return info
end

GetInfo()
