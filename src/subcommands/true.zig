const std = @import("std");
const subcommands = @import("../subcommands.zig");
const shared = @import("../shared.zig");

const log = std.log.scoped(.@"true");

pub const name = "true";

pub const usage =
    \\Usage: {0s} [ignored command line arguments]
    \\   or: {0s} OPTION
    \\Exit with a status code indicating success.
    \\
    \\     -h, --help  display this help and exit
    \\     --version   output version information and exit
    \\
;

// io
// .{
//     .stderr: std.io.Writer,
//     .stdin: std.io.Reader,
//     .stdout: std.io.Writer,
// },

// args
// struct {
//     fn next(self: *Self) !?shared.Arg,
//
//     // intended to only be called for the first argument
//     fn nextWithHelpOrVersion(self: *Self) !?shared.Arg,
// }

pub fn execute(
    allocator: *std.mem.Allocator,
    io: anytype,
    args: anytype,
) subcommands.Error!u8 {
    const z = shared.tracy.traceNamed(@src(), name);
    defer z.end();

    _ = io;

    var opt_arg: ?shared.Arg = try args.nextWithHelpOrVersion();

    while (opt_arg) |arg| : ({
        arg.deinit(allocator);
        opt_arg = try args.next();
    }) {
        switch (arg) {
            .longhand => {},
            .shorthand => {},
            .longhand_with_value => {},
            .positional => {},
        }
    }

    log.debug("true called", .{});

    return 0;
}

test "true no args" {
    try std.testing.expectEqual(
        @as(u8, 0),
        try subcommands.testExecute(
            @This(),
            &.{},
            .{},
        ),
    );
}

test "true help" {
    try shared.testHelp(@This());
}

test "true version" {
    try shared.testVersion(@This());
}

comptime {
    std.testing.refAllDecls(@This());
}
