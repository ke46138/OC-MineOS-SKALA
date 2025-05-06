local GUI = require("GUI")
local system = require("System")
local component = require("component")

---------------------------------------------------------------------------------

-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.titledWindow(1, 1, 80, 25, "Мастер установки СУЗ СКАЛА 2.0 мини", false)) -- e1e1e1

-- Add single cell layout to window
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

local setupText1 = window:addChild(GUI.text(24, 4, 0x4B4B4B, "Добро пожаловать в мастер установки СУЗ СКАЛА 2.0 мини!"))

local setupText2 = window:addChild(GUI.text(24, 6, 0x4B4B4B, ""))

local setupText3 = window:addChild(GUI.text(24, 10, 0x4B4B4B, ""))

local verticalList = window:addChild(GUI.list(2, 4, 20, 20, 3, 0, 0xE1E1E1, 0x4B4B4B, 0xD2D2D2, 0x4B4B4B, 0x008800, 0xFFFFFF, false)) -- 0x3366CC

local selector1 = 1
local selector2 = 1
local selector3 = 1
local selector4 = 1

local selector4Destroyed = false

local function update_window()
  if verticalList.selectedItem == 1 then
    setupText1.text = "Добро пожаловать в мастер установки СУЗ СКАЛА 2.0 мини!"
  elseif verticalList.selectedItem == 2 then
    selector4Destroyed = false
    setupText1.text = "Выберите адреса топливных стержней."
    setupText2.text = "Топливный стержень 1:     Топливный стержень 2:"
    setupText3.text = "Топливный стержень 3:     Топливный стержень 4:"
    selector1 = window:addChild(GUI.comboBox(24, 7, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector2 = window:addChild(GUI.comboBox(50, 7, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector3 = window:addChild(GUI.comboBox(24, 11, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    selector4 = window:addChild(GUI.comboBox(50, 11, 21, 2, 0xEEEEEE, 0x2D2D2D, 0xCCCCCC, 0x888888))
    for address, name in component.list("rbmk_fuel_rod") do
      selector1:addItem(address)
      selector2:addItem(address)
      selector3:addItem(address)
      selector4:addItem(address)
    end
  elseif verticalList.selectedItem == 3 then
    selector1:clear()
    selector2:clear()
    selector3:clear()
    selector4:clear()
    
    setupText1.text = "Выберите адреса регулирующих стержней."
    setupText2.text = "Регулирующий стержень 1:     Регулирующий стержень 2:"
    setupText3.text = "Регулирующий стержень 3:     Регулирующий стержень 4:"
    for address, name in component.list("rbmk_control_rod") do
      selector1:addItem(address)
      selector2:addItem(address)
      selector3:addItem(address)
      selector4:addItem(address)
    end
  elseif verticalList.selectedItem == 4 then
    if not selector4Destroyed then
      selector4:remove()
      selector4Destroyed = true
    end
    
    selector4 = 1
    
    selector1:clear()
    selector2:clear()
    selector3:clear()
    
    setupText1.text = "Выберите адреса труб с измерителем потока."
    setupText2.text = "Датчик потока пара:     Датчик потока пара низк. давл.:"
    setupText3.text = "Датчик потока воды:"
    
    for address, name in component.list("ntm_fluid_gauge") do
      selector1:addItem(address)
      selector2:addItem(address)
      selector3:addItem(address)
    end
  elseif verticalList.selectedItem == 5 then
    
  else
    
  end
end

verticalList:addItem("Добро пожаловать!").onTouch = update_window
verticalList:addItem("Настройка т. с.").onTouch = update_window
verticalList:addItem("Настройка рег. с.").onTouch = update_window
verticalList:addItem("Настройка датч. пот.").onTouch = update_window
verticalList:addItem("Настройка другого").onTouch = update_window

window:addChild(GUI.roundedButton(70, 22, 7, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Далее")).onTouch = function()
  verticalList.selectedItem = verticalList.selectedItem + 1
  update_window()
end

-- Create callback function with resizing rules when window changes its' size
window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

---------------------------------------------------------------------------------

-- Draw changes on screen after customizing your window
workspace:draw()
