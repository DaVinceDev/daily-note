const std = @import("std");
const reader = std.io.getStdIn().reader();

pub const DailyNote = struct {
    workDir: []const u8,

    pub fn init(allocator: std.mem.Allocator) !DailyNote {
        const homeDir = try std.process.getEnvVarOwned(allocator, "HOME");
        defer allocator.free(homeDir);

        const path = try std.fmt.allocPrint(allocator, "{s}/Documents/daily", .{homeDir});
        defer allocator.free(path);

        return .{
            .workDir = try allocator.dupe(u8, path),
        };
    }

    pub fn list(self: *DailyNote) !void {
        const dir = try std.fs.cwd().openDir(self.workDir, .{ .iterate = true });
        var it = dir.iterate();
        std.debug.print("\tNotes:\n", .{});

        while (try it.next()) |entry| {
            std.debug.print("{s}\n", .{entry.name});
        }
    }

    pub fn write(self: *DailyNote, allocator: std.mem.Allocator, filename: []u8) !void {
        const dir = std.fs.cwd().openDir(self.workDir, .{}) catch {
            std.debug.print("Error: `daily` directory was not found. Fallback: Attemping to create it...\n", .{});
            try std.fs.cwd().makeDir(self.workDir);
            return;
        };

        const content = try reader.readUntilDelimiterAlloc(allocator, ';', 1024);

        const new_filename = try std.fmt.allocPrint(allocator, "{s}.md", .{filename});

        var file = try dir.createFile(new_filename, .{});

        try file.writeAll(content);

        std.debug.print("WRITE!\n", .{});
    }
};
