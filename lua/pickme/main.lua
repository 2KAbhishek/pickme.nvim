local config = require('pickme.config')

---@class PickMe.Main
local M = {}

---@class PickMe.CommonOptions
---@field cwd? string -- Current working directory
---@field title? string -- Window title
---@field provider_override? string -- Picker provider to use

---@class PickMe.SelectFileOptions
---@field items string[] -- List of file paths to select from
---@field title string -- Window title
---@field provider_override? string -- Picker provider to use

---@class PickMe.CustomPickerOptions
---@field items table -- List of items to display
---@field title string -- Window title
---@field entry_maker fun(item:any):table -- Converts raw items to picker entries
---@field preview_generator fun(item:any):string -- Generates preview content as string
---@field preview_ft? string -- File type for preview content (defaults to 'markdown')
---@field selection_handler fun(bufnr:number|nil, selection:table) -- Handler for selection
---@field provider_override? string -- Picker provider to use
---@field action_mapping? table<string, fun(bufnr:number|nil, selection:table)> -- Custom keybindings map

local picker_provider_map = {
    snacks = 'snacks.picker',
    telescope = 'telescope.builtin',
    fzf_lua = 'fzf-lua',
}

local function handle_opts(opts, provider)
    opts = opts or {}

    if opts.provider_override then
        opts.provider_override = nil
    end

    if provider == 'fzf_lua' and opts.title then
        local fzf_lua_prompt_suffix = ' '
        opts.prompt = opts.title .. fzf_lua_prompt_suffix
        opts.title = nil
    end

    if provider == 'telescope' and opts.title then
        opts.prompt_title = opts.title
        opts.title = nil
    end
    return opts
end

---@return table

M.get_commands = function()
    local commands = {}
    local seen = {}
    local provider = config.config.picker_provider
    local command_map = require('pickme.' .. provider).command_map()
    local command_aliases = config.config.command_aliases

    for _, cmds in ipairs({ command_map, command_aliases }) do
        for cmd, _ in pairs(cmds) do
            if not seen[cmd] then
                seen[cmd] = true
                table.insert(commands, cmd)
            end
        end
    end

    return commands
end

---@param command string
---@param opts PickMe.CommonOptions
M.pick = function(command, opts)
    opts = opts or {}
    local provider = opts.provider_override or config.config.picker_provider
    local command_aliases = config.config.command_aliases
    if command_aliases[command] then
        command = command_aliases[command]
    end
    opts = handle_opts(opts, provider)

    vim.schedule(function()
        local cmd_map = require('pickme.' .. provider).command_map()
        local cmd = cmd_map[command]
        if cmd then
            require(picker_provider_map[provider])[cmd](opts)
        else
            vim.notify(
                string.format("Command '%s' not supported by provider '%s'", command, provider),
                vim.log.levels.ERROR
            )
        end
    end)
end

---@param opts PickMe.SelectFileOptions
M.select_file = function(opts)
    opts = opts or {}
    local provider = opts.provider_override or config.config.picker_provider

    opts = handle_opts(opts, provider)
    vim.schedule(function()
        require('pickme.' .. provider).select_file(opts)
    end)
end

---@param opts PickMe.CustomPickerOptions
M.custom_picker = function(opts)
    opts = opts or {}
    local provider = opts.provider_override or config.config.picker_provider

    opts = handle_opts(opts, provider)
    vim.schedule(function()
        require('pickme.' .. provider).custom_picker(opts)
    end)
end

return M
