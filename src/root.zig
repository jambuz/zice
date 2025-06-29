pub const builtin = @import("builtin");

pub const Tracer = switch (builtin.os.tag) {
    .windows => @import("os/win32/tracer.zig"),
    .linux => @import("os/linux/tracer.zig"),
    else => @compileError("Unsupported OS"),
};

pub const Process = switch (builtin.os.tag) {
    .windows => @import("os/win32/process.zig"),
    .linux => @import("os/linux/process.zig"),
    else => @compileError("Unsupported OS"),
};

test "tids" {
    const std = @import("std");
    const threads = try Process.enumerateThreads(1753);

    for (threads.constSlice()) |t| {
        std.debug.print("TID: {d}\n", .{t});
    }
}
