const std = @import("std");

test "optional destructuring" {
    var maybe_i: ?i8 = null;
    if (maybe_i) |_| {
        @panic("must be null");
    }
    maybe_i = 42;
    if (maybe_i) |i| {
        std.debug.print("i is {d}\n", .{i});
    } else {
        @panic("must not be null");
    }
}

test "error destructuring" {
    const function = struct {
        fn function() !void {
            return error.TestError;
        }
    }.function;
    try std.testing.expectError(error.TestError, function());
    function() catch |err| {
        std.debug.print("this is the error: {}\n", .{err});
    };
}
