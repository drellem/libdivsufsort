const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.


    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "divsufsort",
        .target = target,
        .optimize = optimize,
    });

    // const t = lib.target_info.target;

    
    lib.addCSourceFiles(&generic_src_files, &.{});

    lib.defineCMacro("HAVE_STDLIB_H", "1");
    lib.defineCMacro("INLINE", "inline");
    lib.defineCMacro("PROJECT_VERSION_FULL", "\"0.0.1\"");
    
    lib.linkLibC();

    const config_header = b.addConfigHeader(.{
        .style = .{ .cmake = .{ .path = "include/config.h.cmake" } },
        }, .{
        .HAVE_INTTYPES_H = 1,
        .HAVE_STDDEF_H = 1,
        .HAVE_STDINT_H = 1,
        .HAVE_STDLIB_H = 1,
        .HAVE_STRING_H = 1,
        .HAVE_STRINGS_H = 1,
        .HAVE_MEMORY_H = 1,
        .HAVE_SYS_TYPES_H = 1,
    });
    lib.addConfigHeader(config_header);
    lib.installConfigHeader(config_header, .{});

    const config_header2 = b.addConfigHeader(.{
        .style = .{ .cmake = .{ .path = "include/divsufsort.h.cmake" } },
        .include_path = "divsufsort.h",
        }, .{
        .HAVE_INTTYPES_H = 1,
        .HAVE_STDDEF_H = 1,
        .HAVE_STDINT_H = 1,
        .HAVE_STDLIB_H = 1,
        .HAVE_STRING_H = 1,
        .HAVE_STRINGS_H = 1,
        .HAVE_MEMORY_H = 1,
        .HAVE_SYS_TYPES_H = 1,
        .W64BIT = "",
        .SAINDEX_TYPE = "long",
        .SAUCHAR_TYPE = "unsigned char",
        .SAINT32_TYPE = "int",
        .SAINT64_TYPE = "long"
    });
    lib.addConfigHeader(config_header2);
    lib.installConfigHeader(config_header2, .{});
    
    lib.addIncludePath("include");
    lib.installHeadersDirectory("include", "");
    b.installArtifact(lib);
}

const generic_src_files = [_][]const u8{
    "lib/divsufsort.c",
    "lib/sssort.c",
    "lib/trsort.c",
    "lib/utils.c",
};
