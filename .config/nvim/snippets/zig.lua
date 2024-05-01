return {

	s("test",
		fmta([[
			test "<>" {
				<>
			}]],
			{
				i(1),
				d(2, function(_, snip) return sn(nil, i(1, snip.env.TM_SELECTED_TEXT or {})) end),
			}
		),
		-- {
		-- 	t "test \"", i(1), t { "\" {", "\t" },
		-- 	d(2, function(_, snip) return sn(nil, i(1, snip.env.TM_SELECTED_TEXT or {})) end),
		-- 	t { "", "}" }
		-- },
		{ condition = conds.line_begin }
	),

	-- s("trig", {
	-- 	t "text: ", i(1), t { "", "copy: " },
	-- 	d(2, function(args)
	-- 			-- the returned snippetNode doesn't need a position; it's inserted
	-- 			-- "inside" the dynamicNode.
	-- 			return sn(nil, {
	-- 				-- jump-indices are local to each snippetNode, so restart at 1.
	-- 				i(1, args[1])
	-- 			})
	-- 		end,
	-- 		{ 1 })
	-- })
	-- 	s("test1",
	-- 		fmta([[test "<>" {
	-- 	<>
	-- }]], {
	-- 			i(1),
	-- 			-- d(0, function(_, snip) return sn(nil, { i(1, snip.env.TM_SELECTED_TEXT) }) end)
	-- 			d(2, function(args)
	-- 				return sn(nil, {
	-- 					i(1, args[1])
	-- 				})
	-- 			end)
	-- 		}),
	-- 		{ condition = conds.line_begin }
	-- 	),

	-- s("trig", fmta("text: <>\ncopy: <>", {
	-- 	i(1), d(2, function(args)
	-- 	return sn(nil, { i(1, args[1]) })
	-- end, { 1 })
	-- }))

}

-- , f(function(_, snip) return snip.env.TM_SELECTED_TEXT or {} end)
