local M = {}
local uv = vim.uv

---@class ClaudeSession
---@field id string
---@field name string
---@field timestamp number
---@field git_branch string?
---@field message_count number?
---@field last_timestamp string?

local CLAUDE_PROJECTS_DIR = os.getenv("HOME") .. "/.claude/projects/"

---Convert a project path to Claude CLI's directory naming convention
---@param root_dir string The project root directory path
---@return string The Claude project directory name
local function get_claude_project_dir_name(root_dir)
  -- Replace '/' with '-' and remove leading slash to avoid double dash at start
  local project_path_slug = root_dir:gsub("^/", ""):gsub("/", "-"):gsub("%.", "-")
  return CLAUDE_PROJECTS_DIR .. "-" .. project_path_slug
end

---Read session metadata from a Claude JSONL session file
---@param file_path string Path to the session JSONL file
---@return table? Session metadata or nil if file cannot be read
local function read_session_metadata(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil
  end

  local metadata = {}
  local message_count = 0
  local last_timestamp = nil
  local git_branch = nil
  local first_session_message = nil

  for line in file:lines() do
    local ok, data = pcall(vim.json.decode, line)
    if ok and data then
      -- Get git branch from first occurrence
      if data.gitBranch and not git_branch then
        git_branch = data.gitBranch
      end

      -- Count non-sidechain user and assistant messages
      if (data.type == "user" or data.type == "assistant") and not data.isSidechain then
        message_count = message_count + 1
        if data.timestamp then
          last_timestamp = data.timestamp
        end
      end

      -- Find the first session-starting user message with precise criteria
      if
        not first_session_message
        and (data.parentUuid == nil or data.parentUuid == vim.NIL)
        and data.isSidechain == false
        and data.type == "user"
        and data.message
        and data.message.role == "user"
        and data.message.content
        and type(data.message.content) == "string"
      then
        first_session_message = data.message.content
      end

      -- Get session ID
      if data.sessionId and not metadata.session_id then
        metadata.session_id = data.sessionId
      end
    end
  end

  file:close()

  -- Only include sessions that have a first session message
  if not first_session_message or first_session_message == "" then
    return nil
  end

  -- Clean up and truncate the first user message for display
  local clean_message = tostring(first_session_message):gsub("\n", " "):gsub("%s+", " ")
  if #clean_message > 80 then
    metadata.title = clean_message:sub(1, 77) .. "..."
  else
    metadata.title = clean_message
  end

  metadata.git_branch = git_branch
  metadata.message_count = message_count
  metadata.last_timestamp = last_timestamp

  return metadata
end

---Retrieve a list of Claude sessions for the current project
---@param root_dir string The project root directory path
---@return ClaudeSession[] Array of session objects
function M.get_project_sessions(root_dir)
  local project_dir = get_claude_project_dir_name(root_dir)
  local sessions = {}

  local stat = uv.fs_stat(project_dir)
  if not stat or stat.type ~= "directory" then
    return sessions
  end

  local ok, dir_iter = pcall(vim.fs.dir, project_dir)
  if not ok then
    return sessions
  end

  for name, type in dir_iter do
    if type == "file" and name:match("%.jsonl$") then
      local session_id = name:match("^([^%.]+)")
      local file_path = project_dir .. "/" .. name
      local metadata = read_session_metadata(file_path)

      if metadata and metadata.title then
        local timestamp = nil

        -- Try to parse the actual last timestamp from the session
        local timestamp_str = metadata.last_timestamp
        if timestamp_str then
          local year, month, day, hour, min, sec = timestamp_str:match("(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)")
          if year then
            local year_num = tonumber(year)
            local month_num = tonumber(month)
            local day_num = tonumber(day)
            local hour_num = tonumber(hour)
            local min_num = tonumber(min)
            local sec_num = tonumber(sec)

            if year_num and month_num and day_num and hour_num and min_num and sec_num then
              -- The timestamp is in UTC, but os.time treats it as local time
              -- We need to convert from UTC to local time
              local utc_time = os.time({
                year = year_num,
                month = month_num,
                day = day_num,
                hour = hour_num,
                min = min_num,
                sec = sec_num,
              })

              -- Get the timezone offset in seconds
              local now = os.time()
              local utc_date = os.date("!*t", now) --[[@as osdate?]]
              local utc_now = utc_date and os.time(utc_date) or now
              local tz_offset = os.difftime(now, utc_now)

              -- Adjust the UTC timestamp to local time
              timestamp = utc_time + tz_offset
            end
          end
        end

        -- Only fall back to file mtime if we couldn't parse the session timestamp
        if not timestamp then
          local file_stat = uv.fs_stat(file_path)
          timestamp = file_stat and file_stat.mtime.sec or os.time()
        end

        table.insert(sessions, {
          id = session_id,
          name = metadata.title,
          timestamp = timestamp,
          git_branch = metadata.git_branch,
          message_count = metadata.message_count,
          last_timestamp = metadata.last_timestamp,
        })
      end
    end
  end

  table.sort(sessions, function(a, b)
    return a.timestamp > b.timestamp
  end)

  return sessions
end

---Calculate relative time string from timestamp
---@param timestamp number Unix timestamp
---@return string Relative time string like "2 hours ago"
local function get_relative_time(timestamp)
  local now = os.time()
  local diff = now - timestamp

  if diff < 60 then
    return "just now"
  elseif diff < 3600 then
    local minutes = math.floor(diff / 60)
    return minutes == 1 and "1 min ago" or minutes .. " mins ago"
  elseif diff < 86400 then
    local hours = math.floor(diff / 3600)
    return hours == 1 and "1 hour ago" or hours .. " hours ago"
  elseif diff < 604800 then
    local days = math.floor(diff / 86400)
    return days == 1 and "1 day ago" or days .. " days ago"
  elseif diff < 2629800 then
    local weeks = math.floor(diff / 604800)
    return weeks == 1 and "1 week ago" or weeks .. " weeks ago"
  else
    local months = math.floor(diff / 2629800)
    return months == 1 and "1 month ago" or months .. " months ago"
  end
end

---Open a picker to browse and resume Claude sessions for the current project
---Uses Snacks.nvim picker to display available Claude sessions with metadata preview
---When a session is selected, it launches Sidekick.nvim with Claude resuming that specific session
function M.session_picker()
  local root_dir = LazyVim.root.cwd()
  if not root_dir then
    vim.notify("Not inside a project. Cannot list Claude sessions.", vim.log.levels.WARN)
    return
  end

  local sessions = M.get_project_sessions(root_dir)

  if vim.tbl_isempty(sessions) then
    vim.notify("No Claude sessions found for this project.", vim.log.levels.INFO)
    return
  end

  local items = {}
  for i, session in ipairs(sessions) do
    local summary_preview = session.name
    if #summary_preview > 60 then
      summary_preview = summary_preview:sub(1, 57) .. "..."
    end

    ---@type snacks.picker.finder.Item
    local item = {
      text = summary_preview,
      name = summary_preview,
      id = session.id,
      idx = i,
      file = summary_preview,
      session = session,
      last_used = get_relative_time(session.timestamp),
    }
    table.insert(items, item)
  end

  ---@param ctx snacks.picker.preview.ctx
  local function claude_preview(ctx)
    local session = ctx.item.session
    if not session then
      ctx.preview:notify("No session data available", "warn")
      return false
    end

    ctx.preview:reset()
    local lines = {}

    table.insert(lines, "# " .. session.name)
    table.insert(lines, "")
    table.insert(lines, "**Session ID:** " .. session.id)

    if session.git_branch then
      table.insert(lines, "**Git Branch:** " .. session.git_branch)
    end

    if session.message_count then
      table.insert(lines, "**Messages:** " .. session.message_count)
    end

    if session.last_timestamp then
      local year, month, day, hour, min, sec = session.last_timestamp:match("(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)")
      if year then
        local year_num = tonumber(year)
        local month_num = tonumber(month)
        local day_num = tonumber(day)
        local hour_num = tonumber(hour)
        local min_num = tonumber(min)
        local sec_num = tonumber(sec)

        if year_num and month_num and day_num and hour_num and min_num and sec_num then
          local formatted_time = os.date(
            "%B %d, %Y at %I:%M %p",
            os.time({
              year = year_num,
              month = month_num,
              day = day_num,
              hour = hour_num,
              min = min_num,
              sec = sec_num,
            })
          )
          table.insert(lines, "**Last Activity:** " .. formatted_time)
        end
      end
    end

    table.insert(lines, "")
    table.insert(lines, "Press Enter to resume this session")

    ctx.preview:set_lines(lines)
    ctx.preview:highlight({ ft = "markdown" })

    return true
  end

  local picker_util = require("util.picker")
  local default_layout = picker_util.layout.default

  ---Custom format function for Claude sessions
  ---@param item snacks.picker.Item
  ---@return snacks.picker.Highlight[]
  local function claude_session_format(item)
    local ret = {} ---@type snacks.picker.Highlight[]
    local session = item.session

    if not session then
      return { { item.text or "Unknown Session", "Normal" } }
    end

    -- Last used time
    ret[#ret + 1] = { item.last_used, "SnacksPickerTime" }
    ret[#ret + 1] = { " " }

    -- Session name/summary (main text)
    ret[#ret + 1] = { item.name, "SnacksPickerTitle" }
    ret[#ret + 1] = { " " }

    -- Message count if available
    if session.message_count then
      ret[#ret + 1] = { tostring(session.message_count), "SnacksPickerCount" }
      ret[#ret + 1] = { " msgs", "SnacksPickerDesc" }
      ret[#ret + 1] = { " " }
    end

    -- Git branch if available
    if session.git_branch then
      ret[#ret + 1] = { "[", "SnacksPickerDelim" }
      ret[#ret + 1] = { session.git_branch, "SnacksPickerGitBranch" }
      ret[#ret + 1] = { "]", "SnacksPickerDelim" }
    end

    return ret
  end

  Snacks.picker.pick({
    items = items,
    layout = default_layout,
    win = { title = "Resume Claude Session" },
    format = claude_session_format,
    preview = claude_preview,
    confirm = function(picker, item)
      if not item or not item.id then
        vim.notify("No session selected", vim.log.levels.WARN)
        return
      end

      picker:close()

      -- Load required Sidekick modules
      local ok_config, Config = pcall(require, "sidekick.config")
      if not ok_config then
        vim.notify("Sidekick.nvim config not available", vim.log.levels.ERROR)
        return
      end

      local ok_state, State = pcall(require, "sidekick.cli.state")
      if not ok_state then
        vim.notify("Sidekick.nvim state module not available", vim.log.levels.ERROR)
        return
      end

      local ok_session, Session = pcall(require, "sidekick.cli.session")
      if not ok_session then
        vim.notify("Sidekick.nvim session module not available", vim.log.levels.ERROR)
        return
      end

      -- Ensure session backends are registered before creating sessions
      Session.setup()

      -- Create a custom Claude tool with the resume command
      local claude_tool = Config.get_tool("claude")
      local resume_tool = claude_tool:clone({
        cmd = vim.list_extend(vim.deepcopy(claude_tool.cmd), { "--resume", item.id }),
      })

      -- Create a new Sidekick session with the resume command
      -- The cwd is crucial for Claude to find the correct session files
      local resume_session = Session.new({
        tool = resume_tool,
        cwd = LazyVim.root.cwd(),
        id = "claude_resume_" .. item.id:gsub("-", "_"), -- Ensure valid session ID
      })

      -- Convert session to state and attach to launch the terminal
      local resume_state = State.get_state(resume_session)
      State.attach(resume_state, { show = true, focus = true })
    end,
  })
end

return M
