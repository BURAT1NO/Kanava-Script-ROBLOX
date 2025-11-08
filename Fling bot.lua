-- Создание передвигаемого GUI для Fling (телепортация внутрь + вращение + заморозка) + Выбор цели по клику + Закрытие по Insert
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService") -- Для обработки Insert

-- Создаем главный фрейм
local flingGui = Instance.new("ScreenGui")
flingGui.Name = "FlingGUI"
flingGui.ResetOnSpawn = false
flingGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 150) -- Увеличил высоту для новой кнопки
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = flingGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
title.BorderSizePixel = 0
title.Text = "Fling Bot"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = mainFrame

-- Поле ввода ника цели
local targetNameLabel = Instance.new("TextLabel")
targetNameLabel.Name = "TargetNameLabel"
targetNameLabel.Size = UDim2.new(0.3, 0, 0, 20)
targetNameLabel.Position = UDim2.new(0.02, 0, 0, 25)
targetNameLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
targetNameLabel.BorderSizePixel = 0
targetNameLabel.Text = "Цель:"
targetNameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
targetNameLabel.Font = Enum.Font.SourceSans
targetNameLabel.TextSize = 14
targetNameLabel.TextXAlignment = Enum.TextXAlignment.Left
targetNameLabel.Parent = mainFrame

local targetNameBox = Instance.new("TextBox")
targetNameBox.Name = "TargetNameBox"
targetNameBox.Size = UDim2.new(0.65, 0, 0, 20)
targetNameBox.Position = UDim2.new(0.33, 0, 0, 25)
targetNameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
targetNameBox.BorderSizePixel = 1
targetNameBox.BorderColor3 = Color3.fromRGB(70, 70, 90)
targetNameBox.Text = ""
targetNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
targetNameBox.Font = Enum.Font.SourceSans
targetNameBox.TextSize = 14
targetNameBox.ClearTextOnFocus = false
targetNameBox.Parent = mainFrame

-- Кнопка выбора цели по клику
local selectTargetButton = Instance.new("TextButton")
selectTargetButton.Name = "SelectTargetButton"
selectTargetButton.Size = UDim2.new(0.96, 0, 0, 25)
selectTargetButton.Position = UDim2.new(0.02, 0, 0, 50)
selectTargetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
selectTargetButton.BorderSizePixel = 1
selectTargetButton.BorderColor3 = Color3.fromRGB(90, 90, 110)
selectTargetButton.Text = "Выбрать цель (клик)"
selectTargetButton.TextColor3 = Color3.fromRGB(230, 230, 255)
selectTargetButton.Font = Enum.Font.SourceSans
selectTargetButton.TextSize = 14
selectTargetButton.Parent = mainFrame

-- Кнопка Fling
local flingButton = Instance.new("TextButton")
flingButton.Name = "FlingButton"
flingButton.Size = UDim2.new(0.96, 0, 0, 30)
flingButton.Position = UDim2.new(0.02, 0, 0, 80) -- Сдвинул вниз
flingButton.BackgroundColor3 = Color3.fromRGB(70, 50, 50)
flingButton.BorderSizePixel = 1
flingButton.BorderColor3 = Color3.fromRGB(100, 70, 70)
flingButton.Text = "Запустить Fling"
flingButton.TextColor3 = Color3.fromRGB(255, 200, 200)
flingButton.Font = Enum.Font.SourceSansBold
flingButton.TextSize = 16
flingButton.Parent = mainFrame

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0.96, 0, 0, 25)
statusLabel.Position = UDim2.new(0.02, 0, 0, 115) -- Сдвинул вниз
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusLabel.BorderSizePixel = 0
statusLabel.Text = "Статус: Готов"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextWrapped = true
statusLabel.TextYAlignment = Enum.TextYAlignment.Center
statusLabel.Parent = mainFrame

-- Стиль для кнопок при наведении
selectTargetButton.MouseEnter:Connect(function()
    selectTargetButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
end)
selectTargetButton.MouseLeave:Connect(function()
    selectTargetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
end)

