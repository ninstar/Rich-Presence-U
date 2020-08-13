![badge-size]  [![Patreon][badge-patreon]][link-patreon] [![Discord][badge-discord]][link-discord] [![Blog][badge-blog]][link-blog]  
<img alt="Card" src="https://i.imgur.com/iodPtfQ.png" width="100%">

This application allows you to display **Wii U**, **Nintendo Switch** and **Nintendo 3DS** games with a custom or predefined description on your *Discord* profile. There are over 400 titles across all three platforms.

<img alt="Demonstration" src="https://i.imgur.com/XnlTO8v.gif" width="100%">

> **Note:** This application does not use nor support any console modifications by default, it needs manual setup in order to display your games.

## Content

### Releases

#### Rich Presence U 

- [**⬇ DOWNLOAD**](https://github.com/MarioSilvaGH/Rich-Presence-U/releases/tag/0.6) - Version: ``0.6.1``
	- [x] Rich Presence U ``[Windows, 32/64-bit]``
	- [x] [Changelog](https://github.com/MarioSilvaGH/Ninty-Launcher/blob/master/CHANGELOG.txt)


### Links

-   [**Source Code** (Master)](https://github.com/MarioSilvaGH/Rich-Presence-U/tree/master)

## Extras

### Customizing the predefined details

You can change the content of predefined details (*Single Player, Multiplayer,* etc.) by editing the ``DETAILS.cfg``.

### Client redirection

If you have a repository with your own icons and you want to use them with Rich Presence U, you can create a new file named ``NETWORK.cfg`` with the following content:

```ini
[URLS]
wiiu = "X"
```

**X** is where the URL of the new repository goes, keep in mind that it must follow the same directory structure as the default one (which you can see [here](https://github.com/MarioSilvaGH/Ninty-Launcher/blob/master/Assets/WiiU), this is also the default URL) with files and folders following the same name.

> **Note:** This example overrides the default client for the Wii U, if you want to use it again just remove the ``REDIRECT.cfg`` from the application directory.

## Credits

**Design & Program**
* Mario Silva (Nin★)

**RPC Wrapper**
* Aouab

**Icons & Titles**
* Mario Silva (Nin★)
* Majesty
* Sneethan
* Luxen

## License

This project is licensed under the ***MIT License***, refer to ``LICENSE.md`` (alternatively this [link](https://github.com/MarioSilvaGH/Rich-Presence-U/blob/master/LICENSE.md)) for more information.

[badge-size]: https://img.shields.io/github/repo-size/MarioSilvaGH/Rich-Presence-U?color=black&label=Size&logo=github&logoColor=white&style=flat-square
[badge-patreon]: https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.herokuapp.com%2Fninstar&label=Patreon&logoColor=white&style=flat-square
[badge-discord]: https://img.shields.io/discord/574569573458771968?color=7289da&label=Discord&logo=discord&logoColor=white&style=flat-square
[badge-blog]: https://img.shields.io/static/v1?color=E87700&label=Blog&logo=blogger&logoColor=white&message=Rich+Presence+U&style=flat-square

[link-patreon]: https://www.patreon.com/ninstar
[link-discord]: https://invite.gg/ninstar
[link-blog]: https://ninstars.blogspot.com/p/rich-presence-u.html