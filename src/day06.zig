const std = @import("std");

pub fn p1(input: []const u8) !u64 {
    var operator_buf: [1000]Operator = undefined;
    var operator_list: []Operator = undefined;
    var value_buf: [1000]u64 = [_]u64{0} ** 1000;
    var value_list: []u64 = undefined;

    var iterator_line = std.mem.splitBackwardsSequence(u8, input, "\n");
    var first_line = true;
    while (iterator_line.next()) |line| {
        const line_clean = std.mem.trim(u8, line, " ");
        if (first_line) {
            operator_list = Operator.parse(line_clean, &operator_buf);
            value_list = value_buf[0..operator_list.len];
            first_line = false;
            continue;
        }

        var iterator_column = std.mem.tokenizeAny(u8, line_clean, " x"); // x is for testing
        var i: u64 = 0;
        while (iterator_column.next()) |cell| : (i += 1) {
            const n = try std.fmt.parseInt(u64, cell, 10);
            value_list[i] = operator_list[i].calc(value_list[i], n);
        }
    }

    var sum: u64 = 0;
    for (value_list) |value| {
        sum += value;
    }
    return sum;
}

const Operator = enum {
    addition,
    multiplication,

    fn calc(self: Operator, a: u64, b: u64) u64 {
        return switch (self) {
            .addition => a + b,
            .multiplication => if (a == 0) b else a * b,
        };
    }

    fn parse(line: []const u8, buf: []Operator) []Operator {
        var cell_len: usize = 0;

        var iterator_cell = std.mem.tokenizeAny(u8, line, " x");
        while (iterator_cell.next()) |cell| {
            std.debug.assert(cell.len == 1);

            buf[cell_len] = switch (cell[0]) {
                '+' => .addition,
                '*' => .multiplication,
                else => unreachable,
            };
            cell_len += 1;
            std.debug.assert(cell_len <= buf.len);
        }
        return buf[0..cell_len];
    }
};

pub fn p2(input: []const u8) !u64 {
    const line_len: i64 = @intCast(std.mem.indexOf(u8, input, "\n").? + 1);
    var last_line_index = (std.mem.lastIndexOf(u8, input, "\n").? + 1);

    var sum: u64 = 0;
    var column_var: u64 = 0;
    var operator: Operator = undefined;
    while (last_line_index < input.len) : (last_line_index += 1) {
        const item = input[last_line_index];

        switch (item) {
            '+' => {
                operator = Operator.addition;
                sum += column_var;
                column_var = 0;
            },
            '*' => {
                operator = Operator.multiplication;
                sum += column_var;
                column_var = 1;
            },
            else => {},
        }

        var i: i64 = @as(i64, @intCast(last_line_index)) - line_len;
        var pos: u64 = 0;
        var num: u64 = 0;
        while (i >= 0) : (i -= line_len) {
            const digit = input[@intCast(i)];
            if (digit == ' ' or digit == 'x') { // x is for testing, since last space gets removed from editor.
                continue;
            }

            const n = digit - '0';
            num += n * pow10(pos);
            pos += 1;
        }
        if (num == 0) {
            continue;
        }

        column_var = operator.calc(column_var, num);
    }
    sum += column_var;

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
    try std.testing.expectEqual(4277556, got);
}

test "p2" {
    const got = try p2(test_input);
    try std.testing.expectEqual(3263827, got);
}

const test_input =
    \\123 328  51 64x
    \\ 45 64  387 23x
    \\  6 98  215 314
    \\*   +   *   +xx
;
