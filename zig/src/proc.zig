const std = @import("std");

pub fn getLastChildCwd(parent_pid: usize, buffer: *[std.fs.MAX_PATH_BYTES]u8) []const u8 {
    const last_child = getLastChild(parent_pid);

    var path_buffer: [std.fs.MAX_PATH_BYTES]u8 = undefined;
    const path = std.fmt.bufPrint(&path_buffer, "/proc/{d}/cwd", .{last_child}) catch |err| {
        std.debug.print("ERROR: {}\n", .{err});
        return std.fs.cwd().realpath(".", buffer) catch |errcwd| {
            std.debug.print("ERROR: {}\n", .{errcwd});
            return "/";
        };
    };

    const cwd = std.fs.readLinkAbsolute(path, buffer) catch |err| {
        std.debug.print("ERROR: {}\n", .{err});
        return std.fs.cwd().realpath(".", buffer) catch |errcwd| {
            std.debug.print("ERROR: {}\n", .{errcwd});
            return "/";
        };
    };

    return cwd;
}

fn getLastChild(parent_pid: usize) usize {
    var buffer: [256]u8 = undefined;
    const path = std.fmt.bufPrint(&buffer, "/proc/{d}/task/{d}/children", .{ parent_pid, parent_pid }) catch |err| {
        std.debug.print("ERROR: {}\n", .{err});
        return 0;
    };

    const file = std.fs.openFileAbsolute(path, .{}) catch |err| {
        std.debug.print("ERROR: {s} {}\n", .{ &buffer, err });
        return 0;
    };
    defer file.close();

    const bytes_read = file.readAll(&buffer) catch |err| {
        std.debug.print("ERROR: {s} {}\n", .{ &buffer, err });
        return 0;
    };

    var children = std.mem.split(u8, buffer[0..bytes_read], " ");
    const first_child = std.mem.trim(u8, children.first(), " ");
    if (first_child.len == 0) return 0;

    const child_pid = std.fmt.parseInt(usize, first_child, 10) catch |err| {
        std.debug.print("ERROR: {} '{s}'\n", .{ err, first_child });
        return 0;
    };

    if (child_pid == 0)
        return parent_pid;

    const my_child = getLastChild(child_pid);
    if (my_child > 0)
        return my_child;

    return child_pid;
}
