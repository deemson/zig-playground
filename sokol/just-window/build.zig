const std = @import("std");
const Build = std.Build;
const OptimizeMode = std.builtin.OptimizeMode;

pub fn build(b: *Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const dep_sokol = b.dependency("sokol", .{
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{
        .name = "just-window",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{
                    .name = "sokol",
                    .module = dep_sokol.module("sokol"),
                },
            },
        }),
    });
    b.installArtifact(exe);
    const run = b.addRunArtifact(exe);
    b.step("run", "").dependOn(&run.step);
}
