const std = @import("std");
const linux = std.os.linux;

pub const Tracer = struct {
    tid: linux.pid_t,

    /// Initialize the tracer
    /// @1 Process Handle of target
    pub fn init(tid: linux.pid_t) Tracer {
        return Tracer{ .tid = tid };
    }

    pub fn follow(self: Tracer) !void {
        if (linux.ptrace(linux.PTRACE.ATTACH, self.tid, 0, 0, 0) < 0) return error.FailedToAttach;
        // Wait for stop
        var status: u32 = 0;
        if (linux.waitpid(self.tid, &status, 0) < 0) {
            _ = linux.ptrace(linux.PTRACE.DETACH, self.tid, 0, 0, 0);
            return error.WaitFailed;
        }
    }
};
