local P = {}

function P.slice_buffer(bufnr, s_row, s_col, e_row, e_col)
local lines = vim.api.nvim_buf_get_lines(bufnr, s_row - 1, e_row, false)

	lines[1] = string.sub(lines[1], s_col)

	lines[#lines] = lines[#lines]:sub(1, e_col)

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
