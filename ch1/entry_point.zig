const std = @import("std");
const builtin = @import("builtin");

const ModeError = error{ReleaseOnly};

pub fn main() !void {
    requireDebugSafety() catch |err| {
        std.debug.print("warning: {s}\n", .{@errorName(err)});
    };

    try announceStartup();
}

fn requireDebugSafety() ModeError!void {
    if (builtin.mode == .Debug) return;

    return ModeError.ReleaseOnly;
}

fn announceStartup() !void {
    // Allocate a fixed-size buffer on the stack for stdout operations
    var stdout_buffer: [128]u8 = undefined;
    // Create a buffered writer wrapping stdout
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    // Get the generic writer interface for polymorphic I/O
    const stdout = &stdout_writer.interface;
    // Write formatted message to the buffer
    try stdout.print("Zig entry point reporting in.\n", .{});
    // Flush the buffer to ensure message is written to stdout
    try stdout.flush();
}
