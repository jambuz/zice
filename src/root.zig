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
