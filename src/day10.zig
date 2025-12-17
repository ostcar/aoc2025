const std = @import("std");

pub fn p1(allocator_orig: std.mem.Allocator, input: []const u8) !u64 {
    var arena = std.heap.ArenaAllocator.init(allocator_orig);
    defer arena.deinit();
    const allocator = arena.allocator();

    var iterator = std.mem.splitSequence(u8, input, "\n");
    var sum: u64 = 0;
    while (iterator.next()) |line| {
        const m = try Machine.parse(allocator, line);
        sum += m.p1();
    }
    return sum;
}

const Lights = std.bit_set.IntegerBitSet(10);

const Machine = struct {
    lights: Lights,
    lights_len: u8,
    buttons: [][]u8,

    fn p1(self: Machine) u64 {
        var count: u64 = 0;
        while (count <= 100) : (count += 1) {
            const highest_number = std.math.powi(u64, self.buttons.len, count) catch undefined;
            for (0..highest_number) |i| {
                if (self.pressButtonList(i, count)) {
                    return count;
                }
            }
        }
        @panic("not found");
    }

    fn pressButtonList(self: Machine, n: u64, count: u64) bool {
        var result = Lights.initEmpty();

        var next = n;

        var i: u64 = 0;
        while (i < count) : (i += 1) {
            const cur = next % self.buttons.len;
            next /= self.buttons.len;

            result = pressButtons(self.buttons[cur], result);
        }

        return result == self.lights;
    }

    fn pressButtons(buttons: []u8, lights: Lights) Lights {
        var result = lights;
        for (buttons) |b| {
            result.toggle(b);
        }
        return result;
    }

    fn parse(allocator: std.mem.Allocator, line: []const u8) !Machine {
        var lights = Lights.initEmpty();

        var i: u64 = 0;
        while (line[i] != '\n') : (i += 1) {
            const e = line[i];
            if (e == ']') {
                break;
            }

            if (e == '#') {
                lights.set(i - 1);
            }
        }

        const lights_len: u8 = @intCast(i - 1);

        i += 2;

        const button_count = std.mem.count(u8, line, "(");
        var button_list = try allocator.alloc([]u8, button_count);
        var button_cur: u8 = 0;
        var button_group = std.ArrayList(u8){};
        while (i < line.len) : (i += 1) {
            const e = line[i];
            switch (e) {
                ' ', '(', ',' => continue,
                ')' => {
                    button_list[button_cur] = button_group.items;
                    button_cur += 1;
                    button_group = std.ArrayList(u8){};
                    continue;
                },
                '0'...'9' => {
                    try button_group.append(allocator, e - '0');
                },
                '{' => break,
                else => {
                    std.debug.print("Error: invalid input '{c}' at pos {d}\n", .{ e, i });
                    @panic("invalid input ");
                },
            }
        }

        return Machine{ .lights = lights, .lights_len = lights_len, .buttons = button_list };
    }
};

pub fn p2(allocator: std.mem.Allocator, input: []const u8) !u64 {
    _ = allocator;
    _ = input;
    return error.NotImplemented;
}

test "p1" {
    const allocator = std.testing.allocator;
    const got = try p1(allocator, test_input);
    try std.testing.expectEqual(7, got);
}

// test "pressButtonList" {
//     const allocator = std.testing.allocator;
//     const line = "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1)";
//     const m = try Machine.parse(allocator, line);
//     try std.testing.expect(m.pressButtonList(0, 3));
// }

test "p2" {
    const allocator = std.testing.allocator;
    const got = try p2(allocator, test_input);
    try std.testing.expectEqual(99999999999999999, got);
}

const test_input =
    \\[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    \\[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
    \\[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
;
