local GUI = require("GUI")
local system = require("System")
local component = require("component")
local number = require("number")
local event = require("event")
local computer = require("computer")
local screen = require("Screen")

---------------------------ТУРБИНЫ-------------------------------- Работают ли они?

--local t1 = component.proxy("")
--local t2 = component.proxy("")
--local t3 = component.proxy("")

-----------------------ДАТЧИКИ ПОТОКА-----------------------------

local steam_gauge = component.proxy("26f95bc8-e07a-4641-86c5-b7995380b504")
local low_press_steam_gauge = component.proxy("674609b0-7242-4671-8ca2-27b164919507")
local water_gauge = component.proxy("65abeb16-8d03-4621-9d22-979a535ec3a3")

------------------------РЕАКТОР РБМК------------------------------

local f1 = component.proxy("0e818add-80cb-4ec9-afa5-8004db0848a5")
local f2 = component.proxy("d0ddfae3-92e5-441f-bca6-7298b26357d0")
local f3 = component.proxy("be3f1cf8-576b-406d-b9b4-aaa6fb5eedf5")
local f4 = component.proxy("11e3a64f-37e4-44d3-bb62-65978a3e0442")

local r1 = component.proxy("83679015-5e8c-40df-81bb-f40afb70fd65")
local r2 = component.proxy("a49fa2b7-0bdc-4feb-8def-6b6f8b697865")
local r3 = component.proxy("93f57b45-bd92-4dc6-adc2-78752d459f2c")
local r4 = component.proxy("ecc11a83-76cd-40bf-9cf7-8690e2c44444")

---------------------------ДРУГОЕ---------------------------------

local rad = component.proxy("ea8fec7c-8ba3-4a5b-9f95-0eece417fdd3")
local water_storage = component.proxy("e9eeaea6-fe05-47e1-8e87-c2ba15a4fc6b")

------------------------------------------------------------------

-- Создание окна
local workspace, window = system.addWindow(GUI.window(1, 1, 150, 40)) 
window:addChild(GUI.panel(1, 1, window.width, window.height, 0xE1E1E1))
local actionButtons = window:addChild(GUI.actionButtons(2, 2, false))

local levelSlider = window:addChild(GUI.slider(37, 37, 40, 0x66DB80, 0x0, 0xFFFFFF, 0x555555, 0, 100, 50, true, "Высота: ", "%"))
levelSlider.roundValues = true
levelSlider.value = r1.getLevel()
levelSlider.onValueChanged = function()
  r1.setLevel(levelSlider.value)
  r2.setLevel(levelSlider.value)
  r3.setLevel(levelSlider.value)
  r4.setLevel(levelSlider.value)
end

window:addChild(GUI.text(66, 2, 0x555555, "СУЗ СКАЛА 2.0 мини"))

local f1typeLabel = window:addChild(GUI.text(2, 4, 0x555555, "Тип топл. стержня 1: " .. f1.getType()))
local f1heatLabel = window:addChild(GUI.text(2, 5, 0x555555, "Темп. топл. стержня 1: " .. f1.getHeat()))
local f1skinHeatLabel = window:addChild(GUI.text(2, 6, 0x555555, "Темп. оболочки топл. стержня 1: " .. f1.getSkinHeat()))
local f1coreHeatLabel = window:addChild(GUI.text(2, 7, 0x555555, "Темп. ядра топл. стержня 1: " .. f1.getCoreHeat()))
local f1xenonLabel = window:addChild(GUI.text(2, 8, 0x555555, "Отрав. ксеноном топл. стержня 1: " .. f1.getXenonPoison()))

