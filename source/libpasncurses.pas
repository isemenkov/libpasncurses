(******************************************************************************)
(*                                libPasNCurses                               *)
(*                object pascal wrapper around ncurses library                *)
(*             https://invisible-island.net/ncurses/ncurses.html              *)
(*                                                                            *)
(* Copyright (c) 2020                                       Ivan Semenkov     *)
(* https://github.com/isemenkov/libpasncurses               ivan@semenkov.pro *)
(*                                                          Ukraine           *)
(******************************************************************************)
(*                                                                            *)
(* This source  is free software;  you can redistribute  it and/or modify  it *)
(* under the terms of the GNU General Public License as published by the Free *)
(* Software Foundation; either version 3 of the License.                      *)
(*                                                                            *)
(* This code is distributed in the  hope that it will  be useful, but WITHOUT *)
(* ANY  WARRANTY;  without even  the implied  warranty of MERCHANTABILITY  or *)
(* FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License for *)
(* more details.                                                              *)
(*                                                                            *)
(* A copy  of the  GNU General Public License is available  on the World Wide *)
(* Web at <http://www.gnu.org/copyleft/gpl.html>. You  can also obtain  it by *)
(* writing to the Free Software Foundation, Inc., 51  Franklin Street - Fifth *)
(* Floor, Boston, MA 02110-1335, USA.                                         *)
(*                                                                            *)
(******************************************************************************)

unit libpasncurses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

{$IFDEF FPC}
  {$PACKRECORDS C}
{$ENDIF}

const
  { colors }
  COLOR_BLACK                                                           = 0;
  COLOR_RED                                                             = 1;
  COLOR_GREEN                                                           = 2;
  COLOR_YELLOW                                                          = 3;
  COLOR_BLUE                                                            = 4;
  COLOR_MAGENTA                                                         = 5;
  COLOR_CYAN                                                            = 6;
  COLOR_WHITE                                                           = 7;

  ERR                                                                   = -1;
  OK                                                                    = 0;

  { values for the _flags member }
  _SUBWIN       { is this a sub-window? }                               = $01;
  _ENDLINE      { is the window flush right? }                          = $02;
  _FULLWIN      { is the window full-screen? }                          = $04;
  _SCROLLWIN    { bottom edge is at screen bottom? }                    = $08;
  _ISPAD        { is this window a pad? }                               = $10;
  _HASMOVED     { has cursor moved since last refresh? }                = $20;
  _WRAPPED      { cursor was just wrappped }                            = $40;

  { this value is used in the firstchar and lastchar fields to mark
    unchanged lines }
  _NOCHANGE                                                             = -1;

  { this value is used in the oldindex field to mark lines created by insertions
    and scrolls. }
  _NEWINDEX                                                             = -1;

  CCHARW_MAX                                                            = 5;
type
  NCURSES_ATTR_T = type Integer;

  { The standard type used for color values, and for color-pairs.  The latter
    allows the curses library to enumerate the combinations of foreground and
    background colors used by an application, and is normally the product of the
    total foreground and background colors.

    X/Open uses "short" for both of these types, ultimately because they are
    numbers from the SVr4 terminal database, which uses 16-bit signed values. }
  NCURSES_COLOR_T = type ShortInt;

  NCURSES_PAIRS_T = type ShortInt;

  { The internal type used for window dimensions. }
  NCURSES_SIZE_T = type ShortInt;

  { Control type used for tparm's arguments.  While X/Open equates long and
    char* values, this is not always workable for 64-bit platforms. }
  NCURSES_TPARM_ARG = type PInteger;

  pchtype = ^chtype;
  chtype = type Cardinal;
  mmask_t = type Cardinal;

  { ...must be at least as wide as chtype }
  attr_t = chtype;

  NCURSES_BOOL = type Boolean;

  screen = type Pointer;
  SCREEN = screen;

  pldat = ^ldat;
  ldat = type Pointer;

  PWINDOW = ^WINDOW;

  pdat = record
    _pad_x : NCURSES_SIZE_T;
    _pad_y : NCURSES_SIZE_T;
    _pad_top : NCURSES_SIZE_T;
    _pad_left : NCURSES_SIZE_T;
    _pad_bottom : NCURSES_SIZE_T;
    _pad_right :  NCURSES_SIZE_T;
  end;

  { cchar_t stores an array of CCHARW_MAX wide characters.  The first is
    normally a spacing character.  The others are non-spacing.  If those
    (spacing and nonspacing) do not fill the array, a null L'\0' follows.
    Otherwise, a null is assumed to follow when extracting via getcchar(). }
  cchar_t = record
    attr : attr_t;
    chars : WideString[CCHARW_MAX];
  end;

  _win_st = record
    _cury, _curx : NCURSES_SIZE_T; { current cursor position }

    { window location and size }
    _maxy, _maxx : NCURSES_SIZE_T; { maximums of x and y, NOT window size }
    _begy, _begx : NCURSES_SIZE_T; { screen coords of upper-left-hand corner }

    _flags : ShortInt;             { window state flags }

    { attribute tracking }
    _attrs : attr_t;               { current attribute for non-space character }
    _bkgd : chtype;                { current background char/attribute pair }

    { option values set by user }
    _notimeout : Boolean;          { no time out on function-key entry? }
    _clear : Boolean;              { consider all data in the window invalid? }
    _leaveok : Boolean;            { OK to not reset cursor on exit? }
    _scroll : Boolean;             { OK to scroll this window? }
    _idlok : Boolean;              { OK to use insert/delete line? }
    _idcok : Boolean;              { OK to use insert/delete char? }
    _immed : Boolean;              { window in immed mode? (not yet used) }
    _sync : Boolean;               { window in sync mode? }
    _use_keypad : Boolean;         { process function keys into KEY_ symbols? }
    _delay : Integer;              { 0 = nodelay, <0 = blocking, >0 = delay }

    _line : pldat;                 { the actual line data }

    { global screen state }
    _regtop : NCURSES_SIZE_T;      { top line of scrolling region }
    _regbottom : NCURSES_SIZE_T;   { bottom line of scrolling region }

    { these are used only if this is a sub-window }
    _parx : Integer;               { x coordinate of this window in parent }
    _pary : Integer;               { y coordinate of this window in parent }
    _parent : PWINDOW;             { pointer to parent if a sub-window }

    { these are used only if this is a pad }
    _pad : pdat;

    _yoffset : NCURSES_SIZE_T;     { real begy is _begy + _yoffset }

    _bkgrnd : cchar_t;             { current background char/attribute pair }
  end;

  WINDOW = _win_st;

  { Curses uses a helper function.  Define our type for this to simplify
    extending it for the sp-funcs feature. }
  NCURSES_OUTC = function (Value : Integer) : Integer of object;

  {$IFDEF WINDOWS}
    const libNCurses = 'libncurses.dll';
  {$ENDIF}
  {$IFDEF LINUX}
    const libNCurses = 'libncurses.so';
  {$ENDIF}

  { Function prototypes.  This is the complete X/Open Curses list of required
    functions.  Those marked `generated' will have sources generated from the
    macro definitions later in this file, in order to satisfy XPG4.2
    requirements. }

  { The addch, waddch, mvaddch and mvwaddch routines put the character ch into
    the given window at its current window position, which is then advanced.
    They are analogous to putchar in stdio. If the advance is at the right
    margin, the cursor automatically wraps to the beginning of the next line. At
    the bottom of the current scrolling region, if scrollok is enabled, the
    scrolling region is scrolled up one line.

    If ch is a tab, newline, or backspace, the cursor is moved appropriately
    within the window. Backspace moves the cursor one character left; at the
    left edge of a window it does nothing. Newline does a clrtoeol, then moves
    the cursor to the window left margin on the next line, scrolling the window
    if on the last line. Tabs are considered to be at every eighth column. The
    tab interval may be altered by setting the TABSIZE variable.

    If ch is any control character other than tab, newline, or backspace, it is
    drawn in ^X notation. Calling winch after adding a control character does
    not return the character itself, but instead returns the ^-representation of
    the control character.

    Video attributes can be combined with a character argument passed to addch
    or related functions by logical-ORing them into the character. (Thus, text,
    including attributes, can be copied from one place to another using inch and
    addch.) See the curs_attr(3X) page for values of predefined video attribute
    constants that can be usefully OR'ed into characters.

    The echochar and wechochar routines are equivalent to a call to addch
    followed by a call to refresh, or a call to waddch followed by a call to
    wrefresh. The knowledge that only a single character is being output is used
    and, for non-control characters, a considerable performance gain may be seen
    by using these routines instead of their equivalents. }
  function addch (const ch : chtype) : Integer; cdecl; external libNCurses;
  function waddch (win : PWINDOW; const ch : chtype) : Integer; cdecl;
    external libNCurses;
  function mvaddch (y : Integer; x : Integer; const ch : chtype) : Integer;
    cdecl; external libNCurses;
  function mvwaddch (win : PWINDOW; y : Integer; x : Integer; const ch: chtype):
    Integer; cdecl; external libNCurses;
  function echochar (const ch : chtype) : Integer; cdecl; external libNCurses;
  function wechochar (win : PWINDOW; const ch : chtype) : Integer; cdecl;
    external libNCurses;

  { These routines copy chstr into the window image structure at and after the
    current cursor position. The four routines with n as the last argument copy
    at most n elements, but no more than will fit on the line. If n=-1 then the
    whole string is copied, to the maximum number of characters that will fit on
    the line.

    The window cursor is not advanced, and these routines work faster than
    waddnstr. On the other hand, they do not perform any kind of checking (such
    as for the newline, backspace, or carriage return characters), they do not
    advance the current cursor position, they do not expand other control
    characters to ^-escapes, and they truncate the string if it crosses the
    right margin, rather than wrapping it around to the new line. }
  function addchstr (const chstr : pchtype) : Integer; cdecl;
    external libNCurses;
  function addchnstr (const chstr : pchtype; n : Integer) : Integer; cdecl;
    external libNCurses;
  function waddchstr (win : PWINDOW; const chstr : pchtype) : Integer; cdecl;
    external libNCurses;
  function waddchnstr (win : PWINDOW; const chstr : pchtype; n : Integer) :
    Integer; cdecl; external libNCurses;
  function mvaddchstr (y : Integer; x : Integer; const chstr : pchtype) :
    Integer; cdecl; external libNCurses;
  function mvaddchnstr (y : Integer; x : Integer; const chstr : pchtype; n :
    Integer) : Integer; cdecl; external libNCurses;
  function mvwaddchstr (win : PWINDOW; y : Integer; x : Integer; const chstr :
    pchtype) : Integer; cdecl; external libNCurses;
  function mvwaddchnstr (win : PWINDOW; y : Integer; x : Integer; const chstr :
    pchtype; n : Integer) : Integer; cdecl; external libNCurses;

  { These routines write the characters of the (null-terminated) character
    string str on the given window. It is similar to calling waddch once for
    each character in the string. The four routines with n as the last argument
    write at most n characters. If n is -1, then the entire string will be
    added, up to the maximum number of characters that will fit on the line, or
    until a terminating null is reached. }
  function addstr (const str : PChar) : Integer; cdecl; external libNCurses;
  function addnstr (const str : PChar; n : Integer) : Integer; cdecl;
    external libNCurses;
  function waddstr (win : PWINDOW; const str : PChar) : Integer; cdecl;
    external libNCurses;
  function waddnstr (win : PWINDOW; const str : PChar; n : Integer) : Integer;
    cdecl; external libNCurses;
  function mvaddstr (y : Integer; x : Integer; const str : PChar) : Integer;
    cdecl; external libNCurses;
  function mvaddnstr (y : Integer; x : Integer; const str : PChar; n : Integer):
    Integer; cdecl; external libNCurses;
  function mvwaddstr (win : PWINDOW; y : Integer; x : Integer; const str :
    PChar) : Integer; cdecl; external libNCurses;
  function mvwaddnstr (win : PWINDOW; y : Integer; x : Integer; const str :
    PChar; n : Integer) : Integer; cdecl; external libNCurses;

  { These routines manipulate the current attributes of the named window. The
    current attributes of a window apply to all characters that are written into
    the window with waddch, waddstr and wprintw. Attributes are a property of
    the character, and move with the character through any scrolling and
    insert/delete line/character operations. To the extent possible, they are
    displayed as appropriate modifications to the graphic rendition of
    characters put on the screen.

    The routine attrset sets the current attributes of the given window to
    attrs. The routine attroff turns off the named attributes without turning
    any other attributes on or off. The routine attron turns on the named
    attributes without affecting any others. The routine standout is the same as
    attron(A_STANDOUT). The routine standend is the same as attrset(A_NORMAL) or
    attrset, that is, it turns off all attributes.

    The attrset and related routines do not affect the attributes used when
    erasing portions of the window. See curs_bkgd for functions which modify
    the attributes used for erasing and clearing.

    The routine color_set sets the current color of the given window to the
    foreground/background combination described by the color_pair_number. The
    parameter opts is reserved for future use, applications must supply a null
    pointer.

    The routine wattr_get returns the current attribute and color pair for the
    given window; attr_get returns the current attribute and color pair for
    stdscr. The remaining attr_* functions operate exactly like the
    corresponding attr* functions, except that they take arguments of type
    attr_t rather than int.

    The routine chgat changes the attributes of a given number of characters
    starting at the current cursor location of stdscr. It does not update the
    cursor and does not perform wrapping. A character count of -1 or greater
    than the remaining window width means to change attributes all the way to
    the end of the current line. The wchgat function generalizes this to any
    window; the mvwchgat function does a cursor move before acting. In these
    functions, the color argument is a color-pair index (as in the first
    argument of init_pair, see curs_color(3X)). The opts argument is not
    presently used, but is reserved for the future (leave it NULL). }
  function attroff (attrs : NCURSES_ATTR_T) : Integer; cdecl;
    external libNCurses;
  function wattroff (win : PWINDOW; attrs : NCURSES_ATTR_T) : Integer; cdecl;
    external libNCurses;
  function attron (attrs : NCURSES_ATTR_T) : Integer; cdecl;
    external libNCurses;
  function wattron (win : PWINDOW; attrs : NCURSES_ATTR_T) : Integer; cdecl;
    external libNCurses;
  function attrset (attrs : NCURSES_ATTR_T) : Integer; cdecl;
    external libNCurses;
  function wattrset (win : PWINDOW; attrs : NCURSES_ATTR_T) : Integer; cdecl;
    external libNCurses;
  function color_set (color_pair_number : Shortint; opts : Pointer) : Integer;
    cdecl; external libNCurses;
  function wcolor_set (win : PWINDOW; color_pair_number : Shortint; opts :
    Pointer) : Integer; cdecl; external libNCurses;
  function standend : Integer; cdecl; external libNCurses;
  function wstandend (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function standout : Integer; cdecl; external libNCurses;
  function wstandout (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function attr_get (attrs : pattr_t; pair : PShortint; opts : Pointer) :
    Integer; cdecl; external libNCurses;
  function wattr_get (win : PWINDOW; attrs : pattr_t; pair : PShortint; opts :
    Pointer) : Intger; cdecl; external libNCurses;
  function attr_off (attrs : attr_t; opts : Pointer) : Integer; cdecl;
    external libNCurses;
  function wattr_off (win : PWINDOW; attrs : attr_t; opts : Pointer) : Integer;
    cdecl; external libNCurses;
  function attr_on (attrs : attr_t; opts : Pointer) : Integer; cdecl;
    external libNCurses;
  function wattr_on (win : PWINDOW; attrs : attr_t; opts : Pointer) : Integer;
    cdecl; external libNCurses;
  function attr_set (attrs : attr_t; pair : Shortint; opts : Pointer) : Integer;
    cdecl; external libNCurses;
  function wattr_set (win : PWINDOW; attrs : attr_t; pair : Shortint; opts :
    Pointer) : Integer; cdecl; external libNCurses;
  function chgat (n : Integer; attr : attr_t; color : Shortint; const opts :
    Pointer) : Integer; cdecl; external libNCurses;
  function wchgat (win : PWINDOW; n : Integer; attr : attr_t; color : Shortint;
    const opts : Pointer) : Integer; cdecl; external libNCurses;
  function mvchgat (y : Integer; x : Integer; n : Integer; attr : attr_t;
    color : Shortint; const opts : Pointer) : Integer; cdecl;
    external libNCurses;
  function mvwchgat (win : PWINDOW; y : Integer; x : Integer; n : Integer;
    attr : attr_t; color : Shortint; const opts : Pointer) : Integer; cdecl;
    external libNCurses;

  { The baudrate routine returns the output speed of the terminal. The number
    returned is in bits per second, for example 9600, and is an integer.

    The erasechar routine returns the user's current erase character.

    The erasewchar routine stores the current erase character in the location
    referenced by ch. If no erase character has been defined, the routine fails
    and the location referenced by ch is not changed.

    The has_ic routine is true if the terminal has insert- and delete- character
    capabilities.

    The has_il routine is true if the terminal has insert- and delete-line
    capabilities, or can simulate them using scrolling regions. This might be
    used to determine if it would be appropriate to turn on physical scrolling
    using scrollok.

    The killchar routine returns the user's current line kill character.

    The killwchar routine stores the current line-kill character in the location
    referenced by ch. If no line-kill character has been defined, the routine
    fails and the location referenced by ch is not changed.

    The longname routine returns a pointer to a static area containing a verbose
    description of the current terminal. The maximum length of a verbose
    description is 128 characters. It is defined only after the call to initscr
    or newterm. The area is overwritten by each call to newterm and is not
    restored by set_term, so the value should be saved between calls to newterm
    if longname is going to be used with multiple terminals.

    If a given terminal does not support a video attribute that an application
    program is trying to use, curses may substitute a different video attribute
    for it. The termattrs and term_attrs functions return a logical OR of all
    video attributes supported by the terminal using A_ and WA_ constants
    respectively. This information is useful when a curses program needs
    complete control over the appearance of the screen.

    The termname routine returns the terminal name used by setupterm. }
  function baudrate : Integer; cdecl; external libNCurses;
  function erasechar : Char; cdecl; external libNCurses;
  function erasewchar (ch : PWideChar) : Integer; cdecl; external libNCurses;
  function has_ic : Boolean; cdecl; external libNCurses;
  function has_il : Boolean; cdecl; external libNCurses;
  function killchar : Char; cdecl; external libNCurses;
  function killwchar (ch : PWideChar) : Integer; cdecl; external libNCurses;
  function longname : PChar; cdecl; external libNCurses;
  function term_attrs : attr_t; cdecl; external libNCurses;
  function termattrs : chtype; cdecl; external libNCurses;
  function termname : PChar; cdecl; external libNCurses;

  { The beep and flash routines are used to alert the terminal user. The routine
    beep sounds an audible alarm on the terminal, if possible; otherwise it
    flashes the screen (visible bell). The routine flash flashes the screen, and
    if that is not possible, sounds the alert. If neither alert is possible,
    nothing happens. Nearly all terminals have an audible alert (bell or beep),
    but only some can flash the screen. }
  function beep : Integer; cdecl; external libNCurses;
  function flash : Integer; cdecl; external libNCurses;

  { The bkgdset and wbkgdset routines manipulate the background of the named
    window. The window background is a chtype consisting of any combination of
    attributes (i.e., rendition) and a character. The attribute part of the
    background is combined (OR'ed) with all non-blank characters that are
    written into the window with waddch. Both the character and attribute parts
    of the background are combined with the blank characters. The background
    becomes a property of the character and moves with the character through any
    scrolling and insert/delete line/character operations.

    To the extent possible on a particular terminal, the attribute part of the
    background is displayed as the graphic rendition of the character put on the
    screen.

    The bkgd and wbkgd functions set the background property of the current or
    specified window and then apply this setting to every character position in
    that window:

         The rendition of every character on the screen is changed to the new
         background rendition.

         Wherever the former background character appears, it is changed to the
         new background character.

    The getbkgd function returns the given window's current background
    character/attribute pair. }
  procedure bkgdset (ch : chtype); cdecl; external libNCurses;
  procedure wbkgdset (win : PWINDOW; ch : chtype); cdecl; external libNCurses;
  function bkgd (ch : chtype) : Integer; cdecl; external libNCurses;
  function wbkgd (win : PWINDOW; ch : chtype) : Integer; cdecl;
    external libNCurses;
  function getbkgd (win : PWINDOW) : chtype; cdecl; external libNCurses;

  { The border, wborder and box routines draw a box around the edges of a
    window. Other than the window, each argument is a character with attributes:

         ls - left side,
         rs - right side,
         ts - top side,
         bs - bottom side,
         tl - top left-hand corner,
         tr - top right-hand corner,
         bl - bottom left-hand corner, and
         br - bottom right-hand corner.

    If any of these arguments is zero, then the corresponding default values
    (defined in curses.h) are used instead:

         ACS_VLINE,
         ACS_VLINE,
         ACS_HLINE,
         ACS_HLINE,
         ACS_ULCORNER,
         ACS_URCORNER,
         ACS_LLCORNER,
         ACS_LRCORNER.

    box(win, verch, horch) is a shorthand for the following call: wborder(win,
    verch, verch, horch, horch, 0, 0, 0, 0).

    The hline and whline functions draw a horizontal (left to right) line using
    ch starting at the current cursor position in the window. The current cursor
    position is not changed. The line is at most n characters long, or as many
    as fit into the window.

    The vline and wvline functions draw a vertical (top to bottom) line using ch
    starting at the current cursor position in the window. The current cursor
    position is not changed. The line is at most n characters long, or as many
    as fit into the window. }
  function border (ls : chtype; rs : chtype; ts : chtype; bs : chtype;
    tl : chtype; tr : chtype; bl : chtype; br : chtype) : Integer; cdecl;
    external libNCurses;
  function wborder (win : PWINDOW; ls : chtype; rs : chtype; ts : chtype;
    bs : chtype; tl : chtype; tr : chtype; bl : chtype; rb : chtype) : Integer;
    cdecl; external libNCurses;
  function box (win : PWINDOW; verch : chtype; horch : chtype) : Integer;
    cdecl; external libNCurses;
  function hline (ch : chtype; n : Integer) : Integer; cdecl;
    external libNCurses;
  function whline (win : PWINDOW; ch : chtype; n : Integer) : Integer; cdecl;
    external libNCurses;
  function vline (ch : chtype; n : Integer) : Integer; cdecl;
    external libNCurses;
  function wvline (win : PWINDOW; ch : chtype; n : Integer) : Integer; cdecl;
    external libNCurses;
  function mvhline (y : Integer; x : Integer; ch : chtype; n : Integer) :
    Integer; cdecl; external libNCurses;
  function mvwhline (win : PWINDOW; y : Integer; x : Integer; ch : chtype;
    n : Integer) : Integer; cdecl; external libNCurses;
  function mvvline (y : Integer; x : Integer; ch : chtype; n : Integer) :
    Integer; cdecl; external libNCurses;
  function mvwvline (win : PWINDOW; y : Integer; x : Integer; ch : chtype;
    n : Integer) : Integer; cdecl; external libNCurses;

  { curses support color attributes on terminals with that capability. To use
    these routines start_color must be called, usually right after initscr.
    Colors are always used in pairs (referred to as color-pairs). A color-pair
    consists of a foreground color (for characters) and a background color (for
    the blank field on which the characters are displayed). A programmer
    initializes a color-pair with the routine init_pair. After it has been
    initialized, COLOR_PAIR(n), a macro defined in <curses.h>, can be used as a
    new video attribute.

    If a terminal is capable of redefining colors, the programmer can use the
    routine init_color to change the definition of a color. The routines
    has_colors and can_change_color return TRUE or FALSE, depending on whether
    the terminal has color capabilities and whether the programmer can change
    the colors. The routine color_content allows a programmer to extract the
    amounts of red, green, and blue components in an initialized color. The
    routine pair_content allows a programmer to find out how a given color-pair
    is currently defined.

    Routine Descriptions

    The start_color routine requires no arguments. It must be called if the
    programmer wants to use colors, and before any other color manipulation
    routine is called. It is good practice to call this routine right after
    initscr. start_color initializes eight basic colors (black, red, green,
    yellow, blue, magenta, cyan, and white), and two global variables, COLORS
    and COLOR_PAIRS (respectively defining the maximum number of colors and
    color-pairs the terminal can support). It also restores the colors on the
    terminal to the values they had when the terminal was just turned on.

    The init_pair routine changes the definition of a color-pair. It takes three
    arguments: the number of the color-pair to be changed, the foreground color
    number, and the background color number. For portable applications:

         - The value of the first argument must be between 1 and COLOR_PAIRS-1,
         except that if default colors are used (see use_default_colors) the
         upper limit is adjusted to allow for extra pairs which use a default
         color in foreground and/or background.

         - The value of the second and third arguments must be between 0 and
         COLORS. Color pair 0 is assumed to be white on black, but is actually
         whatever the terminal implements before color is initialized. It cannot
         be modified by the application.

    If the color-pair was previously initialized, the screen is refreshed and
    all occurrences of that color-pair are changed to the new definition.

    As an extension, ncurses allows you to set color pair 0 via the
    assume_default_colors routine, or to specify the use of default colors
    (color number -1) if you first invoke the use_default_colors routine.

    The init_color routine changes the definition of a color. It takes four
    arguments: the number of the color to be changed followed by three RGB
    values (for the amounts of red, green, and blue components). The value of
    the first argument must be between 0 and COLORS. (See the section Colors for
    the default color index.) Each of the last three arguments must be a value
    between 0 and 1000. When init_color is used, all occurrences of that color
    on the screen immediately change to the new definition.

    The has_colors routine requires no arguments. It returns TRUE if the
    terminal can manipulate colors; otherwise, it returns FALSE. This routine
    facilitates writing terminal-independent programs. For example, a programmer
    can use it to decide whether to use color or some other video attribute.

    The can_change_color routine requires no arguments. It returns TRUE if the
    terminal supports colors and can change their definitions; other, it returns
    FALSE. This routine facilitates writing terminal-independent programs.

    The color_content routine gives programmers a way to find the intensity of
    the red, green, and blue (RGB) components in a color. It requires four
    arguments: the color number, and three addresses of shorts for storing the
    information about the amounts of red, green, and blue components in the
    given color. The value of the first argument must be between 0 and COLORS.
    The values that are stored at the addresses pointed to by the last three
    arguments are between 0 (no component) and 1000 (maximum amount of
    component).

    The pair_content routine allows programmers to find out what colors a given
    color-pair consists of. It requires three arguments: the color-pair number,
    and two addresses of shorts for storing the foreground and the background
    color numbers. The value of the first argument must be between 1 and
    COLOR_PAIRS-1. The values that are stored at the addresses pointed to by the
    second and third arguments are between 0 and COLORS.

    Colors

    In <curses.h> the following macros are defined. These are the default
    colors. curses also assumes that COLOR_BLACK is the default background color
    for all terminals.

         COLOR_BLACK
         COLOR_RED
         COLOR_GREEN
         COLOR_YELLOW
         COLOR_BLUE
         COLOR_MAGENTA
         COLOR_CYAN
         COLOR_WHITE }
  function start_color : Integer; cdecl; external libNCurses;
  function init_pair (pair : Shortint; f : Shortint; b : Shortint) : Integer;
    cdecl; external libNCurses;
  function init_color (color : Shortint; r : Shortint; g : Shortint;
    b : Shortint) : Integer; cdecl; external libNCurses;
  function has_colors : Boolean; cdecl; external libNCurses;
  function can_change_color : Boolean; cdecl; external libNCurses;
  function color_content (color : Shortint; r : PShortint; g : PShortint;
    b : PShortint) : Integer; cdecl; external libNCurses;
  function pair_content (pair : Shortint; f : PShortint; b : PShortint) :
    Integer; cdecl; external libNCurses;


implementation

end.

