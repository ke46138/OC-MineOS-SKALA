local GUI = require("GUI")
local system = require("System")
local component = require("component")
local number = require("number")
local event = require("event")
local computer = require("computer")

---------------------------ТУРБИНЫ-------------------------------- Работают ли они?

--local t1 = component.proxy("")
--local t2 = component.proxy("")
--local t3 = component.proxy("")

-----------------------ДАТЧИКИ ПОТОКА-----------------------------

local steam_gauge = component.proxy("45fca2d6-7634-4a8a-a9c5-85a0520170c2")
local low_press_steam_gauge = component.proxy("21a2c4bb-12ca-4a29-9622-3459c562fa95")
local water_gauge = component.proxy("f0bbf77b-01a9-4bde-bfad-114f6f276746")

------------------------РЕАКТОР РБМК------------------------------

local f1 = component.proxy("28490c37-316f-4339-8dd4-fcc5c464fdad")
local f2 = component.proxy("2725b90f-09d6-463f-be1f-b57a6293b6db")
local f3 = component.proxy("f9054b9f-215c-46d2-af7c-95befb201c31")
local f4 = component.proxy("c2e8dd42-fd45-450c-8db3-9a8148153767")

local r1 = component.proxy("099e04ad-fa25-4a52-bb10-caee2dbfab06")
local r2 = component.proxy("c295a00f-11cd-4266-99c6-e5ef433cbc75")
local r3 = component.proxy("399fa38c-f3b8-48f4-98f7-eef6b9f94f10")
local r4 = component.proxy("e1b9cbfd-2cfa-4dd9-94d3-b8de026354e0")

---------------------------ДРУГОЕ---------------------------------

local rad = component.proxy("a5a11f0a-9b85-447c-ba60-676ec4f49e25")
local water_storage = component.proxy("1f0db8cc-10e8-4b73-8cd7-d2f5e0488935")

------------------------------------------------------------------

-- Создание окна
local workspace, window = system.addWindow(GUI.window(1, 1, 150, 40)) 
window:addChild(GUI.panel(1, 1, window.width, window.height, 0xE1E1E1))
local actionButtons = window:addChild(GUI.actionButtons(2, 2, false))

local localization = system.getCurrentScriptLocalization()

local levelSlider = window:addChild(GUI.slider(37, 37, 40, 0x66DB80, 0x0, 0xFFFFFF, 0x555555, 0, 100, 50, true, "Высота: ", "%"))
levelSlider.roundValues = true
levelSlider.value = r1.getLevel()
levelSlider.onValueChanged = function()
  r1.setLevel(levelSlider.value)
  r2.setLevel(levelSlider.value)
  r3.setLevel(levelSlider.value)
  r4.setLevel(levelSlider.value)
end

window:addChild(GUI.text(70, 2, 0x555555, "СКАЛА 2.0 мини"))

local f1typeLabel = window:addChild(GUI.text(2, 4, 0x555555, "Тип топл. стержня 1: " .. f1.getType()))
local f1heatLabel = window:addChild(GUI.text(2, 5, 0x555555, "Темп. топл. стержня 1: " .. number.roundToDecimalPlaces(f1.getHeat(), 2)))
local f1skinHeatLabel = window:addChild(GUI.text(2, 6, 0x555555, "Темп. оболочки топл. стержня 1: " .. number.roundToDecimalPlaces(f1.getSkinHeat(), 2)))
local f1coreHeatLabel = window:addChild(GUI.text(2, 7, 0x555555, "Темп. ядра топл. стержня 1: " .. number.roundToDecimalPlaces(f1.getCoreHeat(), 2)))
local f1xenonLabel = window:addChild(GUI.text(2, 8, 0x555555, "Отрав. ксеноном топл. стержня 1: " .. number.roundToDecimalPlaces(f1.getXenonPoison(), 2)))

