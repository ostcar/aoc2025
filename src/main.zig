const std = @import("std");
const build_options = @import("build_options");

const day = switch (build_options.selected_day) {
    1 => @import("day01.zig"),
    2 => @import("day02.zig"),
    3 => @import("day03.zig"),
    4 => @import("day04.zig"),
    5 => @import("day05.zig"),
    6 => @import("day06.zig"),
    else => @compileError("Day not implemented"),
};

const day_input = blk: {
    const filename = std.fmt.comptimePrint("day{d:0>2}.input", .{build_options.selected_day});
    break :blk std.mem.trimRight(u8, @embedFile(filename), "\n");
};

pub fn main() !void {
    const p1_start = std.time.milliTimestamp();
    const p1_solution = try day.p1(day_input);
    const p1_duration = std.time.milliTimestamp() - p1_start;
    std.debug.print("Part 1 ({} ms): {}\n", .{ p1_duration, p1_solution });

    const p2_start = std.time.milliTimestamp();
    const p2_solution = try day.p2(day_input);
    const p2_duration = std.time.milliTimestamp() - p2_start;
    std.debug.print("Part 2 ({} ms): {}\n", .{ p2_duration, p2_solution });
}
