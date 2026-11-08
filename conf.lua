function love.conf(t)
  -- Console
  t.console = true

  -- Window
  t.window.title = "since2012_dev"
  t.window.width = 900
  t.window.height = 700
  t.window.vsync = 1
  t.window.msaa = 0
  t.window.depth = 0
  t.window.heightdpi = false
  t.window.stencil = false
  t.window.borderless = false
  t.window.resizable = false
  t.window.fullscreen = false

  -- Modules
  t.modules.joystick = false
  t.modules.physics = false
  t.modules.video = false
end
