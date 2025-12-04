const std = @import("std");
const build_options = @import("build_options");

const day = switch (build_options.selected_day) {
    1 => @import("day01.zig"),
    2 => @import("day02.zig"),
    3 => @import("day03.zig"),
    4 => @import("day04.zig"),
    else => @compileError("Day not implemented"),
};

const day_input = blk: {
    const filename = std.fmt.comptimePrint("day{d:0>2}.input", .{build_options.selected_day});
    break :blk std.mem.trimRight(u8, @embedFile(filename), "\n");
};

pub fn main() !void {
    std.debug.print("Part 1: {}\n", .{try day.p1(day_input)});
    std.debug.print("Part 2: {}\n", .{try day.p2(day_input)});
}
