local pickme = require('pickme.main')
local config = require('pickme.config').config

local M = {}

M.setup = function()
    vim.api.nvim_create_user_command('PickMe', function(opts)
        local args = opts.args
        if args == '' then
            print('Usage: PickMe [picker_name] [provider] [title] (e.g. PickMe files snacks File picker)')
            return
        end

        local parts = {}
        for word in args:gmatch('%S+') do
            table.insert(parts, word)
        end

        local cmd = parts[1]
        local provider_override = parts[2]
        local title = table.concat(parts, ' ', 3)

        local picker_opts = {}

        if provider_override then
            picker_opts.provider_override = provider_override
        end

        if title ~= '' then
            picker_opts.title = title
        end

        require('pickme').pick(cmd, picker_opts)
    end, {
        nargs = '*',
        desc = 'Use any picker with optional provider override',
        complete = function(ArgLead, CmdLine, CursorPos)
            local parts = {}
            for word in CmdLine:gsub('^%s*PickMe%s+', ''):gmatch('%S+') do
                table.insert(parts, word)
            end

            if #parts == 0 then
                local pickers = pickme.get_commands()
                local matches = {}
                for _, picker in ipairs(pickers) do
                    if picker:find(ArgLead, 1, true) == 1 then
                        table.insert(matches, picker)
                    end
                end
                return matches
            end

            return {}
        end,
    })

    if config.add_default_keybindings then
        local function add_keymap(keys, cmd, desc)
            vim.api.nvim_set_keymap('n', keys, cmd, { noremap = true, silent = true, desc = desc })
        end

        add_keymap('<leader>,', ':PickMe buffers<cr>', 'Buffers')
        add_keymap('<leader>/', ':PickMe search_history<cr>', 'Search History')
        add_keymap('<leader>:', ':PickMe command_history<cr>', 'Command History')
        add_keymap('<leader><space>', ':PickMe files<cr>', 'Files')
        add_keymap('<C-f>', ':PickMe files<cr>', 'Files')

        add_keymap('<leader>fa', ':PickMe files<cr>', 'Find Files')
        add_keymap('<leader>fb', ':PickMe buffers<cr>', 'Buffers')
        add_keymap('<leader>fc', ':PickMe git_log_file<cr>', 'File Commits')
        add_keymap('<leader>fd', ':PickMe projects<cr>', 'Project Dirs')
        add_keymap('<leader>ff', ':PickMe git_files<cr>', 'Find Git Files')
        add_keymap('<leader>fg', ':PickMe live_grep<cr>', 'Grep')
        add_keymap('<leader>fl', ':PickMe loclist<cr>', 'Location List')
        add_keymap('<leader>fm', ':PickMe git_status<cr>', 'Modified Files')
        add_keymap('<leader>fo', ':PickMe grep_buffers<cr>', 'Grep Open Buffers')
        add_keymap('<leader>fp', ':PickMe resume<cr>', 'Previous Picker')
        add_keymap('<leader>fq', ':PickMe quickfix<cr>', 'Quickfix List')
        add_keymap('<leader>fr', ':PickMe oldfiles<cr>', 'Recent Files')
        add_keymap('<leader>fs', ':PickMe buffer_grep<cr>', 'Buffer Lines')
        add_keymap('<leader>ft', ':PickMe pickers<cr>', 'All Pickers')
        add_keymap('<leader>fu', ':PickMe undo<cr>', 'Undo History')
        add_keymap('<leader>fw', ':PickMe grep_string<cr>', 'Word Grep')
        add_keymap('<leader>fz', ':PickMe zoxide<cr>', 'Zoxide')

        add_keymap('<leader>gL', ':PickMe git_log<cr>', 'Git Log')
        add_keymap('<leader>gS', ':PickMe git_stash<cr>', 'Git Stash')
        add_keymap('<leader>gc', ':PickMe git_commits<cr>', 'Git Commits')
        add_keymap('<leader>gl', ':PickMe git_log_line<cr>', 'Git Log Line')
        add_keymap('<leader>gs', ':PickMe git_branches<cr>', 'Git Branches')

        add_keymap('<leader>ii', ':PickMe icons<cr>', 'Icons')
        add_keymap('<leader>ir', ':PickMe registers<cr>', 'Registers')
        add_keymap('<leader>is', ':PickMe spell_suggest<cr>', 'Spell Suggestions')
        add_keymap('<leader>iv', ':PickMe cliphist<cr>', 'Clipboard')

        add_keymap('<leader>lD', ':PickMe lsp_declarations<cr>', 'LSP Declarations')
        add_keymap('<leader>lF', ':PickMe lsp_references<cr>', 'References')
        add_keymap('<leader>lL', ':PickMe diagnostics<cr>', 'Diagnostics')
        add_keymap('<leader>lS', ':PickMe lsp_workspace_symbols<cr>', 'Workspace Symbols')
        add_keymap('<leader>ld', ':PickMe lsp_definitions<cr>', 'LSP Definitions')
        add_keymap('<leader>li', ':PickMe lsp_implementations<cr>', 'LSP Implementations')
        add_keymap('<leader>ll', ':PickMe diagnostics_buffer<cr>', 'Buffer Diagnostics')
        add_keymap('<leader>ls', ':PickMe lsp_document_symbols<cr>', 'Document Symbols')
        add_keymap('<leader>lt', ':PickMe lsp_type_definitions<cr>', 'Type Definitions')

        add_keymap('<leader>oC', ':PickMe colorschemes<cr>', 'Colorschemes')
        add_keymap('<leader>oa', ':PickMe autocmds<cr>', 'Autocmds')
        add_keymap('<leader>oc', ':PickMe command_history<cr>', 'Command History')
        add_keymap('<leader>od', ':PickMe help<cr>', 'Docs')
        add_keymap('<leader>of', ':PickMe marks<cr>', 'Marks')
        add_keymap('<leader>og', ':PickMe commands<cr>', 'Commands')
        add_keymap('<leader>oh', ':PickMe highlights<cr>', 'Highlights')
        add_keymap('<leader>oj', ':PickMe jumplist<cr>', 'Jump List')
        add_keymap('<leader>ok', ':PickMe keymaps<cr>', 'Keymaps')
        add_keymap('<leader>ol', ':PickMe lazy<cr>', 'Search for Plugin Spec')
        add_keymap('<leader>om', ':PickMe man<cr>', 'Man Pages')
        add_keymap('<leader>on', ':PickMe notifications<cr>', 'Notifications')
        add_keymap('<leader>oo', ':PickMe options<cr>', 'Options')
        add_keymap('<leader>os', ':PickMe search_history<cr>', 'Search History')
        add_keymap('<leader>ot', ':PickMe treesitter<cr>', 'Treesitter Find')

        add_keymap(
            '<leader>ecc',
            ':lua require("pickme").pick("files", { cwd = vim.fn.stdpath("config"), title = "Neovim Configs" })<cr>',
            'Neovim Configs'
        )
        add_keymap(
            '<leader>ecP',
            ':lua require("pickme").pick("files", { cwd = vim.fn.stdpath("data") .. "/lazy", title = "Plugin Files" })<cr>',
            'Neovim Plugins'
        )
        add_keymap(
            '<leader>ecL',
            ':lua require("pickme").pick("files", { cwd = vim.fn.stdpath("state"), title = "Log Files" })<cr>',
            'Neovim Logs'
        )
    end
end

return M
