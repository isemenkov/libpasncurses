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

  A_NORMAL                                        = 0;
  A_ATTRIBUTES                                    = Not (0 shl (0 + 8));
  A_CHARTEXT                                      = (1 shl (0 + 8)) - 1;
  A_COLOR                                         = ((1 shl 8) - 1) shl (0 + 8);
  A_STANDOUT                                      = 1 shl (8 + 8);
  A_UNDERLINE                                     = 1 shl (9 + 8);
  A_REVERSE                                       = 1 shl (10 + 8);
  A_BLINK                                         = 1 shl (11 + 8);
  A_DIM                                           = 1 shl (12 + 8);
  A_BOLD                                          = 1 shl (13 + 8);
  A_ALTCHARSET                                    = 1 shl (14 + 8);
  A_INVIS                                         = 1 shl (15 + 8);
  A_PROTECT                                       = 1 shl (16 + 8);
  A_HORIZONTAL                                    = 1 shl (17 + 8);
  A_LEFT                                          = 1 shl (18 + 8);
  A_LOW                                           = 1 shl (19 + 8);
  A_RIGHT                                         = 1 shl (20 + 8);
  A_TOP                                           = 1 shl (21 + 8);
  A_VERTICAL                                      = 1 shl (22 + 8);
  A_ITALIC                                        = 1 shl (23 + 8);

  { Pseudo-character tokens outside ASCII range.  The curses wgetch() function
    will return any given one of these only if the corresponding k- capability
    is defined in your terminal's terminfo entry.

    Some keys (KEY_A1, etc) are arranged like this:
    a1     up    a3
    left   b2    right
    c1     down  c3

    A few key codes do not depend upon the terminfo entry. }
  KEY_CODE_YES      { A wchar_t contains a key code }                   = &0400;
  KEY_MIN           { Minimum curses key }                              = &0401;
  KEY_BREAK         { Break key (unreliable) }                          = &0401;
  KEY_SRESET        { Soft (partial) reset (unreliable) }               = &0530;
  KEY_RESET         { Reset or hard reset (unreliable) }                = &0531;

  { These definitions were generated by ./MKkey_defs.sh ./Caps ./Caps-ncurses }
  KEY_DOWN          { down-arrow key }                                  = &0402;
  KEY_UP            { up-arrow key }                                    = &0403;
  KEY_LEFT          { left-arrow key }                                  = &0404;
  KEY_RIGHT         { right-arrow key }                                 = &0405;
  KEY_HOME          { home key }                                        = &0406;
  KEY_BACKSPACE     { backspace key }                                   = &0407;
  KEY_F0            { Function keys.  Space for 64 }                    = &0410;
  KEY_F1                                                                = &0411;
  KEY_F2                                                                = &0412;
  KEY_F3                                                                = &0413;
  KEY_F4                                                                = &0414;
  KEY_F5                                                                = &0415;
  KEY_F6                                                                = &0416;
  KEY_F7                                                                = &0417;
  KEY_F8                                                                = &0418;
  KEY_F9                                                                = &0419;
  KEY_F10                                                               = &0420;
  KEY_F11                                                               = &0421;
  KEY_F12                                                               = &0422;
  KEY_DL            { delete-line key }                                 = &0510;
  KEY_IL            { insert-line key }                                 = &0511;
  KEY_DC            { delete-character key }                            = &0512;
  KEY_IC            { insert-character key }                            = &0513;
  KEY_EIC           { sent by rmir or smir in insert mode }             = &0514;
  KEY_CLEAR         { clear-screen or erase key }                       = &0515;
  KEY_EOS           { clear-to-end-of-screen key }                      = &0516;
  KEY_EOL           { clear-to-end-of-line key }                        = &0517;
  KEY_SF            { scroll-forward key }                              = &0520;
  KEY_SR            { scroll-backward key }                             = &0521;
  KEY_NPAGE         { next-page key }                                   = &0522;
  KEY_PPAGE         { previous-page key }                               = &0523;
  KEY_STAB          { set-tab key }                                     = &0524;
  KEY_CTAB          { clear-tab key }                                   = &0525;
  KEY_CATAB         { clear-all-tabs key }                              = &0526;
  KEY_ENTER         { enter/send key }                                  = &0527;
  KEY_PRINT         { print key }                                       = &0532;
  KEY_LL            { lower-left key (home down) }                      = &0533;
  KEY_A1            { upper left of keypad }                            = &0534;
  KEY_A3            { upper right of keypad }                           = &0535;
  KEY_B2            { center of keypad }                                = &0536;
  KEY_C1            { lower left of keypad }                            = &0537;
  KEY_C3            { lower right of keypad }                           = &0540;
  KEY_BTAB          { back-tab key }                                    = &0541;
  KEY_BEG           { begin key }                                       = &0542;
  KEY_CANCEL        { cancel key }                                      = &0543;
  KEY_CLOSE         { close key }                                       = &0544;
  KEY_COMMAND       { command key }                                     = &0545;
  KEY_COPY          { copy key }                                        = &0546;
  KEY_CREATE        { create key }                                      = &0547;
  KEY_END           { end key }                                         = &0550;
  KEY_EXIT          { exit key }                                        = &0551;
  KEY_FIND          { find key }                                        = &0552;
  KEY_HELP          { help key }                                        = &0553;
  KEY_MARK          { mark key }                                        = &0554;
  KEY_MESSAGE       { message key }                                     = &0555;
  KEY_MOVE          { move key }                                        = &0556;
  KEY_NEXT          { next key }                                        = &0557;
  KEY_OPEN          { open key }                                        = &0560;
  KEY_OPTIONS       { options key }                                     = &0561;
  KEY_PREVIOUS      { previous key }                                    = &0562;
  KEY_REDO          { redo key }                                        = &0563;
  KEY_REFERENCE     { reference key }                                   = &0564;
  KEY_REFRESH       { refresh key }                                     = &0565;
  KEY_REPLACE       { replace key }                                     = &0566;
  KEY_RESTART       { restart key }                                     = &0567;
  KEY_RESUME        { resume key }                                      = &0570;
  KEY_SAVE          { save key }                                        = &0571;
  KEY_SBEG          { shifted begin key }                               = &0572;
  KEY_SCANCEL       { shifted cancel key }                              = &0573;
  KEY_SCOMMAND      { shifted command key }                             = &0574;
  KEY_SCOPY         { shifted copy key }                                = &0575;
  KEY_SCREATE       { shifted create key }                              = &0576;
  KEY_SDC           { shifted delete-character key }                    = &0577;
  KEY_SDL           { shifted delete-line key }                         = &0600;
  KEY_SELECT        { select key }                                      = &0601;
  KEY_SEND          { shifted end key }                                 = &0602;
  KEY_SEOL          { shifted clear-to-end-of-line key }                = &0603;
  KEY_SEXIT         { shifted exit key }                                = &0604;
  KEY_SFIND         { shifted find key }                                = &0605;
  KEY_SHELP         { shifted help key }                                = &0606;
  KEY_SHOME         { shifted home key }                                = &0607;
  KEY_SIC           { shifted insert-character key }                    = &0610;
  KEY_SLEFT         { shifted left-arrow key }                          = &0611;
  KEY_SMESSAGE      { shifted message key }                             = &0612;
  KEY_SMOVE         { shifted move key }                                = &0613;
  KEY_SNEXT         { shifted next key }                                = &0614;
  KEY_SOPTIONS      { shifted options key }                             = &0615;
  KEY_SPREVIOUS     { shifted previous key }                            = &0616;
  KEY_SPRINT        { shifted print key }                               = &0617;
  KEY_SREDO         { shifted redo key }                                = &0620;
  KEY_SREPLACE      { shifted replace key }                             = &0621;
  KEY_SRIGHT        { shifted right-arrow key }                         = &0622;
  KEY_SRSUME        { shifted resume key }                              = &0623;
  KEY_SSAVE         { shifted save key }                                = &0624;
  KEY_SSUSPEND      { shifted suspend key }                             = &0625;
  KEY_SUNDO         { shifted undo key }                                = &0626;
  KEY_SUSPEND       { suspend key }                                     = &0627;
  KEY_UNDO          { undo key }                                        = &0630;
  KEY_MOUSE         { Mouse event has occurred }                        = &0631;
  KEY_RESIZE        { Terminal resize event }                           = &0632;
  KEY_EVENT         { We were interrupted by an event }                 = &0633;

  KEY_MAX           { Maximum key value is 0633 }                       = &0777;

  NCURSES_BUTTON_RELEASED                                               = 001;
  NCURSES_BUTTON_PRESSED                                                = 002;
  NCURSES_BUTTON_CLICKED                                                = 004;
  NCURSES_DOUBLE_CLICKED                                                = 010;
  NCURSES_TRIPLE_CLICKED                                                = 020;
  NCURSES_RESERVED_EVENT                                                = 040;

  { trace masks }
  TRACE_DISABLE     { turn off tracing }                                = $0000;
  TRACE_TIMES       { trace user and system times of updates }          = $0001;
  TRACE_TPUTS       { trace tputs calls }                               = $0002;
  TRACE_UPDATE      { trace update actions, old & new screens }         = $0004;
  TRACE_MOVE        { trace cursor moves and scrolls }                  = $0008;
  TRACE_CHARPUT     { trace all character outputs }                     = $0010;
  TRACE_ORDINARY    { trace all update actions }                        = $001F;
  TRACE_CALLS       { trace all curses calls }                          = $0020;
  TRACE_VIRTPUT     { trace virtual character puts }                    = $0040;
  TRACE_IEVENT      { trace low-level input processing }                = $0080;
  TRACE_BITS        { trace state of TTY control bits }                 = $0100;
  TRACE_ICALLS      { trace internal/nested calls }                     = $0200;
  TRACE_CCALLS      { trace per-character calls }                       = $0400;
  TRACE_DATABASE    { trace read/write of terminfo/termcap data }       = $0800;
  TRACE_ATTRS       { trace attribute updates }                         = $1000;

