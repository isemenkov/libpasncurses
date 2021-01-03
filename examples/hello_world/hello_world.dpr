program hello_world;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, libpasncurses;

begin
  initscr;
  printw('Hello world!');
  refresh;
  getch;
  endwin;
end.
