<div align = "center">

<h1><a href="https://github.com/2kabhishek/pickme.nvim">pickme.nvim</a></h1>

<a href="https://github.com/2KAbhishek/pickme.nvim/blob/main/LICENSE">
<img alt="License" src="https://img.shields.io/github/license/2kabhishek/pickme.nvim?style=flat&color=eee&label="> </a>

<a href="https://github.com/2KAbhishek/pickme.nvim/graphs/contributors">
<img alt="People" src="https://img.shields.io/github/contributors/2kabhishek/pickme.nvim?style=flat&color=ffaaf2&label=People"> </a>

<a href="https://github.com/2KAbhishek/pickme.nvim/stargazers">
<img alt="Stars" src="https://img.shields.io/github/stars/2kabhishek/pickme.nvim?style=flat&color=98c379&label=Stars"></a>

<a href="https://github.com/2KAbhishek/pickme.nvim/network/members">
<img alt="Forks" src="https://img.shields.io/github/forks/2kabhishek/pickme.nvim?style=flat&color=66a8e0&label=Forks"> </a>

<a href="https://github.com/2KAbhishek/pickme.nvim/watchers">
<img alt="Watches" src="https://img.shields.io/github/watchers/2kabhishek/pickme.nvim?style=flat&color=f5d08b&label=Watches"> </a>

<a href="https://github.com/2KAbhishek/pickme.nvim/pulse">
<img alt="Last Updated" src="https://img.shields.io/github/last-commit/2kabhishek/pickme.nvim?style=flat&color=e06c75&label="> </a>

<h3>One Picker to rule them all 💍👑</h3>

<figure>
  <img src="doc/images/screenshot.png" alt="pickme.nvim in action">
  <br/>
  <figcaption>pickme.nvim in action</figcaption>
</figure>

</div>

# pickme.nvim

A unified interface for multiple Neovim picker plugins (Telescope, FZF-Lua, and Snacks). Write your code once and let users choose their preferred picker backend!

## ✨ Features

- Auto-detects available picker providers based on your configuration
- Seamlessly switch between Telescope, FZF-Lua, and Snacks.picker
- 40+ common pickers that work across all providers
- Nice collection of exclusive pickers for each provider
- Custom picker API for creating your own powerful pickers
- Sensible default keybindings

## ⚡ Setup

### 💻 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  '2KAbhishek/pickme.nvim',
  cmd = 'PickMe',
  event = 'VeryLazy',
  dependencies = {
    -- Include at least one of these pickers:
    'folke/snacks.nvim', -- For snacks.picker
    -- 'nvim-telescope/telescope.nvim', -- For telescope
    -- 'ibhagwan/fzf-lua', -- For fzf-lua
  },
  opts = {
    picker_provider = 'snacks', -- Default provider
  },
}
```

## 🚀 Usage

### Configuration

```lua
require('pickme').setup({
  -- Choose your preferred picker provider
  picker_provider = 'snacks', -- Options: 'snacks' (default), 'telescope', 'fzf_lua'

  -- Auto-detect available picker providers (default: true)
  -- If the specified picker_provider is not available, will try to use one from provider_priority list
  detect_provider = true,

  -- Add default keybindings (default: true)
  -- See Keybindings section below for the full list of default keybindings
  add_default_keybindings = true,

  -- Command aliases for convenient shortcuts
  -- Example: using ':PickMe grep' will call ':PickMe live_grep'
  command_aliases = {
    grep = 'live_grep',
    -- Add your own aliases here
  }
})
```

## Available Pickers

### Common Pickers

These pickers are available across all three supported providers (snacks, telescope, fzf_lua):

- `autocmds` - List autocommands
- `buffer_grep` - Search within current buffer
- `buffers` - Browse and select open buffers
- `colorschemes` - Browse and apply colorschemes
- `command_history` - View command history
- `commands` - Browse available commands
- `diagnostics` - View workspace diagnostics
- `files` - Find files in the current directory
- `git_branches` - View and checkout git branches
- `git_commits` - Browse git commit history
- `git_files` - Find files tracked by Git
- `git_log_file` - View git commits for the current buffer
- `git_log_line` - View git history for current line
- `git_stash` - Browse git stash entries
- `git_status` - View files with git status changes
- `grep_string` - Search for the word under cursor
- `help` - Search through help tags
- `highlights` - Browse highlight groups
- `jumplist` - Navigate through jump history
- `keymaps` - Browse configured key mappings
- `live_grep` - Search for a string in your project (grep)
- `loclist` - Browse location list
- `lsp_declarations` - Find declarations with LSP
- `lsp_definitions` - Go to definition of the symbol under cursor
- `lsp_document_symbols` - List symbols in current document
- `lsp_implementations` - Find implementations of the interface under cursor
- `lsp_references` - Find references to the symbol under cursor
- `lsp_type_definitions` - Find type definitions
- `lsp_workspace_symbols` - Search for workspace symbols
- `man` - Browse manual pages
- `marks` - View and jump to marks
- `oldfiles` - Browse recently opened files
- `options` - Browse Neovim options
- `pickers` - Browse available pickers
- `quickfix` - Browse quickfix list
- `registers` - View contents of registers
- `resume` - Resume the last picker
- `search_history` - View search history
- `spell_suggest` - Get spelling suggestions for word under cursor
- `treesitter` - Navigate treesitter symbols

### Snacks Pickers

- `cliphist` - Browse clipboard history
- `git_log` - View detailed git log
- `grep_buffers` - Search across all open buffers
- `icons` - Browse and insert icons
- `lazy` - Search through lazy.nvim plugin specs
- `lsp_config` - Browse LSP server configurations
- `projects` - Browse and switch between projects

### Telescope Pickers

- `options` - View Neovim options
- `icons` - Browse symbols (with devicons)
- `tags` - Work with ctags

### FZF-Lua Pickers

- `breakpoints` - View DAP debugger breakpoints
- `git_tags` - Browse git tags
- `options` - View Neovim options
- `profiles` - Switch FZF profiles
- `tabs` - Browse and switch between tabs
- `tags` - Work with ctags
- `tmux_cliphist` - Browse tmux clipboard history

### Custom Pickers

These are utility functions you can use to create your own pickers:

- `select_file` - Custom file picker with provided items
- `custom_picker` - Fully customizable picker with custom items and handlers

### Lua Usage

```lua
local pickme = require('pickme')

