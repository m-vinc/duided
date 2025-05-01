# Duided

A simple CLI tool used to generate DUIDs or showing you the DUID NetworkManager is going to use on your machine.

## Build

You need to install the V compiler by following the guide on the offical (V website)[https://vlang.io/] then :

```bash
$ cd duided
$ v .
$ file duided
$ file duided
duided: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, not stripped
```

## Usage

Generate a DUID-UUID according to https://datatracker.ietf.org/doc/html/rfc6355#section-4 :

```bash
$ duided gen -t uuid
000435093229e5764b1bac6ba6d50e8984f3
$ duided gen -t uuid -h
00:04:b3:ca:37:e9:55:1d:4d:94:81:0f:8e:83:97:ce:d1:b5
```

Show the DUID NetworkManager will use on your system by reading /etc/machine-id and doing SHA256 on it :

```bash
./duided show -h
00:04:49:5a:e5:ba:8f:5e:d2:ef:81:b2:bc:cf:e5:85:f0:f7
```

# Contributions

Feel free to implement the logic to generate the others DUID types if not already present or report bugs :p

