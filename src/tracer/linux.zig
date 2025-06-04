const std = @import("std");
const linux = std.os.linux;

pub const Tracer = struct {
    const Self = @This();

    /// Initialize the tracer
    /// @1 Process Handle of target
    pub fn init() Self {}

    /// Trace a thread's execution
    /// 1. Check Thread's RIP
    pub fn follow(self: Self, thread_handle: linux.pid_t) !void {
        _ = self;
        _ = thread_handle;
    }

    pub fn deinit(self: Self) void {
        _ = self;
    }
};
