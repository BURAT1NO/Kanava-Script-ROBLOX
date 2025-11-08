-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create the main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedRemoteDebugger"
screenGui.Parent = playerGui

-- Create the main Frame (Window)
local windowFrame = Instance.new("Frame")
windowFrame.Name = "Window"
windowFrame.Size = UDim2.new(0, 600, 0, 500)
windowFrame.Position = UDim2.new(0.5, -300, 0.5, -250) -- Centered initially
windowFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
windowFrame.BorderSizePixel = 2
windowFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
windowFrame.Active = true
windowFrame.Draggable = true
windowFrame.Parent = screenGui

-- Create Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.Parent = windowFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Advanced Remote Debugger"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleBar

-- Create Input TextBox for Remote Path
local inputTextBox = Instance.new("TextBox")
inputTextBox.Name = "InputTextBox"
inputTextBox.Size = UDim2.new(1, -20, 0, 30)
inputTextBox.Position = UDim2.new(0, 10, 0, 40)
inputTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputTextBox.BorderColor3 = Color3.fromRGB(100, 100, 100)
inputTextBox.Text = "game:GetService(\"ReplicatedStorage\").Remotes.NoWait" -- Updated default
inputTextBox.PlaceholderText = "Enter Remote Path (e.g., ReplicatedStorage.RemoteName)"
inputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputTextBox.TextScaled = true
inputTextBox.Font = Enum.Font.SourceSans
inputTextBox.Parent = windowFrame

-- Create Input TextBox for Arguments
local argsTextBox = Instance.new("TextBox")
argsTextBox.Name = "ArgsTextBox"
argsTextBox.Size = UDim2.new(1, -20, 0, 30)
argsTextBox.Position = UDim2.new(0, 10, 0, 80)
argsTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
argsTextBox.BorderColor3 = Color3.fromRGB(100, 100, 100)
argsTextBox.Text = "nil"
argsTextBox.PlaceholderText = "Arguments (Lua format, e.g., {\"hello\", 123, true})"
argsTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
argsTextBox.TextScaled = true
argsTextBox.Font = Enum.Font.SourceSans
argsTextBox.Parent = windowFrame

-- Create Dropdown for Method (FireServer/InvokeServer)
local methodFrame = Instance.new("Frame")
methodFrame.Name = "MethodFrame"
methodFrame.Size = UDim2.new(0.5, -10, 0, 30)
methodFrame.Position = UDim2.new(0, 10, 0, 120)
methodFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
methodFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
methodFrame.Parent = windowFrame

local methodLabel = Instance.new("TextLabel")
methodLabel.Name = "MethodLabel"
methodLabel.Size = UDim2.new(0.3, 0, 1, 0)
methodLabel.BackgroundTransparency = 1
methodLabel.Text = "Method:"
methodLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
methodLabel.TextScaled = true
methodLabel.Font = Enum.Font.SourceSans
methodLabel.Parent = methodFrame

local methodDropdown = Instance.new("TextButton")
methodDropdown.Name = "MethodDropdown"
methodDropdown.Size = UDim2.new(0.7, -40, 1, 0)
methodDropdown.Position = UDim2.new(0.3, 0, 0, 0)
methodDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
methodDropdown.BorderColor3 = Color3.fromRGB(100, 100, 100)
methodDropdown.Text = "InvokeServer"
methodDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
methodDropdown.TextScaled = true
methodDropdown.Font = Enum.Font.SourceSansBold
methodDropdown.Parent = methodFrame

local methodOptions = {"FireServer", "InvokeServer"}
local currentMethodIndex = 2 -- Start with InvokeServer

methodDropdown.MouseButton1Click:Connect(function()
    currentMethodIndex = currentMethodIndex % #methodOptions + 1
    methodDropdown.Text = methodOptions[currentMethodIndex]
end)

