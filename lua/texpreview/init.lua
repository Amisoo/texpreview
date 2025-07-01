local M = {}

local parser = require('texpreview.parser')
local tex_compiler = require('texpreview.tex_formatter')
local tex_viewer = require('texpreview.compiler_tex')

local defaults = {
target_char = '(',
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

				-- local oui = tex_viewer.preview_math(tex_text)

			else
				print("On est pas en math dsl")
			end
		else
			print("Desolé pas en fichier tex")
		end
	end, {
		nargs = '?',
		complete = function ()
			return {"oui"}
		end,
		desc = 'Check and give the position of the math  environment'
	})

	vim.api.nvim_create_user_command('CharrePort', function()
		if vim.bo.filetype == "tex" then
			local char = '('-- opts.args ~= '(' and opts.args or M.cfg.target_char
			print("eest ce qu'on est en fait en train de rien print")
			print(char)
			local count = parser.count_char_in_current_buf(char)
			local msg = string.format("Found %d '%s' character%s in this buffer.",
							count, char, count == 1 and '' or 's')
			if M.cfg.notify then
				vim.notify(msg, vim.log.levels.INFO, { title  = 'CharrePort0'})
			else
				print(count)
				print(msg)
			end
		else
			print("not in a tex file")
		end
	end, {
		nargs = '?',
		complete = function()
			return { '(', ')', '[', ']', '{', '}', ';', ','}
		end,
		desc = 'Count occurences of a character in the current buffer',
	})
end


return M
