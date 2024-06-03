# Final Fantasy V: Dress Code
## A hack for Final Fantasy V (SNES) to add overworld sprites on a per-job per-character basis.

This is to be applied to any version of the SNES game, expanded to 32Mbit (4 MB) via whatever means you like.
For Windows users, I might recommend Lunar Expand.

The .asm will compile with asar, but you'll need to inject the sprite data yourself (or just use the supplied .ips file)

## For those looking to edit the sprites: 
The sprite sheets are in a format recognised by SNESTilesKitten. 
I've also included the aseprite data with tilemaps + palette defined for easier editing.

### The palette data for SNESTilesKitten to import this graphical data is located at:
PC Address: 1ffc00

### The patch expects the sprite data to be organized like so:
(PC addresses)
390000 = Knight

392800 = Monk

395000 = Thief

397800 = Dragoon

39A000 = Ninja

39C800 = Samurai


3A0000 = Berserker

3A2800 = Ranger

3A5000 = Mystic

3A7800 = White Mage

3AA000 = Black Mage

3AC800 = Time Mage


3B0000 = Summoner

3B2800 = Blue Mage

3B5000 = Red Mage

3B7800 = Beastmaster

3BA000 = Chemist

3BC800 = Geomancer


3C0000 = Bard

3C2800 = Dancer

3C5000 = Mimic