flingButton.MouseEnter:Connect(function()
    flingButton.BackgroundColor3 = Color3.fromRGB(90, 60, 60)
end)
flingButton.MouseLeave:Connect(function()
    flingButton.BackgroundColor3 = Color3.fromRGB(70, 50, 50)
end)

-- Переменные для управления
local isFlingActive = false
local isSelectingTarget = false
local flingTimerConnection = nil
local spinConnection = nil
local myHRP = nil
local targetPlayer = nil
local targetHRP = nil
local originalCFrame = nil -- Для возврата
local startTime = nil
local FLING_DURATION = 3 -- 1 секунда
local isFrozenAfter = false -- Флаг для состояния заморозки после

-- Функция обновления статуса
local function updateStatus(text)
    if statusLabel and statusLabel.Parent then
        statusLabel.Text = "Статус: " .. text
    end
end

-- Функция закрытия GUI
local function closeGUI()
    print("Fling GUI закрыт по запросу пользователя (Insert или крестик).")
    -- Останавливаем все активные процессы перед закрытием
    if isFlingActive or isFrozenAfter or isSelectingTarget then
        -- Останавливаем кручение и телепортацию
        if spinConnection then
            spinConnection:Disconnect()
            spinConnection = nil
        end
        if flingTimerConnection then
            flingTimerConnection:Disconnect()
            flingTimerConnection = nil
        end
        isFlingActive = false
        isFrozenAfter = false
        isSelectingTarget = false
        
        -- Сбрасываем угловую скорость
        if myHRP and myHRP.Parent then
            myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            myHRP.Anchored = false -- Размораживаем на всякий
        end

        -- Возвращаем на исходную позицию (если возможно)
        if myHRP and myHRP.Parent and originalCFrame then
            myHRP.CFrame = originalCFrame
            print("Fling: Возврат на исходную позицию при закрытии.")
        end
        
        -- Сброс переменных
        targetPlayer = nil
        targetHRP = nil
        myHRP = nil
        originalCFrame = nil
        startTime = nil
    end
    
    -- Удаляем GUI
    if flingGui and flingGui.Parent then
        flingGui:Destroy()
        flingGui = nil
    end
end

-- Обработчик нажатия клавиши Insert
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Игнорируем, если игра уже обработала это нажатие (например, ввод текста)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        closeGUI()
    end
end)

-- Функция выбора цели по клику
local function startTargetSelection()
    if isFlingActive or isFrozenAfter then
        updateStatus("Невозможно выбрать цель во время Fling.")
        return
    end

    isSelectingTarget = true
    updateStatus("Кликните по игроку...")
    selectTargetButton.Text = "Выбор... (кликните)"
    selectTargetButton.BackgroundColor3 = Color3.fromRGB(100, 80, 50)

    -- Функция обработки клика мыши
    local function onMouseClick()
        if not isSelectingTarget then return end

        local target = mouse.Target
        if target then
            -- Ищем Humanoid в родителях target
            local character = target:FindFirstAncestorWhichIsA("Model")
            if character then
                local plr = Players:GetPlayerFromCharacter(character)
                if plr and plr ~= player then
                    targetNameBox.Text = plr.Name
                    targetPlayer = plr
                    updateStatus("Цель выбрана: " .. plr.Name)
                    print("Fling: Цель выбрана - " .. plr.Name)
                else
                    updateStatus("Ошибка: Это не игрок.")
                end
            else
                updateStatus("Ошибка: Не найден персонаж.")
            end
        else
            updateStatus("Ошибка: Ничего не выбрано.")
        end

        -- Сброс состояния выбора
        isSelectingTarget = false
        selectTargetButton.Text = "Выбрать цель (клик)"
        selectTargetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        
        -- Отключаем обработчик клика
        mouse.Button1Down:Disconnect(onMouseClick)
    end

    -- Подключаем обработчик клика
    mouse.Button1Down:Connect(onMouseClick)
end

-- Привязываем функцию выбора цели к кнопке
selectTargetButton.MouseButton1Click:Connect(startTargetSelection)

