local library = {flags = {}, windows = {}, open = true}

local runService = game:GetService"RunService"
local tweenService = game:GetService"TweenService"
local textService = game:GetService"TextService"
local inputService = game:GetService"UserInputService"
local ui = Enum.UserInputType.MouseButton1

local dragging, dragInput, dragStart, startPos, dragObject


local function round(num, bracket)
	bracket = bracket or 1
	local a = math.floor(num/bracket + (math.sign(num) * 0.5)) * bracket
	if a < 0 then
		a = a + bracket
	end
	return a
end

local function keyCheck(x,x1)
	for _,v in next, x1 do
		if v == x then
			return true
		end
	end
end

local function update(input)
	local delta = input.Position - dragStart
	local yPos = (startPos.Y.Offset + delta.Y) < -36 and -36 or startPos.Y.Offset + delta.Y
	dragObject:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, yPos), "Out", "Quint", 0.1, true)
end
 

local chromaColor
local rainbowTime = 5
spawn(function()
	while wait() do
		chromaColor = Color3.fromHSV(tick() % rainbowTime / rainbowTime, 1, 1)
	end
end)

function library:Create(class, properties)
	properties = typeof(properties) == "table" and properties or {}
	local inst = Instance.new(class)
	for property, value in next, properties do
		inst[property] = value
	end
	return inst
end

local function createOptionHolder(holderTitle, parent, parentTable, subHolder)
	local size = subHolder and 34 or 40
	parentTable.main = library:Create("ImageButton", {
		LayoutOrder = subHolder and parentTable.position or 0,
		Position = UDim2.new(0, 20 + (250 * (parentTable.position or 0)), 0, 20),
		Size = UDim2.new(0, 230, 0, size),
		BackgroundTransparency = 1,
		Image = "rbxassetid://3570695787",
		ImageColor3 = Color3.fromRGB(20, 20, 20),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 0.04,
		ClipsDescendants = true,
		Parent = parent
	})
	
	local round
	if not subHolder then
		round = library:Create("ImageLabel", {
			Size = UDim2.new(1, 0, 0, size),
			BackgroundTransparency = 1,
			Image = "rbxassetid://3570695787",
			ImageColor3 = parentTable.open and (subHolder and Color3.fromRGB(16, 16, 16) or Color3.fromRGB(10, 10, 10)) or (subHolder and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(6, 6, 6)),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(100, 100, 100, 100),
			SliceScale = 0.04,
			Parent = parentTable.main
		})
	end
	
	local title = library:Create("TextLabel", {
		Size = UDim2.new(1, 0, 0, size),
		BackgroundTransparency = subHolder and 0 or 1,
		BackgroundColor3 = Color3.fromRGB(10, 10, 10),
		BorderSizePixel = 0,
		Text = holderTitle,
		TextSize = subHolder and 16 or 17,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Parent = parentTable.main
	})
	
	local closeHolder = library:Create("Frame", {
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(-1, 0, 1, 0),
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		BackgroundTransparency = 1,
		Parent = title
	})
	
	local close = library:Create("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -size - 10, 1, -size - 10),
		Rotation = parentTable.open and 90 or 180,
		BackgroundTransparency = 1,
		Image = "rbxassetid://4918373417",
		ImageColor3 = parentTable.open and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(30, 30, 30),
		ScaleType = Enum.ScaleType.Fit,
		Parent = closeHolder
	})
	
	parentTable.content = library:Create("Frame", {
		Position = UDim2.new(0, 0, 0, size),
		Size = UDim2.new(1, 0, 1, -size),
		BackgroundTransparency = 1,
		Parent = parentTable.main
	})
	
	local layout = library:Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parentTable.content
	})
	
	layout.Changed:connect(function()
		parentTable.content.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
		parentTable.main.Size = #parentTable.options > 0 and parentTable.open and UDim2.new(0, 230, 0, layout.AbsoluteContentSize.Y + size) or UDim2.new(0, 230, 0, size)
	end)
	
	if not subHolder then
		library:Create("UIPadding", {
			Parent = parentTable.content
		})
		
		title.InputBegan:connect(function(input)
			if input.UserInputType == ui then
				dragObject = parentTable.main
				dragging = true
				dragStart = input.Position
				startPos = dragObject.Position
			elseif input.UserInputType == Enum.UserInputType.Touch then
				dragObject = parentTable.main
				dragging = true
				dragStart = input.Position
				startPos = dragObject.Position
			end
		end)
		title.InputChanged:connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			elseif dragging and input.UserInputType == Enum.UserInputType.Touch then
				dragInput = input
			end
		end)
			title.InputEnded:connect(function(input)
			if input.UserInputType == ui then
				dragging = false
			elseif input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end
	
	closeHolder.InputBegan:connect(function(input)
		if input.UserInputType == ui then
			parentTable.open = not parentTable.open
			tweenService:Create(close, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = parentTable.open and 90 or 180, ImageColor3 = parentTable.open and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(30, 30, 30)}):Play()
			if subHolder then
				tweenService:Create(title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = parentTable.open and Color3.fromRGB(16, 16, 16) or Color3.fromRGB(10, 10, 10)}):Play()
			else
				tweenService:Create(round, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = parentTable.open and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(6, 6, 6)}):Play()
			end
			parentTable.main:TweenSize(#parentTable.options > 0 and parentTable.open and UDim2.new(0, 230, 0, layout.AbsoluteContentSize.Y + size) or UDim2.new(0, 230, 0, size), "Out", "Quad", 0.2, true)
		elseif input.UserInputType == Enum.UserInputType.Touch then
			parentTable.open = not parentTable.open
			tweenService:Create(close, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = parentTable.open and 90 or 180, ImageColor3 = parentTable.open and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(30, 30, 30)}):Play()
			if subHolder then
				tweenService:Create(title, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = parentTable.open and Color3.fromRGB(16, 16, 16) or Color3.fromRGB(10, 10, 10)}):Play()
			else
				tweenService:Create(round, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = parentTable.open and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(6, 6, 6)}):Play()
			end
			parentTable.main:TweenSize(#parentTable.options > 0 and parentTable.open and UDim2.new(0, 230, 0, layout.AbsoluteContentSize.Y + size) or UDim2.new(0, 230, 0, size), "Out", "Quad", 0.2, true)
		end
	end)

	function parentTable:SetTitle(newTitle)
		title.Text = tostring(newTitle)
	end
	
	return parentTable
end
	
local function createLabel(option, parent)
	local main = library:Create("TextLabel", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Text = " " .. option.text,
		TextSize = 17,
		Font = Enum.Font.SourceSans,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent.content
	})
	
	setmetatable(option, {__newindex = function(t, i, v)
		if i == "Text" then
			main.Text = " " .. tostring(v)
		end
	end})
