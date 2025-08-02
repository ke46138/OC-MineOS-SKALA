

local GUI = require("GUI")
local system = require("System")
local number = require("number")
local event = require("event")
local computer = require("computer")
local screen = require("Screen")
local f = require("filesystem")

-------------------------КОНФИГУРАЦИЯ-----------------------------

local isPalundra = true -- Глобальное отключение защит

local palundraWater = true -- Защита от отстутсвия воды в буфере
local palundraWaterPercentage = 25 -- Порог срабатывания защиты
local palundraCO2 = true -- Защита по CO2
local palundraCO2percentage = 25 -- Порог срабатывания защиты
local palundraTemperature = true -- Защита по температуре
local palundraTemperatureMax = 700 -- Максимальная температура
local palundraCO2pressure = 27 -- Максимальное давление
local logsDir = "/SKALA.log"

------------------------------------------------------------------

local localization = system.getCurrentScriptLocalization()

-- Создание окна
local workspace, window = system.addWindow(GUI.window(1, 1, 107, 27))
window:addChild(GUI.panel(1, 1, window.width, window.height, 0xE1E1E1))
local actionButtons = window:addChild(GUI.actionButtons(2, 2, false))

-- Причина, по которой сработала АЗ
local azreason = localization.idk

-- Переменная - статус, определяет пищать ли при радиации
local radBeep = false

local isAz = false

window:addChild(GUI.text(45, 2, 0x555555, localization.appName))

local function getZirnoxInfo() -- Цирнокс возвращает данные в своих единицах... и нафига? ЛЮБЛЮ КОСТЫЛИ :)
  local rawTemp, rawPressure, rawWater, rawco2, rawSteam, rawIsActive = zirnox.getInfo()
  return rawTemp * 0.00001 * 780 + 20, rawPressure * 0.00001 * 30, rawWater, rawco2, rawSteam, (rawIsActive == true) and localization.yes or localization.no
end

local temp, pressure, water, co2, steam, isActive = getZirnoxInfo()

local z1TempLabel = window:addChild(GUI.text(2, 4, 0x555555, localization.temperature .. temp .. "°C"))
local z1PressLabel = window:addChild(GUI.text(2, 5, 0x555555, localization.pressure .. pressure .. " bar"))
local z1WaterLabel = window:addChild(GUI.text(2, 6, 0x555555, localization.waterInReactor .. water .. " MB"))
local z1CardonDioxideLabel = window:addChild(GUI.text(2, 7, 0x555555, localization.co2InReactor .. co2 .. " MB"))
local z1SteamLabel = window:addChild(GUI.text(2, 8, 0x555555, localization.steamInReactor .. steam .. " MB"))
local z1IsActiveLabel = window:addChild(GUI.text(2, 9, 0x555555, localization.isReactorEnabled .. isActive))

local radLabel = window:addChild(GUI.text(2, 11, 0x555555, localization.radiation .. rad.getRads() .. " RAD/s"))

local waterBufLabel = window:addChild(GUI.text(2, 12, 0x555555, localization.waterInBuf .. water_storage.getFluidStored() .. " MB"))
local co2StorageLabel = window:addChild(GUI.text(2, 13, 0x555555, localization.co2InStorage .. co2_storage.getFluidStored() .. " MB"))

window:addChild(GUI.text(2, 15, 0x555555, localization.generation))

local power_graph = window:addChild(GUI.chart(2, 16, 55, 11, 0xEEEEEE, 0xAAAAAA, 0x888888, 0x008800, 0.25, 0.25, "s", "he/s", false, {}))

local seconds = 1

local lines = {
  localization.logStart
}

local display = window:addChild(GUI.object(60, 7, 1, 4))

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

local enableZirnoxButton = window:addChild(GUI.button(60, 10, 10, 3, 0xFFFFFF, 0x555555, 0x4B4B4B, 0xFFFFFF, localization.start))

local palundraButton = window:addChild(GUI.button(71, 10, 10, 3, 0xFFFFFF, 0x555555, 0x4B4B4B, 0xFFFFFF, localization.stop))

local ventZirnoxButton = window:addChild(GUI.button(82, 10, 25, 3, 0xFFFFFF, 0x555555, 0x4B4B4B, 0xFFFFFF, localization.ventCO2))

local inCO2ZirnoxButton = window:addChild(GUI.button(60, 14, 32, 3, 0xFFFFFF, 0x555555, 0x4B4B4B, 0xFFFFFF, localization.inCO2))

local function palundra()
  zirnox.setActive(false)
  table.insert(lines, localization.palundraAZ .. azreason)
  isAz = true
  f.append(logsDir, "\n" .. os.date("%d %b %Y %H:%M:%S", system.getTime()) .. ", " .. localization.palundraAZ .. azreason)
  workspace:draw()
  computer.beep(600, 0.6)
  workspace:draw()
  event.pull(0.25)
  computer.beep(600, 0.6)
  workspace:draw()
  event.pull(0.25)
  computer.beep(600, 0.6)
  workspace:draw()
  event.pull(0.25)
  computer.beep(600, 1)
  workspace:draw()
  azreason = localization.idk
