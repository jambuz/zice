const std = @import("std");
const linux = std.os.linux;

pub const Process = struct {
    const Self = @This();

    pid: ?linux.pid_t,

    pub fn init(pid: ?linux.pid_t) Self {
        return .{ .pid = pid };
    }

    pub fn enumerateThreads(self: Self) !std.BoundedArray(linux.pid_t, 32) {
        var threads = try std.BoundedArray(linux.pid_t, 32).init(0);

        const task_dir_path = try self.getTaskDirPath();
        var task_dir = try std.fs.openDirAbsolute(task_dir_path, .{ .iterate = true });
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

    inline fn getTaskDirPath(self: Self) ![]const u8 {
        const task_path = blk: {
            if (self.pid) |p| {
                var buf: [64]u8 = undefined;
                break :blk try std.fmt.bufPrint(&buf, "/proc/{d}/task", .{p});
            } else {
                break :blk "/proc/self/task";
            }
        };

        return task_path;
    }
};
