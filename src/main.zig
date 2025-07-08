const std = @import("std");
const eql = std.mem.eql;
const DailyImport = @import("daily.zig");
pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var daily = try DailyImport.DailyNote.init(allocator);
    const args = try std.process.argsAlloc(allocator);
    defer allocator.free(args);

    if (eql(u8, args[1], "write"))
        try daily.write(allocator, args[2])
    else if (eql(u8, args[1], "list"))
        try daily.list()
    else if (eql(u8, args[1], "get")) {} //get(args[2])

    else {
        std.debug.print("Not implemented yet :p \n", .{});
    }
}
