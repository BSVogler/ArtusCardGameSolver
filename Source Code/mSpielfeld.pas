unit mSpielfeld;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, XPMan, mKarte, mKante;


type
    TPartnerarray = array of array[0..1] of Integer;
    TSpielfeld = class(TImage)
       private
          Fclickpos:integer;
          Fpartnersave:array[0..8] of TPartnerarray;
          FLog:TListBox;
          FDrawNummer:Boolean;
          FDrawPasszahl:Boolean;
          FDrawSeiten:Boolean;
          FDrawOften:Boolean;
          FTablepointslabel:TLabel;
          FPositionen:array[0..8] of TKarte;
          procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
          procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
       public
           constructor Create(AOwner:TComponent;KTablepointslabel:TLabel;KLog:TListBox);
           procedure Restart();
           procedure setclickpos(karte:integer);
           procedure setDrawNummer(n:boolean);
           procedure setDrawPasszahl(n:boolean);
           procedure setDrawSeiten(n:boolean);
           procedure setDrawoften(n:boolean);
           function getPositionen(n:integer):TKarte;
           procedure setPositionen(pos:integer;nr:integer);
           function getClickpos():integer;
           procedure refreshPasszahl(pos:integer);
           function tablepoints():integer;
           procedure draw(pos:integer);
           procedure drawfield();
           procedure drehen(pos:integer);
           procedure orientieren(pos:integer;orient:integer);
           procedure tausche(karte1:integer;karte2:integer);
           procedure randomize();
           function partner(pos:integer):TPartnerarray;
end;


implementation

constructor TSpielfeld.Create(AOwner:TComponent;KTablepointslabel:TLabel;KLog:TListBox);
var i:integer;
begin
    inherited Create(AOwner);
    FTablepointslabel := KTablepointslabel;
    FLog := KLog;
    FLog.Items.Add('Herzlich Willkommen');
    FLog.Items.Add('zum Artus Game Solver V1.0');
    FDrawNummer := True;
    FDrawPasszahl := True;
    FDrawSeiten := True;
    FDrawOften := False;
    for i := 0 to 8 do
       begin
          setLength(Fpartnersave[i], 3);
          Fpartnersave[i][0][0] := -1;//entspricht undefiniert
       end;
    Top := 32;
    Left := 5;
    Width := 500;
    Height := 500;
    //eigene Mouseereignisse zuweisen
    onmousedown := MouseDown;
    onmouseup := MouseUp;
    Restart;
    drawfield;
end;

procedure TSpielfeld.Restart();
//Neustart des Feldes
var i:integer;
begin
  for i := 0 to 8 do FPositionen[i] := TKarte.Create(i);
  for i := 0 to 8 do refreshPasszahl(i);
end;

//Getter/Setter
procedure TSpielfeld.setclickpos(karte:integer);
begin
  Fclickpos := karte;
end;

procedure TSpielfeld.setDrawNummer(n:boolean);
begin
   FDrawNummer := n;
end;

procedure TSpielfeld.setDrawPasszahl(n:boolean);
begin
   FDrawPasszahl := n;
end;

procedure TSpielfeld.setDrawSeiten(n:boolean);
begin
   FDrawSeiten := n;
end;

procedure TSpielfeld.setDrawoften(n:boolean);
begin
   FDrawOften := n;
end;

function TSpielfeld.getPositionen(n:integer):TKarte;
begin
  Result := Fpositionen[n];
end;

procedure TSpielfeld.setPositionen(pos:integer;nr:integer);
begin
  FPositionen[pos] := TKarte.Create(nr);
end;

function TSpielfeld.getclickpos():integer;
begin
   Result := Fclickpos;
end;

//maus
procedure TSpielfeld.MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var pos:integer;
begin
   pos := x div 166 + y div 166*3;
   //showmessage('x: ' + IntToStr(x)+', y: '+IntToStr(y)+'Pos:'+IntToStr(pos));
   if pos = Fclickpos then drehen(pos);
   Fclickpos := pos;
   drawfield;
end;

procedure TSpielfeld.MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var pos:integer;
begin
   pos := x div 166 + y div 166*3;
   if pos <> Fclickpos then tausche(Fclickpos, pos);
   Fclickpos := pos;
   drawfield;
end;

//Zeichnen
procedure TSpielfeld.draw(pos:integer);
  function formtoword(form:integer):string;
  //wandelt die Zahl der Form in Wort um
  begin
    if form = 1
       then Result := 'Kopf'
       else Result := 'Fuss';
  end;
  function colortohex(color:integer):TColor;
  //farbe in BGR (umgedrehtes RGB-Format) umwandeln
  begin
     case color of
          0: Result := $00DAFF;
          1: Result := $0000ff;
          2: Result := $ff0000;
          3: Result := $00ff00;
          else Result := $00DAFF;//damit compiler nicht warnt
     end;
  end;
