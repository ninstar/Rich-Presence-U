[<img src="./.github/banner.svg" alt="Rich Presence U" width="100%">][home]

# Overview

A simple application that allows you to create your own activity statuses for Wii U, Nintendo Switch and Nintendo 3DS games and display them on your Discord profile.

<img src="./.github/activity_status.png" alt="Activity status" width="100%">

## Features

- An ever-growing [collection of titles and icons][database] from multiple regions.
- Various customization options.
	- Game renaming and personalized descriptions.
	- Nintendo Network ID and Friend Code sharing.
	- Elapsed time, party size and more.

<img src="./.github/user_interface.png" alt="User interface" width="100%">

> [!Note]
> Automatic activity setup is NOT supported at the moment. Partial or full support may be added in a future major release, implementation will vary from platform to platform.


<p align="center">You can support my work by purchasing this application:</p>
<p align="center"><a href="https://ninstars.itch.io/rpc"><img src="https://static.itch.io/images/badge-color.svg?sanitize=true" alt="AVAILABLE ON itch.io" width="40%"></a></p>

# Localize

If you are interested in contributing by translating the project into other languages, you can use the [english.csv][locale_template] as a template.

> [!Important]
> Cells are separated by commas ``,`` and delimited by double quotation marks ``"``. 

- Other translations: [/source/locales][locales]

# Compile

1. [Download][zip] the repository or clone it via command line:
```bash
git clone https://github.com/ninstar/Rich-Presence-U.git
```
2. Get Godot ``3.6-stable (Standard)`` [here][godot].
3. Open Godot, click **Import ➜ Browse**, navigate to ``/source/project.godot``, open the file and click **Import & Edit**.
4. With the project open, go to **Editor ➜ Manage Export Templates** and click **Download and Install**.
5. After the installation is done, go to **Project ➜ Export**, click **Add** and select **Linux/X11**, **Mac OSX** or **Windows Desktop**.
	- Add ``com.ninstar.rpc`` to the **identifier** field if you selected **Mac OSX**.
	- Set the **export mode** to **Compiled Bytecode** in the **script tab**.
	- Set an **export path** and optionally fill in the name, icon and other details for the app in the **options tab**.
		- Icons for the supported platforms can be found in ``/source/assets/app``.
			- For **Windows Desktop**, you will also need [rcedit][rcedit] in order to use a custom executable icon.
		- These configurations are saved in ``/source/export_presets.cfg`` for any eventual reuse.
6. Click **Export All ➜ Release** or use the command line depending on the platform you made the preset for: 
 ```bash
godot --export "Linux/X11" RichPresenceU
godot --export "Mac OSX" RichPresenceU.dmg
godot --export "Windows Desktop" RichPresenceU.exe
```

> You also have the option to compile [everything][compile] from source.

# Credits

- **Art, Code & Design** - NinStar
- **Database** - [All contributors](https://github.com/ninstar/Rich-Presence-U-DB#credits)
- **Translations**
	- **Deutsch** - DeeKay-Deluxe
	- **Español** - JhoanLsuper
	- **Magyar** - Feeniheelo
	- **Nederlands** - Thomanski
	- **Português** - NinStar

# Third-party code

- [**discord-rpc**](https://github.com/discord/discord-rpc) - Discord
- [**Godot**](https://github.com/godotengine/godot) - Godot Engine 
- [**Godot-UnixSocket**](https://github.com/Abdera7mane/Godot-UnixSocket) - Abdera7mane

[home]: https://ninstars.blogspot.com/p/rpc.html
[database]: https://github.com/ninstar/Rich-Presence-U-DB
[zip]: https://github.com/ninstar/Rich-Presence-U/archive/refs/heads/main.zip
[godot]: https://godotengine.org/download/archive/3.6-stable/
[compile]: https://docs.godotengine.org/en/3.6/development/compiling
[locales]: https://github.com/ninstar/Rich-Presence-U/tree/main/source/locales
[locale_template]: https://github.com/ninstar/Rich-Presence-U/tree/main/source/locales/english.csv
[rcedit]: https://github.com/electron/rcedit/releases