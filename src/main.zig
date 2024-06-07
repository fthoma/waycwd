const std = @import("std");
const sway = @import("sway.zig");
const proc = @import("proc.zig");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var args = std.process.args();
    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "version")) {
            try stdout.print("{s}\n", .{@import("config").version});
            return;
        }
    }

    const pid = sway.getPidOfFocusedWindow() catch |err| {
        std.log.info("main.getPidOfFocusedWindow: {}", .{err});
        var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
        const path = try std.fs.cwd().realpath(".", &path_buffer);
        try stdout.print("{s}\n", .{path});
        return;
    };

    var buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const child_cwd = proc.getLastChildCwd(pid, &buffer);
    try stdout.print("{s}\n", .{child_cwd});
}
