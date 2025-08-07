const sokol = @import("sokol");
const sapp = sokol.app;
const sg = sokol.gfx;
const slog = sokol.log;
const sglue = sokol.glue;
const shd = @import("shader");

pub fn main() !void {
    sapp.run(sapp.Desc{
        .width = 640,
        .height = 480,
        .window_title = "Triangle",
        .init_cb = init,
        .frame_cb = frame,
        .cleanup_cb = cleanup,
    });
}

var state = struct {
    bindings: sg.Bindings,
    pipeline: ?sg.Pipeline,
    pass_action: sg.PassAction,
}{ .bindings = sg.Bindings{}, .pipeline = null, .pass_action = sg.PassAction{} };

fn init() callconv(.c) void {
    sg.setup(sg.Desc{
        .environment = sglue.environment(),
        .logger = sg.Logger{
            .func = slog.func,
        },
    });
    const vertices = [_]f32{
        // positions     // colors
        0.0,  0.5,  0.5, 1.0, 0.0, 0.0, 1.0,
        0.5,  -0.5, 0.5, 0.0, 1.0, 0.0, 1.0,
        -0.5, -0.5, 0.5, 0.0, 0.0, 1.0, 1.0,
    };
    state.bindings.vertex_buffers[0] = sg.makeBuffer(sg.BufferDesc{
        .label = "triangle-vertices",
        .data = sg.asRange(&vertices),
    });
    var pipelineDesc = sg.PipelineDesc{
        .label = "triangle-pipeline",
        .shader = sg.makeShader(shd.triangleShaderDesc(sg.queryBackend())),
    };
    pipelineDesc.layout.attrs[shd.ATTR_triangle_position].format = .FLOAT3;
    pipelineDesc.layout.attrs[shd.ATTR_triangle_color0].format = .FLOAT4;
    state.pipeline = sg.makePipeline(pipelineDesc);
    state.pass_action.colors[0] = .{
        .load_action = .CLEAR,
        .clear_value = .{ .r = 0, .g = 0, .b = 0, .a = 1 },
    };
}

fn frame() callconv(.c) void {
    sg.beginPass(sg.Pass{
        .action = state.pass_action,
        .swapchain = sglue.swapchain(),
    });
    sg.applyPipeline(state.pipeline.?);
    sg.applyBindings(state.bindings);
    sg.draw(0, 3, 1);
    sg.endPass();
    sg.commit();
}

fn cleanup() callconv(.c) void {
    sg.shutdown();
}