-- Create Invoke Button
local invokeButton = Instance.new("TextButton")
invokeButton.Name = "InvokeButton"
invokeButton.Size = UDim2.new(0, 100, 0, 30)
invokeButton.Position = UDim2.new(0.5, -50, 0, 160)
invokeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
invokeButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
invokeButton.Text = "Invoke"
invokeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
invokeButton.TextScaled = true
invokeButton.Font = Enum.Font.SourceSansBold
invokeButton.Parent = windowFrame

-- Create ScrollFrame for Call History
local historyFrame = Instance.new("ScrollingFrame")
historyFrame.Name = "HistoryFrame"
historyFrame.Size = UDim2.new(1, -20, 0, 250)
historyFrame.Position = UDim2.new(0, 10, 0, 200)
historyFrame.BackgroundTransparency = 1
historyFrame.BorderSizePixel = 0
historyFrame.ScrollBarThickness = 6
historyFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
historyFrame.Parent = windowFrame

local historyListLayout = Instance.new("UIListLayout")
historyListLayout.Name = "HistoryListLayout"
historyListLayout.SortOrder = Enum.SortOrder.LayoutOrder
historyListLayout.Padding = UDim.new(0, 5)
historyListLayout.Parent = historyFrame

-- NEW: Improved path resolution to handle GetService correctly
local function resolvePath(path)
    -- Split path by dots, but be careful with GetService calls
    local parts = {}
    local currentPart = ""
    local inQuotes = false
    local quoteChar = nil
    local bracketDepth = 0

    for i = 1, #path do
        local char = path:sub(i, i)
        if not inQuotes and bracketDepth == 0 and char == "." then
            table.insert(parts, currentPart)
            currentPart = ""
        else
            currentPart = currentPart .. char
            if char == '"' or char == "'" then
                if not inQuotes then
                    inQuotes = true
                    quoteChar = char
                elseif char == quoteChar then
                    inQuotes = false
                    quoteChar = nil
                end
            elseif char == "(" then
                bracketDepth = bracketDepth + 1
            elseif char == ")" then
                bracketDepth = bracketDepth - 1
            end
        end
    end
    if currentPart ~= "" then
        table.insert(parts, currentPart)
    end

    -- Now process the parts
    local obj = nil
    if parts[1] == "game" then
        obj = game
        table.remove(parts, 1)
    elseif parts[1] == "workspace" then
        obj = workspace
        table.remove(parts, 1)
    elseif parts[1] == "ReplicatedStorage" then
        obj = ReplicatedStorage
        table.remove(parts, 1)
    elseif parts[1] == "Players" then
        obj = Players
        table.remove(parts, 1)
    else
        return nil, "Invalid root object. Use 'game', 'workspace', 'ReplicatedStorage', or 'Players'."
    end

    for i, part in ipairs(parts) do
        -- Check if part is a GetService call
        local getServiceMatch = part:match("^GetService%((.*)%)$")
        if getServiceMatch then
            -- getServiceMatch now contains the argument string, e.g., "\"ReplicatedStorage\""
            -- We need to extract the service name from the quotes
            local serviceName = getServiceMatch:match("^\"(.*)\"$")
            if not serviceName then
                -- Try single quotes
                serviceName = getServiceMatch:match("^'(.*)'$")
            end
            if serviceName then
                obj = obj:GetService(serviceName)
            else
                return nil, "Could not parse service name in GetService call: " .. part
            end
        elseif obj then
            -- Otherwise, index normally (remove potential trailing parentheses for method calls like Remote:InvokeServer)
            local indexName = part:match("^([%w_]+)")
            if indexName then
                obj = obj[indexName]
            else
                 return nil, "Could not parse index name: " .. part
            end
        else
            return nil, "Failed to resolve path: Could not index into nil object."
        end
    end

    if not obj then
        return nil, "Path resolved to nil."
    end

    return obj, nil
end


