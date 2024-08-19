local M = {}

local vimBindings = {
    Left = "<C-h>",
    Down = "<C-j>",
    Up = "<C-k>",
    Right = "<C-l>",
}

local kittyMappings = { 
    h = "left",
    j = "bottom",
    k = "top",
    l = "right"
}

function M.setup()
    vim.g.Netrw_UserMaps = { { "<C-l>", "<C-U>NvimKittyNavigateRight<CR>" } }
    for func, mapping in pairs(vimBindings) do
        vim.api.nvim_set_keymap(
            "n",
            mapping,
            ":lua require'kitty-navigator'.NvimKittyNavigate" .. func .. "()<CR>",
            { noremap = true, silent = true })
    end
end

function navigate(direction)
	local left_win = vim.fn.winnr("1" .. direction)
	if vim.fn.winnr() ~= left_win then
		vim.api.nvim_command("wincmd " .. direction)
	else
		local command = "kitty @ kitten navigate_kitty.py " .. kittyMappings[direction]
		vim.fn.system(command)
	end
end

function M.NvimKittyNavigateLeft() navigate("h") end
function M.NvimKittyNavigateDown() navigate("j") end
function M.NvimKittyNavigateUp() navigate("k") end
function M.NvimKittyNavigateRight() navigate("l") end

local function create_command(command_name, func, direction)
    vim.api.nvim_create_user_command(command_name, function(...) func(direction) end, {})
end

create_command("NvimKittyNavigateLeft", navigate, "h")
create_command("NvimKittyNavigateDown", navigate, "j")
create_command("NvimKittyNavigateUp", navigate, "k")
create_command("NvimKittyNavigateRight", navigate, "l")

return M
