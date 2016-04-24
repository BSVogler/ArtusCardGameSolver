unit mArtus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, Math, XPMan, mSpielfeld, mUeber,
  ComCtrls;

type
  TArtus = class(TForm)
    MainMenu: TMainMenu;
    cbAlgorithmus: TComboBox;
    miAnsicht: TMenuItem;
    miInfo: TMenuItem;
    miUeberprogramm: TMenuItem;
    cbAnzeigen: TCheckBox;
    XPManifest: TXPManifest;
    laAlgorithmus: TLabel;
    edZeit: TEdit;
    btStarten: TButton;
    laZeit: TLabel;
    btZeitschaetzen: TButton;
    laStrich: TLabel;
    edGeschaetzte: TEdit;
    imPfeil: TImage;
    miAutor: TMenuItem;
    miNummer: TMenuItem;
    miPasszahl: TMenuItem;
    miSeiten: TMenuItem;
    laErklaerung: TLabel;
    N1: TMenuItem;
    miEntwickler: TMenuItem;
    laLogdoppelpunkt: TLabel;
    bt_dev_drawfield: TButton;
    imRandomize: TImage;
    imReset: TImage;
    bt_dev_refreshPasszahl: TButton;
    laStrich2: TLabel;
    laStrich3: TLabel;
    laTablepoints: TLabel;
    bt_dev_Tablepoints: TButton;
    bt_dev_drehen: TButton;
    laTablepontstitel: TLabel;
    bt_dev_orientieren: TButton;
    laEinheit1: TLabel;
    miOptionen: TMenuItem;
    miDoublebuffered: TMenuItem;
    laEinheit2: TLabel;
    tbGenauigkeit: TTrackBar;
    laMintbp: TLabel;
    lbLog: TListBox;
    bt_dev_autoturn: TButton;
    laFortschritt: TLabel;
    miProcess: TMenuItem;
    rgDrehalgorithmus: TRadioGroup;
    gbEntwickler: TGroupBox;
    procedure FormCreate(Sender: TObject);
    procedure imPfeilClick(Sender: TObject);
    procedure cbAlgorithmusChange(Sender: TObject);
    procedure miUeberprogrammClick(Sender: TObject);
    procedure miNummerClick(Sender: TObject);
    procedure miPasszahlClick(Sender: TObject);
    procedure miSeitenClick(Sender: TObject);
    procedure miEntwicklerClick(Sender: TObject);
    procedure miDoublebufferedClick(Sender: TObject);
    procedure miProcessClick(Sender: TObject);
    procedure imResetClick(Sender: TObject);
    procedure cbAnzeigenClick(Sender: TObject);
    procedure bt_dev_refreshPasszahlClick(Sender: TObject);
    procedure bt_dev_drawfieldClick(Sender: TObject);
    procedure bt_dev_drehenClick(Sender: TObject);
    procedure bt_dev_TablepointsClick(Sender: TObject);
    procedure bt_dev_orientierenClick(Sender: TObject);
    procedure bt_dev_autoturnClick(Sender: TObject);
    procedure imRandomizeClick(Sender: TObject);
    procedure btZeitschaetzenClick(Sender: TObject);
    procedure btStartenClick(Sender: TObject);
    procedure tbGenauigkeitChange(Sender: TObject);
    procedure randomsolve(mintable:integer);
    procedure randomswitchsolve(mintable:integer);
    procedure miAutorClick(Sender: TObject);
  private
    Spielfeld: TSpielfeld;
    Speicher: array of array[0..9] of Integer;
    Schleifenbreak: boolean;
    appprocesslast: boolean;
    procedure savefield(extra:integer);
    procedure loadfield(slot:integer);
    procedure backtracking;
    procedure bruteforce();
    function bruteturn():integer;
    procedure autoturn();
  public
    { Public declarations }
  end;

var Artus: TArtus;

implementation

{$R *.dfm}

procedure TArtus.FormCreate(Sender: TObject);
begin
  //erstellt das Spielfeld
  Spielfeld := TSpielfeld.Create(Artus,laTablepoints,lbLog);
  Spielfeld.Parent := Artus;
  Spielfeld.Canvas.Rectangle(0, 0, Spielfeld.Width, Spielfeld.Height);
  //initialisiert den Zufallsgenerator
  Randomize;
  //startwert der Variable schleifenbreak setzen
  schleifenbreak := false;