begin
   application.processmessages;
   Canvas.Pen.Width := 3;
   //Hintergrund
   if Fclickpos = pos
     then Canvas.Brush.Color := $fff0f0
     else Canvas.Brush.Color := $ffffff;
   Canvas.Rectangle(pos mod 3 * 166,pos div 3 * 166,pos mod 3 * 166 + 166, pos div 3 * 166 + 166);
   //Striche
   Canvas.moveTo(pos mod 3*166, pos div 3 *166);//oben links
   Canvas.lineTo(pos mod 3*166+166, pos div 3 *166 + 166);//unten rechts
   Canvas.moveTo(pos mod 3*166+166, pos div 3 *166);//oben rechts
   Canvas.lineTo(pos mod 3*166, pos div 3 *166 + 166);//unten links

   //Mausauswahl blau machen
   if Fclickpos = pos
     then Canvas.Brush.Color := $ffbfbf
     else Canvas.Brush.Color := $cfcfcf;
   if FDrawSeiten
      then begin
              if Fpositionen[pos].getKante(0).getPasst
                 then Canvas.FloodFill(pos mod 3*166+10,pos div 3 *166+83,$000000,fsBorder);
              if Fpositionen[pos].getKante(1).getPasst
                 then Canvas.FloodFill(pos mod 3*166+83,pos div 3 *166+20,$000000,fsBorder);
              if Fpositionen[pos].getKante(2).getPasst
                 then Canvas.FloodFill(pos mod 3*166+100,pos div 3 *166+83,$000000,fsBorder);
              if Fpositionen[pos].getKante(3).getPasst
                 then Canvas.FloodFill(pos mod 3*166+83,pos div 3 *166+100,$000000,fsBorder);
           end;
   //Lagestrich zeichen
   case Fpositionen[pos].getOrientierung of//kante wählen
        0: begin
             Canvas.moveTo(pos mod 3*166, pos div 3 * 166 + 83);//mitte links
             Canvas.lineTo(pos mod 3*166 + 20, pos div 3 * 166 + 83);
           end;
        1: begin
             Canvas.moveTo(pos mod 3*166 + 83, pos div 3 * 166);//mitte oben
             Canvas.lineTo(pos mod 3*166 + 83, pos div 3 * 166 + 20);
           end;
        2: begin
             Canvas.moveTo(pos mod 3*166 + 146, pos div 3 * 166 + 83);//mitte rechts
             Canvas.lineTo(pos mod 3*166 + 166, pos div 3 * 166 + 83);
           end;
        3: begin
             Canvas.moveTo(pos mod 3*166 + 83, pos div 3 * 166 + 146);//mitte unten
             Canvas.lineTo(pos mod 3*166 + 83, pos div 3 * 166 + 166);
           end;
   end;

   //Wörter+Zahlen
   Canvas.Font.Name := 'Verdana';
   Canvas.Font.Size := 18;
   Canvas.Font.Style := [fsbold];
   Canvas.Brush.Style := bsclear;

   Canvas.Font.Color := colortohex(Fpositionen[pos].getKante(0).getFarbe());
   Canvas.Textout(pos mod 3*166+10, pos div 3 *166+70,formtoword(Fpositionen[pos].getKante(0).getForm));

   Canvas.Font.Color := colortohex(Fpositionen[pos].getKante(1).getFarbe);
   Canvas.Textout(pos mod 3*166+58, pos div 3 *166+20,formtoword(Fpositionen[pos].getKante(1).getForm));

   Canvas.Font.Color := colortohex(Fpositionen[pos].getKante(2).getFarbe);
   Canvas.Textout(pos mod 3*166+100, pos div 3 *166+70, formtoword(Fpositionen[pos].getKante(2).getForm));

   Canvas.Font.Color := colortohex(Fpositionen[pos].getKante(3).getFarbe);
   Canvas.Textout(pos mod 3*166+58, pos div 3 *166+130, formtoword(Fpositionen[pos].getKante(3).getForm));

   //Passzahl
   Canvas.Font.Size := 17;
   Canvas.Font.Color := clblack;
   if FDrawPasszahl
      then Canvas.Textout(pos mod 3*166+76, pos div 3 *166+88,IntToStr(Fpositionen[pos].getPasszahl));
   if FDrawNummer
      then Canvas.Textout(pos mod 3*166+5, pos div 3 *166,IntToStr(Fpositionen[pos].getNummer));
end;

procedure TSpielfeld.drawfield();
//alle Positionen zeichnen
var i:integer;
begin
   for i:=0 to 8 do
       begin
          refreshPasszahl(i);
          draw(i);
       end;
   tablepoints;
end;

function TSpielfeld.tablepoints():integer;
var points, i:integer;
begin
  points := 0;
  for i := 0 to 8 do points := points + Fpositionen[i].getPasszahl;
  FTablepointslabel.Caption := IntToStr(points);
  Result := points;
end;

procedure TSpielfeld.refreshPasszahl(pos:integer);
var partnerlist : TPartnerarray;
    passzahl, i :integer;
    kante1, kante2:TKante;
