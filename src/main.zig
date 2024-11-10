// raylib-zig (c) Nikolas Wipper 2023

const std = @import("std");
const rl = @import("raylib");
const rect = rl.Rectangle;

const orig = rl.Vector2.init(0, 0);

const tiles = [_]Tile{
    Tile.init(0, 0), // Empty
    Tile.init(4, 0), // Wall
    Tile.init(5, 0), // Wall
    Tile.init(6, 0), // Wall
    Tile.init(7, 0), // Wall
    Tile.init(4, 1), // Wall
    Tile.init(5, 1), // Wall
    Tile.init(6, 1), // Wall
    Tile.init(7, 1), // Wall
    Tile.init(2, 2), // Wall
    Tile.init(3, 2), // Wall
    Tile.init(4, 2), // Wall
    Tile.init(5, 2), // Wall
    Tile.init(2, 3), // Wall
    Tile.init(3, 3), // Wall
    Tile.init(4, 3), // Wall
    Tile.init(5, 3), // Wall
    Tile.init(0, 2), // Fire
    Tile.init(1, 2), // Fire
    Tile.init(0, 3), // Fire
    Tile.init(1, 3), // Fire
    Tile.initBig(0, 4, 2, 2), // Ship
    Tile.initBig(4, 4, 1, 2), // Yellow Door
    Tile.initBig(5, 4, 1, 2), // Red Door
    Tile.initBig(6, 4, 1, 2), // Blue Door
    Tile.init(7, 4), // Yellow Key
    Tile.init(7, 5), // Red Key
    Tile.init(7, 6), // Blue Key
    Tile.init(4, 6), // Yellow Button
    Tile.init(5, 6), // Red Button
    Tile.init(6, 6), // Blue Button
};

pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 1024;
    const screenHeight = 768;

    rl.initWindow(screenWidth, screenHeight, "Spacewarp Editor");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------
    var gesture: rl.Gesture = undefined;
    var touch_position: rl.Vector2 = undefined;

    const textures: rl.Texture2D = rl.loadTexture("./resources/spacewarp_assets.png");
    defer textures.unload();

    const pos = rect.init(0, 0, 48, 48);
    const frame = rect.init(8, 0, 8, 8);

    var selection: u32 = 0;
    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        gesture = rl.getGestureDetected();
        touch_position = rl.getTouchPosition(0);
        if (touch_position.x > 772) {
            const x = @divFloor(touch_position.x - 772, 63);
            const y = @divFloor(touch_position.y, 63);

            if (gesture == rl.Gesture.gesture_tap) selection = @intFromFloat(4 * y + x);
        }
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        rl.drawRectangle(768, 0, 4, 768, rl.Color.dark_gray);
        rl.drawText("Congrats! You created your first window!", 190, 200, 20, rl.Color.light_gray);

        for (tiles, 0..) |tile, i| {
            const x: LargerInt(isize) = 780 + 63 * @mod(i, 4);
            const y: LargerInt(isize) = 8 + 63 * @divFloor(i, 4);
            const position = rect.init(@floatFromInt(x), @floatFromInt(y), 48, 48);

            if (i == selection) rl.drawRectangle(@truncate(x - 4), @truncate(y - 4), 56, 56, rl.Color.white);
            tile.draw(textures, position);
        }

        rl.drawTexturePro(textures, frame, pos, orig, 0, rl.Color.white);
        //----------------------------------------------------------------------------------
    }
}

fn LargerInt(comptime T: type) type {
    return @Type(.{
        .Int = .{
            .bits = @typeInfo(T).Int.bits + 1,
            .signedness = @typeInfo(T).Int.signedness,
        },
    });
}

const Tile = struct {
    source: rect,

    pub fn init(x: f32, y: f32) Tile {
        return Tile{ .source = rect.init(x * 8, y * 8, 8, 8) };
    }

    pub fn initBig(x: f32, y: f32, w: f32, h: f32) Tile {
        return Tile{ .source = rect.init(x * 8, y * 8, w * 8, h * 8) };
    }

    pub fn draw(self: Tile, texture: rl.Texture2D, pos: rect) void {
        rl.drawTexturePro(texture, self.source, pos, orig, 0, rl.Color.white);
    }
};
