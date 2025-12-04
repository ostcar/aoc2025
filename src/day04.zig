const std = @import("std");

pub fn p1(input: []const u8) !u64 {
    const around_stuff = around(input);
    var count: u64 = 0;
    for (input, 0..) |element, index| {
        if (element != '@') {
            continue;
        }
        const index_i32: i32 = @intCast(index);
        var count_around: u8 = 0;
        for (around_stuff) |rel| {
            if (is_paper_roll(input, index_i32 + rel)) {
                count_around += 1;
                if (count_around >= 4) {
                    break;
                }
            }
        } else {
            count += 1;
        }
    }
    return count;
}

fn around(map: []const u8) [8]i32 {
    const line_len: i32 = @intCast(std.mem.indexOf(u8, map, "\n") orelse unreachable);
    return [8]i32{ -line_len - 2, -line_len - 1, -line_len, -1, 1, line_len, line_len + 1, line_len + 2 };
}

fn is_paper_roll(map: []const u8, pos: i32) bool {
    if (pos < 0 or pos >= map.len) {
        return false;
    }
    return map[@intCast(pos)] == '@';
}

pub fn p2(input: []const u8) !u64 {
    std.debug.assert(input.len <= 18632);

    var buf: [18632]u8 = undefined;
    @memcpy(buf[0..input.len], input);
    const input_mutable = buf[0..input.len];

    var count: u64 = 0;
    while (true) {
        const found = remove_reachable(input_mutable);
        if (found == 0) {
            break;
        }
        count += found;
    }

    return count;
}

fn remove_reachable(input: []u8) u64 {
    var removed: u64 = 0;
    const around_stuff = around(input);
    for (input, 0..) |element, index| {
        if (element != '@') {
            continue;
        }
        const index_i32: i32 = @intCast(index);
        var count_around: u8 = 0;
        for (around_stuff) |rel| {
            if (is_paper_roll(input, index_i32 + rel)) {
                count_around += 1;
                if (count_around >= 4) {
                    break;
                }
            }
        } else {
            input[index] = '.';
            removed += 1;
        }
    }
    return removed;
}

test "p1" {
    const got = try p1(test_input);
    try std.testing.expectEqual(13, got);
}

test "p2" {
    const got = try p2(test_input);
    try std.testing.expectEqual(43, got);
}

const test_input =
    \\..@@.@@@@.
    \\@@@.@.@.@@
    \\@@@@@.@.@@
    \\@.@@@@..@.
    \\@@.@@@@.@@
    \\.@@@@@@@.@
    \\.@.@.@.@@@
    \\@.@@@.@@@@
    \\.@@@@@@@@.
    \\@.@.@@@.@.
;
