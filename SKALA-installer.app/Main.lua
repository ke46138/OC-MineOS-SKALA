local GUI = require("GUI")
local system = require("System")
local component = require("component")
local f = require("filesystem")
local internet = require("internet")

local page = 1

local workspace, window, menu = system.addWindow(GUI.titledWindow(1, 1, 90, 28, "Мастер установки СУЗ СКАЛА 2.0 мини", false))

local setupText1 = window:addChild(GUI.text(24, 4, 0x4B4B4B, ""))
local setupText2 = window:addChild(GUI.text(24, 5, 0x4B4B4B, ""))
local setupText3 = window:addChild(GUI.text(24, 6, 0x4B4B4B, ""))
local setupText4 = window:addChild(GUI.text(24, 10, 0x4B4B4B, ""))
local setupText5 = window:addChild(GUI.text(24, 14, 0x4B4B4B, ""))
local setupText6 = window:addChild(GUI.text(24, 18, 0x4B4B4B, ""))

local verticalList = window:addChild(GUI.list(2, 4, 20, 24, 3, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x008800, 0xFFFFFF, false))

local selector1 = 1
local selector2 = 1
local selector3 = 1
local selector4 = 1
local selector5 = 1
local selector6 = 1
local selector7 = 1
local selector8 = 1
local logsDirChooser = 1
local f1Addr, f2Addr, f3Addr, f4Addr, r1Addr, r2Addr, r3Addr, r4Addr, steamAddr, lowPressSteamAddr, waterGAddr, logsPath, geigerAddr, waterAddr = 1
local dr1Addr, dr2Addr, dr3Addr, dr4Addr, dr5Addr, dr6Addr, dr7Addr, dr8Addr, powerAddr = 1

local fTable = {}
local rTable = {}
local gTable = {}
local radTable = {}
local wTable = {}
local pTable = {}

