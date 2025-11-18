const std = @import("std");

///Enumeration of all possible action types in the script processor
const Action = enum { add, skip, threshold, unknown };

/// Represents a single processing step with an associated action and value
const Step = struct {
    tag: Action,
    value: i32,
};

/// Contains the final state after script execution completes or terminates early
const Outcome = struct {
    index: usize,
    total: i32,
};

/// Maps single-character codes to their corresponding Action enum values.
/// returns .unknown for unrecognized codes to maintain exhaustive handling.
fn mapCode(code: u8) Action {
    return switch (code) {
        'A' => .add,
        'S' => .skip,
        'T' => .threshold,
        else => .unknown,
    };
}

/// Executes a sequence of steps, accumulating values and checking threshold limits.
/// Processing stops early if a threshold step finds the total meets or exceeds the limit.
/// Returns an Outcome containing the stop index and final accumulated total.
fn process(script: []const Step, limit: i32) Outcome {
    var total: i32 = 0;

    const stop = outer: for (script, 0..) |step, index| {
        switch (step.tag) {
            .add => total += step.value,
            .skip => continue :outer,
            .threshold => {
                if (total >= limit) break :outer Outcome{ .index = index, .total = total };
                continue :outer;
            },
            .unknown => unreachable,
        }
    } else Outcome{ .index = script.len, .total = total };

    return stop;
}

pub fn main() !void {
    // Define a script sequence demonstrating all action types
    const script = [_]Step{
        .{ .tag = mapCode('A'), .value = 2 }, // Add 2 → total: 2
        .{ .tag = mapCode('S'), .value = 0 }, // Skip (no effect)
        .{ .tag = mapCode('A'), .value = 5 }, // Add 5 → total: 7
        .{ .tag = mapCode('T'), .value = 6 }, // Threshold check (7 >= 6: triggers early exit)
        .{ .tag = mapCode('A'), .value = 10 }, // Never executed due to early termination
    };

    const outcome = process(&script, 6);

    std.debug.print(
        "stopped at step {d} with total {d}\n",
        .{ outcome.index, outcome.total },
    );
}
