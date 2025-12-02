const std = @import("std");

pub fn p1(input: []const u8) !u64 {
    _ = input;
    return error.NotImplemented;
}

pub fn p2(input: []const u8) !u64 {
    _ = input;
    return error.NotImplemented;
}

test "p1" {
    const got = try p1(test_input);
    try std.testing.expectEqual(999999999999999999, got);
}

test "p2" {
    const got = try p2(test_input);
    try std.testing.expectEqual(99999999999999999, got);
}

const test_input = "";
