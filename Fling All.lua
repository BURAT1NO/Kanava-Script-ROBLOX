-- Fling All GUI (блять, отдельный, как ты хотел)
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Создаем GUI для Fling All
local flingAllGui = Instance.new("ScreenGui")
flingAllGui.Name = "FlingAllGUI"
flingAllGui.ResetOnSpawn = false
flingAllGui.Parent = player:WaitForChild("PlayerGui")

local flingAllFrame = Instance.new("Frame")
flingAllFrame.Name = "FlingAllFrame"
flingAllFrame.Size = UDim2.new(0, 250, 0, 120)
flingAllFrame.Position = UDim2.new(0.5, -125, 0.3, -60) -- Позиция чуть выше центра
flingAllFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
flingAllFrame.BorderSizePixel = 2
flingAllFrame.BorderColor3 = Color3.fromRGB(90, 60, 120)
flingAllFrame.Active = true
flingAllFrame.Draggable = true
flingAllFrame.Parent = flingAllGui

-- Заголовок
local flingAllTitle = Instance.new("TextLabel")
flingAllTitle.Name = "Title"
flingAllTitle.Size = UDim2.new(1, 0, 0, 25)
flingAllTitle.Position = UDim2.new(0, 0, 0, 0)
flingAllTitle.BackgroundColor3 = Color3.fromRGB(50, 30, 70)
flingAllTitle.BorderSizePixel = 0
flingAllTitle.Text = "FLING ALL CONTROLLER"
flingAllTitle.TextColor3 = Color3.fromRGB(255, 150, 200)
flingAllTitle.Font = Enum.Font.SourceSansBold
flingAllTitle.TextSize = 16
flingAllTitle.Parent = flingAllFrame

-- Статус
local flingAllStatus = Instance.new("TextLabel")
flingAllStatus.Name = "Status"
flingAllStatus.Size = UDim2.new(0.96, 0, 0, 30)
flingAllStatus.Position = UDim2.new(0.02, 0, 0, 30)
flingAllStatus.BackgroundColor3 = Color3.fromRGB(40, 25, 55)
flingAllStatus.BorderSizePixel = 0
flingAllStatus.Text = "Статус: Ожидание запуска"
flingAllStatus.TextColor3 = Color3.fromRGB(220, 200, 240)
flingAllStatus.Font = Enum.Font.SourceSans
flingAllStatus.TextSize = 14
flingAllStatus.TextWrapped = true
flingAllStatus.TextYAlignment = Enum.TextYAlignment.Center
flingAllStatus.Parent = flingAllFrame

-- Кнопка запуска/остановки
local flingAllToggleButton = Instance.new("TextButton")
flingAllToggleButton.Name = "ToggleButton"
flingAllToggleButton.Size = UDim2.new(0.96, 0, 0, 35)
flingAllToggleButton.Position = UDim2.new(0.02, 0, 0, 65)
flingAllToggleButton.BackgroundColor3 = Color3.fromRGB(80, 40, 100)
flingAllToggleButton.BorderSizePixel = 1
flingAllToggleButton.BorderColor3 = Color3.fromRGB(130, 80, 160)
flingAllToggleButton.Text = "ЗАПУСТИТЬ FLING ALL"
flingAllToggleButton.TextColor3 = Color3.fromRGB(255, 220, 255)
flingAllToggleButton.Font = Enum.Font.SourceSansBold
flingAllToggleButton.TextSize = 16
flingAllToggleButton.Parent = flingAllFrame

-- Стиль для кнопки при наведении
flingAllToggleButton.MouseEnter:Connect(function()
    TweenService:Create(flingAllToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 60, 140)}):Play()
end)
flingAllToggleButton.MouseLeave:Connect(function()
    TweenService:Create(flingAllToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 40, 100)}):Play()
end)

-- Переменные для Fling All
local flingAllEnabled = false
local flingAllCoroutine = nil
local currentFlingTargetName = "Никого"

-- Функция обновления статуса Fling All
local function updateFlingAllStatus(text)
    if flingAllStatus and flingAllStatus.Parent then
        flingAllStatus.Text = "Статус: " .. text
    end
end

-- Функция закрытия GUI Fling All
local function closeFlingAllGUI()
    print("Fling All GUI закрыт.")
    flingAllEnabled = false -- Останавливаем Fling All
    -- Корутина сама остановится
    if flingAllGui and flingAllGui.Parent then
        flingAllGui:Destroy()
        flingAllGui = nil
    end
end

-- Обработчик клавиши Insert для закрытия этого GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert and flingAllGui and flingAllGui.Parent then
        closeFlingAllGUI()
    end
end)

-- === Логика Fling All ===
-- (скопирована и адаптирована из предыдущего кода)

local flingTimerConnection_FA = nil
local spinConnection_FA = nil
local myHRP_FA = nil
local targetHRP_FA = nil
local originalCFrame_FA = nil
local startTime_FA = nil
local FLING_DURATION_FA = 1.5 -- Время флинга одного игрока
local isFrozenAfter_FA = false

