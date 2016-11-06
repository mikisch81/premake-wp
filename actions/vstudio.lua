--
-- Name:        premake-wp/actions/vstudio.lua
-- Purpose:     Define Windows Phone Visual Studio action(s).
-- Author:      Michael Schwarcz
-- Created:     2016/11/03
-- Copyright:   (c) 2016 Michael Schwarcz
--

	local p = premake

	local vstudio = p.vstudio
	local validation = p.validation
	local m = p.vstudio.vc2010

--
-- Validate ARM/ARM64 architecture is given only for vs2013/vs2015 actions
--

	local function verifyActionSupportsArmArch(cfg)
		local action = p.action.current()
		if p.config.isArmArch(cfg) and action.trigger ~= "vs2013" and action.trigger ~= "vs2015" then
			p.error("'%s' architecture configuration is not supported by '%s' action", cfg.architecture, action.trigger)
		end
	end

	premake.override(validation.elements, "config", function(base, cfg)
		local calls = base(cfg)
		if p.config.isArmArch(cfg) then
			table.insertafter(calls, validation.configValuesInScope, verifyActionSupportsArmArch)
		end
		return calls
	end)

--
-- Override the VisualStudio platformToolset function to support WindowsApplicationForDrivers10.0
--

	p.override(m, "platformToolset", function(base, cfg)
		local tool, version = p.config.toolset(cfg)
		if not version then
			local action = p.action.current()
			if action.trigger >= "vs2013" and p.config.isArmArch(cfg) then
				version = "WindowsApplicationForDrivers10.0"
			else
				version = action.vstudio.platformToolset
			end
		end
		if version then
			if cfg.kind == p.NONE or cfg.kind == p.MAKEFILE then
				if p.config.hasFile(cfg, path.iscppfile) then
					m.element("PlatformToolset", nil, version)
				end
			else
				m.element("PlatformToolset", nil, version)
			end
		end
	end)

--
-- Add ARM architecures to the VisualStudio architectures list
--

	if vstudio.vs2010_architectures ~= nil then
		vstudio.vs2010_architectures.ARM = "ARM"
		vstudio.vs2010_architectures.ARM64 = "ARM64"
	end

--
-- Add the DriverTargetPlatform configuration property
--

	local function driverTargetPlatform(cfg)
		local value = iif(_ACTION > "vs2013", "Universal", "Mobile")
		m.element("DriverTargetPlatform", nil, value)
	end

	premake.override(m.elements, "configurationProperties", function(base, cfg)
		local calls = base(cfg)
		if p.config.isArmArch(cfg) then
			table.insertafter(calls, m.platformToolset, driverTargetPlatform)
		end
		return calls
	end)

--
-- Override the VisualStudio exceptionHandling function to support EXPLICIT synchronized C++ exceptions
--

	premake.override(m, "exceptionHandling", function(base, cfg)
		if cfg.exceptionhandling == p.ON then
			m.element("ExceptionHandling", nil, "Sync")
		else
			base(cfg)
		end
	end)
