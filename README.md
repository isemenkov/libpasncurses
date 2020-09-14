# libpasncurses

The Curses library forms a wrapper over working with raw terminal codes, and provides highly flexible and efficient API (Application Programming Interface). It provides functions to move the cursor, create windows, produce colors, play with mouse etc. The application programs need not worry about the underlying terminal capabilities.



### Table of contents

* [Requierements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Bindings](#bindings)



### Requirements

* [Free Pascal Compiler](http://freepascal.org)
* [Lazarus IDE](http://www.lazarus.freepascal.org/) (optional)

Library is tested with latest stable FreePascal Compiler (currently 3.2.0) and Lazarus IDE (currently 2.0.10).



### Installation

Get the sources and add the *source* directory to the *fpc.cfg* file.



### Usage

Clone the repository `git clone https://github.com/isemenkov/libpasncurses`.

Add the unit you want to use to the `uses` clause.



### Bindings

[libpasncurses.pas](https://github.com/isemenkov/libpasncurses/blob/master/source/libpasncurses.pas) file contains the translated headers to use this library in pascal programs. You can find C API documentation at [nCurses](https://invisible-island.net/ncurses/announce.html).