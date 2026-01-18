const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const libogg_dep = b.dependency("libogg", .{
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .name = "vorbis",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
        .linkage = .static,
    });
    lib.root_module.linkLibrary(libogg_dep.artifact("ogg"));
    lib.root_module.addIncludePath(b.path("include"));
    lib.root_module.addIncludePath(b.path("lib"));
    lib.root_module.addCSourceFiles(.{
        .files = &.{
            "lib/analysis.c",
            "lib/bitrate.c",
            "lib/block.c",
            "lib/codebook.c",
            "lib/envelope.c",
            "lib/floor0.c",
            "lib/floor1.c",
            "lib/info.c",
            "lib/lookup.c",
            "lib/lpc.c",
            "lib/lsp.c",
            "lib/mapping0.c",
            "lib/mdct.c",
            "lib/psy.c",
            "lib/registry.c",
            "lib/res0.c",
            "lib/sharedbook.c",
            "lib/smallft.c",
            "lib/synthesis.c",
            "lib/window.c",

            "lib/vorbisfile.c",
            "lib/vorbisenc.c",
        },
    });
    lib.installHeadersDirectory(b.path("include/vorbis"), "vorbis", .{});
    b.installArtifact(lib);
}
