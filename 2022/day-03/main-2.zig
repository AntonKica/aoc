const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var buffer_one = std.ArrayList(u8).init(allocator);
    var buffer_two = std.ArrayList(u8).init(allocator);
    var buffer_three = std.ArrayList(u8).init(allocator);

    var buffered_input = std.io.bufferedReader(std.io.getStdIn().reader());
    const input = buffered_input.reader();
    var score: u32 = 0;

    while (true) {
        input.readUntilDelimiterArrayList(&buffer_one, '\n', 4096) catch {
            break;
        };
        input.readUntilDelimiterArrayList(&buffer_two, '\n', 4096) catch {
            break;
        };
        input.readUntilDelimiterArrayList(&buffer_three, '\n', 4096) catch {
            break;
        };
        var used_map = [_]u8{0} ** 256;

        for (buffer_one.items) |item_one| {
            if (used_map[item_one] == 0)
                used_map[item_one] += 1;
        }
        for (buffer_two.items) |item_two| {
            if (used_map[item_two] == 1)
                used_map[item_two] += 1;
        }
        for (buffer_three.items) |item_three| {
            if (used_map[item_three] == 2) {
                if (item_three >= 'a' and item_three <= 'z')
                    score += @as(u32, item_three) - @as(u32, 'a') + 1
                else
                    score += @as(u32, item_three) - @as(u32, 'A') + 27;
                break;
            }
        }
    }

    try std.io.getStdOut().writer().print("The score is {}\n", .{score});
}
