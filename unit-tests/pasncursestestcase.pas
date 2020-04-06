unit pasncursestestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils;

type

  TTestCase= class(TTestCase)
  published
    procedure TestHookUp;
  end;

implementation

procedure TTestCase.TestHookUp;
begin
  Fail('Напишите ваш тест');
end;



initialization

  RegisterTest(TTestCase);
end.

