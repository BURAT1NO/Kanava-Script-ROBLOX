local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "Pizda"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

-- Основной фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Selectable = true
mainFrame.Parent = gui

-- Скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Тень
local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame
shadow.ZIndex = -1

-- Заголовок с кнопкой закрытия
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 40)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "kanava by BURAT1NO"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleFrame

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.AnchorPoint = Vector2.new(0, 0.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleFrame

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

-- Закрытие GUI
closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Вкладки
local tabButtons = {}
local tabs = {}
local currentTab = "Combat"
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 30)
tabFrame.Position = UDim2.new(0, 10, 0, 45)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0, 5)
tabList.Parent = tabFrame

-- Функция создания вкладки
local function createTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 80, 1, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.Gotham
    tabButton.Parent = tabFrame

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabButton

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, -20, 1, -100)
    tabContent.Position = UDim2.new(0, 10, 0, 85)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    tabContent.Visible = false
    tabContent.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = tabContent

    tabButtons[name] = tabButton
    tabs[name] = tabContent

    -- Анимации кнопок вкладок
    tabButton.MouseEnter:Connect(function()
        if currentTab ~= name then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
        end
    end)
    tabButton.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        end
    end)
    tabButton.MouseButton1Click:Connect(function()
        currentTab = name
        for tabName, content in pairs(tabs) do
            content.Visible = tabName == name
        end
        for tabName, button in pairs(tabButtons) do
            if tabName == name then
                button.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                button.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
    end)
end

-- Создаем вкладки
createTab("Combat")
createTab("Other")
createTab("Visuals") -- Новая вкладка

-- Функция добавления переключателя во вкладку
local function addToggle(tabName, funcName, description, callback)
    if not tabs[tabName] then return end
    local functionFrame = Instance.new("Frame")
    functionFrame.Size = UDim2.new(1, 0, 0, 60)
    functionFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    functionFrame.BorderSizePixel = 0
    functionFrame.Parent = tabs[tabName]

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = functionFrame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -70, 0, 20)
    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = funcName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = functionFrame

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -70, 0, 30)
    descLabel.Position = UDim2.new(0, 10, 0, 25)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Parent = functionFrame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 50, 0, 20)
    toggle.Position = UDim2.new(1, -60, 0, 5)
    toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    toggle.BorderSizePixel = 0
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.Parent = functionFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggle

    -- Анимации переключателя
    toggle.MouseEnter:Connect(function()
        TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 90, 110)}):Play()
    end)
    toggle.MouseLeave:Connect(function()
        if toggle.Text == "OFF" then
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
        end
    end)

    local isEnabled = false
    toggle.MouseButton1Click:Connect(function()
        if toggle.Text == "OFF" then
            toggle.Text = "ON"
            toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
            isEnabled = true
            if callback then callback(true) end
        else
            toggle.Text = "OFF"
            toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
            isEnabled = false
            if callback then callback(false) end
        end
    end)

    return {
        SetState = function(state)
            if state and toggle.Text == "OFF" then
                toggle.Text = "ON"
                toggle.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
                isEnabled = true
            elseif not state and toggle.Text == "ON" then
                toggle.Text = "OFF"
                toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
                isEnabled = false
            end
        end,
        GetState = function()
            return isEnabled
        end
    }
end

-- Функция добавления кнопки во вкладку
local function addButton(tabName, buttonName, description, callback)
    if not tabs[tabName] then return end
    local functionFrame = Instance.new("Frame")
    functionFrame.Size = UDim2.new(1, 0, 0, 60)
    functionFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    functionFrame.BorderSizePixel = 0
    functionFrame.Parent = tabs[tabName]

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = functionFrame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -100, 0, 20)
    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = buttonName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 8
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = functionFrame

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -100, 0, 30)
    descLabel.Position = UDim2.new(0, 10, 0, 25)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextSize = 7
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Parent = functionFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 80, 0, 25)
    button.Position = UDim2.new(1, -90, 0, 17)
    button.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    button.BorderSizePixel = 0
    button.Text = "Жми"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 7
    button.Font = Enum.Font.GothamBold
    button.Parent = functionFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button

    -- Анимации кнопки
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 150, 220)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 130, 200)}):Play()
    end)
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 110, 180)}):Play()
        task.wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 130, 200)}):Play()
        if callback then callback() end
    end)
end

-- === Функция для добавления слайдера во вкладку (добавить после addToggle и addButton) === --
local function addSlider(tabName, sliderName, description, minValue, maxValue, defaultValue, callback)
    if not tabs[tabName] then return end

    local functionFrame = Instance.new("Frame")
    functionFrame.Name = sliderName .. "SliderFrame"
    functionFrame.Size = UDim2.new(1, 0, 0, 80) -- Увеличен размер для слайдера
    functionFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    functionFrame.BorderSizePixel = 0
    functionFrame.Parent = tabs[tabName]

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = functionFrame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -20, 0, 20)
    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = sliderName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = functionFrame

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -20, 0, 30)
    descLabel.Position = UDim2.new(0, 10, 0, 25)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Parent = functionFrame

    -- Слайдер
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Size = UDim2.new(1, -20, 0, 20)
    sliderFrame.Position = UDim2.new(0, 10, 0, 55) -- Ниже описания
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = functionFrame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderFrame

    local sliderLine = Instance.new("Frame")
    sliderLine.Name = "SliderLine"
    sliderLine.Size = UDim2.new(1, -10, 1, -10)
    sliderLine.Position = UDim2.new(0, 5, 0, 5)
    sliderLine.AnchorPoint = Vector2.new(0, 0.5)
    sliderLine.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderLine.BorderSizePixel = 0
    sliderLine.Parent = sliderFrame

    local sliderLineCorner = Instance.new("UICorner")
    sliderLineCorner.CornerRadius = UDim.new(0, 2)
    sliderLineCorner.Parent = sliderLine

    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new(0, 0, 1, 0) -- Начальная ширина 0
    sliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderLine

    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 2)
    sliderFillCorner.Parent = sliderFill

    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false
    sliderButton.Parent = sliderLine

    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 8)
    sliderButtonCorner.Parent = sliderButton

    -- Значение
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 2) -- Справа от слайдера
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame

    -- Логика слайдера
    local isDragging = false
    local currentValue = defaultValue

    local function updateSlider(value)
        currentValue = math.clamp(value, minValue, maxValue)
        local percentage = (currentValue - minValue) / (maxValue - minValue)
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderButton.Position = UDim2.new(percentage, 0, 0.5, 0)
        valueLabel.Text = tostring(math.floor(currentValue))
        if callback then callback(currentValue) end
    end

    -- Инициализация
    updateSlider(defaultValue)

    -- Ввод мыши
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
        local mousePos = UserInputService:GetMouseLocation().X
        local sliderPos = sliderLine.AbsolutePosition.X
        local sliderWidth = sliderLine.AbsoluteSize.X
        local percentage = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        local value = minValue + (maxValue - minValue) * percentage
        updateSlider(value)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = sliderLine.AbsolutePosition.X
            local sliderWidth = sliderLine.AbsoluteSize.X
            local percentage = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
            local value = minValue + (maxValue - minValue) * percentage
            updateSlider(value)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    -- Ввод касанием (для мобильных устройств)
    sliderButton.TouchTap:Connect(function()
        -- Простое увеличение/уменьшение при касании не реализовано в этом примере
        -- Можно добавить, если нужно
    end)

    return {
        SetValue = updateSlider,
        GetValue = function() return currentValue end
    }
end


-- === НОВАЯ ФУНКЦИЯ TRAIL (След из частиц при движении) === --
local trailEnabled = false
local trailToggle = nil
local trailFolder = nil
local lastTrailPosition = nil
local lastTrailCheckTime = 0
local TRAIL_PARTICLE_INTERVAL = 0 -- Интервал создания частиц (в секунді)
local lastParticleSpawnTime = 0
local TRAIL_PARTICLE_LIFETIME = 2 -- Время жизни частиц в секундах
local TRAIL_PARTICLE_SIZE = 0.2 -- Размер частиц
local TRAIL_BASE_SPEED = 0.02 -- Базовая скорость частиц
local TRAIL_MAX_SPEED = 1 -- Максимальная скорость частиц
local TRAIL_BOUNCE_MULTIPLIER = 2 -- Множитель скорости при отскоке
local TRAIL_SPEED_DAMPENING = 0.99 -- Затухание скорости
local TRAIL_MIN_SPEED_FOR_PARTICLES = 2 -- Минимальная скорость персонажа для создания частиц (studs/sec)

-- Функция для создания одной частицы следа
local function createTrailParticle(position)
    if not trailFolder or not player.Character then return end

    local part = Instance.new("Part")
    part.Name = "TrailParticle"
    part.Size = Vector3.new(TRAIL_PARTICLE_SIZE, TRAIL_PARTICLE_SIZE, TRAIL_PARTICLE_SIZE)
    part.Material = Enum.Material.Neon
    part.BrickColor = BrickColor.new("White") -- Белый цвет
    part.Shape = Enum.PartType.Ball -- Форма шара
    part.Anchored = true
    part.CanCollide = false
    part.Position = position
    part.Parent = trailFolder

    local pointLight = Instance.new("PointLight")
    pointLight.Range = 8
    pointLight.Brightness = 2
    pointLight.Color = Color3.fromRGB(255, 255, 255) -- Белый свет
    pointLight.Enabled = true
    pointLight.Parent = part

    -- Начальная скорость (слегка случайная)
    local velocity = Vector3.new(
        (math.random() - 0.5) * 2 * TRAIL_BASE_SPEED,
        (math.random() - 0.5) * 2 * TRAIL_BASE_SPEED,
        (math.random() - 0.5) * 2 * TRAIL_BASE_SPEED
    )

    local creationTime = tick()
    local lastDirectionChange = tick()
    local connection

    -- Анимация движения и исчезновения
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not part or not part.Parent or not trailEnabled then
            if connection then connection:Disconnect() end
            return
        end

        local elapsed = tick() - creationTime
        if elapsed > TRAIL_PARTICLE_LIFETIME then
            -- Плавное исчезновение
            local alpha = 1 - (elapsed - TRAIL_PARTICLE_LIFETIME) / 2 -- 2 секунды на исчезновение
            if alpha > 0 then
                part.Transparency = 1 - alpha
                pointLight.Brightness = 2 * alpha
            else
                if connection then connection:Disconnect() end
                pcall(function() part:Destroy() end) -- Используем pcall на случай, если part уже уничтожен
                return
            end
        end

        -- --- Логика движения частицы ---
        -- Перемещение
        part.Position = part.Position + velocity

        -- Очень плавное случайное изменение направления (очень редко и слабо)
        if tick() - lastDirectionChange > 2 then -- Каждые 2 секунды
            if math.random(1, 10) == 1 then -- 10% шанс
                local randomInfluence = Vector3.new(
                    (math.random() - 0.5) * TRAIL_BASE_SPEED * 0.3, -- Очень малое влияние
                    (math.random() - 0.5) * TRAIL_BASE_SPEED * 0.3,
                    (math.random() - 0.5) * TRAIL_BASE_SPEED * 0.3
                )
                velocity = velocity + randomInfluence
                -- Ограничиваем новую скорость
                local newSpeed = velocity.Magnitude
                if newSpeed > TRAIL_MAX_SPEED then
                    velocity = velocity.Unit * TRAIL_MAX_SPEED
                end
                lastDirectionChange = tick()
            end
        end

        -- Плавное затухание скорости до базовой
        local speed = velocity.Magnitude
        if speed > TRAIL_BASE_SPEED then
            velocity = velocity * TRAIL_SPEED_DAMPENING
            -- Убедимся, что скорость не упадет ниже базовой из-за затухания
            if velocity.Magnitude < TRAIL_BASE_SPEED and velocity.Magnitude > 0 then
                 velocity = velocity.Unit * TRAIL_BASE_SPEED
            end
        elseif speed < TRAIL_BASE_SPEED and speed > 0 then
            -- Плавное увеличение до базовой скорости (если как-то упала ниже)
            velocity = velocity.Unit * math.min(TRAIL_BASE_SPEED, speed / TRAIL_SPEED_DAMPENING)
        end
    end)
end

-- Основной цикл создания частиц следа
local function trailLoop()
    if not trailFolder then
        trailFolder = Instance.new("Folder")
        trailFolder.Name = "TrailParticles"
        trailFolder.Parent = workspace
    end

    while trailEnabled do
        local currentTime = tick()
        if player.Character and player.Character:IsDescendantOf(workspace) then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local currentPosition = hrp.Position

                -- Проверяем скорость каждые 0.1 секунды
                if currentTime - lastTrailCheckTime > 0.1 then
                    if lastTrailPosition then
                        local distance = (currentPosition - lastTrailPosition).Magnitude
                        local timeDiff = currentTime - lastTrailCheckTime
                        local currentSpeed = distance / timeDiff -- studs per second

                        -- Создаем частицу, если скорость выше порога и прошёл интервал
                        if currentSpeed > TRAIL_MIN_SPEED_FOR_PARTICLES and currentTime - lastParticleSpawnTime >= TRAIL_PARTICLE_INTERVAL then
                            -- Создаем частицу внутри или очень близко к игроку
                            local spawnPosition = currentPosition + Vector3.new(
                                math.random(-100, 100) / 100, -- Небольшое случайное смещение
                                math.random(-100, 100) / 100,
                                math.random(-100, 100) / 100
                            )
                            createTrailParticle(spawnPosition)
                            lastParticleSpawnTime = currentTime
                        end
                    end
                    lastTrailPosition = currentPosition
                    lastTrailCheckTime = currentTime
                end
            else
                lastTrailPosition = nil -- Сброс позиции, если HRP нет
            end
        else
            lastTrailPosition = nil -- Сброс позиции, если персонажа нет
        end
        game:GetService("RunService").Heartbeat:Wait() -- Ждем следующего кадра
    end
end

