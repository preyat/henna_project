program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {form_LoadScreen},
  Unit2 in 'Unit2.pas' {form_homepage};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tform_LoadScreen, form_LoadScreen);
  Application.CreateForm(Tform_homepage, form_homepage);
  Application.Run;
end.
