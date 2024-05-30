const std = @import("std");
const sway = @import("sway.zig");
const proc = @import("proc.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const pid = sway.getPidOfFocusedWindow() catch |err| {
        std.debug.print("ERROR: {}\n", .{err});
        try stdout.print("~\n", .{});
        return;
    };

    const procPid = proc.getLastChildCwd(pid);
    try stdout.print("{s}\n", .{procPid});
}
