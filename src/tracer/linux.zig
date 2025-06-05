const std = @import("std");
const linux = std.os.linux;

pub const Tracer = struct {
    const Self = @This();

    tid: linux.pid_t,

    /// Initialize the tracer
    /// @1 Process Handle of target
    pub fn init(tid: linux.pid_t) Self {
        return Self{ .tid = tid };
    }

    pub fn follow(self: Self) !linux.getcontext(2) {
        if (linux.ptrace(linux.PTRACE.ATTACH, self.tid, 0, 0, 0) < 0) return error.FailedToAttach;
        // Wait for stop
        var status: u32 = 0;
        if (linux.waitpid(self.tid, &status, 0) < 0) {
            _ = linux.ptrace(linux.PTRACE.DETACH, self.tid, 0, 0, 0);
            return error.WaitFailed;
        }

        linux.REG.EIP;
        // Get registers
        var regs: UserRegs = undefined;
        if (linux.ptrace(linux.PTRACE.GETREGS, self.tid, 0, @intFromPtr(&regs), 0) < 0) {
            _ = linux.ptrace(linux.PTRACE.DETACH, self.tid, 0, 0, 0);
            return error.GetRegsFailed;
        }

        // Detach
        _ = linux.ptrace(linux.PTRACE.DETACH, self.tid, 0, 0, 0);

        return regs;
    }
};