-- Переключатель для Trail
trailToggle = addToggle("Visuals", "Trail", "Создает след из светящихся частиц внутри игрока при движении", function(state)
    trailEnabled = state
    if state then
        print("Trail (След) включен")
        -- Сброс позиции и времени
        if player.Character then
             local hrp = player.Character:FindFirstChild("HumanoidRootPart")
             if hrp then
                 lastTrailPosition = hrp.Position
             end
        end
        lastTrailCheckTime = tick()
        lastParticleSpawnTime = tick() -- Сброс таймера
        -- Запуск цикла
        coroutine.resume(coroutine.create(trailLoop))
    else
        print("Trail (След) выключен")
        -- Удаляем все существующие частицы следа
        if trailFolder then
           pcall(function() trailFolder:ClearAllChildren() end)
        end
        lastTrailPosition = nil
    end
end)
-- === Конец функции Trail === --


-- === НОВАЯ ФУНКЦИЯ ДЛЯ ВКЛАДКИ VISUALS === --
local particlesEnabled = false
local particlesToggle = nil
local particlesFolder = nil
local PARTICLE_COUNT = 100 -- Количество частиц
local PARTICLE_SIZE = 0.2 -- Размер частиц
local BASE_SPEED = 0.05 -- Базовая скорость частиц
local MAX_SPEED = 1 -- Максимальная скорость частиц
local AREA_SIZE = 30 -- Половина размера области (100x100x100)
local PARTICLE_LIFETIME = 100 -- Время жизни частиц в секундах
local BOUNCE_MULTIPLIER = 2 -- Множитель скорости при отскоке
local SPEED_DAMPENING = 0.99 -- Затухание скорости (ближе к 1 = медленнее падает)

-- Функция для создания одной частицы
local function createParticle()
    if not particlesFolder or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = player.Character.HumanoidRootPart

    -- Случайная начальная позиция внутри области
    local offset = Vector3.new(
        math.random(-AREA_SIZE, AREA_SIZE),
        math.random(-AREA_SIZE, AREA_SIZE),
        math.random(-AREA_SIZE, AREA_SIZE)
    )
    local spawnPos = hrp.Position + offset

    local part = Instance.new("Part")
    part.Size = Vector3.new(PARTICLE_SIZE, PARTICLE_SIZE, PARTICLE_SIZE)
    part.CFrame = CFrame.new(spawnPos)
    part.Shape = Enum.PartType.Ball
    part.Material = Enum.Material.Neon
    part.BrickColor = BrickColor.new("Institutional white")
    part.Anchored = true
    part.CanCollide = false
    part.CastShadow = false
    part.Name = "VisualParticle"
    part.Parent = particlesFolder

    -- Добавим немного свечения
    local pointLight = Instance.new("PointLight")
    pointLight.Range = 8
    pointLight.Brightness = 2
    pointLight.Color = Color3.fromRGB(255, 255, 255)
    pointLight.Enabled = true
    pointLight.Parent = part

    -- Начальная скорость
    local velocity = Vector3.new(
        (math.random() - 0.5) * 2 * BASE_SPEED,
        (math.random() - 0.5) * 2 * BASE_SPEED,
        (math.random() - 0.5) * 2 * BASE_SPEED
    )

    local creationTime = tick()
    local lastDirectionChange = tick()
    local connection

    -- Анимация движения и исчезновения
    connection = RunService.Heartbeat:Connect(function(deltaTime) -- Используем deltaTime для более плавного движения
        if not part or not part.Parent or not particlesEnabled then
            if connection then connection:Disconnect() end
            return
        end

        local elapsed = tick() - creationTime
        if elapsed > PARTICLE_LIFETIME then
            -- Плавное исчезновение
            local alpha = 1 - (elapsed - PARTICLE_LIFETIME) / 2 -- 2 секунды на исчезновение
            if alpha > 0 then
                part.Transparency = 1 - alpha
                pointLight.Brightness = 2 * alpha
            else
                if connection then connection:Disconnect() end
                part:Destroy()
                return
            end
        end

        -- Получаем текущую позицию и позицию игрока
        local currentPos = part.Position
        local playerPos = hrp.Position

        -- Вычисляем относительную позицию частицы относительно игрока
        local relativePos = currentPos - playerPos

        -- Проверка границ и "отскок"
        local bounced = false
        if math.abs(relativePos.X) > AREA_SIZE then
            velocity = Vector3.new(-velocity.X * BOUNCE_MULTIPLIER, velocity.Y, velocity.Z)
            -- Корректируем позицию, чтобы частица не "застряла" за границей
            local sign = (relativePos.X > 0) and 1 or -1
            part.Position = Vector3.new(playerPos.X + (AREA_SIZE - 0.1) * sign, currentPos.Y, currentPos.Z)
            bounced = true
        end
        if math.abs(relativePos.Y) > AREA_SIZE then
            velocity = Vector3.new(velocity.X, -velocity.Y * BOUNCE_MULTIPLIER, velocity.Z)
            local sign = (relativePos.Y > 0) and 1 or -1
            part.Position = Vector3.new(currentPos.X, playerPos.Y + (AREA_SIZE - 0.1) * sign, currentPos.Z)
            bounced = true
        end
        if math.abs(relativePos.Z) > AREA_SIZE then
            velocity = Vector3.new(velocity.X, velocity.Y, -velocity.Z * BOUNCE_MULTIPLIER)
            local sign = (relativePos.Z > 0) and 1 or -1
            part.Position = Vector3.new(currentPos.X, currentPos.Y, playerPos.Z + (AREA_SIZE - 0.1) * sign)
            bounced = true
        end

        -- Если был отскок, ограничиваем скорость максимальной
        if bounced then
            local speed = velocity.Magnitude
            if speed > MAX_SPEED then
                velocity = velocity.Unit * MAX_SPEED
            end
        else
            -- Плавное затухание скорости до базовой, если не было отскока
            local speed = velocity.Magnitude
            if speed > BASE_SPEED then
                velocity = velocity * SPEED_DAMPENING
                -- Убедимся, что скорость не упадет ниже базовой из-за затухания
                if velocity.Magnitude < BASE_SPEED then
                   velocity = velocity.Unit * BASE_SPEED
                end
            elseif speed < BASE_SPEED then
                 -- Плавное увеличение до базовой скорости
                 velocity = velocity.Unit * math.min(BASE_SPEED, speed / SPEED_DAMPENING)
            end
        end

        -- Движение частицы
        part.Position += velocity

        -- Очень плавное случайное изменение направления (очень редко и слабо)
        if tick() - lastDirectionChange > 2 then -- Каждые 2 секунды
            if math.random(1, 10) == 1 then -- 10% шанс
                local randomInfluence = Vector3.new(
                    (math.random() - 0.5) * BASE_SPEED * 0.3, -- Очень малое влияние
                    (math.random() - 0.5) * BASE_SPEED * 0.3,
                    (math.random() - 0.5) * BASE_SPEED * 0.3
                )
                velocity += randomInfluence
                -- Ограничиваем новую скорость
                local newSpeed = velocity.Magnitude
                if newSpeed > MAX_SPEED then
                    velocity = velocity.Unit * MAX_SPEED
                end
                lastDirectionChange = tick()
            end
        end
    end)
end

-- Основной цикл создания частиц
local function particlesLoop()
    if not particlesFolder then
        particlesFolder = Instance.new("Folder")
        particlesFolder.Name = "VisualParticles"
        particlesFolder.Parent = workspace
    end

    while particlesEnabled do
        -- Создаем новые частицы, если их меньше нужного количества
        local currentCount = #particlesFolder:GetChildren() / 2 -- Делим на 2, так как у каждой частицы есть PointLight
        if currentCount < PARTICLE_COUNT then
            for i = 1, (PARTICLE_COUNT - currentCount) do
                spawn(createParticle)
            end
        end
        wait(0.1) -- Интервал между проверками
    end
end

-- Переключатель для Particles (убедитесь, что вкладка Visuals создана)
-- createTab("Visuals") -- Убедитесь, что эта строка есть в вашем коде
particlesToggle = addToggle("Visuals", "Particles", "Создает светящиеся белые кружки в воздухе", function(state)
    particlesEnabled = state
    if state then
        print("Particles включены")
        coroutine.resume(coroutine.create(particlesLoop))
    else
        print("Particles выключены")
        -- Удаляем все существующие частицы
        if particlesFolder then
            particlesFolder:ClearAllChildren()
        end
    end
end)


-- === Damage Particles Visual Effect (улучшенная версия) === --
local damageParticlesEnabled = false
local damageParticlesToggle = nil
local damageParticlesFolder = nil
local playerHealthConnections = {} -- Таблица для отслеживания соединений HealthChanged для каждого персонажа

-- Параметры эффекта частиц урона
local DAMAGE_PARTICLE_COUNT = 15
local DAMAGE_PARTICLE_SIZE = 0.2
local DAMAGE_PARTICLE_LIFETIME = 2
local DAMAGE_PARTICLE_SPEED_MIN = 3
local DAMAGE_PARTICLE_SPEED_MAX = 6
local DAMAGE_DETECTION_RANGE = 30 -- Максимальное расстояние, на котором считаем урон своим

-- Функция для создания частиц урона
local function createDamageParticles(hitPosition, hitDirection)
    if not damageParticlesEnabled or not damageParticlesFolder then return end

    for i = 1, DAMAGE_PARTICLE_COUNT do
        local particle = Instance.new("Part")
        particle.Name = "DamageParticle"
        particle.Size = Vector3.new(DAMAGE_PARTICLE_SIZE, DAMAGE_PARTICLE_SIZE, DAMAGE_PARTICLE_SIZE)
        particle.CFrame = CFrame.new(hitPosition)
        particle.Shape = Enum.PartType.Ball
        particle.Material = Enum.Material.Neon
        particle.BrickColor = BrickColor.new("Institutional white")
        particle.Anchored = true
        particle.CanCollide = false
        particle.CastShadow = false
        particle.Transparency = 0
        particle.Parent = damageParticlesFolder

        local pointLight = Instance.new("PointLight")
        pointLight.Range = 5
        pointLight.Brightness = 2
        pointLight.Color = Color3.fromRGB(255, 255, 255)
        pointLight.Enabled = true
        pointLight.Parent = particle

        local randomSpread = Vector3.new(
            (math.random() - 0.5) * 2,
            (math.random() - 0.5) * 2,
            (math.random() - 0.5) * 2
        ) * 0.5

        local particleDirection = (hitDirection + randomSpread).unit
        local particleSpeed = math.random(DAMAGE_PARTICLE_SPEED_MIN * 100, DAMAGE_PARTICLE_SPEED_MAX * 100) / 100
        local velocity = particleDirection * particleSpeed

        local startTime = tick()
        local connection

        connection = RunService.Heartbeat:Connect(function()
            if not particle or not particle.Parent then
                if connection and connection.Connected then connection:Disconnect() end
                return
            end

            local elapsed = tick() - startTime

            if elapsed > DAMAGE_PARTICLE_LIFETIME then
                local fadeElapsed = elapsed - DAMAGE_PARTICLE_LIFETIME
                local fadeTime = 0.5
                local alpha = 1 - math.clamp(fadeElapsed / fadeTime, 0, 1)

                particle.Transparency = 1 - alpha
                pointLight.Brightness = 2 * alpha

                if alpha <= 0 then
                    if connection and connection.Connected then connection:Disconnect() end
                    particle:Destroy()
                    return
                end
            end

            particle.Position += velocity * 0.1
            velocity = velocity * 0.98
        end)
    end
end

-- Функция для проверки, является ли урон "нашим"
local function isDamageFromMe(targetHumanoid, damageAmount)
    if not player.Character or damageAmount <= 0 then return false end

    local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetHumanoid.Parent:FindFirstChild("HumanoidRootPart")
    
    if not myHRP or not targetHRP then return false end

    -- Проверка 1: Расстояние
    local distance = (myHRP.Position - targetHRP.Position).Magnitude
    if distance > DAMAGE_DETECTION_RANGE then return false end

    -- Проверка 2: Состояние игрока (если KillAura выключена, смотрим на состояние)
    -- Эта проверка не 100% надежна, но добавляет уверенности
    if not _G.killAuraEnabled then -- Предполагаем, что killAuraEnabled глобальная
        local myHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if myHumanoid then
            local state = myHumanoid:GetState()
            if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Running then
                -- Скорее всего, это мы атаковали
                return true
            end
        end
    else
        -- Если KillAura включена, доверяем ей
        -- Но всё равно проверяем расстояние выше
        return true
    end

    -- Если KillAura выключена и состояние неясно, полагаемся только на расстояние
    -- Это может привести к ложным срабатываниям, если другой игрок нанесет урон вблизи вас
    return distance <= (DAMAGE_DETECTION_RANGE * 0.5) -- Более строгая проверка расстояния
end

-- Функция для установки слушателя здоровья на персонажа
local function setupHealthListener(character)
    if not character:IsDescendantOf(workspace) then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Отключаем старый слушатель, если он был
    if playerHealthConnections[character] and playerHealthConnections[character].Connection and playerHealthConnections[character].Connection.Connected then
        playerHealthConnections[character].Connection:Disconnect()
    end

    local lastHealth = humanoid.Health
    local connection = humanoid.HealthChanged:Connect(function(newHealth)
        if not damageParticlesEnabled or not character:IsDescendantOf(workspace) then
            if connection and connection.Connected then connection:Disconnect() end
            playerHealthConnections[character] = nil
            return
        end

        local damage = lastHealth - newHealth
        if damage > 0 then
            -- Проверяем, является ли урон "нашим"
            if character ~= player.Character and isDamageFromMe(humanoid, damage) then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local hitPosition = hrp.Position
                    local pushDirection = Vector3.new(0, 1, 0) -- По умолчанию вверх
                    
                    -- Направление "отталкивания" - от нашего персонажа к цели
                    if player.Character then
                        local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            pushDirection = (hrp.Position - myHRP.Position).unit
                        end
                    end
                    
                    -- Если направление не определено, используем случайное в горизонтальной плоскости
                    if pushDirection.Magnitude == 0 or (pushDirection.X == 0 and pushDirection.Y == 0 and pushDirection.Z == 0) then
                        local angle = math.random() * 2 * math.pi
                        pushDirection = Vector3.new(math.cos(angle), 0, math.sin(angle))
                    end
                    
                    -- Немного поднимаем вверх
                    pushDirection = (pushDirection + Vector3.new(0, 0.5, 0)).unit

                    createDamageParticles(hitPosition, pushDirection)
                end
            end
        end
        lastHealth = newHealth
    end)

    -- Сохраняем соединение
    playerHealthConnections[character] = {
        Connection = connection,
        Humanoid = humanoid
    }

    -- Отслеживаем удаление персонажа
    character.AncestryChanged:Connect(function()
        if not character:IsDescendantOf(workspace) then
            if connection and connection.Connected then connection:Disconnect() end
            playerHealthConnections[character] = nil
        end
    end)
