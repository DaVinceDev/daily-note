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

    pub fn setup(self: *DailyNote) !void {
        try std.fs.cwd().makeDir(self.workDir);
        std.debug.print("Daily Note directory is set.", .{});
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
            return error.DiretoryNotFound;
        };

        std.debug.print("--START WRITTING BELOW--\n", .{});
        const content = try reader.readUntilDelimiterAlloc(allocator, ';', 1024);

        const new_filename = try std.fmt.allocPrint(allocator, "{s}.md", .{filename});

        var file = try dir.createFile(new_filename, .{});

        try file.writeAll(content);

        std.debug.print("WRITE!\n", .{});
    }

    pub fn get(self: *DailyNote, filename: []const u8) !void {
        const dir = try std.fs.cwd().openDir(self.workDir, .{});

        const file = dir.openFile(filename, .{ .mode = .read_only }) catch {
            std.debug.print("Note was not found.\n", .{});
            return error.NoteWasNotFound;
        };

        var buf: [1024]u8 = undefined;
        const size = try file.readAll(&buf);
        const content = buf[0..size];
        std.debug.print("{s}\n", .{content});
    }
};
