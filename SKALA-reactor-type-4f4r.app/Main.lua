

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
local palundraGauges = true -- Защита от отсутствия потока в трубах
local palundraTemperature = true -- Защита по температуре

------------------------------------------------------------------

-- Создание окна
local workspace, window = system.addWindow(GUI.window(1, 1, 120, 40)) 
window:addChild(GUI.panel(1, 1, window.width, window.height, 0xE1E1E1))
local actionButtons = window:addChild(GUI.actionButtons(2, 2, false))

-- Причина, по которой сработала АЗ
local azreason = "ХЗ"

-- Переменная - статус, определяет пищать ли при радиации
local radBeep = false

local isAz = false

window:addChild(GUI.text(50, 2, 0x555555, "СУЗ СКАЛА 2.0 мини"))

local getName = {
  ["N/A"] = "Т. с. отсутствует",
  ["item.rbmk_fuel_ueu"] = "Необогащ. уран. т. с.",
  ["item.rbmk_fuel_meu"] = "Среднеобогащ. уран. т. с.",
  ["item.rbmk_fuel_heu"] = "Высокообогащ. уран. т. с.",
  ["item.rbmk_fuel_leaus"] = "Низкообогащ. австрал. т. с.",
  ["item.rbmk_fuel_heaus"] = "Высокообогащ. австрал. т. с.",
  ["item.rbmk_fuel_pu238be"] = "Плут. 238 бер. ист. ней.",
  ["item.rbmk_fuel_po210be"] = "Полон. 210 бер. ист. ней.",
  ["item.rbmk_fuel_ra226be"] = "Рад. 226 бер. ист. ней.",
  ["item.rbmk_fuel_lea"] = "Низкообогащ. америц. т. с.",
  ["item.rbmk_fuel_mea"] = "Среднеобогащ. америц. т. с.",
  ["item.rbmk_fuel_hea241"] = "Высокообогащ. америц. 241 т. с.",
  ["item.rbmk_fuel_hea242"] = "Высокообогащ. америц. 242 т. с.",
  ["item.rbmk_fuel_heu235"] = "Высокообогащ. уран. 235 т. с.",
  ["item.rbmk_fuel_lep"] = "Низкообогащ. плут. 239 т. с.",
  ["item.rbmk_fuel_mep"] = "Среднеобогащ. плут. 239 т. с.",
  ["item.rbmk_fuel_hep"] = "Высокообогащ. плут. 239 т. с.",
  ["item.rbmk_fuel_hep241"] = "Высокообогащ. плут. 241 т. с.",
  ["item.rbmk_fuel_men"] = "Среднеобогащ. нептун. т. с.",
  ["item.rbmk_fuel_hen"] = "Высокообогащ. нептун. т. с.",
  ["item.rbmk_fuel_mox"] = "МОКС т. с.",
  ["item.rbmk_fuel_les"] = "Низкообогащ. шраб. т. с.",
  ["item.rbmk_fuel_mes"] = "Среднеобогащ. шраб. т. с.",
  ["item.rbmk_fuel_hes"] = "Высокообогащ. шраб. т. с.",
  ["item.rbmk_fuel_thmeu"] = "Среднеобогащ. торий уран. т. с.",
  ["item.rbmk_fuel_balefire_gold"] = "Флэшголд т. с.",
  ["item.rbmk_fuel_flashlead"] = "Флэшлид т. с.",
  ["item.rbmk_fuel_balefire"] = "Жар-топл. с.",
  ["item.rbmk_fuel_zfb_pu241"] = "Плут. 241 ЦТС с.",
  ["item.rbmk_fuel_zfb_bismuth"] = "Висмут. 241 ЦТС с.",
  ["item.rbmk_fuel_zfb_am_mix"] = "Америц. реакт. кач. ЦТС с.",
  ["item.rbmk_fuel_drx"] = "Дигамма т. с."
}

