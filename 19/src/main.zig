const std = @import("std");
const input = @embedFile("input.txt");

const print = std.debug.print;
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var patterns = std.ArrayList([]const u8).init(gpa.allocator());

    var possibleCount: usize = 0;
    var totalWays: usize = 0;

    var firstLine = true;
    var it = std.mem.tokenizeScalar(u8, input, '\n');
    while (it.next()) |line| {
        //Assign the first line to patterns
        if (firstLine == true) {
            firstLine = false;
            var splitIter = std.mem.split(u8, line, ", ");
            while (splitIter.next()) |pattern| {
                try patterns.append(pattern);
            }
            continue;
        }

        var validSubstrings = try gpa.allocator().alloc(usize, line.len + 1);
        @memset(validSubstrings, 0);

        //The number of ways to make a substring of line[0..n]. validSubstrings[line.len] will have the total number of ways to make a line
        validSubstrings[0] = 1;
        for (0..line.len + 1) |n| {
            for (patterns.items) |pattern| {
                if (!std.mem.endsWith(u8, line[0..n], pattern)) continue;
                validSubstrings[n] += validSubstrings[n - pattern.len];
            }
        }

        if (validSubstrings[line.len] > 0) {
            possibleCount += 1;
            totalWays += validSubstrings[line.len];
        }
    }

    print("{any}\n", .{possibleCount});
    print("{any}\n", .{totalWays});
}
