unit mcsConstantesRutinas;

interface

uses
  windows, sysUtils, dialogs,Graphics,Math;//,Contnrs;

const 
  NUMERO_MAXIMO_DE_MICROCONTROLADORES = 2;//4;

type
  TELista=array[1..NUMERO_MAXIMO_DE_MICROCONTROLADORES] of integer;

const
  DIR_ULTIMO_BYTE_MEM_PROG=8191; {4095 para 8051}

type
  TablaDeDireccionFila=array[0..DIR_ULTIMO_BYTE_MEM_PROG]of integer;


procedure iniciarListaMicros(var listaMic:TELista);
function indiceVacioEnListaMicros(var listaMic:TELista):integer;
procedure borrarIndiceEnListaMicros(var listaMic:TELista;ind:integer);
function estaEnListaMicros(var listaMic:TELista;x:integer):boolean;
function ListaMicrosVacia(var listaMic:TELista):boolean;

function leerTablaDeDireccionFila(var x:TablaDeDireccionFila;d:word):integer;

procedure escribirTablaDeDireccionFila(var x:TablaDeDireccionFila;d:word;f:integer);

implementation
function leerTablaDeDireccionFila(var x:TablaDeDireccionFila;d:word):integer;
var
  dNuevo:word;
begin
  if (d > DIR_ULTIMO_BYTE_MEM_PROG) then
  begin
    dNuevo:=0;
  end
  else
  begin
    dNuevo:=d;
  end;
  leerTablaDeDireccionFila:=x[dNuevo];
end;

procedure escribirTablaDeDireccionFila(var x:TablaDeDireccionFila;d:word;f:integer);
begin
  if (d > DIR_ULTIMO_BYTE_MEM_PROG) then
  begin
    exit;
  end;
  x[d]:=f;
end;


function estaEnListaMicros(var listaMic:TELista;x:integer):boolean;
begin
  if (x> NUMERO_MAXIMO_DE_MICROCONTROLADORES)or(x<=0) then
  begin
    estaEnListaMicros:=FALSE;
    exit;
  end;
  if listaMic[x]=x then
  begin
    estaEnListaMicros:=TRUE;
    exit;
  end;
  estaEnListaMicros:=FALSE;

end;
procedure borrarIndiceEnListaMicros(var listaMic:TELista;ind:integer);
begin
  listaMic[ind]:=0;
end;

function indiceVacioEnListaMicros(var listaMic:TELista):integer;
var
  i:integer;
begin
  for i:=1 to NUMERO_MAXIMO_DE_MICROCONTROLADORES do
  begin
    if listaMic[i] = 0 then
    begin
      listaMic[i]:=i;//Se ocupa el indice vacio
      indiceVacioEnListaMicros:=i;
      exit;
    end;
  end;
  indiceVacioEnListaMicros:=0;
end;
procedure iniciarListaMicros(var listaMic:TELista);
var
  i:integer;
begin
  for i:=1 to NUMERO_MAXIMO_DE_MICROCONTROLADORES do
  begin
    listaMic[i]:=0;
  end;
end;

function ListaMicrosVacia(var listaMic:TELista):boolean;
var
  i:integer;
begin
  for i:=1 to NUMERO_MAXIMO_DE_MICROCONTROLADORES do
  begin
    if listaMic[i] <> 0 then
    begin
      ListaMicrosVacia:=FALSE;
      exit;
    end;
  end;
  ListaMicrosVacia:=TRUE;
end;

end.


