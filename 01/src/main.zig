const std = @import("std");

pub fn main() anyerror!void {
    var elfs = try read_values("input.txt");

    var maxCal = [_]u32{0, 0, 0};
    for (elfs.items) |elf| {
        var s = sum(elf.items);

        for (maxCal) |v1, i| {
            if (s > v1) {
                for (maxCal[i..]) |v2, j| {
                    if (j < maxCal.len - 1) {
                        maxCal[j + 1] = v2;
                    }
                }
                maxCal[i] = s;
                break;
            }
        }
    }

    std.debug.print("Elf with most calories: {}cal\n", .{maxCal[0]});
    std.debug.print("Top three elfs with most calories: {any}cal\n", .{sum(&maxCal)});
}

fn read_values(sub_path: []const u8) anyerror!std.ArrayList(std.ArrayList(u32)) {
    var allocator = std.heap.page_allocator;

    var values = std.ArrayList(std.ArrayList(u32)).init(allocator);
    try values.append(std.ArrayList(u32).init(allocator));

    var in_file = try std.fs.cwd().openFile(sub_path, .{});
    defer in_file.close();

    var buf_reader = std.io.bufferedReader(in_file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |l| {
        var line = l[0..l.len - 1];

        if (line.len == 0) {
            try values.append(std.ArrayList(u32).init(allocator));
            continue;
        }
        
        var number = try std.fmt.parseUnsigned(u32, line, 10);
        try values.items[values.items.len - 1].append(number);
    }

    return values;
}

fn sum(arr: []const u32) u32 {
    var s: u32 = 0;
    for (arr) |val| {
        s += val;
    }
    return s;
}
