const std = @import("std");
const data = @embedFile("data/day01.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    var part_one = partOne(allocator);
    std.debug.print("Part 1: {any}\n", .{part_one});

    var part_two = partTwo(allocator);
    std.debug.print("Part 2: {any}\n", .{part_two});
}

fn getCarriedCals(allocator: std.mem.Allocator) ![]u32 {
    var lines = std.mem.split(u8, data, "\n");
    var cals = std.ArrayList(u32).init(allocator);

    var elf_cals: u32 = 0;
    while (lines.next()) |line| {
        // Move to next elf
        if (line.len == 0) {
            try cals.append(elf_cals);
            elf_cals = 0;
            continue;
        }

        const num = try std.fmt.parseInt(u32, line, 10);
        elf_cals += num;
    }

    return cals.toOwnedSlice();
}

fn partOne(allocator: std.mem.Allocator) !u32 {
    const cals = try getCarriedCals(allocator);
    defer allocator.free(cals);

    std.sort.insertion(u32, cals, {}, comptime std.sort.desc(u32));

    return cals[0];
}

fn partTwo(allocator: std.mem.Allocator) !u32 {
    const cals = try getCarriedCals(allocator);
    defer allocator.free(cals);

    std.sort.insertion(u32, cals, {}, comptime std.sort.desc(u32));

    var sum: u32 = 0;
    for (cals[0..3]) |val| sum += val;

    return sum;
}
