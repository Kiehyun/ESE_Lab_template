-- Replace dingbat glyphs that text/CJK fonts cannot shape with LaTeX math equivalents.
local REPL = {
  ["\226\156\147"] = "\\ding{52}",          -- ✓ U+2713 (not in Latin Modern / DejaVu Serif)
}

local function split_str(text)
  for marker, latex in pairs(REPL) do
    if text:find(marker, 1, true) then
      local inlines = {}
      local idx = 1
      while true do
        local a, b = text:find(marker, idx, true)
        if not a then
          if idx <= #text then table.insert(inlines, pandoc.Str(text:sub(idx))) end
          break
        end
        if a > idx then table.insert(inlines, pandoc.Str(text:sub(idx, a - 1))) end
        table.insert(inlines, pandoc.RawInline("latex", latex))
        idx = b + 1
      end
      return inlines
    end
  end
  return nil
end

function Str(el)
  return split_str(el.text)
end
