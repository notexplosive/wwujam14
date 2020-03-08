local DeferredComponent = {}

registerComponent(DeferredComponent, "DeferredComponent")

function DeferredComponent:setup(component, ...)
    self.component = component
    self.args = {...}
end

function DeferredComponent:start()
    self.actor:addComponent(self.component, unpack(self.args))
    self:destroy()
end

function DeferredComponent:draw(x, y)
end

function DeferredComponent:update(dt)
end

return DeferredComponent
