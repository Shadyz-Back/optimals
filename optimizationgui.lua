wait(4)

local folderName = "BoostGUI"
local fileName = "settings.json"
local filePath = folderName .. "/" .. fileName

local UserInputService = game:GetService("UserInputService")
local guiEnabled = false

-- Create the GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RenderUnscrewer"
gui.Parent = game.Players.LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(1, -220, 0.5, -50) -- Adjusted position to middle-right
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.Active = true
frame.Parent = gui

local enableButton = Instance.new("TextButton")
enableButton.Name = "EnableButton"
enableButton.Size = UDim2.new(0.9, 0, 0, 30)
enableButton.Position = UDim2.new(0.05, 0, 0.1, 0)
enableButton.BackgroundTransparency = 1
enableButton.Text = "[i] Enable Rendering"  
enableButton.Font = Enum.Font.SourceSansBold
enableButton.TextSize = 18
enableButton.TextColor3 = Color3.fromRGB(255, 255, 255)
enableButton.Parent = frame

local disableButton = enableButton:Clone()
disableButton.Name = "DisableButton"
disableButton.Position = UDim2.new(0.05, 0, 0.4, 0)
disableButton.Text = "[o] Disable Rendering"
disableButton.Parent = frame

local closeButton = enableButton:Clone()
closeButton.Name = "CloseButton"
closeButton.Position = UDim2.new(0.05, 0, 0.7, 0)
closeButton.Text = "[p] Close GUI"
closeButton.Parent = frame

-- Function to enable rendering
local function enableRendering()
    writefile(filePath, '{"render":true}')
    setfpscap(60)
    game:GetService("RunService"):Set3dRenderingEnabled(true)
    workspace.ClientAnimatorThrottling = Enum.ClientAnimatorThrottlingMode.Disabled
    workspace.InterpolationThrottling = Enum.InterpolationThrottlingMode.Disabled
    workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Full
    sethiddenproperty(workspace.Terrain, "Decoration", true)
    game:GetService("Lighting").GlobalShadows = true
end

-- Function to disable rendering
local function disableRendering()
    setfpscap(15)
    writefile(filePath, '{"render":false}')
    game:GetService("RunService"):Set3dRenderingEnabled(false)
    workspace.ClientAnimatorThrottling = Enum.ClientAnimatorThrottlingMode.Enabled
    workspace.InterpolationThrottling = Enum.InterpolationThrottlingMode.Enabled
    workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
    sethiddenproperty(workspace.Terrain, "Decoration", false)
    game:GetService("Lighting").GlobalShadows = false
end

-- Function to close the GUI without toggling rendering
local function closeGUI()
    gui:Destroy()
    guiEnabled = false
end

-- Connect button click events
enableButton.MouseButton1Click:Connect(enableRendering)
disableButton.MouseButton1Click:Connect(disableRendering)
closeButton.MouseButton1Click:Connect(closeGUI)

-- Function to handle key presses
local function onKeyPress(input)
    if not guiEnabled then
        return
    end
    
    if input.KeyCode == Enum.KeyCode.I then
        enableRendering()
    elseif input.KeyCode == Enum.KeyCode.O then
        disableRendering()
    elseif input.KeyCode == Enum.KeyCode.P then
        closeGUI()
    end
end

-- Connect the key press event
UserInputService.InputBegan:Connect(onKeyPress)

guiEnabled = true

-- Function to check if a folder exists, if not, create it
local function createFolderIfNotExists()
    if not isfolder(folderName) then
        makefolder(folderName)
    end
end

-- Function to create the settings file if it doesn't exist
local function createSettingsFileIfNotExists()
    createFolderIfNotExists()
    if not isfile(filePath) then
        writefile(filePath, '{"render":true}')
    end
end

-- Create the settings file if it doesn't exist
createSettingsFileIfNotExists()

-- Read the settings from the file
local settingsData = game:GetService("HttpService"):JSONDecode(readfile(filePath))

-- Check if the "render" setting is true or false and execute the corresponding code
if settingsData.render then
    enableRendering()
else
    disableRendering()
end
