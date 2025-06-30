
local P = {}


function P.count_char_in_current_buf(char)
	local bufnr = vim.api.nvim_get_current_buf()

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)


	local count = 0

	for _, line in ipairs(lines) do
		for c in line:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
			if c == char then
				count = count + 1
			end
		end
	end
	return count
	
end


return P