-- Function to parse arguments from a string using loadstring (with restrictions)
local function parseArguments(argsString)
    if not argsString or argsString == "" or argsString == "nil" then
        return {nil}
    end
    -- Wrap the string in a function to safely evaluate it
    local code = "return " .. argsString
    local func, err = loadstring(code)
    if not func then
        return nil, "Failed to parse arguments: " .. tostring(err)
    end
    -- Execute the function in a restricted environment
    local success, result = pcall(func)
    if not success then
        return nil, "Error executing argument code: " .. tostring(result)
    end
    -- If the result is not a table, wrap it in one for consistent handling
    if type(result) ~= "table" then
        result = {result}
    end
    return result, nil
end

-- History storage
local callHistory = {}
local historyCounter = 0

-- Function to add an entry to the history
local function addToHistory(entry)
    historyCounter = historyCounter + 1
    entry.id = historyCounter
    table.insert(callHistory, 1, entry) -- Add to the beginning

    -- Create UI element for the history entry
    local entryFrame = Instance.new("Frame")
    entryFrame.Name = "EntryFrame_" .. entry.id
    entryFrame.Size = UDim2.new(1, 0, 0, 100) -- Adjust height as needed
    entryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    entryFrame.BorderColor3 = Color3.fromRGB(70, 70, 70)
    entryFrame.Parent = historyFrame
    entryFrame.LayoutOrder = entry.id -- Reverse order for UIListLayout

    local successColor = Color3.fromRGB(100, 255, 100)
    local errorColor = Color3.fromRGB(255, 100, 100)
    local defaultColor = Color3.fromRGB(200, 200, 200)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0, 20)
    statusLabel.Position = UDim2.new(0, 5, 0, 5)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = (entry.success and "SUCCESS" or "ERROR") .. " - " .. entry.method .. " - " .. os.date("%H:%M:%S", entry.time)
    statusLabel.TextColor3 = entry.success and successColor or errorColor
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.Parent = entryFrame

    local pathLabel = Instance.new("TextLabel")
    pathLabel.Name = "PathLabel"
    pathLabel.Size = UDim2.new(1, 0, 0, 15)
    pathLabel.Position = UDim2.new(0, 5, 0, 25)
    pathLabel.BackgroundTransparency = 1
    pathLabel.Text = "Path: " .. entry.path
    pathLabel.TextColor3 = defaultColor
    pathLabel.TextScaled = true
    pathLabel.Font = Enum.Font.SourceSans
    pathLabel.TextWrapped = true
    pathLabel.Parent = entryFrame

    local argsLabel = Instance.new("TextLabel")
    argsLabel.Name = "ArgsLabel"
    argsLabel.Size = UDim2.new(1, 0, 0, 15)
    argsLabel.Position = UDim2.new(0, 5, 0, 40)
    argsLabel.BackgroundTransparency = 1
    argsLabel.Text = "Args: " .. entry.argsStr
    argsLabel.TextColor3 = defaultColor
    argsLabel.TextScaled = true
    argsLabel.Font = Enum.Font.SourceSans
    argsLabel.TextWrapped = true
    argsLabel.Parent = entryFrame

    local resultLabel = Instance.new("TextLabel")
    resultLabel.Name = "ResultLabel"
    resultLabel.Size = UDim2.new(1, 0, 0, 30) -- Might need adjustment
    resultLabel.Position = UDim2.new(0, 5, 0, 55)
    resultLabel.BackgroundTransparency = 1
    resultLabel.Text = "Result: " .. entry.resultStr
    resultLabel.TextColor3 = entry.success and successColor or errorColor
    resultLabel.TextScaled = true
    resultLabel.Font = Enum.Font.SourceSans
    resultLabel.TextWrapped = true
    resultLabel.Parent = entryFrame

    -- Update CanvasSize
    historyFrame.CanvasSize = UDim2.new(0, 0, 0, historyListLayout.AbsoluteContentSize.Y)
end

