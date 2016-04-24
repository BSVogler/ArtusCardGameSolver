unit mUeber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XPMan;

type
  TUeber = class(TForm)
    laTitle: TLabel;
    laField1: TLabel;
    laField2: TLabel;
    laField3: TLabel;
    imPortrait: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
     procedure showinfoauthor;
     procedure showinfoprogramm;
  end;

var
  Ueber: TUeber;

implementation

{$R *.dfm}

procedure TUeber.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Ueber.Destroy;
  Ueber := nil;
end;

procedure TUeber.showinfoauthor;
begin
   Ueber.laTitle.Caption := 'Benedikt Vogler';
   Ueber.laField1.Caption := 'e-mail@benediktvogler.de';
   Ueber.laField2.Caption := 'www.benediktvogler.de';
   Ueber.laField3.Caption := 'Zum Zeitpunkt der Entwicklung Schüler der Stufe 11.';
   Ueber.imPortrait.Visible := True;
   Ueber.Show;
end;

procedure TUeber.showinfoprogramm;
begin
 Ueber.laTitle.Caption := 'Artus Puzzle Solver';
   Ueber.laField1.Caption := 'Version 1.0';
   Ueber.laField2.Caption := '(c) Benedikt Vogler, 2012';
   Ueber.laField3.Caption := 'Das Programm entstand im Rahmen der Facharbeit in Informatik im Q1 der Stufe 11 am Erasmus von Rotterdam Gymnasium Viersen. Fachlehrer ist Egon Klaus.';
   Ueber.imPortrait.Visible := False;
   Ueber.Show;
end;

end.
