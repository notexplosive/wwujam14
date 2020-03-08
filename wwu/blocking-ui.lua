local BlockingUI = {}

registerComponent(BlockingUI, "BlockingUI")

function BlockingUI:setup(scene)
    self.scene = scene
    self.scene.freeze = true
end

function BlockingUI:onDestroy()
    self.scene.freeze = false
end

return BlockingUI
