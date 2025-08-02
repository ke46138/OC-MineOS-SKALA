local GUI = require("GUI")
local system = require("System")
local component = require("component")
local f = require("filesystem")
local internet = require("internet")

local page = 1

local localization = system.getCurrentScriptLocalization()
local workspace, window, menu = system.addWindow(GUI.titledWindow(1, 1, 90, 28, localization.appName, false))

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

local logsDirChooser = 1
local zirnoxAddr, geigerAddr, waterAddr, co2Addr, powerAddr, logsPath = 1
local logsPath = "/SKALAerr.log"

local zTable = {}
local rTable = {}
local gTable = {}
local radTable = {}
local wTable = {}
local pTable = {}

local function update_window()
  if page == 1 then
    setupText1.text = localization.welcome1
    setupText2.text = localization.welcome2
    setupText3.text = "https://github.com/ke46138/OC-MineOS-SKALA/blob/main/INSTALLING.md"
  elseif page == 2 then
    setupText1.text = localization.chooseZirnox
    setupText2.text = ""
    setupText3.text = ""
    setupText4.text = ""
    selector1 = window:addChild(GUI.comboBox(24, 7, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))

    local i = 1

    for address, name in component.list("zirnox_reactor") do
      selector1:addItem(address)

      zTable[i] = address

      i = i + 1
    end
  elseif page == 3 then
    zirnoxAddr = zTable[selector1.selectedItem]

    selector1:remove()

    setupText1.text = localization.chooseLogs
    setupText2.text = ""
    setupText3.text = ""
    setupText4.text = ""

    logsDirChooser = window:addChild(GUI.filesystemChooser(24, 5, 30, 2, 0xE1E1E1, 0x888888, 0x3C3C3C, 0x888888, nil, localization.open, localization.cancel, localization.chooseDirectory, "/"))
    logsDirChooser:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_DIRECTORY)
    logsDirChooser.onSubmit = function(path)
      logsPath = path
    end
  elseif page == 4 then
    logsDirChooser:remove()
    setupText1.text = localization.chooseOther
    setupText3.text = localization.chooseOther1
    setupText4.text = localization.chooseOther2
    selector1 = window:addChild(GUI.comboBox(24, 7, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector2 = window:addChild(GUI.comboBox(50, 7, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector3 = window:addChild(GUI.comboBox(24, 11, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector4 = window:addChild(GUI.comboBox(50, 11, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))

    local i = 1

    for address, name in component.list("ntm_geiger") do
      selector1:addItem(address)

      radTable[i] = address

      i = i + 1
    end

    local i = 1

    for address, name in component.list("ntm_fluid_tank") do
      selector2:addItem(address)
      selector4:addItem(address)

      wTable[i] = address

      i = i + 1
    end

    local i = 1

    for address, name in component.list("ntm_power_gauge") do
      selector3:addItem(address)

      pTable[i] = address

      i = i + 1
    end
  elseif page == 5 then
    geigerAddr = radTable[selector1.selectedItem]
    waterAddr = wTable[selector2.selectedItem]
    co2Addr = wTable[selector4.selectedItem]
    powerAddr = pTable[selector3.selectedItem]

    selector1:remove()
    selector2:remove()
    selector3:remove()
    selector4:remove()
    setupText2.text = ""
    setupText3.text = ""
    setupText4.text = ""

    setupText1.text = localization.doneLoading

    progressbar = window:addChild(GUI.progressBar(24, 6, 42, 0x008800, 0x696969, 0x4B4B4B, 0, true, true, localization.completedBy, localization.percent))

    workspace:draw()

    f.makeDirectory("/Applications/SKALA Zirnox Edition.app")
    f.makeDirectory("/Applications/SKALA Zirnox Edition.app/Localizations")

    progressbar.value = 1

    workspace:draw()

    local success = f.write("/Applications/SKALA Zirnox Edition.app/Main.lua", [[local component = require("component")
------------------------РЕАКТОР ЦИРНОКС----------------------------

local zirnox = component.proxy("]] .. zirnoxAddr .. [[")

---------------------------ДРУГОЕ---------------------------------

local rad = component.proxy("]] .. geigerAddr .. [[")
local water_storage = component.proxy("]] .. waterAddr .. [[")
local co2_storage = component.proxy("]] .. co2Addr .. [[")
local power_gauge = component.proxy("]] .. powerAddr .. [[")
local redstone = component.get("redstone")

local logsPath = "]] .. logsPath .. [[SKALA.log"

------------------------------------------------------------------
-- Deltarune easter egg
-- Пятая глава выйдет 06.XX.2026
-- Driving in my car right after a beer...... King chariot never be stopped
]])

    if success == false then
      GUI.alert(localization.Error1)
      return
    end

    progressbar.value = 40

    workspace:draw()

    local data, reason = internet.request("https://github.com/ke46138/OC-MineOS-SKALA/raw/refs/heads/main/SKALA-reactor-zirnox.app/Main.lua")

    if data then
      f.append("/Applications/SKALA Zirnox Edition.app/Main.lua", data)
    else
      GUI.alert(localization.Error2)
      return
    end

    progressbar.value = 75

    workspace:draw()

    local data, reason = internet.request("https://github.com/ke46138/OC-MineOS-SKALA/raw/refs/heads/main/SKALA-reactor-zirnox.app/Icon.pic")

    if data then
      f.write("/Applications/SKALA Zirnox Edition.app/Icon.pic", data)
    else
      GUI.alert(localization.Error3)
      return
    end
    
    local data, reason = internet.request("https://github.com/ke46138/OC-MineOS-SKALA/raw/refs/heads/main/SKALA-reactor-zirnox.app/Localizations/Russian.lang")
    
    if data then
      f.write("/Applications/SKALA Zirnox Edition.app/Localizations/Russian.lang", data)
    else
      GUI.alert(localization.Error4)
      return
    end
    
    local data, reason = internet.request("https://github.com/ke46138/OC-MineOS-SKALA/raw/refs/heads/main/SKALA-reactor-zirnox.app/Localizations/English.lang")
    
    if data then
      f.write("/Applications/SKALA Zirnox Edition.app/Localizations/English.lang", data)
    else
      GUI.alert(localization.Error5)
      return
    end

    progressbar.value = 80

    workspace:draw()

    system.createShortcut(
      "/Users/" .. system.getUser()  .. "/Desktop/SKALA Zirnox Edition",
      "/Applications/SKALA Zirnox Edition.app/"
    )

    progressbar.value = 100

    workspace:draw()

    GUI.alert(localization.done)
  else
    GUI.alert("Error!")
  end
end

verticalList:addItem(localization.welcome)
verticalList:addItem(localization.zirnoxSet)
verticalList:addItem(localization.pathsSet)
verticalList:addItem(localization.otherSet)
verticalList:addItem(localization.downloadApp)
verticalList.disabled = true

window:addChild(GUI.roundedButton(80, 25, 7, 3, 0xFFFFFF, 0x555555, 0x4B4B4B, 0xFFFFFF, localization.next)).onTouch = function()
  verticalList.selectedItem = verticalList.selectedItem + 1
  page = page + 1

  if page > 5 then
    page = 5
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