end;

procedure TArtus.imPfeilClick(Sender: TObject);
begin
  //das Log ein- oder ausfahren
  if Artus.ClientWidth > 715
     then begin
             Artus.ClientWidth := 715;
             //Grafik des Buttons ändern
             imPfeil.Picture.loadfromfile('.\LogOut.bmp');
     end
     else begin
             Artus.ClientWidth := 955;
             imPfeil.Picture.loadfromfile('.\LogIn.bmp');
      end;
end;

procedure TArtus.cbAlgorithmusChange(Sender: TObject);
begin
  //Felder leeren
  edGeschaetzte.Text := '';
  edZeit.Text := '';
  //Einstellung je nach Algorithmuswahl verstecken/zeigen oder ändern
  case cbAlgorithmus.ItemIndex of
       0:begin
           laErklaerung.Caption := 'Der Bruteforce Algorithmus probiert systematisch alle Möglichkeiten durch.';
           edGeschaetzte.Visible := True;
           btZeitschaetzen.Visible := True;
           laEinheit1.Visible := True;
           laMintbp.Visible := False;
           tbGenauigkeit.Visible := False;
           rgDrehalgorithmus.Visible := False;
         end;
       1:begin
           laErklaerung.Caption := 'Der rekursive Backtracking Algorithmus geht alle erfolgreichen Wege bis zum Ende.';
           edGeschaetzte.Visible := False;
           btZeitschaetzen.Visible := False;
           laEinheit1.Visible := False;
           laMintbp.Visible := False;
           tbGenauigkeit.Visible := False;
           rgDrehalgorithmus.Visible := False;
         end;
       2:begin
           laErklaerung.Caption := 'Der randomswitchsolve Algorithmus tauscht (optimiert) zufällig, aber dreht mit einer gewählten Methode.';
           edGeschaetzte.Visible := False;
           btZeitschaetzen.Visible := False;
           laEinheit1.Visible := False;
           laMintbp.Visible := True;
           tbGenauigkeit.Visible := True;
           rgDrehalgorithmus.Visible := True;
         end;
       3:begin
            laErklaerung.Caption := 'Der randomsolve Algorithmus tauscht und dreht zufällig, bis die Lösung gefunden wird.';
            edGeschaetzte.Visible := True;
            btZeitschaetzen.Visible := True;
            laEinheit1.Visible := True;
            laMintbp.Visible := True;
            tbGenauigkeit.Visible := True;
            rgDrehalgorithmus.Visible := False;
         end;
    end;
end;

procedure TArtus.bt_dev_drawfieldClick(Sender: TObject);
begin
   Spielfeld.drawfield;
end;

procedure TArtus.miNummerClick(Sender: TObject);
begin
  if miNummer.Checked = True
     then begin
             //haken
             miNummer.Checked := False;
             Spielfeld.setDrawNummer(false);
          end
     else begin
             miNummer.Checked := True;
             Spielfeld.setDrawNummer(True);
          end;
  Spielfeld.drawfield;
end;

procedure TArtus.miPasszahlClick(Sender: TObject);
begin
   if miPasszahl.Checked = True
     then begin
             //haken
             miPasszahl.Checked := False;
             Spielfeld.setDrawPasszahl(false);
          end
     else begin
             miPasszahl.Checked := True;
             Spielfeld.setDrawPasszahl(True);
          end;
  Spielfeld.drawfield;
end;

procedure TArtus.miSeitenClick(Sender: TObject);
begin
  if miSeiten.Checked = True
     then begin
             //haken wegnehmen
             miSeiten.Checked := False;
             Spielfeld.setDrawSeiten(False);
          end
     else begin
             miSeiten.Checked := True;
             Spielfeld.setDrawSeiten(True);
          end;
  Spielfeld.drawfield;
end;

procedure TArtus.miEntwicklerClick(Sender: TObject);
begin
   if miEntwickler.Checked = True
      then begin
             miEntwickler.Checked := False;
             gbEntwickler.Visible := False;
             //Alternativ
             {for i := 0 to Artus.ComponentCount - 1 do
                 if pos('dev',Components[i].Name) = 4
                    then TButton(Components[i]).Visible := False;}
           end
      else begin
             miEntwickler.Checked := True;
             gbEntwickler.Visible := True;
           end;
end;

