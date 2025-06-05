pub const builtin = @import("builtin");

pub const def = @import("def.zig");

pub const Tracer = switch (builtin.os.tag) {
    .windows => @import("tracer/windows.zig").Tracer,
    .linux => @import("tracer/linux.zig").Tracer,
    else => @compileError("Unsupported OS"),
};

pub const Process = switch (builtin.os.tag) {
    .windows => @import("proc/windows.zig").Process,
    .linux => @import("proc/linux.zig").Process,
    else => @compileError("Unsupported OS"),
};

test "get regs of tids" {
    const std = @import("std");
    const p = Process.init(null);

    const threads = try p.enumerateThreads();
    for (threads.constSlice()) |t| {
        const tracer = Tracer.init(t);
        const regs = try tracer.follow();
        std.debug.print("regs: of {d}: {}\n", .{ t, regs });
    }
}
