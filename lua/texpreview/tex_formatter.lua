local P = {}

function P.slice_buffer(bufnr, s_row, s_col, e_row, e_col)
local lines = vim.api.nvim_buf_get_lines(bufnr, s_row - 1, e_row, false)
	print(s_row)
	print("lines : ", lines[1])
	-- if we are in an empty file

	print("s_col : ", s_col)
	lines[1] = lines[1]
	lines[#lines] = lines[#lines]:sub(1, e_col)
	print("lines[1] : ", lines[1])
	print("lines[lines] : ", lines[#lines])
	return table.concat(lines, '\n')
end

function P.make_tex(snippet)
  return table.concat({
    "\\documentclass[preview]{standalone}",
    "\\usepackage{amsmath,amsfonts}",
    "\\begin{document}",
    "\\[",
    snippet,
    "\\]",
    "\\end{document}",
    ""}, "\n")
end


return P
