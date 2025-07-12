local M = {}

local parser = require('texpreview.parser')
local tex_compiler = require('texpreview.tex_formatter')
local tex_viewer = require('texpreview.compiler_tex')

local defaults = {
	notify = false, -- true = use vim.notify, false = just print
}

function M.setup(user_opts)
	M.cfg = vim.tbl_deep_extend('force', defaults, user_opts or {})

	vim.api.nvim_create_user_command('Mathenv', function()
		if vim.bo.filetype == "tex" then
			local isMath, s, e = parser.is_in_math_env()
			if isMath then
				local bufnr = vim.api.nvim_get_current_buf()
				local snippet = tex_compiler.slice_buffer(bufnr, s[1], s[2], e[1], e[2])
				local tex_text = tex_compiler.make_tex(snippet)

				print(tex_text)

				tex_viewer.preview_math(tex_text)
			else
				print("Not in a math environment")
			end
		else
			print("Not in a tex file")
		end
	end, {
		nargs = '?',
		complete = function ()
			return {"oui"}
		end,
		desc = 'Check if the given position is in a math environment and compute the equation'
	})

end


return M
