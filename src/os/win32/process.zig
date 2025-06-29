const std = @import("std");
const win = std.os.windows;
const def = @import("def.zig");

/// Enumerate a process's threads.
pub fn enumerateThreads(process_handle: win.HANDLE) !std.BoundedArray(win.HANDLE, 32) {
    var thread_list = try std.BoundedArray(win.HANDLE, 32).init(0);
    var current: ?win.HANDLE = null;

    while (true) {
        var next: win.HANDLE = win.INVALID_HANDLE_VALUE;
        const status = def.NtGetNextThread(
            process_handle,
            current,
            win.THREAD_ALL_ACCESS,
            0,
            0,
            &next,
        );
        if (status == .NO_MORE_ENTRIES) break;
        if (next == win.INVALID_HANDLE_VALUE) continue;
        try thread_list.append(next);
        current = next;
    }

    if (thread_list.len == 0) return error.NoThreadsFound;
    return thread_list;
}
