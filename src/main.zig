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
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const p1_start = std.time.milliTimestamp();
    const p1_solution = try callP(day.p1, allocator, day_input);
    const p1_duration = std.time.milliTimestamp() - p1_start;
    std.debug.print("Part 1 ({} ms): {}\n", .{ p1_duration, p1_solution });

    const p2_start = std.time.milliTimestamp();
    const p2_solution = try callP(day.p2, allocator, day_input);
    const p2_duration = std.time.milliTimestamp() - p2_start;
    std.debug.print("Part 2 ({} ms): {}\n", .{ p2_duration, p2_solution });
}

fn callP(comptime function: anytype, allocator: std.mem.Allocator, input: []const u8) !u64 {
    if (comptime needsAllocator(function)) {
        return function(allocator, input);
    } else {
        return function(input);
    }
}

fn needsAllocator(comptime func: anytype) bool {
    return @typeInfo(@TypeOf(func)).@"fn".params[0].type == std.mem.Allocator;
}
