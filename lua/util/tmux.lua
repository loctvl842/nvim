---@class util.tmux
local M = {}

--- Get list of tmux sessions
---@return table List of tmux sessions with name and info
function M.get_sessions()
  local sessions = {}

  -- Check if tmux is available
  vim.fn.system("which tmux")
  if vim.v.shell_error ~= 0 then
    vim.notify("tmux is not available", vim.log.levels.ERROR)
    return sessions
  end

  -- Get tmux sessions with pane count
  local output = vim.fn.system(
    "tmux list-sessions -F '#{session_name}:#{session_windows}:#{session_attached}:#{session_created}:#{session_many_attached}'"
  )

  if vim.v.shell_error ~= 0 then
    -- No sessions or tmux server not running
    return sessions
  end

  for line in output:gmatch("[^\r\n]+") do
    local name, windows, attached, created, many_attached = line:match("([^:]+):([^:]+):([^:]+):([^:]+):([^:]*)")
    if name then
      -- Get pane count for this session
      local pane_cmd = string.format("tmux list-panes -s '%s' | wc -l", name)
      local pane_output = vim.fn.system(pane_cmd)
      local pane_count = tonumber(pane_output:gsub("%s+", "")) or 0

      local attached_status = attached == "1" and "●" or "○"
      local display_name = string.format("%s %s (%s windows)", attached_status, name, windows)

      table.insert(sessions, {
        name = name,
        display = display_name,
        windows = tonumber(windows) or 0,
        attached = attached == "1",
        created = created,
        pane_count = pane_count,
        many_attached = many_attached == "1",
        -- Make it compatible with Snacks picker format
        text = display_name,
        file = name, -- Use name as the identifier
      })
    end
  end

  return sessions
end

--- Switch to tmux session
---@param session_name string The name of the session to switch to
function M.switch_session(session_name)
  if not session_name then
    vim.notify("No session name provided", vim.log.levels.ERROR)
    return
  end

  -- Check if we're inside tmux
  local tmux_env = os.getenv("TMUX")

  if tmux_env then
    -- We're inside tmux, switch session
    local cmd = string.format("tmux switch-client -t '%s'", session_name)
    local result = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
      vim.notify(string.format("Failed to switch to session '%s': %s", session_name, result), vim.log.levels.ERROR)
    else
      vim.notify(string.format("Switched to tmux session: %s", session_name), vim.log.levels.INFO)
    end
  else
    -- We're not inside tmux, attach to session
    vim.notify("Not inside tmux. Use 'tmux attach-session -t " .. session_name .. "' to attach.", vim.log.levels.WARN)
  end
end

--- Format session details for preview
---@param session table Session data
---@return string[] Preview lines
local function format_session_preview(session)
  local lines = {}

  -- Header
  table.insert(lines, "┌─ Tmux Session Details ─┐")
  table.insert(lines, "")

  -- Session name
  table.insert(lines, string.format("Session: %s", session.name))

  -- Attachment status
  local status_text = session.attached and "Currently Attached" or "Not Attached"
  local status_icon = session.attached and "●" or "○"
  table.insert(lines, string.format("Status:  %s %s", status_icon, status_text))

  if session.many_attached then
    table.insert(lines, "         (Multiple clients attached)")
  end

  table.insert(lines, "")

  -- Windows and panes
  table.insert(lines, string.format("Windows: %d", session.windows))
  table.insert(lines, string.format("Panes:   %d", session.pane_count))

  table.insert(lines, "")

  -- Creation time
  if session.created and session.created ~= "" then
    -- Convert Unix timestamp to readable format
    local created_time = tonumber(session.created)
    if created_time then
      local date_str = os.date("%Y-%m-%d %H:%M:%S", created_time)
      table.insert(lines, string.format("Created: %s", date_str))
    else
      table.insert(lines, string.format("Created: %s", session.created))
    end
  end

  table.insert(lines, "")
  table.insert(lines, "└─────────────────────────┘")

  -- Add some spacing
  for _ = 1, 5 do
    table.insert(lines, "")
  end

  return lines
