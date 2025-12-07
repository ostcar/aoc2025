const std = @import("std");

pub fn p1(allocator: std.mem.Allocator, input: []const u8) !u64 {
    _ = allocator;
    _ = input;
    return error.NotImplemented;
}

pub fn p2(allocator: std.mem.Allocator, input: []const u8) !u64 {
    _ = allocator;
    _ = input;
    return error.NotImplemented;
}

test "p1" {
    const allocator = std.testing.allocator;
    const got = try p1(allocator, test_input);
    try std.testing.expectEqual(999999999999999999, got);
}

test "p2" {
    const allocator = std.testing.allocator;
    const got = try p2(allocator, test_input);
    try std.testing.expectEqual(99999999999999999, got);
}

const test_input = "";