local getSafeTemp = {
  ["N/A"] = 99999,
  ["item.rbmk_fuel_ueu"] = 2100,
  ["item.rbmk_fuel_meu"] = 2100,
  ["item.rbmk_fuel_heu"] = 2100,
  ["item.rbmk_fuel_leaus"] = 6000,
  ["item.rbmk_fuel_heaus"] = 4200,
  ["item.rbmk_fuel_pu238be"] = 900,
  ["item.rbmk_fuel_po210be"] = 900,
  ["item.rbmk_fuel_ra226be"] = 450,
  ["item.rbmk_fuel_lea"] = 1850,
  ["item.rbmk_fuel_mea"] = 1850,
  ["item.rbmk_fuel_hea241"] = 1850,
  ["item.rbmk_fuel_hea242"] = 1850,
  ["item.rbmk_fuel_heu235"] = 2100,
  ["item.rbmk_fuel_lep"] = 2000,
  ["item.rbmk_fuel_mep"] = 2000,
  ["item.rbmk_fuel_hep"] = 2000,
  ["item.rbmk_fuel_hep241"] = 2000,
  ["item.rbmk_fuel_men"] = 2000,
  ["item.rbmk_fuel_hen"] = 2000,
  ["item.rbmk_fuel_mox"] = 2000,
  ["item.rbmk_fuel_les"] = 1700,
  ["item.rbmk_fuel_mes"] = 2000,
  ["item.rbmk_fuel_hes"] = 2400,
  ["item.rbmk_fuel_thmeu"] = 2500,
  ["item.rbmk_fuel_balefire_gold"] = 1200,
  ["item.rbmk_fuel_flashlead"] = 1200,
  ["item.rbmk_fuel_balefire"] = 2800,
  ["item.rbmk_fuel_zfb_pu241"] = 2000,
  ["item.rbmk_fuel_zfb_bismuth"] = 2000,
  ["item.rbmk_fuel_zfb_am_mix"] = 2000,
  ["item.rbmk_fuel_drx"] = 2000 -- Я не знаю температуру плавления дигамма стержня, мне кажется там вообще другой принцип работы
  -- А ВООБЩЕ НЕ ВСТАВЛЯЙТЕ ДИГАММА СТЕРЖЕНЬ В ЭТОТ РЕАКТОР!!!
}

local f1typeLabel = window:addChild(GUI.text(2, 4, 0x555555, "Тип топл. стержня 1: " .. getName[f1.getType()]))
local f1heatLabel = window:addChild(GUI.text(2, 5, 0x555555, "Темп. топл. стержня 1: " .. f1.getHeat()))
local f1skinHeatLabel = window:addChild(GUI.text(2, 6, 0x555555, "Темп. оболочки топл. стержня 1: " .. f1.getSkinHeat()))
local f1coreHeatLabel = window:addChild(GUI.text(2, 7, 0x555555, "Темп. ядра топл. стержня 1: " .. f1.getCoreHeat()))
local f1xenonLabel = window:addChild(GUI.text(2, 8, 0x555555, "Отрав. ксеноном топл. стержня 1: " .. f1.getXenonPoison()))
local f1depletionLabel = window:addChild(GUI.text(2, 9, 0x555555, "Обеднение топл. стержня 1: " .. f1.getDepletion()))

local f2typeLabel = window:addChild(GUI.text(60, 4, 0x555555, "Тип топл. стержня 2: " .. getName[f2.getType()]))
local f2heatLabel = window:addChild(GUI.text(60, 5, 0x555555, "Темп. топл. стержня 2: " .. f2.getHeat()))
local f2skinHeatLabel = window:addChild(GUI.text(60, 6, 0x555555, "Темп. оболочки топл. стержня 2: " .. f2.getSkinHeat()))
local f2coreHeatLabel = window:addChild(GUI.text(60, 7, 0x555555, "Темп. ядра топл. стержня 2: " .. f2.getCoreHeat()))
local f2xenonLabel = window:addChild(GUI.text(60, 8, 0x555555, "Отрав. ксеноном топл. стержня 2: " .. f2.getXenonPoison()))
local f2depletionLabel = window:addChild(GUI.text(60, 9, 0x555555, "Обеднение топл. стержня 2: " .. f2.getDepletion()))
local r1heightLabel = window:addChild(GUI.text(60, 10, 0x555555, "Высота рег. стержней 1 топл. стержня 2: " .. r1.getLevel()))
local r2heightLabel = window:addChild(GUI.text(60, 11, 0x555555, "Высота рег. стержней 2 топл. стержня 2: " .. r2.getLevel()))

