--
-- Name:        premake-wix/wix.lua
-- Purpose:     Define the WindowsPhone action(s).
-- Author:      Michael Schwarcz
-- Created:     2016/11/03
-- Copyright:   (c) 2016 Michael Schwarcz
--

	local p = premake

	p.modules.wp = {}

	local m = p.modules.wp

	function p.config.isArmArch(cfg)
		return cfg.architecture == p.ARM or cfg.architecture == p.ARM64
	end

--
-- Patch actions
--

	include( "_preload.lua" )
	include( "actions/vstudio.lua" )

	return m