vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt
opt.number = true
opt.relativenumber = false
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.wrap = false
opt.scrolloff = 6
opt.sidescrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 200
opt.timeoutlen = 350
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.completeopt = { "menuone", "noselect" }
opt.laststatus = 3
opt.pumblend = 8
opt.fillchars = { eob = " " }

-- Theme options: "dracula" | "catppuccin" | "night_owl" | "ayu"
local ACTIVE_THEME = "catppuccin"

local themes = {
  dracula = {
    bg = "#282a36",
    bg_dark = "#21222c",
    bg_highlight = "#313442",
    fg = "#f8f8f2",
    fg_dark = "#d7dae0",
    comment = "#6272a4",
    border = "#44475a",
    blue = "#82aaff",
    cyan = "#8be9fd",
    green = "#50fa7b",
    yellow = "#f1fa8c",
    red = "#ff5555",
    magenta = "#ff79c6",
    visual_bg = "#44475a",
    git_line_add_bg = "#243f2d",
    git_line_change_bg = "#273a52",
    git_diff_add_bg = "#1f3829",
    git_diff_delete_bg = "#3b2432",
    git_diff_change_bg = "#23324a",
    git_diff_text_bg = "#2e4367",
    git_deleted_virtual = "#ff8ca5",
  },
  catppuccin = {
    bg = "#24273a",
    bg_dark = "#1e2030",
    bg_highlight = "#363a4f",
    fg = "#cad3f5",
    fg_dark = "#b8c0e0",
    comment = "#6e738d",
    border = "#494d64",
    blue = "#8aadf4",
    cyan = "#91d7e3",
    green = "#a6da95",
    yellow = "#eed49f",
    red = "#ed8796",
    magenta = "#c6a0f6",
    visual_bg = "#414559",
    git_line_add_bg = "#263d2e",
    git_line_change_bg = "#2b3550",
    git_diff_add_bg = "#214033",
    git_diff_delete_bg = "#3d2735",
    git_diff_change_bg = "#293a57",
    git_diff_text_bg = "#34507a",
    git_deleted_virtual = "#f2a7b5",
  },
  night_owl = {
    bg = "#011627",
    bg_dark = "#01111d",
    bg_highlight = "#1d3b53",
    fg = "#d6deeb",
    fg_dark = "#b6c2d9",
    comment = "#637777",
    border = "#27405a",
    blue = "#82aaff",
    cyan = "#7fdbca",
    green = "#22da6e",
    yellow = "#ecc48d",
    red = "#ef5350",
    magenta = "#c792ea",
    visual_bg = "#1b3650",
    git_line_add_bg = "#133327",
    git_line_change_bg = "#1a3150",
    git_diff_add_bg = "#153a2f",
    git_diff_delete_bg = "#3a2333",
    git_diff_change_bg = "#1f3960",
    git_diff_text_bg = "#265287",
    git_deleted_virtual = "#f78c6c",
  },
  ayu = {
    bg = "#0a0e14",
    bg_dark = "#06090f",
    bg_highlight = "#1f2430",
    fg = "#b3b1ad",
    fg_dark = "#9f9d99",
    comment = "#5c6773",
    border = "#2a303b",
    blue = "#59c2ff",
    cyan = "#95e6cb",
    green = "#aad94c",
    yellow = "#ffcc66",
    red = "#f07178",
    magenta = "#d2a6ff",
    visual_bg = "#253340",
    git_line_add_bg = "#1a2a1f",
    git_line_change_bg = "#223046",
    git_diff_add_bg = "#162a20",
    git_diff_delete_bg = "#311f26",
    git_diff_change_bg = "#1d3047",
    git_diff_text_bg = "#284064",
    git_deleted_virtual = "#ff8f97",
  },
}

local palette = themes[ACTIVE_THEME] or themes.dracula

local function hl(group, value)
  vim.api.nvim_set_hl(0, group, value)
end

local function apply_soft_theme()
  hl("Normal", { fg = palette.fg, bg = palette.bg })
  hl("NormalNC", { fg = palette.fg_dark, bg = palette.bg_dark })
  hl("NormalFloat", { fg = palette.fg, bg = palette.bg_dark })
  hl("FloatBorder", { fg = palette.border, bg = palette.bg_dark })
  hl("SignColumn", { fg = palette.fg_dark, bg = palette.bg })
  hl("LineNr", { fg = palette.comment, bg = palette.bg })
  hl("CursorLineNr", { fg = palette.yellow, bg = palette.bg, bold = true })
  hl("CursorLine", { bg = palette.bg_highlight })
  hl("ColorColumn", { bg = palette.bg_highlight })
  hl("Visual", { bg = palette.visual_bg })
  hl("Search", { fg = palette.bg, bg = palette.yellow })
  hl("IncSearch", { fg = palette.bg, bg = palette.cyan })
  hl("Pmenu", { fg = palette.fg, bg = palette.bg_dark })
  hl("PmenuSel", { fg = palette.bg, bg = palette.blue })
  hl("StatusLine", { fg = palette.fg_dark, bg = palette.bg_dark })
  hl("StatusLineNC", { fg = palette.comment, bg = palette.bg_dark })
  hl("WinSeparator", { fg = palette.border, bg = palette.bg })
  hl("VertSplit", { fg = palette.border, bg = palette.bg })
  hl("Comment", { fg = palette.comment, italic = true })
  hl("DiagnosticError", { fg = palette.red })
  hl("DiagnosticWarn", { fg = palette.yellow })
  hl("DiagnosticInfo", { fg = palette.blue })
  hl("DiagnosticHint", { fg = palette.cyan })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = palette.red })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = palette.yellow })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = palette.blue })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = palette.cyan })