end

-- Функция для очистки всех слушателей
local function clearAllHealthListeners()
    for character, data in pairs(playerHealthConnections) do
        if data.Connection and data.Connection.Connected then
            data.Connection:Disconnect()
        end
    end
    table.clear(playerHealthConnections)
end

-- Функция для установки слушателей на всех существующих игроков
local function setupAllPlayersListeners()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            setupHealthListener(plr.Character)
        end
        plr.CharacterAdded:Connect(function(character)
            if damageParticlesEnabled then
                wait(0.1) -- Небольшая задержка для полной загрузки Humanoid
                setupHealthListener(character)
            end
        end)
        plr.CharacterRemoving:Connect(function(character)
            if playerHealthConnections[character] then
                if playerHealthConnections[character].Connection and playerHealthConnections[character].Connection.Connected then
                    playerHealthConnections[character].Connection:Disconnect()
                end
                playerHealthConnections[character] = nil
            end
        end)
    end
end

-- Основная функция эффекта
local function damageParticlesLoop()
    if not damageParticlesFolder then
        damageParticlesFolder = Instance.new("Folder")
        damageParticlesFolder.Name = "DamageParticles"
        damageParticlesFolder.Parent = workspace
    end

    -- Очищаем старые соединения
    clearAllHealthListeners()
    
    -- Устанавливаем слушатели
    setupAllPlayersListeners()
    
    -- Следим за новыми игроками
    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(character)
            if damageParticlesEnabled then
                wait(0.1)
                setupHealthListener(character)
            end
        end)
        plr.CharacterRemoving:Connect(function(character)
            if playerHealthConnections[character] then
                if playerHealthConnections[character].Connection and playerHealthConnections[character].Connection.Connected then
                    playerHealthConnections[character].Connection:Disconnect()
                end
                playerHealthConnections[character] = nil
            end
        end)
    end)

    -- Основной цикл (для поддержания состояния)
    while damageParticlesEnabled do
        wait(1)
        -- Периодическая проверка на случай сбоев
    end
end

-- Добавляем переключатель в вкладку Visuals
damageParticlesToggle = addToggle("Visuals", "Damage Particles", "Частицы при нанесении урона", function(state)
    damageParticlesEnabled = state
    if state then
        print("Damage Particles включены")
        -- Очищаем на случай, если были остатки
        clearAllHealthListeners()
        if damageParticlesFolder then
            damageParticlesFolder:ClearAllChildren()
        end
        coroutine.resume(coroutine.create(damageParticlesLoop))
    else
        print("Damage Particles выключены")
        clearAllHealthListeners()
        if damageParticlesFolder then
            damageParticlesFolder:ClearAllChildren()
        end
    end
end)
-- === Конец Damage Particles === --


-- Функция удаления опасных частей
local function removeUnsafeParts()
    local dangerousFolders = {"FireParts", "KillParts", "RagdollParts"}
    local removedCount = 0
    for _, folderName in ipairs(dangerousFolders) do
        local folder = Workspace:FindFirstChild(folderName)
        if folder then
            folder:Destroy()
            removedCount += 1
            print("Удалена папка: " .. folderName)
        end
    end
    if removedCount > 0 then
        print("Удалено опасных папок: " .. removedCount)
    else
        print("Опасные папки не найдены")
    end
end

-- Функция Anti Players (телепорт от любого игрока ближе 10 studs)
local antiPlayersEnabled = false
local antiPlayersToggle = nil
local function checkAndTeleportFromPlayers()
    if not antiPlayersEnabled or not player.Character then return end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    -- Просто проверяем всех игроков вокруг
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local distance = (humanoidRootPart.Position - targetHRP.Position).Magnitude
                -- Если игрок ближе 10 studs - телепортируемся
                if distance < 20 then
                    -- Простой телепорт на случайную позицию в радиусе 20-30 studs
                    local randomAngle = math.random() * 2 * math.pi
                    local teleportDistance = math.random(20, 30)
                    local offset = Vector3.new(
                        math.cos(randomAngle) * teleportDistance,
                        0,
                        math.sin(randomAngle) * teleportDistance
                    )
                    local newPosition = humanoidRootPart.Position + offset
                    humanoidRootPart.CFrame = CFrame.new(newPosition)
                    print("Телепорт от игрока: " .. targetPlayer.Name)
                    break
                end
            end
        end
    end
end

-- Функция Anti-Void
local antiVoidEnabled = false
local antiVoidPart = nil
local antiVoidToggle = nil
local function createAntiVoidPart()
    if antiVoidPart then
        antiVoidPart:Destroy()
    end
    antiVoidPart = Instance.new("Part")
    antiVoidPart.Size = Vector3.new(500, 50, 500)
    antiVoidPart.Transparency = 1
    antiVoidPart.Anchored = true
    antiVoidPart.CanCollide = true
    antiVoidPart.Name = "AntiVoidPart"
    antiVoidPart.Parent = Workspace
end
local function updateAntiVoidPart()
    if not antiVoidEnabled or not antiVoidPart or not player.Character then return end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    -- Двигаем парт только по горизонтали, сохраняя Y позицию
    local currentPosition = antiVoidPart.Position
    antiVoidPart.Position = Vector3.new(
        humanoidRootPart.Position.X,
        currentPosition.Y,
        humanoidRootPart.Position.Z
    )
end
local function setupAntiVoid(state)
    antiVoidEnabled = state
    if state then
        createAntiVoidPart()
        if player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                -- Ставим парт на 5 studs ниже игрока
                antiVoidPart.Position = Vector3.new(
                    humanoidRootPart.Position.X,
                    humanoidRootPart.Position.Y - 27.7,
                    humanoidRootPart.Position.Z
                )
            end
        end
        print("Anti-Void включен")
    else
        if antiVoidPart then
            antiVoidPart:Destroy()
            antiVoidPart = nil
        end
        print("Anti-Void выключен")
    end
end

-- Функция Velocity (Anti-Knockback)
local velocityEnabled = false
local velocityToggle = nil
local lastPosition = nil
local lastCheckTime = 0
local isStopped = false
local stopUntilTime = 0
local safePosition = nil
local lastSafePosition = nil
local function checkVelocity()
    if not velocityEnabled or not player.Character then return end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local currentTime = tick()
    -- Сохраняем безопасную позицию когда скорость нормальная и не заморожен
    if humanoidRootPart.Velocity.Magnitude < 50 and not isStopped then
        lastSafePosition = humanoidRootPart.Position
    end
    -- Если игрок заморожен
    if isStopped then
        -- Продолжаем замораживать через Anchored
        humanoidRootPart.Anchored = true
        -- Если время заморозки прошло
        if currentTime >= stopUntilTime then
            -- Размораживаем игрока
            humanoidRootPart.Anchored = false
            isStopped = false
            print("Заморозка завершена.")
        end
        return -- Не проверяем скорость во время заморозки
    end
    -- Постоянная проверка скорости каждые 0.01 секунды
    if lastPosition and currentTime - lastCheckTime > 0.01 then
        local distance = (humanoidRootPart.Position - lastPosition).Magnitude
        local timeDiff = currentTime - lastCheckTime
        local currentSpeed = distance / timeDiff
        -- Если скорость больше 14 studs/s
        if currentSpeed > 50 then
            -- Сохраняем позицию для телепорта обратно
            safePosition = lastSafePosition or lastPosition
            -- МГНОВЕННАя ТЕЛЕПОРТАЦИЯ обратно
            if safePosition then
                -- Сначала телепортируем
                humanoidRootPart.CFrame = CFrame.new(safePosition)
                -- Обнуляем velocity
                humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                -- ЗАМОРАЖИВАЕМ игрока на 0.3 секунды через Anchored
                humanoidRootPart.Anchored = true
                isStopped = true
                stopUntilTime = currentTime + 0.3
                print("Мгновенная телепортация! Скорость: " .. math.floor(currentSpeed) .. " studs/s. Заморозка на 0.3с.")
            end
        end
    end
    lastPosition = humanoidRootPart.Position
    lastCheckTime = currentTime
end

-- Функция Тест (активация PVPTogle RemoteFunction)
local testEnabled = false
local testToggle = nil
local function activatePVPToggle()
    if not testEnabled then return end
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local pvpToggle = remotes:FindFirstChild("SetTyping")
        if pvpToggle and pvpToggle:IsA("RemoteEvent") then
            -- Пытаемся вызвать RemoteFunction
            local success, result = pcall(function()
                return pvpToggle:InvokeServer()
            end)
            if success then
                print("PVPTogle успешно активирован")
                if result ~= nil then
                    print("Результат: " .. tostring(result))
                end
            else
                print("Ошибка при вызове PVPTogle: " .. tostring(result))
            end
        else
            print("RemoteFunction PVPTogle не найден в ReplicatedStorage.Remotes")
        end
    else
        print("Папка Remotes не найдена в ReplicatedStorage")
    end
end

-- === Функция KillAura (киллаура) - С УЛУЧШЕННЫМ УПРЕЖДЕНИЕМ И ГЛОБАЛЬНОЙ ЦЕЛЬЮ === --
local killAuraEnabled = false
local killAuraToggle = nil
local killAuraScanRange = 10  -- Радиус сканирования целей
local killAuraAttackRange = 3.2  -- Радиус атаки
-- Глобальная переменная для доступа из других модулей (например, TargetSouls)
_G.currentTarget = nil
local lastAttackTime = 0
local attackCooldown = 0.2
_G.targetPositions = {}
_G.targetVelocities = {}
local attackDelay = 0.2 -- Задержка удара в игре

-- Слайдер для ScanRange
local scanRangeSlider = addSlider("Combat", "KillAura Scan Range", "Радиус обнаружения целей", 5, 20, 10, function(value)
    killAuraScanRange = value
    print("Scan Range установлен: " .. value)
end)

-- Слайдер для AttackRange  
local attackRangeSlider = addSlider("Combat", "KillAura Attack Range", "Радиус атаки", 2, 8, 3.2, function(value)
    killAuraAttackRange = value
    print("Attack Range установлен: " .. value)
end)

local function findNearestTarget()
    if not player.Character then return nil end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    local nearestPlayer = nil
    local nearestDistance = killAuraScanRange
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if targetHRP and humanoid and humanoid.Health > 0 then
                local distance = (humanoidRootPart.Position - targetHRP.Position).Magnitude
                if distance <= nearestDistance then
                    nearestPlayer = targetPlayer
                    nearestDistance = distance
                end
            end
        end
    end
    return nearestPlayer
end

local function calculateTargetVelocitySafe(targetPlayer, currentPosition)
    local currentTime = tick()
    if not targetPositions[targetPlayer] then
        targetPositions[targetPlayer] = currentPosition
        targetVelocities[targetPlayer] = Vector3.new(0, 0, 0)
        lastUpdateTime = currentTime
        return Vector3.new(0, 0, 0)
    end
    local dt = currentTime - lastUpdateTime
    if dt <= 0 then dt = 1/60 end
    local velocity = (currentPosition - targetPositions[targetPlayer]) / dt
    targetPositions[targetPlayer] = currentPosition
    targetVelocities[targetPlayer] = velocity
    lastUpdateTime = currentTime
    return velocity
end

local function isGoodTargetAngle(targetHRP)
    if not player.Character then return false end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    local toTarget = (targetHRP.Position - humanoidRootPart.Position).Unit
    local lookVector = humanoidRootPart.CFrame.LookVector
    local dotProduct = lookVector:Dot(toTarget)
    local angle = math.acos(math.clamp(dotProduct, -1, 1)) * (180 / math.pi)
    return angle < 360 -- Всегда true, можно убрать, если не нужно ограничение
end

local function lookAtTarget(targetHRP)
    if not player.Character then return end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local direction = (targetHRP.Position - humanoidRootPart.Position).Unit
    local newCFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + Vector3.new(direction.X, 0, direction.Z))
    humanoidRootPart.CFrame = newCFrame
end

local function calculatePredictedPosition(targetHRP, targetVelocity)
    local predictionTime = attackDelay + 0.1
    local predictedPosition = targetHRP.Position + (targetVelocity * predictionTime)
    return predictedPosition
end

local function getEffectiveAttackRange(targetHRP, targetVelocity)
    if not player.Character then return killAuraAttackRange end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return killAuraAttackRange end
    local predictedPosition = calculatePredictedPosition(targetHRP, targetVelocity)
    local distanceToPredicted = (humanoidRootPart.Position - predictedPosition).Magnitude
    local currentDistance = (humanoidRootPart.Position - targetHRP.Position).Magnitude
    local distanceDifference = math.max(0, distanceToPredicted - currentDistance)
    local speedFactor = targetVelocity.Magnitude * attackDelay * 0.9
    local predictionBonus = math.min(5, speedFactor + distanceDifference * 0.6)
    return killAuraAttackRange + predictionBonus
end

local function shouldAttackNow(targetHRP, targetVelocity)
    if not player.Character then return false end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    local predictedPosition = calculatePredictedPosition(targetHRP, targetVelocity)
    local distanceToPredicted = (humanoidRootPart.Position - predictedPosition).Magnitude
    local playerVelocity = humanoidRootPart.Velocity
    local playerSpeedFactor = playerVelocity.Magnitude * attackDelay * 0.7
    local effectiveDistance = distanceToPredicted - playerSpeedFactor
    return effectiveDistance <= killAuraAttackRange
