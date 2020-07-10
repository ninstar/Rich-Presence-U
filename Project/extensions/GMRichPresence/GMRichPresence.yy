{
    "id": "f1d48b0c-558b-4d83-8167-907f9b102ef4",
    "modelName": "GMExtension",
    "mvc": "1.2",
    "name": "GMRichPresence",
    "IncludedResources": [
        
    ],
    "androidPermissions": [
        
    ],
    "androidProps": false,
    "androidactivityinject": "",
    "androidclassname": "",
    "androidinject": "",
    "androidmanifestinject": "",
    "androidsourcedir": "",
    "author": "",
    "classname": "",
    "copyToTargets": 64,
    "date": "2019-36-15 02:09:49",
    "description": "",
    "exportToGame": true,
    "extensionName": "",
    "files": [
        {
            "id": "50f75f65-8f2b-4cfc-b1f9-b69a76a39fb6",
            "modelName": "GMExtensionFile",
            "mvc": "1.0",
            "ProxyFiles": [
                
            ],
            "constants": [
                
            ],
            "copyToTargets": 64,
            "filename": "discord_rich_presence.dll",
            "final": "",
            "functions": [
                {
                    "id": "f541ef08-86f9-4128-a868-15e35c792702",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "InitDiscord",
                    "help": "discord_presence_init(applicationId)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_presence_init",
                    "returnType": 2
                },
                {
                    "id": "ad2aeae7-b9de-4a95-898d-9ffbeaa0b25f",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "setDetails",
                    "help": "discord_set_details(details)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_details",
                    "returnType": 2
                },
                {
                    "id": "485b0b0c-14b1-4e5a-a3e8-1a45caf8c123",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": -1,
                    "args": [
                        
                    ],
                    "externalName": "FreeDiscord",
                    "help": "discord_presence_shutdown()",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_presence_shutdown",
                    "returnType": 2
                },
                {
                    "id": "a5403751-704f-425f-8dd7-d4e1c96a9ab8",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "setState",
                    "help": "discord_set_state(state)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_state",
                    "returnType": 2
                },
                {
                    "id": "e65c385a-d2a4-4a42-8432-262dc999265d",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "UpdatePresence",
                    "help": "discord_presence_update()",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_presence_update",
                    "returnType": 2
                },
                {
                    "id": "2c1472f2-1981-4205-ac33-c7abc9b3fa96",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "ClearPresence",
                    "help": "discord_presence_clear()",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_presence_clear",
                    "returnType": 2
                },
                {
                    "id": "50ef0845-f135-4aa6-bacf-37598f40a04b",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "setLargeImageKey",
                    "help": "discord_set_image_large(largeImageKey)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_image_large",
                    "returnType": 2
                },
                {
                    "id": "2c7e3669-db4c-48d1-ab04-f99aa5a1baa3",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "setSmallImageKey",
                    "help": "discord_set_image_small(smallImageKey)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_image_small",
                    "returnType": 2
                },
                {
                    "id": "bcbd65b0-5517-4c9f-b490-8b1c3e8243c7",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "setLargeImageText",
                    "help": "discord_set_text_large(largeImageText)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_text_large",
                    "returnType": 2
                },
                {
                    "id": "0fdab961-2dde-4552-8d69-8aaf6d4bea7d",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "setSmallImageText",
                    "help": "discord_set_text_small(smallImageText)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_text_small",
                    "returnType": 2
                },
                {
                    "id": "437da8f8-3c75-4235-829b-ad25fb6bc7e3",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "setPartySize",
                    "help": "discord_set_party_size(partySize)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_party_size",
                    "returnType": 2
                },
                {
                    "id": "fc26fc72-452e-4f36-88c2-701b5ae0e6d7",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "setPartyMax",
                    "help": "discord_set_party_max(partyMax)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_party_max",
                    "returnType": 2
                },
                {
                    "id": "9f08a733-63b8-404c-bd38-47dce83ac603",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        1
                    ],
                    "externalName": "setPartyId",
                    "help": "discord_set_party_id(partyId)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_party_id",
                    "returnType": 2
                },
                {
                    "id": "a380294c-2c19-47be-bcad-0732fa4273d9",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "setStartTimestamp",
                    "help": "discord_set_timestamp_start(startTimestamp)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_timestamp_start",
                    "returnType": 2
                },
                {
                    "id": "5f143b47-9097-46e4-86da-f43cbc492c19",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 1,
                    "args": [
                        2
                    ],
                    "externalName": "setEndTimestamp",
                    "help": "discord_set_timestamp_end(endTimestamp)",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_set_timestamp_end",
                    "returnType": 2
                },
                {
                    "id": "f2c3c0e9-b10c-4d7d-9437-a384848a5e65",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "RenewPresence",
                    "help": "discord_presence_renew()",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_presence_renew",
                    "returnType": 2
                },
                {
                    "id": "cb145673-4887-499c-9790-6a9f88cbd662",
                    "modelName": "GMExtensionFunction",
                    "mvc": "1.0",
                    "argCount": 0,
                    "args": [
                        
                    ],
                    "externalName": "Now",
                    "help": "discord_get_timestamp_now()",
                    "hidden": false,
                    "kind": 12,
                    "name": "discord_get_timestamp_now",
                    "returnType": 2
                }
            ],
            "init": "",
            "kind": 1,
            "order": [
                "f541ef08-86f9-4128-a868-15e35c792702",
                "ad2aeae7-b9de-4a95-898d-9ffbeaa0b25f",
                "485b0b0c-14b1-4e5a-a3e8-1a45caf8c123",
                "a5403751-704f-425f-8dd7-d4e1c96a9ab8",
                "e65c385a-d2a4-4a42-8432-262dc999265d",
                "2c1472f2-1981-4205-ac33-c7abc9b3fa96",
                "50ef0845-f135-4aa6-bacf-37598f40a04b",
                "2c7e3669-db4c-48d1-ab04-f99aa5a1baa3",
                "bcbd65b0-5517-4c9f-b490-8b1c3e8243c7",
                "0fdab961-2dde-4552-8d69-8aaf6d4bea7d",
                "437da8f8-3c75-4235-829b-ad25fb6bc7e3",
                "fc26fc72-452e-4f36-88c2-701b5ae0e6d7",
                "9f08a733-63b8-404c-bd38-47dce83ac603",
                "a380294c-2c19-47be-bcad-0732fa4273d9",
                "5f143b47-9097-46e4-86da-f43cbc492c19",
                "f2c3c0e9-b10c-4d7d-9437-a384848a5e65",
                "cb145673-4887-499c-9790-6a9f88cbd662"
            ],
            "origname": "extensions\\discord_rich_presence.dll",
            "uncompress": false
        },
        {
            "id": "06c6e869-68ce-48de-a4c9-7d981cd1d64a",
            "modelName": "GMExtensionFile",
            "mvc": "1.0",
            "ProxyFiles": [
                
            ],
            "constants": [
                
            ],
            "copyToTargets": 66,
            "filename": "discord-rpc.dll",
            "final": "",
            "functions": [
                
            ],
            "init": "",
            "kind": 1,
            "order": [
                
            ],
            "origname": "extensions\\discord-rpc.dll",
            "uncompress": false
        }
    ],
    "gradleinject": "",
    "helpfile": "",
    "installdir": "",
    "iosProps": false,
    "iosSystemFrameworkEntries": [
        
    ],
    "iosThirdPartyFrameworkEntries": [
        
    ],
    "iosdelegatename": "",
    "iosplistinject": "",
    "license": "Free to use, also for commercial games.",
    "maccompilerflags": "",
    "maclinkerflags": "",
    "macsourcedir": "",
    "options": null,
    "optionsFile": "options.json",
    "packageID": "",
    "productID": "ACBD3CFF4E539AD869A0E8E3B4B022DD",
    "sourcedir": "",
    "supportedTargets": 64,
    "tvosProps": false,
    "tvosSystemFrameworkEntries": [
        
    ],
    "tvosThirdPartyFrameworkEntries": [
        
    ],
    "tvosclassname": "",
    "tvosdelegatename": "",
    "tvosmaccompilerflags": "",
    "tvosmaclinkerflags": "",
    "tvosplistinject": "",
    "version": "1.1.0"
}