end

apply_soft_theme()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply_soft_theme,
})

pcall(function()
  require("tablabel").setup({
    set_tabline = true,
    tabline_highlights = {
      enabled = true,
      contrast_step = 0.08,
      active_bold = true,
    },
  })
end)

pcall(function()
  require("treedx").setup({
    panel = {
      width = 34,
      split = "left",
    },
    explorer = {
      show_hidden = true,
      git = {
        enabled = false,
        show_ignored = false,
      },
      search = {
        case_sensitive = false,
        match_path = true,
        include_hidden = false,
        include_git_dir = false,
        include_node_modules = false,
        skip_dirs = { "node_modules", "dist", ".next", ".git" },
      },
      content_search = {
        max_matches_per_file = 15,
        max_file_size = 1024 * 512,
      },
    },
    highlights = {
      TreeDxTitle = { fg = palette.blue, bold = true },
      TreeDxHint = { fg = palette.comment, italic = true },
      TreeDxRootPath = { fg = palette.fg_dark },
      TreeDxCursorLine = { bg = palette.bg_highlight },
      TreeDxGitModified = { fg = palette.yellow },
      TreeDxGitNew = { fg = palette.green },
      TreeDxGitIgnored = { fg = palette.comment },
    },
  })
end)

pcall(function()
  require("gitdx").setup({
    live = {
      enabled = true,
      debounce_ms = 160,
      show_signs = true,
      line_highlight = false,
      show_deleted_count = true,
      stable_signcolumn = true,
      stable_signcolumn_value = "yes:1",
      winbar_summary = true,
    },
    panel = {
      width = 38,
      split = "right",
    },
    highlights = {
      GitDxSignAdd = { fg = palette.green, bg = "NONE" },
      GitDxSignChange = { fg = palette.yellow, bg = "NONE" },
      GitDxSignDelete = { fg = palette.red, bg = "NONE" },
      GitDxLineAdd = { bg = palette.git_line_add_bg },
      GitDxLineChange = { bg = palette.git_line_change_bg },
      GitDxDeletedVirtual = { fg = palette.git_deleted_virtual, italic = true },
      GitDxDirtyBadge = { fg = palette.fg_dark, bold = true },
      GitDxPanelTitle = { fg = palette.blue, bold = true },
      GitDxPanelHint = { fg = palette.comment, italic = true },
      GitDxPanelPath = { fg = palette.fg },
      GitDxPanelStatusAdd = { fg = palette.green, bold = true },
      GitDxPanelStatusChange = { fg = palette.yellow, bold = true },
      GitDxPanelStatusDelete = { fg = palette.red, bold = true },
      GitDxPanelStatusRename = { fg = palette.blue, bold = true },
      GitDxPanelStatusConflict = { fg = palette.magenta, bold = true },
      GitDxDiffAdd = { bg = palette.git_diff_add_bg },
      GitDxDiffDelete = { bg = palette.git_diff_delete_bg },
      GitDxDiffChange = { bg = palette.git_diff_change_bg },
      GitDxDiffText = { bg = palette.git_diff_text_bg, bold = true },
    },
  })
end)

pcall(function()
  require("workalias").setup({
    autosave_current = false,
    confirm_delete = true,
    notify = true,
    integrations = {
      treedx = true,
      gitdx = true,
    },
  })
end)

local map = vim.keymap.set
map("n", "<leader>e", "<cmd>TreeDxToggle<cr>", { desc = "TreeDx toggle" })
map("n", "<leader>E", "<cmd>TreeDxGitToggle<cr>", { desc = "TreeDx git toggle" })
map("n", "<leader>gg", "<cmd>GitDxRight<cr>", { desc = "GitDx panel" })
map("n", "<leader>gd", "<cmd>GitDxDiff<cr>", { desc = "GitDx diff" })
map("n", "<leader>wS", "<cmd>WorkflowSave<cr>", { desc = "Workflow save" })
map("n", "<leader>wL", "<cmd>WorkflowLoad<cr>", { desc = "Workflow load" })
map("n", "<leader>wD", function()
  local alias = vim.fn.input({
    prompt = "Workflow delete alias: ",
    completion = "customlist,v:lua.require'workalias'.complete_aliases",
  })
  alias = vim.trim(alias or "")
  if alias == "" then
    return
  end
  vim.cmd("WorkflowDelete " .. alias)
end, { desc = "Workflow delete alias" })
map("n", "<leader>wl", "<cmd>WorkflowList<cr>", { desc = "Workflow list" })
