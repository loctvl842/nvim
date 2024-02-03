# How to Create a Component

A lualine component is a function that return a string.

To create a new component, follow these steps:
1. Open the `components.lua` file.
2. Add the following code snippet to the file:
```lua
M.<your_component_name> = function()
    return <content>
end
```
Replace `<your_component_name>` with the desired name for your component.
Replace `<content>` with the code or functionality you want your component to have.
