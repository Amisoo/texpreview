local P = {}
local uv = vim.loop

---Compile snippet -> PDF (then SVG) and call cb(svg_path) on success
 local function compile_snippet(snippet)
  local tmpdir = vim.fn.tempname():gsub("\\", "/")  -- win backslash fix
  vim.fn.mkdir(tmpdir)
  print(tmpdir)
  local texfile = tmpdir .. "/eq.tex"
  local pdffile = tmpdir .. "/eq.pdf"
  local dvifile = tmpdir .. "/eq.dvi"
  local svgfile = tmpdir .. "/eq.svg"

  -- write the .tex
  print("ici peut être?")
  local fd = assert(io.open(texfile, "w"))
  fd:write(snippet)
  fd:close()

  -- 1) lualatex
  print("la?")
  print(string.format('%s %s', tmpdir, texfile))

  local handle = io.popen(string.format( 
	'pdflatex -interaction=nonstopmode --output-format=dvi -output-directory=%s %s', tmpdir, texfile

  ))
  local result = handle:read("*a")

  handle:close()
   --os.execute(string.format(
	-- 'pdflatex -interaction=nonstopmode --output-format=dvi -jobname=%s %s', tmpdir, texfile
  -- ))
  print("Toujours ici")

  os.execute(string.format( 
	  'dvisvgm --no-fonts --exact -o %s %s', svgfile, dvifile
  ))


  print("SVG written at ", svgfile, dvifile)

  return svgfile
  --[[
  uv.spawn(latex_cmd[1], { args = vim.list_slice(latex_cmd, 2) }, function(code)
    if code ~= 0 then
      vim.schedule(function()
        vim.notify("LaTeX error (code "..code..")", vim.log.levels.ERROR)
      end)
      return
    end

    -- 2) dvisvgm or pdf2svg
    local svg_cmd = { "dvisvgm", pdffile, "-n", "-o", svgfile }
    uv.spawn(svg_cmd[1], { args = vim.list_slice(svg_cmd, 2) }, function(svgcode)
      if svgcode == 0 then
        vim.schedule(function() cb(svgfile) end)
      else
        vim.schedule(function()
          vim.notify("SVG conversion failed", vim.log.levels.ERROR)
        end)
      end
    end)
  end)
  ]]--
end



 function P.preview_math(tex_text)
	 print("on passe par ici")
  	local svg_path = compile_snippet(tex_text)
    -- send to your websocket or open in external viewer:
    -- 1) websocket
    --   require("texpreview.sender").send(snippet)   -- your existing flow
    -- 2) simple browser preview (Windows)
    os.execute(string.format('start "" "%s"', svg_path))
end


return P
