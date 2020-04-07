unit pasncursestestcase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry;

type

  TTest = class(TTestCase)
  published
    procedure TestHookUp;
  end;

implementation

procedure TTest.TestHookUp;
begin
  Fail('Напишите ваш тест');
end;



initialization

  RegisterTest(TTest);
end.

