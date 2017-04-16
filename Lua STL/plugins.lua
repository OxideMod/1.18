﻿-- Oxide - Lua Standard Library
-- plugins.lua - Plugins and api system

plugins = {}

function plugins.Find( name )
	return cs.findplugin( name )
end
function plugins.Call( name, ... )
	local args = { ... }
	return cs.callplugins( name, args, #args )
end
function plugins.Reload( name )
	return cs.reloadplugin( name )
end

function plugins.Load( name )
	print("plugins.Load")
	return cs.loadplugin( name )
end
api = {}
local apibindings = {}
function api.Bind( plugin, apiname )
	if (apibindings[ apiname ]) then
		error( "Conflict: more than 1 plugin tried to bind to the same API! (" .. plugin.Title .. ", " .. apibindings[ apiname ].Title .. ")" )
		return false
	end
	apibindings[ apiname ] = plugin
	return true
end
function api.Unbind( apiname )
	local plugin = apibindings[ apiname ]
	if (not plugin) then return false, "No such api found!" end
	plugin = nil
	return true
end
function api.Exists( apiname )
	return apibindings[ apiname ] ~= nil
end
function api.Call( apiname, name, ... )
	local plugin = apibindings[ apiname ]
	if (not plugin) then return false, "No such api found!" end
	local func = plugin[ name ]
	if (not func) then return false, "The specified api does not have that function!" end
	return pcall( func, plugin, ... )
end
function api.HasFunction( apiname, name )
	local plugin = apibindings[ apiname ]
	if (not plugin) then return false, "No such api found!" end
	local func = plugin[ name ]
	if (not func) then return false, "The specified api does not have that function!" end
	return true
end
