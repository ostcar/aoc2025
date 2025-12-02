const std = @import("std");

pub fn p1(input: []const u8) !u64 {
    var iterator_part = std.mem.splitSequence(u8, input, ",");
    var sum: u64 = 0;

    while (iterator_part.next()) |part| {
        const dash_idx = std.mem.indexOf(u8, part, "-").?;
        var cur = try std.fmt.parseInt(u64, part[0..dash_idx], 10);
        const end = try std.fmt.parseInt(u64, part[dash_idx + 1 ..], 10);
        while (cur <= end) : (cur += 1) {
            var digits = base10_digits(cur);
            if (digits % 2 != 0) {
                cur = pow10(digits);
                if (cur > end) {
                    break;
                }
                digits += 1;
            }

            const half_base = pow10(digits / 2);
            const left = cur / half_base;
            const right = cur % half_base;
            if (left == right) {
                sum += cur;
            }
        }
    }
    return sum;
}

pub fn p2(input: []const u8) !u64 {
    var iterator_part = std.mem.splitSequence(u8, input, ",");
    var sum: u64 = 0;

    while (iterator_part.next()) |part| {
        const dash_idx = std.mem.indexOf(u8, part, "-").?;
        var cur = try std.fmt.parseInt(u64, part[0..dash_idx], 10);
        const end = try std.fmt.parseInt(u64, part[dash_idx + 1 ..], 10);

        while (cur <= end) : (cur += 1) {
            if (p2_invalid_id(cur)) {
                sum += cur;
            }
        }
    }
    return sum;
}

fn p2_invalid_id(cur: u64) bool {
    const digits = base10_digits(cur);
    const half_digits = (digits / 2);

    outer: for (1..half_digits + 1) |probe_len| {
        const probe = cur % pow10(probe_len);
        var tmp = cur / pow10(probe_len);
        while (tmp > 0) : (tmp /= pow10(probe_len)) {
            const cur_part = tmp % pow10(probe_len);
            if (probe != cur_part or base10_digits(cur_part) != probe_len) {
                continue :outer;
            }
        }
        return true;
    }
    return false;
}

test "p2_invalid" {
    try std.testing.expectEqual(false, p2_invalid_id(10101));
}

fn base10_digits(i: u64) u64 {
    var count: u64 = 0;
    var n = i;
    while (n > 0) : (n /= 10) {
        count += 1;
    }
    return count;
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
    try std.testing.expectEqual(1227775554, got);
}

test "p2" {
    const got = try p2(test_input);
    try std.testing.expectEqual(4174379265, got);
}

const test_input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
