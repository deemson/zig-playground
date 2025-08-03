const sokol = @import("sokol");

pub fn main() !void {
    sokol.app.run(sokol.app.Desc{
        .width = 640,
        .height = 480,
        .window_title = "Just Window",
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
    });
}

fn init() callconv(.c) void {}

fn frame() callconv(.c) void {}

fn cleanup() callconv(.c) void {}
