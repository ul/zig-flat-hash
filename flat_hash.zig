const std = @import("std");
const hash = std.hash;

const FlatHash = @import("flat_hash/base.zig").FlatHash;

const CityNative = switch(@sizeOf(usize)) {
    8 => hash.CityHash64,
    else => hash.CityHash32,
};

pub fn Set(comptime Key: type, comptime transferFn: var, comptime hashFn: var, comptime equalFn: var) type {
    return FlatHash(Key, void, transferFn, hashFn, equalFn);
}

pub const StringSet = Set([]const u8, strAllocFn, CityNative.hash, null);

pub const Map = FlatHash;

pub fn Dictionary(comptime Value: type) type {
    return Map([]const u8, Value, strAllocFn, CityNative.hash, null);
}

fn strAllocFn(allocator: *std.mem.Allocator, src: []const u8) ![]u8 {
    const new = try allocator.alloc(u8, src.len);
    @memcpy(new.ptr, src.ptr, src.len);
    return new;
}

