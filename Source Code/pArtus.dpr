program pArtus;

uses
  Forms,
  mArtus in 'mArtus.pas' {Artus},
  mUeber in 'mUeber.pas' {Ueber},
  mSpielfeld in 'mSpielfeld.pas',
  mKarte in 'mKarte.pas',
  mKante in 'mKante.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Artus Puzzle';
  Application.CreateForm(TArtus, Artus);
  Application.Run;
end.
