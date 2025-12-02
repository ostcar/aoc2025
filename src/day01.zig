const std = @import("std");

pub fn p1(input: []const u8) !u64 {
    var state: i32 = 50;
    var count: u64 = 0;
    var iterator = std.mem.splitSequence(u8, input, "\n");

    while (iterator.next()) |line| {
        const n = try std.fmt.parseInt(i32, line[1..], 10);
        switch (line[0]) {
            'L' => state = @mod(state - n, 100),
            'R' => state = @mod(state + n, 100),
            else => @panic("Unknown state"),
        }
        if (state == 0) {
            count += 1;
        }
    }
    return count;
}

pub fn p2(input: []const u8) !u64 {
    var state: i32 = 50;
    var count: usize = 0;
    var iterator = std.mem.splitSequence(u8, input, "\n");

    while (iterator.next()) |line| {
        const n = try std.fmt.parseInt(i32, line[1..], 10);
        var start_at_0 = state == 0;
        switch (line[0]) {
            'L' => state -= n,
            'R' => state += n,
            else => @panic("Unknown line"),
        }
        while (state < 0) {
            state += 100;
            if (start_at_0) {
                start_at_0 = false;
                continue;
            }
            count += 1;
        }
        while (state > 99) {
            state -= 100;
            count += 1;
        }
        if (line[0] == 'L' and state == 0) {
            count += 1;
        }
    }
    return count;
}

test "p2" {
    const got = try p2(test_input);
    try std.testing.expectEqual(6, got);
}

const test_input =
    \\L68
    \\L30
    \\R48
    \\L5
    \\R60
    \\L55
    \\L1
    \\L99
    \\R14
    \\L82
;