begin
   //funktionsaufruf zwischenspeichern
   partnerlist := partner(pos);
   passzahl := 4;
   for i := 0 to 3 do Fpositionen[pos].getKante(i).setPasst(true);//alle erst mal auf true
   for i := 0 to length(partnerlist) - 1 do
       begin
           //beide kanten zwischenspeichern
           kante1 := Fpositionen[pos].getKante(partnerlist[i][0]);
           kante2 := Fpositionen[partnerlist[i][1]].getKante((partnerlist[i][0]+2) mod 4);

           if (kante1.getFarbe <> kante2.getFarbe) or (kante1.getForm = kante2.getForm)
              then begin
                      //passt nicht? dann passzahl verringern und kante so eintragen
                      passzahl := passzahl - 1;
                      kante1.setPasst(false);
                   end;
       end;
   Fpositionen[pos].setPasszahl(passzahl);//speichern
end;

function TSpielfeld.partner(pos:integer):TPartnerarray;
//liefert Array mit allen umliegenden Karten, [partner][0]=orientierung;[partner][1]=position
var partners:TPartnerarray;
    curside:integer;
begin
   if (Fpartnersave[pos][0][0] <> -1)//wenn im Speicher, dann ausgeben
       then Result := Fpartnersave[pos]
       else begin
               //Partnerkarten ermitteln
               setLength(partners,4);
               curside := 0;

               if pos mod 3 <> 0 //nur die am linken Rand nicht
                  then begin
                          partners[curside][0]:= 0;//Karte links
                          partners[curside][1]:= pos-1;//Position
                          curside := curside + 1;
                       end;
               if pos >= 3 //alle mittleren und unteren Karten
                  then begin
                          partners[curside][0] := 1;//Karte links
                          partners[curside][1] := pos-3;//Position
                          curside := curside + 1;
                       end;
               if pos mod 3 - 2 <> 0 //nur die am rechten Rand nicht
                  then begin
                          partners[curside][0] := 2;//Karte rechts
                          partners[curside][1] := pos+1;//Position
                          curside:=curside + 1;
                       end;
               if pos <= 5//nur die oberen nicht
                  then begin
                          partners[curside][0] := 3;//Karte unten
                          partners[curside][1] := pos+3;//Position
                          curside := curside + 1;
                        end;
               setLength(partners, curside);//array kürzen, wenn es weniger Partner gibt
               Fpartnersave[pos] := partners;//speichern
               Result := partners;
             end;
end;

procedure TSpielfeld.drehen(pos:integer);
//dreht Karte an der Position pos im Uhrzeigersinn
var tempSide:TKante;
begin
   tempSide := Fpositionen[pos].getKante(0);//temporärer Speicher
   Fpositionen[pos].setKante(0,Fpositionen[pos].getkante(3));
   Fpositionen[pos].setKante(3,Fpositionen[pos].getkante(2));
   Fpositionen[pos].setKante(2,Fpositionen[pos].getkante(1));
   Fpositionen[pos].setKante(1,tempSide);

   //orientierung aktualisieren
   Fpositionen[pos].setOrientierung((Fpositionen[pos].getOrientierung + 1) mod 4);
   refreshPasszahl(pos);
   if FDrawoften then draw(pos);
end;

procedure TSpielfeld.orientieren(pos:integer;orient:integer);
var old:array[0..3] of TKante;
    i:integer;
begin
  //Karte, unabhängig der Orientierung, speichern
  for i := 0 to 3 do
      old[i] := Fpositionen[pos].getKante((i + Fpositionen[pos].getOrientierung) mod 4);
  for i := 0 to 3
      do Fpositionen[pos].setKante(i,old[(i-orient+4) mod 4]);//wiederherstellen
  //Position aktualisieren
  Fpositionen[pos].setOrientierung(orient);
  refreshPasszahl(pos);
  if FDrawoften then draw(pos)
end;

procedure TSpielfeld.tausche(karte1:integer;karte2:integer);
var temp:TKarte;
begin
   //Prüfen ob Parameter einen Sinn haben
   if (karte1 < 9) and (karte1>=0) and (karte2 < 9) and (karte2>=0)
      then if karte1<>karte2
              then begin
                      //tauschen mit hilfe einer Hilfsvariable
                      temp := Fpositionen[karte1];
                      Fpositionen[karte1] := Fpositionen[karte2];
                      Fpositionen[karte2] := temp;
                   end
              else FLog.Items.Add('Das Tauschen mit sich selber ist nicht nötig.')
      else FLog.Items.Add('Illegaler Aufruf der tauschen-Funktion. karte1: '+IntToStr(karte1)+' karte2: '+IntToStr(karte2));
      //beide Karten aktualisieren
      refreshPasszahl(karte1);
      refreshPasszahl(karte2);
end;

procedure TSpielfeld.randomize();
var i,partner1,partner2:integer;
begin
   for i:=0 to 8 do //jede Position
       begin
          repeat
             partner1 := Random(9);
             partner2 := Random(9);
          until (partner1<>partner2);
          tausche(partner1,partner2);
          orientieren(partner1,Random(4));
          orientieren(partner2,Random(4));
       end;
end;


end.
