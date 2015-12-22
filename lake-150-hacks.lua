return function(lake)
	lake.rule {
		rule = { class = "MPlayer" },
		properties = { floating = true }
	}
	lake.rule {
		rule = { class = "pinentry" },
		properties = { floating = true }
	}
	lake.rule {
		rule = { class = "gimp" },
		properties = { floating = true }
	}
    -- Set Firefox to always map on tags number 2 of screen 1.
    --[[
    lake.rule {
		rule = { class = "Firefox" },
		properties = { tag = tags[1][2] }
	}
	]]
end
