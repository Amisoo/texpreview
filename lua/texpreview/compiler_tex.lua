
local P = {}
local uv = vim.loop


---Compile snippet -> PDF (then SVG) and call cb(svg_path) on success
 local function compile_snippet(snippet)
  local tmpdir = vim.fn.tempname():gsub("\\", "/")  -- win backslash fix
  -- create a directory to store the svg
  vim.fn.mkdir(tmpdir)

  -- All needed path for each file
  local texfile = tmpdir .. "/eq.tex"
  local dvifile = tmpdir .. "/eq.dvi"
  local svgfile = tmpdir .. "/eq.svg"

  -- write the .tex
  local fd = assert(io.open(texfile, "w"))
  fd:write(snippet)
  fd:close()

  -- compiling the tex file
  local handle = io.popen(string.format( 
	'pdflatex -interaction=nonstopmode --output-format=dvi -output-directory=%s %s', tmpdir, texfile

  ))
  local result = handle:read("*a")
  handle:close()

  -- converting the pfg file into a svg
  os.execute(string.format( 
	  'dvisvgm --no-fonts --exact -o %s %s', svgfile, dvifile
  ))

  -- path of the file
  return svgfile
end



 function P.preview_math(tex_text)
  	local svg_path = compile_snippet(tex_text)
	
	-- show the svg depending on the os
	local osname = vim.loop.os_uname().sysname
	if osname ==  "Windows_NT" then
    		os.execute(string.format('start "" "%s"', svg_path))
	 elseif osname == "Darwin" then
    		os.execute(string.format('open "" "%s"', svg_path))
	  elseif osname == "Linux" then
    		os.execute(string.format('xdg-open "" "%s"', svg_path))
	  else 
		  print("An error occured with the detection of the os : ")
		  print("This is the os detected : ", osname)
	  end

end


return P
