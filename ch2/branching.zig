const std = @import("std");

fn chooseLabel(value: ?i32) []const u8 {
    return if (value) |v| blk: {
        if (v == 0) break :blk "zero";
        if (v > 0 and v <= 100) break :blk "positive";
        if (v > 100) break :blk "large";
        break :blk "negative";
    } else "missing";
}

pub fn main() !void {
    const samples = [_]?i32{ 5, 0, null, -3, 101 };

    for (samples, 0..) |item, index| {
        const label = chooseLabel(item);

        std.debug.print("sample {d}: {s}\n", .{ index, label });
    }
}
