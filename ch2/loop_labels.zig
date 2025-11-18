const std = @import("std");

/// Searches for the first row where both elements are even numbers.
/// Uses a while loop with continue statements to skip invalid rows.
/// Returns the zero-based index of the matching row, or null if none found.
fn findAllEvenPair(rows: []const [2]i32) ?usize {
    var row: usize = 0;

    const found = while (row < rows.len) : (row += 1) {
        const pair = rows[row];
        if (@mod(pair[0], 2) != 0) continue;
        if (@mod(pair[1], 2) != 0) continue;
        break row;
    } else null;

    return found;
}

pub fn main() !void {
    const grid = [_][2]i32{
        .{ 3, 7 },
        .{ 2, 4 },
        .{ 5, 6 },
    };

    if (findAllEvenPair(&grid)) |row| {
        std.debug.print("first all-even row: {d}\n", .{row});
    } else {
        std.debug.print("no all-even rows\n", .{});
    }

    var attempts: usize = 0;

    const outer = while (attempts < grid.len) : (attempts += 1) {
        for (grid[attempts], 0..) |value, column| {
            if (value == 4) {
                break grid[attempts];
            }
        }
    } else null;

    if (outer) {
        std.debug.print(
            "found target value at row {d}, column {d}\n",
            outer,
        );
    } else {
        std.debug.print("no target value found\n", .{});
    }
}
