const std = @import("std");
fn idk(reader: std.Reader, writer: std.Writer, delimiter: u8) !void {
    while (true) {
        const byte: u8 = try reader.readByte(); // (Error || error{EndOfStream})
        if (byte == delimiter) return;
        try writer.writeByte(byte); // @TypeOf(writer).Error
    }
}

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
        const oponent = buffer.items[0];
        const me = buffer.items[2];
        // try std.io.getStdOut().writer().print("Read {} {}\n", .{ oponent, me });

        switch (me) {
            'X' => {
                score += 0;
                switch (oponent) {
                    'A' => score += 3,
                    'B' => score += 1,
                    'C' => score += 2,
                    else => unreachable,
                }
            },
            'Y' => {
                score += 3;
                switch (oponent) {
                    'A' => score += 1,
                    'B' => score += 2,
                    'C' => score += 3,
                    else => unreachable,
                }
            },
            'Z' => {
                score += 6;
                switch (oponent) {
                    'A' => score += 2,
                    'B' => score += 3,
                    'C' => score += 1,
                    else => unreachable,
                }
            },
            else => {
                unreachable;
            },
        }
    }

    try std.io.getStdOut().writer().print("The score is {}\n", .{score});
}