local function update_window()
  if page == 1 then
    setupText1.text = "Добро пожаловать в мастер установки СУЗ СКАЛА 2.0 мини!"
    setupText2.text = "Обязательно прочитайте гайд по установке:"
    setupText3.text = "https://github.com/ke46138/OC-MineOS-SKALA/blob/main/INSTALLING.md"
  elseif page == 2 then
    setupText1.text = "Выберите адреса топливных стержней:"
    setupText2.text = ""
    setupText3.text = "Топливный стержень 1:     Топливный стержень 2:"
    setupText4.text = "Топливный стержень 3:     Топливный стержень 4:"
    selector1 = window:addChild(GUI.comboBox(24, 7, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector2 = window:addChild(GUI.comboBox(50, 7, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector3 = window:addChild(GUI.comboBox(24, 11, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector4 = window:addChild(GUI.comboBox(50, 11, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))

    local i = 1

    for address, name in component.list("rbmk_fuel_rod") do
      selector1:addItem(address)
      selector2:addItem(address)
      selector3:addItem(address)
      selector4:addItem(address)

      fTable[i] = address

      i = i + 1
    end
  elseif page == 3 then
    f1Addr = fTable[selector1.selectedItem]
    f2Addr = fTable[selector2.selectedItem]
    f3Addr = fTable[selector3.selectedItem]
    f4Addr = fTable[selector4.selectedItem]

    selector1:clear()
    selector2:clear()
    selector3:clear()
    selector4:clear()

    setupText1.text = "Выберите адреса регулирующих стержней:"
    setupText3.text = "Регулирующий стержень 1:     Регулирующий стержень 2:"
    setupText4.text = "Регулирующий стержень 3:     Регулирующий стержень 4:"

    local i = 1

    for address, name in component.list("rbmk_control_rod") do
      selector1:addItem(address)
      selector2:addItem(address)
      selector3:addItem(address)
      selector4:addItem(address)

      rTable[i] = address

      i = i + 1
    end
  elseif page == 4 then
    r1Addr = rTable[selector1.selectedItem]
    r2Addr = rTable[selector2.selectedItem]
    r3Addr = rTable[selector3.selectedItem]
    r4Addr = rTable[selector4.selectedItem]

    selector1:clear()
    selector2:clear()
    selector3:clear()
    selector4:clear()
    selector5 = window:addChild(GUI.comboBox(24, 15, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector6 = window:addChild(GUI.comboBox(50, 15, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector7 = window:addChild(GUI.comboBox(24, 19, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector8 = window:addChild(GUI.comboBox(50, 19, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))

    setupText1.text = "Выберите адреса дополнительных регулирующих стержней:"
    setupText3.text = "Доп. рег. стержень 1:     Доп. рег. стержень 2:"
    setupText4.text = "Доп. рег. стержень 3:     Доп. рег. стержень 4:"
    setupText5.text = "Доп. рег. стержень 5:     Доп. рег. стержень 6:"
    setupText6.text = "Доп. рег. стержень 7:     Доп. рег. стержень 8:"

    local i = 1

    for address, name in component.list("rbmk_control_rod") do
      selector1:addItem(address)
      selector2:addItem(address)
      selector3:addItem(address)
      selector4:addItem(address)
      selector5:addItem(address)
      selector6:addItem(address)
      selector7:addItem(address)
      selector8:addItem(address)

      rTable[i] = address

      i = i + 1
    end
  elseif page == 5 then
    dr1Addr = rTable[selector1.selectedItem]
    dr2Addr = rTable[selector2.selectedItem]
    dr3Addr = rTable[selector3.selectedItem]
    dr4Addr = rTable[selector4.selectedItem]
    dr5Addr = rTable[selector5.selectedItem]
    dr6Addr = rTable[selector6.selectedItem]
    dr7Addr = rTable[selector7.selectedItem]
    dr8Addr = rTable[selector8.selectedItem]

    selector4:remove()
    selector5:remove()
    selector6:remove()
    selector7:remove()
    selector8:remove()

    selector1:clear()
    selector2:clear()
    selector3:clear()
    selector4:clear()

    setupText1.text = "Выберите адреса труб с измерителем потока:"
    setupText3.text = "Датчик потока пара:        Датчик потока пара низк. давл.:"
    setupText4.text = "Датчик потока воды:"
    setupText5.text = ""
    setupText6.text = ""

    local i = 1

    for address, name in component.list("ntm_fluid_gauge") do
      selector1:addItem(address)
      selector2:addItem(address)
      selector3:addItem(address)

      gTable[i] = address

      i = i + 1
    end
  elseif page == 6 then
    steamAddr = gTable[selector1.selectedItem]
    lowPressSteamAddr = gTable[selector2.selectedItem]
    waterGAddr = gTable[selector3.selectedItem]

    selector1:remove()
    selector2:remove()
    selector3:remove()

    setupText1.text = "Выберите папку для сохранения логов:"
    setupText2.text = ""
    setupText3.text = ""
    setupText4.text = ""

    logsDirChooser = window:addChild(GUI.filesystemChooser(24, 5, 30, 2, 0xE1E1E1, 0x888888, 0x3C3C3C, 0x888888, nil, "Открыть", "Отмена", "Выберите папку", "/"))
    logsDirChooser:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_DIRECTORY)
    logsDirChooser.onSubmit = function(path)
      logsPath = path
    end
  elseif page == 7 then
    logsDirChooser:remove()
    setupText1.text = "Выберите адреса счётчика гейгера и резервуара воды:"
    setupText3.text = "Счётчик гейгера:           Резервуар воды:"
    setupText4.text = "Датчик мощности:"
    selector1 = window:addChild(GUI.comboBox(24, 7, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector2 = window:addChild(GUI.comboBox(50, 7, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector3 = window:addChild(GUI.comboBox(24, 11, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))

    local i = 1

    for address, name in component.list("ntm_geiger") do
      selector1:addItem(address)

      radTable[i] = address

      i = i + 1
    end

    local i = 1

    for address, name in component.list("ntm_fluid_tank") do
      selector2:addItem(address)

      wTable[i] = address

      i = i + 1
    end

    local i = 1

    for address, name in component.list("ntm_power_gauge") do
      selector3:addItem(address)

      pTable[i] = address

      i = i + 1
    end
  elseif page == 8 then
    geigerAddr = radTable[selector1.selectedItem]
    waterAddr = wTable[selector2.selectedItem]
    powerAddr = pTable[selector3.selectedItem]

    selector1:remove()
    selector2:remove()
    selector3:remove()
    setupText2.text = ""
    setupText3.text = ""
    setupText4.text = ""

    setupText1.text = "Настройка завершена! Идёт загрузка..."

    progressbar = window:addChild(GUI.progressBar(24, 6, 42, 0x008800, 0x696969, 0x4B4B4B, 0, true, true, "Завершено на: ", " процентов"))

    workspace:draw()

    f.makeDirectory("/Applications/SKALA.app")

    progressbar.value = 1

    workspace:draw()

    local success = f.write("/Applications/SKALA.app/Main.lua", [[local component = require("component")
local steam_gauge = component.proxy("]] .. steamAddr .. [[")
local low_press_steam_gauge = component.proxy("]] .. lowPressSteamAddr .. [[")
local water_gauge = component.proxy("]] .. waterGAddr .. [[")

local f1 = component.proxy("]] .. f1Addr .. [[")
local f2 = component.proxy("]] .. f2Addr .. [[")
local f3 = component.proxy("]] .. f3Addr .. [[")
local f4 = component.proxy("]] .. f4Addr .. [[")

local r1 = component.proxy("]] .. r1Addr .. [[")
local r2 = component.proxy("]] .. r2Addr .. [[")
local r3 = component.proxy("]] .. r3Addr .. [[")
local r4 = component.proxy("]] .. r4Addr .. [[")

local dr1 = component.proxy("]] .. dr1Addr .. [[")
local dr2 = component.proxy("]] .. dr2Addr .. [[")
local dr3 = component.proxy("]] .. dr3Addr .. [[")
local dr4 = component.proxy("]] .. dr4Addr .. [[")
local dr5 = component.proxy("]] .. dr5Addr .. [[")
local dr6 = component.proxy("]] .. dr6Addr .. [[")
local dr7 = component.proxy("]] .. dr7Addr .. [[")
local dr8 = component.proxy("]] .. dr8Addr .. [[")

local rad = component.proxy("]] .. geigerAddr .. [[")
local water_storage = component.proxy("]] .. waterAddr .. [[")
local power_gauge = component.proxy("]] .. powerAddr .. [[")
local logsPath = "]] .. logsPath .. [[SKALA.log"
--deltarune easter egg]])

    if success == false then
      GUI.alert("Ошибка при записи Main.lua!")
      return
    end

    progressbar.value = 40

    workspace:draw()

    local data, reason = internet.request("https://github.com/ke46138/OC-MineOS-SKALA/raw/refs/heads/main/SKALA-reactor-type-4f4r.app/Main.lua")

    if data then
      f.append("/Applications/SKALA.app/Main.lua", data)
    else
      GUI.alert("Ошибка при скачивании файла!")
      return
    end

    progressbar.value = 75

    workspace:draw()

    local data, reason = internet.request("https://github.com/ke46138/OC-MineOS-SKALA/raw/refs/heads/main/SKALA-reactor-type-4f4r.app/Icon.pic")

    if data then
      f.write("/Applications/SKALA.app/Icon.pic", data)
    else
      GUI.alert("Ошибка при скачивании файла!")
      return
    end

    progressbar.value = 80

    workspace:draw()

    system.createShortcut(
      "/Users/" .. system.getUser()  .. "/Desktop/SKALA",
      "/Applications/SKALA.app/"
    )

    progressbar.value = 100

    workspace:draw()

    GUI.alert("Готово! Можно закрыть программу.")
  else
    GUI.alert("Error!")
  end
end

verticalList:addItem("Добро пожаловать!")
verticalList:addItem("Настройка т. с.")
verticalList:addItem("Настройка рег. с.")
verticalList:addItem("Настр. доп. рег. с.")
verticalList:addItem("Настройка датч. пот.")
verticalList:addItem("Настройка путей")
verticalList:addItem("Настройка другого")
verticalList:addItem("Загрузка программы")
verticalList.disabled = true

window:addChild(GUI.roundedButton(80, 25, 7, 3, 0xFFFFFF, 0x555555, 0x4B4B4B, 0xFFFFFF, "Далее")).onTouch = function()
  verticalList.selectedItem = verticalList.selectedItem + 1
  page = page + 1

  if page > 8 then
    page = 8
    verticalList.selectedItem = page
  end

  update_window()
end

window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

update_window()
workspace:draw()
