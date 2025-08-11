-- This module provides functionality to create a floating window in Neovim.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}
local function create_floating_window(opts)
  -- Default options: 75% of screen width and height, centered
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.75)
  local height = opts.height or math.floor(vim.o.lines * 0.75)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create a new buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf -- Use existing buffer if valid
  else
    buf = vim.api.nvim_create_buf(false, true) -- Not listed, scratch buffer
  end

  -- Window configuration
  local win_opts = {
    relative = 'editor', -- Float relative to the editor
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal', -- Minimal style for clean look
    zindex = 50, -- Ensure it floats above other windows
    border = 'rounded', -- Rounded border for aesthetics
    title = 'Interm', -- Optional title
    title_pos = 'center', -- Center the title
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= 'terminal' then
      vim.cmd.terminal()
      vim.cmd 'startinsert'
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

-- Example usage:
-- Create a floating window with default size (75% of screen)
vim.api.nvim_create_user_command('Interm', toggle_terminal, {})
vim.keymap.set({ 'n', 't' }, '<leader>tt', toggle_terminal)

return {}
