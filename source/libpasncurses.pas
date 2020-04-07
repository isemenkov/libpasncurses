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

  chtype = type Cardinal;
  mmask_t = type Cardinal;

  { ...must be at least as wide as chtype }
  attr_t = chtype;

  NCURSES_BOOL = type Boolean;

  screen = type Pointer;
  SCREEN = screen;

  _win_st = type Pointer;
  WINDOW = _win_st;

  { cchar_t stores an array of CCHARW_MAX wide characters.  The first is
    normally a spacing character.  The others are non-spacing.  If those
    (spacing and nonspacing) do not fill the array, a null L'\0' follows.
    Otherwise, a null is assumed to follow when extracting via getcchar(). }
  cchar_t = record
    attr : attr_t;
    chars : WideString[CCHARW_MAX];
  end;



{var
  acs_map : array of chtype; external name 'acs_name';
}

implementation

end.

