const std = @import("std");

const Mode = enum { fast, safe, tiny };

fn describeScore(score: u8) []const u8 {
    return switch (score) {
        0 => "no progress",
        1...3 => "warming up",
        4, 5 => "halfway there",
        6...9 => "almost done",
        10 => "perfect run",
        else => "out of range",
    };
}

pub fn main() !void {
    const samples = [_]u8{ 0, 2, 5, 8, 10, 12 };

    for (samples) |score| {
        std.debug.print("{d}: {s}\n", .{ score, describeScore(score) });
    }

    const mode: Mode = .safe;

    const factor = switch (mode) {
        .fast => 32,
        .safe => 16,
        .tiny => 4,
    };

    std.debug.print("mode {s} -> factor {d}\n", .{ @tagName(mode), factor });
}
