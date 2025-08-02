const std = @import("std");

test "some" {
    const ArgumentStruct = struct {};
    const MethodStruct = struct {
        const Self = @This();
        fn method(_: *const Self, _: *const ArgumentStruct) void {}
    };
    const method_struct = &MethodStruct{};
    method_struct.method(&ArgumentStruct{});
}
