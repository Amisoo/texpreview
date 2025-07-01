local P = {}

function P.slice_buffer(bufnr, s_row, s_col, e_row, e_col)
	local lines = vim.api.nvim_buf_get_lines(bufnr, s_row, e_row, false)
	-- if we are in an empty file
	if #lines == 0 then return "" end

	lines[1] = lines[1]:sub(s_col)
	lines[#lines] = lines[#lines]:sub(1, e_col)
	return table.concat(lines, '\n')
end

function P.make_tex(snippet)
  return table.concat({
    "\\documentclass{standalone}",
    "\\usepackage{amsmath,amsfonts}",
    "\\begin{document}",
    "\\[",
    snippet,
    "\\]",
    "\\end{document}",
    ""}, "\n")
end


return P
