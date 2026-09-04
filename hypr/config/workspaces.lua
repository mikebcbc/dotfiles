-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Named workspaces come from NAMED_WSPACES in variables.lua.
for _, ws in ipairs(NAMED_WSPACES) do
    hl.workspace_rule({ workspace = "name:" .. ws, monitor = MONITOR1, persistent = true })
end
hl.workspace_rule({ workspace = "name:Gaming", monitor = PRIMARY_MONITOR, default = false })
-- hl.workspace_rule({ workspace = "2", monitor = MONITOR1, default = true, persistent = true })
-- hl.workspace_rule({ workspace = "3", monitor = MONITOR1, default = true, persistent = true })
-- hl.workspace_rule({ workspace = "4", monitor = MONITOR2, default = true, persistent = true })
-- hl.workspace_rule({ workspace = "5", monitor = MONITOR2, default = true, persistent = true })
-- hl.workspace_rule({ workspace = "6", monitor = MONITOR2, default = true, persistent = true })

-- For other layouts such as scrolling, see example below
-- hl.workspace_rule({ workspace = "1", monitor = MONITOR1, default = true, persistent = true, layout = scroling })