-- Функция Fling (телепорт внутрь + вращение + заморозка)
local function toggleFling()
    if not isFlingActive and not isFrozenAfter then
        -- === ЗАПУСК FLING ===
        local targetName = targetNameBox.Text
        if not targetName or targetName == "" then
            warn("Fling: Не указан ник цели.")
            updateStatus("Ошибка: Не указан ник цели.")
            return
        end

        targetPlayer = Players:FindFirstChild(targetName)
        if not targetPlayer or not targetPlayer.Character then
            warn("Fling: Игрок с ником '" .. tostring(targetName) .. "' не найден или у него нет персонажа.")
            updateStatus("Ошибка: Игрок не найден.")
            return
        end

        if not player.Character then
            warn("Fling: У тебя нет персонажа.")
            updateStatus("Ошибка: Нет персонажа.")
            return
        end

        myHRP = player.Character:FindFirstChild("HumanoidRootPart")
        targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not myHRP then
            warn("Fling: У тебя нет HumanoidRootPart.")
            updateStatus("Ошибка: Нет HRP.")
            return
        end

        if not targetHRP then
            warn("Fling: У цели нет HumanoidRootPart.")
            updateStatus("Ошибка: У цели нет HRP.")
            return
        end

        print("Fling: Начинаем Fling на игрока " .. targetName)
        updateStatus("Запуск...")
        isFlingActive = true
        flingButton.Text = "ОСТАНОВИТЬ Fling"
        flingButton.BackgroundColor3 = Color3.fromRGB(100, 50, 50)

        -- Сохраняем оригинальную позицию
        originalCFrame = myHRP.CFrame
        startTime = tick() -- Запоминаем время начала

        -- 1. Телепортируем ВНУТРЬ цели
        myHRP.CFrame = CFrame.new(targetHRP.Position)
        print("Fling: Телепортация ВНУТРЬ " .. targetName)

        -- 2. Включаем режим кручения
        print("Fling: Режим кручения ЗАПУЩЕН!")
        updateStatus("Кручение внутри цели...")

        -- Функция кручения
        local function spin()
            if not isFlingActive or not myHRP or not myHRP.Parent then
                return -- Остановка, если что-то пошло не так
            end
            -- ОЧЕНЬ БЫСТРОЕ вращение вокруг оси Y
            local spinSpeed = 1000000
            myHRP.AssemblyAngularVelocity = Vector3.new(0, spinSpeed, 0)
            
            -- Постоянно телепортируем ВНУТРЬ (на всякий случай, если физика его выкинет)
            myHRP.CFrame = CFrame.new(targetHRP.Position)
        end

        -- Подписываемся на Heartbeat для кручения и телепортации
        spinConnection = RunService.Heartbeat:Connect(spin)

        -- 3. Таймер на 1 секунду
        local function flingTimer()
            if not isFlingActive then return end

            local currentTime = tick()
            local elapsedTime = currentTime - startTime

            if elapsedTime >= FLING_DURATION then
                -- Время вышло
                print("Fling: Время внутри цели вышло (1 секунда).")
                
                -- Останавливаем кручение и телепортацию
                if spinConnection then
                    spinConnection:Disconnect()
                    spinConnection = nil
                end
                isFlingActive = false
                
                -- Сбрасываем угловую скорость
                if myHRP and myHRP.Parent then
                    myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end

                -- Возвращаем на исходную позицию
                if myHRP and myHRP.Parent and originalCFrame then
                    myHRP.CFrame = originalCFrame
                    print("Fling: Возврат на исходную позицию.")
                end

                -- === НАЧИНАЕМ ЗАМОРОЗКУ НА 1 СЕКУНДУ ===
                updateStatus("Заморозка после...")
                isFrozenAfter = true
                
                -- Обнуляем все скорости
                if myHRP and myHRP.Parent then
                    myHRP.Velocity = Vector3.new(0, 0, 0)
                    myHRP.RotVelocity = Vector3.new(0, 0, 0)
                    myHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    -- Замораживаем через Anchored
                    myHRP.Anchored = true
                end

                -- Таймер на 1 секунду заморозки
                local freezeStartTime = tick()
                local freezeDuration = 1
                
                local function freezeTimer()
                    local currentFreezeTime = tick()
                    local freezeElapsedTime = currentFreezeTime - freezeStartTime
                    
                    if freezeElapsedTime >= freezeDuration then
                        -- Заморозка закончена
                        print("Fling: Заморозка завершена.")
                        updateStatus("Готов.")
                        
                        -- Размораживаем
                        if myHRP and myHRP.Parent then
                            myHRP.Anchored = false
                        end
                        
                        isFrozenAfter = false
                        flingButton.Text = "Запустить Fling"
                        flingButton.BackgroundColor3 = Color3.fromRGB(70, 50, 50)
                        
                        if flingTimerConnection then
                            flingTimerConnection:Disconnect()
                            flingTimerConnection = nil
                        end
                    end
                end
                
                -- Подписываемся на Heartbeat для таймера заморозки
                flingTimerConnection = RunService.Heartbeat:Connect(freezeTimer)
            end
        end

        -- Подписываемся на Heartbeat для таймера активной фазы
        flingTimerConnection = RunService.Heartbeat:Connect(flingTimer)

    elseif isFlingActive and not isFrozenAfter then
        -- === ПРЕЖДЕВРЕМЕННАЯ ОСТАНОВКА FLING ===
        print("Fling: Режим остановлен пользователем.")
        
        -- Останавливаем кручение и телепортацию
        if spinConnection then
            spinConnection:Disconnect()
            spinConnection = nil
        end
        if flingTimerConnection then
            flingTimerConnection:Disconnect()
            flingTimerConnection = nil
        end
        
        isFlingActive = false

        -- Сбрасываем угловую скорость
        if myHRP and myHRP.Parent then
            myHRP.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end

        -- Возвращаем на исходную позицию
        if myHRP and myHRP.Parent and originalCFrame then
            myHRP.CFrame = originalCFrame
            print("Fling: Возврат на исходную позицию (преждевр.).")
        end

        flingButton.Text = "Запустить Fling"
        flingButton.BackgroundColor3 = Color3.fromRGB(70, 50, 50)
        updateStatus("Прервано. Готов.")
        
        -- Сброс переменных
        targetPlayer = nil
        targetHRP = nil
        myHRP = nil
        originalCFrame = nil
        startTime = nil

    elseif isFrozenAfter then
        -- === ПОПЫТКА ОСТАНОВИТЬ ВО ВРЕМЯ ЗАМОРОЗКИ (ничего не делаем, ждем окончания) ===
        print("Fling: Невозможно остановить во время заморозки.")
        updateStatus("Заморозка активна...")
    end
