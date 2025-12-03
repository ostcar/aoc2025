const std = @import("std");

pub fn p1(input: []const u8) !u64 {
    var sum: u64 = 0;
    var iterator_line = std.mem.splitSequence(u8, input, "\n");
    while (iterator_line.next()) |line| {
        var first: u8 = 0;
        var first_index: usize = 0;
        for (line[0 .. line.len - 1], 0..) |char, index| {
            if (char > first) {
                first = char;
                first_index = index;
            }
        }

        var second: u8 = 0;
        for (line[first_index + 1 ..]) |char| {
            if (char > second) {
                second = char;
            }
        }

        sum += (first - '0') * 10 + second - '0';
    }
    return sum;
}

pub fn p2(input: []const u8) !u64 {
    var sum: u64 = 0;
    var iterator_line = std.mem.splitSequence(u8, input, "\n");
    while (iterator_line.next()) |line| {
        var digits: [12]u8 = [_]u8{0} ** 12;
        var last_index: usize = 0;
        for (0..12) |i| {
            var cur_index: usize = 0;
            for (line[last_index .. line.len - (12 - i - 1)], 0..) |char, index| {
                if (char > digits[i]) {
                    digits[i] = char;
                    cur_index = last_index + index;
                }
            }
            last_index = cur_index + 1;
        }

        var num: u64 = 0;
        for (digits, 0..) |digit, i| {
            num += (digit - '0') * pow10(12 - i - 1);
        }

        sum += num;
    }
    return sum;
}

fn pow10(n: u64) u64 {
    var result: u64 = 1;
    for (0..n) |_| {
        result *= 10;
    }
    return result;
}

test "p1" {
    const got = try p1(test_input);
    try std.testing.expectEqual(357, got);
}

test "p2" {
    const got = try p2(test_input);
    try std.testing.expectEqual(3121910778619, got);
}

const test_input =
    \\987654321111111
    \\811111111111119
    \\234234234234278
    \\818181911112111
;