-- Basic usage
pickme.pick('files', { title = 'Find Files' })
pickme.pick('live_grep', { title = 'Search Text' })

-- Select file from a list of files
pickme.select_file({
  items = { "path/to/file1.txt", "path/to/file2.lua", "path/to/file3.md" },
  title = "Select a file to open"
})

-- Using custom picker
pickme.custom_picker({
  title = 'My Custom Picker',
  items = {'item1', 'item2', 'item3'},
  entry_maker = function(item)
    return { display = item, value = item }
  end,
  preview_generator = function(item)
    return "Preview content for " .. item
  end,
  preview_ft = 'markdown',
  selection_handler = function(_, selection)
    print("Selected: " .. selection.value)
  end
})
```

Example Usages:

- custom_picker in [octohub.nvim/repos.lua](https://github.com/2kabhishek/octohub.nvim/blob/main/lua/octohub/repos.lua)
- select_file in [tdo.nvim/init.lua](https://github.com/2kabhishek/tdo.nvim/blob/main/lua/tdo/init.lua)

### Keybindings

If `add_default_keybindings = true` in your setup, the following keybindings will be automatically configured:

| Keybinding        | Command                 | Description            |
| ----------------- | ----------------------- | ---------------------- |
| `<leader>,`       | `buffers`               | Buffers                |
| `<leader>/`       | `search_history`        | Search History         |
| `<leader>:`       | `command_history`       | Command History        |
| `<leader><space>` | `files`                 | Files                  |
| `<C-f>`           | `files`                 | Files                  |
| `<leader>fa`      | `files`                 | Find Files             |
| `<leader>fb`      | `buffers`               | Buffers                |
| `<leader>fc`      | `git_log_file`          | File Commits           |
| `<leader>fd`      | `projects`              | Project Dirs           |
| `<leader>ff`      | `git_files`             | Find Git Files         |
| `<leader>fg`      | `live_grep`             | Grep                   |
| `<leader>fl`      | `loclist`               | Location List          |
| `<leader>fm`      | `git_status`            | Modified Files         |
| `<leader>fo`      | `grep_buffers`          | Grep Open Buffers      |
| `<leader>fp`      | `resume`                | Previous Picker        |
| `<leader>fq`      | `quickfix`              | Quickfix List          |
| `<leader>fr`      | `oldfiles`              | Recent Files           |
| `<leader>fs`      | `buffer_grep`           | Buffer Lines           |
| `<leader>ft`      | `pickers`               | All Pickers            |
| `<leader>fu`      | `undo`                  | Undo History           |
| `<leader>fw`      | `grep_string`           | Word Grep              |
| `<leader>fz`      | `zoxide`                | Zoxide                 |
| `<leader>gL`      | `git_log`               | Git Log                |
| `<leader>gS`      | `git_stash`             | Git Stash              |
| `<leader>gc`      | `git_commits`           | Git Commits            |
| `<leader>gl`      | `git_log_line`          | Git Log Line           |
| `<leader>gs`      | `git_branches`          | Git Branches           |
| `<leader>ii`      | `icons`                 | Icons                  |
| `<leader>ir`      | `registers`             | Registers              |
| `<leader>is`      | `spell_suggest`         | Spell Suggestions      |
| `<leader>iv`      | `cliphist`              | Clipboard              |
| `<leader>lD`      | `lsp_declarations`      | LSP Declarations       |
| `<leader>lF`      | `lsp_references`        | References             |
| `<leader>lL`      | `diagnostics`           | Diagnostics            |
| `<leader>lS`      | `lsp_workspace_symbols` | Workspace Symbols      |
| `<leader>ld`      | `lsp_definitions`       | LSP Definitions        |
| `<leader>li`      | `lsp_implementations`   | LSP Implementations    |
| `<leader>ll`      | `diagnostics_buffer`    | Buffer Diagnostics     |
| `<leader>ls`      | `lsp_document_symbols`  | Document Symbols       |
| `<leader>lt`      | `lsp_type_definitions`  | Type Definitions       |
| `<leader>oC`      | `colorschemes`          | Colorschemes           |
| `<leader>oa`      | `autocmds`              | Autocmds               |
| `<leader>oc`      | `command_history`       | Command History        |
| `<leader>od`      | `help`                  | Docs                   |
| `<leader>of`      | `marks`                 | Marks                  |
| `<leader>og`      | `commands`              | Commands               |
| `<leader>oh`      | `highlights`            | Highlights             |
| `<leader>oj`      | `jumplist`              | Jump List              |
| `<leader>ok`      | `keymaps`               | Keymaps                |
| `<leader>ol`      | `lazy`                  | Search for Plugin Spec |
| `<leader>om`      | `man`                   | Man Pages              |
| `<leader>on`      | `notifications`         | Notifications          |
| `<leader>oo`      | `options`               | Options                |
| `<leader>os`      | `search_history`        | Search History         |
| `<leader>ot`      | `treesitter`            | Treesitter Find        |
| `<leader>ecc`     | Custom                  | Neovim Configs         |
| `<leader>ecP`     | Custom                  | Plugin Files           |

If you want to disable the default keybindings, set `add_default_keybindings = false` in your setup.

You can add your own keybindings by using the `pickme.pick` function or the `PickMe` command. For example:

```lua
local pickme = require('pickme')