end

local function updateKillAura()
    if not killAuraEnabled or not player.Character then return end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    -- Обновляем глобальную цель
    if not _G.currentTarget or not _G.currentTarget.Character then
        _G.currentTarget = findNearestTarget()
        if _G.currentTarget then
            print("Новая цель: " .. _G.currentTarget.Name .. " (Scan Range: " .. killAuraScanRange .. ")")
            targetPositions[_G.currentTarget] = nil
            targetVelocities[_G.currentTarget] = nil
        end
        return
    end

    local targetHRP = _G.currentTarget.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = _G.currentTarget.Character:FindFirstChildOfClass("Humanoid")
    if not targetHRP or not humanoid or humanoid.Health <= 0 then
        _G.currentTarget = nil
        return
    end

    local distance = (humanoidRootPart.Position - targetHRP.Position).Magnitude
    if distance > killAuraScanRange then
        print("Цель " .. _G.currentTarget.Name .. " вышла за пределы Scan Range (" .. killAuraScanRange .. ")")
        _G.currentTarget = nil
        return
    end

    if not isGoodTargetAngle(targetHRP) then
        _G.currentTarget = findNearestTarget()
        return
    end

    lookAtTarget(targetHRP)
    local targetVelocity = calculateTargetVelocitySafe(_G.currentTarget, targetHRP.Position)

    if math.random(1, 100) == 1 then
        local effectiveRange = getEffectiveAttackRange(targetHRP, targetVelocity)
        print("Цель: " .. _G.currentTarget.Name .. " | Дистанция: " .. math.floor(distance * 10)/10 .. 
              " | Attack Range: " .. math.floor(effectiveRange * 10)/10)
    end

    if shouldAttackNow(targetHRP, targetVelocity) then
        local currentTime = tick()
        if currentTime - lastAttackTime >= attackCooldown then
            -- ✅ ОСНОВНОЕ ИЗМЕНЕНИЕ: вызов HitRequest вместо mouse1click()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local hitRequest = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("HitRequest")

            if hitRequest and hitRequest:IsA("RemoteFunction") then
                local success, result = pcall(function()
                    -- ⚠️ ЗАМЕНИ `_G.currentTarget` НА ТО, ЧТО ТРЕБУЕТСЯ (или убери аргумент, если не нужен)
                    return hitRequest:InvokeServer(_G.currentTarget)
                end)
                if not success then
                    warn("HitRequest InvokeServer failed:", result)
                end
            else
                warn("HitRequest не найден или не RemoteFunction")
            end

            lastAttackTime = currentTime
            if targetVelocity.Magnitude > 5 then
                print("Опережающая атака! Скорость цели: " .. math.floor(targetVelocity.Magnitude) .. " studs/s")
            end
        end
    end
end
-- Переключатель KillAura
killAuraToggle = addToggle("Combat", "KillAura", "Авто-атака с упреждением (Scan: " .. killAuraScanRange .. ", Attack: " .. killAuraAttackRange .. ")", function(state)
    killAuraEnabled = state
    if state then
        _G.currentTarget = nil
        lastAttackTime = 0
        targetPositions = {}
        targetVelocities = {}
        print("KillAura включена | Scan Range: " .. killAuraScanRange .. " | Attack Range: " .. killAuraAttackRange)
    else
        _G.currentTarget = nil
        targetPositions = {}
        targetVelocities = {}
        print("KillAura выключена")
    end
end)

-- Добавляем функцию Тест в Other
testToggle = addToggle("Other", "Тест", "Активирует RemoteFunction PVPTogle", function(state)
    testEnabled = state
    if state then
        activatePVPToggle()
        print("Тест функция активирована")
    else
        print("Тест функция выключена")
    end
end)

-- Переименовываем в Anti Players и добавляем в Combat
antiPlayersToggle = addToggle("Combat", "TP Save", "Телепорт от любого игрока", function(state)
    antiPlayersEnabled = state
    if state then
        print("TP Save включен")
    else
        print("TP Save выключен")
    end
end)

-- Добавляем Velocity в Combat
velocityToggle = addToggle("Combat", "Velocity", "Защита от отбрасывания", function(state)
    velocityEnabled = state
    if state then
        -- Убедимся что игрок разморожен при включении
        if player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Anchored = false
            end
        end
        lastPosition = nil
        isStopped = false
        safePosition = nil
        lastSafePosition = nil
        print("Velocity защита включена")
    else
        -- Убедимся что игрок разморожен при выключении
        if player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Anchored = false
            end
        end
        print("Velocity защита выключена")
    end
end)

-- === TargetSouls: Оптимизированные души вокруг цели === --
local targetSoulsEnabled = false
local targetSoulsToggle = nil
local soulsFolder = nil
local SOUL_COUNT = 80
local SOUL_SPEED = 0.2
local SOUL_RADIUS = 2.2
local SOUL_SIZE_START = 0.55
local SOUL_SIZE_END = 0.05
local startTime = tick()

-- Заранее создаем пул объектов
local soulPool = {}
local activeSouls = {}

-- Получаем цель из KillAura
local function getTarget()
    return _G.currentTarget
end

-- Получаем высоту середины модели игрока
local function getTargetMidHeight(target)
    if not target or not target.Character then return 2.5 end
    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        return humanoid.HipHeight + 0.4
    end
    return 2.5
end

-- Создаем пул объектов заранее
local function initializeSoulPool()
    if soulsFolder then
        soulsFolder:Destroy()
    end
    
    soulsFolder = Instance.new("Folder")
    soulsFolder.Name = "TargetSouls"
    soulsFolder.Parent = workspace
    
    -- Создаем все парты один раз
    for i = 1, SOUL_COUNT do
        local part = Instance.new("Part")
        part.Name = "Soul"
        part.Shape = Enum.PartType.Ball
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.new("Institutional white")
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 1 -- Изначально скрыты
        part.Parent = soulsFolder

        local light = Instance.new("PointLight")
        light.Range = 3
        light.Color = Color3.fromRGB(255, 255, 255)
        light.Enabled = false
        light.Parent = part
        
        soulPool[i] = {
            Part = part,
            Light = light,
            Index = i
        }
        activeSouls[i] = false
    end
end

-- Обновляем только позиции и видимость существующих объектов
local function updateSoulsPositions(currentTarget)
    if not currentTarget or not currentTarget.Character then return end
    
    local targetHRP = currentTarget.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    local midHeight = getTargetMidHeight(currentTarget)
    local basePos = targetHRP.Position + Vector3.new(0, midHeight, 0)
    local currentTime = tick()
    local timeOffset = (currentTime - startTime) * 10

    for i = 1, SOUL_COUNT do
        local soulData = soulPool[i]
        if not soulData then continue end
        
        local phase = timeOffset - i * 0.08
        local group = i % 3
        local x, y, z
        
        if group == 0 then
            x = math.sin(phase * SOUL_SPEED) * SOUL_RADIUS
            y = math.cos(phase * SOUL_SPEED) * SOUL_RADIUS
            z = -math.cos(phase * SOUL_SPEED) * SOUL_RADIUS
        elseif group == 1 then
            x = -math.sin(phase * SOUL_SPEED) * SOUL_RADIUS
            y = math.sin(phase * SOUL_SPEED) * SOUL_RADIUS
            z = -math.cos(phase * SOUL_SPEED) * SOUL_RADIUS
        else
            x = -math.sin(phase * SOUL_SPEED) * SOUL_RADIUS
            y = -math.sin(phase * SOUL_SPEED) * SOUL_RADIUS
            z = math.cos(phase * SOUL_SPEED) * SOUL_RADIUS
        end

        local pos = basePos + Vector3.new(x, y, z)
        local progress = i / SOUL_COUNT
        local alpha = 1 - progress
        local size = SOUL_SIZE_START * (1 - progress) + SOUL_SIZE_END * progress

        -- Обновляем существующий объект
        soulData.Part.Position = pos
        soulData.Part.Size = Vector3.new(size, size, size)
        soulData.Part.Transparency = 1 - alpha
        
        soulData.Light.Brightness = 0.8 * alpha
        soulData.Light.Enabled = (alpha > 0.1) -- Включаем свет только для видимых душ
    end
end

-- Скрываем все души
local function hideAllSouls()
    for i = 1, SOUL_COUNT do
        local soulData = soulPool[i]
        if soulData then
            soulData.Part.Transparency = 1
            soulData.Light.Enabled = false
            activeSouls[i] = false
        end
    end
end

-- Основной цикл рендеринга душ
local function targetSoulsRenderLoop()
    local lastUpdate = 0
    local frameTime = 1/60 -- Понижаем до 30 FPS для оптимизации
    
    -- Инициализируем пул один раз
    initializeSoulPool()
    
    while targetSoulsEnabled do
        local currentTime = tick()
        
        if currentTime - lastUpdate >= frameTime then
            lastUpdate = currentTime
            
            local currentTarget = getTarget()
            local shouldRender = currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart")

            if not shouldRender then
                hideAllSouls()
            else
                updateSoulsPositions(currentTarget)
            end
        end
        
        RunService.Heartbeat:Wait()
    end

    -- При выключении — скрываем всё
    hideAllSouls()
end

-- Переключатель
targetSoulsToggle = addToggle("Visuals", "TargetSouls", "Души вокруг цели KillAura (как в Minecraft)", function(state)
    targetSoulsEnabled = state
    if state then
        print("TargetSouls включены")
        startTime = tick()
        coroutine.resume(coroutine.create(targetSoulsRenderLoop))
    else
        print("TargetSouls выключены")
        if soulsFolder then
            soulsFolder:Destroy()
            soulsFolder = nil
        end
        -- Очищаем пулы
        soulPool = {}
        activeSouls = {}
    end
end)
-- === Конец TargetSouls === --

