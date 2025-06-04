const std = @import("std");
const win = std.os.windows;

pub const PROCESS_QUERY_INFORMATION = 0x0400;
pub const PROCESS_VM_READ = 0x0010;
pub const PROCESS_DUP_HANDLE = 0x0040;

pub const THREAD_QUERY_INFORMATION = 0x0040;
pub const THREAD_QUERY_LIMITED_INFORMATION = 0x0800;
pub const THREAD_SUSPEND_RESUME = 0x0002;
pub const THREAD_GET_CONTEXT = 0x0008;

pub const DUPLICATE_SAME_ACCESS = 0x00000002;

pub const CONTEXT_i386 = 0x00010000;
pub const CONTEXT_CONTROL = CONTEXT_i386 | 0x0001;
pub const CONTEXT_INTEGER = CONTEXT_i386 | 0x0002;
pub const CONTEXT_SEGMENTS = CONTEXT_i386 | 0x0004;
pub const CONTEXT_FLOATING_POINT = CONTEXT_i386 | 0x0008;
pub const CONTEXT_DEBUG_REGISTERS = CONTEXT_i386 | 0x0010;
pub const CONTEXT_FULL = CONTEXT_CONTROL | CONTEXT_INTEGER | CONTEXT_SEGMENTS;

pub extern "ntdll" fn NtGetNextThread(
    ProcessHandle: win.HANDLE,
    ThreadHandle: ?win.HANDLE,
    DesiredAccess: win.ACCESS_MASK,
    HandleAttributes: win.ULONG,
    Flags: win.ULONG,
    NewThreadHandle: *win.HANDLE,
) callconv(win.WINAPI) win.NTSTATUS;

pub extern "ntdll" fn NtDuplicateObject(
    SourceProcessHandle: win.HANDLE,
    SourceHandle: win.HANDLE,
    TargetProcessHandle: win.HANDLE,
    TargetHandle: *win.HANDLE,
    DesiredAccess: win.ACCESS_MASK,
    HandleAttributes: win.ULONG,
    Options: win.ULONG,
) callconv(win.WINAPI) win.NTSTATUS;

pub extern "ntdll" fn NtClose(
    Handle: win.HANDLE,
) callconv(win.WINAPI) win.NTSTATUS;

pub extern "ntdll" fn NtOpenThread(
    ThreadHandle: *win.HANDLE,
    DesiredAccess: win.ACCESS_MASK,
    ObjectAttributes: *win.OBJECT_ATTRIBUTES,
    ClientId: *win.CLIENT_ID,
) callconv(win.WINAPI) win.NTSTATUS;

pub extern "kernel32" fn OpenProcess(
    dwDesiredAccess: win.DWORD,
    bInheritHandle: win.BOOL,
    dwProcessId: win.DWORD,
) callconv(win.WINAPI) win.HANDLE;

pub extern "kernel32" fn OpenThread(
    dwDesiredAccess: win.DWORD,
    bInheritHandle: win.BOOL,
    dwThreadId: win.DWORD,
) callconv(win.WINAPI) win.HANDLE;

pub extern "kernel32" fn ResumeThread(
    hThread: win.HANDLE,
) callconv(win.WINAPI) win.DWORD;

pub extern "kernel32" fn SuspendThread(
    hThread: win.HANDLE,
) callconv(win.WINAPI) win.DWORD;

pub extern "kernel32" fn GetThreadId(
    Thread: win.HANDLE,
) callconv(win.WINAPI) win.DWORD;

pub extern "kernel32" fn GetThreadContext(
    hThread: win.HANDLE,
    lpContext: *win.CONTEXT,
) callconv(win.WINAPI) win.BOOL;

pub extern "kernel32" fn VirtualQueryEx(
    hProcess: win.HANDLE,
    lpAddress: win.PVOID,
    lpBuffer: *win.MEMORY_BASIC_INFORMATION,
    dwLength: win.SIZE_T,
) callconv(win.WINAPI) win.SIZE_T;
