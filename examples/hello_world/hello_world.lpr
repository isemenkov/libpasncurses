program hello_world;

uses
  SysUtils, libpasncurses;

begin
  initscr;
  printw('Hello world!');
  refresh;
  getch;
  endwin;
end.