procedure TArtus.miDoublebufferedClick(Sender: TObject);
begin
  if miDoublebuffered.Checked = True
     then begin
             miDoublebuffered.Checked := False;
             lbLog.Items.Add('Deaktiviere Doublebuffered.')
          end
     else begin
             miDoublebuffered.Checked := True;
             lbLog.Items.Add('Aktiviere Doublebuffered.');
          end;
end;

procedure TArtus.miUeberprogrammClick(Sender: TObject);
begin
   if Ueber <> nil
      then Ueber.setfocus
      else Ueber := TUeber.Create(Artus);
   Ueber.showinfoprogramm;   
end;

procedure TArtus.miAutorClick(Sender: TObject);
begin
   if Ueber <> nil
       then Ueber.setfocus
       else Ueber := TUeber.Create(Artus);
   Ueber.showinfoauthor;
end;

procedure TArtus.bt_dev_refreshPasszahlClick(Sender: TObject);
begin
   Spielfeld.refreshPasszahl(Spielfeld.getClickpos);
end;

procedure TArtus.cbAnzeigenClick(Sender: TObject);
begin
   if cbAnzeigen.checked
      then begin
              Spielfeld.setDrawOften(True);
              //letzte Einstellung speichern, da die Einstellung selber gesetzt und danach wieder wie vorhher gesetzt werden soll
              appprocesslast := miProcess.Checked;
              miProcess.Checked := True;
              miProcess.Enabled := False;
           end
      else begin
              Spielfeld.setDrawOften(False);
              //alte, vom Benutz, gesetzte EInstellungen setzten
              if appprocesslast = true
                 then miProcess.Checked := True
                 else miProcess.Checked := False;
              miProcess.Enabled := True;
           end;
end;

procedure TArtus.bt_dev_drehenClick(Sender: TObject);
begin
   Spielfeld.drehen(Spielfeld.getClickpos);
end;

procedure TArtus.imResetClick(Sender: TObject);
begin
   Spielfeld.restart;
   Spielfeld.drawfield;
end;

procedure TArtus.bt_dev_TablepointsClick(Sender: TObject);
begin
  Spielfeld.tablepoints;
end;

procedure TArtus.bt_dev_orientierenClick(Sender: TObject);
begin
  Spielfeld.orientieren(Spielfeld.getClickpos,0);
end;

procedure TArtus.imRandomizeClick(Sender: TObject);
begin
   Spielfeld.randomize;
   Spielfeld.drawfield;
end;

procedure TArtus.miProcessClick(Sender: TObject);
begin
if miProcess.Checked = True
     then begin
             miProcess.Checked := False;
             Doublebuffered := False;
             lbLog.Items.Add('Deaktiviere application.processmessages.')
          end
     else begin
             miProcess.Checked := True;
             Doublebuffered := True;
             lbLog.Items.Add('Aktiviere application.processmessages.');
          end;
end;

procedure TArtus.bt_dev_autoturnClick(Sender: TObject);
begin
  autoturn;
end;

procedure TArtus.tbGenauigkeitChange(Sender: TObject);
begin
  //Farbe und Beschriftung anpassen
  laMintbp.Caption := 'Minimale tablepoints: '+IntToStr(12+tbGenauigkeit.Position*2);
  laMintbp.Font.Color :=  tbGenauigkeit.Position*15+20000;
end;

//Zeit schätzen
procedure TArtus.btZeitschaetzenClick(Sender: TObject);
var starttime: TDateTime;
    partner1, partner2, counter: Integer;
    Hour,Min,Sec,MSec: Word;
    Zeit: extended;
