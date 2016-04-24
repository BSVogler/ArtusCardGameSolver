unit mKante;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, XPMan;

type
    TKante = class
       private
         FFarbe:Integer;
         FForm: Integer;
         Fpasst: boolean;
       public
         procedure setFarbe(n:integer);
         function getFarbe():integer;
         procedure setForm(n:integer);
         function getForm():integer;
         procedure setPasst(n:boolean);
         function getPasst():boolean;
  end;

implementation

//Getter/Setter
//hier könnte man auch Arrays in den Karten benutzen
procedure TKante.setFarbe(n:integer);
begin
   FFarbe := n;
end;

function TKante.getFarbe():integer;
begin;
   Result := FFarbe;
end;

procedure TKante.setForm(n:integer);
begin
   FForm := n;
end;

function TKante.getForm():integer;
begin;
   Result := FForm;
end;

procedure TKante.setPasst(n:boolean);
begin
   FPasst := n;
end;

function TKante.getPasst():boolean;
begin;
   Result := FPasst;
end;
end.
 