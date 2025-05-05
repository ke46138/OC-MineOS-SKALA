local GUI = require("GUI")
local system = require("System")
local component = require("component")
local number = require("number")
local event = require("event")
local computer = require("computer")
local screen = require("Screen")
local f = require("filesystem")

-----------------------ДАТЧИКИ ПОТОКА-----------------------------

local steam_gauge = component.proxy("26f95bc8-e07a-4641-86c5-b7995380b504")
local low_press_steam_gauge = component.proxy("674609b0-7242-4671-8ca2-27b164919507")
local water_gauge = component.proxy("9659f5bd-9405-4261-8639-fb7851e8277a")

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

-- Причина, по которой сработала АЗ
local azreason = "ХЗ"

local radBeep = false

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

getName = {
  ["N/A"] = "Т. с. отсутствует",
  ["item.rbmk_fuel_ueu"] = "Необогащ. уран. т. с.",
  ["item.rbmk_fuel_leaus"] = "Низкообогащ. австрал. т. с.",
  
}

local f1typeLabel = window:addChild(GUI.text(2, 4, 0x555555, "Тип топл. стержня 1: " .. getName[f1.getType()]))
local f1heatLabel = window:addChild(GUI.text(2, 5, 0x555555, "Темп. топл. стержня 1: " .. f1.getHeat()))
local f1skinHeatLabel = window:addChild(GUI.text(2, 6, 0x555555, "Темп. оболочки топл. стержня 1: " .. f1.getSkinHeat()))
local f1coreHeatLabel = window:addChild(GUI.text(2, 7, 0x555555, "Темп. ядра топл. стержня 1: " .. f1.getCoreHeat()))
local f1xenonLabel = window:addChild(GUI.text(2, 8, 0x555555, "Отрав. ксеноном топл. стержня 1: " .. f1.getXenonPoison()))
local f1depletionLabel = window:addChild(GUI.text(2, 9, 0x555555, "Обеднение топл. стержня 1: " .. f1.getDepletion()))

local f2typeLabel = window:addChild(GUI.text(60, 4, 0x555555, "Тип топл. стержня 2: " .. f2.getType()))
local f2heatLabel = window:addChild(GUI.text(60, 5, 0x555555, "Темп. топл. стержня 2: " .. f2.getHeat()))
local f2skinHeatLabel = window:addChild(GUI.text(60, 6, 0x555555, "Темп. оболочки топл. стержня 2: " .. f2.getSkinHeat()))
local f2coreHeatLabel = window:addChild(GUI.text(60, 7, 0x555555, "Темп. ядра топл. стержня 2: " .. f2.getCoreHeat()))
local f2xenonLabel = window:addChild(GUI.text(60, 8, 0x555555, "Отрав. ксеноном топл. стержня 2: " .. f2.getXenonPoison()))
local f2depletionLabel = window:addChild(GUI.text(60, 9, 0x555555, "Обеднение топл. стержня 2: " .. f2.getDepletion()))
local r1heightLabel = window:addChild(GUI.text(60, 10, 0x555555, "Высота рег. стержней 1 топл. стержня 2: " .. r1.getLevel()))
local r2heightLabel = window:addChild(GUI.text(60, 11, 0x555555, "Высота рег. стержней 2 топл. стержня 2: " .. r2.getLevel()))

local f3typeLabel = window:addChild(GUI.text(2, 11, 0x555555, "Тип топл. стержня 3: " .. f3.getType()))
local f3heatLabel = window:addChild(GUI.text(2, 12, 0x555555, "Темп. топл. стержня 3: " .. f3.getHeat()))
local f3skinHeatLabel = window:addChild(GUI.text(2, 13, 0x555555, "Темп. оболочки топл. стержня 3: " .. f3.getSkinHeat()))
local f3coreHeatLabel = window:addChild(GUI.text(2, 14, 0x555555, "Темп. ядра топл. стержня 3: " .. f3.getCoreHeat()))
local f3xenonLabel = window:addChild(GUI.text(2, 15, 0x555555, "Отрав. ксеноном топл. стержня 3: " .. f3.getXenonPoison()))
local f3depletionLabel = window:addChild(GUI.text(2, 16, 0x555555, "Обеднение топл. стержня 3: " .. f3.getDepletion()))
local r3heightLabel = window:addChild(GUI.text(2, 17, 0x555555, "Высота рег. стержней 3 топл. стержня 3: " .. r3.getLevel()))
local r4heightLabel = window:addChild(GUI.text(2, 18, 0x555555, "Высота рег. стержней 4 топл. стержня 3: " .. r4.getLevel()))

local f4typeLabel = window:addChild(GUI.text(60, 13, 0x555555, "Тип топл. стержня 4: " .. f4.getType()))
local f4heatLabel = window:addChild(GUI.text(60, 14, 0x555555, "Темп. топл. стержня 4: " .. f4.getHeat()))
local f4skinHeatLabel = window:addChild(GUI.text(60, 15, 0x555555, "Темп. оболочки топл. стержня 4: " .. f4.getSkinHeat()))
local f4coreHeatLabel = window:addChild(GUI.text(60, 16, 0x555555, "Темп. ядра топл. стержня 4: " .. f4.getCoreHeat()))
local f4xenonLabel = window:addChild(GUI.text(60, 17, 0x555555, "Отрав. ксеноном топл. стержня 4: " .. f4.getXenonPoison()))
local f4depletionLabel = window:addChild(GUI.text(60, 18, 0x555555, "Обеднение топл. стержня 4: " .. f4.getDepletion()))

local radLabel = window:addChild(GUI.text(2, 20, 0x555555, "Радиация в чанке рядом с реактором: " .. rad.getRads() .. " RAD/s"))
mbt, mbs = steam_gauge.getTransfer()
local steamLabel = window:addChild(GUI.text(2, 21, 0x555555, "Поток пара: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))
mbt, mbs = water_gauge.getTransfer()
local waterLabel = window:addChild(GUI.text(2, 22, 0x555555, "Поток воды: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))
mbt, mbs = low_press_steam_gauge.getTransfer()
local lowPressSteamLabel = window:addChild(GUI.text(2, 23, 0x555555, "Поток пара низк. давл.: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))

local waterBufLabel = window:addChild(GUI.text(2, 24, 0x555555, "Количество воды в буфере: " .. water_storage.getFluidStored() .. " MB"))

local lines = {
  "Начало лога"
}

local display = window:addChild(GUI.object(60, 23, 1, 4))

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
  table.insert(lines, "Сраб. АЗ. Причина: " .. azreason)
  f.append("/Mounts/64babd3e-bcbf-4eb9-aea3-e079f63c80f4/SKALA.log", "\n" .. os.date("%d %b %Y %H:%M:%S", system.getTime()) .. ", Сраб. АЗ. Причина: " .. azreason)
  workspace:draw()
  computer.beep(600, 0.6)
  event.pull(0.25)
  computer.beep(600, 0.6)
  event.pull(0.25)
  computer.beep(600, 0.6)
  event.pull(0.25)
  computer.beep(600, 1)
  azreason = "ХЗ"
end
palundraButton.onTouch = function()
  azreason = "Руч. наж. кнопки АЗ"
  palundra()
end

local function update_window()
  f1typeLabel.text = "Тип топл. стержня 1: " .. getName[f1.getType()]
  f1heatLabel.text = "Темп. топливного стержня 1: " .. f1.getHeat()
  f1skinHeatLabel.text = "Темп. оболочки топл. стержня 1: " .. f1.getSkinHeat()
  f1coreHeatLabel.text = "Темп. ядра топл. стержня 1: " .. f1.getCoreHeat()
  f1xenonLabel.text = "Отрав. ксеноном топл. стержня 1: " .. f1.getXenonPoison()
  f1depletionLabel.text = "Обеднение топл. стержня 1: " .. f1.getDepletion()
  
  f2typeLabel.text = "Тип топл. стержня 2: " .. getName[f2.getType()]
  f2heatLabel.text = "Темп. топливного стержня 2: " .. f2.getHeat()
  f2skinHeatLabel.text = "Темп. оболочки топл. стержня 2: " .. f2.getSkinHeat()
  f2coreHeatLabel.text = "Темп. ядра топл. стержня 2: " .. f2.getCoreHeat()
  f2xenonLabel.text = "Отрав. ксеноном топл. стержня 2: " .. f2.getXenonPoison()
  f2depletionLabel.text = "Обеднение топл. стержня 2: " .. f2.getDepletion()
  r1heightLabel.text = "Высота рег. стержней 1 топл. стержня 2: " .. r1.getLevel()
  r2heightLabel.text = "Высота рег. стержней 2 топл. стержня 2: " .. r2.getLevel()
  
  f3typeLabel.text = "Тип топл. стержня 3: " .. f3.getType()
  f3heatLabel.text = "Темп. топливного стержня 3: " .. f3.getHeat()
  f3skinHeatLabel.text = "Темп. оболочки топл. стержня 3: " .. f3.getSkinHeat()
  f3coreHeatLabel.text = "Темп. ядра топл. стержня 3: " .. f3.getCoreHeat()
  f3xenonLabel.text = "Отрав. ксеноном топл. стержня 3: " .. f3.getXenonPoison()
  f3depletionLabel.text = "Обеднение топл. стержня 3: " .. f3.getDepletion()
  r3heightLabel.text = "Высота рег. стержней 3 топл. стержня 3: " .. r3.getLevel()
  r4heightLabel.text = "Высота рег. стержней 4 топл. стержня 3: " .. r4.getLevel()
  
  f4typeLabel.text = "Тип топл. стержня 4: " .. f4.getType()
  f4heatLabel.text = "Темп. топливного стержня 4: " .. f4.getHeat()
  f4skinHeatLabel.text = "Темп. оболочки топл. стержня 4: " .. f4.getSkinHeat()
  f4coreHeatLabel.text = "Темп. ядра топл. стержня 4: " .. f4.getCoreHeat()
  f4xenonLabel.text = "Отрав. ксеноном топл. стержня 4: " .. f4.getXenonPoison()
  f4depletionLabel.text = "Обеднение топл. стержня 4: " .. f4.getDepletion()
  
  radLabel.text =  "Радиация в чанке рядом с реактором: " .. rad.getRads() .. " RAD/s"
  mbt, mbs = steam_gauge.getTransfer()
  
  if mbt < 100 and r1.getLevel() > 0 and f3.getHeat() > 150 then
    azreason = "Автомат. сраб. по крит. низк. потоку пара"
    palundra()
  end
  
  steamLabel.text = "Поток пара: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  
  mbt, mbs = water_gauge.getTransfer()
  waterLabel.text = "Поток воды: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  
  if mbt < 100 and r1.getLevel() > 0 and f3.getHeat() > 150 then
    azreason = "Автомат. сраб. по крит. низк. потоку воды"
    palundra()
  end
  
  mbt, mbs = low_press_steam_gauge.getTransfer()
  lowPressSteamLabel.text = "Поток пара низк. давл.: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  
  if mbt < 100 and r1.getLevel() > 0 and f3.getHeat() > 200 then
    azreason = "Автомат. сраб. по крит. низк. потоку пара низк. давл."
    palundra()
  end
  
  waterBufLabel.text = "Количество воды в буфере: " .. water_storage.getFluidStored() .. " MB"
  
  if type(f3.getSkinHeat()) == "number" and f3.getSkinHeat() >= 1800 and r1.getLevel() > 0 then
    azreason = "Автомат. сраб. по темп. т. с. 3"
    palundra()
  end
  if type(f1.getSkinHeat()) == "number" and f1.getSkinHeat() >= 1800 and r1.getLevel() > 0 then
    azreason = "Автомат. сраб. по темп. т. с. 1"
    palundra()
  end
  if type(f2.getSkinHeat()) == "number" and f2.getSkinHeat() >= 1800 and r1.getLevel() > 0 then
    azreason = "Автомат. сраб. по темп. т. с. 2"
    palundra()
  end
  if type(f4.getSkinHeat()) == "number" and f4.getSkinHeat() >= 1800 and r1.getLevel() > 0 then
    azreason = "Автомат. сраб. по темп. т. с. 4"
    palundra()
  end
  if water_storage.getFluidStored() < 50000 and r1.getLevel() > 0 then
    azreason = "Автомат. сраб. по крит. низк. ур. воды"
    palundra()
  end
  
  if rad.getRads() > 10 then
    radBeep = true
  end
end

local logSeparator = ", "

local logHandler = event.addHandler(function() -- PLS KILL ME
  f.append("/Mounts/64babd3e-bcbf-4eb9-aea3-e079f63c80f4/SKALA.log", "\n" .. os.date("%d %b %Y %H:%M:%S", system.getTime()) .. 
  logSeparator .. f1.getHeat() .. logSeparator .. 
  f2.getHeat() .. logSeparator .. f3.getHeat() .. logSeparator .. f4.getHeat() .. logSeparator .. f1.getSkinHeat() ..
  logSeparator .. f2.getSkinHeat() .. logSeparator .. f3.getSkinHeat() .. logSeparator .. f4.getSkinHeat() ..
  logSeparator .. f1.getCoreHeat() .. logSeparator .. f2.getCoreHeat() .. logSeparator .. f3.getCoreHeat() ..
  logSeparator .. f4.getCoreHeat() .. logSeparator .. f1.getXenonPoison() .. logSeparator .. f2.getXenonPoison() ..
  logSeparator .. f3.getXenonPoison() .. logSeparator .. f4.getXenonPoison() .. logSeparator .. f1.getDepletion() ..
  logSeparator .. f2.getDepletion() .. logSeparator .. f3.getDepletion() .. logSeparator .. f4.getDepletion() ..
  logSeparator .. r1.getLevel() .. logSeparator .. r2.getLevel() .. logSeparator .. r3.getLevel() ..
  logSeparator .. r4.getLevel() .. logSeparator .. rad.getRads() .. logSeparator .. water_gauge.getTransfer() ..
  logSeparator .. steam_gauge.getTransfer() .. logSeparator .. low_press_steam_gauge.getTransfer() ..
  logSeparator .. water_storage.getFluidStored())
end, 60)

local beepHandler = event.addHandler(function()
  if radBeep == true then
    computer.beep(1000, 0.25)
  end
end, 5)

window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

local update_window_handler = event.addHandler(update_window, 1)

actionButtons.close.onTouch = function()
  event.removeHandler(update_window_handler)
  event.removeHandler(beepHandler)
  event.removeHandler(logHandler)
  window:remove()
end

actionButtons.minimize.onTouch = function()
  window:minimize()
end


workspace:draw()