begin
  lbLog.Items.Add('Schätze Zeit...');
  if cbAlgorithmus.ItemIndex=0
     then begin
            //startzeit messen
            starttime := getTime;
            schleifenbreak := False;
            //bruteturn aufrufen
            bruteturn;
            //zeit errechnen
            DecodeTime(getTime-starttime,Hour,Min,Sec,MSec);
            Zeit := Hour*3600+Min*60+Sec+MSec/1000; //Zeit in s umrechnen
            Zeit := Zeit*362880/8; //hochrechnen
          end
     else begin
            starttime := getTime;
            counter := 0;
            //500000 mal zufällig tauschen
            while counter < 500000 do
            begin
                 Inc(counter);
                 repeat
                    partner1 := Random(9);
                    partner2 := Random(9);
                 until partner1 <> partner2;
                 Spielfeld.tausche(partner1, partner2);
                 Spielfeld.orientieren(partner1, Random(4));
                 Spielfeld.orientieren(partner2, Random(4));
            end;
            //Zeit messen
            DecodeTime(getTime - starttime, Hour, Min, Sec, MSec);
            Zeit := Hour*3600+Min*60+Sec+MSec/1000; //Zeit in s
            Zeit := Zeit*362880*32768/500000; //hochrechnen
          end;
  Zeit := Zeit / 60; //in Minuten umwandeln
  laEinheit1.Caption := 'min';
  if Zeit >= 60//falls mehr als 60 min in Stunden umwandeln
     then begin
             Zeit := Zeit / 60;
             laEinheit1.Caption := 'h';
             if Zeit >= 48//falls mehr als 48 Stunden in Tage umwandeln
                then begin
                       Zeit := Zeit / 24;
                       laEinheit1.Caption := 'd';
                     end;
          end;
  edGeschaetzte.Text := FloatToStrF(Zeit,ffFixed,3,2);
  lbLog.Items.Add('Die Geschätze Zeit beträgt: ' + edGeschaetzte.Text+laEinheit1.Caption);
end;

procedure TArtus.savefield(extra:integer);
//speichert die Orientierungen
var pos:integer;
begin
  //speicherarray um eins verlängern
  setLength(Speicher,length(Speicher)+1);
  //alle Orientierungen speichern
  for pos := 0 to 8 do
      Speicher[length(Speicher)-1][pos] := Spielfeld.getPositionen(pos).getOrientierung;
  Speicher[length(Speicher)-1][9] := extra;//zum debuggen
end;

procedure TArtus.loadfield(slot:integer);
//lädt die Positionen
var pos:integer;
begin
   if (slot < 0) then slot := length(Speicher) - slot;
   //vorhanden?
   if slot < length(Speicher)
      then for pos := 0 to 8 do Spielfeld.orientieren(pos,Speicher[slot][pos]);
end;

//Algorithmen starten
procedure TArtus.btStartenClick(Sender: TObject);
var starttime: TDateTime;
    Hour,Min,Sec,MSec: Word;
    Zeit: integer;
begin
   if btStarten.Caption = 'Starten'
      then begin
             //logeintrag hinzufügen
             lbLog.Items.Add('Starte Algorithmus...');
             //Buttonbeschriftung anpassen
             if miProcess.Checked
                then btStarten.Caption := 'Stoppen'
                else btStarten.Caption := 'Warten';
             //schleifenbreak zurück setzen
             schleifenbreak := false;
             //Startzeit speichern
             starttime := getTime;
             //Welchen Algorithmus starten?
             case cbAlgorithmus.ItemIndex of
                  0: bruteforce;
                  1: backtracking;
                  2: randomswitchsolve(12+tbGenauigkeit.Position*2);
                  3: randomsolve(12+tbGenauigkeit.Position*2);
             end;
             //Zeitintervall messen
             DecodeTime(getTime - starttime,Hour,Min,Sec,MSec);
             //Zeit in Sekunden umwandeln
             Zeit := Hour*3600+Min*60+Sec;
             edZeit.Text := IntToStr(Zeit) + ',';
             //Format für ms anpassen
             if MSec < 10
                then edZeit.Text := edZeit.Text + '00'
                else if MSec < 100
                        then edZeit.Text := edZeit.Text + '0';
             edZeit.Text := edZeit.Text + IntToStr(MSec);
             laEinheit2.Caption := 's';
             //Feld anzeigen
             Spielfeld.drawfield;
             //button zurück setzte
             btStarten.Caption := 'Starten';
             lbLog.Items.Add('...Fertig. Zeit betrug: ' + edZeit.Text + ' s');
           end
      else begin//wenn auf stoppen geklickt wurde
             schleifenbreak := true;
             btStarten.Caption := 'Starten';
           end;
end;

//Bruteforce
procedure TArtus.bruteforce();
//benutzt Permutationsalgorithmus nach Alexander Bogomolyn
var i, level, counter:integer;
    value: array[0..8] of integer;
    procedure visit(k:integer);
    var i:integer;
    begin
       inc(level);
       value[k] := level;
       if level = 8
          then begin
                  //Fortschritt anzeigen
                  laFortschritt.Caption := 'Permutationen: ' + IntToStr(counter);
                  Inc(counter);
                  //Daten aus array laden und Karten positionieren
                  for i := 0 to 8 do Spielfeld.setPositionen(i, value[i]);
                  //wenn das Feld richtig liegt, abbrechen
                  if bruteturn = 36 then exit;
               end
          else
              for i := 0 to 8 do
                  //schleifenbreak ergänzt, damit abgebrochen werden kann
                  if (value[i] = 0) and (not schleifenbreak)
                     then visit(i);
       dec(level);
       value[k] := 0;
    end;
