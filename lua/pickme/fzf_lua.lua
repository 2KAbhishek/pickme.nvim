local M = {}

---Convert Neovim style keybindings (<C-x>) to fzf style (ctrl-x)
---@param mapping table<string, function>
---@return table<string, function>
local function convert_keybindings(mapping)
    if not mapping then
        return {}
    end

    local converted = {}
    local keymap = {
        ['<C-'] = 'ctrl-',
        ['<A-'] = 'alt-',
        ['<S-'] = 'shift-',
        ['<M-'] = 'alt-',
        ['<CR>'] = 'enter',
        ['<BS>'] = 'bspace',
        ['<Tab>'] = 'tab',
        ['<S-Tab>'] = 'btab',
        ['<Space>'] = 'space',
        ['<Up>'] = 'up',
        ['<Down>'] = 'down',
        ['<Left>'] = 'left',
        ['<Right>'] = 'right',
    }

    for key, handler in pairs(mapping) do
        local new_key = key
        for vim_key, fzf_key in pairs(keymap) do
            new_key = new_key:gsub(vim_key:gsub('%-', '%%%-'), fzf_key)
        end
        new_key = new_key:gsub('[<>]', '')
        converted[new_key] = handler
    end

    return converted
end

---@param opts PickMe.SelectFileOptions
M.select_file = function(opts)
    require('fzf-lua').fzf_exec(opts.items, {
        prompt = opts.title,
        file_icons = true,
        previewer = 'builtin',
        file_skip_empty_lines = true,
        actions = {
            ['default'] = function(selected)
                if selected and #selected > 0 then
                    vim.cmd('edit ' .. vim.fn.fnameescape(selected[1]))
                end
            end,
        },
    })
end

---@param opts PickMe.CustomPickerOptions
M.custom_picker = function(opts)
    local formatted_items = {}
    local item_map = {}
    for _, item in ipairs(opts.items) do
        local entry = opts.entry_maker(item)
        table.insert(formatted_items, entry.display)
        item_map[entry.display] = item
    end

    local CustomPreviewer = require('fzf-lua.previewer.builtin').base:extend()
    function CustomPreviewer:new(o, preview_opts, fzf_win)
        CustomPreviewer.super.new(self, o, preview_opts, fzf_win)
        setmetatable(self, CustomPreviewer)
        self.item_map = item_map
        return self
    end

    function CustomPreviewer:populate_preview_buf(entry_str)
        local bufnr = self:get_tmp_buffer()
        local item = self.item_map[entry_str]
        local preview_text = opts.preview_generator(item)
        local lines = vim.split(preview_text, '\n')
        vim.bo[bufnr].filetype = opts.preview_ft or 'markdown'
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

        self:set_preview_buf(bufnr)
        if self.win and type(self.win.update_scrollbar) == 'function' then
            self.win:update_scrollbar()
        end
    end

    local actions = {
        ['default'] = function(selected)
            if selected and #selected > 0 then
                local item = item_map[selected[1]]
                if item then
                    opts.selection_handler(nil, { value = item })
                end
            end
        end,
    }

    if opts.action_map then
        local converted_actions = convert_keybindings(opts.action_map)
        for key, handler in pairs(converted_actions) do
            actions[key] = function(selected)
                if selected and #selected > 0 then
                    local item = item_map[selected[1]]
                    if item then
                        handler(nil, { value = item })
                    end
                end
            end
        end
    end

    require('fzf-lua').fzf_exec(formatted_items, {
        prompt = opts.title,
        previewer = CustomPreviewer,
        actions = actions,
    })
end

M.command_map = function()
    return {
        autocmds = 'autocmds',
        buffer_grep = 'grep_curbuf',
        buffers = 'buffers',
        breakpoints = 'dap_breakpoints',
        colorschemes = 'colorschemes',
        command_history = 'command_history',
        commands = 'commands',
        diagnostics = 'diagnostics_workspace',
        diagnostics_buffer = 'diagnostics_document',
        files = 'files',
        git_branches = 'git_branches',
        git_commits = 'git_commits',
        git_files = 'git_files',
        git_log_file = 'git_bcommits',
        git_log_line = 'git_commits_current',
        git_stash = 'git_stash',
        git_status = 'git_status',
        git_tags = 'git_tags',
        grep_string = 'grep_cword',
        help = 'helptags',
        highlights = 'highlights',
        jumplist = 'jumps',
        keymaps = 'keymaps',
        live_grep = 'live_grep',
        loclist = 'loclist',
        lsp_declarations = 'lsp_declarations',
        lsp_definitions = 'lsp_definitions',
        lsp_document_symbols = 'lsp_document_symbols',
        lsp_implementations = 'lsp_implementations',
        lsp_references = 'lsp_references',
        lsp_type_definitions = 'lsp_typedefs',
        lsp_workspace_symbols = 'lsp_workspace_symbols',
        man = 'manpages',
        marks = 'marks',
        oldfiles = 'oldfiles',
        options = 'nvim_options',
        pickers = 'builtin',
        profiles = 'profiles',
        quickfix = 'quickfix',
        registers = 'registers',
        resume = 'resume',
        search_history = 'search_history',
        spell_suggest = 'spell_suggest',
        tags = 'tags',
        tabs = 'tabs',
        tmux_cliphist = 'tmux_buffers',
        treesitter = 'treesitter',
        undo = 'changes',
        zoxide = 'zoxide',
    }
end

return M
