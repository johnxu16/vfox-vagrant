# Introduction

vfox-vagrant is a plugin for [vfox](https://vfox.dev/)

# Prerequitsite

Enable ["Sudo for Windows"](https://learn.microsoft.com/en-us/windows/sudo/)

# How to use 

## Install Plugin
After installing vfox, run the following command to add the plugin:

```sh
vfox add vagrant
```

## Install SDK

```sh
vfox install vagrant@2.4.3
vfox use -g vagrant@2.4.3
```

# Supported OS's

Currently only Linux and Windows are supported.

Mac OS is not supported due to HashiCorp distributing Vagrant as a DMG file for Mac.

# Development

```pwsh
git clone https://github.com/johnxu16/vfox-vagrant.git $(PluginDirectoryPath)

New-Item -ItemType SymbolicLink -Path "C:\Users\11633\.version-fox\vagrant" -Target "$(PluginDirectoryPath)"

vfox config cache.availableHookDuration 0
# vfox config cache.availableHookDuration 12h
```

# TODO

- [ ] Support MacOS
- [ ] Add sha check
- [ ] Cache versions (fetch from cdn)
- [ ] Env Path
