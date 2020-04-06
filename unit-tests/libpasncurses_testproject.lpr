program libpasncurses_testproject;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, pasncursestestcase, libpasncurses;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

