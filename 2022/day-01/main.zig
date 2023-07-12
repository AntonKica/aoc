const std = @import("std");

pub fn main() !void {
    var buffered_reader = std.io.bufferedReader(std.io.getStdIn().reader());
    var reader = buffered_reader.reader();

    var cur: u32 = 0;
    var max_one: u32 = 0;
    var max_two: u32 = 0;
    var max_three: u32 = 0;

    while (true) {
        // lets first read a line
        var buffer: [4096]u8 = undefined;
        var buffer_size: u32 = 0;
        var done = false;

        while (buffer_size != buffer.len) {
            if (reader.readByte()) |byte| {
                if (byte == '\n')
                    break;
                buffer[buffer_size] = byte;
                buffer_size += 1;
            } else |err| switch (err) {
                error.EndOfStream => {
                    done = true;
                    break;
                },
                else => unreachable,
            }
        }
        if (done and buffer_size == 0) {
            try std.io.getStdOut().writer().print("The sum of first is {}\nThe sum of first three is {}\n", .{ max_one, max_one + max_two + max_three });
            return;
        }
        if (buffer_size != 0) {
            cur += try std.fmt.parseInt(u32, buffer[0..buffer_size], 10);
        } else {
            if (max_one < cur) {
                max_three = max_two;
                max_two = max_one;
                max_one = cur;
            } else if (max_two < cur) {
                max_three = max_two;
                max_two = cur;
            } else if (max_three < cur) {
                max_three = cur;
            }

            cur = 0;
        }
    }
}
