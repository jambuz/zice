const std = @import("std");
const win = std.os.windows;

const def = @import("def.zig");

pub const Tracer = struct {
    /// Initialize the tracer
    /// @1 Process Handle of target
    pub fn init() Tracer {}

    /// Trace a thread's execution
    /// 1. Check Thread's RIP
    pub fn follow(self: Tracer, thread_handle: win.HANDLE) !void {
        _ = self;
        _ = thread_handle;
    }

    pub fn deinit(self: Tracer) void {
        _ = self;
    }
};
