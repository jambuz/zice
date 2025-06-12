pub const builtin = @import("builtin");

pub const def = @import("os/def.zig");

pub const Tracer = switch (builtin.os.tag) {
    .windows => @import("os/win32/tracer.zig").Tracer,
    .linux => @import("os/linux/tracer.zig").Tracer,
    else => @compileError("Unsupported OS"),
};

pub const Process = switch (builtin.os.tag) {
    .windows => @import("os/win32/process.zig").Process,
    .linux => @import("os/linux/process.zig").Process,
    else => @compileError("Unsupported OS"),
};

test "get regs of tids" {
    const std = @import("std");
    const p = Process.init(null);

    const threads = try p.enumerateThreads();
    for (threads.constSlice()) |t| {
        std.debug.print("Thread ID {d}\n", .{t});
    }
}
