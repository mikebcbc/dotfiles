function sesh
    nvim -c ":lua MiniSessions.read('$argv')"
end
