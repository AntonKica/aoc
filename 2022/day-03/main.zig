const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var buffer = std.ArrayList(u8).init(allocator);
    defer buffer.deinit();

    var buffered_input = std.io.bufferedReader(std.io.getStdIn().reader());
    const input = buffered_input.reader();
    var score: u32 = 0;

    while (true) {
        input.readUntilDelimiterArrayList(&buffer, '\n', 4096) catch {
            break;
        };
        const both_compartments = buffer.toOwnedSlice();
        const left_compartment = both_compartments[0 .. both_compartments.len / 2];
        const right_compartment = both_compartments[both_compartments.len / 2 .. both_compartments.len];
        // try std.io.getStdOut().writer().print("Full compartment is\n{s}\n{s}{s}\n", .{ both_compartments, left_compartment, right_compartment });
        var used_map = [_]u8{0} ** 256;

        for (left_compartment) |left_item| {
            for (right_compartment) |right_item| {
                if (left_item == right_item) {
                    const val: u32 = if (left_item >= 'a' and left_item <= 'z')
                        @as(u32, left_item) - @as(u32, 'a') + 1
                    else
                        @as(u32, left_item) - @as(u32, 'A') + 27;

                    if (used_map[val] == 0) {
                        used_map[val] = 1;
                        score += val;
                    }
                }
            }
        }
    }

    try std.io.getStdOut().writer().print("The score is {}\n", .{score});
}