begin
   for i := 0 to 8 do value[i] := 0;
   //zurück setzten und Variablen initialisieren
   Spielfeld.Restart;
   counter := 0;
   level := -1;
   laFortschritt.Visible := True;
   //starten
   visit(0);
end;

function TArtus.bruteturn():integer;
//geht alle 262144 drehungen durch und legt in das, was am besten war
var i, pos, highest, tablepoints:integer;
    partners:TPartnerarray;
begin
   //wenn aktiviert, zwischenpausen machen und auf inputs reagieren
   if miProcess.Checked then application.processmessages;
   //alle Karten in 0-Orientierung bringen
   for i := 0 to 8 do Spielfeld.orientieren(i,0);
   //variablen startwerte geben
   pos := 0;
   highest := Spielfeld.tablepoints;
   //so lange karten drehen, bis alle Kartenorientierungen durch sind
   repeat
      //um mehrmaligen Funktionsuafruf zu verhindern in Variable zwischenspeichern
      tablepoints := Spielfeld.tablepoints;
      //wenn besseres Feld gefunden ist, speichern
      if tablepoints > highest
         then begin
                highest := Spielfeld.tablepoints;
                savefield(highest);
              end;
      Spielfeld.drehen(pos);
      //in Varibale funktionsuafruf zwischenspeichern
      partners := Spielfeld.partner(pos);
      //alle Partner aktualisieren
      for i := 0 to length(partners) - 1
         do Spielfeld.refreshPasszahl(partners[i][1]);
      //alle Orientierungen hochzählen
      if Spielfeld.getPositionen(pos).getOrientierung = 0
         then inc(pos)
         else pos := 0;
   until pos = 9;

   //laden
   loadfield(-1);
   //tablepoints zurück geben
   Result := highest;
end;

//Backtracking
procedure TArtus.backtracking();
    function rekursion_backtracking(karte:integer):boolean;
    var span, startseite:integer;
    begin
       //extra für Darstellung
       Spielfeld.setclickpos(karte);
       //falls an letzter Karte angelangt, abbrechen und true zurück geben
       if karte >= 9
          then begin
                 Result := true;
                 exit;
               end;
       span := 1;
       //so lannge bis karte+partner über die letzte Position hinaus ist
       repeat
          //startseite Speichern
          startseite := Spielfeld.getPositionen(karte).getOrientierung;
          //drehen bis die Karte alle Orientierungen hatte oder selber passt+nächste Karte
          repeat
             //vor der Prüfung aktualisieren
             Spielfeld.refreshPasszahl(karte);
             //falls kante links und oben passt sowie die nachbarkarte passt, true zurück liefern
             if (Spielfeld.getPositionen(karte).getKante(0).getPasst)
                and (Spielfeld.getPositionen(karte).getKante(1).getPasst)
                and (rekursion_backtracking(karte+1))
                then begin
                       Result := true;
                       exit;
                     end;
             //drehen
             Spielfeld.drehen(karte);
          until startseite = Spielfeld.getPositionen(karte).getOrientierung;
          //wenn partner größer als die Nachbarkarte, dann tauschen
          if span > 1 then Spielfeld.tausche(karte,karte+span);
          //tauschkarte erhöhen
          inc(span);
       until karte+span >= 9;
    end;
begin
   Spielfeld.Restart;
   rekursion_backtracking(0);
end;


//RANDOMSOLVE
procedure TArtus.randomsolve(mintable:integer);
//lößt mittels blindem Legen
var partner1, partner2: Integer;
begin
  //solange die minimalen Punkte nicht erreich wurden
   while Spielfeld.tablepoints < mintable do
         begin
            //wenn aktiviert, Programm auf Ereignisse reagieren lassen
            if miProcess.Checked then application.processmessages;
            //wenn die Schleife über das Formular abgebrochen wird den Algorithmus verlassen
            if schleifenbreak
               then begin
                      schleifenbreak := False;
                      exit;
                   end;
            //wiederhole Schleifendruchgänge bis die positionen unterschiedlich sind
            repeat
               partner1 := Random(9);
               partner2 := Random(9);
            until partner1 <> partner2;
            //Karten vertauschen und drehen
            Spielfeld.tausche(partner1,partner2);
            Spielfeld.orientieren(partner1,Random(4));
            Spielfeld.orientieren(partner2,Random(4));
         end;
