#!/usr/bin/env python3
"""Merge portable Noctalia settings from the dotfiles repo into the local
~/.local/state/noctalia/settings.toml, preserving device-specific sections
(battery D-Bus paths, monitor-specific lockscreen widgets, wallpaper.last, etc.)."""

import os
import shutil
import subprocess
import tomllib

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
REPO_SETTINGS = os.path.join(SCRIPT_DIR, "..", "noctalia", "settings.toml")
HOME = os.path.expanduser("~")
LOCAL_SETTINGS = os.path.join(HOME, ".local", "state", "noctalia", "settings.toml")


def expand_home(value):
    if isinstance(value, dict):
        return {k: expand_home(v) for k, v in value.items()}
    if isinstance(value, list):
        return [expand_home(x) for x in value]
    if isinstance(value, str):
        return value.replace("$HOME", HOME)
    return value


def deep_merge(base, override):
    result = dict(base)
    for k, v in override.items():
        if k in result and isinstance(result[k], dict) and isinstance(v, dict):
            result[k] = deep_merge(result[k], v)
        else:
            result[k] = v
    return result


def fmt(v):
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, str):
        return f'"{v}"'
    if isinstance(v, int):
        return str(v)
    if isinstance(v, float):
        return str(v)
    if isinstance(v, list):
        return "[" + ", ".join(fmt(x) for x in v) + "]"
    raise ValueError(f"Cannot serialize {type(v).__name__}: {v!r}")


def write_toml(data, path=None, lines=None):
    if lines is None:
        lines = []
    leaves = {k: v for k, v in sorted(data.items()) if not isinstance(v, dict)}
    branches = {k: v for k, v in sorted(data.items()) if isinstance(v, dict)}
    if path is not None and leaves:
        lines.append(f"[{path}]")
    for k, v in leaves.items():
        lines.append(f"{k} = {fmt(v)}")
    for k, v in branches.items():
        new_path = f"{path}.{k}" if path else k
        if lines and lines[-1] != "":
            lines.append("")
        write_toml(v, new_path, lines)
    return lines


def main():
    if not os.path.exists(REPO_SETTINGS):
        print(f"Noctalia setup: {REPO_SETTINGS} not found, skipping.")
        return

    with open(REPO_SETTINGS, "rb") as f:
        repo_data = expand_home(tomllib.load(f))

    os.makedirs(os.path.dirname(LOCAL_SETTINGS), exist_ok=True)

    local_data = {}
    if os.path.exists(LOCAL_SETTINGS):
        with open(LOCAL_SETTINGS, "rb") as f:
            local_data = tomllib.load(f)

    merged = deep_merge(local_data, repo_data)
    output = "\n".join(write_toml(merged)) + "\n"
    with open(LOCAL_SETTINGS, "w") as f:
        f.write(output)
    print(f"Noctalia settings merged -> {LOCAL_SETTINGS}")

    if shutil.which("noctalia"):
        wallpaper = os.path.join(HOME, "Pictures", "Wallpapers", "Dueling Planets.jpg")
        for cmd in [
            ["noctalia", "msg", "color-scheme-set", "community", "Vesper"],
            ["noctalia", "msg", "theme-mode-set", "dark"],
            ["noctalia", "msg", "wallpaper-set", wallpaper],
        ]:
            try:
                subprocess.run(cmd, capture_output=True, timeout=5)
            except Exception:
                pass


if __name__ == "__main__":
    main()