end

-- Привязываем функцию Fling к кнопке
flingButton.MouseButton1Click:Connect(toggleFling)

print("Fling GUI (Комбо: телепорт ВНУТРЬ + вращение + заморозка + выбор цели) создан. Нажмите 'Выбрать цель (клик)', затем кликните по игроку, затем 'Запустить Fling'. Закрыть можно по кнопке Insert или крестику.")

-- При выходе из скрипта (если возможно) или при удалении GUI, останавливаем fling
flingGui.AncestryChanged:Connect(function()
    if flingGui and not flingGui:IsDescendantOf(game) then
        -- Просто отключаем все соединения, восстановление позиции может не сработать
        if spinConnection then
            spinConnection:Disconnect()
        end
        if flingTimerConnection then
            flingTimerConnection:Disconnect()
        end
        isFlingActive = false
        isFrozenAfter = false
        isSelectingTarget = false -- Сброс выбора цели
        -- Пытаемся разморозить на всякий
        if myHRP and myHRP.Parent then
            myHRP.Anchored = false
        end
    end
end)

-- Создаем кнопку закрытия (крестик) в правом верхнем углу
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, -5) -- Позиционируем относительно правого верхнего угла mainFrame
closeButton.AnchorPoint = Vector2.new(0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.BorderSizePixel = 1
closeButton.BorderColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 16
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Анимация при наведении на кнопку закрытия
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 80, 80)}):Play()
end)
closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play()
end)

-- Привязываем функцию закрытия к кнопке крестика
closeButton.MouseButton1Click:Connect(closeGUI)
