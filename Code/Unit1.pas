unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  Tform_LoadScreen = class(TForm)
    titleLbl: TLabel;
    leftBorderImg: TImage;
    rightBorderImg: TImage;
    captionLbl: TLabel;
    loadScrTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure LoadScrTimerActionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  form_LoadScreen: Tform_LoadScreen;
   mainTextColour : TColor;

implementation

{$R *.dfm}

uses Unit2;

procedure Tform_LoadScreen.LoadScrTimerActionClick(Sender: TObject);
begin
  //this function manages the timing and disappearance/transition of the load screen
 form_LoadScreen.Hide;
 form_homepage.show;
 form_LoadScreen.loadScrTimer.Enabled := false;
end;

procedure Tform_LoadScreen.FormCreate(Sender: TObject);
begin
//colour managment of the text on the page
mainTextColour := RGB(172, 105, 91);
titleLbl.Font.Color := mainTextColour;
captionLbl.Font.Color := mainTextColour;
end;



end.
