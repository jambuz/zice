const std = @import("std");
const win = std.os.windows;

const def = @import("def.zig");

pub const Process = struct {
    process_handle: win.HANDLE,

    /// Initialize the process given a handle
    /// @1 Process Handle of target
    pub fn init(process_handle: win.HANDLE) Process {
        return Process{ .process_handle = process_handle };
    }
    /// Enumerates all threads of the process.
    /// access_mask specifies the permissions used to open each thread.
    /// Returns a bounded array of thread handles, or an error if none are found.
    pub fn enumerateThreads(self: Process, access_mask: win.ACCESS_MASK) !std.BoundedArray(win.HANDLE, 32) {
        var thread_list = try std.BoundedArray(win.HANDLE, 32).init(0);
        var current_thread: ?win.HANDLE = null;
        while (true) {
            var next_thread: win.HANDLE = win.INVALID_HANDLE_VALUE;
            const status = def.NtGetNextThread(
                self.process_handle,
                current_thread,
                access_mask,
                0,
                0,
                &next_thread,
            );
            if (status == .NO_MORE_ENTRIES) break;
            if (next_thread == win.INVALID_HANDLE_VALUE) continue;
            try thread_list.append(next_thread);
            current_thread = next_thread;
        }
        if (thread_list.len == 0) return error.NoThreadsFound;
        return thread_list;
    }
};
