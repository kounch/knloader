# knloader

Game Launcher for ZX Spectrum Next

[![Demo Video](./img/Demo.gif)](./img/Demo.mp4 "Demo")

Do you have a ZX Spectrum Next, but you are tired to remember which is the best option to launch your programs? knloader to the rescue!

This a set of NextBASIC programs which you can configure to remember, and then use, your preferred way to launch other programs (Next/+3e Mode, 128K mode, USR 0, etc.). As a bonus, you can put some images (like cassette covers or loading screens).

This program is not a replacement for the incoportaded Browser, nor offers any other function than to launch other programs.

---

## English

A ZIP file with the latest version is available following [this link](https://github.com/kounch/knloader/releases/latest)

### Software Requirements

- **NextZXOS (version 1.3.2)**. Docs, downloads, etc. [here](https://www.specnext.com/latestdistro/)

### Installation

- Create `knloader.bdt` file (see the included manual for instructions).

- Copy `knloader.bas`, `knlauncher` and `knloader.bdt` to any place in your SD card.

#### Use

Use the browser or command line to navigate to the folder where `knloader.bas`, `knlauncher` and `knloader.bdt` are. Load `knloader.bas`.

On first run, cache files will be created from the data inside database file `knloader.bdt`. This has to be done only once, or after any changes are made to the database file.

![First Boot](./docs/FirstBoot.png)

The main interface shows a list of the programs found in the database file.

![First Boot](./docs/CoverOff.png)

You can use the cursor keys or a joystick (Kempston or MD) to move and select the program that you want to load. Then, press `ENTER`, `0` or the joystick button to launch.

---

### Frequently Asked Questions

- **How many loading modes are there?**

At the moment, the loading mode can be one of these (TZX and Pi audio modes require an accelerated Next to function properly):

    0  - 3DOS
    1  - TAP
    2  - TZX (fast)
    3  - DSK (AUTOBOOT)
    4  - TAP (USR 0)
    5  - TZX (USR0 - Fast)
    6  - TAP (Next)
    7  - TZX (Next - Fast)
    8  - DSK (Custom Boot)
    9  - TAP (PI Audio)
    10 - TZX
    11 - TAP (USR 0 - PI Audio)
    12 - TZX (USR 0)
    13 - TAP (PI Audio - Next)
    14 - TZX (Next)
    15 - NEX
    16 - Snapshot (Z80, SNX, SNA, etc.)

- **What formats are supported for the images?**

The file must be a full ZX Spectrum Next screen image file. It can be in SCR, SLR, SHC, SL2 or BMP format.

- **Does this software write anything to the SD card?**

The program creates a preferences file named `opts.tmp` inside the same folder where `knloader.bas` is installed.

It also creates a variable number of cache files insidde `/tmp/knloader`. This is necessary to speed up the program execution and overcome RAM limitations for large database files. However, if the database file is not changed, these will become read only on all subsequent executions.

For all other operations, temporary files are created in the RAM disk.

---

## Copyright

Copyright (c) 2020 kounch

Some of the code used to launch programs has been adapted from the official NextZXOS distribution (especifically from `browser.cfg`, `tapload.bas` and `tzxload.bas`).

**_Spectrum Next_** and **_System/Next_** are © **SpecNext Ltd**.

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE
