-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Named workspaces come from NAMED_WSPACES in variables.lua.
for _, ws in ipairs(NAMED_WSPACES) do
	hl.workspace_rule({
		workspace = "name:" .. ws,
		persistent = true,
		default = (ws == "Primary"),
	})
end
hl.workspace_rule({ workspace = "name:Gaming", default = false })
