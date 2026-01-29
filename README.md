### library
```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dvuzz/Lib/refs/heads/main/Source",true))()
```


### Adding window
```lua
local window = library:CreateWindow("Your Title")
```



### Adding tab
```lua
local tab = window:AddFolder("Folder")
```

### Adding config
```lua
library:AddConfigTab(window)
```

### Adding Button
```lua
window:AddButton({
	text = "Click me",
	flag = "button",
	callback = function()
	print("hello world")
end
})
```




### Adding Toggle
```lua
window:AddToggle({
	text = "Toggle",
	flag = "toggle",
	callback = function(v)
	print(v)
end
})
```




### Adding Label
```lua
window:AddLabel({
	text = "This Is Sick!",
	type = "label"
	})

window:AddLabel("Hello World")

window:AddLabel({
    text = "link",
    icon = "rbxassetid://Image ID", 
    copyable = true,
    hoverColor = Color3.fromRGB(88, 101, 242) 
})

```

### Adding paragraph
```lua
window:AddParagraph({
    title = "test",
    content = "hello"
})
```



### Adding Slider
```lua
window:AddSlider({
	text = "Fov",
	min = 70,
	max = 170,
	dual = true,
	type = "slider",
	callback = function(v)
	print(v)
end
})
```





### Adding input
```lua
window:AddInput({
    text = "test",
    flag = "input",
    value = "",
    placeholder = "test",
    numeric = false,-- only allow number input if this is true
    callback = function(text)
        print("test", text)
    end
})
```





### Adding color
```lua
window:AddColor({
	text = "Color Picker",
	flag = "color",
	type = "color",
	callback = function(v)
	print(v)
end
})
```





### Adding Dropdown
```lua
window:AddList({
    text = "Color",
    values = {"Red", "Green", "Blue"},
    multiselect = false,-- true or false
    callback = function(value)
        print("Selected color:", value)
    end,
    open = false,
    flag = "color_option"
})
```





### Adding Notification
```lua
library:Notify({
    title = "test",
    content = "test",
    duration = 5,
})
```





### Adding Bind
```lua
window:AddBind({
    text = "bind",
    key = "X",
    hold = false,
    callback = function()
    end
})
```

### How to use the tooltip
```lua
window:AddToggle({
	text = "Toggle",
	tooltip = "hello hello hello hello",-- Add it here (only: toggle , button , slider, input)
	flag = "toggle",
	callback = function(v)
	print(v)
end
})
```

### Close Lib
```lua
library:Close()
```



### Final (REQUIRED OR THE UI WILL NOT SHOW)
```lua
library:Init()
```
### You must call library:Init() first, then you can call the watermark
```lua
library:Watermark({
    name = "test" 
})
```
### You must call library:Init() first, then you can call the keybindlist
```lua
library:KeybindList()
```
