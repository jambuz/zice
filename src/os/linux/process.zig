const std = @import("std");
const linux = std.os.linux;

pub fn enumerateThreads(pid: ?linux.pid_t) !std.BoundedArray(linux.pid_t, 32) {
    var threads = try std.BoundedArray(linux.pid_t, 32).init(0);

    var buf: [64]u8 = undefined;
    const task_path = try getTaskDirPath(&buf, pid);

    var task_dir = try std.fs.openDirAbsolute(task_path, .{ .iterate = true });
    defer task_dir.close();

    var iter = task_dir.iterate();
    while (try iter.next()) |entry| {
        if (entry.kind != .directory or
            entry.name.len == 0 or
            !std.ascii.isDigit(entry.name[0])) continue;

        const tid = try std.fmt.parseInt(linux.pid_t, entry.name, 10);
        threads.appendAssumeCapacity(tid);
    }

    return threads;
}

fn getTaskDirPath(buf: *[64]u8, pid: ?linux.pid_t) ![]const u8 {
    return if (pid) |p|
        try std.fmt.bufPrint(buf, "/proc/{d}/task", .{p})
    else
        "/proc/self/task";
}