local f2typeLabel = window:addChild(GUI.text(60, 4, 0x555555, "Тип топл. стержня 2: " .. f1.getType()))
local f2heatLabel = window:addChild(GUI.text(60, 5, 0x555555, "Темп. топл. стержня 2: " .. number.roundToDecimalPlaces(f2.getHeat(), 2)))
local f2skinHeatLabel = window:addChild(GUI.text(60, 6, 0x555555, "Темп. оболочки топл. стержня 2: " .. number.roundToDecimalPlaces(f2.getSkinHeat(), 2)))
local f2coreHeatLabel = window:addChild(GUI.text(60, 7, 0x555555, "Темп. ядра топл. стержня 2: " .. number.roundToDecimalPlaces(f2.getCoreHeat(), 2)))
local f2xenonLabel = window:addChild(GUI.text(60, 8, 0x555555, "Отрав. ксеноном топл. стержня 2: " .. number.roundToDecimalPlaces(f2.getXenonPoison(), 2)))
local r1heightLabel = window:addChild(GUI.text(60, 9, 0x555555, "Высота рег. стержней 1 топл. стержня 2: " .. r1.getLevel()))
local r2heightLabel = window:addChild(GUI.text(60, 10, 0x555555, "Высота рег. стержней 2 топл. стержня 2: " .. r2.getLevel()))

local f3typeLabel = window:addChild(GUI.text(2, 10, 0x555555, "Тип топл. стержня 3: " .. f3.getType()))
local f3heatLabel = window:addChild(GUI.text(2, 11, 0x555555, "Темп. топл. стержня 3: " .. number.roundToDecimalPlaces(f3.getHeat(), 2)))
local f3skinHeatLabel = window:addChild(GUI.text(2, 12, 0x555555, "Темп. оболочки топл. стержня 3: " .. number.roundToDecimalPlaces(f3.getSkinHeat(), 2)))
local f3coreHeatLabel = window:addChild(GUI.text(2, 13, 0x555555, "Темп. ядра топл. стержня 3: " .. number.roundToDecimalPlaces(f3.getCoreHeat(), 2)))
local f3xenonLabel = window:addChild(GUI.text(2, 14, 0x555555, "Отрав. ксеноном топл. стержня 3: " .. number.roundToDecimalPlaces(f3.getXenonPoison(), 2)))
local r3heightLabel = window:addChild(GUI.text(2, 15, 0x555555, "Высота рег. стержней 3 топл. стержня 3: " .. r3.getLevel()))
local r4heightLabel = window:addChild(GUI.text(2, 16, 0x555555, "Высота рег. стержней 4 топл. стержня 3: " .. r4.getLevel()))

local f4typeLabel = window:addChild(GUI.text(60, 12, 0x555555, "Тип топл. стержня 4: " .. f4.getType()))
local f4heatLabel = window:addChild(GUI.text(60, 13, 0x555555, "Темп. топл. стержня 4: " .. number.roundToDecimalPlaces(f4.getHeat(), 2)))
local f4skinHeatLabel = window:addChild(GUI.text(60, 14, 0x555555, "Темп. оболочки топл. стержня 4: " .. number.roundToDecimalPlaces(f4.getSkinHeat(), 2)))
local f4coreHeatLabel = window:addChild(GUI.text(60, 15, 0x555555, "Темп. ядра топл. стержня 4: " .. number.roundToDecimalPlaces(f4.getCoreHeat(), 2)))
local f4xenonLabel = window:addChild(GUI.text(60, 16, 0x555555, "Отрав. ксеноном топл. стержня 4: " .. number.roundToDecimalPlaces(f4.getXenonPoison(), 2)))

