--
-- Name:        premake-wp/_preload.lua
-- Purpose:     Define the Windows Phone API's.
-- Author:      Michael Schwarcz
-- Created:     2016/11/03
-- Copyright:   (c) 2016 Michael Schwarcz
--

	local p = premake
	local api = p.api

--
-- Register the WP extension
--

	p.ARM = "ARM"
	p.ARM64 = "ARM64"
	api.addAllowed("architecture", { p.ARM, p.ARM64 })

--
-- Decide when to load the full module
--

	return function (cfg)
		return p.config.isArmArch(cfg)
	end
