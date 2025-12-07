const std = @import("std");
const Queue = std.ArrayList(usize);

pub fn p1(allocator: std.mem.Allocator, input: []const u8) !u64 {
    const start = std.mem.indexOf(u8, input, "S").?;

    var queue = Queue{};
    defer queue.deinit(allocator);

    var found_list = Queue{};
    defer found_list.deinit(allocator);

    const line_len = std.mem.indexOf(u8, input, "\n").? + 1;

    try queue.append(allocator, start);
    var i: u64 = 0;
    while (i < queue.items.len) : (i += 1) {
        const found = goDown(input, line_len, queue.items[i]) orelse continue;

        if (std.mem.indexOfScalar(usize, found_list.items, found) != null) {
            continue;
        }

        try found_list.append(allocator, found);

        try addToQueue(allocator, &queue, found);
    }

    return found_list.items.len;
}

fn goDown(input: []const u8, line_len: usize, start: usize) ?usize {
    var i = start + line_len;
    while (i < input.len) : (i += line_len) {
        if (input[i] == '^') {
            return i;
        }
    }
    return null;
}

fn addToQueue(allocator: std.mem.Allocator, queue: *Queue, splitter_idx: u64) std.mem.Allocator.Error!void {
    if (std.mem.indexOfScalar(usize, queue.items, splitter_idx - 1) == null) {
        try queue.append(allocator, splitter_idx - 1);
    }

    if (std.mem.indexOfScalar(usize, queue.items, splitter_idx + 1) == null) {
        try queue.append(allocator, splitter_idx + 1);
    }
}

pub fn p2(allocator: std.mem.Allocator, input: []const u8) !u64 {
    const start = std.mem.indexOf(u8, input, "S").?;
    const line_len = std.mem.indexOf(u8, input, "\n").? + 1;
    const line_count = std.mem.count(u8, input, "\n");
    const tachyon_amount = try allocator.alloc(u64, line_len);
    defer allocator.free(tachyon_amount);
    @memset(tachyon_amount, 0);

    tachyon_amount[start] = 1;
    var cur_line: u64 = 2;
    while (cur_line < line_count) : (cur_line += 2) {
        const line = input[cur_line * line_len ..][0..line_len];
        for (line, 0..) |e, i| {
            if (e == '^') {
                tachyon_amount[i - 1] += tachyon_amount[i];
                tachyon_amount[i + 1] += tachyon_amount[i];
                tachyon_amount[i] = 0;
            }
        }
    }

    var sum: u64 = 0;
    for (tachyon_amount) |v| {
        sum += v;
    }

    return sum;
}

test "p1" {
    const allocator = std.testing.allocator;
    const got = try p1(allocator, test_input);
    try std.testing.expectEqual(21, got);
}

test "p2" {
    const allocator = std.testing.allocator;
    const got = try p2(allocator, test_input);
    try std.testing.expectEqual(40, got);
}
const test_input =
    \\.......S.......
    \\...............
    \\.......^.......
    \\...............
    \\......^.^......
    \\...............
    \\.....^.^.^.....
    \\...............
    \\....^.^...^....
    \\...............
    \\...^.^...^.^...
    \\...............
    \\..^...^.....^..
    \\...............
    \\.^.^.^.^.^...^.
    \\...............
;