type
  NCURSES_ATTR_T = type Integer;

  { The standard type used for color values, and for color-pairs.  The latter
    allows the curses library to enumerate the combinations of foreground and
    background colors used by an application, and is normally the product of the
    total foreground and background colors.

    X/Open uses "short" for both of these types, ultimately because they are
    numbers from the SVr4 terminal database, which uses 16-bit signed values. }
  PNCURSES_COLOR_T = ^NCURSES_COLOR_T;
  NCURSES_COLOR_T = type ShortInt;

  NCURSES_PAIRS_T = type ShortInt;

  { The internal type used for window dimensions. }
  NCURSES_SIZE_T = type ShortInt;

  { Control type used for tparm's arguments.  While X/Open equates long and
    char* values, this is not always workable for 64-bit platforms. }
  NCURSES_TPARM_ARG = type PInteger;

  pchtype = ^chtype;
  chtype = type Cardinal;
  pmmask_t = ^mmask_t;
  mmask_t = type Cardinal;

  { ...must be at least as wide as chtype }
  attr_t = chtype;

  NCURSES_BOOL = type Boolean;

  screen = type Pointer;
  PSCREEN = ^SCREEN;
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

  PMEVENT = ^MEVENT;
  MEVENT = record
    id : Shortint;       { ID to distinguish multiple devices }
    x, y, z : Integer;   { event coordinates (character-cell) }
    bstate : mmask_t;    { button state bits }
  end;

  { Curses uses a helper function.  Define our type for this to simplify
    extending it for the sp-funcs feature. }
  NCURSES_OUTC = function (putc : Integer) : Integer of object;
  NCURSES_SP_OUTC = function (src : PSCREEN; val : Integer) : Integer of
    object;
  NCURSES_WINDOW_CB = function (win : PWINDOW; ptr : Pointer) : Integer of
    object;
  NCURSES_SCREEN_CB = function (scr : PSCREEN; ptr : Pointer) : Integer of
    object;

  ripoffline_init_callback = function (win : PWINDOW; val : Integer) : Integer
    of object;

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
  function PAIR_NUMBER (attr : Integer) : Integer; cdecl; external libNCurses;

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
  function baudrate_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function erasechar : Char; cdecl; external libNCurses;
  function erasechar_sp (src : PSCREEN) : Char; cdecl; external libNCurses;
  function erasewchar (ch : PWideChar) : Integer; cdecl; external libNCurses;
  function has_ic : Boolean; cdecl; external libNCurses;
  function has_ic_sp (src : PSCREEN) : Boolean; cdecl; external libNCurses;
  function has_il : Boolean; cdecl; external libNCurses;
  function has_il_sp (src : PSCREEN) : Boolean; cdecl; external libNCurses;
  function killchar : Char; cdecl; external libNCurses;
  function killchar_sp (src : PSCREEN) : Char; cdecl; external libNCurses;
  function killwchar (ch : PWideChar) : Integer; cdecl; external libNCurses;
  function longname : PChar; cdecl; external libNCurses;
  function longname_sp (src : PSCREEN) : PChar; cdecl; external libNCurses;
  function term_attrs : attr_t; cdecl; external libNCurses;
  function termattrs : chtype; cdecl; external libNCurses;
  function termattrs_sp (src : PSCREEN) : chtype; cdecl; external libNCurses;
  function termname : PChar; cdecl; external libNCurses;
  function termname_sp (src : PSCREEN) : PChar; cdecl; external libNCurses;

  { The beep and flash routines are used to alert the terminal user. The routine
    beep sounds an audible alarm on the terminal, if possible; otherwise it
    flashes the screen (visible bell). The routine flash flashes the screen, and
    if that is not possible, sounds the alert. If neither alert is possible,
    nothing happens. Nearly all terminals have an audible alert (bell or beep),
    but only some can flash the screen. }
  function beep : Integer; cdecl; external libNCurses;
  function beep_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function flash : Integer; cdecl; external libNCurses;
  function flash_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;

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
  function start_color_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function init_pair (pair : NCURSES_PAIRS_T; f : Shortint; b : Shortint) :
    Integer; cdecl; external libNCurses;
  function init_pair_sp (src : PSCREEN; pair : NCURSES_PAIRS_T; f :
    NCURSES_COLOR_T; b : NCURSES_COLOR_T) : Integer; cdecl;
    external libNCurses;
  function init_color (color : NCURSES_COLOR_T; r : Shortint; g : Shortint;
    b : Shortint) : Integer; cdecl; external libNCurses;
  function init_color_sp (src : PSCREEN; color : NCURSES_COLOR_T;
    r : NCURSES_COLOR_T; g : NCURSES_COLOR_T; b : NCURSES_COLOR_T) :
    Integer; cdecl; external libNCurses;
  function has_colors : Boolean; cdecl; external libNCurses;
  function has_colors_sp (src : PSCREEN) : Boolean; cdecl; external libNCurses;
  function can_change_color : Boolean; cdecl; external libNCurses;
  function can_change_color_sp (src : PSCREEN) : Boolean; cdecl;
    external libNCurses;
  function color_content (color : NCURSES_PAIRS_T; r : PShortint; g : PShortint;
    b : PShortint) : Integer; cdecl; external libNCurses;
  function color_content_sp (src : PSCREEN; color : NCURSES_PAIRS_T; r :
    NCURSES_COLOR_T; g : NCURSES_COLOR_T; b : NCURSES_COLOR_T) : Integer;
    cdecl; external libNCurses;
  function pair_content (pair : Shortint; f : PShortint; b : PShortint) :
    Integer; cdecl; external libNCurses;
  function pair_content_sp (src : PSCREEN; pair : NCURSES_PAIRS_T; f :
    PNCURSES_COLOR_T; b : PNCURSES_COLOR_T) : Integer; cdecl;
    external libNCurses;

  { Normally, the tty driver buffers typed characters until a newline or
    carriage return is typed. The cbreak routine disables line buffering and
    erase/kill character-processing (interrupt and flow control characters are
    unaffected), making characters typed by the user immediately available to
    the program. The nocbreak routine returns the terminal to normal (cooked)
    mode.

    Initially the terminal may or may not be in cbreak mode, as the mode is
    inherited; therefore, a program should call cbreak or nocbreak explicitly.
    Most interactive programs using curses set the cbreak mode. Note that cbreak
    overrides raw. [See curs_getch for a discussion of how these routines
    interact with echo and noecho.]

    The echo and noecho routines control whether characters typed by the user
    are echoed by getch as they are typed. Echoing by the tty driver is always
    disabled, but initially getch is in echo mode, so characters typed are
    echoed. Authors of most interactive programs prefer to do their own echoing
    in a controlled area of the screen, or not to echo at all, so they disable
    echoing by calling noecho. [See curs_getch for a discussion of how these
    routines interact with cbreak and nocbreak.]

    The halfdelay routine is used for half-delay mode, which is similar to
    cbreak mode in that characters typed by the user are immediately available
    to the program. However, after blocking for tenths tenths of seconds, ERR is
    returned if nothing has been typed. The value of tenths must be a number
    between 1 and 255. Use nocbreak to leave half-delay mode.

    If the intrflush option is enabled, (bf is TRUE), when an interrupt key is
    pressed on the keyboard (interrupt, break, quit) all output in the tty
    driver queue will be flushed, giving the effect of faster response to the
    interrupt, but causing curses to have the wrong idea of what is on the
    screen. Disabling (bf is FALSE), the option prevents the flush. The default
    for the option is inherited from the tty driver settings. The window
    argument is ignored.

    The keypad option enables the keypad of the user's terminal. If enabled (bf
    is TRUE), the user can press a function key (such as an arrow key) and
    wgetch returns a single value representing the function key, as in KEY_LEFT.
    If disabled (bf is FALSE), curses does not treat function keys specially and
    the program has to interpret the escape sequences itself. If the keypad in
    the terminal can be turned on (made to transmit) and off (made to work
    locally), turning on this option causes the terminal keypad to be turned on
    when wgetch is called. The default value for keypad is false.

    Initially, whether the terminal returns 7 or 8 significant bits on input
    depends on the control mode of the tty driver [see termio]. To force 8 bits
    to be returned, invoke meta(win, TRUE); this is equivalent, under POSIX, to
    setting the CS8 flag on the terminal. To force 7 bits to be returned, invoke
    meta(win, FALSE); this is equivalent, under POSIX, to setting the CS7 flag
    on the terminal. The window argument, win, is always ignored. If the
    terminfo capabilities smm (meta_on) and rmm (meta_off) are defined for the
    terminal, smm is sent to the terminal when meta(win, TRUE) is called and rmm
    is sent when meta(win, FALSE) is called.

    The nodelay option causes getch to be a non-blocking call. If no input is
    ready, getch returns ERR. If disabled (bf is FALSE), getch waits until a key
    is pressed.

    While interpreting an input escape sequence, wgetch sets a timer while
    waiting for the next character. If notimeout(win, TRUE) is called, then
    wgetch does not set a timer. The purpose of the timeout is to differentiate
    between sequences received from a function key and those typed by a user.

    The raw and noraw routines place the terminal into or out of raw mode. Raw
    mode is similar to cbreak mode, in that characters typed are immediately
    passed through to the user program. The differences are that in raw mode,
    the interrupt, quit, suspend, and flow control characters are all passed
    through uninterpreted, instead of generating a signal. The behavior of the
    BREAK key depends on other bits in the tty driver that are not set by
    curses.

    When the noqiflush routine is used, normal flush of input and output queues
    associated with the INTR, QUIT and SUSP characters will not be done [see
    termio]. When qiflush is called, the queues will be flushed when these
    control characters are read. You may want to call noqiflush() in a signal
    handler if you want output to continue as though the interrupt had not
    occurred, after the handler exits.

    The timeout and wtimeout routines set blocking or non-blocking read for a
    given window. If delay is negative, blocking read is used (i.e., waits
    indefinitely for input). If delay is zero, then non-blocking read is used
    (i.e., read returns ERR if no input is waiting). If delay is positive, then
    read blocks for delay milliseconds, and returns ERR if there is still no
    input. Hence, these routines provide the same functionality as nodelay, plus
    the additional capability of being able to block for only delay milliseconds
    (where delay is positive).

    The curses library does ''line-breakout optimization'' by looking for
    typeahead periodically while updating the screen. If input is found, and it
    is coming from a tty, the current update is postponed until refresh or
    doupdate is called again. This allows faster response to commands typed in
    advance. Normally, the input FILE pointer passed to newterm, or stdin in the
    case that initscr was used, will be used to do this typeahead checking. The
    typeahead routine specifies that the file descriptor fd is to be used to
    check for typeahead instead. If fd is -1, then no typeahead checking is
    done. }
  function cbreak : Integer; cdecl; external libNCurses;
  function cbreak_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function nocbreak : Integer; cdecl; external libNCurses;
  function nocbreak_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function echo : Integer; cdecl; external libNCurses;
  function echo_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function noecho : Integer; cdecl; external libNCurses;
  function noecho_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function halfdelay (tenths : Integer) : Integer; cdecl; external libNCurses;
  function halfdelay_sp (src : PSCREEN; tenths : Integer) : Integer; cdecl;
    external libNCurses;
  function intrflush (win : PWINDOW; bf : Boolean) : Integer; cdecl;
    external libNCurses;
  function intrflush_sp (src : PSCREEN; win : PWINDOW; bf : Boolean) : Integer;
    cdecl; external libNCurses;
  function keypad (win : PWINDOW; bf : Boolean) : Integer; cdecl;
    external libNCurses;
  function meta (win : PWINDOW; bf : Boolean) : Integer; cdecl;
    external libNCurses;
  function nodelay (win : PWINDOW; bf : Boolean) : Integer; cdecl;
    external libNCurses;
  function raw : Integer; cdecl; external libNCurses;
  function raw_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function noraw : Integer; cdecl; external libNCurses;
  function noraw_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  procedure noqiflush; cdecl; external libNCurses;
  procedure noqiflush_sp (src : PSCREEN); cdecl; external libNCurses;
  procedure qiflush; cdecl; external libNCurses;
  procedure qiflush_sp (src : PSCREEN); cdecl; external libNCurses;
  function notimeout (win : PWINDOW; bf : Boolean) : Integer; cdecl;
    external libNCurses;
  procedure timeout (delay : Integer); cdecl; external libNCurses;
  procedure wtimeout (win : PWINDOW; delay : Integer); cdecl;
    external libNCurses;
  function typeahead (fd : Integer) : Integer; cdecl; external libNCurses;
  function typeahead_sp (src : PSCREEN; fd : Integer) : Integer; cdecl;
    external libNCurses;

  { The erase and werase routines copy blanks to every position in the window,
    clearing the screen.

    The clear and wclear routines are like erase and werase, but they also call
    clearok, so that the screen is cleared completely on the next call to
    wrefresh for that window and repainted from scratch.

    The clrtobot and wclrtobot routines erase from the cursor to the end of
    screen. That is, they erase all lines below the cursor in the window. Also,
    the current line to the right of the cursor, inclusive, is erased.

    The clrtoeol and wclrtoeol routines erase the current line to the right of
    the cursor, inclusive, to the end of the current line.

    Blanks created by erasure have the current background rendition (as set by
    wbkgdset) merged into them. }
  function erase : Integer; cdecl; external libNCurses;
  function werase (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function clear : Integer; cdecl; external libNCurses;
  function wclear (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function clrtobot : Integer; cdecl; external libNCurses;
  function wclrtobot (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function clrtoeol : Integer; cdecl; external libNCurses;
  function wclrtoeol (win : PWINDOW) : Integer; cdecl; external libNCurses;

  { These routines set options that change the style of output within curses.
    All options are initially FALSE, unless otherwise stated. It is not
    necessary to turn these options off before calling endwin.

    If clearok is called with TRUE as argument, the next call to wrefresh with
    this window will clear the screen completely and redraw the entire screen
    from scratch. This is useful when the contents of the screen are uncertain,
    or in some cases for a more pleasing visual effect. If the win argument to
    clearok is the global variable curscr, the next call to wrefresh with any
    window causes the screen to be cleared and repainted from scratch.

    If idlok is called with TRUE as second argument, curses considers using the
    hardware insert/delete line feature of terminals so equipped. Calling idlok
    with FALSE as second argument disables use of line insertion and deletion.
    This option should be enabled only if the application needs insert/delete
    line, for example, for a screen editor. It is disabled by default because
    insert/delete line tends to be visually annoying when used in applications
    where it is not really needed. If insert/delete line cannot be used, curses
    redraws the changed portions of all lines.

    If idcok is called with FALSE as second argument, curses no longer considers
    using the hardware insert/delete character feature of terminals so equipped.
    Use of character insert/delete is enabled by default. Calling idcok with
    TRUE as second argument re-enables use of character insertion and deletion.

    If immedok is called with TRUE as argument, any change in the window image,
    such as the ones caused by waddch, wclrtobot, wscrl, etc., automatically
    cause a call to wrefresh. However, it may degrade performance considerably,
    due to repeated calls to wrefresh. It is disabled by default.

    Normally, the hardware cursor is left at the location of the window cursor
    being refreshed. The leaveok option allows the cursor to be left wherever
    the update happens to leave it. It is useful for applications where the
    cursor is not used, since it reduces the need for cursor motions.

    The setscrreg and wsetscrreg routines allow the application programmer to
    set a software scrolling region in a window. top and bot are the line
    numbers of the top and bottom margin of the scrolling region. (Line 0 is the
    top line of the window.) If this option and scrollok are enabled, an attempt
    to move off the bottom margin line causes all lines in the scrolling region
    to scroll one line in the direction of the first line. Only the text of the
    window is scrolled. (Note that this has nothing to do with the use of a
    physical scrolling region capability in the terminal, like that in the
    VT100. If idlok is enabled and the terminal has either a scrolling region or
    insert/delete line capability, they will probably be used by the output
    routines.)

    The scrollok option controls what happens when the cursor of a window is
    moved off the edge of the window or scrolling region, either as a result of
    a newline action on the bottom line, or typing the last character of the
    last line. If disabled, (bf is FALSE), the cursor is left on the bottom
    line. If enabled, (bf is TRUE), the window is scrolled up one line (Note
    that to get the physical scrolling effect on the terminal, it is also
    necessary to call idlok).

    The nl and nonl routines control whether the underlying display device
    translates the return key into newline on input, and whether it translates
    newline into return and line-feed on output (in either case, the call
    addch('\n') does the equivalent of return and line feed on the virtual
    screen). Initially, these translations do occur. If you disable them using
    nonl, curses will be able to make better use of the line-feed capability,
    resulting in faster cursor motion. Also, curses will then be able to detect
    the return key. }
  function clearok (win : PWINDOW; bf : Boolean) : Integer; cdecl;
    external libNCurses;
  function idlok (win : PWINDOW; bf : Boolean) : Integer; cdecl;
    external libNCurses;
  procedure idcok (win : PWINDOW; bf : Boolean); cdecl; external libNCurses;
  procedure immedok (win : PWINDOW; bf : Boolean); cdecl; external libNCurses;
  function leaveok (win : PWINDOW; bf : Boolean) : Integer; cdecl;
    external libNCurses;
  function setscrreg (top : Integer; bot : Integer) : Integer; cdecl;
    external libNCurses;
  function wsetscrreg (win : PWINDOW; top : Integer; bot : Integer) : Integer;
    cdecl; external libNCurses;
  function scrollok (win : PWINDOW; bf : Boolean) : Integer; cdecl;
    external libNCurses;
  function nl : Integer; cdecl; external libNCurses;
  function nl_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function nonl : Integer; cdecl; external libNCurses;
  function nonl_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;

  { The overlay and overwrite routines overlay srcwin on top of dstwin. scrwin
    and dstwin are not required to be the same size; only text where the two
    windows overlap is copied. The difference is that overlay is non-destructive
    (blanks are not copied) whereas overwrite is destructive.

    The copywin routine provides a finer granularity of control over the overlay
    and overwrite routines. Like in the prefresh routine, a rectangle is
    specified in the destination window, (dminrow, dmincol) and (dmaxrow,
    dmaxcol), and the upper-left-corner coordinates of the source window,
    (sminrow, smincol). If the argument overlay is true, then copying is
    non-destructive, as in overlay. }
  function overlay (const srcwin : PWINDOW; dstwin : PWINDOW) : Integer; cdecl;
    external libNCurses;
  function overwrite (const srcwin : PWINDOW; dstwin : PWINDOW) : Integer;
    cdecl; external libNCurses;
  function copywin (const srcwin : PWINDOW; dstwin : PWINDOW; sminrow : Integer;
    dminrow : Integer; dmincol : Integer; dmaxrow : Integer; dmaxcol : Integer;
    overlay : Integer) : Integer; cdecl; external libNCurses;

  { The following routines give low-level access to various curses capabilities.
    Theses routines typically are used inside library routines.

    The def_prog_mode and def_shell_mode routines save the current terminal
    modes as the "program" (in curses) or "shell" (not in curses) state for use
    by the reset_prog_mode and reset_shell_mode routines. This is done
    automatically by initscr. There is one such save area for each screen
    context allocated by newterm().

    The reset_prog_mode and reset_shell_mode routines restore the terminal to
    "program" (in curses) or "shell" (out of curses) state. These are done
    automatically by endwin and, after an endwin, by doupdate, so they normally
    are not called.

    The resetty and savetty routines save and restore the state of the terminal
    modes. savetty saves the current state in a buffer and resetty restores the
    state to what it was at the last call to savetty.

    The getsyx routine returns the current coordinates of the virtual screen
    cursor in y and x. If leaveok is currently TRUE, then -1,-1 is returned. If
    lines have been removed from the top of the screen, using ripoffline, y and
    x include these lines; therefore, y and x should be used only as arguments
    for setsyx.

    The setsyx routine sets the virtual screen cursor to y, x. If y and x are
    both -1, then leaveok is set. The two routines getsyx and setsyx are
    designed to be used by a library routine, which manipulates curses windows
    but does not want to change the current position of the program's cursor.
    The library routine would call getsyx at the beginning, do its manipulation
    of its own windows, do a wnoutrefresh on its windows, call setsyx, and then
    call doupdate.

    The ripoffline routine provides access to the same facility that slk_init
    [see curs_slk] uses to reduce the size of the screen. ripoffline must be
    called before initscr or newterm is called. If line is positive, a line is
    removed from the top of stdscr; if line is negative, a line is removed from
    the bottom. When this is done inside initscr, the routine init (supplied by
    the user) is called with two arguments: a window pointer to the one-line
    window that has been allocated and an integer with the number of columns in
    the window. Inside this initialization routine, the integer variables LINES
    and COLS (defined in <curses.h>) are not guaranteed to be accurate and
    wrefresh or doupdate must not be called. It is allowable to call
    wnoutrefresh during the initialization routine.

    ripoffline can be called up to five times before calling initscr or newterm.

    The curs_set routine sets the cursor state is set to invisible, normal, or
    very visible for visibility equal to 0, 1, or 2 respectively. If the
    terminal supports the visibility requested, the previous cursor state is
    returned; otherwise, ERR is returned.

    The napms routine is used to sleep for ms milliseconds. }
  function def_prog_mode : Integer; cdecl; external libNCurses;
  function def_prog_mode_sp (src : PSCREEN) : Integer; cdecl;
    external libNCurses;
  function def_shell_mode : Integer; cdecl; external libNCurses;
  function def_shell_mode_sp (src : PSCREEN) : Integer; cdecl;
    external libNCurses;
  function reset_prog_mode : Integer; cdecl; external libNCurses;
  function reset_prog_mode_sp (src : PSCREEN) : Integer; cdecl;
    external libNCurses;
  function reset_shell_mode : Integer; cdecl; external libNCurses;
  function reset_shell_mode_sp (src : PSCREEN) : Integer; cdecl;
    external libNCurses;
  function resetty : Integer; cdecl; external libNCurses;
  function resetty_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function savetty : Integer; cdecl; external libNCurses;
  function savetty_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  procedure getsyx (y : Integer; x : Integer); cdecl; external libNCurses;
  procedure setsyx (y : Integer; x : Integer); cdecl; external libNCurses;
  function ripoffline (line : Integer; init : ripoffline_init_callback) :
    Integer; cdecl; external libNCurses;
  function ripoffline_sp (src : PSCREEN; line : Integer; init :
    ripoffline_init_callback) : Integer; cdecl; external libNCurses;
  function curs_set (visibility : Integer) : Integer; cdecl;
    external libNCurses;
  function curs_set_sp (src : PSCREEN; visibility : Integer) : Integer; cdecl;
    external libNCurses;
  function napms (ms : Integer) : Integer; cdecl; external libNCurses;
  function napms_sp (src : PSCREEN; ms : Integer) : Integer; cdecl;
    external libNCurses;

  { The unctrl routine returns a character string which is a printable
    representation of the character c, ignoring attributes. Control characters
    are displayed in the ^X notation. Printing characters are displayed as is.
    The corresponding wunctrl returns a printable representation of a
    wide-character.

    The keyname routine returns a character string corresponding to the key c:

        - Printable characters are displayed as themselves, e.g., a
        one-character string containing the key.
        - Control characters are displayed in the ^X notation.
        - DEL (character 127) is displayed as ^?.
        - Values above 128 are either meta characters (if the screen has not
        been initialized, or if meta has been called with a TRUE parameter),
        shown in the M-X notation, or are displayed as themselves. In the latter
        case, the values may not be printable; this follows the X/Open
        specification.
        - Values above 256 may be the names of the names of function keys.
        - Otherwise (if there is no corresponding name) the function returns
        null, to denote an error. X/Open also lists an "UNKNOWN KEY" return
        value, which some implementations return rather than null.

    The corresponding key_name returns a character string corresponding to the
    wide-character value w. The two functions do not return the same set of
    strings; the latter returns null where the former would display a meta
    character.

    The filter routine, if used, must be called before initscr or newterm are
    called. The effect is that, during those calls, LINES is set to 1; the
    capabilities clear, cup, cud, cud1, cuu1, cuu, vpa are disabled; and the
    home string is set to the value of cr.

    The nofilter routine cancels the effect of a preceding filter call. That
    allows the caller to initialize a screen on a different device, using a
    different value of $TERM. The limitation arises because the filter routine
    modifies the in-memory copy of the terminal information.

    The use_env routine, if used, is called before initscr or newterm are
    called. When called with FALSE as an argument, the values of lines and
    columns specified in the terminfo database will be used, even if environment
    variables LINES and COLUMNS (used by default) are set, or if curses is
    running in a window (in which case default behavior would be to use the
    window size if LINES and COLUMNS are not set). Note that setting LINES or
    COLUMNS overrides the corresponding size which may be obtained from the
    operating system.

    The putwin routine writes all data associated with window win into the file
    to which filep points. This information can be later retrieved using the
    getwin function.

    The getwin routine reads window related data stored in the file by putwin.
    The routine then creates and initializes a new window using that data. It
    returns a pointer to the new window.

    The delay_output routine inserts an ms millisecond pause in output. This
    routine should not be used extensively because padding characters are used
    rather than a CPU pause. If no padding character is specified, this uses
    napms to perform the delay.

    The flushinp routine throws away any typeahead that has been typed by the
    user and has not yet been read by the program. }
  function unctrl (c : chtype) : PChar; cdecl; external libNCurses;
  //function wunctrl (c : pcchar_t) : PWideChar; cdecl; external libNCurses;
  function keyname (c : Integer) : PChar; cdecl; external libNCurses;
  function keyname_sp (src : PSCREEN; c : Integer) : PChar; cdecl;
    external libNCurses;
  function key_name (w : WideChar) : PChar; cdecl; external libNCurses;
  procedure filter; cdecl; external libNCurses;
  procedure filter_sp (src : PSCREEN); cdecl; external libNCurses;
  procedure nofilter; cdecl; external libNCurses;
  procedure nofilter_sp (src : PCSREEN); cdecl; external libNCurses;
  procedure use_env (f : Boolean); cdecl; external libNCurses;
  procedure use_env_sp (src : PSCREEN; f : Boolean); cdecl; external libNCurses;
  function putwin (win : PWINDOW; filep : Pointer) : Integer; cdecl;
    external libNCurses;
  function getwin (filep : Pointer) : PWINDOW; cdecl; external libNCurses;
  function getwin_sp (src : PSCREEN; filep : Pointer) : PWINDOW; cdecl;
    external libNCurses;
  function delay_output (ms : Integer) : Integer; cdecl; external libNCurses;
  function delay_output_sp (src : PSCREEN; ms : Integer) : Integer; cdecl;
    external libNCurses;
  function flushinp : Integer; cdecl; external libNCurses;
  function flushinp_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  procedure use_tioctl (val : Boolean); cdecl; external libNCurses;
  procedure use_tioctl_sp (src : PSCREEN; val : Boolean); cdecl;
    external libNCurses;

  { These routines delete the character under the cursor; all characters to the
    right of the cursor on the same line are moved to the left one position and
    the last character on the line is filled with a blank. The cursor position
    does not change (after moving to y, x, if specified). (This does not imply
    use of the hardware delete character feature.) }
  function delch : Integer; cdecl; external libNCurses;
  function wdelch (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function mvdelch (y : Integer; x : Integer) : Integer; cdecl;
    external libNCurses;
  function mvwdelch (win : PWINDOW; y : Integer; x : Integer) : Integer; cdecl;
    external libNCurses;
  function mvcur (oldrow : Integer; oldcol : Integer; newrow : Integer;
    newcol : Integer) : Integer; cdecl; external libNCurses;
  function mvcur_sp (src : PSCREEN; oldrow : Integer; oldcol : Integer; newrow :
    Integer; newcol : Integer) : Integer; cdecl; external libNCurses;

  { initscr is normally the first curses routine to call when initializing a
    program. A few special routines sometimes need to be called before it; these
    are slk_init, filter, ripoffline, use_env. For multiple-terminal
    applications, newterm may be called before initscr.

    The initscr code determines the terminal type and initializes all curses
    data structures. initscr also causes the first call to refresh to clear the
    screen. If errors occur, initscr writes an appropriate error message to
    standard error and exits; otherwise, a pointer is returned to stdscr.

    A program that outputs to more than one terminal should use the newterm
    routine for each terminal instead of initscr. A program that needs to
    inspect capabilities, so it can continue to run in a line-oriented mode if
    the terminal cannot support a screen-oriented program, would also use
    newterm. The routine newterm should be called once for each terminal. It
    returns a variable of type SCREEN * which should be saved as a reference to
    that terminal. The arguments are the type of the terminal to be used in
    place of $TERM, a file pointer for output to the terminal, and another file
    pointer for input from the terminal (if type is NULL, $TERM will be used).
    The program must also call endwin for each terminal being used before
    exiting from curses. If newterm is called more than once for the same
    terminal, the first terminal referred to must be the last one for which
    endwin is called.

    A program should always call endwin before exiting or escaping from curses
    mode temporarily. This routine restores tty modes, moves the cursor to the
    lower left-hand corner of the screen and resets the terminal into the proper
    non-visual mode. Calling refresh or doupdate after a temporary escape causes
    the program to resume visual mode.

    The isendwin routine returns TRUE if endwin has been called without any
    subsequent calls to wrefresh, and FALSE otherwise.

    The set_term routine is used to switch between different terminals. The
    screen reference new becomes the new current terminal. The previous terminal
    is returned by the routine. This is the only routine which manipulates
    SCREEN pointers; all other routines affect only the current terminal.

    The delscreen routine frees storage associated with the SCREEN data
    structure. The endwin routine does not do this, so delscreen should be
    called after endwin if a particular SCREEN is no longer needed. }
  function initscr : PWINDOW; cdecl; external libNCurses;
  function endwin : Integer; cdecl; external libNCurses;
  function endwin_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function isendwin : Boolean; cdecl; external libNCurses;
  function isendwin_sp (src : PSCREEN) : Boolean; cdecl; external libNCurses;
  function newterm (_type : PChar; outfd : Pointer; infd : Pointer) : PSCREEN;
    cdecl; external libNCurses;
   function newterm_sp (src : PSCREEN; const _type : PChar; outfd : Pointer;
    infd : Pointer) : PSCREEN; cdecl; external libNCurses;
  function set_term (new : PSCREEN) : PSCREEN; cdecl; external libNCurses;
  procedure delscreen (sp : PSCREEN); cdecl; external libNCurses;

  { Calling newwin creates and returns a pointer to a new window with the given
    number of lines and columns. The upper left-hand corner of the window is at
    line begin_y, column begin_x. If either nlines or ncols is zero, they
    default to LINES - begin_y and COLS - begin_x. A new full-screen window is
    created by calling newwin(0,0,0,0).

    Calling delwin deletes the named window, freeing all memory associated with
    it (it does not actually erase the window's screen image). Subwindows must
    be deleted before the main window can be deleted.

    Calling mvwin moves the window so that the upper left-hand corner is at
    position (x, y). If the move would cause the window to be off the screen, it
    is an error and the window is not moved. Moving subwindows is allowed, but
    should be avoided.

    Calling subwin creates and returns a pointer to a new window with the given
    number of lines, nlines, and columns, ncols. The window is at position
    (begin_y, begin_x) on the screen. (This position is relative to the screen,
    and not to the window orig.) The window is made in the middle of the window
    orig, so that changes made to one window will affect both windows. The
    subwindow shares memory with the window orig. When using this routine, it is
    necessary to call touchwin or touchline on orig before calling wrefresh on
    the subwindow.

    Calling derwin is the same as calling subwin, except that begin_y and
    begin_x are relative to the origin of the window orig rather than the
    screen. There is no difference between the subwindows and the derived
    windows.

    Calling mvderwin moves a derived window (or subwindow) inside its parent
    window. The screen-relative parameters of the window are not changed. This
    routine is used to display different parts of the parent window at the same
    physical position on the screen.

    Calling dupwin creates an exact duplicate of the window win.

    Calling wsyncup touches all locations in ancestors of win that are changed
    in win. If syncok is called with second argument TRUE then wsyncup is called
    automatically whenever there is a change in the window.

    The wsyncdown routine touches each location in win that has been touched in
    any of its ancestor windows. This routine is called by wrefresh, so it
    should almost never be necessary to call it manually.

    The routine wcursyncup updates the current cursor position of all the
    ancestors of the window to reflect the current cursor position of the
    window. }
  function newwin (nlines : Integer; ncols : Integer; begin_y : Integer;
    begin_x : Intger) : PWINDOW; cdecl; external libNCurses;
  function newwin_sp (src : PSCREEN; nlines : Integer; ncols : Integer;
    begin_y : Integer; begin_x : Integer) : PWINDOW; cdecl; external libNCurses;
  function delwin (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function mvwin (win : PWINDOW; y : Integer; x : Integer) : Integer; cdecl;
    external libNCurses;
  function subwin (orig : PWINDOW; nlines : Integer; ncols : Integer; begin_y :
    Integer; begin_x : Integer) : PWINDOW; cdecl; external libNCurses;
  function derwin (orig : PWINDOW; nlines : Integer; ncols : Integer; begin_y :
    Integer; begin_x : Integer) : PWINDOW; cdecl; external libNCurses;
  function mvderwin (win : PWINDOW; par_y : Integer; par_x : Integer) : Integer;
    cdecl; external libNCurses;
  function dupwin (win : PWINDOW) : PWINDOW; cdecl; external libNCurses;
  procedure wsyncup (win : PWINDOW); cdecl; external libNCurses;
  function syncok (win : PWINDOW; bf : Boolean) : Integer; cdecl;
    external libNCurses;
  procedure wcursyncup (win : PWINDOW); cdecl; external libNCurses;
  procedure wsyncdown (win : PWINDOW); cdecl; external libNCurses;

  { The deleteln and wdeleteln routines delete the line under the cursor in the
    window; all lines below the current line are moved up one line. The bottom
    line of the window is cleared. The cursor position does not change.

    The insdelln and winsdelln routines, for positive n, insert n lines into the
    specified window above the current line. The n bottom lines are lost. For
    negative n, delete n lines (starting with the one under the cursor), and
    move the remaining lines up. The bottom n lines are cleared. The current
    cursor position remains the same.

    The insertln and winsertln routines insert a blank line above the current
    line and the bottom line is lost. }
  function deleteln : Integer; cdecl; external libNCurses;
  function wdeleteln (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function insdelln (n : Integer) : Integer; cdecl; external libNCurses;
  function winsdelln (win : PWINDOW; n : Integer) : Integer; cdecl;
    external libNCurses;
  function insertln : Integer; cdecl; external libNCurses;
  function winsertln (win : PWINDOW) : Integer; cdecl; external libNCurses;

  { The refresh and wrefresh routines (or wnoutrefresh and doupdate) must be
    called to get actual output to the terminal, as other routines merely
    manipulate data structures. The routine wrefresh copies the named window to
    the physical terminal screen, taking into account what is already there to
    do optimizations. The refresh routine is the same, using stdscr as the
    default window. Unless leaveok has been enabled, the physical cursor of the
    terminal is left at the location of the cursor for that window.

    The wnoutrefresh and doupdate routines allow multiple updates with more
    efficiency than wrefresh alone. In addition to all the window structures,
    curses keeps two data structures representing the terminal screen: a
    physical screen, describing what is actually on the screen, and a virtual
    screen, describing what the programmer wants to have on the screen.

    The routine wrefresh works by first calling wnoutrefresh, which copies the
    named window to the virtual screen, and then calling doupdate, which
    compares the virtual screen to the physical screen and does the actual
    update. If the programmer wishes to output several windows at once, a series
    of calls to wrefresh results in alternating calls to wnoutrefresh and
    doupdate, causing several bursts of output to the screen. By first calling
    wnoutrefresh for each window, it is then possible to call doupdate once,
    resulting in only one burst of output, with fewer total characters
    transmitted and less CPU time used. If the win argument to wrefresh is the
    global variable curscr, the screen is immediately cleared and repainted from
    scratch.

    The phrase "copies the named window to the virtual screen" above is
    ambiguous. What actually happens is that all touched (changed) lines in the
    window are copied to the virtual screen. This affects programs that use
    overlapping windows; it means that if two windows overlap, you can refresh
    them in either order and the overlap region will be modified only when it is
    explicitly changed. (But see the section on PORTABILITY below for a warning
    about exploiting this behavior.)

    The wredrawln routine indicates to curses that some screen lines are
    corrupted and should be thrown away before anything is written over them. It
    touches the indicated lines (marking them changed). The routine redrawwin()
    touches the entire window. }
  function refresh : Integer; cdecl; external libNCurses;
  function wrefresh (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function wnoutrefresh (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function doupdate : Integer; cdecl; external libNCurses;
  function doupdate_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function redrawwin (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function wredrawln (win : PWINDOW; beg_line : Integer; num_lines : Integer) :
    Integer; cdecl; external libNCurses;

  { The getch, wgetch, mvgetch and mvwgetch, routines read a character from the
    window. In no-delay mode, if no input is waiting, the value ERR is returned.
    In delay mode, the program waits until the system passes text through to the
    program. Depending on the setting of cbreak, this is after one character
    (cbreak mode), or after the first newline (nocbreak mode). In half-delay
    mode, the program waits until a character is typed or the specified timeout
    has been reached.

    Unless noecho has been set, then the character will also be echoed into the
    designated window according to the following rules: If the character is the
    current erase character, left arrow, or backspace, the cursor is moved one
    space to the left and that screen position is erased as if delch had been
    called. If the character value is any other KEY_ define, the user is alerted
    with a beep call. Otherwise the character is simply output to the screen.

    If the window is not a pad, and it has been moved or modified since the last
    call to wrefresh, wrefresh will be called before another character is read.

    If keypad is TRUE, and a function key is pressed, the token for that
    function key is returned instead of the raw characters. Possible function
    keys are defined in <curses.h> as macros with values outside the range of
    8-bit characters whose names begin with KEY_. Thus, a variable intended to
    hold the return value of a function key must be of short size or larger.

    When a character that could be the beginning of a function key is received
    (which, on modern terminals, means an escape character), curses sets a
    timer. If the remainder of the sequence does not come in within the
    designated time, the character is passed through; otherwise, the function
    key value is returned. For this reason, many terminals experience a delay
    between the time a user presses the escape key and the escape is returned to
    the program.

    The ungetch routine places ch back onto the input queue to be returned by
    the next call to wgetch. There is just one input queue for all windows. }
  function getch : Integer; cdecl; external libNCurses;
  function wgetch (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function mvgetch (y : Integer; x : Integer) : Integer; cdecl;
    external libNCurses;
  function mvwgetch (win : PWINDOW; y : Integer; x : Integer) : Integer; cdecl;
    external libNCurses;
  function ungetch (ch : Integer) : Integer; cdecl; external libNCurses;
  function ungetch_sp (src : PSCREEN; ch : Integer) : Integer; cdecl;
    external libNCurses;
  function has_key (ch : Integer) : Integer; cdecl; external libNCurses;
  function has_key_sp (src : PSCREEN; ch : Integer) : Integer; cdecl;
    external libNCurses;

  { The function getstr is equivalent to a series of calls to getch, until a
    newline or carriage return is received (the terminating character is not
    included in the returned string). The resulting value is placed in the area
    pointed to by the character pointer str.

    wgetnstr reads at most n characters, thus preventing a possible overflow of
    the input buffer. Any attempt to enter more characters (other than the
    terminating newline or carriage return) causes a beep. Function keys also
    cause a beep and are ignored. The getnstr function reads from the stdscr
    default window.

    The user's erase and kill characters are interpreted. If keypad mode is on
    for the window, KEY_LEFT and KEY_BACKSPACE are both considered equivalent to
    the user's kill character.

    Characters input are echoed only if echo is currently on. In that case,
    backspace is echoed as deletion of the previous character (typically a left
    motion). }
  function getstr (str : PChar) : Integer; cdecl; external libNCurses;
  function getnstr (str : PChar; n : Integer) : Integer; cdecl;
    external libNCurses;
  function wgetstr (win : PWINDOW; str : PChar) : Integer; cdecl;
    external libNCurses;
  function wgetnstr (win : PWINDOW; str : PChar; n : Integer) : Integer; cdecl;
    external libNCurses;
  function mvgetstr (y : Integer; x : Integer; str : PChar) : Integer; cdecl;
    external libNCurses;
  function mvwgetstr (win : PWINDOW; y : Integer; x : Integer; str : PChar) :
    Integer; cdecl; external libNCurses;
  function mvgetnstr (y : Integer; x : Integer; str : PChar; n : Integer) :
    Integer; cdecl; external libNCurses;
  function mvwgetnstr (win : PWINDOW;  y : Integer; x : Integer; str : PChar;
    n : Integer) : Integer; cdecl; external libNCurses;

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

  { These routines return the character, of type chtype, at the current position
    in the named window. If any attributes are set for that position, their
    values are OR'ed into the value returned. Constants defined in <curses.h>
    can be used with the & (logical AND) operator to extract the character or
    attributes alone. }
  function inch : chtype; cdecl; external libNCurses;
  function winch (win : PWINDOW) : chtype; cdecl; external libNCurses;
  function mvinch (y : Integer; x : Integer) : chtype; cdecl;
    external libNCurses;
  function mvwinch (win : PWINDOW; y : Integer; x : Integer) : chtype; cdecl;
    external libNCurses;

  { These routines return a NULL-terminated array of chtype quantities, starting
    at the current cursor position in the named window and ending at the right
    margin of the window. The four functions with n as the last argument, return
    a leading substring at most n characters long (exclusive of the trailing
    (chtype)0). Constants defined in <curses.h> can be used with the & (logical
    AND) operator to extract the character or the attribute alone from any
    position in the chstr [see curs_inch]. }
  function inchstr (chstr : pchtype) : Integer; cdecl; external libNCurses;
  function inchnstr (chstr : pchtype; n : Integer) : Integer; cdecl;
    external libNCurses;
  function winchstr (win : PWINDOW; chstr : pchtype) : Integer; cdecl;
    external libNCurses;
  function winchnstr (win : PWINDOW; chstr : pchtype; n : Integer) : Integer;
    cdecl; external libNCurses;
  function mvinchstr (y : Integer; x : Integer; chstr : pchtype) : Integer;
    cdecl; external libNCurses;
  function mvinchnstr (y : Integer; x : Integer; chstr : pchtype; n : Integer) :
    Integer; cdecl; external libNCurses;
  function mvwinchstr (win : PWINDOW; y : Integer; x : Integer; chstr : pchtype)
    : Integer; cdecl; external libNCurses;
  function mvwinchnstr (win : PWINDOW; y : Integer; x : Integer;
    chstr : pchtype; n : Integer) : Integer; cdecl; external libNCurses;

  { These routines return a string of characters in str, extracted starting at
    the current cursor position in the named window. Attributes are stripped
    from the characters. The four functions with n as the last argument return a
    leading substring at most n characters long (exclusive of the trailing
    NUL). }
  function instr (str : PChar) : Integer; cdecl; external libNCurses;
  function innstr (str : PChar; n : Integer) : Integer; cdecl;
    external libNCurses;
  function winstr (win : PWINDOW; str : PChar) : Integer; cdecl;
    external libNCurses;
  function winnstr (win : PWINDOW; str : PChar; n : Integer) : Integer; cdecl;
    external libNCurses;
  function mvinstr (y : Integer; x : Integer; str : PChar) : Integer; cdecl;
    external libNCurses;
  function mvinnstr (y : Integer; x : Integer; str : PChar; n : Integer) :
    Integer; cdecl; external libNCurses;
  function mvwinstr (win : PWINDOW; y : Integer; x : Integer; str : PChar) :
    Integer; cdecl; external libNCurses;
  function mvwinnstr (win : PWINDOW; y : Integer; x : Integer; str : PChar;
    n : Integer) : Integer; cdecl; external libNCurses;

  { The refresh and wrefresh routines (or wnoutrefresh and doupdate) must be
    called to get actual output to the terminal, as other routines merely
    manipulate data structures. The routine wrefresh copies the named window to
    the physical terminal screen, taking into account what is already there to
    do optimizations. The refresh routine is the same, using stdscr as the
    default window. Unless leaveok has been enabled, the physical cursor of the
    terminal is left at the location of the cursor for that window.

    The wnoutrefresh and doupdate routines allow multiple updates with more
    efficiency than wrefresh alone. In addition to all the window structures,
    curses keeps two data structures representing the terminal screen: a
    physical screen, describing what is actually on the screen, and a virtual
    screen, describing what the programmer wants to have on the screen.

    The routine wrefresh works by first calling wnoutrefresh, which copies the
    named window to the virtual screen, and then calling doupdate, which
    compares the virtual screen to the physical screen and does the actual
    update. If the programmer wishes to output several windows at once, a series
    of calls to wrefresh results in alternating calls to wnoutrefresh and
    doupdate, causing several bursts of output to the screen. By first calling
    wnoutrefresh for each window, it is then possible to call doupdate once,
    resulting in only one burst of output, with fewer total characters
    transmitted and less CPU time used. If the win argument to wrefresh is the
    global variable curscr, the screen is immediately cleared and repainted from
    scratch.

    The phrase "copies the named window to the virtual screen" above is
    ambiguous. What actually happens is that all touched (changed) lines in the
    window are copied to the virtual screen. This affects programs that use
    overlapping windows; it means that if two windows overlap, you can refresh
    them in either order and the overlap region will be modified only when it is
    explicitly changed. (But see the section on PORTABILITY below for a warning
    about exploiting this behavior.)

    The wredrawln routine indicates to curses that some screen lines are
    corrupted and should be thrown away before anything is written over them. It
    touches the indicated lines (marking them changed). The routine redrawwin()
    touches the entire window. }
  function refresh : Integer; cdecl; external libNCurses;
  function wrefresh (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function wnoutrefresh (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function doupdate : Integer; cdecl; external libNCurses;
  function redrawwin (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function wredrawln (win : PWINDOW; beg_line : Integer; num_lines : Integer) :
    Integer; cdecl; external libNCurses;

  { These routines insert the character ch before the character under the
    cursor. All characters to the right of the cursor are moved one space to the
    right, with the possibility of the rightmost character on the line being
    lost. The insertion operation does not change the cursor position. }
  function insch (ch : chtype) : Integer; cdecl; external libNCurses;
  function winsch (win : PWINDOW; ch : chtype) : Integer; cdecl;
    external libNCurses;
  function mvinsch (y : Integer; x : Integer; ch : chtype) : Integer; cdecl;
    external libNCurses;
  function mvwinsch (win : PWINDOW; y : Integer; x : Integer; ch : chtype) :
    Integer; cdecl; external libNCurses;

  { These routines insert a character string (as many characters as will fit on
    the line) before the character under the cursor. All characters to the right
    of the cursor are shifted right with the possibility of the rightmost
    characters on the line being lost. The cursor position does not change
    (after moving to y, x, if specified). The functions with n as the last
    argument insert a leading substring of at most n characters. If n<=0, then
    the entire string is inserted. }
  function insstr (const str : PChar) : Integer; cdecl; external libNCurses;
  function insnstr (const str : PChar; n : Integer) : Integer; cdecl;
    external libNCurses;
  function winsstr (win : PWINDOW; const str : PChar) : Integer; cdecl;
    external libNCurses;
  function winsnstr (win : PWINDOW; const str : PChar; n : Integer) : Integer;
    cdecl; external libNCurses;
  function mvinsstr (y : Integer; x : Integer; const str : PChar) : Integer;
    cdecl; external libNCurses;
  function mvinsnstr (y : Integer; x : Integer; const str : PChar; n : Integer)
    : Integer; cdecl; external libNCurses;
  function mvwinsstr (win : PWINDOW; y : Integer; x : Integer; const str :
    PChar) : Integer; cdecl; external libNCurses;
  function mvwinsnstr (win : PWINDOW; y : Integer; x : Integer; const str :
    PChar; n : Integer) : Integer; cdecl; external libNCurses;

  { The touchwin and touchline routines throw away all optimization information
    about which parts of the window have been touched, by pretending that the
    entire window has been drawn on. This is sometimes necessary when using
    overlapping windows, since a change to one window affects the other window,
    but the records of which lines have been changed in the other window do not
    reflect the change. The routine touchline only pretends that count lines
    have been changed, beginning with line start.

    The untouchwin routine marks all lines in the window as unchanged since the
    last call to wrefresh.

    The wtouchln routine makes n lines in the window, starting at line y, look
    as if they have (changed=1) or have not (changed=0) been changed since the
    last call to wrefresh.

    The is_linetouched and is_wintouched routines return TRUE if the specified
    line/window was modified since the last call to wrefresh; otherwise they
    return FALSE. In addition, is_linetouched returns ERR if line is not valid
    for the given window. }
  function touchwin (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function touchline (win : PWINDOW; start : Integer; count : Integer) :
    Integer; cdecl; external libNCurses;
  function untouchwin (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function wtouchln (win : PWINDOW; y : Integer; n : Integer; changed : Integer)
    : Integer; cdecl; external libNCurses;
  function is_linetouched (win : PWINDOW; line : Integer) : Boolean; cdecl;
    external libNCurses;
  function is_wintouched (win : PWINDOW) : Boolean; cdecl; external libNCurses;

  { These routines move the cursor associated with the window to line y and
    column x. This routine does not move the physical cursor of the terminal
    until refresh is called. The position specified is relative to the upper
    left-hand corner of the window, which is (0,0). }
  function move (y : Integer; x : Integer) : Integer; cdecl;
    external libNCurses;
  function wmove (win : PWindow; y : Integer; x : Integer) : Integer; cdecl;
    external libNCurses;

  { The printw, wprintw, mvprintw and mvwprintw routines are analogous to printf
    [see printf]. In effect, the string that would be output by printf is output
    instead as though waddstr were used on the given window.

    The vwprintw and wv_printw routines are analogous to vprintf [see printf]
    and perform a wprintw using a variable argument list. The third argument is
    a va_list, a pointer to a list of arguments, as defined in <stdarg.h>. }
  function printw (const fmt : PChar) : Integer; cdecl; varargs;
    external libNCurses;
  function wprintw (win : PWINDOW; const ftm : PChar) : Integer; cdecl; varargs;
    external libNCurses;
  function mvprintw (y : Integer; x : Integer; const ftm : PChar) : Integer;
    cdecl; varargs; external libNCurses;
  function mvwprintw (win : PWINDOW; y : Integer; x : Integer; const fmt :
    PChar) : Integer; cdecl; varargs; external libNCurses;
  function vwprintw (win : PWINDOW; const fmt : PChar) : Integer; cdecl;
    varargs; external libNCurses;
  function vw_printw (win : PWINDOW; const fmt : PChar) : Integer; cdecl;
    varargs; external libNCurses;

  { The scanw, wscanw and mvscanw routines are analogous to scanf [see scanf].
    The effect of these routines is as though wgetstr were called on the window,
    and the resulting line used as input for sscanf. Fields which do not map to
    a variable in the fmt field are lost.

    The vwscanw and vw_scanw routines are analogous to vscanf. They perform a
    wscanw using a variable argument list. The third argument is a va_list, a
    pointer to a list of arguments, as defined in <stdarg.h>. }
  function scanw (fmt : PChar) : Integer; cdecl; varargs; external libNCurses;
  function wscanw (win : PWINDOW; ftm : PChar) : Integer; cdecl; varargs;
    external libNCurses;
  function mvscanw (y : Integer; x : Integer; fmt : PChar) : Integer; cdecl;
    varargs; external libNCurses;
  function mvwscanw (win : PWINDOW; y : Integer; x : Integer; fmt : PChar) :
    Integer; cdecl; varargs; external libNCurses;
  function vw_scanw (win : PWINDOW; fmt : PChar) : Integer; cdecl; varargs;
    external libNCurses;
  function vwscanw (win : PWINDOW; fmt : PChar) : Integer; cdecl; varargs;
    external libNCurses;

  { The newpad routine creates and returns a pointer to a new pad data structure
    with the given number of lines, nlines, and columns, ncols. A pad is like a
    window, except that it is not restricted by the screen size, and is not
    necessarily associated with a particular part of the screen. Pads can be
    used when a large window is needed, and only a part of the window will be on
    the screen at one time. Automatic refreshes of pads (e.g., from scrolling or
    echoing of input) do not occur. It is not legal to call wrefresh with a pad
    as an argument; the routines prefresh or pnoutrefresh should be called
    instead. Note that these routines require additional parameters to specify
    the part of the pad to be displayed and the location on the screen to be
    used for the display.

    The subpad routine creates and returns a pointer to a subwindow within a pad
    with the given number of lines, nlines, and columns, ncols. Unlike subwin,
    which uses screen coordinates, the window is at position (begin_x, begin_y)
    on the pad. The window is made in the middle of the window orig, so that
    changes made to one window affect both windows. During the use of this
    routine, it will often be necessary to call touchwin or touchline on orig
    before calling prefresh.

    The prefresh and pnoutrefresh routines are analogous to wrefresh and
    wnoutrefresh except that they relate to pads instead of windows. The
    additional parameters are needed to indicate what part of the pad and screen
    are involved. pminrow and pmincol specify the upper left-hand corner of the
    rectangle to be displayed in the pad. sminrow, smincol, smaxrow, and smaxcol
    specify the edges of the rectangle to be displayed on the screen. The lower
    right-hand corner of the rectangle to be displayed in the pad is calculated
    from the screen coordinates, since the rectangles must be the same size.
    Both rectangles must be entirely contained within their respective
    structures. Negative values of pminrow, pmincol, sminrow, or smincol are
    treated as if they were zero.

    The pechochar routine is functionally equivalent to a call to addch followed
    by a call to refresh, a call to waddch followed by a call to wrefresh, or a
    call to waddch followed by a call to prefresh. The knowledge that only a
    single character is being output is taken into consideration and, for
    non-control characters, a considerable performance gain might be seen by
    using these routines instead of their equivalents. In the case of pechochar,
    the last location of the pad on the screen is reused for the arguments to
    prefresh.

    The pecho_wchar function is the analogous wide-character form of pechochar.
    It outputs one character to a pad and immediately refreshes the pad. It does
    this by a call to wadd_wch followed by a call to prefresh. }
  function newpad (nlines : Integer; ncols : Integer) : PWINDOW; cdecl;
    external libNCurses;
  function newpad_sp (src : PSCREEN; nlines : Integer; ncols : Integer) :
    PWINDOW; cdecl; external libNCurses;
  function subpad (orig : PWINDOW; nlines : Integer; ncols : Integer; begin_y :
    Integer; begin_x : Integer) : PWINDOW; cdecl; external libNCurses;
  function prefresh (pad : PWINDOW; pminrow : Integer; pmincol : Integer;
    sminrow : Integer; smincol : Integer; smaxrow : Integer; smaxcol : Integer)
    : Integer; cdecl; external libNCurses;
  function pnoutrefresh (pad : PWINDOW; pminrow : Integer; pmincol : Integer;
    sminrow : Integer; smincol : Integer; smaxrow : Integer; smaxcol : Integer)
    : Integer; cdecl; external libNCurses;
  function pechochar (pad : PWINDOW; ch : chtype) : Integer; cdecl;
    external libNCurses;
  //function pecho_wchar (pad : PWINDOW; const wch : cchar_t) : Integer; cdecl;
  //  external libNCurses;

  { The scr_dump routine dumps the current contents of the virtual screen to the
    file filename.

    The scr_restore routine sets the virtual screen to the contents of filename,
    which must have been written using scr_dump. The next call to doupdate
    restores the screen to the way it looked in the dump file.

    The scr_init routine reads in the contents of filename and uses them to
    initialize the curses data structures about what the terminal currently has
    on its screen. If the data is determined to be valid, curses bases its next
    update of the screen on this information rather than clearing the screen and
    starting from scratch. scr_init is used after initscr or a system call to
    share the screen with another process which has done a scr_dump after its
    endwin call. The data is declared invalid if the terminfo capabilities rmcup
    and nrrmc exist; also if the terminal has been written to since the
    preceding scr_dump call.

    The scr_set routine is a combination of scr_restore and scr_init. It tells
    the program that the information in filename is what is currently on the
    screen, and also what the program wants on the screen. This can be thought
    of as a screen inheritance function.

    To read (write) a window from (to) a file, use the getwin and putwin
    routines [see curs_util]. }
  function scr_dump (const filename : PChar) : Integer; cdecl;
    external libNCurses;
  function scr_restore (const filename : PChar) : Integer; cdecl;
    external libNCurses;
  function scr_restore_sp (src : PSCREEN; const filename : PChar) : Integer;
    cdecl; external libNCurses;
  function scr_init (const filename : PChar) : Integer; cdecl;
    external libNCurses;
  function scr_init_sp (src : PSCREEN; const filename : PChar) : Integer; cdecl;
    external libNCurses;
  function scr_set (const filename : PChar) : Integer; cdecl;
    external libNCurses;
  function scr_set_sp (src : PSCREEN; const filename : PChar) : Integer; cdecl;
    external libNCurses;

  { The scroll routine scrolls the window up one line. This involves moving the
    lines in the window data structure. As an optimization, if the scrolling
    region of the window is the entire screen, the physical screen may be
    scrolled at the same time.

    For positive n, the scrl and wscrl routines scroll the window up n lines
    (line i+n becomes i); otherwise scroll the window down n lines. This
    involves moving the lines in the window character image structure. The
    current cursor position is not changed.

    For these functions to work, scrolling must be enabled via scrollok. }
  function scroll (win : PWINDOW) : Integer; cdecl; external libNCurses;
  function scrl (n : Integer) : Integer; cdecl; external libNCurses;
  function wscrl (win : PWINDOW; n : Integer) : Integer; cdecl;
    external libNCurses;

  { The slk* functions manipulate the set of soft function-key labels that exist
    on many terminals. For those terminals that do not have soft labels, curses
    takes over the bottom line of stdscr, reducing the size of stdscr and the
    variable LINES. curses standardizes on eight labels of up to eight
    characters each. In addition to this, the ncurses implementation supports a
    mode where it simulates 12 labels of up to five characters each. This is
    most common for todays PC like enduser devices. Please note that ncurses
    simulates this mode by taking over up to two lines at the bottom of the
    screen, it does not try to use any hardware support for this mode.

    The slk_init routine must be called before initscr or newterm is called. If
    initscr eventually uses a line from stdscr to emulate the soft labels, then
    fmt determines how the labels are arranged on the screen. Setting fmt to 0
    indicates a 3-2-3 arrangement of the labels, 1 indicates a 4-4 arrangement
    and 2 indicates the PC like 4-4-4 mode. If fmt is set to 3, it is again the
    PC like 4-4-4 mode, but in addition an index line is generated, helping the
    user to identify the key numbers easily.

    The slk_set routine requires labnum to be a label number, from 1 to 8 (resp.
    12); label must be the string to be put on the label, up to eight (resp.
    five) characters in length. A null string or a null pointer sets up a blank
    label. fmt is either 0, 1, or 2, indicating whether the label is to be
    left-justified, centered, or right-justified, respectively, within the
    label.

    The slk_refresh and slk_noutrefresh routines correspond to the wrefresh and
    wnoutrefresh routines.

    The slk_label routine returns the current label for label number labnum,
    with leading and trailing blanks stripped.

    The slk_clear routine clears the soft labels from the screen.

    The slk_restore routine restores the soft labels to the screen after a
    slk_clear has been performed.

    The slk_touch routine forces all the soft labels to be output the next time
    a slk_noutrefresh is performed.

    The slk_attron, slk_attrset, slk_attroff and slk_attr routines correspond to
    attron, attrset, attroff and attr_get. They have an effect only if soft
    labels are simulated on the bottom line of the screen. The default highlight
    for soft keys is A_STANDOUT (as in System V curses, which does not document
    this fact).

    The slk_color routine corresponds to color_set. It has an effect only if
    soft labels are simulated on the bottom line of the screen. }
  function slk_init (fmt : Integer) : Integer; cdecl; external libNCurses;
  function slk_init_sp (src : PSCREEN; fmt : Integer) : Integer; cdecl;
    external libNCurses;
  function slk_set (labnum : Integer; const lbl : PChar; fmt : Integer) :
    Integer; cdecl; external libNCurses;
  function slk_set_sp (src : PSCREEN; labnum : Integer; const lbl : PChar;
    fmt : Integer) : Integer; cdecl; external libNCurses;
  function slk_refresh : Integer; cdecl; external libNCurses;
  function slk_refresh_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function slk_noutrefresh : Integer; cdecl; external libNCurses;
  function slk_noutrefresh_sp (src : PSCREEN) : Integer; cdecl;
    external libNCurses;
  function slk_label (labnum : Integer) : PChar; cdecl; external libNCurses;
  function slk_label_sp (src : PSCREEN; labnum : Integer) : PChar; cdecl;
    external libNCurses;
  function slk_clear : Integer; cdecl; external libNCurses;
  function slk_clear_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function slk_restore : Integer; cdecl; external libNCurses;
  function slk_restore_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function slk_touch : Integer; cdecl; external libNCurses;
  function slk_touch_sp (src : PSCREEN) : Integer; cdecl; external libNCurses;
  function slk_attron (const attrs : chtype) : Integer; cdecl;
    external libNCurses;
  function slk_attron_sp (src : PSCREEN; const attrs : chtype) : Integer; cdecl;
    external libNCurses;
  function slk_attroff (const attrs : chtype) : Integer; cdecl;
    external libNCurses;
  function slk_attroff_sp (src : PSCREEN; const attrs : chtype) : Integer;
    cdecl; external libNCurses;
  function slk_attrset (const attrs : chtype) : Integer; cdecl;
    external libNCurses;
  function slk_attrset_sp (src : PSCREEN; const attrs : chtype) : Integer;
    cdecl; external libNCurses;
  function slk_attr_on (attrs : attr_t; opts : Pointer) : Integer; cdecl;
    external libNCurses;
  function slk_attr_off (const attrs : attr_t; opts : Pointer) : Integer; cdecl;
    external libNCurses;
  function slk_attr_set (const attrs : attr_t; color_pair_number : Shortint;
    opts : Pointer) : Integer; cdecl; external libNCurses;
  function slk_attr_set_sp (src : PSCREEN; const attrs : attr_t;
    color_pair_number : NCURSES_PAIRS_T; opts : Pointer) : Integer; cdecl;
    external libNCurses;
  function slk_attr : attr_t; cdecl; external libNCurses;
  function slk_attr_sp (src : PSCREEN) : attr_t; cdecl; external libNCurses;
  function slk_color (color_pair_number : Shortint) : Integer; cdecl;
    external libNCurses;
  function slk_color_sp (src : PSCREEN; color_pair_number : NCURSES_PAIRS_T) :
    Integer; cdecl; external libNCurses;
  function extended_slk_color (val : Integer) : Integer; cdecl;
    external libNCurses;
  function extended_slk_color_sp (src : PSCREEN; val : Integer) : Integer;
    cdecl; external libNCurses;

  { The vidputs routine displays the string on the terminal in the video
    attribute mode attrs, which is any combination of the attributes listed in
    curses. The characters are passed to the putchar-like routine putc.

    The vidattr routine is like the vidputs routine, except that it outputs
    through putchar.

    The vid_attr and vid_puts routines correspond to vidattr and vidputs,
    respectively. They use a set of arguments for representing the video
    attributes plus color, i.e., one of type attr_t for the attributes and one
    of short for the color_pair number. The vid_attr and vid_puts routines are
    designed to use the attribute constants with the WA_ prefix. The opts
    argument is reserved for future use. Currently, applications must provide a
    null pointer for that argument. }
  function vidputs (attrs : chtype; putc : NCURSES_OUTC) : Integer; cdecl;
    external libNCurses;
  function vidputs_sp (src : PSCREEN; attrs : chtype; putc : NCURSES_SP_OUTC) :
    Integer; cdecl; external libNCurses;
  function vidattr (attrs : chtype) : Integer; cdecl; external libNCurses;
  function vidattr_sp (src : PSCREEN; attrs : chtype) : Integer; cdecl;
    external libNCurses;

  { These low-level routines must be called by programs that have to deal
    directly with the terminfo database to handle certain terminal capabilities,
    such as programming function keys. For all other functionality, curses
    routines are more suitable and their use is recommended. }
  function tigetflag (const capname : PChar) : Integer; cdecl;
    external libNCurses;
  function tigetnum (const capname : PChar) : Integer; cdecl;
    external libNCurses;
  function tigetstr (const capname : PChar) : PChar; cdecl;
    external libNCurses;
  function putp (const str : PChar) : Integer; cdecl; external libNCurses;
  function tparm (const str : PChar) : PChar; cdecl; varargs;
    external libNCurses;
  function tiparm (const str : PChar) : PChar; cdecl; varargs;
    external libNCurses;

  { These functions are not in X/Open, but we use them in macro definitions: }
  function getattrs (const win : PWINDOW) : Integer; cdecl; external libNCurses;
  function getcurx (const win : PWINDOW) : Integer; cdecl; external libNCurses;
  function getcury (const win : PWINDOW) : Integer; cdecl; external libNCurses;
  function getbegx (const win : PWINDOW) : Integer; cdecl; external libNCurses;
  function getbegy (const win : PWINDOW) : Integer; cdecl; external libNCurses;
  function getmaxx (const win : PWINDOW) : Integer; cdecl; external libNCurses;
  function getmaxy (const win : PWINDOW) : Integer; cdecl; external libNCurses;
  function getparx (const win : PWINDOW) : Integer; cdecl; external libNCurses;
  function getpary (const win : PWINDOW) : Integer; cdecl; external libNCurses;

  { This is an extension to the curses library. It provides callers with a hook
    into the ncurses data to resize windows, primarily for use by programs
    running in an X Window terminal (e.g., xterm). The function resizeterm
    resizes the standard and current windows to the specified dimensions, and
    adjusts other bookkeeping data used by the ncurses library that record the
    window dimensions.

    Most of the work is done by the inner function resize_term. The outer
    function resizeterm adds bookkeeping for the SIGWINCH handler. When resizing
    the windows, resize_term blank-fills the areas that are extended. The
    calling application should fill in these areas with appropriate data. The
    resize_term function attempts to resize all windows. However, due to the
    calling convention of pads, it is not possible to resize these without
    additional interaction with the application.

    A support function is_term_resized is provided so that applications can
    check if the resize_term function would modify the window structures. It
    returns TRUE if the windows would be modified, and FALSE otherwise. }
  function is_term_resized (lines : Integer; columns : Integer) : Boolean;
    cdecl; external libNCurses;
  function is_term_resized_sp (src : PSCREEN; lines : Integer; columns :
    Integer) : Boolean; cdecl; external libNCurses;
  function resize_term (lines : Integer; columns : Integer) : Integer; cdecl;
    external libNCurses;
  function resize_term_sp (src : PSCREEN; lines : Integer; columns : Integer) :
    Integer; cdecl; external libNCurses;
  function resizeterm (lines : Integer; columns : Integer) : Integer; cdecl;
    external libNCurses;
  function resizeterm_sp (src : PSCREEN; lines : Integer; columns : Integer) :
    Integer; cdecl; external libNCurses;

  { This is an extension to the curses library. It permits an application to
    determine the string which is defined in the terminfo for specific
    keycodes. }
  function keybound (keycode : Integer; count : Integer) : PChar; cdecl
    external libNCurses;
  function keybound_sp (src : PSCREEN; keycode : Integer; count : Integer) :
    PChar; cdecl; external libNCurses;

  { These functions are extensions to the curses library which do not fit easily
    into other categories.

    Use curses_version() to get the version number, including patch level of the
    library, e.g., 5.0.19991023

    The use_extended_names() function controls whether the calling application
    is able to use user-defined or nonstandard names which may be compiled into
    the terminfo description, i.e., via the terminfo or termcap interfaces.
    Normally these names are available for use, since the essential decision is
    made by using the -x option of tic to compile extended terminal definitions.
    However you can disable this feature to ensure compatibility with other
    implementations of curses. }
  function curses_version : PChar; cdecl; external libNCurses;
  function use_extended_names (enable : Boolean) : Integer; cdecl;
    external libNCurses;
  function alloc_pair (val1 : Integer; val2 : Integer) : Integer; cdecl;
    external libNCurses;
  function alloc_pair_sp (src : PSCREEN; val1 : Integer; val2 : Integer) :
    Integer; cdecl; external libNCurses;

  { The use_default_colors() and assume_default_colors() functions are
    extensions to the curses library. They are used with terminals that support
    ISO 6429 color, or equivalent. These terminals allow the application to
    reset color to an unspecified default value (e.g., with SGR 39 or SGR 49).

    Applications that paint a colored background over the whole screen do not
    take advantage of SGR 39 and SGR 49. Some applications are designed to work
    with the default background, using colors only for text. For example, there
    are several implementations of the ls program which use colors to denote
    different file types or permissions. These "color ls" programs do not
    necessarily modify the background color, typically using only the setaf
    terminfo capability to set the foreground color. Full-screen applications
    that use default colors can achieve similar visual effects.

    The first function, use_default_colors() tells the curses library to assign
    terminal default foreground/background colors to color number -1. So
    init_pair(x,COLOR_RED,-1) will initialize pair x as red on default
    background and init_pair(x,-1,COLOR_BLUE) will initialize pair x as default
    foreground on blue.

    The other, assume_default_colors() is a refinement which tells which colors
    to paint for color pair 0. This function recognizes a special color
    number -1, which denotes the default terminal color.

    The following are equivalent:

        use_default_colors()
        assume_default_colors(-1,-1);
    These are ncurses extensions. For other curses implementations, color
    number -1 does not mean anything, just as for ncurses before a successful
    call of use_default_colors() or assume_default_colors().

    Other curses implementations do not allow an application to modify color
    pair 0. They assume that the background is COLOR_BLACK, but do not ensure
    that the color pair 0 is painted to match the assumption. If your
    application does not use either use_default_colors() or
    assume_default_colors() ncurses will paint a white foreground (text) with
    black background for color pair 0. }
  function use_default_colors : Integer; cdecl; external libNCurses;
  function use_default_colors_sp (src : PSCREEN) : Integer; cdecl;
    external libNCurses;
  function assume_default_colors (fg : Integer; bg : Integer) : Integer; cdecl;
    external libNCurses;
  function assume_default_colors_sp (src : PSCREEN; fg : Integer; bg : Integer)
    : Integer; cdecl; external libNCurses;
  function extended_color_content (val : Integer; ptr1 : PInteger; ptr2 :
    PInteger; ptr3 : PInteger) : Integer; cdecl; external libNCurses;
  function extended_color_content_sp (src : PSCREEN; val : Integer; ptr1 :
    PInteger; ptr2 : PInteger; ptr3 : PInteger) : Integer; cdecl;
    external libNCurses;
  function extended_pair_content (val : Integer; ptr1 : PInteger; ptr2 :
    PInteger) : Integer; cdecl; external libNCurses;
  function extended_pair_content_sp (src : PSCREEN; val : Integer; ptr1 :
    PInteger; ptr2 : PInteger) : Integer; cdecl; external libNCurses;

  { This is an extension to the curses library. It permits an application to
    define keycodes with their corresponding control strings, so that the
    ncurses library will interpret them just as it would the predefined codes in
    the terminfo database.

    If the given string is null, any existing definition for the keycode is
    removed. Similarly, if the given keycode is negative or zero, any existing
    string for the given definition is removed. }
  function define_key (const definition : PChar; keycode : Integer) : Integer;
    cdecl; external libNCurses;
  function define_key_sp (src : PSCREEN; const definishion : PChar; keycode :
    Integer) : Integer; cdecl; external libNCurses;

  { These functions are extensions - not in X/Open Curses. }
  function find_pair (val1 : Integer; val2 : Integer) : Integer; cdecl;
    external libNCurses;
  function find_pair_sp (src : PSCREEN; val1 : Integer; val2 : Integer) :
    Integer; cdecl; external libNCurses;
  function free_pair (val : Integer) : Integer; cdecl; external libNCurses;
  function free_pair_sp (src : PSCREEN; val : Integer) : Integer; cdecl;
    external libNCurses;
  function get_escdelay : Integer; cdecl; external libNCurses;
  function get_escdelay_sp (src : PSCREEN) : Integer; cdecl;
    external libNCurses;
  function init_extended_color (val1 : Integer; val2 : Integer; val3 :
    Integer; val4 : Integer) : Integer; cdecl; external libNCurses;
  function init_extended_color_sp (src : PSCREEN; val1 : Integer; val2 :
    Integer; val3 : Integer; val4 : Integer) : Integer; cdecl;
    external libNCurses;
  function init_extended_pair (val1 : Integer; val2 : Integer; val3 : Integer) :
    Integer; cdecl; external libNCurses;
  function init_extended_pair_sp (src : PSCREEN; val1 : Integer; val2 :
    Integer; val3 : Integer) : Integer; cdecl; external libNCurses;
  procedure reset_color_pairs; cdecl; external libNCurses;
  procedure reset_color_pairs_sp (src : PSCREEN); cdecl; external libNCurses;

  { This is an extension to the curses library. It permits an application to
    determine if a string is currently bound to any keycode. }
  function key_defined (const definition : PChar) : Integer; cdecl;
    external libNCurses;
  function key_defined_sp (src : PSCREEN; const definition : PChar) : Integer;
    cdecl; external libNCurses;

  { This is an extension to the curses library. It permits an application to
    disable specific keycodes, rather than use the keypad function to disable
    all keycodes. Keys that have been disabled can be reenabled. }
  function keyok (keycode : Integer; enable : Boolean) : Integer; cdecl;
    external libNCurses;
  function keyok_sp (src : PSCREEN; keycode : Integer; enable : Boolean) :
    Integer; cdecl; external libNCurses;

  { This is an extension to the curses library. It provides callers with a hook
    into the ncurses data to resize windows, primarily for use by programs
    running in an X Window terminal (e.g., xterm). The function resizeterm
    resizes the standard and current windows to the specified dimensions, and
    adjusts other bookkeeping data used by the ncurses library that record the
    window dimensions.

    Most of the work is done by the inner function resize_term. The outer
    function resizeterm adds bookkeeping for the SIGWINCH handler. When resizing
    the windows, resize_term blank-fills the areas that are extended. The
    calling application should fill in these areas with appropriate data. The
    resize_term function attempts to resize all windows. However, due to the
    calling convention of pads, it is not possible to resize these without
    additional interaction with the application.

    A support function is_term_resized is provided so that applications can
    check if the resize_term function would modify the window structures. It
    returns TRUE if the windows would be modified, and FALSE otherwise. }
  function is_term_resized (lines : Integer; columns : Integer) : Boolean;
    cdecl; external libNCurses;
  function resize_term (lines : Integer; columns : Integer) : Integer; cdecl;
    external libNCurses;
  function resizeterm (lines : Integer; columns : Integer) : Integer; cdecl;
    external libNCurses;

  { This implementation can be configured to provide rudimentary support for
    multi-threaded applications. This makes a different set of libraries, e.g.,
    libncursest since the binary interfaces are different.

    Rather than modify the interfaces to pass a thread specifier to each
    function, it adds a few functions which can be used in any configuration
    which hide the mutex's needed to prevent concurrent use of the global
    variables when configured for threading.

    In addition to forcing access to members of the WINDOW structure to be via
    functions (see curs_opaque(3x)), it makes functions of the common global
    variables, e.g., COLORS, COLOR_PAIRS, COLS, ESCDELAY, LINES, TABSIZE curscr,
    newscr and ttytype. Those variables are maintained as read-only values,
    stored in the SCREEN structure.

    Even this is not enough to make a thread-safe application using curses. A
    multi-threaded application would be expected to have threads updating
    separate windows (within the same device), or updating on separate screens
    (on different devices). Also, a few of the global variables are considered
    writable by some applications. The functions described here address these
    special situations.

    The ESCDELAY and TABSIZE global variables are modified by some applications.
    To modify them in any configuration, use the set_escdelay or set_tabsize
    functions. Other global variables are not modifiable.

    The use_window and use_screen functions provide coarse granularity mutexes
    for their respective WINDOW and SCREEN parameters, and call a user-supplied
    function, passing it a data parameter, and returning the value from the
    user-supplied function to the application. }
  function set_escdelay (size : Integer) : Integer; cdecl; external libNCurses;
  function set_escdelay_sp (src : PSCREEN; size : Integer) : Integer; cdecl;
    external libNCurses;
  function set_tabsize (size : Integer) : Integer; cdecl; external libNCurses;
  function set_tabsize_sp (src : PSCREEN; size : Integer) : Integer; cdecl;
    external libNCurses;
  function use_screen (scr : PSCREEN; func : NCURSES_WINDOW_CB; data : Pointer)
    : Integer; cdecl; external libNCurses;
  function use_window (win : PWINDOW; func : NCURSES_SCREEN_CB; data : Pointer)
    : Integer; cdecl; external libNCurses;

  { The use_legacy_coding() function is an extension to the curses library. It
    allows the caller to change the result of unctrl, and suppress related
    checks within the library that would normally cause nonprinting characters
    to be rendered in visible form. This affects only 8-bit characters.

    The level parameter controls the result:
        0 - the library functions normally, rendering nonprinting characters as
            described in unctrl.
        1 - the library ignores isprintf for codes in the range 160-255.
        2 - the library ignores isprintf for codes in the range 128-255. It also
            modifies the output of unctrl, showing codes in the range 128-159 as
            is. }
  function use_legacy_coding (level : Integer) : Integer; cdecl;
    external libNCurses;
  function use_legacy_coding_sp (src : PSCREEN; level : Integer) : Integer;
    cdecl; external libNCurses;

  { The wresize function reallocates storage for an ncurses window to adjust its
    dimensions to the specified values. If either dimension is larger than the
    current values, the window's data is filled with blanks that have the
    current background rendition (as set by wbkgndset) merged into them. }
  function wresize (win : PWINDOW; lines : Integer; columns : Integer) :
    Integer; cdecl; external libNCurses;

  { This implementation provides functions which return properties set in the
    WINDOW structure, allowing it to be ''opaque'' if the symbol NCURSES_OPAQUE
    is defined:

       is_cleared
            returns the value set in clearok
       is_idcok
            returns the value set in idcok
       is_idlok
            returns the value set in idlok
       is_immedok
            returns the value set in immedok
       is_keypad
            returns the value set in keypad
       is_leaveok
            returns the value set in leaveok
       is_nodelay
            returns the value set in nodelay
       is_notimeout
            returns the value set in notimeout
       is_scrollok
            returns the value set in scrollok
       is_syncok
            returns the value set in syncok
       wgetparent
            returns the parent WINDOW pointer for subwindows, or NULL for
            windows having no parent.
       wgetscrreg
            returns the top and bottom rows for the scrolling margin as set in
            wsetscrreg. }
  function is_cleared (const win : PWINDOW) : Boolean; cdecl;
    external libNCurses;
  function is_idcok (const win : PWINDOW) : Boolean; cdecl; external libNCurses;
  function is_idlok (const win : PWINDOW) : Boolean; cdecl; external libNCurses;
  function is_immedok (const win : PWINDOW) : Boolean; cdecl;
    external libNCurses;
  function is_keypad (const win : PWINDOW) : Boolean; cdecl;
    external libNCurses;
  function is_leaveok (const win : PWINDOW) : Boolean; cdecl;
    external libNCurses;
  function is_nodelay (const win : PWINDOW) : Boolean; cdecl;
    external libNCurses;
  function is_notimeout (const win : PWINDOW) : Boolean; cdecl;
    external libNCurses;
  function is_scrollok (const win : PWINDOW) : Boolean; cdecl;
    external libNCurses;
  function is_syncok (const win : PWINDOW) : Boolean; cdecl;
    external libNCurses;
  function wgetparent (const win : PWINDOW) : PWINDOW; cdecl;
    external libNCurses;
  function wgetscrreg (const win : PWINDOW; top : PInteger; bottom : PInteger) :
    Integer; cdecl; external libNCurses;
  function is_pad (const win : PWINDOW) : Boolean; cdecl; external libNCurses;
  function is_subwin (const win : PWINDOW) : Boolean; cdecl;
    external libNCurses;
  function wgetdelay (const win : PWINDOW) : Integer; cdecl;
    external libNCurses;

  { Extra extension-functions, which pass a SCREEN pointer rather than using
    a global variable SP. }
  function new_prescr : PSCREEN; cdecl; external libNCurses;

  { These functions provide an interface to mouse events from ncurses. Mouse
    events are represented by KEY_MOUSE pseudo-key values in the wgetch input
    stream.

    To make mouse events visible, use the mousemask function. This will set the
    mouse events to be reported. By default, no mouse events are reported. The
    function will return a mask to indicate which of the specified mouse events
    can be reported; on complete failure it returns 0. If oldmask is non-NULL,
    this function fills the indicated location with the previous value of the
    given window's mouse event mask.

    As a side effect, setting a zero mousemask may turn off the mouse pointer;
    setting a nonzero mask may turn it on. Whether this happens is
    device-dependent.

    Here are the mouse event type masks which may be defined:

         Once a class of mouse events have been made visible in a window,
         calling the wgetch function on that window may return KEY_MOUSE as an
         indicator that a mouse event has been queued. To read the event data
         and pop the event off the queue, call getmouse. This function will
         return OK if a mouse event is actually visible in the given window, ERR
         otherwise. When getmouse returns OK, the data deposited as y and x in
         the event structure coordinates will be screen-relative character-cell
         coordinates. The returned state mask will have exactly one bit set to
         indicate the event type.

         The ungetmouse function behaves analogously to ungetch. It pushes a
         KEY_MOUSE event onto the input queue, and associates with that event
         the given state data and screen-relative character-cell coordinates.

         The wenclose function tests whether a given pair of screen-relative
         character-cell coordinates is enclosed by a given window, returning
         TRUE if it is and FALSE otherwise. It is useful for determining what
         subset of the screen windows enclose the location of a mouse event.

         The wmouse_trafo function transforms a given pair of coordinates from
         stdscr-relative coordinates to coordinates relative to the given window
         or vice versa. Please remember, that stdscr-relative coordinates are
         not always identical to window-relative coordinates due to the
         mechanism to reserve lines on top or bottom of the screen for other
         purposes (see the ripoffline() and slk_init calls, for example). If the
         parameter to_screen is TRUE, the pointers pY, pX must reference the
         coordinates of a location inside the window win. They are converted to
         window-relative coordinates and returned through the pointers. If the
         conversion was successful, the function returns TRUE. If one of the
         parameters was NULL or the location is not inside the window, FALSE is
         returned. If to_screen is FALSE, the pointers pY, pX must reference
         window-relative coordinates. They are converted to stdscr-relative
         coordinates if the window win encloses this point. In this case the
         function returns TRUE. If one of the parameters is NULL or the point is
         not inside the window, FALSE is returned. Please notice, that the
         referenced coordinates are only replaced by the converted coordinates
         if the transformation was successful.

         The mouse_trafo function performs the same translation as wmouse_trafo,
         using stdscr for win.

         The mouseinterval function sets the maximum time (in thousands of a
         second) that can elapse between press and release events for them to be
         recognized as a click. Use mouseinterval(0) to disable click
         resolution. This function returns the previous interval value. Use
         mouseinterval(-1) to obtain the interval without altering it. The
         default is one sixth of a second.

         The has_mouse function returns TRUE if the mouse driver has been
         successfully initialized.

         Note that mouse events will be ignored when input is in cooked mode,
         and will cause an error beep when cooked mode is being simulated in a
         window by a function such as getstr that expects a linefeed for
         input-loop termination.

    mousemask returns the mask of reportable events.

    mouseinterval returns the previous interval value, unless the terminal was
    not initialized. In that case, it returns the maximum interval value (166).

    wenclose and wmouse_trafo are boolean functions returning TRUE or FALSE
    depending on their test result. }
  function has_mouse : Boolean; cdecl; external libNCurses;
  function has_mouse_sp (src : PSCREEN) : Boolean; cdecl; external libNCurses;
  function getmouse (event : PMEVENT) : Integer; cdecl; external libNCurses;
  function getmouse_sp (src : PSCREEN; event : PMEVENT) : Integer; cdecl;
    external libNCurses;
  function ungetmouse (event : PMEVENT) : Integer; cdecl; external libNCurses;
  function ungetmouse_sp (src : PSCREEN; event : PMEVENT) : Integer; cdecl;
    external libNCurses;
  function mousemask (newmask : mmask_t; oldmask : pmmask_t) : mmask_t; cdecl;
    external libNCurses;
  function mousemask_sp (src : PSCREEN; newmask : mmask_t; oldmask : pmmask_t) :
    mmask_t; cdecl; external libNCurses;
  function wenclose (const win : PWINDOW; y : Integer; x : Integer) : Boolean;
    cdecl; external libNCurses;
  function mouse_trafo (pY : PInteger; pX : PInteger; to_screen : Boolean) :
    Boolean; cdecl; external libNCurses;
  function wmouse_trafo (const win : PWINDOW; pY : PInteger; pX : PInteger;
    to_screen : Boolean) : Boolean; cdecl; external libNCurses;
  function mouseinterval (erval : Integer) : Integer; cdecl;
    external libNCurses;
  function mouseinterval_sp (src : PSCREEN; erval : Integer) : Integer; cdecl;
    external libNCurses;

  { This function uses the mc5p or mc4 and mc5 capabilities, if they are
    present, to ship given data to a printer attached to the terminal.

    Note that the mcprint code has no way to do flow control with the printer or
    to know how much buffering it has. Your application is responsible for
    keeping the rate of writes to the printer below its continuous throughput
    rate (typically about half of its nominal cps rating). Dot-matrix printers
    and 6-page-per-minute lasers can typically handle 80cps, so a good
    conservative rule of thumb is to sleep for a second after shipping each
    80-character line. }
  function mcprint (data : PChar; len : Integer) : Integer; cdecl;
    external libNCurses;
  function mcprint_sp (src : PSCREEN; data : PChar; len : Integer) : Integer;
    cdecl; external libNCurses;

  { The trace routines are used for debugging the ncurses libraries, as well as
    applications which use the ncurses libraries. These functions are normally
    available only with the debugging library libncurses_g.a, but may be
    compiled into any model (shared, static, profile) by defining the symbol
    TRACE.

    The principal parts of this interface are the trace routine which
    selectively enables different tracing features, and the _tracef routine
    which writes formatted data to the trace file.

    Calling trace with a nonzero parameter opens the file trace in the current
    directory for output. The parameter is formed by OR'ing values from the list
    of TRACE_xxx definitions in <curses.h>. These include:

       TRACE_DISABLE
          turn off tracing.
      TRACE_TIMES
          trace user and system times of updates.
      TRACE_TPUTS
          trace tputs calls.
      TRACE_UPDATE
          trace update actions, old & new screens.
      TRACE_MOVE
          trace cursor movement and scrolling.
      TRACE_CHARPUT
          trace all character outputs.
      TRACE_ORDINARY
          trace all update actions. The old and new screen contents are written
          to the trace file for each refresh.
      TRACE_CALLS
          trace all curses calls. The parameters for each call are traced, as
          well as return values.
      TRACE_VIRTPUT
          trace virtual character puts, i.e., calls to addch.
      TRACE_IEVENT
          trace low-level input processing, including timeouts.
      TRACE_BITS
          trace state of TTY control bits.
      TRACE_ICALLS
          trace internal/nested calls.
      TRACE_CCALLS
          trace per-character calls.
      TRACE_DATABASE
          trace read/write of terminfo/termcap data.
      TRACE_ATTRS
          trace changes to video attributes and colors.
      TRACE_MAXIMUM
          maximum trace level, enables all of the separate trace features.

    Some tracing features are enabled whenever the trace parameter is nonzero.
    Some features overlap. The specific names are used as a guideline. }
  procedure _tracef (const format : PChar); varargs; cdecl; external libNCurses;
  procedure _tracedump (const label_str : PChar; win : PWINDOW); cdecl;
    external libNCurses;
  function _traceattr (attr : attr_t) : PChar; cdecl; external libNCurses;
  function _traceattr2 (buffer : Integer; ch : chtype) : PChar; cdecl;
    external libNCurses;
  function _nc_tracebits : PChar; cdecl; external libNCurses;
  function _tracechar (val : Integer) : PChar; cdecl; external libNCurses;
  function _tracechtype (ch : chtype) : PChar; cdecl; external libNCurses;
  function _tracechtype2 (buffer : Integer; ch : chtype) : PChar; cdecl;
    external libNCurses;
  function _tracemouse (const event : PMEVENT) : PChar; cdecl;
    external libNCurses;
  procedure trace (const param : Cardinal); cdecl; external libNCurses;
  function curses_trace (const param : Cardinal) : Cardinal; cdecl;
    external libNCurses;

  procedure exit_curses (val : Integer); cdecl; external libNCurses;

implementation

end.