end

function createToggle(option, parent)
	
	option.onColor = option.onColor or Color3.fromRGB(0, 255, 128) 
	option.offColor = Color3.fromRGB(50, 50, 50)

	local main = library:Create("TextButton", { 
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = parent.content
	})


	local title = library:Create("TextLabel", {
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(1, -60, 1, 0),
		BackgroundTransparency = 1,
		Text = option.text,
		TextSize = 17,
		Font = Enum.Font.GothamSemibold, 
		TextColor3 = Color3.fromRGB(230, 230, 230),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = main
	})

	
	local switchBg = library:Create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.new(0, 44, 0, 22),
		BackgroundColor3 = option.state and option.onColor or option.offColor,
		BorderSizePixel = 0,
		Parent = main
	})

	library:Create("UICorner", {
		CornerRadius = UDim.new(1, 0), 
		Parent = switchBg
	})
    
    
    library:Create("UIStroke", {
        Color = Color3.fromRGB(30,30,30),
        Thickness = 1,
        Parent = switchBg
    })

	
	local knob = library:Create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = option.state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
		Size = UDim2.new(0, 18, 0, 18),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = switchBg
	})

	library:Create("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = knob
	})

	local toggling = false

	
	function option:SetState(bool)
		if bool == nil then bool = not self.state end
		self.state = bool
		library.flags[self.flag] = bool

		local targetPos = bool and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
		local targetColor = bool and self.onColor or self.offColor

		
		tweenService:Create(knob, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
		tweenService:Create(switchBg, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()

		pcall(self.callback, bool)
	end

	
	main.MouseButton1Click:Connect(function()
		if not toggling then
			toggling = true
			option:SetState(not option.state)
			wait(0.1)
			toggling = false
		end
	end)
    
    
    main.MouseEnter:Connect(function()
        tweenService:Create(title, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    main.MouseLeave:Connect(function()
        tweenService:Create(title, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
    end)

	
	if option.state then
		option:SetState(true)
	end
    
    
	setmetatable(option, {__newindex = function(t, i, v)
		if i == "Text" then
			title.Text = tostring(v)
		end
	end})
end

local function createButton(option, parent)
    
    local main = library:Create("TextButton", { 
        LayoutOrder = option.position,
        Size = UDim2.new(1, 0, 0, 34), 
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = parent.content
    })

    
    local container = library:Create("Frame", {
        Name = "Container",
        Size = UDim2.new(1, 0, 1, -4),
        Position = UDim2.new(0, 0, 0, 2),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        ClipsDescendants = true, 
        Parent = main
    })

    library:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = container
    })

    
    local stroke = library:Create("UIStroke", {
        Color = Color3.fromRGB(60, 60, 60),
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = container
    })

    
    if option.icon then
        library:Create("ImageLabel", {
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundTransparency = 1,
            Image = option.icon,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Parent = container
        })
    end

    
    local title = library:Create("TextLabel", {
        Size = UDim2.new(1, option.icon and -40 or 0, 1, 0),
        Position = UDim2.new(0, option.icon and 35 or 0, 0, 0),
        BackgroundTransparency = 1,
        Text = option.text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextXAlignment = option.icon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
        Parent = container
    })

    
    local function spawnRipple(inputObject)
        if not option.active then return end
        
        local ripple = library:Create("ImageLabel", {
            Name = "Ripple",
            BackgroundTransparency = 1,
            Image = "rbxassetid://2708891598", 
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.6,
            Parent = container,
            ZIndex = 5
        })

        local x, y
        if inputObject.UserInputType == Enum.UserInputType.Touch or inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
            x = inputObject.Position.X - container.AbsolutePosition.X
            y = inputObject.Position.Y - container.AbsolutePosition.Y
        else
            x = container.AbsoluteSize.X / 2
            y = container.AbsoluteSize.Y / 2
        end

        ripple.Position = UDim2.new(0, x, 0, y)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)

        local maxSize = math.max(container.AbsoluteSize.X, container.AbsoluteSize.Y) * 2.5
        
        tweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            ImageTransparency = 1
        }):Play()

        game:GetService("Debris"):AddItem(ripple, 0.6)
    end

    
    main.MouseEnter:Connect(function()
        if not option.active then return end
        tweenService:Create(container, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        tweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(100, 100, 100)}):Play()
        tweenService:Create(title, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    
    main.MouseLeave:Connect(function()
        if not option.active then return end
        tweenService:Create(container, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        tweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(60, 60, 60)}):Play()
        tweenService:Create(title, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end)

    
    main.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and option.active then
            spawnRipple(input)
            tweenService:Create(container, TweenInfo.new(0.1), {Size = UDim2.new(1, -2, 1, -6)}):Play() 
            
            task.spawn(function()
                option.callback()
            end)
        end
    end)

    main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tweenService:Create(container, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 1, -4)}):Play() 
        end
    end)

    
    
    function option:SetText(text)
        option.text = text
        title.Text = text
    end

    function option:SetCallback(fn)
        option.callback = fn
    end

    function option:Fire()
        option.callback()
        spawnRipple({UserInputType = Enum.UserInputType.None}) 
    end

    function option:Lock(bool)
        option.active = not bool
        if bool then
            
            tweenService:Create(container, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
            tweenService:Create(title, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(100, 100, 100)}):Play()
            tweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 40)}):Play()
        else
            
            tweenService:Create(container, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            tweenService:Create(title, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            tweenService:Create(stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(60, 60, 60)}):Play()
        end
    end
end

local blacklistedKeys = {
    Enum.KeyCode.Unknown,
    Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
    Enum.KeyCode.Slash, Enum.KeyCode.Tab, Enum.KeyCode.Backspace, Enum.KeyCode.Escape
}


local keyNames = {
    ["MouseButton1"] = "MB1", ["MouseButton2"] = "MB2", ["MouseButton3"] = "MB3",
    ["LeftControl"] = "L.Ctrl", ["RightControl"] = "R.Ctrl",
    ["LeftAlt"] = "L.Alt", ["RightAlt"] = "R.Alt",
    ["LeftShift"] = "L.Shift", ["RightShift"] = "R.Shift",
    ["CapsLock"] = "Caps", ["Return"] = "Enter", ["Backspace"] = "Back",
    ["ContextMenu"] = "Menu", ["Insert"] = "Ins", ["Delete"] = "Del",
    ["PageUp"] = "PgUp", ["PageDown"] = "PgDn", ["Home"] = "Home", ["End"] = "End",
    ["Space"] = "Space"
}

local function formatKeyName(keyName)
    return keyNames[keyName] or keyName
end

local function createBind(option, parent)
    
    option.key = option.key or Enum.KeyCode.F
    
    local currentKeyName = typeof(option.key) == "EnumItem" and option.key.Name or tostring(option.key)
    
    local binding = false
    local loop 

    
    local main = library:Create("TextLabel", {
        LayoutOrder = option.position,
        Size = UDim2.new(1, 0, 0, 35), 
        BackgroundTransparency = 1,
        Text = " " .. option.text,
        TextSize = 17,
        Font = Enum.Font.Gotham, 
        TextColor3 = Color3.fromRGB(230, 230, 230),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent.content
    })

    
    local buttonContainer = library:Create("TextButton", { 
        Position = UDim2.new(1, -10, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 0, 0, 20), 
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = main
    })

    local buttonBg = library:Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = buttonContainer
    })

    library:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = buttonBg})
    
    
    local stroke = library:Create("UIStroke", {
        Color = Color3.fromRGB(60, 60, 60),
        Thickness = 1,
        Parent = buttonBg
    })

    local bindText = library:Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = formatKeyName(currentKeyName),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Parent = buttonBg
    })

    
    local function updateSize()
        local txtSize = textService:GetTextSize(bindText.Text, 13, bindText.Font, Vector2.new(999, 20))
        buttonContainer.Size = UDim2.new(0, txtSize.X + 20, 0, 22)
    end
    updateSize()

    
    function option:SetKey(newKey)
        binding = false
        
        if typeof(newKey) == "EnumItem" then
            currentKeyName = newKey.Name
            self.key = newKey
        elseif type(newKey) == "string" then
            currentKeyName = newKey
            self.key = newKey
        end

        library.flags[self.flag] = currentKeyName
        bindText.Text = formatKeyName(currentKeyName)
        updateSize()

        
        tweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 60)}):Play()
        tweenService:Create(bindText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        tweenService:Create(buttonBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
    end

    
    buttonContainer.MouseButton1Click:Connect(function()
        if binding then return end
        binding = true
        bindText.Text = "..."
        updateSize()
        
        
        tweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 170, 0)}):Play() 
        tweenService:Create(bindText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    
    inputService.InputBegan:Connect(function(input, gameProcessed)
        if not binding then
            
            if not gameProcessed and (input.KeyCode.Name == currentKeyName or input.UserInputType.Name == currentKeyName) then
                if currentKeyName == "None" then return end
                
                
                tweenService:Create(buttonBg, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
                tweenService:Create(bindText, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()

                if option.hold then
                    
                    option.callback(true) 
                    if loop then loop:Disconnect() end
                    loop = runService.Heartbeat:Connect(function()
                        
                    end)
                else
                    
                    option.callback()
                end
            end
        else
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                
                if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.Escape then
                    option:SetKey("None")
                    return
                end

                
                local isBlacklisted = false
                for _, v in pairs(blacklistedKeys) do
                    if input.KeyCode == v then isBlacklisted = true break end
                end
                
                if not isBlacklisted then
                    option:SetKey(input.KeyCode)
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
                 option:SetKey(input.UserInputType)
            end
        end
    end)

    
    inputService.InputEnded:Connect(function(input)
        if not binding and (input.KeyCode.Name == currentKeyName or input.UserInputType.Name == currentKeyName) then
            if currentKeyName == "None" then return end

            
            tweenService:Create(buttonBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            tweenService:Create(bindText, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()

            if option.hold and loop then
                loop:Disconnect()
                loop = nil
                option.callback(false) 
            end
        end
    end)

    
    library.flags[option.flag] = currentKeyName
end

local function createSlider(option, parent)
	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 1,
		Parent = parent.content
	})
	
	
	local title = library:Create("TextLabel", {
		Position = UDim2.new(0, 10, 0, 5),
		Size = UDim2.new(0.5, 0, 0, 20),
		BackgroundTransparency = 1,
		Text = option.text,
		TextSize = 16,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255), 
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = main
	})
	
	
	local valueBg = library:Create("ImageLabel", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 5),
		Size = UDim2.new(0, 50, 0, 20),
		BackgroundTransparency = 1,
		Image = "rbxassetid://3570695787",
		ImageColor3 = Color3.fromRGB(30, 30, 30), 
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 0.02,
		Parent = main
	})
	
	local inputvalue = library:Create("TextBox", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = option.value,
		TextColor3 = Color3.fromRGB(255, 255, 255), 
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		Parent = valueBg
	})

	
	local sliderBg = library:Create("ImageLabel", {
		Position = UDim2.new(0, 10, 0, 35),
		Size = UDim2.new(1, -20, 0, 6),
		BackgroundTransparency = 1,
		Image = "rbxassetid://3570695787",
		ImageColor3 = Color3.fromRGB(40, 40, 40), 
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 0.02,
		Parent = main
	})
	
	
	local fill = library:Create("ImageLabel", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 1,
		Image = "rbxassetid://3570695787",
		ImageColor3 = Color3.fromRGB(255, 255, 255), 
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 0.02,
		Parent = sliderBg
	})
	

	local gradient = library:Create("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)), 
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))  
		},
		Parent = fill
	})

	
	local circle = library:Create("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(0, 14, 0, 14),
		BackgroundTransparency = 1,
		Image = "rbxassetid://3570695787", 
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 1, 
		Parent = fill 
	})
	
	
	local circleGlow = library:Create("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 8, 1, 8), 
		BackgroundTransparency = 1,
		Image = "rbxassetid://3570695787",
		ImageColor3 = Color3.fromRGB(255, 255, 255), 
		ImageTransparency = 0.8,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 1,
		Parent = circle
	})
	

	local dragging = false
	
	local function updateSlider(input)
		local sizeX = sliderBg.AbsoluteSize.X
		local positionX = sliderBg.AbsolutePosition.X
		
		
		local percent = math.clamp((input.Position.X - positionX) / sizeX, 0, 1)
		
		
		local value = option.min + (option.max - option.min) * percent
		value = round(value, option.float) 
		
		option:SetValue(value)
	end
	
	
	function option:SetValue(value)
		
		value = math.clamp(value, self.min, self.max)
		
	
		local roundedValue = round(value, option.float)
		
		
		local percent = (roundedValue - self.min) / (self.max - self.min)
		
		
		tweenService:Create(fill, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(percent, 0, 1, 0)
		}):Play()
		
		
		circle.Position = UDim2.new(1, 0, 0.5, 0)

		library.flags[self.flag] = roundedValue
		self.value = roundedValue
		inputvalue.Text = tostring(roundedValue)
		self.callback(roundedValue)
	end

	
	inputvalue.FocusLost:connect(function()
		local num = tonumber(inputvalue.Text)
		if num then
			option:SetValue(num)
		else
			inputvalue.Text = tostring(option.value)
		end
	end)


	sliderBg.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateSlider(input)
			
			
			tweenService:Create(circle, TweenInfo.new(0.2), {Size = UDim2.new(0, 18, 0, 18)}):Play()
			tweenService:Create(circleGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
		
			tweenService:Create(valueBg, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(50, 50, 50)}):Play()
		end
	end)

	sliderBg.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			
		
			tweenService:Create(circle, TweenInfo.new(0.2), {Size = UDim2.new(0, 14, 0, 14)}):Play()
			tweenService:Create(circleGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
			tweenService:Create(valueBg, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(30, 30, 30)}):Play()
		end
	end)

	inputService.InputChanged:connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)

 
	option:SetValue(option.value)
