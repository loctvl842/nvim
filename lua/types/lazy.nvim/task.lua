---@class TaskOptions: {[string]:any}
---@field on_done? fun(task:LazyTask)

---@class LazyTaskDef
---@field skip? fun(plugin:LazyPlugin, opts?:TaskOptions):any?
---@field run fun(task:LazyTask, opts:TaskOptions)

---@alias LazyTaskState fun():boolean?

---@class LazyTask
---@field plugin LazyPlugin
---@field name string
---@field output string
---@field status string
---@field error? string
---@field private _task fun(task:LazyTask)
---@field private _running LazyPluginState[]
---@field private _started? number
---@field private _ended? number
---@field private _opts TaskOptions