local f3typeLabel = window:addChild(GUI.text(2, 11, 0x555555, "Тип топл. стержня 3: " .. getName[f3.getType()]))
local f3heatLabel = window:addChild(GUI.text(2, 12, 0x555555, "Темп. топл. стержня 3: " .. f3.getHeat()))
local f3skinHeatLabel = window:addChild(GUI.text(2, 13, 0x555555, "Темп. оболочки топл. стержня 3: " .. f3.getSkinHeat()))
local f3coreHeatLabel = window:addChild(GUI.text(2, 14, 0x555555, "Темп. ядра топл. стержня 3: " .. f3.getCoreHeat()))
local f3xenonLabel = window:addChild(GUI.text(2, 15, 0x555555, "Отрав. ксеноном топл. стержня 3: " .. f3.getXenonPoison()))
local f3depletionLabel = window:addChild(GUI.text(2, 16, 0x555555, "Обеднение топл. стержня 3: " .. f3.getDepletion()))
local r3heightLabel = window:addChild(GUI.text(2, 17, 0x555555, "Высота рег. стержней 3 топл. стержня 3: " .. r3.getLevel()))
local r4heightLabel = window:addChild(GUI.text(2, 18, 0x555555, "Высота рег. стержней 4 топл. стержня 3: " .. r4.getLevel()))

local f4typeLabel = window:addChild(GUI.text(60, 13, 0x555555, "Тип топл. стержня 4: " .. getName[f4.getType()]))
local f4heatLabel = window:addChild(GUI.text(60, 14, 0x555555, "Темп. топл. стержня 4: " .. f4.getHeat()))
local f4skinHeatLabel = window:addChild(GUI.text(60, 15, 0x555555, "Темп. оболочки топл. стержня 4: " .. f4.getSkinHeat()))
local f4coreHeatLabel = window:addChild(GUI.text(60, 16, 0x555555, "Темп. ядра топл. стержня 4: " .. f4.getCoreHeat()))
local f4xenonLabel = window:addChild(GUI.text(60, 17, 0x555555, "Отрав. ксеноном топл. стержня 4: " .. f4.getXenonPoison()))
local f4depletionLabel = window:addChild(GUI.text(60, 18, 0x555555, "Обеднение топл. стержня 4: " .. f4.getDepletion()))

