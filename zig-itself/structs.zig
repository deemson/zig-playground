const std = @import("std");

test "inner struct with a method" {
    const Struct = struct {
        const Self = @This();
        fn method(_: Self) void {}
    };
    const s = Struct{};
    s.method();
}
