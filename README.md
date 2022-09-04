[<img src="https://i.imgur.com/HADoV2p.png" alt="Rich Presence U" width="100%">][home]

# Overview

A simple application that allows you to create your own activity statuses for Wii U, Nintendo Switch and Nintendo 3DS games and display them on your Discord profile.

<img src="https://i.imgur.com/HR3QyAI.png" alt="Activity status" width="100%">

## Features

- An ever-growing [collection of titles and icons][database] from multiple regions.
- Various customization options.
	- Game renaming and personalized descriptions.
	- Nintendo Network ID and Friend Code sharing.
	- Elapsed time, party size and more.

<img src="https://i.imgur.com/g9yGpnY.png" alt="User interface" width="100%">

> **Note:** Automatic activity setup is not supported at the moment, this is due to Nintendo not providing an open alternative for apps to communicate with their services.

[<p align="center"><img src="https://static.itch.io/images/badge-color.svg?sanitize=true" alt="AVAILABLE ON itch.io" width="40%"></p>][download]

# Compile

1. [Download][zip] the repository or clone it via command line:
```bash
git clone https://github.com/ninstar/Rich-Presence-U.git
```
	
2. Get Godot binary [here][godot] (Standard version, 3.5 or later).
3. Open ``/source/project.godot``.
4. With the project open in Godot, go to **Editor ➜ Manage Export Templates** and select **Download and Install**.
5. Set up a new preset for the platform you want to compile the code by going to **Project ➜ Export** and selecting **Add**.
	- Set an export path and optionally fill in the details in the application section.
	- Go to the script tab and set the export mode to ``Compiled Bytecode``.
6. Select **Export All** or use the command line depending on the platform you made the preset for: 
 ```bash
godot --export "Linux/X11" RichPresenceU
godot --export "Mac OSX" RichPresenceU.dmg
godot --export "Windows Desktop" RichPresenceU.exe
```

> You also have the option to compile [everything][compile] from source.

# Credits

- **Art, Code & Design** - NinStar
- [**discord-rpc**](https://github.com/discord/discord-rpc) - Discord
- [**Godot**](https://github.com/godotengine/godot) - Godot Engine 
- [**UnixSocket**](https://github.com/Abdera7mane/Godot-UnixSocket) - Abdera7mane

[home]: ninstars.blogspot.com/p/rpc.html
[download]: https://ninstars.itch.io/rpc
[database]: https://github.com/ninstar/Rich-Presence-U-DB
[zip]: https://github.com/ninstar/Rich-Presence-U/archive/refs/heads/main.zip
[godot]: https://godotengine.org/download 
[compile]: https://docs.godotengine.org/en/latest/development/compiling
