local DestroyOnKeys = {}

registerComponent(DestroyOnKeys, "DestroyOnKeys")

function DestroyOnKeys:setup(...)
    self.keys = {...}
end

function DestroyOnKeys:onKeyPress(key, scancode, wasRelease)
    if not wasRelease then
        for i, ikey in ipairs(self.keys) do
            if ikey == key then
                self.actor:destroy()
            end
        end
    end
end

return DestroyOnKeys
