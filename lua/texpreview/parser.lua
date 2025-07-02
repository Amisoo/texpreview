local P = {}

function P.is_in_math_env()

	local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- index of the current position of the cursor

	local bufnr = vim.api.nvim_get_current_buf()

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local line = lines[row]


	-- Check inline math with '$ ... $ ' in the current line before the current cursor until 5 lines above
	local beforeCursor = line:sub(1, col)
	local _, dollar_count = beforeCursor:gsub("%$", "")
	local start_line = math.max(1, row - 5)

	local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, row - 1, false)

	for _, line in ipairs(lines) do
		print(line)
		local _, count = line:gsub("%$", "")
		dollar_count = dollar_count + count
	end
	print(dollar_count)

	if dollar_count % 2 == 1 then
		local col_start_start = -1
		local line_start = row

		for c = col, 1, -1 do
			if line:sub(c, c) == "$" then
				col_start_start = c
				break
			end
		end
		if col_start_start == -1 then
			for r = row-1, 1, -1 do
				local l = vim.api.nvim_buf_get_lines(bufnr, r-1, r, false)[1]
				local idx = l:find("$", 1, true)
				if idx then
					col_start_start = l:match(".*()$", idx)
					line_start = r
				end
			end
		end

		local after_cursor = line:sub(col)
		local col_end_start = after_cursor:find("%$")

		if col_end_start then
			return true, {line_start, col_start_start}, {row, col_end_start - 1}
		end
		-- the $ is in another line
		totalLines = vim.api.nvim_bug_get_line_count(bufnr)
		for r = row + 1, totalLines do
			local line = vim.api.nvim_buf_get_lines(bufnr, r-1, r, false)[1] 
			col_end_start = line:find("%$")
			if col_end_start then
				return true, {line_start, col_start_start}, {row, col_end_start - 1}
			end
		end
		if col_end_start then
			return true, {line_start, col_start_start}, {row, col_end_start - 1}
		else
		end
	end

	local math_envs = {'equation', 'equation*', 'align', 'align*', 'multiline', 'gather', 'eqnarray'}

	local function find_begin()
		-- Check if we are in a begin environment
		for i = row, 1, -1 do
			local l = lines[i]
			for _, env in ipairs(math_envs) do
				local pattern = '\\begin{' .. env

				local s, e = string.find(l, pattern)
				if s then
					-- return line number, start col and end col
					return i, s, e, true
				end
			end
			-- check if we are in a math environment 
			--
			local s, e = line:find("\\%[")

			if not s then
				s, e = line:find("\\%(")
			end

			if s then
				return i, s, e, false
			end

		end
		return nil
	end


	local function find_end()
		-- Check if we are in a end environment
		for i = row, #lines, 1 do 
			local l = lines[i] 
			for _, env in ipairs(math_envs) do 
				local pattern = '\\end{' .. env
				local s, e = string.find(l, pattern)
				if s then
					return i, s, e, true
				end
			end
			-- check if we are in a math environment
			local s, e = line:find("\\%]")
			if not s then
				s, e = line:find("\\%)")
			end

			if s then
				return i, s, e, false
			end
		end
		return nil
	end


	local line_start, col_start_start, col_start_end, flag_start = find_begin()
	if line_start then
		local line_end, col_end_start, _, flag_end = find_end()
		if flag_start ~= flag_end then
			return false, -1, -1
		end

		if line_end then
			-- In the case of a multiline equation
			if line_start < line_end then
				return true, {line_start, col_start_start} , {line_end, col_end_start - 1}

			-- In case where we have a inline begin environment
			elseif line_start == line_end then
				if col_start_end < col_end_start then
					return true, {line_start, col_start_start} , {line_end, col_end_start - 1}
				else
					return false, -1, -1
				end
			else
				return false, -1, -1
			end
		end
	end
	return false, -1, -1
end

return P