end

local function createList(option, parent, holder)

	option.multiselect = option.multiselect or false
	

	if option.multiselect then
		if type(option.value) == "string" and option.value ~= "" then
			option.value = {[option.value] = true}
		elseif type(option.value) ~= "table" then
			option.value = {}
		end
	end

	local valueCount = 0
	

	local main = library:Create("Frame", {
		LayoutOrder = option.position,
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundTransparency = 1,
		Parent = parent.content
	})
	

	local round = library:Create("ImageLabel", {
		Position = UDim2.new(0, 6, 0, 4),
		Size = UDim2.new(1, -12, 1, -10),
		BackgroundTransparency = 1,
		Image = "rbxassetid://3570695787",
		ImageColor3 = Color3.fromRGB(40, 40, 40),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 0.02,
		Parent = main
	})
	

	local title = library:Create("TextLabel", {
		Position = UDim2.new(0, 12, 0, 8),
		Size = UDim2.new(1, -24, 0, 14),
		BackgroundTransparency = 1,
		Text = option.text,
		TextSize = 14,
		Font = Enum.Font.SourceSans,
		TextColor3 = Color3.fromRGB(140, 140, 140),
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = main
	})
	

	local listvalue = library:Create("TextLabel", {
		Position = UDim2.new(0, 12, 0, 20),
		Size = UDim2.new(1, -40, 0, 24),
		BackgroundTransparency = 1,
		Text = "", 
		TextSize = 18,
		Font = Enum.Font.SourceSansBold,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Left,
		ClipsDescendants = true,
		Parent = main
	})
	
	
	local arrow = library:Create("ImageLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.new(0, 14, 0, 14),
		BackgroundTransparency = 1,
		Image = "rbxassetid://4918373417",
		ImageColor3 = Color3.fromRGB(140, 140, 140),
		Rotation = -90, 
		ScaleType = Enum.ScaleType.Fit,
		Parent = round
	})


	option.mainHolder = library:Create("ImageButton", {
		ZIndex = 10,
		Size = UDim2.new(0, 240, 0, 52),
		BackgroundTransparency = 1,
		Image = "rbxassetid://3570695787",
		ImageTransparency = 1,
		ImageColor3 = Color3.fromRGB(35, 35, 35),
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 0.02,
		Visible = false,
		Parent = library.base
	})


	local searchBar = library:Create("TextBox", {
		ZIndex = 11,
		Position = UDim2.new(0, 10, 0, 5),
		Size = UDim2.new(1, -20, 0, 25),
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(25, 25, 25),
		Text = "",
		PlaceholderText = "Search...",
		PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 16,
		Font = Enum.Font.SourceSans,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = option.mainHolder
	})
	
	local separator = library:Create("Frame", {
		ZIndex = 11,
		Position = UDim2.new(0, 5, 0, 35),
		Size = UDim2.new(1, -10, 0, 1),
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		BorderSizePixel = 0,
		Parent = option.mainHolder
	})

	local content = library:Create("ScrollingFrame", {
		ZIndex = 11,
		Position = UDim2.new(0, 0, 0, 40),
		Size = UDim2.new(1, 0, 1, -45),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80),
		ScrollBarThickness = 4,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = option.mainHolder
	})
	
	library:Create("UIPadding", {
		PaddingTop = UDim.new(0, 2),
		PaddingLeft = UDim.new(0, 5),
		PaddingRight = UDim.new(0, 5),
		Parent = content
	})
	
	local layout = library:Create("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2),
		Parent = content
	})
	
	local function updateSize()
		local contentHeight = layout.AbsoluteContentSize.Y
		local totalHeight = math.clamp(contentHeight + 45, 50, 200)
		option.mainHolder.Size = UDim2.new(0, 240, 0, totalHeight)
		content.CanvasSize = UDim2.new(0, 0, 0, contentHeight + 5)
	end
	
	layout.Changed:connect(updateSize)

	function option:RefreshList(searchText)
		searchText = searchText and string.lower(searchText) or ""
		
		for _, item in ipairs(content:GetChildren()) do
			if item:IsA("TextButton") then item:Destroy() end
		end
		
		valueCount = 0
		for _, value in ipairs(option.values) do
			local strValue = tostring(value)
			if searchText == "" or string.find(string.lower(strValue), searchText) then
				valueCount = valueCount + 1
				
				local isSelected = false
				if option.multiselect then
					isSelected = option.value[strValue] == true
				else
					isSelected = (option.value == strValue)
				end
				
				local itemBtn = library:Create("TextButton", {
					ZIndex = 12,
					Size = UDim2.new(1, 0, 0, 25),
					BackgroundTransparency = isSelected and 0.5 or 1,
					BackgroundColor3 = Color3.fromRGB(60, 60, 60),
					BorderSizePixel = 0,
					Text = "  " .. strValue,
					TextSize = 14,
					Font = isSelected and Enum.Font.SourceSansBold or Enum.Font.SourceSans,
					TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200),
					TextXAlignment = Enum.TextXAlignment.Left,
					AutoButtonColor = false,
					Parent = content
				})
				
				if option.multiselect and isSelected then
					library:Create("ImageLabel", {
						Position = UDim2.new(1, -25, 0.5, -6),
						Size = UDim2.new(0, 12, 0, 12),
						BackgroundTransparency = 1,
						Image = "rbxassetid://4919148038",
						ImageColor3 = Color3.fromRGB(255, 255, 255),
						Parent = itemBtn
					})
				end
				
				library:Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = itemBtn})

				itemBtn.MouseEnter:Connect(function()
					if (option.multiselect and not option.value[strValue]) or (not option.multiselect and option.value ~= strValue) then
						tweenService:Create(itemBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
					end
				end)
				
				itemBtn.MouseLeave:Connect(function()
					if (option.multiselect and not option.value[strValue]) or (not option.multiselect and option.value ~= strValue) then
						tweenService:Create(itemBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
					end
				end)

				itemBtn.MouseButton1Click:Connect(function()
					if option.multiselect then
						local newValue = option.value
						if newValue[strValue] then
							newValue[strValue] = nil
						else
							newValue[strValue] = true
						end
						option:SetValue(newValue)
						option:RefreshList(searchBar.Text)
					else
						option:SetValue(strValue)
						option:Close()
					end
				end)
			end
		end
		updateSize()
	end

	searchBar:GetPropertyChangedSignal("Text"):Connect(function()
		option:RefreshList(searchBar.Text)
	end)


	local inContact
	
	round.InputBegan:connect(function(input)
		if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
			if library.activePopup and library.activePopup ~= option then
				library.activePopup:Close()
			end
			
			if option.open then
				option:Close()
				return
			end

			local position = main.AbsolutePosition
			local mainSize = main.AbsoluteSize 
			
			
			option.mainHolder.Position = UDim2.new(0, position.X + mainSize.X + 5, 0, position.Y)
			
			option.open = true
			option.mainHolder.Visible = true
			
			searchBar.Text = ""
			option:RefreshList("") 
			
			
			option.mainHolder.ImageTransparency = 1
			tweenService:Create(option.mainHolder, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
			
			
			tweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
			tweenService:Create(round, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(60, 60, 60)}):Play()

			wait() 
			library.activePopup = option
		end
		
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = true
			if not option.open then
				tweenService:Create(round, TweenInfo.new(0.1), {ImageColor3 = Color3.fromRGB(50, 50, 50)}):Play()
			end
		end
	end)
	
	round.InputEnded:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			inContact = false
			if not option.open then
				tweenService:Create(round, TweenInfo.new(0.1), {ImageColor3 = Color3.fromRGB(40, 40, 40)}):Play()
			end
		end
	end)
	
	function option:SetValue(value)
		if option.multiselect then
			library.flags[self.flag] = value
			self.value = value
			
			local displayTable = {}
			for _, v in ipairs(option.values) do
				if value[tostring(v)] then
					table.insert(displayTable, tostring(v))
				end
			end
			
			local displayText = table.concat(displayTable, ", ")
			if displayText == "" then displayText = "None" end
			
			listvalue.Text = displayText
			self.callback(value)
		else
			library.flags[self.flag] = tostring(value)
			self.value = tostring(value)
			listvalue.Text = self.value
			self.callback(value)
		end
	end
	
	function option:Close()
		library.activePopup = nil
		self.open = false
		
		tweenService:Create(self.mainHolder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
		
		
		tweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = -90}):Play()
		tweenService:Create(round, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(40, 40, 40)}):Play()

		delay(0.2, function()
			if not self.open then
				self.mainHolder.Visible = false
			end
		end)
	end
    
    if option.multiselect then
        option:SetValue(option.value)
    else
        if not table.find(option.values, option.value) and #option.values > 0 then
             option:SetValue(option.values[1])
        else
             option:SetValue(option.value)
        end
    end

	return option
