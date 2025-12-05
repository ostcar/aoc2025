const std = @import("std");

pub fn p1(input: []const u8) !u64 {
    const part_del = std.mem.indexOf(u8, input, "\n\n").?;
    const input_fresh = input[0..part_del];
    const input_available = input[part_del + 2 ..];

    var count_fresh: u64 = 0;
    var iterator_available = std.mem.splitSequence(u8, input_available, "\n");
    while (iterator_available.next()) |line| {
        const id = try std.fmt.parseInt(u64, line, 10);
        if (try is_fresh(input_fresh, id)) {
            count_fresh += 1;
        }
    }
    return count_fresh;
}

fn is_fresh(input: []const u8, id: u64) !bool {
    var iterator_range = std.mem.splitSequence(u8, input, "\n");
    while (iterator_range.next()) |line| {
        const dash_idx = std.mem.indexOf(u8, line, "-").?;
        const start = try std.fmt.parseInt(u64, line[0..dash_idx], 10);
        const end = try std.fmt.parseInt(u64, line[dash_idx + 1 ..], 10);
        if (id >= start and id <= end) {
            return true;
        }
    }
    return false;
}

pub fn p2(input: []const u8) !u64 {
    const part_del = std.mem.indexOf(u8, input, "\n\n").?;
    const input_fresh = input[0..part_del];

    const items = blk: {
        var buf: [181]Range = undefined;
        var items_len: usize = 0;
        var iterator_range = std.mem.splitSequence(u8, input_fresh, "\n");
        while (iterator_range.next()) |line| {
            buf[items_len] = try Range.from_line(line);
            items_len += 1;
            std.debug.assert(items_len <= 181);
        }
        break :blk buf[0..items_len];
    };

    std.mem.sort(Range, items, {}, Range.lessThen);

    var count: u64 = 0;
    var cur = items[0];
    for (items[1..]) |other| {
        if (cur.end + 1 >= other.start) {
            cur.end = if (cur.end > other.end) cur.end else other.end;
            continue;
        }
        count += cur.count();
        cur = other;
    }

    count += cur.count();
    return count;
}

const Range = struct {
    start: u64,
    end: u64,

    fn from_line(line: []const u8) !Range {
        const dash_idx = std.mem.indexOf(u8, line, "-").?;
        const start = try std.fmt.parseInt(u64, line[0..dash_idx], 10);
        const end = try std.fmt.parseInt(u64, line[dash_idx + 1 ..], 10);
        return .{ .start = start, .end = end };
    }

    fn lessThen(_: void, a: Range, b: Range) bool {
        return a.start < b.start;
    }

    fn count(self: Range) u64 {
        return self.end - self.start + 1;
    }
};

test "p1" {
    const got = try p1(test_input);
    try std.testing.expectEqual(3, got);
}

test "p2" {
    const got = try p2(test_input);
    try std.testing.expectEqual(14, got);
}

const test_input =
    \\3-5
    \\10-14
    \\16-20
    \\12-18
    \\
    \\1
    \\5
    \\8
    \\11
    \\17
    \\32
;
