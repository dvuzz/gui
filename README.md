### library
```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/dvuzz/Lib/refs/heads/main/Source",true))()
```


### Adding Tab
```lua
local tab = library:CreateWindow("Your Title")
```



### Adding Folder
```lua
local folder = tab:AddFolder("Folder")
```



### Adding Button
```lua
folder:AddButton({
	text = "Click me",
	flag = "button",
	callback = function()
	print("hello world")
end
})
```




### Adding Toggle
```lua
folder:AddToggle({
	text = "Toggle",
	flag = "toggle",
	callback = function(v)
	print(v)
end
})
```




### Adding Label
```lua
folder:AddLabel({
	text = "This Is Sick!",
	type = "label"
	})

folder:AddLabel("Hello World")

folder:AddLabel({
    text = "Join Discord Server",
    icon = "rbxassetid://Image ID", 
    copyable = true,
    hoverColor = Color3.fromRGB(88, 101, 242) 
})

```





### Adding Slider
```lua
folder:AddSlider({
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
folder:AddInput({
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
folder:AddColor({
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
folder:AddList({
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
    image = "rbxassetid://Image ID" -- this line isn’t really necessary, you can remove it
})
```





### Adding Bind
```lua
folder:AddBind({
    text = "bind",
    key = "X",
    hold = false,
    callback = function()
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