end;

//Randomswitchsolve
procedure TArtus.randomswitchsolve(mintable:integer);
//legt blind aber dreht mithilfe von autoturn oder bruteturn
var partner1, partner2, trys, trys2, max_trys:integer;
begin
   max_trys := 10;
   trys := 0;
   while Spielfeld.tablepoints < mintable do
   begin
      if miProcess.Checked then application.processmessages;
      //wenn abgebrochen werden soll
      if schleifenbreak
         then begin
                schleifenbreak := False;
                exit;
              end;
      //nach max_trys versuchen das Feld neu starten
      Inc(trys);
      if (trys > max_trys)
         then begin
                 Spielfeld.restart;
                 trys := 0
              end;
      repeat
         //mit trys2 endlosschleife verhindern, wenn Feld schon gelößt ist
         trys2 := 0;
         repeat
            inc(trys2);
            partner1 := Random(9)
         until (Spielfeld.getPositionen(partner1).getPasszahl < 4) or (trys2 > 500);
         trys2 := 0;
         repeat
            inc(trys2);
            partner2 := Random(9)
         until (Spielfeld.getPositionen(partner2).getPasszahl < 4) or (trys2 > 500);
      until partner1 <> partner2;
      Spielfeld.tausche(partner1,partner2);
      //je nach Auswahl Drehverfahren wählen
      if rgDrehalgorithmus.ItemIndex=1
         then autoturn
         else bruteturn;
   end;
end;

//Autoturn
procedure TArtus.autoturn();
//dreht Feld besser, kann aber in endlosschleifen landen;
var vor_check, i, counter, hoechster, tblps_at_start, tbl_points, pos,j,trys, tblps_rekord:integer;
    Ortrng_passzahl: array[0..8] of integer;
    partners: TPartnerarray;
begin
   tblps_at_start := Spielfeld.tablepoints;
   trys := 0;
   savefield(Spielfeld.tablepoints);
   repeat
      Inc(trys);
      tblps_rekord := Spielfeld.tablepoints;
      for pos := 0 to 8 do
         for j := 0 to 3 do
            begin
               vor_check := Spielfeld.getPositionen(pos).getOrientierung;

               //Daten sammeln
               counter := 0;
               Spielfeld.orientieren(pos,0);//in 0-orientierung bringen
               repeat
                  Ortrng_passzahl[counter] := Spielfeld.getPositionen(pos).getPasszahl;//in Array füllen
                  Spielfeld.drehen(pos);
                  Inc(counter);
               until (Ortrng_passzahl[counter] = 4) or (counter = 4);//drehe die Karte so oft, bis die beste Orientierung gefunden ist oder einmal rum ist

               //beste Orientierung finden anhand der Liste Ortrng_passzahl[j]
               hoechster := 4;
               //schleifendurchläufe bis beste Orientierung gefunden ist
               repeat
                  for i := 0 to 3 do
                     if Ortrng_passzahl[i] = hoechster
                        then begin
                                hoechster := -1;//zum verlassen der nächsten schleife
                                break;//schleife verlassen
                             end;
                        hoechster := hoechster-1;//keine Karte mit
               until hoechster<0;
               Spielfeld.orientieren(pos,i);

               //wenn Karte anders ist, nachbkarten aktualisieren
               if vor_check <> Spielfeld.getPositionen(pos).getOrientierung
                  then begin
                          partners := Spielfeld.partner(pos);
                          for i := 0 to length(partners) - 1
                              do Spielfeld.refreshPasszahl(partners[i][1]);
                       end;

               //falls Feld besser ist speichern
               tbl_points := Spielfeld.tablepoints;
               if tbl_points > tblps_rekord
                  then begin
                         tblps_rekord := tbl_points;
                         savefield(tbl_points);
                       end;
            end;
   until (Spielfeld.tablepoints >= tblps_at_start) or (trys > 3);
   loadfield(-1);
   setlength(Speicher,0);//speicher leeren
end;

end.
