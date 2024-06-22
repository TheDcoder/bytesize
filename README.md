# bytesize

A simple script to convert computer storage sizes from bytes to units of higher magnitude and vice versa, it's written in the lightweight [Lua](https://www.lua.org/) language.

## Install

Install Lua in your system if you don't already have it.

No additional setup is neccessary for usage, but for the sake of convenience you can put the script in one of your `$PATH` directories and make it executable:

```
$ cp bytesize.lua /usr/bin/bytesize
$ chmod +x /usr/bin/bytesize
```

## Usage

```
$ bytesize --help
Convert BYTES to SIZE and vice versa, BYTES is the no. of bytes without
a suffix and SIZE accepts both SI (1KB = 1000 bytes) and non-SI (1KiB = 
1024 bytes) suffixes without case-sensitivity.

Usage: bytesize BYTES
   or: bytesize SIZE

Examples:

$ bytesize 1024 # Simple bytes to human readable output
1.024 kB
1.0 KiB

$ bytesize 2147483647 # Y2K38
2.15 GB
2.00 GiB

$ bytesize 1TB # SI units
1000000000000

$ bytesize 1TiB # non-SI units, they are powers of 2
1099511627776

$ bytesize 16G # non-SI with short and ambiguous suffix
17179869184
```
