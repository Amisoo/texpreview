
if vim.g.loaded_charreport then
	return
end

vim.g.loaded_charreport = true

require('texpreview').setup
