unit mKarte;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, mKante, XPMan;

type
    TKarte = class
       private
          FPasszahl:integer;
          FOrientierung:integer;
          FNummer:integer;
          FKante:array[0..3] of TKante;
       public
         constructor Create(number:integer);virtual;
         procedure setKante(nr:integer;kante:TKante);
         procedure setPasszahl(n:Integer);
         procedure setOrientierung(nr:integer);
         function getKante(nr:integer):TKante;
         function getNummer():Integer;
         function getPasszahl():Integer;
         function getOrientierung():integer;
  end;


implementation

constructor TKarte.Create(number:integer);
begin
    FNummer := number;
    FOrientierung := 0;
    //kantenobjekte erzeugen
    FKante[0] := TKante.Create();
    FKante[1] := TKante.Create();
    FKante[2] := TKante.Create();
    FKante[3] := TKante.Create();
    //je nachdem welche Karte erzeugt wird
    case number of
       0:begin
            FKante[0].setFarbe(0);
            FKante[0].setForm(1);
            FKante[1].setFarbe(1);
            FKante[1].setForm(0);
            FKante[2].setFarbe(3);
            FKante[2].setForm(0);
            FKante[3].setFarbe(2);
            FKante[3].setForm(1);
       end;
       1:begin
            FKante[0].setFarbe(2);
            FKante[0].setForm(1);
            FKante[1].setFarbe(0);
            FKante[1].setForm(0);
            FKante[2].setFarbe(3);
            FKante[2].setForm(0);
            FKante[3].setFarbe(1);
            FKante[3].setForm(1);
       end;
       2:begin
            FKante[0].setFarbe(3);
            FKante[0].setForm(1);
            FKante[1].setFarbe(1);
            FKante[1].setForm(0);
            FKante[2].setFarbe(0);
            FKante[2].setForm(0);
            FKante[3].setFarbe(1);
            FKante[3].setForm(1);
       end;
       3:begin
             FKante[0].setFarbe(0);
             FKante[0].setForm(1);
             FKante[1].setFarbe(3);
             FKante[1].setForm(1);
             FKante[2].setFarbe(1);
             FKante[2].setForm(0);
             FKante[3].setFarbe(2);
             FKante[3].setForm(0);
       end;
       4:begin
             FKante[0].setFarbe(3);
             FKante[0].setForm(1);
             FKante[1].setFarbe(0);
             FKante[1].setForm(0);
             FKante[2].setFarbe(1);
             FKante[2].setForm(0);
             FKante[3].setFarbe(2);
             FKante[3].setForm(1);
       end;
       5:begin
            FKante[0].setFarbe(0);
            FKante[0].setForm(0);
            FKante[1].setFarbe(2);
            FKante[1].setForm(0);
            FKante[2].setFarbe(1);
            FKante[2].setForm(1);
            FKante[3].setFarbe(3);
            FKante[3].setForm(1);
       end;
       6:begin
            FKante[0].setFarbe(3);
            FKante[0].setForm(1);
            FKante[1].setFarbe(1);
            FKante[1].setForm(0);
            FKante[2].setFarbe(2);
            FKante[2].setForm(0);
            FKante[3].setFarbe(0);
            FKante[3].setForm(1);
       end;
       7:begin
            FKante[0].setFarbe(2);
            FKante[0].setForm(1);
            FKante[1].setFarbe(0);
            FKante[1].setForm(0);
            FKante[2].setFarbe(3);
            FKante[2].setForm(0);
            FKante[3].setFarbe(0);
            FKante[3].setForm(1);
       end;
       8:begin
            FKante[0].setFarbe(2);
            FKante[0].setForm(1);
            FKante[1].setFarbe(1);
            FKante[1].setForm(0);
            FKante[2].setFarbe(0);
            FKante[2].setForm(0);
            FKante[3].setFarbe(3);
            FKante[3].setForm(1);
       end;
    end;
end;

//Getter/Setter
function TKarte.getKante(nr:integer):TKante;
begin
   Result := FKante[nr];
end;

procedure TKarte.setPasszahl(n:integer);
begin
   FPasszahl := n;
end;

function TKarte.getPasszahl():Integer;
begin
   Result := Fpasszahl
end;

function TKarte.getOrientierung():Integer;
begin
   Result := FOrientierung;
end;

function TKarte.getNummer():Integer;
begin
   Result := FNummer;
end;

procedure TKarte.setOrientierung(nr:integer);
begin
  FOrientierung := nr;
end;

procedure TKarte.setKante(nr:integer;kante:TKante);
begin
   FKante[nr] := kante;
end;
end.