end

local function createInput(option, parent)
    
    option.placeholder = option.placeholder or "Type here..."
    option.numeric = option.numeric or false
    
    local main = library:Create("Frame", {
        LayoutOrder = option.position,
        Size = UDim2.new(1, 0, 0, 60), 
        BackgroundTransparency = 1,
        Parent = parent.content
    })

    
    local title = library:Create("TextLabel", {
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 0, 20),
        BackgroundTransparency = 1,
        Text = option.text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = main
    })

    
    local inputBox = library:Create("Frame", {
        Position = UDim2.new(0, 10, 0, 25),
        Size = UDim2.new(1, -20, 0, 30),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Parent = main
    })

    library:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = inputBox
    })

    local stroke = library:Create("UIStroke", {
        Color = Color3.fromRGB(60, 60, 60),
        Thickness = 1,
        Transparency = 0,
        Parent = inputBox
    })

    
    local inputvalue = library:Create("TextBox", {
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = option.value,
        PlaceholderText = option.placeholder,
        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        ClipsDescendants = true,
        ClearTextOnFocus = false,
        Parent = inputBox
    })

    
    local icon = library:Create("ImageLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7072719277", 
        ImageColor3 = Color3.fromRGB(100, 100, 100),
        Parent = inputBox
    })

    local focused = false

    
    inputvalue.Focused:Connect(function()
        focused = true
        tweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        tweenService:Create(inputBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        tweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    
    inputvalue.FocusLost:Connect(function(enter)
        focused = false
        tweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 60)}):Play()
        tweenService:Create(inputBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
        tweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(100, 100, 100)}):Play()
        
        
        if option.numeric then
            local num = tonumber(inputvalue.Text)
            if not num then
                inputvalue.Text = option.value 
            else
                option:SetValue(inputvalue.Text, enter)
            end
        else
            option:SetValue(inputvalue.Text, enter)
        end
    end)
    
    
    inputvalue:GetPropertyChangedSignal("Text"):Connect(function()
        if option.numeric then
            inputvalue.Text = inputvalue.Text:gsub("[^0-9%.%-]", "")
        end
    end)

    function option:SetValue(value, enter)
        library.flags[self.flag] = tostring(value)
        self.value = tostring(value)
        inputvalue.Text = self.value
        self.callback(value, enter)
    end