local radLabel = window:addChild(GUI.text(2, 20, 0x555555, "Радиация в чанке рядом с реактором: " .. rad.getRads() .. " RAD/s"))
local mbt, mbs = steam_gauge.getTransfer()
local steamLabel = window:addChild(GUI.text(2, 21, 0x555555, "Поток пара: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))
mbt, mbs = water_gauge.getTransfer()
local waterLabel = window:addChild(GUI.text(2, 22, 0x555555, "Поток воды: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))
mbt, mbs = low_press_steam_gauge.getTransfer()
local lowPressSteamLabel = window:addChild(GUI.text(2, 23, 0x555555, "Поток пара низк. давл.: " .. mbt .. " MB/t, " .. mbs .. " MB/s"))

local waterBufLabel = window:addChild(GUI.text(2, 24, 0x555555, "Количество воды в буфере: " .. water_storage.getFluidStored() .. " MB"))

local power_graph = window:addChild(GUI.chart(2, 26, 55, 11, 0xEEEEEE, 0xAAAAAA, 0x888888, 0x008800, 0.25, 0.25, "s", "he/s", false, {}))
local neutrons = window:addChild(GUI.chart(60, 26, 60, 11, 0xEEEEEE, 0xAAAAAA, 0x888888, 0x008800, 0.25, 0.25, "s", "n", false, {}))

window:addChild(GUI.text(2, 25, 0x555555, "Выработка электроэнергии: "))
window:addChild(GUI.text(60, 25, 0x555555, "Суммарный поток нейтронов: "))

local levelSlider = window:addChild(GUI.slider(36, 38, 40, 0x66DB80, 0x0, 0xFFFFFF, 0x555555, 0, 100, 50, true, "Высота осн. рег. стержней: ", "%"))
levelSlider.roundValues = true
levelSlider.value = (r1.getLevel() + r2.getLevel() + r3.getLevel() + r4.getLevel()) / 4
levelSlider.onValueChanged = function()
  if levelSlider.value > 0 then
    isAz = false
  end
  r1.setLevel(levelSlider.value)
  r2.setLevel(levelSlider.value)
  r3.setLevel(levelSlider.value)
  r4.setLevel(levelSlider.value)
end

local dLevelSlider = window:addChild(GUI.slider(85, 38, 30, 0x66DB80, 0x0, 0xFFFFFF, 0x555555, 0, 100, 50, true, "Высота доп. рег. стержней: ", "%"))
dLevelSlider.roundValues = true
dLevelSlider.value = (dr1.getLevel() + dr2.getLevel() + dr3.getLevel() + dr4.getLevel() + dr5.getLevel() + dr6.getLevel() + dr7.getLevel() + dr8.getLevel()) / 8
dLevelSlider.onValueChanged = function()
  if dLevelSlider.value > 0 then
    isAz = false
  end
  dr1.setLevel(dLevelSlider.value)
  dr2.setLevel(dLevelSlider.value)
  dr3.setLevel(dLevelSlider.value)
  dr4.setLevel(dLevelSlider.value)
  dr5.setLevel(dLevelSlider.value)
  dr6.setLevel(dLevelSlider.value)
  dr7.setLevel(dLevelSlider.value)
  dr8.setLevel(dLevelSlider.value)
end

local seconds = 1

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
  dr1.setLevel(0)
  dr2.setLevel(0)
  dr3.setLevel(0)
  dr4.setLevel(0)
  dr5.setLevel(0)
  dr6.setLevel(0)
  dr7.setLevel(0)
  dr8.setLevel(0)
  levelSlider.value = 0
  table.insert(lines, "Сраб. АЗ. Причина: " .. azreason)
  isAz = true
  f.append(logsPath, "\n" .. os.date("%d %b %Y %H:%M:%S", system.getTime()) .. ", Сраб. АЗ. Причина: " .. azreason)
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
  
  f3typeLabel.text = "Тип топл. стержня 3: " .. getName[f3.getType()]
  f3heatLabel.text = "Темп. топливного стержня 3: " .. f3.getHeat()
  f3skinHeatLabel.text = "Темп. оболочки топл. стержня 3: " .. f3.getSkinHeat()
  f3coreHeatLabel.text = "Темп. ядра топл. стержня 3: " .. f3.getCoreHeat()
  f3xenonLabel.text = "Отрав. ксеноном топл. стержня 3: " .. f3.getXenonPoison()
  f3depletionLabel.text = "Обеднение топл. стержня 3: " .. f3.getDepletion()
  r3heightLabel.text = "Высота рег. стержней 3 топл. стержня 3: " .. r3.getLevel()
  r4heightLabel.text = "Высота рег. стержней 4 топл. стержня 3: " .. r4.getLevel()
  
  f4typeLabel.text = "Тип топл. стержня 4: " .. getName[f4.getType()]
  f4heatLabel.text = "Темп. топливного стержня 4: " .. f4.getHeat()
  f4skinHeatLabel.text = "Темп. оболочки топл. стержня 4: " .. f4.getSkinHeat()
  f4coreHeatLabel.text = "Темп. ядра топл. стержня 4: " .. f4.getCoreHeat()
  f4xenonLabel.text = "Отрав. ксеноном топл. стержня 4: " .. f4.getXenonPoison()
  f4depletionLabel.text = "Обеднение топл. стержня 4: " .. f4.getDepletion()
  
  radLabel.text =  "Радиация в чанке рядом с реактором: " .. rad.getRads() .. " RAD/s"
  
  local avg_temp = (f1.getHeat() + f2.getHeat() +  f3.getHeat() + f4.getHeat()) / 4
  local avg_level = (r1.getLevel() + r2.getLevel() + r3.getLevel() + r4.getLevel()) / 4
  
  mbt, mbs = steam_gauge.getTransfer()
  
  if mbt < 100 and avg_level > 0 and avg_temp > 150 then
    azreason = "Автомат. сраб. по крит. низк. потоку пара"
    palundra()
  end
  
  steamLabel.text = "Поток пара: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  
  mbt, mbs = water_gauge.getTransfer()
  waterLabel.text = "Поток воды: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  
  if mbt < 100 and avg_level > 0 and avg_temp > 150 and isAz == false and palundraGauges == true and isPalundra == true then
    azreason = "Автомат. сраб. по крит. низк. потоку воды"
    palundra()
  end
  
  mbt, mbs = low_press_steam_gauge.getTransfer()
  lowPressSteamLabel.text = "Поток пара низк. давл.: " .. mbt .. " MB/t, " .. mbs .. " MB/s"
  
  if mbt < 100 and avg_level > 0 and avg_temp > 200 and isAz == false and palundraGauges == true and isPalundra == true then
    azreason = "Автомат. сраб. по крит. низк. потоку пара низк. давл."
    palundra()
  end
  
  waterBufLabel.text = "Количество воды в буфере: " .. water_storage.getFluidStored() .. " MB"
  
  if type(f3.getSkinHeat()) == "number" and f3.getSkinHeat() >= getSafeTemp[f3.getType()] and r3.getLevel() > 0 and isAz == false and isPalundra == true and palundraTemperature == true then
    azreason = "Автомат. сраб. по темп. т. с. 3"
    palundra()
  end
  if type(f1.getSkinHeat()) == "number" and f1.getSkinHeat() >= getSafeTemp[f1.getType()] and r1.getLevel() > 0 and isAz == false and isPalundra == true and palundraTemperature == true then
    azreason = "Автомат. сраб. по темп. т. с. 1"
    palundra()
  end
  if type(f2.getSkinHeat()) == "number" and f2.getSkinHeat() >= getSafeTemp[f2.getType()] and r2.getLevel() > 0 and isAz == false and isPalundra == true and palundraTemperature == true then
    azreason = "Автомат. сраб. по темп. т. с. 2"
    palundra()
  end
  if type(f4.getSkinHeat()) == "number" and f4.getSkinHeat() >= getSafeTemp[f4.getType()] and r4.getLevel() > 0 and isAz == false and isPalundra == true and palundraTemperature == true then
    azreason = "Автомат. сраб. по темп. т. с. 4"
    palundra()
  end
  if water_storage.getFluidStored() / water_storage.getMaxStored() * 100 <= palundraWaterPercentage and avg_level > 0 and isAz == false and isPalundra == true and palundraWater == true then
    azreason = "Автомат. сраб. по крит. низк. ур. воды"
    palundra()
  end
  
  if rad.getRads() > 10 then
    radBeep = true
  else
    radBeep = false
  end
  
  if seconds > 60 then
    local y = seconds - 60
    local z = seconds - y
  end
  
  while #neutrons.values > 0 and (seconds - neutrons.values[1][1]) > 30 do
    table.remove(neutrons.values, 1)
  end
  while #power_graph.values > 0 and (seconds - power_graph.values[1][1]) > 30 do
    table.remove(power_graph.values, 1)
  end

  local _, phe = power_gauge.getTransfer()
  table.insert(power_graph.values, {seconds, phe})
  table.insert(neutrons.values, {seconds, f1.getFluxQuantity() + f2.getFluxQuantity() + f3.getFluxQuantity() + f4.getFluxQuantity()})
  
  seconds = seconds + 1
end

local logSeparator = ", "

local logHandler = event.addHandler(function() -- PLS KILL ME
  f.append(logsPath, "\n" .. os.date("%d %b %Y %H:%M:%S", system.getTime()) .. 
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
  --logHandle:close()
  window:remove()
end

actionButtons.minimize.onTouch = function()
  window:minimize()
end

workspace:draw()

