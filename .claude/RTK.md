# RTK - Rust Token Killer

**Usage**: Token-optimized CLI proxy (60-90% savings on dev operations)

## Meta Commands (always use rtk directly)

```bash
rtk gain              # Show token savings analytics
rtk gain --history    # Show command usage history with savings
rtk discover          # Analyze Claude Code history for missed opportunities
rtk proxy <cmd>       # Execute raw command without filtering (for debugging)
```

## Installation Verification

```bash
rtk --version         # Should show: rtk X.Y.Z
rtk gain              # Should work (not "command not found")
which rtk             # Verify correct binary
```

⚠️ **Name collision**: If `rtk gain` fails, you may have reachingforthejack/rtk (Rust Type Kit) installed instead.

## Hook-Based Usage

All other commands are automatically rewritten by the Claude Code hook.
Example: `git status` → `rtk git status` (transparent, 0 tokens overhead)

## Tool Override: Prefer Bash Over Built-in Tools

The rtk hook only intercepts Bash tool calls. Claude Code's built-in tools (Read, Grep, Glob) bypass Bash and produce uncompressed output, wasting tokens.

**IMPORTANT — override default tool selection:**

- **Reading files**: Use `Bash(cat <file>)` instead of the Read tool → hook rewrites to `rtk read`
- **Searching file contents**: Use `Bash(rg <pattern>)` instead of the Grep tool → hook rewrites to `rtk grep`
- **Listing/finding files**: Use `Bash(ls <path>)` or `Bash(fd <pattern>)` instead of the Glob tool → hook rewrites to `rtk ls` / `rtk find`
- **Git operations**: Use `Bash(git <cmd>)` → hook rewrites to `rtk git`

This applies to **exploratory/read operations only**. Continue using the Edit and Write tools for modifications (they don't produce large output).

Refer to CLAUDE.md for full command reference.