end

local function createColorPickerWindow(option)
    option.mainHolder = library:Create("ImageButton", {
        ZIndex = 3,
        Size = UDim2.new(0, 240, 0, 180),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ImageTransparency = 1,
        ImageColor3 = Color3.fromRGB(30, 30, 30),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.02,
        Parent = library.base
    })
    local hue, sat, val = Color3.toHSV(option.color)
    hue, sat, val = hue == 0 and 1 or hue, sat + 0.005, val - 0.005
    local editinghue
    local editingsatval
    local currentColor = option.color
    local previousColors = {[1] = option.color}
    local originalColor = option.color
    local rainbowEnabled
    local rainbowLoop
    function option:updateVisuals(Color)
        currentColor = Color
        self.visualize2.ImageColor3 = Color
        hue, sat, val = Color3.toHSV(Color)
        hue = hue == 0 and 1 or hue
        self.satval.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        self.hueSlider.Position = UDim2.new(1 - hue, 0, 0, 0)
        self.satvalSlider.Position = UDim2.new(sat, 0, 1 - val, 0)
    end
    option.hue = library:Create("ImageLabel", {
        ZIndex = 3,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 8, 1, -8),
        Size = UDim2.new(1, -100, 0, 22),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.02,
        Parent = option.mainHolder
    })
    local Gradient = library:Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.157, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(0.323, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.488, Color3.fromRGB(0, 255, 255)),            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.817, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
        }),
        Parent = option.hue
    })
    option.hueSlider = library:Create("Frame", {
        ZIndex = 3,
        Position = UDim2.new(1 - hue, 0, 0, 0),
        Size = UDim2.new(0, 2, 1, 0),
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderColor3 = Color3.fromRGB(255, 255, 255),
        Parent = option.hue
    })
    option.hue.InputBegan:connect(function(Input)
        if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
            editinghue = true
            local X = (Input.Position.X - option.hue.AbsolutePosition.X) / option.hue.AbsoluteSize.X
            X = math.clamp(X, 0, 0.995)
            option:updateVisuals(Color3.fromHSV(1 - X, sat, val))
        end
    end)
    inputService.InputChanged:connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and editinghue then
            local X = (Input.Position.X - option.hue.AbsolutePosition.X) / option.hue.AbsoluteSize.X
            X = math.clamp(X, 0, 0.995)
            option:updateVisuals(Color3.fromHSV(1 - X, sat, val))
        end
    end)
    option.hue.InputEnded:connect(function(Input)
        if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
            editinghue = false
        end
    end)
    option.satval = library:Create("ImageLabel", {
        ZIndex = 3,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(1, -100, 1, -42),
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
        BorderSizePixel = 0,
        Image = "rbxassetid://4155801252",
        ImageTransparency = 1,
        ClipsDescendants = true,
        Parent = option.mainHolder
    })
    option.satvalSlider = library:Create("Frame", {
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5),        Position = UDim2.new(sat, 0, 1 - val, 0),
        Size = UDim2.new(0, 4, 0, 4),
        Rotation = 45,
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Parent = option.satval
    })
    option.satval.InputBegan:connect(function(Input)
        if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
            editingsatval = true
            local X = (Input.Position.X - option.satval.AbsolutePosition.X) / option.satval.AbsoluteSize.X
            local Y = (Input.Position.Y - option.satval.AbsolutePosition.Y) / option.satval.AbsoluteSize.Y
            X = math.clamp(X, 0.005, 1)
            Y = math.clamp(Y, 0, 0.995)
            option:updateVisuals(Color3.fromHSV(hue, X, 1 - Y))
        end
    end)
    inputService.InputChanged:connect(function(Input)
        if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) and editingsatval then
            local X = (Input.Position.X - option.satval.AbsolutePosition.X) / option.satval.AbsoluteSize.X
            local Y = (Input.Position.Y - option.satval.AbsolutePosition.Y) / option.satval.AbsoluteSize.Y
            X = math.clamp(X, 0.005, 1)
            Y = math.clamp(Y, 0, 0.995)
            option:updateVisuals(Color3.fromHSV(hue, X, 1 - Y))
        end
    end)
    option.satval.InputEnded:connect(function(Input)
        if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
            editingsatval = false
        end
    end)
    option.visualize2 = library:Create("ImageLabel", {
        ZIndex = 3,
        Position = UDim2.new(1, -8, 0, 8),
        Size = UDim2.new(0, -80, 0, 80),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ImageColor3 = currentColor,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.02,
        Parent = option.mainHolder
    })
    option.resetColor = library:Create("ImageLabel", {
        ZIndex = 3,
        Position = UDim2.new(1, -8, 0, 92),
        Size = UDim2.new(0, -80, 0, 18),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ImageTransparency = 1,        ImageColor3 = Color3.fromRGB(20, 20, 20),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.02,
        Parent = option.mainHolder
    })
    option.resetText = library:Create("TextLabel", {
        ZIndex = 3,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "Reset",
        TextTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 15,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Parent = option.resetColor
    })
    option.resetColor.InputBegan:connect(function(Input)
        if (Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch) and not rainbowEnabled then
            previousColors = {originalColor}
            option:SetColor(originalColor)
        end
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            tweenService:Create(option.resetColor, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(10, 10, 10)}):Play()
        end
    end)
    option.resetColor.InputEnded:connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            tweenService:Create(option.resetColor, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end
    end)
    option.undoColor = library:Create("ImageLabel", {
        ZIndex = 3,
        Position = UDim2.new(1, -8, 0, 112),
        Size = UDim2.new(0, -80, 0, 18),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ImageTransparency = 1,
        ImageColor3 = Color3.fromRGB(20, 20, 20),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.02,
        Parent = option.mainHolder
    })
    option.undoText = library:Create("TextLabel", {
        ZIndex = 3,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "Undo",
        TextTransparency = 1,        Font = Enum.Font.Gotham,
        TextSize = 15,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Parent = option.undoColor
    })
    option.undoColor.InputBegan:connect(function(Input)
        if (Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch) and not rainbowEnabled then
            local Num = #previousColors == 1 and 0 or 1
            option:SetColor(previousColors[#previousColors - Num])
            if #previousColors ~= 1 then
                table.remove(previousColors, #previousColors)
            end
        end
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            tweenService:Create(option.undoColor, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(10, 10, 10)}):Play()
        end
    end)
    option.undoColor.InputEnded:connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            tweenService:Create(option.undoColor, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end
    end)
    option.setColor = library:Create("ImageLabel", {
        ZIndex = 3,
        Position = UDim2.new(1, -8, 0, 132),
        Size = UDim2.new(0, -80, 0, 18),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ImageTransparency = 1,
        ImageColor3 = Color3.fromRGB(20, 20, 20),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.02,
        Parent = option.mainHolder
    })
    option.setText = library:Create("TextLabel", {
        ZIndex = 3,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "Set",
        TextTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 15,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Parent = option.setColor
    })
    option.setColor.InputBegan:connect(function(Input)
        if (Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch) and not rainbowEnabled then
            table.insert(previousColors, currentColor)
            option:SetColor(currentColor)        end
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            tweenService:Create(option.setColor, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(10, 10, 10)}):Play()
        end
    end)
    option.setColor.InputEnded:connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            tweenService:Create(option.setColor, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end
    end)
    option.rainbow = library:Create("ImageLabel", {
        ZIndex = 3,
        Position = UDim2.new(1, -8, 0, 152),
        Size = UDim2.new(0, -80, 0, 18),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ImageTransparency = 1,
        ImageColor3 = Color3.fromRGB(20, 20, 20),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.02,
        Parent = option.mainHolder
    })
    option.rainbowText = library:Create("TextLabel", {
        ZIndex = 3,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "Rainbow",
        TextTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 15,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Parent = option.rainbow
    })
    option.rainbow.InputBegan:connect(function(Input)
        if Input.UserInputType == ui or Input.UserInputType == Enum.UserInputType.Touch then
            rainbowEnabled = not rainbowEnabled
            if rainbowEnabled then
                if rainbowLoop then rainbowLoop:Disconnect() end
                rainbowLoop = runService.Heartbeat:connect(function()
                    option:SetColor(chromaColor)
                    option.rainbowText.TextColor3 = chromaColor
                end)
            else
                if rainbowLoop then rainbowLoop:Disconnect() end
                option:SetColor(previousColors[#previousColors])
                option.rainbowText.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then            tweenService:Create(option.rainbow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(10, 10, 10)}):Play()
        end
    end)
    option.rainbow.InputEnded:connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            tweenService:Create(option.rainbow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end
    end)
    return option
end

local function createColor(option, parent, holder)
    option.main = library:Create("TextLabel", {
        LayoutOrder = option.position,
        Size = UDim2.new(1, 0, 0, 31),
        BackgroundTransparency = 1,
        Text = " " .. option.text,
        TextSize = 17,
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = parent.content
    })
    local colorBoxOutline = library:Create("ImageLabel", {
        Position = UDim2.new(1, -6, 0, 4),
        Size = UDim2.new(-1, 10, 1, -10),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ImageColor3 = Color3.fromRGB(100, 100, 100),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.02,
        Parent = option.main
    })
    option.visualize = library:Create("ImageLabel", {
        Position = UDim2.new(0, 2, 0, 2),
        Size = UDim2.new(1, -4, 1, -4),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ImageColor3 = option.color,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.02,
        Parent = colorBoxOutline
    })
    local inContact
    option.main.InputBegan:connect(function(input)
        if input.UserInputType == ui or input.UserInputType == Enum.UserInputType.Touch then
            if not option.mainHolder then createColorPickerWindow(option) end            if library.activePopup then
                library.activePopup:Close()
            end
            local position = option.main.AbsolutePosition
            option.mainHolder.Position = UDim2.new(0, position.X - 5, 0, position.Y - 10)
            option.open = true
            option.mainHolder.Visible = true
            library.activePopup = option
            tweenService:Create(option.mainHolder, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0, Position = UDim2.new(0, position.X - 5, 0, position.Y - 4)}):Play()
            tweenService:Create(option.mainHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.1), {Position = UDim2.new(0, position.X - 5, 0, position.Y + 1)}):Play()
            tweenService:Create(option.satval, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            for _,object in next, option.mainHolder:GetDescendants() do
                if object:IsA"TextLabel" then
                    tweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                elseif object:IsA"ImageLabel" then
                    tweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                elseif object:IsA"Frame" then
                    tweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                end
            end
        end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            inContact = true
            if not option.open then
                tweenService:Create(colorBoxOutline, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(140, 140, 140)}):Play()
            end
        end
    end)
    option.main.InputEnded:connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            inContact = true
            if not option.open then
                tweenService:Create(colorBoxOutline, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(100, 100, 100)}):Play()
            end
        end
    end)
    function option:SetColor(newColor)
        if self.mainHolder then
            self:updateVisuals(newColor)
        end
        self.visualize.ImageColor3 = newColor
        library.flags[self.flag] = newColor
        self.color = newColor
        self.callback(newColor)
    end
    function option:Close()
        library.activePopup = nil
        self.open = false
        local position = self.main.AbsolutePosition
        tweenService:Create(self.mainHolder, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1, Position = UDim2.new(0, position.X - 5, 0, position.Y - 10)}):Play()        tweenService:Create(self.satval, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        for _,object in next, self.mainHolder:GetDescendants() do
            if object:IsA"TextLabel" then
                tweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
            elseif object:IsA"ImageLabel" then
                tweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
            elseif object:IsA"Frame" then
                tweenService:Create(object, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
            end
        end
        delay(0.3, function()
            if not self.open then
                self.mainHolder.Visible = false
            end 
        end)
    end
end

local function loadOptions(option, holder)
	for _,newOption in next, option.options do
		if newOption.type == "label" then
			createLabel(newOption, option)
		elseif newOption.type == "toggle" then
			createToggle(newOption, option)
		elseif newOption.type == "button" then
			createButton(newOption, option)
		elseif newOption.type == "list" then
			createList(newOption, option, holder)
		elseif newOption.type == "input" then
			createInput(newOption, option)
		elseif newOption.type == "bind" then
			createBind(newOption, option)
		elseif newOption.type == "slider" then
			createSlider(newOption, option)
		elseif newOption.type == "color" then
			createColor(newOption, option, holder)
		elseif newOption.type == "folder" then
			newOption:init()
		end
	end
end

local function getFnctions(parent)
	function parent:AddLabel(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.type = "label"
		option.position = #self.options
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddToggle(option)
    option = typeof(option) == "table" and option or {}
    option.text = tostring(option.text)
    option.state = typeof(option.state) == "boolean" and option.state or false
    
    option.onColor = option.onColor or nil 
    option.callback = typeof(option.callback) == "function" and option.callback or function() end
    option.type = "toggle"
    option.position = #self.options
    option.flag = option.flag or option.text
    library.flags[option.flag] = option.state
    table.insert(self.options, option)
    
    return option
end
	
	function parent:AddButton(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
        option.icon = option.icon or nil 
        option.active = true 
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "button"
		option.position = #self.options
		option.flag = option.flag or option.text
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddBind(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.key = (option.key and option.key.Name) or option.key or "F"
		option.hold = typeof(option.hold) == "boolean" and option.hold or false
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "bind"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.key
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddSlider(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.min = typeof(option.min) == "number" and option.min or 0
		option.max = typeof(option.max) == "number" and option.max or 0
		option.dual = typeof(option.dual) == "boolean" and option.dual or false
		option.value = math.clamp(typeof(option.value) == "number" and option.value or option.min, option.min, option.max)
		option.value2 = typeof(option.value2) == "number" and option.value2 or option.max
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.float = typeof(option.value) == "number" and option.float or 1
		option.type = "slider"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.value
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddList(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.values = typeof(option.values) == "table" and option.values or {}
		option.value = tostring(option.value or option.values[1] or "")
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.open = false
		option.type = "list"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.value
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddInput(option) 
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.value = tostring(option.value or "")
        option.placeholder = option.placeholder or "Input here..." 
        option.numeric = typeof(option.numeric) == "boolean" and option.numeric or false 
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.type = "input" 
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.value
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddColor(option)
		option = typeof(option) == "table" and option or {}
		option.text = tostring(option.text)
		option.color = typeof(option.color) == "table" and Color3.new(tonumber(option.color[1]), tonumber(option.color[2]), tonumber(option.color[3])) or option.color or Color3.new(255, 255, 255)
		option.callback = typeof(option.callback) == "function" and option.callback or function() end
		option.open = false
		option.type = "color"
		option.position = #self.options
		option.flag = option.flag or option.text
		library.flags[option.flag] = option.color
		table.insert(self.options, option)
		
		return option
	end
	
	function parent:AddFolder(title)
		local option = {}
		option.title = tostring(title)
		option.options = {}
		option.open = false
		option.type = "folder"
		option.position = #self.options
		table.insert(self.options, option)
		
		getFnctions(option)
		
		function option:init()
			createOptionHolder(self.title, parent.content, self, true)
			loadOptions(self, parent)
		end
		
		return option
	end
end

function library:CreateWindow(title)
	local window = {title = tostring(title), options = {}, open = true, canInit = true, init = false, position = #self.windows}
	getFnctions(window)
	
	table.insert(library.windows, window)
	
	return window
end

local UIToggle
function library:Init()
	self.base = self.base or self:Create("ScreenGui")
	if syn and syn.protect_gui then
		syn.protect_gui(self.base)
	elseif get_hidden_gui then
		get_hidden_gui(self.base)
	elseif gethui then
		gethui(self.base)
	else
		game:GetService"Players".LocalPlayer:Kick("Error: protect_gui function not found")
		return
	end
	self.base.Parent = game:GetService"CoreGui"
	self.base.ResetOnSpawn = true
	self.base.Name = "vuz"
	
	
	for _, window in next, self.windows do
		if window.canInit and not window.init then
			window.init = true
			createOptionHolder(window.title, self.base, window)
			loadOptions(window)
		end
	end
	return self.base
end

function library:Close()
	if typeof(self.base) ~= "Instance" then end
	self.open = not self.open
	if self.activePopup then
		self.activePopup:Close()
	end
	for _, window in next, self.windows do
		if window.main then
			window.main.Visible = self.open
		end
	end
end

inputService.InputBegan:connect(function(input)
	if input.UserInputType == ui then
		if library.activePopup then
			if input.Position.X < library.activePopup.mainHolder.AbsolutePosition.X or input.Position.Y < library.activePopup.mainHolder.AbsolutePosition.Y then
				library.activePopup:Close()
			end
		end
		if library.activePopup then
			if input.Position.X > library.activePopup.mainHolder.AbsolutePosition.X + library.activePopup.mainHolder.AbsoluteSize.X or input.Position.Y > library.activePopup.mainHolder.AbsolutePosition.Y + library.activePopup.mainHolder.AbsoluteSize.Y then
				library.activePopup:Close()
			end
		end
	elseif input.UserInputType == Enum.UserInputType.Touch then
		if library.activePopup then
			if input.Position.X < library.activePopup.mainHolder.AbsolutePosition.X or input.Position.Y < library.activePopup.mainHolder.AbsolutePosition.Y then
				library.activePopup:Close()
			end
		end
		if library.activePopup then
			if input.Position.X > library.activePopup.mainHolder.AbsolutePosition.X + library.activePopup.mainHolder.AbsoluteSize.X or input.Position.Y > library.activePopup.mainHolder.AbsolutePosition.Y + library.activePopup.mainHolder.AbsoluteSize.Y then
				library.activePopup:Close()
			end
		end
	end
end)

inputService.InputChanged:connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

wait(1)
local VirtualUser=game:service'VirtualUser'
game:service('Players').LocalPlayer.Idled:connect(function()
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end)



function library:Notify(config)
    
    if not library.base then
        warn("not found library:Init()")
        return
    end

    
    local notifyContainer = library.base:FindFirstChild("NotifyContainer")
    if not notifyContainer then
        notifyContainer = library:Create("Frame", {
            Name = "NotifyContainer",
            Position = UDim2.new(1, -20, 1, -20), 
            Size = UDim2.new(0, 300, 1, 0), 
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,
            Parent = library.base, 
            ClipsDescendants = false
        })

        library:Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 10), 
            Parent = notifyContainer
        })
    end

    
    config = typeof(config) == "table" and config or {}
    local titleText = config.title or "Notification"
    local descText = config.content or "test"
    local duration = config.duration or 5
    local image = config.image or "rbxassetid://3944703587" 

    
    local notifyFrame = library:Create("Frame", {
        Name = "NotifyFrame",
        Size = UDim2.new(1, 0, 0, 80), 
        BackgroundTransparency = 1, 
        BackgroundColor3 = Color3.fromRGB(15, 15, 15), 
        Parent = notifyContainer,
        ClipsDescendants = true,
        LayoutOrder = tick() 
    })
    
    
    library:Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = notifyFrame
    })
    
    
    local stroke = library:Create("UIStroke", {
        Color = Color3.fromRGB(60, 60, 60), 
        Thickness = 1,
        Transparency = 1, 
        Parent = notifyFrame
    })

    
    local icon = library:Create("ImageLabel", {
        Name = "Icon",
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(0, 24, 0, 24),
        BackgroundTransparency = 1,
        Image = image,
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 1,
        Parent = notifyFrame
    })

    
    local titleLabel = library:Create("TextLabel", {
        Name = "Title",
        Position = UDim2.new(0, 50, 0, 15),
        Size = UDim2.new(1, -60, 0, 24),
        BackgroundTransparency = 1,
        Text = titleText,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 1,
        Parent = notifyFrame
    })

    
    local descLabel = library:Create("TextLabel", {
        Name = "Description",
        Position = UDim2.new(0, 50, 0, 42),
        Size = UDim2.new(1, -60, 0, 30),
        BackgroundTransparency = 1,
        Text = descText,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.fromRGB(180, 180, 180), 
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        TextTransparency = 1,
        Parent = notifyFrame
    })

    
    local progressBar = library:Create("Frame", {
        Name = "Timer",
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(0, 0, 0, 2), 
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), 
        BorderSizePixel = 0,
        Parent = notifyFrame
    })

    local closeBtn = library:Create("ImageButton", {
        Position = UDim2.new(1, -25, 0, 15),
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://127981991568413",
        ImageColor3 = Color3.fromRGB(150, 150, 150),
        ImageTransparency = 1,
        Parent = notifyFrame
    })

    
    tweenService:Create(notifyFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    tweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    
        
    delay(0.1, function()
        tweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        tweenService:Create(descLabel, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        tweenService:Create(icon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
        tweenService:Create(closeBtn, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
    end)

    
    tweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 2)}):Play()

    
    local closed = false
    local function closeNotify()
        if closed then return end
        closed = true
        
        
        tweenService:Create(notifyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 50, 0, 0) 
        }):Play()
        tweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        tweenService:Create(titleLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        tweenService:Create(descLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        tweenService:Create(icon, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
        tweenService:Create(closeBtn, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
        tweenService:Create(progressBar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()

        
        delay(0.4, function()
            notifyFrame:Destroy()
        end)
    end

    
    delay(duration, closeNotify)

    
    closeBtn.MouseButton1Click:Connect(closeNotify)
    closeBtn.MouseEnter:Connect(function()
        tweenService:Create(closeBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        tweenService:Create(closeBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
    end)
end

return library
