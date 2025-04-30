local M = {}

---Calls assigned action for the selected entry
---@param handler function
---@param prompt_bufnr number
local function call_action(handler, prompt_bufnr)
    local selection = require('telescope.actions.state').get_selected_entry()
    require('telescope.actions').close(prompt_bufnr)
    handler(prompt_bufnr, selection)
end

---@param opts PickMe.SelectFileOptions
M.select_file = function(opts)
    require('telescope.pickers')
        .new({}, {
            prompt_title = opts.prompt_title,
            finder = require('telescope.finders').new_table({
                results = opts.items,
                entry_maker = require('telescope.make_entry').gen_from_file(),
            }),
            sorter = require('telescope.sorters').get_fzy_sorter(),
            previewer = require('telescope.previewers').vim_buffer_cat.new({}),
        })
        :find()
end

---@param opts PickMe.CustomPickerOptions
M.custom_picker = function(opts)
    require('telescope.pickers')
        .new({}, {
            prompt_title = opts.title,
            finder = require('telescope.finders').new_table({
                results = opts.items,
                entry_maker = opts.entry_maker,
            }),
            sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
            previewer = require('telescope.previewers').new_buffer_previewer({
                define_preview = function(self, entry, _)
                    local repo_info = opts.preview_generator(entry.value)
                    vim.bo[self.state.bufnr].filetype = opts.preview_ft or 'markdown'
                    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(repo_info, '\n'))
                end,
            }),
            attach_mappings = function(prompt_bufnr, keymap)
                require('telescope.actions').select_default:replace(function()
                    call_action(opts.selection_handler, prompt_bufnr)
                end)

                if opts.action_map then
                    for key, handler in pairs(opts.action_map) do
                        keymap('i', key, function()
                            call_action(handler, prompt_bufnr)
                        end)
                    end
                end
                return true
            end,
        })
        :find()
end

M.command_map = function()
    return {
        autocmds = 'autocommands',
        buffer_grep = 'current_buffer_fuzzy_find',
        buffers = 'buffers',
        colorschemes = 'colorscheme',
        command_history = 'command_history',
        commands = 'commands',
        diagnostics = 'diagnostics',
        files = 'find_files',
        git_branches = 'git_branches',
        git_commits = 'git_commits',
        git_files = 'git_files',
        git_log_file = 'git_bcommits',
        git_log_line = 'git_bcommits_range',
        git_stash = 'git_stash',
        git_status = 'git_status',
        grep_string = 'grep_string',
        help = 'help_tags',
        highlights = 'highlights',
        icons = 'symbols',
        jumplist = 'jumplist',
        keymaps = 'keymaps',
        live_grep = 'live_grep',
        loclist = 'loclist',
        lsp_definitions = 'lsp_definitions',
        lsp_document_symbols = 'lsp_document_symbols',
        lsp_implementations = 'lsp_implementations',
        lsp_references = 'lsp_references',
        lsp_type_definitions = 'lsp_type_definitions',
        lsp_workspace_symbols = 'lsp_workspace_symbols',
        man = 'man_pages',
        marks = 'marks',
        oldfiles = 'oldfiles',
        options = 'vim_options',
        pickers = 'builtin',
        quickfix = 'quickfix',
        registers = 'registers',
        resume = 'resume',
        search_history = 'search_history',
        spell_suggest = 'spell_suggest',
        tags = 'current_buffer_tags',
        treesitter = 'treesitter',
    }
end

return M
