local lexers = vis.lexers

local fg = ',fore:default,'
local bg = ',back:default,'

-- 0 = light
-- 1 = dark
local c = {
	blue0   = '#5fd7ff', -- 081 
	blue1   = '#00d7ff', -- 045 
	purple0 = '#87005f', -- 089 
	purple1 = '#af87ff', -- 141 
	brown1  = '#87875f', -- 101 
	green0  = '#87d700', -- 112 
	yellow0 = '#d7d75f', -- 185 
	orange1 = '#d7875f', -- 173 
	orange0 = '#ffaf00', -- 214
	pink0   = '#ff005f', -- 197 
	black0  = '#262626', -- 235
	grey0   = '#4e4e4e', -- 239
	grey1   = '#3a3a3a', -- 237
	grey2   = '#bcbcbc', -- 250
	white1  = '#ffffff', -- 230
}

lexers.STYLE_DEFAULT = bg..fg
lexers.STYLE_NOTHING = bg
lexers.STYLE_CLASS = 'fore:' .. c.orange1
lexers.STYLE_COMMENT = 'fore:' .. c.brown1
lexers.STYLE_CONSTANT = 'fore:' .. c.purple1
lexers.STYLE_DEFINITION = 'fore:' .. c.blue0
lexers.STYLE_ERROR = 'fore:' .. c.purple0 .. ',italics,back:'..c.green0
lexers.STYLE_FUNCTION = 'fore:' .. c.green0
lexers.STYLE_KEYWORD = 'fore:' .. c.pink0
lexers.STYLE_LABEL = 'fore:' .. c.yellow0
lexers.STYLE_NUMBER = 'fore:' .. c.purple1
lexers.STYLE_OPERATOR = 'fore:' .. c.pink0
lexers.STYLE_REGEX = 'fore:' .. c.green0
lexers.STYLE_STRING = 'fore:' .. c.yellow0
lexers.STYLE_PREPROCESSOR = 'fore:' .. c.green0
lexers.STYLE_TAG = 'fore:' .. c.pink0
lexers.STYLE_TYPE = 'fore:' .. c.blue0
lexers.STYLE_VARIABLE = 'fore:' .. c.blue0
lexers.STYLE_WHITESPACE = 'fore:' .. c.grey2
lexers.STYLE_EMBEDDED = 'back:' .. c.blue1
lexers.STYLE_IDENTIFIER = fg

lexers.STYLE_LINENUMBER = 'fore:' .. c.grey2 .. ',back:' .. c.grey1
lexers.STYLE_CURSOR = 'fore:' .. c.black0 .. ',back:' .. c.white1
lexers.STYLE_CURSOR_PRIMARY = 'fore:' .. c.black0 .. ',back:' .. c.orange0
lexers.STYLE_CURSOR_LINE = 'back:' .. c.grey1
lexers.STYLE_COLOR_COLUMN = lexers.STYLE_CURSOR_LINE
lexers.STYLE_SELECTION = 'back:' .. c.grey0 .. ',fore:' .. c.green0
lexers.STYLE_STATUS = 'back:' .. c.grey1 .. ',fore:' .. c.white1
lexers.STYLE_STATUS_FOCUSED = lexers.STYLE_STATUS .. ',bold'
lexers.STYLE_SEPARATOR = lexers.STYLE_DEFAULT
lexers.STYLE_INFO = lexers.STYLE_DEFAULT
lexers.STYLE_EOF = lexers.STYLE_COMMENT
