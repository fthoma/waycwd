const std = @import("std");
const sway = @import("sway.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const pid = sway.getPidOfFocusedWindow() catch |err| {
        std.debug.print("ERROR: {}\n", .{err});
        try stdout.print("~\n", .{});
        return;
    };

    try stdout.print("pid of focused window {}\n", .{pid});
}
