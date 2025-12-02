const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const day = b.option(u8, "ay", "Which day to run (1-12)") orelse {
        std.debug.print(
            \\
            \\ERROR: No day specified!
            \\
            \\Usage: zig build run -Day=<number>
            \\Example: zig build run -Day=2
            \\
            \\
        , .{});
        std.process.exit(1);
    };

    const options = b.addOptions();
    options.addOption(u8, "selected_day", day);

    const exe = b.addExecutable(.{
        .name = "aoc2025",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.root_module.addOptions("build_options", options);

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    // Test step
    const day_test_file = std.fmt.allocPrint(
        b.allocator,
        "src/day{d:0>2}.zig",
        .{day},
    ) catch @panic("OOM");

    const day_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path(day_test_file),
            .target = target,
            .optimize = optimize,
        }),
    });

    const run_day_tests = b.addRunArtifact(day_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_day_tests.step);
}