local function stopCurrentFling_FA()
    if spinConnection_FA then
        spinConnection_FA:Disconnect()
        spinConnection_FA = nil
    end
    if flingTimerConnection_FA then
        flingTimerConnection_FA:Disconnect()
        flingTimerConnection_FA = nil
    end

    if myHRP_FA and myHRP_FA.Parent then
        myHRP_FA.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        myHRP_FA.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        myHRP_FA.Anchored = false
    end

    -- Возврат не делаем, чтобы не мешать основному движению
    myHRP_FA = nil
    targetHRP_FA = nil
    originalCFrame_FA = nil
    startTime_FA = nil
end

local function flingSingleTarget_FA(targetPlayer_FA)
    if not targetPlayer_FA or not targetPlayer_FA.Character or targetPlayer_FA == player then
        return false
    end

    if not player.Character then
        warn("FlingAll_FA: Нет персонажа.")
        return false
    end

    myHRP_FA = player.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP_local_FA = targetPlayer_FA.Character:FindFirstChild("HumanoidRootPart")

    if not myHRP_FA then
        warn("FlingAll_FA: Нет HumanoidRootPart.")
        return false
    end

    if not targetHRP_local_FA then
        warn("FlingAll_FA: У цели нет HumanoidRootPart.")
        return false
    end

    print("FlingAll_FA: Начинаем Fling на " .. targetPlayer_FA.Name)
    currentFlingTargetName = targetPlayer_FA.Name
    targetHRP_FA = targetHRP_local_FA

    originalCFrame_FA = myHRP_FA.CFrame
    startTime_FA = tick()

    local function multiTeleportAndSpin_FA()
        if not flingAllEnabled or not myHRP_FA or not myHRP_FA.Parent or not targetHRP_FA or not targetHRP_FA.Parent then
            return
        end
        myHRP_FA.CFrame = CFrame.new(targetHRP_FA.Position)
        
        -- Жесткий флинг
        local spinSpeedY = 150000 * 10
        local spinSpeedX = 150000 * 2
        local spinSpeedZ = 150000 * 1
        
        myHRP_FA.AssemblyAngularVelocity = Vector3.new(spinSpeedX, spinSpeedY, spinSpeedZ)
        local upForce = 150000 / 100
        myHRP_FA.AssemblyLinearVelocity = Vector3.new(0, upForce, 0)
    end

    if spinConnection_FA then spinConnection_FA:Disconnect() end
    spinConnection_FA = RunService.Heartbeat:Connect(multiTeleportAndSpin_FA)

    local function singleFlingTimer_FA()
        if not flingAllEnabled or not startTime_FA then return end

        local currentTime = tick()
        local elapsedTime = currentTime - startTime_FA

        if elapsedTime >= FLING_DURATION_FA then
            print("FlingAll_FA: Fling на " .. currentFlingTargetName .. " завершен.")
            stopCurrentFling_FA()
            
            -- Мега-заморозка
            isFrozenAfter_FA = true
            if myHRP_FA and myHRP_FA.Parent then
                myHRP_FA.Velocity = Vector3.new(0, 0, 0)
                myHRP_FA.RotVelocity = Vector3.new(0, 0, 0)
                myHRP_FA.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                myHRP_FA.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                myHRP_FA.Anchored = true
            end

            local freezeStartTime = tick()
            local freezeDuration = 1
            
            local function freezeTimer_FA()
                local currentFreezeTime = tick()
                local freezeElapsedTime = currentFreezeTime - freezeStartTime
                
                if freezeElapsedTime >= freezeDuration or not flingAllEnabled then
                    print("FlingAll_FA: Заморозка после " .. currentFlingTargetName .. " завершена.")
                    isFrozenAfter_FA = false
                    if myHRP_FA and myHRP_FA.Parent then
                        myHRP_FA.Anchored = false
                    end
                    
                    if flingTimerConnection_FA then
                        flingTimerConnection_FA:Disconnect()
                        flingTimerConnection_FA = nil
                    end
                end
            end
            
            if flingTimerConnection_FA then flingTimerConnection_FA:Disconnect() end
            flingTimerConnection_FA = RunService.Heartbeat:Connect(freezeTimer_FA)
        end
    end

    if flingTimerConnection_FA then flingTimerConnection_FA:Disconnect() end
    flingTimerConnection_FA = RunService.Heartbeat:Connect(singleFlingTimer_FA)
    return true
end