end

--- Custom format function for tmux session picker
---@param item table The item to format
---@return snacks.picker.Highlight[] Array of highlight elements
local function tmux_session_format(item)
  local ret = {} ---@type snacks.picker.Highlight[]
  local session = item.session

  -- Status indicator with appropriate highlight
  local status_icon = session.attached and "●" or "○"
  local status_hl = session.attached and "SnacksPickerIconOn" or "SnacksPickerIconOff"
  ret[#ret + 1] = { status_icon, status_hl }
  ret[#ret + 1] = { " " }

  -- Session name (main text)
  ret[#ret + 1] = { session.name, "SnacksPickerTitle" }
  ret[#ret + 1] = { " " }

  -- Windows count
  ret[#ret + 1] = { tostring(session.windows), "SnacksPickerCount" }
  ret[#ret + 1] = { "w", "SnacksPickerIcon" }
  ret[#ret + 1] = { " " }

  -- Panes count
  ret[#ret + 1] = { tostring(session.pane_count), "SnacksPickerCount" }
  ret[#ret + 1] = { "p", "SnacksPickerIcon" }

  -- Add multiple clients indicator if applicable
  if session.many_attached then
    ret[#ret + 1] = { " " }
    ret[#ret + 1] = { "⚡", "SnacksPickerSpecial" }
  end

  return ret
end

--- Create tmux session picker using Snacks.nvim
---@param filter_attached? boolean|nil Filter to show only attached (true), unattached (false), or all (nil)
function M.pick_session(filter_attached)
  local all_sessions = M.get_sessions()

  if #all_sessions == 0 then
    vim.notify("No tmux sessions found", vim.log.levels.WARN)
    return
  end

  -- Apply filtering if specified
  local sessions = {}
  if filter_attached == nil then
    sessions = all_sessions
  else
    for _, session in ipairs(all_sessions) do
      if session.attached == filter_attached then
        table.insert(sessions, session)
      end
    end
  end

  if #sessions == 0 then
    local filter_msg = filter_attached and "attached" or "unattached"
    vim.notify(string.format("No %s tmux sessions found", filter_msg), vim.log.levels.WARN)
    return
  end

  -- Get default layout from picker utility
  local picker_util = require("util.picker")
  local default_layout = picker_util.layout.default

  -- Transform sessions to the format expected by Snacks picker
  local items = {}
  for _, session in ipairs(sessions) do
    table.insert(items, {
      text = session.display, -- Fallback for non-custom format
      file = session.name, -- This might be used by preview system
      path = session.name, -- Alternative field name
      session = session, -- Keep full session data for actions
    })
  end

  -- Create custom picker for tmux sessions using the correct API
  Snacks.picker.pick({
    items = items,
    layout = default_layout,
    format = tmux_session_format,
    preview = function(ctx)
      local session = ctx.item.session
      if not session then
        ctx.preview:notify("No session data available", "warn")
        return false
      end

      ctx.preview:reset()
      local lines = format_session_preview(session)

      ctx.preview:set_lines(lines)

      return true
    end,
    confirm = function(picker, item)
      if item and item.session then
        picker:close()
        M.switch_session(item.session.name)
      end
    end,
    actions = {
      -- Add toggle actions for filtering
      ["ctrl-a"] = function(_, picker_ctx)
        -- Toggle to show only attached sessions
        picker_ctx.picker:close()
        M.pick_session(true)
      end,
      ["ctrl-u"] = function(_, picker_ctx)
        -- Toggle to show only unattached sessions
        picker_ctx.picker:close()
        M.pick_session(false)
      end,
      ["ctrl-r"] = function(_, picker_ctx)
        -- Reset to show all sessions
        picker_ctx.picker:close()
        M.pick_session(nil)
      end,
    },
  })
end

return M