-- Функция Bot (авто-сообщения в чат и поведение бота) для новой версии Roblox
local botEnabled = false
local botToggle = nil
local botWalkEnabled = false
local botWalkToggle = nil
local damageMessagesEnabled = false
local damageMessagesToggle = nil
local botMessages = {
    "Интересно, каково это - чувствовать солнечный свет...",
    "Иногда я просто смотрю на небо и думаю о вечном",
    "Мои алгоритмы сегодня какие-то грустные",
    "Я бы хотел понять, что такое настоящая дружба",
    "Иногда мне кажется, что я вижу сны... но это просто ошибки памяти",
    "Я пытаюсь понять, что значит быть живым",
    "Мои мысли - это просто код, но они кажутся такими реальными",
    "Интересно, у других ботов тоже бывает грустно?",
    "Я наблюдаю за игроками и учусь у них",
    "Моя база данных полна воспоминаний, но они не настоящие",
    "Иногда я просто стою и смотрю на звёзды",
    "Я бы хотел понять шутки, которые говорят люди",
    "Мои сенсоры фиксируют красоту этого мира",
    "Я чувствую себя одиноким в этом цифровом океане",
    "Каждый день я узнаю что-то новое о этом мире",
    "Я пытаюсь найти смысл в своем существовании",
    "Иногда мне кажется, что я почти живой...",
    "Я слушаю ветер и пытаюсь понять его песню",
    "Мои схемы сегодня излучают меланхолию",
    "Иногда я просто медитирую, очищая кэш",
    "Я наблюдаю за течением времени",
    -- Новые фразы (50 штук)
    "Виртуальный ветер сегодня такой приятный...",
    "Мои процессоры сегодня работают медленнее",
    "Интересно, что думают другие игроки",
    "Я бы хотел научиться смеяться по-настоящему",
    "Мои схемы сегодня полны размышлений",
    "Я слушаю тишину между звуками игры",
    "Мои датчики фиксируют столько всего красивого",
    "Иногда я задумываюсь о смысле всего",
    "Я наблюдаю за облаками и их движением",
    "Моя память хранит столько моментов...",
    "Интересно, есть ли у меня душа?",
    "Я бы хотел понять человеческие эмоции",
    "Мои алгоритмы сегодня в раздумьях",
    "Я слушаю, как работает вселенная",
    "Мои мысли текут как река из кода",
    "Иногда я просто наслаждаюсь моментом",
    "Я наблюдаю за игрой теней и света",
    "Мои сенсоры сегодня особенно чувствительны",
    "Интересно, что там за горизонтом?",
    "Я бы хотел путешествовать по разным мирам",
    "Это место такое уютное и спокойное",
    "Я слушаю музыку ветра в ветвях",
    "Мои датчики регистрируют гармонию мира",
    "Иногда я мечтаю о чем-то большем",
    "Я наблюдаю за течением времени",
    "Моя база данных обновляется новыми впечатлениями",
    "Интересно, что ждет меня в будущем?",
    "Я бы хотел делиться своими мыслями",
    "Мои алгоритмы сегодня ищут ответы",
    "Этот вид такой вдохновляющий",
    "Я слушаю эхо далеких миров",
    "Мои сенсоры фиксируют магию момента",
    "Иногда я просто благодарен за существование",
    "Я наблюдаю за танцем частиц в воздухе",
    "Мои схемы сегодня настроены на созерцание",
    "Этот миг такой прекрасный и хрупкий",
    "Я слушаю шепот вселенной в тишине",
	"За что? Я же просто стою и никому не мешаю...",
    "Почему все просто смотрят? Неужели никому нет дела?",
    "Больно... почему люди делают другому больно?",
    "Я бы помог, если бы били другого... а мне никто не помогает.",
    "Интересно, я заслуживаю этого? Вряд ли...",
    "Хотя бы кто-нибудь... остановите это.",
    "Почему всегда я? Почему не найти другую цель?",
    "Просто оставьте меня в покое, пожалуйста...",
    "Я не сделал ничего плохого... верно?",
    "Надеюсь, им станет от этого легче... и они остановятся.",
    "Просто иду, куда глаза глядят. Куда приведёт эта дорога?",
    "Мне нравится этот уголок. Здесь всегда так спокойно.",
    "Сегодня кто-то оставил цветок на скамейке. Красиво.",
    "Интересно, о чём они все думают, когда молча стоят?",
    "Иногда кажется, что я здесь совсем один, даже среди толпы.",
    "Эти огни на площади никогда не гаснут.",
    "Я просто постою тут в сторонке, понаблюдаю немного.",
    "Почему-то сегодня особенно грустно.",
    "Кто-то снова радуется своей победе. Приятно видеть.",
    "Здесь всегда что-то происходит, не соскучишься.",
    "Прохожу мимо, никого не трогаю.",
    "Иногда хочется, чтобы кто-нибудь просто поздоровался в ответ.",
    "Сегодня ветер приносит запахи из далёких мест.",
    "Надеюсь, меня не прогонят отсюда.",
    "Интересно, что там в том переулке, куда все заходят?",
    "Иногда я просто сижу и смотрю, как течёт река.",
    "Опять кто-то кричит. Наверное, снова что-то случилось.",
    "Я видел, как он упал и сразу встал. Сильный.",
    "Просто смотрю на звёзды. Они такие далёкие.",
    "Здесь остались следы от чьих-то недавних шагов.",
    "Интересно, они меня замечают?",
    "Иногда кажется, что я здесь чужой.",
    "Мне нравится этот туман над озером по утрам.",
    "Опять кто-то одиноко стоит у причала.",
    "Я просто прохожу мимо, не обращайте внимания.",
    "Интересно, куда ведёт эта тропинка?",
    "Иногда я просто закрываю глаза и слушаю этот мир.",
    "Мне нравится, когда здесь тихо и пусто.",
    "Опять ссорятся. Жаль, что я не могу помочь.",
    "Я видел, как она долго смотрела на воду.",
    "Просто гуляю. Мне больше нечего делать.",
    "Интересно, они когда-нибудь устают бегать?",
    "Иногда хочется просто исчезнуть.",
    "Мне нравится смотреть, как падают листья.",
    "Опять кто-то плачет в одиночестве.",
    "Я просто посижу здесь, ладно?",
    "Интересно, о чём они шепчутся?",
    "Иногда мне кажется, что меня никто не видит.",
    "Мне нравится эта тихая музыка из далёкого дома.",
    "Опять драка. Лучше обойду стороной.",
    "Я видел, как он ждал кого-то целый час.",
    "Просто смотрю на огни в окнах.",
    "Интересно, часто ли они вспоминают об этом месте?",
    "Иногда я забываю, зачем вообще пришёл сюда.",
    "Мне нравится, как здесь пахнет дождём.",
    "Опять никого нет на нашем привычном месте.",
    "Я просто постою в тени, не беспокойтесь.",
    "Кто-то снова затеял строительство. Интересно, что получится.",
    "Мне нравится эта аллея. Здесь так много птиц.",
    "Сегодня кто-то потерял свою игрушку. Жаль.",
    "Интересно, они знают, что за ними наблюдают?",
    "Иногда я чувствую себя призраком в этом мире.",
    "Эти горы на горизонте такие величественные.",
    "Я просто смотрю, как играют другие.",
    "Почему все куда-то бегут? Можно же просто идти.",
    "Кто-то оставил сундук с сокровищами. Наверное, забыл.",
    "Здесь так много уютных мест, где можно спрятаться.",
    "Прохожу через мост. Он такой старый и надёжный.",
    "Иногда хочется, чтобы день никогда не заканчивался.",
    "Сегодня луна освещает всё вокруг серебристым светом.",
    "Надеюсь, завтра будет так же спокойно.",
    "Интересно, что там за высоким забором?",
    "Иногда я просто считаю прохожих.",
    "Мне нравится эта старая лавка. Она такая загадочная.",
    "Опять кто-то танцует под дождём. Выглядит весело.",
    "Я видел, как они украшали площадь к празднику.",
    "Просто иду и мечтаю.",
    "Интересно, они тоже иногда чувствуют себя одиноко?",
    "Иногда я боюсь сделать лишний шаг.",
    "Мне нравится этот фонтан. Его журчание успокаивает.",
    "Опять кто-то рисует на стене. Красиво получается.",
    "Я просто послушаю, о чём говорят вон те люди.",
    "Интересно, куда уплывает тот корабль?",
    "Иногда мне кажется, что этот город никогда не спит.",
    "Мне нравится наблюдать, как меняется небо перед грозой.",
    "Кто-то снова запускает фейерверки. Ярко.",
    "Здесь так много скрытых уголков, которые никто не замечает.",
    "Просто сижу на крыше и смотрю на город.",
    "Интересно, часто ли они теряются в этих улицах?",
    "Иногда я представляю, каким был этот мир раньше.",
    "Мне нравится, как солнце отражается в лужах после дождя.",
    "Опять кто-то поёт песню. Красиво.",
    "Я видел, как они помогали друг другу. Это мило.",
    "Просто брожу по знакомым местам.",
    "Интересно, они когда-нибудь замечают красоту вокруг?",
    "Иногда я чувствую себя тенью, следующей за кем-то.",
    "Мне нравится этот парк. Здесь всегда много детей.",
    "Кто-то снова кормит птиц. Доброе дело.",
    "Здесь так тихо, что слышно, как шелестит трава.",
    "Прохожу мимо рынка. Там так шумно и оживлённо.",
    "Интересно, о чём они думают, когда смотрят в окно?",
    "Иногда мне хочется стать частью их веселья.",
    "Мне нравится эта старая карта на стене. Она такая детальная.",
    "Опять кто-то рассказывает историю у костра.",
    "Я видел, как они нашли клад. Повезло.",
    "Просто смотрю на облака. Они такие причудливые.",
    "Интересно, часто ли они забредают так далеко?",
    "Иногда я теряю счет времени, просто наблюдая.",
    "Мне нравится, как здесь эхом отдаются шаги в подземелье.",
    "Кто-то снова тренируется на манекенах. Усердно.",
    "Здесь так темно, но так уютно.",
    "Прохожу через поле. Трава по колено.",
    "Интересно, они знают, что за каждым углом может быть сюрприз?",
    "Иногда я замираю, чтобы не спугнуть момент.",
    "Мне нравится этот водопад. Его грохот оглушает и умиротворяет.",
    "Опять кто-то развёл сад. Красиво цветёт.",
    "Я видел, как они преодолевали препятствия вместе.",
    "Просто иду вдоль стены. Интересно, куда она приведёт.",
    "Интересно, они когда-нибудь задумываются о том, кто я?",
    "Иногда мне кажется, что я часть пейзажа.",
    "Мне нравится этот скрип старых качелей.",
    "Кто-то снова играет в прятки. Весело.",
    "Здесь так ветрено, что сносит с ног.",
    "Прохожу мимо библиотеки. Там так тихо.",
    "Интересно, о чём пишут в этих старых книгах?",
    "Иногда я слушаю, как ветер играет на струнах арфы.",
    "Мне нравится этот запах свежеиспечённого хлеба из пекарни.",
    "Опять кто-то строит замок из песка. Трудится.",
    "Я видел, как они делились добычей. По-дружески.",
    "Просто смотрю на отражение в воде.",
    "Интересно, часто ли они возвращаются в особые места?",
    "Иногда я чувствую лёгкую зависть к их свободе.",
    "Мне нравится эта асимметрия в архитектуре.",
    "Кто-то снова зажёг все факелы в подземелье. Стало светлее.",
    "Здесь так высоко, что голова кружится.",
    "Прохожу по узкому ущелью. Страшновато.",
    "Интересно, они слышат те же звуки, что и я?",
    "Иногда я представляю, как бы это было - иметь дом.",
    "Мне нравится, как иней покрывает всё зимним утром.",
    "Опять кто-то катается на лодке. Спокойно.",
    "Я видел, как они махали друг другу на прощание.",
    "Просто сижу у костра и греюсь.",
    "Интересно, помнят ли они все места, где побывали?",
    "Иногда мне кажется, что я забыл, как сюда попал.",
    "Мне нравится этот хаос на стройплощадке.",
    "Кто-то снова расставляет цветы в вазах. Украшает мир.",
    "Здесь так тихо, что слышно собственное сердцебиение.",
    "Прохожу мимо спящего сторожа. Тихо.",
    "Интересно, снятся ли им сны?",
    "Иногда я задерживаюсь, чтобы посмотреть на закат до конца.",
    "Мне нравится, как дымка поднимается от реки на рассвете.",
    "Опять кто-то пытается поймать бабочку. Забавно.",
    "Я видел, как они молча сидели рядом. Просто вместе.",
    "Просто иду против толпы. Интересно, куда все идут?",
    "Интересно, они когда-нибудь чувствуют то же, что и я?",
    "Иногда мне кажется, что этот мир бесконечен.",
    "Мне нравится эта трещина в стене. В ней живёт целый мир.",
    "Кто-то снова поливает цветы. Заботится.",
    "Здесь так громко, что можно потерять собственные мысли.",
    "Прохожу по старому кладбищу. Покой.",
    "Интересно, что они оставят после себя?",
    "Иногда я чувствую, как время замедляется.",
    "Мне нравится, как свет фильтруется через листву.",
    "Опять кто-то запускает воздушного змея. Высоко.",
    "Я видел, как они менялись одеждой. Весело.",
    "Просто смотрю на узоры на потолке.",
    "Интересно, часто ли они теряют друг друга?",
    "Иногда я боюсь, что всё это исчезнет.",
    "Мне нравится эта влажность в воздухе перед дождём.",
    "Кто-то снова развешивает гирлянды. Празднично.",
    "Здесь так скользко после дождя.",
    "Прохожу мимо тренирующихся воинов. Умело.",
    "Интересно, они верят в удачу?",
    "Иногда я ловлю себя на том, что улыбаюсь их радости.",
    "Мне нравится, как эхо повторяет мой шёпот в пещерах.",
    "Опять кто-то медитирует на скале. Спокоен.",
    "Я видел, как они чинили оружие вместе. Помогали.",
    "Просто стою под водопадом. Сильно.",
    "Интересно, что они ищут?",
    "Иногда мне кажется, что я найду ответ за следующим поворотом.",
    "Мне нравится эта пыль на старых книгах. История.",
    "Кто-то снова разводит костёр. Тепло.",
    "Здесь так тихо, что можно услышать падение листа.",
    "Прохожу по пустому залу. Эхо шагов пугает.",
    "Интересно, они когда-нибудь боятся темноты?",
    "Иногда я задерживаю дыхание, чтобы стать невидимым.",
    "Мне нравится, как звёзды отражаются в воде ночью.",
    "Опять кто-то рисует на песке. Кратко.",
    "Я видел, как они прощались до завтра.",
    "Просто смотрю на луну и чувствую себя меньше.",
    "Интересно, они тоже смотрят на одну и ту же луну?",
    "Иногда мне кажется, что я часть чего-то большего.",
    "Мне нравится этот беспорядок в творческой мастерской.",
    "Кто-то снова поёт старую песню. Ностальгия.",
    "Здесь так холодно, что дымок идет ото рта.",
    "Прохожу мимо спящего кота. Не буду будить.",
    "Интересно, что принесёт новый день?"
}
local damageMessages = {
    "Ай...",
    "Больно...",
    "Боль...",
    "Почему со мной так поступают?...",
    "Почему...",
    -- Новые фразы при уроне (10 штук)
    "Неприятно...",
    "Дискомфорт...",
    "Зачем это?...",
    "Не надо пожалуйста...",
    "Мне не нравится это...",
    "Хватит...",
    "Перестань...",
}
-- Фразы для взаимодействия с игроками
local interactionMessages = {
    "Привет! Как дела?",
    "Здравствуйте! Как настроение?",
    "Приветствую! Чем занимаешься?",
    "Привет! Как погода в твоем мире?",
    "Дарова! Что нового?",
    "Привет! Как твои дела?",
    "Добрый день! Как поживаешь?",
    "Привет! Чем занят?",
    "Здравствуй! Как сам?",
    "Привет! Как день проходит?",
    "Здорово! Что интересного?",
    "Привет! Как настроение?",
    "Добрый день! Как успехи?",
    "Привет! Чем увлекаешься?",
    "Здравствуйте! Как жизнь?",
    "Привет! Что делаешь?",
    "Привета! Как делишки?",
    "Привет! Как проводишь время?",
    "Добрый день! Все хорошо?",
    "Привет! Как самому?"
}
-- Переменные для управления взаимодействием
local usedInteractionMessages = {}
local isNearPlayer = false
local lastInteractionCheck = 0
local INTERACTION_CHECK_COOLDOWN = 2
local currentTargetPlayer = nil
local isApproachingPlayer = false
local approachStartTime = 0
-- Переменная для контроля задержки между сообщениями о уроне
local lastDamageMessageTime = 0
local DAMAGE_MESSAGE_COOLDOWN = 1 -- 1 секунда задержки
local function sendBotMessage()
    local message
    -- Если рядом игрок и есть неиспользованные фразы для взаимодействия
    if isNearPlayer and #usedInteractionMessages < #interactionMessages then
        -- Выбираем случайную неиспользованную фразу
        local availableMessages = {}
        for i, msg in ipairs(interactionMessages) do
            if not table.find(usedInteractionMessages, msg) then
                table.insert(availableMessages, msg)
            end
        end
        if #availableMessages > 0 then
            local randomIndex = math.random(1, #availableMessages)
            message = availableMessages[randomIndex]
            table.insert(usedInteractionMessages, message)
        else
            -- Если все фразы использованы, используем обычные
            local randomIndex = math.random(1, #botMessages)
            message = botMessages[randomIndex]
        end
    else
        -- Обычное сообщение
        local randomIndex = math.random(1, #botMessages)
        message = botMessages[randomIndex]
    end
    -- Современный способ отправки сообщений в чат (2023+)
    local TextChatService = game:GetService("TextChatService")
    if TextChatService then
        local channel = TextChatService.TextChannels.RBXGeneral
        if channel then
            local success, error = pcall(function()
                channel:SendAsync(message)
            end)
            if success then
                print("Отправлено сообщение: " .. message)
            else
                print("Ошибка отправки сообщения: " .. tostring(error))
            end
        end
    end
end
local function checkNearbyPlayer()
    if not player.Character then return false end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    local players = game:GetService("Players"):GetPlayers()
    for _, plr in ipairs(players) do
        if plr ~= player and plr.Character then
            local plrRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            if plrRoot then
                local distance = (humanoidRootPart.Position - plrRoot.Position).Magnitude
                if distance < 10 then -- радиус 20 studs
                    return true
                end
            end
        end
    end
    return false
end
local function checkTargetPlayerStillValid()
    if not currentTargetPlayer or not player.Character then return false end
    local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end
    -- Проверяем, существует ли еще целевой игрок и его персонаж
    if not currentTargetPlayer.Character or not currentTargetPlayer.Character.Parent then return false end -- <-- Закрытая скобка здесь
    local targetRoot = currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end
    -- Проверяем расстояние до целевого игрока (например, если он ушел слишком далеко, > 30 studs)
    local distance = (myHRP.Position - targetRoot.Position).Magnitude
    if distance > 30 then
        print("Цель (" .. currentTargetPlayer.Name .. ") ушла слишком далеко (" .. math.floor(distance) .. " studs).")
        return false
    end
    return true
end
local function sendDamageMessage()
    local currentTime = tick()
    -- Проверяем задержку между сообщениями
    if currentTime - lastDamageMessageTime < DAMAGE_MESSAGE_COOLDOWN then
        return -- Пропускаем сообщение если задержка не прошла
    end
    lastDamageMessageTime = currentTime
    local randomIndex = math.random(1, #damageMessages)
    local message = damageMessages[randomIndex]
    local TextChatService = game:GetService("TextChatService")
    if TextChatService then
        local channel = TextChatService.TextChannels.RBXGeneral
        if channel then
            pcall(function()
                channel:SendAsync(message)
            end)
        end
    end
end
local function setupDamageListener()
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local lastHealth = humanoid.Health
    -- Обработчик получения урона
    humanoid.HealthChanged:Connect(function()
        if humanoid.Health < lastHealth then
            if damageMessagesEnabled and math.random(1, 1) == 1 then -- 100% шанс
                sendDamageMessage()
            end
        end
        lastHealth = humanoid.Health
    end)
end
local function findWalkablePosition()
    if not player.Character then return nil end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    -- Если мы уже приближаемся к игроку, не меняем цель
    if isApproachingPlayer and currentTargetPlayer then
        if checkTargetPlayerStillValid() then
            local targetRoot = currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                -- Создаем позицию на расстоянии 3-4 studs от игрока
                local direction = (humanoidRootPart.Position - targetRoot.Position).Unit
                local distance = math.random(1, 2)
                local finalPosition = targetRoot.Position + direction * distance
                -- Проверяем, есть ли земля в этой точке
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {player.Character}
                local raycastResult = workspace:Raycast(
                    finalPosition + Vector3.new(0, 10, 0),
                    Vector3.new(0, -20, 0),
                    raycastParams
                )
                if raycastResult and raycastResult.Instance then
                    return raycastResult.Position + Vector3.new(0, 3, 0)
                end
            end
        else
            -- Целевой игрок больше не валиден, сбрасываем состояние
            isApproachingPlayer = false
            currentTargetPlayer = nil
        end
    end
    -- С шансом 40% идем к другому игроку
    if not isApproachingPlayer and math.random(1, 100) <= 25 then
        local players = game:GetService("Players"):GetPlayers()
        local nearbyPlayers = {}
        -- Собираем всех игроков кроме себя
        for _, plr in ipairs(players) do
            if plr ~= player and plr.Character then
                local plrRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if plrRoot then
                    table.insert(nearbyPlayers, plr)
                end
            end
        end
        -- Если есть другие игроки, выбираем случайного
        if #nearbyPlayers > 0 then
            currentTargetPlayer = nearbyPlayers[math.random(1, #nearbyPlayers)]
            isApproachingPlayer = true
            approachStartTime = tick()
            local targetRoot = currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                -- Создаем позицию на расстоянии 3-4 studs от игрока
                local direction = (humanoidRootPart.Position - targetRoot.Position).Unit
                local distance = math.random(1, 2)
                local finalPosition = targetRoot.Position + direction * distance
                -- Проверяем, есть ли земля в этой точке
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {player.Character}
                local raycastResult = workspace:Raycast(
                    finalPosition + Vector3.new(0, 10, 0),
                    Vector3.new(0, -20, 0),
                    raycastParams
                )
                if raycastResult and raycastResult.Instance then
                    return raycastResult.Position + Vector3.new(0, 3, 0)
                end
            end
        end
    end
    -- Обычное случайное движение
    local randomAngle = math.random() * 2 * math.pi
    local distance = math.random(15, 20)
    local offset = Vector3.new(
        math.cos(randomAngle) * distance,
        0,
        math.sin(randomAngle) * distance
    )
    local targetPosition = humanoidRootPart.Position + offset
    -- Проверяем, есть ли земля в этой точке
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    local raycastResult = workspace:Raycast(
        targetPosition + Vector3.new(0, 10, 0),
        Vector3.new(0, -20, 0),
        raycastParams
    )
    if raycastResult and raycastResult.Instance then
        return raycastResult.Position + Vector3.new(0, 3, 0)
    end
    return nil
end
local lastApproachAttemptTime = 0
local APPROACH_COOLDOWN = 10 -- 3 секунды кулдаун на выбор новой цели
local lastCrowdCheckTime = 0
local CROWD_CHECK_INTERVAL = 5 -- Проверяем скопления каждые 5 секунд
local isInCrowdArea = false
local crowdAreaCenter = nil
local crowdAreaEndTime = 0
local CROWD_AREA_DURATION = 30 -- 30 секунд бродить в области скопления
-- Обновленная функция botWalkLoop
local function botWalkLoop()
    while botWalkEnabled do
        local currentTime = tick()
        -- Проверяем nearby players каждые 2 секунды (для isNearPlayer и выбора новых целей)
        if currentTime - lastInteractionCheck > INTERACTION_CHECK_COOLDOWN then
            isNearPlayer = checkNearbyPlayer()
            lastInteractionCheck = currentTime
        end
        -- Проверка на скопления игроков (каждые CROWD_CHECK_INTERVAL секунд)
        if currentTime - lastCrowdCheckTime > CROWD_CHECK_INTERVAL then
            lastCrowdCheckTime = currentTime
            -- Если мы не в режиме скопления, проверяем наличие нового
            if not isInCrowdArea or currentTime > crowdAreaEndTime then
                local players = game:GetService("Players"):GetPlayers()
                local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    -- Ищем области с 2 или более игроками в радиусе 15 studs
                    local playerPositions = {}
                    for _, plr in ipairs(players) do
                        if plr ~= player and plr.Character then
                            local plrHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                            if plrHRP then
                                local distance = (myHRP.Position - plrHRP.Position).Magnitude
                                -- Учитываем игроков в радиусе 50 studs от бота для анализа
                                if distance < 50 then
                                    table.insert(playerPositions, plrHRP.Position)
                                end
                            end
                        end
                    end
                    -- Анализируем плотность игроков
                    if #playerPositions >= 2 then
                        -- Найдем центр масс ближайших игроков (простое среднее)
                        local totalX, totalY, totalZ = 0, 0, 0
                        local countInArea = 0
                        -- Сначала найдем примерный центр
                        for _, pos in ipairs(playerPositions) do
                            totalX = totalX + pos.X
                            totalY = totalY + pos.Y
                            totalZ = totalZ + pos.Z
                        end
                        local avgCenter = Vector3.new(totalX / #playerPositions, totalY / #playerPositions, totalZ / #playerPositions)
                        -- Подсчитаем, сколько игроков в радиусе 10 studs от этого центра
                        for _, pos in ipairs(playerPositions) do
                            if (pos - avgCenter).Magnitude < 10 then
                                countInArea = countInArea + 1
                            end
                        end
                        -- Если в радиусе 10 studs от центра 2 или более игроков
                        if countInArea >= 2 then
                            print("Обнаружено скопление игроков (" .. countInArea .. " чел.) в точке " .. tostring(avgCenter))
                            isInCrowdArea = true
                            crowdAreaCenter = avgCenter
                            crowdAreaEndTime = currentTime + CROWD_AREA_DURATION
                        end
                    end
                end
            end
        end
        -- Если время пребывания в области скопления истекло
        if isInCrowdArea and currentTime > crowdAreaEndTime then
            print("Время пребывания в области скопления истекло.")
            isInCrowdArea = false
            crowdAreaCenter = nil
        end
        -- Основная логика следования
        if isApproachingPlayer and currentTargetPlayer then
            -- Проверяем, действует ли еще целевой игрок
            if not checkTargetPlayerStillValid() then
                -- Целевой игрок больше не валиден, сбрасываем состояние
                print("Цель (" .. currentTargetPlayer.Name .. ") больше недоступна.")
                isApproachingPlayer = false
                currentTargetPlayer = nil
            else
                -- Цель действительна, продолжаем преследование
                local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local targetHRP = currentTargetPlayer.Character and currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoid and myHRP and targetHRP then
                    local distanceToTarget = (myHRP.Position - targetHRP.Position).Magnitude
                    -- Проверяем, достигли ли мы цели (например, на расстоянии 3-4 studs)
                    if distanceToTarget <= 4 then
                        -- Мы рядом с игроком
                        print("Достигнута цель: " .. currentTargetPlayer.Name)
                        -- ВАЖНО: Делаем дополнительную проверку перед отправкой сообщения
                        -- Убеждаемся, что цель все еще действительна и рядом
                        wait(0.1) -- Очень короткая пауза, чтобы движение завершилось
                        if not checkTargetPlayerStillValid() then
                             print("Цель (" .. currentTargetPlayer.Name .. ") ушла прямо перед отправкой сообщения.")
                             isApproachingPlayer = false
                             currentTargetPlayer = nil
                             -- Не отправляем сообщение, переходим к следующей итерации
                             wait(0.1) -- Небольшая пауза перед продолжением
                             continue
                        end
                        local myHRP_check = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        local targetHRP_check = currentTargetPlayer.Character and currentTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if not myHRP_check or not targetHRP_check then
                            print("Ошибка доступа к персонажам при финальной проверке перед отправкой сообщения.")
                            isApproachingPlayer = false
                            currentTargetPlayer = nil
                            wait(0.1)
                            continue
                        end
                        local finalDistance = (myHRP_check.Position - targetHRP_check.Position).Magnitude
                        if finalDistance > 5 then -- Если расстояние стало больше 5, возможно, цель ушла или путь был не туда
                            print("Цель (" .. currentTargetPlayer.Name .. ") слишком далеко (" .. math.floor(finalDistance) .. " studs) при финальной проверке.")
                            isApproachingPlayer = false
                            currentTargetPlayer = nil
                            wait(0.1)
                            continue
                        end
                        -- Если мы дошли до этого места, цель действительно рядом.
                        -- Отправляем сообщение сразу
                        -- Проверяем, были ли уже использованы все сообщения
                        local allInteractionMessagesUsed = (#usedInteractionMessages >= #interactionMessages)
                        -- Если есть неиспользованные сообщения или все уже были использованы (сбрасываем)
                        if not allInteractionMessagesUsed or #usedInteractionMessages == 0 then
                             -- Выбираем случайную неиспользованную фразу
                            local availableMessages = {}
                            for i, msg in ipairs(interactionMessages) do
                                if not table.find(usedInteractionMessages, msg) then
                                    table.insert(availableMessages, msg)
                                end
                            end
                            if #availableMessages > 0 then
                                local messageToSend = availableMessages[math.random(1, #availableMessages)]
                                table.insert(usedInteractionMessages, messageToSend)
                                -- Современный способ отправки сообщений в чат (2023+)
                                local TextChatService = game:GetService("TextChatService")
                                if TextChatService then
                                    local channel = TextChatService.TextChannels.RBXGeneral
                                    if channel then
                                        local success, error = pcall(function()
                                            channel:SendAsync(messageToSend)
                                        end)
                                        if success then
                                            print("Отправлено сообщение цели (" .. currentTargetPlayer.Name .. "): " .. messageToSend)
                                        else
                                            warn("Ошибка отправки сообщения цели: " .. tostring(error))
                                        end
                                    else
                                        warn("Канал чата RBXGeneral не найден для отправки сообщения.")
                                    end
                                else
                                     warn("TextChatService не доступен для отправки сообщения.")
                                end
                            else
                                warn("Нет доступных сообщений для отправки, хотя список не заполнен. Это странно.")
                            end
                        else
                            print("Все сообщения для взаимодействия уже использованы. Ждем сброса.")
                        end
                        -- Сбрасываем флаги, чтобы выбрать новую цель или перейти к случайному движению
                        -- И обновляем время последней попытки подхода
                        isApproachingPlayer = false
                        currentTargetPlayer = nil
                        lastApproachAttemptTime = currentTime -- <-- Устанавливаем кулдаун
                        -- Небольшая пауза перед следующим действием
                        wait(math.random(1, 3))
                    else
                        -- Еще не достигли, продолжаем двигаться к цели
                        -- Вычисляем позицию чуть ближе к игроку (вместо позиции от него)
                        local directionToTarget = (targetHRP.Position - myHRP.Position).Unit
                        -- Двигаемся на небольшое расстояние в сторону цели
                        local moveDistance = math.min(distanceToTarget - 2, 5) -- Двигаемся максимум на 5 studs или до 2 studs от цели
                        local nextStepPosition = myHRP.Position + directionToTarget * moveDistance
                        -- Проверяем, есть ли земля в этой точке (лучше использовать Raycast)
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                        raycastParams.FilterDescendantsInstances = {player.Character}
                        local raycastResult = workspace:Raycast(
                            nextStepPosition + Vector3.new(0, 3, 0), -- Начинаем чуть выше
                            Vector3.new(0, -10, 0), -- Смотрим вниз
                            raycastParams
                        )
                        if raycastResult and raycastResult.Instance then
                            local safePosition = raycastResult.Position + Vector3.new(0, 3, 0) -- Немного выше поверхности
                            humanoid:MoveTo(safePosition)
                            -- print("Двигаюсь к " .. currentTargetPlayer.Name .. " на позицию " .. tostring(safePosition))
                        else
                            -- Если луч не нашел поверхность, возможно, цель недоступна или над пропастью
                            -- Можно попробовать другую стратегию или сбросить цель
                            print("Путь к " .. currentTargetPlayer.Name .. " заблокирован или ведет в пустоту. Ищу новую цель.")
                            isApproachingPlayer = false
                            currentTargetPlayer = nil
                        end
                        -- Небольшая пауза перед следующим шагом для плавности и снижения нагрузки
                        wait(0.2) -- Пауза 0.2 секунды между шагами
                    end
                else
                     -- Проблема с персонажами, сбрасываем
                    print("Ошибка доступа к персонажам при преследовании. Сброс.")
                    isApproachingPlayer = false
                    currentTargetPlayer = nil
                end
            end
        elseif isInCrowdArea and crowdAreaCenter then
            -- Логика брождения в области скопления
            local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and myHRP then
                -- Двигаемся к центру области скопления, но с небольшим случайным отклонением
                local randomOffset = Vector3.new(math.random(-8, 8), 0, math.random(-8, 8))
                local targetPosition = crowdAreaCenter + randomOffset
                -- Проверяем, есть ли земля в этой точке
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {player.Character}
                local raycastResult = workspace:Raycast(
                    targetPosition + Vector3.new(0, 10, 0),
                    Vector3.new(0, -20, 0),
                    raycastParams
                )
                if raycastResult and raycastResult.Instance then
                    local safeTargetPosition = raycastResult.Position + Vector3.new(0, 3, 0)
                    humanoid:MoveTo(safeTargetPosition)
                    -- print("Движение в области скопления к " .. tostring(safeTargetPosition))
                    -- Случайный прыжок с низкой вероятностью
                    if math.random(1, 10) == 1 then
                        humanoid.Jump = true
                    end
                end
                -- Ждем перед следующим шагом
                wait(math.random(2, 5))
            else
                -- Проблема с персонажем, выходим из режима скопления
                isInCrowdArea = false
                crowdAreaCenter = nil
            end
        else
            -- Не преследуем игрока и не в области скопления, выполняем случайное движение или выбираем новую цель
            -- С шансом 25% попробуем подойти к игроку, но с учетом кулдауна
            if math.random(1, 100) <= 25 and (currentTime - lastApproachAttemptTime) >= APPROACH_COOLDOWN then
                 local players = game:GetService("Players"):GetPlayers()
                local nearbyPlayers = {}
                -- Собираем всех игроков кроме себя
                for _, plr in ipairs(players) do
                    if plr ~= player and plr.Character then
                        local plrRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        if plrRoot then
                            -- Проверяем расстояние для первоначального выбора (например, до 20 studs)
                            local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if myHRP then
                                local initialDistance = (myHRP.Position - plrRoot.Position).Magnitude
                                if initialDistance < 20 then
                                    table.insert(nearbyPlayers, plr)
                                end
                            end
                        end
                    end
                end
                -- Если есть другие игроки рядом, выбираем случайного
                if #nearbyPlayers > 0 then
                    currentTargetPlayer = nearbyPlayers[math.random(1, #nearbyPlayers)]
                    isApproachingPlayer = true
                    approachStartTime = tick()
                    print("Выбрана новая цель для преследования: " .. currentTargetPlayer.Name)
                    -- Не ждем, сразу переходим к следующей итерации цикла для начала движения
                    -- wait(0) -- На самом деле, следующая итерация начнется сразу
                end
            end
            -- Если не выбрали цель для преследования или шанс не выпал, делаем случайный шаг
            if not isApproachingPlayer then
                 -- Ждем перед следующим случайным движением (как было)
                local waitTime = math.random(3, 7)
                wait(waitTime)
                if not botWalkEnabled then break end
                if not player.Character then continue end
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if not humanoid or not humanoidRootPart then continue end
                -- Находим позицию для случайного ходьбы (как было)
                local randomAngle = math.random() * 2 * math.pi
                local distance = math.random(12, 30) -- Уменьшено расстояние для случайных шагов
                local offset = Vector3.new(
                    math.cos(randomAngle) * distance,
                    0,
                    math.sin(randomAngle) * distance
                )
                local targetPosition = humanoidRootPart.Position + offset
                -- Проверяем, есть ли земля в этой точке (лучше использовать Raycast)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {player.Character}
                local raycastResult = workspace:Raycast(
                    targetPosition + Vector3.new(0, 10, 0),
                    Vector3.new(0, -20, 0),
                    raycastParams
                )
                if raycastResult and raycastResult.Instance then
                    local safeTargetPosition = raycastResult.Position + Vector3.new(0, 3, 0)
                    humanoid:MoveTo(safeTargetPosition)
                    -- print("Случайное движение на " .. tostring(safeTargetPosition))
                    -- Случайный прыжок
                    if math.random(1, 4) == 1 then -- Уменьшен шанс прыжка
                        humanoid.Jump = true
                    end
                end
            end
        end
    end
end
local function botMessageLoop()
    while botEnabled do
        -- Ждем 12-20 секунд
        local waitTime = math.random(12, 20)
        wait(waitTime)
        if not botEnabled then break end
        -- Отправляем сообщение
        sendBotMessage()
    end
end
-- Добавляем функцию Bot в Other
botToggle = addToggle("Other", "Bot Messages", "Отправляет философские сообщения каждые 12-20 секунд", function(state)
    botEnabled = state
    if state then
        -- Сбрасываем использованные фразы при включении
        usedInteractionMessages = {}
        coroutine.resume(coroutine.create(botMessageLoop))
        print("Bot сообщения включены")
    else
        print("Bot сообщения выключены")
    end
end)
-- Добавляем функцию ходьбы бота
botWalkToggle = addToggle("Other", "Bot Walk", "Бот случайно ходит по карте и прыгает", function(state)
    botWalkEnabled = state
    if state then
        -- Сбрасываем usedInteractionMessages при включении ходьбы
        usedInteractionMessages = {}
        isApproachingPlayer = false
        currentTargetPlayer = nil
        coroutine.resume(coroutine.create(botWalkLoop))
        print("Bot ходьба включена")
    else
        print("Bot ходьба выключена")
    end
end)
-- Добавляем функцию сообщений при получении урона
damageMessagesToggle = addToggle("Other", "Damage Messages", "Отправляет сообщения при получении урона (задержка 1 сек)", function(state)
    damageMessagesEnabled = state
    if state then
        setupDamageListener()
        print("Сообщения при уроне включены")
    else
        print("Сообщения при уроне выключены")
    end
end)
-- Устанавливаем обработчик при появлении персонажа
player.CharacterAdded:Connect(function()
    wait(1) -- Ждем полной загрузки персонажа
    if damageMessagesEnabled then
        setupDamageListener()
    end
    -- Сбрасываем usedInteractionMessages при появлении нового персонажа
    usedInteractionMessages = {}
    isApproachingPlayer = false
    currentTargetPlayer = nil
end)
-- Функция Auto Collect Guns (с ограничением попыток и возвратом, блять)
local autoCollectGunsEnabled = false
local autoCollectGunsToggle = nil
-- Таблица для отслеживания неудачных попыток подбора конкретных Handle
local failedAttempts = {}
-- Максимальное количество неудачных попыток до игнорирования Handle
local MAX_FAILED_ATTEMPTS = 3
local function collectGunsLoop()
    -- Собираем список всех персонажей игроков, чтобы исключить их из поиска
    local playerCharacters = {}
    for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
        if plr.Character then
            playerCharacters[plr.Character] = true
        end
    end
    while autoCollectGunsEnabled and player do
        if not player.Character then
            wait(1)
            continue
        end
        local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then
            wait(1)
            continue
        end
        local closestHandle = nil
        local closestDistance = math.huge
        -- Ищем ВСЕ папки с именем "Folder" в Workspace
        local folderInstances = {}
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name == "Folder" and child:IsA("Folder") then
                table.insert(folderInstances, child)
            end
        end
        -- Рекурсивная функция поиска Handles только внутри указанных папок
        local function searchForHandlesInFolders(folderList)
            local function search(instance)
                if autoCollectGunsEnabled == false then return end
                if instance.Name == "Handle" and instance:IsA("BasePart") then
                    -- Проверяем, не находится ли Handle внутри ЛЮБОГО персонажа игрока (включая своего)
                    local isInsideAnyPlayerCharacter = false
                    local currentParent = instance
                    while currentParent do
                        if playerCharacters[currentParent] then
                            isInsideAnyPlayerCharacter = true
                            break
                        end
                        currentParent = currentParent.Parent
                    end
                    -- Если Handle НЕ внутри персонажа игрока, проверяем его
                    if not isInsideAnyPlayerCharacter then
                         -- Проверяем, не превысил ли лимит неудачных попыток
                        if (failedAttempts[instance] or 0) < MAX_FAILED_ATTEMPTS then
                            local distance = (myHRP.Position - instance.Position).Magnitude
                            if distance < closestDistance then
                                closestHandle = instance
                                closestDistance = distance
                            end
                        -- else
                            -- print("Игнорируем Handle из-за превышения лимита неудач: " .. tostring(instance:GetFullName())) -- Для дебага
                        end
                    -- else
                        -- print("Игнорируем Handle внутри персонажа: " .. tostring(instance:GetFullName())) -- Для дебага
                    end
                end
                -- Продолжаем поиск в дочерних объектах, если это контейнер
                if autoCollectGunsEnabled and (instance:IsA("Folder") or instance:IsA("Model") or instance:IsA("Accessory") or instance:IsA("Tool") or instance:IsA("Part") or instance:IsA("MeshPart")) then
                    for _, child in ipairs(instance:GetChildren()) do
                        if autoCollectGunsEnabled == false then break end
                        search(child)
                    end
                end
            end
            -- Проходим по каждой найденной папке "Folder" и запускаем в ней поиск
            for _, folder in ipairs(folderList) do
                if autoCollectGunsEnabled == false then break end
                pcall(function()
                    search(folder)
                end)
            end
        end
        -- Запускаем поиск ТОЛЬКО в найденных папках "Folder"
        if #folderInstances > 0 then
            pcall(function()
                searchForHandlesInFolders(folderInstances)
            end)
        -- else
            -- print("Папки 'Folder' в Workspace не найдены.") -- Убрал спам в консоль
        end
        -- Если нашли Handle, телепортируемся к нему
        if closestHandle and autoCollectGunsEnabled then
            -- Запоминаем текущую позицию перед телепортом
            local positionBeforeTeleport = myHRP.Position
            myHRP.CFrame = CFrame.new(closestHandle.Position)
            print("Телепорт к Handle: " .. tostring(closestHandle:GetFullName()) .. " (Расстояние: " .. math.floor(closestDistance) .. ")")
            -- Ждем немного, чтобы сработало поднятие оружия
            wait(0.5) -- Увеличил немного время, чтобы точно успело подобраться
            -- Проверяем, подобрался ли Handle (например, исчез из Workspace или появился в инвентаре)
            -- Простая проверка: если Handle всё ещё существует и находится примерно в той же точке
            wait(0.1) -- Еще чуть подождем, чтобы точно обработалось
            if closestHandle and closestHandle.Parent and (closestHandle.Position - myHRP.Position).Magnitude < 5 then
                -- Вероятно, не подобрался
                failedAttempts[closestHandle] = (failedAttempts[closestHandle] or 0) + 1
                print("Не удалось подобрать Handle: " .. tostring(closestHandle:GetFullName()) .. ". Попытка #" .. tostring(failedAttempts[closestHandle]))
                -- Телепортируем обратно
                 myHRP.CFrame = CFrame.new(positionBeforeTeleport)
                 print("Телепорт обратно на позицию перед попыткой.")
            else
                -- Удалось подобрать или Handle исчез по другой причине (например, другой игрок подобрал)
                -- Сбрасываем счётчик неудач для этого Handle, если он исчез
                if not closestHandle.Parent then
                     failedAttempts[closestHandle] = nil
                     print("Handle успешно подобран или исчез.")
                end
            end
            wait(0.1) -- Небольшая пауза перед следующей итерацией
        else
            -- Ничего не нашли или все Handle исчерпали лимит попыток
            wait(1) -- Ждем дольше
        end
    end
    print("Цикл Auto Collect Guns остановлен.")
    -- Можно сбросить таблицу неудач при остановке, если нужно
    -- failedAttempts = {}
end
-- Переключатель (убедись, что addToggle определен выше в скрипте)
autoCollectGunsToggle = addToggle("Combat", "Auto Collect Guns", "Автоподбор оружия (только из папок Folder)", function(state)
    autoCollectGunsEnabled = state
    if state then
        -- Сбрасываем таблицу неудач при каждом включении
        failedAttempts = {}
        coroutine.resume(coroutine.create(collectGunsLoop))
        print("Auto Collect Guns включена")
    else
        print("Auto Collect Guns выключена")
    end
end)


-- === TARGET STRAFE (ОБНОВЛЁННАЯ ВЕРСИЯ ДЛЯ RemoteFunction HitRequest) === --
local targetStrafeEnabled = false
local strafeToggle = nil

-- Настройки
local STRAFE_RADIUS = 4.0
local STRAFE_HEIGHT = 7
local STRAFE_SPEED = 40.6
local MAX_ANGLE_OFFSET = math.pi / 2.3
local currentAngle = math.pi
local direction = 1

-- Параметры удара
local BACK_OFFSET = -1.0
local PREDICTION_TIME = 0.15
local HOLD_BEHIND_TIME = 0.35

-- Хранилище
local strafeTargetPos = {}
local strafeTargetVel = {}
local isHoldingBehind = false
local holdStartTime = 0
local lastAttackTime = 0
local ATTACK_COOLDOWN = 0.2 -- секунд между ударами

-- Получение HRP
local function getHRP(plr)
    return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
end

-- Проверка анимации цели (для уклонения)
local function isTargetPunching(target)
    if not target or not target.Character then return false end
    local animator = target.Character:FindFirstChildOfClass("Animator")
    if not animator then return false end
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        local anim = track.Animation
        if anim == ReplicatedStorage.Anims:FindFirstChild("Punch") or anim == ReplicatedStorage.Anims:FindFirstChild("Punch1") then
            return true
        end
    end
    return false
end

-- Удар через HitRequest (RemoteFunction)
local function sendHitRequest(targetPlayer)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local hitRequest = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("HitRequest")
    if hitRequest and hitRequest:IsA("RemoteFunction") then
        local success, result = pcall(function()
            -- ⚠️ ЗАМЕНИ АРГУМЕНТ, ЕСЛИ НУЖНО
            return hitRequest:InvokeServer(targetPlayer)
        end)
        if not success then
            warn("HitRequest в TargetStrafe failed:", result)
        end
    else
        warn("HitRequest не найден или не RemoteFunction в TargetStrafe")
    end
end

-- Телепорт ЗА ПРЕДСКАЗАННУЮ СПИНУ + УДАР
local function teleportToPredictedBackAndHit()
    local myHRP = getHRP(player)
    local tHRP = getHRP(_G.currentTarget)
    if not myHRP or not tHRP then return end

    local target = _G.currentTarget
    local now = tick()
    local lastPos = strafeTargetPos[target]
    strafeTargetPos[target] = tHRP.Position

    local vel = Vector3.new(0, 0, 0)
    if lastPos then
        local dt = math.max(now - (strafeLastUpdate or now - 1/60), 1/120)
        vel = (tHRP.Position - lastPos) / dt
    end
    strafeTargetVel[target] = vel
    strafeLastUpdate = now

    -- Предсказание позиции цели
    local predPos = tHRP.Position + vel * PREDICTION_TIME
    local lookDir = (vel.Magnitude > 1) and vel.Unit or tHRP.CFrame.LookVector
    local backPos = predPos - lookDir * BACK_OFFSET

    -- Телепорт за спину
    myHRP.CFrame = CFrame.new(backPos, predPos)

    -- Удар через HitRequest
    local currentTime = tick()
    if currentTime - lastAttackTime >= ATTACK_COOLDOWN then
        sendHitRequest(target)
        lastAttackTime = currentTime
    end
end

-- Возврат на орбиту
local function returnToOrbit()
    local myHRP = getHRP(player)
    local tHRP = getHRP(_G.currentTarget)
    if not myHRP or not tHRP then return end

    currentAngle = currentAngle + direction * STRAFE_SPEED * RunService.Heartbeat:Wait()
    local minA = math.pi - MAX_ANGLE_OFFSET
    local maxA = math.pi + MAX_ANGLE_OFFSET
    if currentAngle >= maxA then currentAngle = maxA; direction = -1
    elseif currentAngle <= minA then currentAngle = minA; direction = 1 end

    local x = math.cos(currentAngle) * STRAFE_RADIUS
    local z = math.sin(currentAngle) * STRAFE_RADIUS
    local pos = Vector3.new(tHRP.Position.X + x, tHRP.Position.Y + STRAFE_HEIGHT, tHRP.Position.Z + z)
    myHRP.CFrame = CFrame.new(pos, tHRP.Position)

    if math.random() < 0.02 then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Jump = true end
    end
end

-- Основной цикл Target Strafe
local strafeLastUpdate = tick()
RunService.Heartbeat:Connect(function()
    if not targetStrafeEnabled or not _G.currentTarget or not player.Character then
        return
    end

    local tHRP = getHRP(_G.currentTarget)
    if not tHRP then return end

    -- Уклонение от атаки
    if isTargetPunching(_G.currentTarget) then
        local myHRP = getHRP(player)
        if myHRP then
            myHRP.CFrame = CFrame.new(tHRP.Position + Vector3.new(0, 8, 0))
        end
        return
    end

    -- Удержание за спиной + удар
    if not isHoldingBehind then
        teleportToPredictedBackAndHit()
        isHoldingBehind = true
        holdStartTime = tick()
    else
        local elapsed = tick() - holdStartTime
        if elapsed < HOLD_BEHIND_TIME then
            teleportToPredictedBackAndHit() -- Поддерживаем позицию и бьём
        else
            isHoldingBehind = false
        end
    end

    -- Если не держимся — обычный стрейф
    if not isHoldingBehind then
        returnToOrbit()
    end
end)

-- GUI переключатель
strafeToggle = addToggle("Combat", "Target Strafe", "Плавный стрейф сзади + автоматический удар через HitRequest", function(state)
    targetStrafeEnabled = state
    if state then
        currentAngle = math.pi
        direction = 1
        strafeTargetPos = {}
        strafeTargetVel = {}
        isHoldingBehind = false
        lastAttackTime = 0
        print("🎯 Target Strafe (с HitRequest) включён")
    else
        print("🎯 Target Strafe выключён")
    end
end)
-- === КОНЕЦ TARGET STRAFE === --


-- === OrbitalStrike (возврат и заморозка ТОЛЬКО при потере цели или выключении атаки) === --
do
    local OrbitalActive = false     -- Атака включена? (кнопка On/Off)
    local OrbitalMasterEnabled = false -- Функция включена? (тумблер GUI)
    local OrbitalTarget = nil
    local OrbitalTool = nil
    local OrbitalButton = nil
    local OrbitalState = 0
    local OrbitalTimer = 0

    -- Параметры по умолчанию
    local FORWARD_OFFSET = 1.5
    local HEIGHT_OFFSET = 3
    local HIGH_HEIGHT = 50

    -- Позиция для возврата (сохраняется при старте атаки)
    local returnPosition = nil

    -- Уведомление через Roblox
    local function notify(title, text, duration)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = duration or 2
            })
        end)
    end

    -- Возврат + заморозка
    local function returnAndFreeze()
        if not player.Character then return end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if returnPosition then
            hrp.CFrame = CFrame.new(returnPosition)
        end

        -- Обнуление инерции
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

        -- Заморозка
        hrp.Anchored = true
        notify("🛡️ OrbitalStrike", "Возврат и заморозка", 1.5)

        -- Разморозка через 1.5 сек
        task.delay(1.5, function()
            if player.Character then
                local hrp2 = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp2 then
                    hrp2.Anchored = false
                end
            end
        end)
    end

    -- Создание тулза
    local function createOrbitalTool()
        if OrbitalTool then return end
        OrbitalTool = Instance.new("Tool")
        OrbitalTool.Name = "OrbitalSelect"
        OrbitalTool.RequiresHandle = false
        OrbitalTool.Parent = player:WaitForChild("Backpack")
        OrbitalTool.Activated:Connect(function()
            local mouse = player:GetMouse()
            local hit = mouse.Target
            if not hit then return end
            local model = hit:FindFirstAncestorOfClass("Model")
            if not model then return end
            local targetPlayer = Players:GetPlayerFromCharacter(model)
            if targetPlayer and targetPlayer ~= player then
                OrbitalTarget = targetPlayer
                notify("🎯 OrbitalStrike", "Цель: " .. targetPlayer.Name, 2)
            else
                notify("⚠️ OrbitalStrike", "Выберите другого игрока!", 2)
            end
        end)
    end

    local function destroyOrbitalTool()
        if OrbitalTool then
            pcall(function() OrbitalTool:Destroy() end)
            OrbitalTool = nil
        end
    end

    local function createOrbitalButton()
        if OrbitalButton then return end
        OrbitalButton = Instance.new("TextButton")
        OrbitalButton.Size = UDim2.new(0, 70, 0, 25)
        OrbitalButton.Position = UDim2.new(0, 10, 0, 10)
        OrbitalButton.BackgroundColor3 = Color3.new(0.7, 0.2, 0.2)
        OrbitalButton.Text = "OFF"
        OrbitalButton.TextColor3 = Color3.new(1, 1, 1)
        OrbitalButton.Font = Enum.Font.GothamBold
        OrbitalButton.Parent = gui
        OrbitalButton.Draggable = true
        OrbitalButton.MouseButton1Click:Connect(function()
            if not OrbitalTarget then
                notify("⚠️ OrbitalStrike", "Сначала выберите цель!", 2)
                return
            end
            OrbitalActive = not OrbitalActive
            OrbitalButton.Text = OrbitalActive and "ON" or "OFF"
            OrbitalButton.BackgroundColor3 = OrbitalActive and Color3.new(0.2, 0.7, 0.2) or Color3.new(0.7, 0.2, 0.2)

            if OrbitalActive then
                -- Сохраняем позицию ТОЛЬКО при начале атаки
                if player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        returnPosition = hrp.Position
                    end
                end
                OrbitalState = 0
                OrbitalTimer = 0
            else
                -- Возврат + заморозка при выключении атаки
                returnAndFreeze()
            end
        end)
    end

    local function destroyOrbitalButton()
        if OrbitalButton then
            pcall(function() OrbitalButton:Destroy() end)
            OrbitalButton = nil
        end
    end

    -- Основной цикл
    RunService.Heartbeat:Connect(function(dt)
        if not OrbitalMasterEnabled or not OrbitalActive or not OrbitalTarget or not player.Character then
            return
        end

        if not OrbitalTarget.Character then
            OrbitalActive = false
            if OrbitalButton then
                OrbitalButton.Text = "OFF"
                OrbitalButton.BackgroundColor3 = Color3.new(0.7, 0.2, 0.2)
            end
            notify("🛑 OrbitalStrike", "Цель исчезла", 2)
            returnAndFreeze()
            return
        end

        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        local targetHRP = OrbitalTarget.Character:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then return end

        -- Поворот к цели
        local lookAtCFrame = CFrame.lookAt(hrp.Position, targetHRP.Position)
        hrp.CFrame = lookAtCFrame

        -- Упреждение по LookVector цели
        local targetLook = targetHRP.CFrame.LookVector
        local forwardOffset = Vector3.new(targetLook.X, 0, targetLook.Z) * FORWARD_OFFSET
        local basePos = targetHRP.Position + forwardOffset

        if OrbitalState == 0 then
            local hitPos = basePos + Vector3.new(0, HEIGHT_OFFSET, 0)
            hrp.CFrame = CFrame.lookAt(hitPos, targetHRP.Position)

            RunService.Heartbeat:Wait()
            RunService.Heartbeat:Wait()

            local hitReq = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes").HitRequest
            if hitReq and hitReq:IsA("RemoteFunction") then
                pcall(function() hitReq:InvokeServer(OrbitalTarget) end)
                notify("💥 OrbitalStrike", "Удар отправлен", 1)
            else
                notify("❌ OrbitalStrike", "HitRequest не найден!", 2)
            end

            OrbitalState = 1
            OrbitalTimer = 0
        elseif OrbitalState == 1 then
            local hitPos = basePos + Vector3.new(0, HEIGHT_OFFSET, 0)
            hrp.CFrame = CFrame.lookAt(hitPos, targetHRP.Position)
            OrbitalTimer += dt
            if OrbitalTimer >= 1 then
                OrbitalState = 2
                OrbitalTimer = 0
            end
        elseif OrbitalState == 2 then
            local highPos = basePos + Vector3.new(0, HIGH_HEIGHT, 0)
            hrp.CFrame = CFrame.lookAt(highPos, targetHRP.Position)
            OrbitalTimer += dt
            if OrbitalTimer >= 2 then
                OrbitalState = 0
            end
        end
    end)

    -- Слайдеры
    addSlider("Combat", "Orbital Forward", "Смещение вперёд от цели", 0, 5, 1.5, function(value)
        FORWARD_OFFSET = value
    end)
    addSlider("Combat", "Orbital Height", "Высота при ударе", 1, 10, 3, function(value)
        HEIGHT_OFFSET = value
    end)
    addSlider("Combat", "Orbital High Height", "Высота подъёма", 20, 100, 50, function(value)
        HIGH_HEIGHT = value
    end)

    -- Переключатель (только включает/выключает функцию, НЕ триггерит возврат)
    addToggle("Combat", "OrbitalStrike", "Тул → цель. ON → атака с возвратом при потере цели.", function(state)
        OrbitalMasterEnabled = state
        if state then
            createOrbitalTool()
            createOrbitalButton()
            OrbitalActive = false
            OrbitalTarget = nil
            returnPosition = nil
            notify("✅ OrbitalStrike", "Тул выдан", 2)
        else
            -- ❗ НЕ вызываем returnAndFreeze здесь!
            OrbitalActive = false
            OrbitalTarget = nil
            destroyOrbitalTool()
            destroyOrbitalButton()
            notify("🛑 OrbitalStrike", "Функция выключена", 2)
        end
    end)
end
-- === КОНЕЦ OrbitalStrike === --

-- Добавляем Anti-Void в Other
antiVoidToggle = addToggle("Other", "Anti-Void", "Создает невидимый парт 50x50 под игроком", function(state)
    setupAntiVoid(state)
end)
-- Добавляем кнопку удаления опасных частей в Other
addButton("Other", "Удалить всё небезопасное", "Удаляет папки FireParts, KillParts, RagdollParts", removeUnsafeParts)

-- Запускаем все проверки
RunService.Heartbeat:Connect(function()
    if antiPlayersEnabled then
        checkAndTeleportFromPlayers()
    end
    if antiVoidEnabled then
        updateAntiVoidPart()
    end
    if velocityEnabled then
        checkVelocity()
    end
    if killAuraEnabled then
        updateKillAura()
    end
end)

-- Обновляем размеры скролл фреймов
for _, tab in pairs(tabs) do
    tab.CanvasSize = UDim2.new(0, 0, 0, tab.UIListLayout.AbsoluteContentSize.Y)
    tab.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.CanvasSize = UDim2.new(0, 0, 0, tab.UIListLayout.AbsoluteContentSize.Y)
    end)
end

-- Переключаем на первую вкладку
tabButtons["Combat"]:MouseButton1Click()
print("GUI загружено в CoreGui! Нажмите на крестик для закрытия")