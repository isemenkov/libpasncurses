# libPasnCurses

libPasnCurses is delphi and object pascal bindings around [nCurses](https://invisible-island.net/ncurses/) library. The nCurses library is a wrapper over working with raw terminal codes, and provides highly flexible and efficient API (Application Programming Interface). It provides functions to move the cursor, create windows, produce colors, play with mouse etc. The application programs need not worry about the underlying terminal capabilities.



### Table of contents

* [Requierements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Bindings](#bindings)



### Requirements

* [Embarcadero (R) Rad Studio](https://www.embarcadero.com)
* [Free Pascal Compiler](http://freepascal.org)
* [Lazarus IDE](http://www.lazarus.freepascal.org/)



Library is tested for 

- Embarcadero (R) Delphi 10.3 on Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)
- FreePascal Compiler (3.2.0) and Lazarus IDE (2.0.10) on Ubuntu Linux 5.8.0-33-generic x86_64



### Installation

Get the sources and add the *source* directory to the project search path. For FPC add the *source* directory to the *fpc.cfg* file.



### Usage

Clone the repository `git clone https://github.com/isemenkov/libpasncurses`.

Add the unit you want to use to the `uses` clause.



### Bindings

[libpasncurses.pas](https://github.com/isemenkov/libpasncurses/blob/master/source/libpasncurses.pas) file contains the translated headers to use this library in pascal programs. You can find C API documentation at [nCurses](https://invisible-island.net/ncurses/announce.html).