local radLabel = window:addChild(GUI.text(2, 18, 0x555555, "Радиация в чанке рядом с реактором: " .. rad.getRads() / 10 .. " RAD/s"))
mbt, mbs = steam_gauge.getTransfer()
local steamLabel = window:addChild(GUI.text(2, 19, 0x555555, "Поток пара: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))
mbt, mbs = water_gauge.getTransfer()
local waterLabel = window:addChild(GUI.text(2, 20, 0x555555, "Поток воды: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))
mbt, mbs = low_press_steam_gauge.getTransfer()
local lowPressSteamLabel = window:addChild(GUI.text(2, 21, 0x555555, "Поток пара низк. давл.: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))

local waterBufLabel = window:addChild(GUI.text(2, 22, 0x555555, "Количество воды в буфере: " .. water_storage.getFluidStored() .. " MB"))

local palundraButton = window:addChild(GUI.button(2, 37, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Аварийный стоп"))
palundraButton.onTouch = function()
  r1.setLevel(0)
  r2.setLevel(0)
  r3.setLevel(0)
  r4.setLevel(0)
  levelSlider.value = 0
end

local function update_window()
  f1typeLabel.text = "Тип топл. стержня 1: " .. f1.getType()
  f1heatLabel.text = "Темп. топливного стержня 1: " .. number.roundToDecimalPlaces(f1.getHeat(), 2)
  f1skinHeatLabel.text = "Темп. оболочки топл. стержня 1: " .. number.roundToDecimalPlaces(f1.getSkinHeat(), 2)
  f1coreHeatLabel.text = "Темп. ядра топл. стержня 1: " .. number.roundToDecimalPlaces(f1.getCoreHeat(), 2)
  f1xenonLabel.text = "Отрав. ксеноном топл. стержня 1: " .. number.roundToDecimalPlaces(f1.getXenonPoison(), 2)
  
  f2typeLabel.text = "Тип топл. стержня 2: " .. f1.getType()
  f2heatLabel.text = "Темп. топливного стержня 2: " .. number.roundToDecimalPlaces(f1.getHeat(), 2)
  f2skinHeatLabel.text = "Темп. оболочки топл. стержня 2: " .. number.roundToDecimalPlaces(f1.getSkinHeat(), 2)
  f2coreHeatLabel.text = "Темп. ядра топл. стержня 2: " .. number.roundToDecimalPlaces(f1.getCoreHeat(), 2)
  f2xenonLabel.text = "Отрав. ксеноном топл. стержня 2: " .. number.roundToDecimalPlaces(f1.getXenonPoison(), 2)
  r1heightLabel.text = "Высота рег. стержней 1 топл. стержня 2: " .. r1.getLevel()
  r2heightLabel.text = "Высота рег. стержней 2 топл. стержня 2: " .. r2.getLevel()
  
  f3typeLabel.text = "Тип топл. стержня 3: " .. f3.getType()
  f3heatLabel.text = "Темп. топливного стержня 3: " .. number.roundToDecimalPlaces(f3.getHeat(), 2)
  f3skinHeatLabel.text = "Темп. оболочки топл. стержня 3: " .. number.roundToDecimalPlaces(f3.getSkinHeat(), 2)
  f3coreHeatLabel.text = "Темп. ядра топл. стержня 3: " .. number.roundToDecimalPlaces(f3.getCoreHeat(), 2)
  f3xenonLabel.text = "Отрав. ксеноном топл. стержня 3: " .. number.roundToDecimalPlaces(f3.getXenonPoison(), 2)
  r3heightLabel.text = "Высота рег. стержней 3 топл. стержня 3: " .. r3.getLevel()
  r4heightLabel.text = "Высота рег. стержней 4 топл. стержня 3: " .. r4.getLevel()
  
  f4typeLabel.text = "Тип топл. стержня 4: " .. f4.getType()
  f4heatLabel.text = "Темп. топливного стержня 4: " .. number.roundToDecimalPlaces(f4.getHeat(), 2)
  f4skinHeatLabel.text = "Темп. оболочки топл. стержня 4: " .. number.roundToDecimalPlaces(f4.getSkinHeat(), 2)
  f4coreHeatLabel.text = "Темп. ядра топл. стержня 4: " .. number.roundToDecimalPlaces(f4.getCoreHeat(), 2)
  f4xenonLabel.text = "Отрав. ксеноном топл. стержня 4: " .. number.roundToDecimalPlaces(f4.getXenonPoison(), 2)
  
  radLabel.text =  "Радиация в чанке рядом с реактором: " .. rad.getRads() / 10 .. " RAD/s"
  mbt, mbs = steam_gauge.getTransfer()
  steamLabel.text = "Поток пара: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  mbt, mbs = water_gauge.getTransfer()
  waterLabel.text = "Поток воды: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  mbt, mbs = low_press_steam_gauge.getTransfer()
  lowPressSteamLabel.text = "Поток пара низк. давл.: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  
  waterBufLabel.text = "Количество воды в буфере: " .. water_storage.getFluidStored() .. " MB"
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
