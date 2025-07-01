local P = {}

function P.is_in_math_env()

	local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- index of the current position of the cursor

	local bufnr = vim.api.nvim_get_current_buf()

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local line = lines[row]


	-- Check inline math with '$ ... $ ' in the current line before the cursor
	local before_cursor = line:sub(1, col)

	local _, dollar_count = before_cursor:gsub("%s", "")

	if dollar_count % 2 == 1 then
		local s = before_cursor:match(".*()[$]")
		local after_cursor = line:sub(col + 2)

		local e = after_cursor:find("%$")

		return before_cursor, s, e, true
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
				local s, e = string.find(l, 'align*')
				if s then
					return i, s, e + 1 , true
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
		local line_end, col_end_start, col_end_end, flag_end = find_end()
		if flag_start ~= flag_end then
			return false, -1, -1
		end

		if line_end then
			-- In the case of a multiline equation
			if line_start < line_end then
				return true, {line_start, col_start_start} , {line_end, col_end_end}

			-- In case where we have a inline begin environment
			elseif line_start == line_end then
				if col_start_end < col_end_start then
					return true, {line_start, col_start_start} , {line_end, col_end_end}
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

