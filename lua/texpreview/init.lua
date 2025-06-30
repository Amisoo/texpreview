local M = {}

local parser = require('texpreview.parser')

local defaults = {
target_char = '(',
	notify      = false, -- true = use vim.notify, false = just print
}

function M.setup(user_opts)
	M.cfg = vim.tbl_deep_extend('force', defaults, user_opts or {})

	vim.api.nvim_create_user_command('CharrePort', function(opts)
		local char = opts.args ~= ' ' and opts.args or M.cfg.target_char
		local count = parser.count_char_in_current_buf(char)
		local msg = string.format("Found %d '%s' character%s in this buffer.",
						count, char, count == 1 and '' or 's')
		if M.cfg.notify then
			vim.notify(msg, vim.log.levels.INFO, { title  = 'CharrePort0'})
		else
			print(msg)
		end
	end, {
		margs = '?',
		complete = function()
			return { '(', ')', '[', ']', '{', '}', ';', ','}
		end,
		desc = 'Count occurences of a character in the current buffer',
	})
end


return M
	
			

	