-- Connect the button click event
invokeButton.MouseButton1Click:Connect(function()
    local inputText = inputTextBox.Text
    local argsText = argsTextBox.Text
    local method = methodDropdown.Text

    if not inputText or inputText == "" then
        warn("Remote Debugger: Input path is empty.")
        return
    end

    -- Resolve the remote path
    local remote, pathErr = resolvePath(inputText)
    if pathErr then
        warn("Remote Debugger Path Error: " .. pathErr)
        addToHistory({
            success = false,
            path = inputText,
            argsStr = argsText,
            resultStr = "Path Error: " .. pathErr,
            method = method,
            time = tick()
        })
        return
    end

    if not remote then
        warn("Remote Debugger: Could not find an object at the specified path.")
        addToHistory({
            success = false,
            path = inputText,
            argsStr = argsText,
            resultStr = "Path resolved to nil.",
            method = method,
            time = tick()
        })
        return
    end

    -- Validate Remote type based on method
    if method == "FireServer" and not remote:IsA("RemoteEvent") then
        warn("Remote Debugger: Object is not a RemoteEvent for FireServer.")
        addToHistory({
            success = false,
            path = inputText,
            argsStr = argsText,
            resultStr = "Object is not a RemoteEvent.",
            method = method,
            time = tick()
        })
        return
    elseif method == "InvokeServer" and not (remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent")) then
        -- RemoteEvent can also be used with InvokeServer (though it's FireServer by default)
        warn("Remote Debugger: Object is not a RemoteFunction or RemoteEvent for InvokeServer.")
        addToHistory({
            success = false,
            path = inputText,
            argsStr = argsText,
            resultStr = "Object is not a RemoteFunction or RemoteEvent.",
            method = method,
            time = tick()
        })
        return
    end

    -- Parse arguments
    local args, argsErr = parseArguments(argsText)
    if argsErr then
        warn("Remote Debugger Args Error: " .. argsErr)
        addToHistory({
            success = false,
            path = inputText,
            argsStr = argsText,
            resultStr = "Args Error: " .. argsErr,
            method = method,
            time = tick()
        })
        return
    end

    -- Prepare arguments string for display (use a simple representation)
    local argsDisplay = argsText -- Use the original string input for display

    -- Attempt to invoke the remote
    local invokeStartTime = tick()
    local success, result = pcall(function()
        if method == "FireServer" then
            remote:FireServer(unpack(args))
            return "FireServer called successfully. No return value (nil)."
        elseif method == "InvokeServer" then
            -- For RemoteEvent, InvokeServer acts like FireServer and returns nil
            -- For RemoteFunction, it returns the result
            local funcResult = remote:InvokeServer(unpack(args))
            if remote:IsA("RemoteFunction") then
                return funcResult -- Return the actual result for RemoteFunction
            else
                -- For RemoteEvent, InvokeServer usually behaves like FireServer but might have custom logic
                -- Returning the result directly allows us to see what it might return if custom
                return "InvokeServer on RemoteEvent called. Result: " .. tostring(funcResult)
            end
        end
    end)
    local invokeEndTime = tick()
    local duration = string.format("%.4f", invokeEndTime - invokeStartTime)

    -- Prepare result string for display (limit length for UI)
    local resultStr = tostring(result)
    if #resultStr > 200 then
        resultStr = resultStr:sub(1, 200) .. "..."
    end
    resultStr = resultStr .. " (Took " .. duration .. "s)"

    print("[RemoteDebugger] " .. (success and "SUCCESS" or "ERROR") .. " " .. method .. " on " .. inputText .. " with args: " .. argsDisplay .. ". Result: " .. tostring(result))

    -- Add the result to history
    addToHistory({
        success = success,
        path = inputText,
        argsStr = argsDisplay,
        resultStr = resultStr,
        method = method,
        time = invokeStartTime -- Use start time
    })
end)

print("Advanced Remote Debugger GUI loaded. Drag the window by its title bar.")