local f2typeLabel = window:addChild(GUI.text(60, 4, 0x555555, "Тип топл. стержня 2: " .. f2.getType()))
local f2heatLabel = window:addChild(GUI.text(60, 5, 0x555555, "Темп. топл. стержня 2: " .. f2.getHeat()))
local f2skinHeatLabel = window:addChild(GUI.text(60, 6, 0x555555, "Темп. оболочки топл. стержня 2: " .. f2.getSkinHeat()))
local f2coreHeatLabel = window:addChild(GUI.text(60, 7, 0x555555, "Темп. ядра топл. стержня 2: " .. f2.getCoreHeat()))
local f2xenonLabel = window:addChild(GUI.text(60, 8, 0x555555, "Отрав. ксеноном топл. стержня 2: " .. f2.getXenonPoison()))
local r1heightLabel = window:addChild(GUI.text(60, 9, 0x555555, "Высота рег. стержней 1 топл. стержня 2: " .. r1.getLevel()))
local r2heightLabel = window:addChild(GUI.text(60, 10, 0x555555, "Высота рег. стержней 2 топл. стержня 2: " .. r2.getLevel()))

local f3typeLabel = window:addChild(GUI.text(2, 10, 0x555555, "Тип топл. стержня 3: " .. f3.getType()))
local f3heatLabel = window:addChild(GUI.text(2, 11, 0x555555, "Темп. топл. стержня 3: " .. f3.getHeat()))
local f3skinHeatLabel = window:addChild(GUI.text(2, 12, 0x555555, "Темп. оболочки топл. стержня 3: " .. f3.getSkinHeat()))
local f3coreHeatLabel = window:addChild(GUI.text(2, 13, 0x555555, "Темп. ядра топл. стержня 3: " .. f3.getCoreHeat()))
local f3xenonLabel = window:addChild(GUI.text(2, 14, 0x555555, "Отрав. ксеноном топл. стержня 3: " .. f3.getXenonPoison()))
local r3heightLabel = window:addChild(GUI.text(2, 15, 0x555555, "Высота рег. стержней 3 топл. стержня 3: " .. r3.getLevel()))
local r4heightLabel = window:addChild(GUI.text(2, 16, 0x555555, "Высота рег. стержней 4 топл. стержня 3: " .. r4.getLevel()))

local f4typeLabel = window:addChild(GUI.text(60, 12, 0x555555, "Тип топл. стержня 4: " .. f4.getType()))
local f4heatLabel = window:addChild(GUI.text(60, 13, 0x555555, "Темп. топл. стержня 4: " .. f4.getHeat()))
local f4skinHeatLabel = window:addChild(GUI.text(60, 14, 0x555555, "Темп. оболочки топл. стержня 4: " .. f4.getSkinHeat()))
local f4coreHeatLabel = window:addChild(GUI.text(60, 15, 0x555555, "Темп. ядра топл. стержня 4: " .. f4.getCoreHeat()))
local f4xenonLabel = window:addChild(GUI.text(60, 16, 0x555555, "Отрав. ксеноном топл. стержня 4: " .. f4.getXenonPoison()))