end

palundraButton.onTouch = function()
  zirnox.setActive(false)
end

enableZirnoxButton.onTouch = function()
  temp, pressure, water, steam, co2, isActive = getZirnoxInfo()

  if isPalundra == true then
    if water <= 16000 then
      table.insert(lines, localization.lowWaterReactor)
      return
    end
    if co2 <= 9000 then
      table.insert(lines, localization.lowCO2Reactor)
      return
    end
    if steam >= 4000 then
      table.insert(lines, localization.highSteamReactor)
      return
    end

    if water_storage.getFluidStored() / water_storage.getMaxStored() * 100 <= palundraWaterPercentage and palundraWater == true then
      table.insert(lines, localization.lowWaterBuf)
      return
    end
    if co2_storage.getFluidStored() / co2_storage.getMaxStored() * 100 <= palundraCO2percentage and palundraCO2 == true then
      table.insert(lines, localization.lowCO2Storage)
      return
    end
  end

  zirnox.setActive(true)
end

ventZirnoxButton.onTouch = function()
  zirnox.ventCarbonDioxide(500)
end

inCO2ZirnoxButton.onTouch = function()
  redstone.setOutput(0, 15)
  redstone.setOutput(0, 0)
end

local function update_window()
  temp, pressure, water, steam, co2, isActive = getZirnoxInfo()
  z1TempLabel.text = localization.temperature .. temp .. "°C"
  z1PressLabel.text = localization.pressure .. pressure .. " bar"
  z1WaterLabel.text = localization.waterInReactor .. water .. " MB"
  z1CardonDioxideLabel.text = localization.co2InReactor .. co2 .. " MB"
  z1SteamLabel.text = localization.steamInReactor .. steam .. " MB"
  z1IsActiveLabel.text = localization.isReactorEnabled .. isActive

  radLabel.text = localization.radiation .. rad.getRads() .. " RAD/s"

  waterBufLabel.text = localization.waterInBuf .. water_storage.getFluidStored() .. " MB"
  co2StorageLabel.text = localization.co2InStorage .. co2_storage.getFluidStored() .. " MB"

  if water_storage.getFluidStored() / water_storage.getMaxStored() * 100 <= palundraWaterPercentage and isAz == false and isPalundra == true and palundraWater == true then
    azreason = localization.lowWaterBufAuto
    palundra()
  end

  if co2_storage.getFluidStored() / co2_storage.getMaxStored() * 100 <= palundraCO2percentage and isAz == false and isPalundra == true and palundraCO2 == true then
    azreason = localization.lowCO2StorageAuto
    palundra()
  end

  if rad.getRads() > 10 then
    radBeep = true
  else
    radBeep = false
  end

  while #power_graph.values > 0 and (seconds - power_graph.values[1][1]) > 30 do
    table.remove(power_graph.values, 1)
  end

  local _, phe = power_gauge.getTransfer()

  table.insert(power_graph.values, {seconds, phe})

  seconds = seconds + 1
end

local function tick_security()
  local temp, pressure, water, steam, co2, isActive = getZirnoxInfo()
  if temp >= palundraTemperatureMax and isPalundra == true and palundraTemperature == true and isAz == false then
    azreason = localization.highTempAuto
    palundra()
  end

  if pressure >= palundraCO2pressure and palundraCO2 == true and isAz == false and isPalundra == true then
    azreason = localization.highPressAuto
    palundra()
    zirnox.ventCarbonDioxide()
  end
end

local logSeparator = ", "

local logHandler = event.addHandler(function() -- PLS KILL ME
  local temp, pressure, water, steam, co2, isActive = getZirnoxInfo()
  local _, phe = power_gauge.getTransfer()

  f.append(logsDir, "\n" .. os.date("%d %b %Y %H:%M:%S", system.getTime()) ..
  logSeparator .. temp .. logSeparator .. pressure .. logSeparator .. water .. logSeparator .. steam .. logSeparator .. co2 ..
  logSeparator .. isActive .. logSeparator .. water_storage.getFluidStored() .. logSeparator .. co2_storage.getFluidStored() ..
  logSeparator .. phe .. logSeparator .. rad.getRads())
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
local update_sec_handler = event.addHandler(tick_security, 0.1)

actionButtons.close.onTouch = function()
  event.removeHandler(update_sec_handler)
  event.removeHandler(update_window_handler)
  event.removeHandler(beepHandler)
  event.removeHandler(logHandler)
  window:remove()
end

actionButtons.minimize.onTouch = function()
  window:minimize()
end

workspace:draw()
