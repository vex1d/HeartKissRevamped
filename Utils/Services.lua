local Services = {}
local serviceCache = {}

function Services:Get(serviceName)
    if serviceCache[serviceName] then return serviceCache[serviceName] end
    
    local success, service = pcall(function()
        return game:GetService(serviceName)
    end)
    
    if success then
        serviceCache[serviceName] = service
        return service
    end
    return nil
end

return Services 