local radLabel = window:addChild(GUI.text(2, 18, 0x555555, "Радиация в чанке рядом с реактором: " .. rad.getRads() / 10 .. " RAD/s"))
mbt, mbs = steam_gauge.getTransfer()
local steamLabel = window:addChild(GUI.text(2, 19, 0x555555, "Поток пара: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))
mbt, mbs = water_gauge.getTransfer()
local waterLabel = window:addChild(GUI.text(2, 20, 0x555555, "Поток воды: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))
mbt, mbs = low_press_steam_gauge.getTransfer()
local lowPressSteamLabel = window:addChild(GUI.text(2, 21, 0x555555, "Поток пара низк. давл.: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))

local waterBufLabel = window:addChild(GUI.text(2, 22, 0x555555, "Количество воды в буфере: " .. water_storage.getFluidStored() .. " MB"))

local lines = {
  "Начало лога"
}

local display = window:addChild(GUI.object(60, 21, 1, 4))

display.draw = function(display)
  if #lines == 0 then
    return
  end

  local y = display.y + display.height - 1
  
  for i = #lines, math.max(#lines - display.height, 1), -1 do
    screen.drawText(display.x, y - 2, 0x008800, lines[i])
    y = y - 1
  end
end

local palundraButton = window:addChild(GUI.button(2, 37, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Аварийный стоп"))
local function palundra()
  r1.setLevel(0)
  r2.setLevel(0)
  r3.setLevel(0)
  r4.setLevel(0)
  levelSlider.value = 0
  table.insert(lines, "Сраб. АЗ")
  workspace:draw()
  computer.beep(600, 0.6)
  event.pull(0.25)
  computer.beep(600, 0.6)
  event.pull(0.25)
  computer.beep(600, 0.6)
  event.pull(0.25)
  computer.beep(600, 1)
end
palundraButton.onTouch = palundra

local function update_window()
  f1typeLabel.text = "Тип топл. стержня 1: " .. f1.getType()
  f1heatLabel.text = "Темп. топливного стержня 1: " .. f1.getHeat()
  f1skinHeatLabel.text = "Темп. оболочки топл. стержня 1: " .. f1.getSkinHeat()
  f1coreHeatLabel.text = "Темп. ядра топл. стержня 1: " .. f1.getCoreHeat()
  f1xenonLabel.text = "Отрав. ксеноном топл. стержня 1: " .. f1.getXenonPoison()
  
  f2typeLabel.text = "Тип топл. стержня 2: " .. f1.getType()
  f2heatLabel.text = "Темп. топливного стержня 2: " .. f1.getHeat()
  f2skinHeatLabel.text = "Темп. оболочки топл. стержня 2: " .. f1.getSkinHeat()
  f2coreHeatLabel.text = "Темп. ядра топл. стержня 2: " .. f1.getCoreHeat()
  f2xenonLabel.text = "Отрав. ксеноном топл. стержня 2: " .. f1.getXenonPoison()
  r1heightLabel.text = "Высота рег. стержней 1 топл. стержня 2: " .. r1.getLevel()
  r2heightLabel.text = "Высота рег. стержней 2 топл. стержня 2: " .. r2.getLevel()
  
  f3typeLabel.text = "Тип топл. стержня 3: " .. f3.getType()
  f3heatLabel.text = "Темп. топливного стержня 3: " .. f3.getHeat()
  f3skinHeatLabel.text = "Темп. оболочки топл. стержня 3: " .. f3.getSkinHeat()
  f3coreHeatLabel.text = "Темп. ядра топл. стержня 3: " .. f3.getCoreHeat()
  f3xenonLabel.text = "Отрав. ксеноном топл. стержня 3: " .. f3.getXenonPoison()
  r3heightLabel.text = "Высота рег. стержней 3 топл. стержня 3: " .. r3.getLevel()
  r4heightLabel.text = "Высота рег. стержней 4 топл. стержня 3: " .. r4.getLevel()
  
  f4typeLabel.text = "Тип топл. стержня 4: " .. f4.getType()
  f4heatLabel.text = "Темп. топливного стержня 4: " .. f4.getHeat()
  f4skinHeatLabel.text = "Темп. оболочки топл. стержня 4: " .. f4.getSkinHeat()
  f4coreHeatLabel.text = "Темп. ядра топл. стержня 4: " .. f4.getCoreHeat()
  f4xenonLabel.text = "Отрав. ксеноном топл. стержня 4: " .. f4.getXenonPoison()
  
  radLabel.text =  "Радиация в чанке рядом с реактором: " .. rad.getRads() / 10 .. " RAD/s"
  mbt, mbs = steam_gauge.getTransfer()
  steamLabel.text = "Поток пара: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  mbt, mbs = water_gauge.getTransfer()
  waterLabel.text = "Поток воды: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  mbt, mbs = low_press_steam_gauge.getTransfer()
  lowPressSteamLabel.text = "Поток пара низк. давл.: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  
  waterBufLabel.text = "Количество воды в буфере: " .. water_storage.getFluidStored() .. " MB"
  
  if f3.getSkinHeat() >= 1450 and r1.getLevel() > 0 then
    palundra()
  end
end

window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

local update_window_handler = event.addHandler(update_window, 1)

actionButtons.close.onTouch = function()
  event.removeHandler(update_window_handler)
  window:remove()
end

actionButtons.minimize.onTouch = function()
  window:minimize()
end


workspace:draw()