vim.keymap.set('n', '<leader>ff', function() pickme.pick('git_files', { title = 'Git Files' }) end, { desc = 'Git Files' })
vim.keymap.set('n', '<leader>fg', function() pickme.pick('live_grep') end, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fa', ':PickMe files<cr>', { desc = 'All Files' })
```

### Help

Run `:help pickme.txt` for more details.

## 🏗️ What's Next

- You tell me!

## ⛅ Behind The Code

### 🌈 Inspiration

I was tired of maintaining separate implementations for different picker plugins in my Neovim extensions.
Now I can write the code once and let users pick their preferred UI!

### 💡 Challenges/Learnings

- Finding information about different pickers supported by picker providers was time consuming.
- Got to create a unified interface for different pickers.

### 🧰 Tooling

- [dots2k](https://github.com/2kabhishek/dots2k) — Dev Environment
- [nvim2k](https://github.com/2kabhishek/nvim2k) — Personalized Editor
- [sway2k](https://github.com/2kabhishek/sway2k) — Desktop Environment
- [qute2k](https://github.com/2kabhishek/qute2k) — Personalized Browser

### 🔍 More Info

- [nerdy.nvim](https://github.com/2kabhishek/nerdy.nvim) — Find nerd glyphs easily
- [tdo.nvim](https://github.com/2KAbhishek/tdo.nvim) — Fast and simple notes in Neovim
- [termim.nvim](https://github.com/2kabhishek/termim.nvim) — Neovim terminal improved
- [octohub.nvim](https://github.com/2kabhishek/octohub.nvim) — Github repos in Neovim
- [exercism.nvim](https://github.com/2kabhishek/exercism.nvim) — Exercism exercises in Neovim

<hr>

<div align="center">

<strong>⭐ hit the star button if you found this useful ⭐</strong><br>

<a href="https://github.com/2KAbhishek/pickme.nvim">Source</a>
| <a href="https://2kabhishek.github.io/blog" target="_blank">Blog </a>
| <a href="https://twitter.com/2kabhishek" target="_blank">Twitter </a>
| <a href="https://linkedin.com/in/2kabhishek" target="_blank">LinkedIn </a>
| <a href="https://2kabhishek.github.io/links" target="_blank">More Links </a>
| <a href="https://2kabhishek.github.io/projects" target="_blank">Other Projects </a>

</div>