local function flingAllLoop_FA()
    updateFlingAllStatus("Запущен. Ищу цели...")
    while flingAllEnabled do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            updateFlingAllStatus("Жду персонажа...")
            wait(1)
            continue
        end

        local players = Players:GetPlayers()
        local targetFound_FA = false

        for _, targetPlayer_FA_loop in ipairs(players) do
            if not flingAllEnabled then break end
            
            if targetPlayer_FA_loop ~= player and targetPlayer_FA_loop.Character and targetPlayer_FA_loop.Character:FindFirstChild("HumanoidRootPart") then
                updateFlingAllStatus("Флингую: " .. targetPlayer_FA_loop.Name)
                if flingSingleTarget_FA(targetPlayer_FA_loop) then
                    targetFound_FA = true
                    -- Ждем завершения флинга и заморозки
                    while flingAllEnabled and (currentFlingTargetName == targetPlayer_FA_loop.Name and (spinConnection_FA or flingTimerConnection_FA or isFrozenAfter_FA)) do
                        wait(0.1)
                    end
                    -- Пауза перед следующим
                    if flingAllEnabled then
                        wait(0.3) -- Уменьшил паузу
                    end
                end
            end
            
            if not flingAllEnabled then break end
        end

        if not targetFound_FA then
            updateFlingAllStatus("Нет целей. Жду...")
            wait(1)
        end
    end
    updateFlingAllStatus("Остановлен.")
    print("FlingAll_FA: Цикл остановлен.")
    -- Очистка
    myHRP_FA = nil
    targetHRP_FA = nil
    originalCFrame_FA = nil
    spinConnection_FA = nil
    flingTimerConnection_FA = nil
    startTime_FA = nil
    currentFlingTargetName = "Никого"
end

-- Функция переключения Fling All
local function toggleFlingAll()
    flingAllEnabled = not flingAllEnabled
    if flingAllEnabled then
        print("Fling All (отдельный GUI) запущен.")
        flingAllToggleButton.Text = "ОСТАНОВИТЬ FLING ALL"
        flingAllToggleButton.BackgroundColor3 = Color3.fromRGB(130, 50, 50)
        -- Останавливаем предыдущий, если был
        if flingAllCoroutine and coroutine.status(flingAllCoroutine) ~= "dead" then
            -- coroutine.close(flingAllCoroutine) -- Не во всех версиях Luau доступно
            flingAllEnabled = false -- Останавливаем предыдущий
            wait(0.1) -- Ждем чуть
            flingAllEnabled = true -- Включаем снова
        end
        -- Запускаем новый
        flingAllCoroutine = coroutine.create(flingAllLoop_FA)
        coroutine.resume(flingAllCoroutine)
    else
        print("Fling All (отдельный GUI) остановлен.")
        flingAllToggleButton.Text = "ЗАПУСТИТЬ FLING ALL"
        flingAllToggleButton.BackgroundColor3 = Color3.fromRGB(80, 40, 100)
        stopCurrentFling_FA()
        -- Корутина сама остановится по флагу flingAllEnabled
        updateFlingAllStatus("Остановлен пользователем.")
    end
end

-- Привязываем функцию к кнопке
flingAllToggleButton.MouseButton1Click:Connect(toggleFlingAll)

-- Кнопка закрытия (крестик) для Fling All GUI
local closeFlingAllButton = Instance.new("TextButton")
closeFlingAllButton.Name = "CloseButton"
closeFlingAllButton.Size = UDim2.new(0, 22, 0, 22)
closeFlingAllButton.Position = UDim2.new(1, -27, 0, 3) -- Позиционируем внутри заголовка
closeFlingAllButton.BackgroundColor3 = Color3.fromRGB(180, 80, 80)
closeFlingAllButton.BorderSizePixel = 1
closeFlingAllButton.BorderColor3 = Color3.fromRGB(220, 120, 120)
closeFlingAllButton.Text = "X"
closeFlingAllButton.TextColor3 = Color3.fromRGB(255, 240, 240)
closeFlingAllButton.Font = Enum.Font.SourceSansBold
closeFlingAllButton.TextSize = 14
closeFlingAllButton.Parent = flingAllTitle -- Родитель - заголовок

local closeFlingAllCorner = Instance.new("UICorner")
closeFlingAllCorner.CornerRadius = UDim.new(0, 5)
closeFlingAllCorner.Parent = closeFlingAllButton

closeFlingAllButton.MouseEnter:Connect(function()
    TweenService:Create(closeFlingAllButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 100, 100)}):Play()
end)
closeFlingAllButton.MouseLeave:Connect(function()
    TweenService:Create(closeFlingAllButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 80, 80)}):Play()
end)

closeFlingAllButton.MouseButton1Click:Connect(closeFlingAllGUI)

print("Отдельный Fling All GUI создан! Нажмите 'ЗАПУСТИТЬ FLING ALL'. Закрыть можно кнопкой 'X' или Insert.")

-- Обработка удаления GUI
flingAllGui.AncestryChanged:Connect(function()
    if flingAllGui and not flingAllGui:IsDescendantOf(game) then
        flingAllEnabled = false
        if spinConnection_FA then
            spinConnection_FA:Disconnect()
        end
        if flingTimerConnection_FA then
            flingTimerConnection_FA:Disconnect()
        end
        myHRP_FA = nil
        targetHRP_FA = nil
        originalCFrame_FA = nil
        spinConnection_FA = nil
        flingTimerConnection_FA = nil
        startTime_FA = nil
        currentFlingTargetName = "Никого"
    end
end)
