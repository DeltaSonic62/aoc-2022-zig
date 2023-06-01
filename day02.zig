const std = @import("std");
const data = @embedFile("data/day02.txt");

const Outcome = enum(u3) { lose = 0, draw = 3, win = 6 };
const Shape = enum(u8) { rock = 88, paper = 89, scissors = 90 };

// Difference between player and opponent chars
const PLAYER_OPP_DIFF: u16 = 23;

pub fn main() !void {
    var part_one: u16 = partOne();
    std.debug.print("Part 1: {any}\n", .{part_one});

    var part_two: u16 = partTwo();
    std.debug.print("Part 2: {any}\n", .{part_two});
}

fn calcOutcome(p1: Shape, p2: Shape) Outcome {
    if (p1 == p2) return Outcome.draw;
    if (p1 == Shape.rock and p2 == Shape.scissors) return Outcome.win;
    if (p1 == Shape.scissors and p2 == Shape.rock) return Outcome.lose;

    return if (@enumToInt(p1) > @enumToInt(p2)) Outcome.win else Outcome.lose;
}

fn partOne() u16 {
    var lines: std.mem.SplitIterator(u8) = std.mem.split(u8, data, "\n");

    var score: u16 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const opp_move = @intToEnum(Shape, line[0] + PLAYER_OPP_DIFF);
        const player_move = @intToEnum(Shape, line[2]);

        score += switch (player_move) {
            Shape.rock => 1,
            Shape.paper => 2,
            Shape.scissors => 3,
        };

        score += @enumToInt(calcOutcome(player_move, opp_move));
    }

    return score;
}

fn calcShape(outcome: Outcome, against: Shape) Shape {
    return switch (outcome) {
        Outcome.win => if (against == Shape.scissors) Shape.rock else @intToEnum(Shape, @enumToInt(against) + 1),
        Outcome.draw => against,
        Outcome.lose => if (against == Shape.rock) Shape.scissors else @intToEnum(Shape, @enumToInt(against) - 1),
    };
}

fn partTwo() u16 {
    var lines: std.mem.SplitIterator(u8) = std.mem.split(u8, data, "\n");

    var score: u16 = 0;
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        const opp_move = @intToEnum(Shape, line[0] + PLAYER_OPP_DIFF);

        // Subtract by X/rock (min), multiply remainder to match Outcome value
        const outcome = @intToEnum(Outcome, (line[2] - @enumToInt(Shape.rock)) * 3);
        const player_move = calcShape(outcome, opp_move);

        score += switch (player_move) {
            Shape.rock => 1,
            Shape.paper => 2,
            Shape.scissors => 3,
        };

        score += @enumToInt(calcOutcome(player_move, opp_move));
    }

    return score;
}
