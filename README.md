# Rich Presence U ![badge-size] [![Blog][badge-blog]][link-blog] [![Discord][badge-discord]][link-discord] [![Patreon][badge-patreon]][link-patreon]

[badge-size]: https://img.shields.io/github/repo-size/MarioSilvaGH/Rich-Presence-U?color=black&label=Size&logo=github&logoColor=white&style=flat-square
[badge-blog]: https://img.shields.io/static/v1?color=E87700&label=Blog&logo=blogger&logoColor=white&message=Nin%E2%98%85Blog&style=flat-square
[badge-discord]: https://img.shields.io/discord/574569573458771968?color=7289da&label=Discord&logo=discord&logoColor=white&style=flat-square
[badge-patreon]: https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.herokuapp.com%2FNingamer&label=Patreon&logoColor=white&style=flat-square

[link-blog]: https://ninstars.blogspot.com/p/rich-presence-u.html
[link-discord]: https://discord.gg/wZGW8DZ
[link-patreon]: https://www.patreon.com/ningamer

<p align="center"><img alt="Logo" src="https://github.com/MarioSilvaGH/Rich-Presence-U/raw/master/Assets/logo_monod.png" width="90%"></p>

This application allows you to display **Wii U**, **Nintendo Switch** and **Nintendo 3DS** games with a custom or predefined description on your *Discord* profile. There are over 300 titles across all three platforms.

<img alt="Setting up the status" src="https://github.com/MarioSilvaGH/Rich-Presence-U/raw/master/Assets/demo_modes.gif" width="100%">

> **Note:** This application does not use nor support any console modifications by default, it needs manual setup in order to display your games.

## <div align="center">Content</div>

### Releases

#### Rich Presence U 

- [x] Rich Presence U ``[Windows, 32/64-bit]``
- [x] Changelog

> [**DOWNLOAD**](https://github.com/MarioSilvaGH/Rich-Presence-U/releases/tag/0.5) - Version: ``0.5.3``

### Links

-   [**Source Code** (Master)](https://github.com/MarioSilvaGH/Rich-Presence-U/tree/master)

## <div align="center">Extras</div>

[default-repo]: https://github.com/MarioSilvaGH/Rich-Presence-U/raw/master/Assets/WiiU

### Customizing the predefined details

In addition to being able to manually enter your own custom details directly into the main interface, you can also modify the content on which the predefined details (*Single Player, Multiplayer, Online*) will display by editing the ``PRESET.cfg``.

### Client redirection
If you have a repository with modified icons or titles and you want to use them with Rich Presence U, you can create a new file named ``NETWORK.cfg`` with the following content:

```ini
[URLS]
wiiu = "X"
```

**X** is where the URL of the new repository goes, keep in mind that it must follow the same directory structure as the default one (which you can see [here][default-repo], this is also the default URL) with files and folders following the same name.

> **Note:** This example overrides the default client for the Wii U, if you want to use it again just remove the ``REDIRECT.cfg`` from the application directory.

## <div align="center">Credits</div>

**Design & Program**
* Mario Silva (Nin★)

**RPC Wrapper**
* Aouab

**Icons & Titles**
* Mario Silva (Nin★)
* Majesty
* Sneethan
* Luxen