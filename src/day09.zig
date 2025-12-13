const std = @import("std");

pub fn p1(allocator: std.mem.Allocator, input: []const u8) !u64 {
    const points = try parse(allocator, input);
    defer allocator.free(points);

    var max: u64 = 0;
    for (points, 0..) |point1, i| {
        for (points[i + 1 ..]) |point2| {
            const square = point1.square(point2);
            //std.debug.print("checking point {d}, {d} against {d}, {d}: square: {d}\n", .{ point1.x, point1.y, point2.x, point2.y, square });
            if (square > max) {
                max = square;
            }
        }
    }
    return max;
}

const Point = struct {
    x: u64,
    y: u64,

    fn parse(line: []const u8) !Point {
        const comma_idx = std.mem.indexOf(u8, line, ",").?;
        const x = try std.fmt.parseInt(u64, line[0..comma_idx], 10);
        const y = try std.fmt.parseInt(u64, line[comma_idx + 1 ..], 10);
        return Point{ .x = x, .y = y };
    }

    fn square(self: Point, other: Point) u64 {
        return (dist(self.x, other.x) + 1) * (dist(self.y, other.y) + 1);
    }
};

fn parse(allocator: std.mem.Allocator, input: []const u8) ![]Point {
    const line_count = std.mem.count(u8, input, "\n");
    var points = try allocator.alloc(Point, line_count + 1);
    var iterator = std.mem.splitSequence(u8, input, "\n");

    var i: u64 = 0;
    while (iterator.next()) |line| : (i += 1) {
        points[i] = try Point.parse(line);
    }
    return points;
}

fn dist(a: u64, b: u64) u64 {
    if (a > b) {
        return a - b;
    }
    return b - a;
}

pub fn p2(input: []const u8) !u64 {
    _ = input;
    return error.NotImplemented;
}

test "p1" {
    const allocator = std.testing.allocator;
    const got = try p1(allocator, test_input);
    try std.testing.expectEqual(50, got);
}

test "p2" {
    const got = try p2(test_input);
    try std.testing.expectEqual(99999999999999999, got);
}

const test_input =
    \\7,1
    \\11,1
    \\11,7
    \\9,7
    \\9,5
    \\2,5
    \\2,3
    \\7,3
;
