const std = @import("std");
const testing = std.testing;

const SwayError = error{ SwaySocketNotFound, SwayHeaderNotRead, SwayPayloadNotRead };
const SwayNode = struct { focused: ?bool, pid: ?usize = 0, nodes: ?[]SwayNode };

pub fn getPidOfFocusedWindow() !usize {
    // open socket
    const path = std.posix.getenv("SWAYSOCK") orelse return SwayError.SwaySocketNotFound;
    const socket = try std.net.connectUnixSocket(path);
    defer socket.close();

    // send get tree and read header
    try socket.writeAll("i3-ipc" ++ .{ 0, 0, 0, 0, 4, 0, 0, 0 });
    var header: [14]u8 = undefined;
    if (try socket.readAtLeast(&header, header.len) != header.len)
        return SwayError.SwayHeaderNotRead;

    // read payload
    const payload_len_i32 = std.mem.readPackedIntNative(i32, header[6..10], 0);
    const payload_len: usize = @intCast(@as(i32, @truncate(payload_len_i32)));
    const allocator = std.heap.page_allocator;
    const payload = try allocator.alloc(u8, payload_len);
    defer allocator.free(payload);

    if (try socket.readAtLeast(payload, payload_len) != payload_len)
        return SwayError.SwayPayloadNotRead;

    // parse json
    const parsed = try std.json.parseFromSlice(SwayNode, allocator, payload, .{ .ignore_unknown_fields = true });
    defer parsed.deinit();

    var nodes = [_]SwayNode{parsed.value};
    return focusedNode(&nodes);
}

fn focusedNode(nodes: []SwayNode) usize {
    for (nodes) |node| {
        if (node.focused) |focused| if (focused) return node.pid orelse 0;
        if (node.nodes) |children| {
            const focused = focusedNode(children);
            if (focused > 0) return focused;
        }
    }

    return 0;
}
