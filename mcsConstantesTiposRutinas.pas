unit mcsConstantesTiposRutinas;

interface

uses
  windows, sysUtils, dialogs,Graphics,Math,
  mcsConstantesRutinas;

var
  tae,fae:integer; //Del Algoritmo Evolutivo

const
  NUMERO_CICLOS_EJECUTADOS_POR_TIC_DE_TIMER_ANIMACION = 3*12;
  NUMERO_CICLOS_EJECUTADOS_POR_TIC_DE_TIMER_CORRIDA = 32*12;

const
  NUMERO_MAXIMO_DE_CONEXIONES = 100;
  INDICEMAXIMO_EN_SENAL=100;
  NUMERO_MAX_DE_TRAZOS=16;

type
  cadena250=string;
  cadena100=string;
  cadena80=string;
  cadena60=string;
  cadena40=string;
  cadena30=string;
  cadena20=string;
  cadena14=string;
  cadena10=string;
  cadena2=string;
  tipoCadenasSeparadas=array[0..30] of cadena30;

const
  ArregloNombresSFR:array[128..255] of cadena10=//Todavia no se usa
    ('','','','','','','','','','','','','','','','',
     '','','','','','','','','','','','','','','','',
     '','','','','','','','','','','','','','','','',
     '','','','','','','','','','','','','','','','',
     '','','','','','','','','','','','','','','','',
     '','','','','','','','','','','','','','','','',
     '','','','','','','','','','','','','','','','',
     '','','','','','','','','','','','','','','','');

type
  Tmetodo=procedure of object;
  Tmetodo2=procedure(nombreArchivo:cadena250) of object;

type
  tipoLecturaPuertos=(DEPINES,DELATCHS);
type
  esTipoConexion=(ESTATICA,DINAMICA);
  RegistroConexion=record
    nMicro1:byte;
    puertoMicro1:byte;
    pinMicro1:byte;
    nMicro2:byte;
    puertoMicro2:byte;
    pinMicro2:byte;
    tipoDeConexion:esTipoConexion;
  end;

  TArregloConexiones=record
    TabConex:array[1..NUMERO_MAXIMO_DE_CONEXIONES]of RegistroConexion;
    totalConexiones:integer;
  end;

type
  esEstadoSimulador=(RESETEADO,ANIMADO,PARADO,CORRIENDO);
  RVariablesGenerales=record
    //Conexiones
    ArregloConexiones:TArregloConexiones;
    yaHayFormatoConexiones:boolean;
    ConexionesTop:integer;
    ConexionesLeft:integer;
    //Nombre Archivo
    RutaNombreProyecto:cadena250;
    RutaNombreUltimoArchivoLeidoOSalvado:cadena250;
    yaSeLeyoOGuardoProyecto:boolean;
    //Lista de Micros
    LNMicros:TELista;
    //
    estadoSimulador:esEstadoSimulador;
  end;

var
  varGen:RVariablesGenerales;

var
  clPantalla:Tcolor=clOlive;//clGreen;//clBlack;
  clSenal:Tcolor=clBlack;//clLime;
  clSenalSobrepuesta:Tcolor=clBlack;//clYellow;
  clSeleccionZ:Tcolor=clGreen;//clTeal;//clBlue;
  clSeleccionTrazo:Tcolor=clGreen;//clTeal;//clNavy;
  clCursor:Tcolor=clRed;


const
  ANCHO_ARCHIVO_INFO_PROGRAMA=54;
  ANCHO_ARCHIVO_INSTRUCCIONES=38;

const
  TAMANO_DE_LISTA_DE_ETIQUETAS=500;//200;
  TAMANO_DE_LISTA_DE_POSICIONES=500;//200;
  TAMANO_DE_LISTA_DE_RANGOS=200;
  TAMANO_DE_LISTA_DE_PUNTOS_CORTE=100;

const
  DIR_ULTIMO_BYTE_RAM_EXT=65535; //2005-11-20


const
  TablaHexadecimal:array[0..15] of char=
  ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

const
  {Direcciones de Registros de Funciones Especiales}
  direccionACC=$E0;
  direccionB=$F0;
  direccionPSW=$D0;
  direccionDPH=$83;
  direccionDPL=$82;
  direccionSP=$81;
  direccionP0=$80;
  direccionP1=$90;
  direccionP2=$A0;
  direccionP3=$B0;
  direccionIE=$A8;
  direccionIP=$B8;
  direccionTCON=$88;
  direccionT2CON=$C8;
  direccionSCON=$98;
  direccionTMOD=$89;
  direccionTH0=$8C;
  direccionTL0=$8A;
  direccionTH1=$8D;
  direccionTL1=$8B;

  direccionSBUF=$99;
  direccionPCON=$87;

  direccionTL2=$CC;
  direccionTH2=$CD;
  direccionRCAP2L=$CA;
  direccionRCAP2H=$CB;

const
  {Direcciones de Bits}
  direccionBitP=direccionPSW+0;
  direccionBitOV=direccionPSW+2;
  direccionBitAC=direccionPSW+6;
  direccionBitC=direccionPSW+7;

const
  {Ubicacion de Bits}
  IT0=0;{en TCON}
  IE0=1;{en TCON}
  IT1=2;{en TCON}
  IE1=3;{en TCON}
  TR0=4;{en TCON}
  TF0=5;{en TCON}
  TR1=6;{en TCON}
  TF1=7;{en TCON}

  M0timer0=0;{en TMOD}
  M1timer0=1;{en TMOD}
  CTtimer0=2;{en TMOD}
  GATEtimer0=3;{en TMOD}
  M0timer1=4;{en TMOD}
  M1timer1=5;{en TMOD}
  CTtimer1=6;{en TMOD}
  GATEtimer1=7;{en TMOD}

  RI=0;{en SCON}
  TI=1;{en SCON}
  RB8=2;{en SCON}
  TB8=3;{en SCON}
  REN=4;{en SCON}
  SM2=5;{en SCON}
  SM1=6;{en SCON}
  SM0=7;{en SCON}

  TF2=7;{en T2CON}
  EXF2=6;{en T2CON}
  RCLK=5;{en T2CON}
  TCLK=4;{en T2CON}
  EXEN2=3;{en T2CON}
  TR2=2;{en T2CON}
  CT2=1;{en T2CON}
  CPRL2=0;{en T2CON}

  SMOD=7;{en PCON}

  T0=4;{en P3Ent}
  T1=5;{en P3Ent}
  INT1negado=3;{en P3Ent}
  INT0negado=2;{en P3Ent}

  T2=0;{en P1Ent}
  T2EX=1;{en P1Ent}

  RxD=0;{en P[3]}
  TxD=1;{en P[3]}

  EA=7;{IE}
  ET2=5;{IE}
  ES=4;{IE}
  ET1=3;{IE}
  EX1=2;{IE}
  ET0=1;{IE}
  EX0=0;{IE}

  PT2=5;{IP}
  PS=4;{IP}
  PT1=3;{IP}
  PX1=2;{IP}
  PT0=1;{IP}
  PX0=0;{IP}

const
  TAMANO_DIMINUTO=120;
  TAMANO_PEQUENO=191;//160;

const
  TAMANO_DE_BLOQUE60=60;
  NUMERO_BLOQUES=60;

type
  Bloque60=array[1..TAMANO_DE_BLOQUE60] of byte;
  MatrizDeBOC=array[0..NUMERO_BLOQUES - 1 ] of Bloque60;

type
  TObjetoCripto=Class
    llave:Bloque60;

    public

    procedure formarLlave;
    function codificar(d:byte;
                       x:Bloque60):Bloque60;
    function LlaveComoCadena:string;
  end;

type
  TmeuErro=class(exception);

type
  Toshibka=Class
    procedure anular;
    function existe:boolean;
    procedure colocar(codigo:word;errorS:string);
    function cualEs:string;

      private
    CodigoError:integer;
    descripcionDeError:string;
  end;
var
  miError:Toshibka;

{Variables Globales}
const
  TAMANO_ARREGLO_CLAVE=8;

type
  ArregloClave=array[1..TAMANO_ARREGLO_CLAVE,1..TAMANO_ARREGLO_CLAVE]of longint;
type

  RSenal=record
    seAplico:boolean;
    mantizaDeFrec:double;
    exponenDeMil:byte;
    cicloDeTrabajo:double;
    valorDeInicio:byte;

    tiempoDeInicio:double;
//    yaHayFormato:boolean;
    yaHayGen:boolean;
    //Valores calculados anticipadamente
    nPeriodo:longint;
    nFlanco:longint;
    nTiempoDeInicio:longint;
    //Posicion del formato
    genTop:integer;
    genLeft:integer;
  end;

type

  variablesGlobales=record
    {Variables Globales de un Microcontrolador}
    //
    seDetuvoPorPuntoCorte:boolean;

    esSeccionCritica:boolean;//2007

    FrecuenciaHz:double;

    yaHayLCD:boolean;
    yaHayTeclado:boolean;
    yaHayPuerto:array[0..3]of boolean;
//    yaHayPuerto0,yaHayPuerto1,yaHayPuerto2,yaHayPuerto3:boolean;
    {mcsFormPuerto,Mdiframe,mcsAnalizadorLogico}
//    yaHayDisplay0,yaHayDisplay1,yaHayDisplay2,yaHayDisplay3:boolean;
    yaHayDisplay:array[0..3]of boolean;
    {Mdiframe,mcsFormDisplay}
    yaHayROM:boolean;{mcsFormMemoriaPrograma,Mdiframe}
    yaHayRamExterna:boolean; //2005-11-20
    yaHayDI,yaHaySFR,yaHayI:boolean;{mcsFormRAM128,Mdiframe}
    yaHayMapaBitsDI:boolean;//mcsFormMapaBits 2002-03-06
    yaHayAnalizador:boolean;{Mdiframe,mcsAnalizadorLogico}
//    yaHayGenerador:boolean;{mcsGeneradorDeSenal,mcsFormPuerto,Mdiframe}
    yaHayRegTCON:boolean;{mcsFormTCON_TMOD_IE_IP,Mdiframe}
    yaHayRegACC:boolean;{mcsFormBanco,Mdiframe}
    yaHayTimer0Timer1:boolean;{mcsFormTimer0Timer1,Mdiframe}
    yaHayTimer2:boolean;{mcsFormTimer2,Mdiframe}
    yaHayDesensamblado:boolean;{mcsFormDesensamblado,Mdiframe}
    yaHayRegSCON:boolean;{mcsFormSCON,Mdiframe}

    booleACC,booleB:boolean;                    {mcsFormBanco}
    booleR0,booleR1,booleR2,booleR3:boolean;    {mcsFormBanco}
    booleR4 ,booleR5 ,booleR6 ,booleR7 :boolean;{mcsFormBanco}

    {Variables Globales del Sistema}
    yaSeEnsambloPorLoMenosUnaVez:boolean;{Mdiedit,Mdiframe}
    seEnsambloEdicion:boolean;
    RutaNombreArchivoEnsamblado:cadena250;
//    TopeDeLineasENTRE20:integer;
    //MDIFrame
    cantidadEditForms:integer;
    hayPermisoVerLinea:boolean;
    pfSeleccionarFilaEnEjecucion:Tmetodo;
    pfColocarEnVGPosicionFormato:Tmetodo;

    pfSalvarProgramaEnEdicionEnsamblado:Tmetodo2;
    //Generadores de Señal Periodica

    //Posicion de los formatos
    FormatoMtop:integer;  // Formato del Micro
    FormatoMleft:integer; //

    Puerto0top:integer;
    Puerto0left:integer;
    Puerto1top:integer;
    Puerto1left:integer;
    Puerto2top:integer;
    Puerto2left:integer;
    Puerto3top:integer;
    Puerto3left:integer;

    Display0top:integer;
    Display0left:integer;
    Display1top:integer;
    Display1left:integer;
    Display2top:integer;
    Display2left:integer;
    Display3top:integer;
    Display3left:integer;

    RamDItop:integer;
    RamDIleft:integer;

    RamItop:integer;
    RamIleft:integer;

    RamSFRtop:integer;
    RamSFRleft:integer;

    RegACCtop:integer;
    RegACCleft:integer;

    RegTCONtop:integer;
    RegTCONleft:integer;

    RegSCONtop:integer;
    RegSCONleft:integer;

    Timer0Timer1top:integer;
    Timer0Timer1left:integer;

    Timer2top:integer;
    Timer2left:integer;

    Desensambladotop:integer;
    Desensambladoleft:integer;

    ROMtop:integer;
    ROMleft:integer;

    AnalizadorTop:integer;
    AnalizadorLeft:integer;
    AnalizadorTrazos:cadena20;
    ALPines:array[1..NUMERO_MAX_DE_TRAZOS]of cadena20;
    ALEtiq:array[1..NUMERO_MAX_DE_TRAZOS]of cadena20;

    LCDTop:integer;
    LCDLeft:integer;
    LCDDato:cadena20;
    LCDE:cadena20;
    LCDRS:cadena20;
    LCDRW:cadena20;

    TecladoTop:integer;
    TecladoLeft:integer;
    TecladoFila1:cadena20;
    TecladoFila2:cadena20;
    TecladoFila3:cadena20;
    TecladoFila4:cadena20;
    TecladoColumna1:cadena20;
    TecladoColumna2:cadena20;
    TecladoColumna3:cadena20;
    TecladoColumna4:cadena20;

    MDIEditTop:integer;
    MDIEditLeft:integer;
  end;
type
  TvgMicroCon=array [1..NUMERO_MAXIMO_DE_MICROCONTROLADORES] of variablesGlobales;

var
  vgMicroCon:TvgMicroCon;

type
  TInfoPrograma=Class
    //2002-03-11
    MatBloq:MatrizDeBOC;
    CodDec:TObjetoCripto;

    procedure iniciar;
    function seConsiguioLeerDatos(rutaNombre:string):boolean;
    function seConsiguioEscribirDatos(rutaNombre:string):boolean;
    function sonCorrectosDatosTemporales:boolean;
    function esCorrectoTopeDeLineas(topeEntre20:integer):boolean;


    procedure actualizarDatosTemporales;
    procedure cancelarDatosTemporales;
    function convertirBloque60Astring(x:Bloque60):string;
    function convertirStringABloque60(cad:string):Bloque60;
    function SeLeyoFila(Fila:integer;var EtiquetaI:longint;
                                     var CadenaInfo:string):boolean;
    procedure EscribirFila(Fila:integer; CadenaInfo:string);
    function EtiquetaDeFila(Fila:integer):longint;

  end;
var
  InfoPrograma:TInfoPrograma; 

type

  RpuertoSerial=record
    activoT:boolean;
    activoR:boolean;

    bufferT:word;
    bufferR:word;

    {Modo 0. Transmision}
    desbordesModo0T:byte;
    contadorBitsModo0T:byte;
    totalBitsModo0T:byte;

    {Modo 0. Recepcion}
    desbordesModo0R:byte;
    contadorBitsModo0R:byte;
    totalBitsModo0R:byte;

    {Timer 1. Transmision}
    desbordesTimer1T:word;
    contadorBitsTimer1T:byte;
    totalBitsTimer1T:byte;
    {Timer 1. Recepcion}
    desbordesTimer1R:word;
    contadorBitsTimer1R:byte;
    totalBitsTimer1R:byte;

    {Timer 2. Transmision}
    desbordesTimer2T:word;
    contadorBitsTimer2T:byte;
    totalBitsTimer2T:byte;
    {Timer 2. Recepcion}
    desbordesTimer2R:word;
    contadorBitsTimer2R:byte;
    totalBitsTimer2R:byte;

    {Modo 2. Transmision}
    desbordesModo2T:byte;
    contadorBitsModo2T:byte;
    totalBitsModo2T:byte;

    {Modo 2. Recepcion}
    desbordesModo2R:byte;
    contadorBitsModo2R:byte;
    totalBitsModo2R:byte;

  end;

type
  tiempoValor=record
    tiempo:longint;
    valor:byte;
  end;

  arregloTiemposValores=array[0..INDICEMAXIMO_EN_SENAL]of tiempoValor;

  pRSenalDigital=^RSenalDigital;
  RSenalDigital=record
    (* El cambio de este Formato puede hacer incompatible
      con senales archivadas
    *)
    indiceUltimo:integer;{Indice del ultimo flanco}

    tiemposValores:arregloTiemposValores;

    esPeriodica:boolean;
    tiempoMenorEnSenal:longint; { Tiempo menor  }
    tiempoMayorEnSenal:longint; { Tiempo mayor  }

    {Campos de senal de salida}
    {A medida que se van colocando los valores se va recorriendo el
     arreglo en forma circular}

    esSoloSalida:boolean;{Es senal de entrada}
                  // Si en SENE esSoloSalida=TRUE el pin es de salida
                  // Si en SENE esSoloSalida=FALSE el pin es de entrada

    indiceMaximoUsado:integer;{(puede ser mayor que indiceUltimo)}
    indicePrimero:integer;{Indice del primer flanco}

  end;

type

//  pArregloDeSenales=^ArregloDeSenales;

  ArregloDeSenales=array[0..3,0..7]of RSenalDigital;
  {Senales externas en los Puertos}


type
  mem0a127=array[0..127]of byte;
  mem128a255=array[128..255]of byte;

const
  CANTIDAD_DE_CAMBIOS_EN_RAM=20;

type
  pmem8k=^mem8k;
  mem8k=array[0..DIR_ULTIMO_BYTE_MEM_PROG]of byte;
  ram64k=array[0..DIR_ULTIMO_BYTE_RAM_EXT]of byte; //2005-11-20
type
  cambiosEnRAM=record
    tablaArea:array[1..CANTIDAD_DE_CAMBIOS_EN_RAM]of char;
    tablaDirecciones:array[1..CANTIDAD_DE_CAMBIOS_EN_RAM]of word;
    tablaDatos:array[1..CANTIDAD_DE_CAMBIOS_EN_RAM]of byte;
    total:byte;
  end;

type
  instruccion=record
    No_Operandos:byte; { Numero de operandos de la instruccion
                         Por ejemplo para DIV AB tiene 2 operandos }
    tipoO1,tipoO2,tipoO3:char;
      { Tipo de cada operando
        0..7 : R0..R7
        Z    : @R0
        U    : @R1
        P    : DPTR
        I    : #DATA de 1 byte
        Y    : #DATA de 2 bytes
        D    : DATA ADDR de 1 byte
        W    : DATA ADDR de 1 word
        T    : BIT ADDR
        R    : CODE ADDR en salto relativo
        L    : CODE ADDR en salto lejano
        E    : CODE ADDR en salto cercano
        S    : CODE ADDR en salto absoluto
        A    : ACC
        B    : B
        C    : C (bit de acarreo)
        F    : @A+DPTR
        G    : @A+PC
        H    : @DPTR
        }
    ayudaEns:char;
      { Caracter de ayuda para el ensamblador
        '0'..'7'  Operando con direccionamiento Absoluto
        'R'       Ultimo operando con direccionamiento Relativo
        'B'       Un operando con direccionamiento directo de 1 Byte
        'W'       Un operando con direccionamiento directo de 1 Word
        'D'       Dos operandos c/u con direccionamiento directo de 1 byte
        'S'       Sin operandos }
    OC_hex:cadena2;
    No_Bytes:byte;
    periodos:byte;
    mnemonic:cadena14;
  end;
  conjuntoInstrucciones=array[0..255] of instruccion;

type
  TConjuntoInstrucciones=Class
    //2002-03-11
    JuegoI:conjuntoInstrucciones;

    function seConsiguioLeerDatos:boolean;
    function convertirBloque60Astring(x:Bloque60):string;
  end;
var
  ISet:TconjuntoInstrucciones;




const
  nombreArchivoInfoPrograma='ESDRAS52G.DAT';
//  nombreArchivoDeInstrucciones='ESDRAS52I.DAT';
  nombreArchivoDeInstrucciones='IM.DAT';


{Ver bit de byte y colocar valor de bit en byte}
function formarBit(entradaBit:byte):cadena2;

function verBit(byteEntrada:byte;numeroBit:byte):byte;

function verBitDeWord(wordEntrada:word;numeroBit:byte):byte;

procedure ponerBit(var byteEntrada:byte;numeroBit,valorBit:byte);

procedure ponerBitEnWord(var wordEntrada:word;numeroBit,valorBit:byte);

procedure negarBit(var byteEntrada:byte;numeroBit:byte);

function esNombreRegistro(nombre:cadena20;var direccion:word):boolean;

function esDireccionRegistro(direccion:word;var nombre:cadena20):boolean;

  { CALCULO ARITMETICO}
function hallarMayor(a,b:word):word;

function hallarMenor(a,b:word):word;

procedure eliminarEspaciosDeLaDerecha(var linea:string);

         (* PROCESSAMENTO DE ARQUIVOS *)

procedure cifrarArchivoConTObjetoCripto(nomeM,nomeC,nomeMM:cadena20;
                                        AnchoDeLinea:integer);

  {Procesar Clave de Expiracion}


function CiclosATReal(cr:longint;unidadS:cadena10;frec:double):double;

function TiempoACiclosReloj(t:double;unidadS:cadena10;frec:double):longint;

procedure cadenaAPuertoPin(cad:cadena10;var nPuerto,nPin:integer);

procedure PuertoPinAcadena(nPuerto,nPin:integer;var cad:cadena10);

function extraerMicrosPuertosPines(cad:cadena80;var m1,m2,pu1,pu2,pi1,pi2:integer;
                                                var ed:esTipoConexion):boolean;

procedure encadenarMicrosPuertosPines(m1,m2,pu1,pu2,pi1,pi2:integer;
                                                  ed:esTipoConexion;var cad:cadena80);

procedure quitarConexion(var tablaConex:TArregloConexiones;conex:RegistroConexion);

function sePusoConexion(var tablaConex:TArregloConexiones;conex:RegistroConexion):boolean;

procedure eliminarSoloConexionesDinamicas(var tablaConex:TArregloConexiones);


function valorSalidaGenerador(var x:RSenal;fHz:double;nCiclosReloj:longint):byte;



implementation


function valorSalidaGenerador(var x:RSenal;fHz:double;nCiclosReloj:longint):byte;
var
  nResiduo:longint;
begin
  if not x.seAplico then
  begin
    valorSalidaGenerador:=1;
    exit;
  end;
  nResiduo:=(nCiclosReloj - x.nTiempoDeInicio)mod x.nPeriodo;

  if nResiduo < x.nFlanco then
  begin
    valorSalidaGenerador:=x.valorDeInicio;
  end
  else
  begin
    valorSalidaGenerador:=1-x.valorDeInicio;
  end;


end;


function sePusoConexion(var tablaConex:TArregloConexiones;conex:RegistroConexion):boolean;
begin
  inc(tablaConex.totalConexiones);
  if tablaConex.totalConexiones>NUMERO_MAXIMO_DE_CONEXIONES then
  begin
    sePusoConexion:=FALSE;
    exit;
  end;
  tablaConex.TabConex[tablaConex.totalConexiones]:=conex;
  sePusoConexion:=TRUE;
end;

procedure quitarConexion(var tablaConex:TArregloConexiones;conex:RegistroConexion);
var
  i,pos:integer;
function sonIguales(conex1,conex2:RegistroConexion):boolean;
begin
  if (conex1.nMicro1 = conex2.nMicro1)and
     (conex1.nMicro2 = conex2.nMicro2)and
     (conex1.pinMicro1 = conex2.pinMicro1)and
     (conex1.pinMicro2 = conex2.pinMicro2)and
     (conex1.puertoMicro1 = conex2.puertoMicro1)and
     (conex1.puertoMicro2 = conex2.puertoMicro2) then sonIguales:=TRUE
  else sonIguales:=FALSE;
end;
begin
  //Hallar posicion del registro
  pos:=0;
  for i:= 1 to tablaConex.totalConexiones do
  begin
    if sonIguales(tablaConex.TabConex[i],conex) then
    begin
      pos:=i;
      break;
    end;
  end;
  if pos=0 then exit;
  //Desplazar los registros
  for i:= pos to tablaConex.totalConexiones-1 do
  begin
    tablaConex.TabConex[i]:=tablaConex.TabConex[i+1];
  end;
  dec(tablaConex.totalConexiones);


end;

function extraerMicrosPuertosPines(cad:cadena80;var m1,m2,pu1,pu2,pi1,pi2:integer;
                                                var ed:esTipoConexion):boolean;
var
  codigoError:integer;

begin
(*
Micro 1: P0.0       se conecta con       Micro 2: P0.3   E
*)
//  if length(cad)<4 then exit;
  Val(cad[7],m1,codigoError);
  if codigoError > 0 then
  begin
    extraerMicrosPuertosPines:=FALSE;
    exit;
  end;
  Val(cad[48],m2,codigoError);
  if codigoError > 0 then
  begin
    extraerMicrosPuertosPines:=FALSE;
    exit;
  end;
  Val(cad[11],pu1,codigoError);
  if codigoError > 0 then
  begin
    extraerMicrosPuertosPines:=FALSE;
    exit;
  end;
  Val(cad[52],pu2,codigoError);
  if codigoError > 0 then
  begin
    extraerMicrosPuertosPines:=FALSE;
    exit;
  end;
  Val(cad[13],pi1,codigoError);
  if codigoError > 0 then
  begin
    extraerMicrosPuertosPines:=FALSE;
    exit;
  end;
  Val(cad[54],pi2,codigoError);
  if codigoError > 0 then
  begin
    extraerMicrosPuertosPines:=FALSE;
    exit;
  end;
  case cad[58] of
  'E':begin ed:=ESTATICA end;
  'D':begin ed:=DINAMICA end;
  end;
  extraerMicrosPuertosPines:=TRUE;
end;

procedure encadenarMicrosPuertosPines(m1,m2,pu1,pu2,pi1,pi2:integer;
                                                  ed:esTipoConexion;var cad:cadena80);
var
  cm1,cm2,cpu1,cpu2,cpi1,cpi2,ced:cadena10;
begin
  str(m1,cm1);
  str(m2,cm2);
  str(pu1,cpu1);
  str(pu2,cpu2);
  str(pi1,cpi1);
  str(pi2,cpi2);
  case ed of
  ESTATICA:begin ced:='E' end;
  DINAMICA:begin ced:='D' end;
  end;
  cad:='Micro '+cm1+': P'+cpu1+'.'+cpi1+'       se conecta con       Micro '+cm2+': P'+cpu2+'.'+cpi2+'   '+ced;
end;

procedure cadenaAPuertoPin(cad:cadena10;var nPuerto,nPin:integer);
var
  numeroPuerto,numeroPin,codigoError:integer;
begin
  nPuerto:=0;
  nPin:=0;
  if length(cad)<4 then exit;
  Val(cad[2],numeroPuerto,codigoError);
  if codigoError > 0 then exit;
  Val(cad[4], numeroPin, codigoError);
  if codigoError > 0 then exit;
  nPuerto:=numeroPuerto;
  nPin:=numeroPin;
end;

procedure eliminarSoloConexionesDinamicas(var tablaConex:TArregloConexiones);
var
  i:integer;
  tablaAux:TArregloConexiones;
begin
  tablaAux.totalConexiones:=0;
  for i:= 1 to tablaConex.totalConexiones do
  begin
    if tablaConex.TabConex[i].tipoDeConexion=ESTATICA then
    begin
      sePusoConexion(TablaAux,tablaConex.TabConex[i]);
    end;
  end;
  tablaConex:=tablaAux;
end;

procedure PuertoPinAcadena(nPuerto,nPin:integer;var cad:cadena10);
var
  cadenaAyuda1,cadenaAyuda2:cadena10;
begin
  str(nPuerto,cadenaAyuda1);
  str(nPin,cadenaAyuda2);
  cad:='P'+cadenaAyuda1+'.'+cadenaAyuda2;
end;


function TiempoACiclosReloj(t:double;unidadS:cadena10;frec:double):longint;
var
  crd:double;
begin
  if unidadS='(uS)' then
  begin
//    crd:=(t*vgMicroCon.frecuenciaHz)/1000000;
    crd:=(t*frec)/1000000;
    TiempoACiclosReloj:=Round(crd);
    exit;
  end;
  if unidadS='(mS)' then
  begin
    crd:=(t*frec)/1000;
    TiempoACiclosReloj:=Round(crd);
    exit;
  end;
  if unidadS='(S)' then
  begin
    crd:=(t*frec)/1;
    TiempoACiclosReloj:=Round(crd);
    exit;
  end;
  crd:=(t*frec)/1;
  TiempoACiclosReloj:=Round(crd);
end;

function CiclosATReal(cr:longint;unidadS:cadena10;frec:double):double;
var
  microS:double;
begin
  if unidadS='(uS)' then
  begin
    microS:=cr*(1000000/frec);
    CiclosATReal:=microS;
    exit;
  end;
  if unidadS='(mS)' then
  begin
    microS:=cr*(1000000/frec);
    CiclosATReal:=microS/1000;
    exit;
  end;
  if unidadS='(S)' then
  begin
    microS:=cr*(1000000/frec);
    CiclosATReal:=microS/1000000;
    exit;
  end;
  microS:=cr*(1000000/frec);
  CiclosATReal:=microS/1000000;
end;

function hallarMayor(a,b:word):word;
begin
  if a>b then hallarMayor:=a else hallarMayor:=b;
end;

function hallarMenor(a,b:word):word;
begin
  if a<b then hallarMenor:=a else hallarMenor:=b;
end;

//2002-03-09
// Inicio TObjetoCripto

procedure TObjetoCripto.formarLlave;
var
  i:integer;
  X,C1:longint;
const
  aleaConst0=1375915145;
  aleaConst1=1379515154;
//  aleaConst1=1375915145;
  aleaConst2=1739514417;
procedure generador;
asm
  PUSH EAX
  PUSH EBX
  MOV EAX,C1
  ROR EAX,1
  MOV C1,EAX
  MOV EBX,X
  XOR EAX,EBX
  MOV X,EAX
  POP EBX
  POP EAX
end;
begin
  C1:=aleaConst1;
  X:=aleaConst2;
  for i:=1 to TAMANO_DE_BLOQUE60 do
  begin
    generador;
    llave[i]:=abs(X);
  end;
end;
(*
procedure TObjetoCripto.formarLlave;
var
  i:integer;
  alea:longint;
const
  aleaConst=1735915145;
begin
  alea:=aleaConst;
  for i:=1 to TAMANO_DE_BLOQUE60 do
  begin
    alea:=(alea shl 1)xor( (alea shr 16)or( (alea shl 16)and $FFFF0000));
    llave[i]:=abs(alea);
  end;
end;
*)

function TObjetoCripto.LlaveComoCadena:string;
var
  i:integer;
  stringLlave:string;
  cad:cadena10;
begin
  stringLlave:='';
  for i:=1 to TAMANO_DE_BLOQUE60 do
  begin
    str(llave[i],cad);
    stringLlave:=stringLlave+cad+' ';
  end;
  LlaveComoCadena:=stringLlave;
end;

function TObjetoCripto.codificar(d:byte;
                       x:Bloque60):Bloque60;
var
  i:integer;
  y:Bloque60;
begin
  for i:=1 to TAMANO_DE_BLOQUE60 do
  begin
    y[i]:=x[i] xor (llave[i] + d);
  end;
  codificar:=y;
end;
// Fin TObjetoCripto

procedure cifrarArchivoConTObjetoCripto(nomeM,nomeC,nomeMM:cadena20;
                                        AnchoDeLinea:integer);
//2002-03-09
var
  FromF, ToF, mmF: file;
  NumRead, NumWritten: Integer;
  Buf:Bloque60;
  cifrador:TObjetoCripto;
  delta:byte;
begin
  cifrador:=TObjetoCripto.create;
  cifrador.formarLlave;
  showmessage(cifrador.LlaveComoCadena);
//  cifrador.mostrarLlave;
  AssignFile(FromF, nomeM);
  Reset(FromF, 1);	{ Record size = 1 }
  AssignFile(ToF, nomeC);	{ Open output file }
  Rewrite(ToF, 1);	{ Record size = 1 }
  AssignFile(mmF, nomeMM);	{ Open output file }
  Rewrite(mmF, 1);	{ Record size = 1 }
  delta:=0;
  repeat
    BlockRead(FromF, Buf, AnchoDeLinea + 2, NumRead);
    Buf:=cifrador.codificar(delta,Buf);
    BlockWrite(ToF, Buf, NumRead, NumWritten);
    Buf:=cifrador.codificar(delta,Buf);
    BlockWrite(mmF, Buf, NumRead, NumWritten);
    inc(delta);
  until (NumRead = 0) or (NumWritten <> NumRead);
  CloseFile(FromF);
  CloseFile(ToF);
  CloseFile(mmF);
  cifrador.destroy;
end;

procedure eliminarEspaciosDeLaDerecha(var linea:string);
  function lugarUltimaLetra(cad:string):integer;
  var
    tamano,i:integer;
  begin
    tamano:=length(cad);
    for i:=tamano downto 1 do
    begin
      if (cad[i]<>' ') then
      begin
        lugarUltimaLetra:=i;
        exit;
      end;
    end;
    lugarUltimaLetra:=0;
  end;
var
  b:integer;
begin
  b:=lugarUltimaLetra(linea);
  if b=0 then
  begin
    linea:='';
  end
  else
  begin
    linea:=copy(linea,1,b);
  end;
end;

{Fin Objeto TCriptografo}

{ OBJETO Toshibka }

procedure Toshibka.anular;
begin
  CodigoError:=0;
  descripcionDeError:='';
end;

function Toshibka.existe:boolean;
begin
  if CodigoError=0 then existe:=FALSE
  else existe:=TRUE;
end;

procedure Toshibka.colocar(codigo:word;errorS:string);
begin
  CodigoError:=codigo;
  descripcionDeError:=errorS;
end;

function Toshibka.cualEs:string;
begin
  if CodigoError=0 then
  begin
    cualEs:=' NO SE DETECTO ERROR ';
    exit;
  end;
  cualEs:=descripcionDeError;
end;

function esNombreRegistro(nombre:cadena20;var direccion:word):boolean;
begin
  if (nombre='ACC') then
  begin direccion:=direccionACC; esNombreRegistro:=TRUE; exit; end;
  if (nombre='B') then
  begin direccion:=direccionB; esNombreRegistro:=TRUE; exit; end;
  if (nombre='PSW') then
  begin direccion:=direccionPSW; esNombreRegistro:=TRUE; exit; end;
  if (nombre='IP') then
  begin direccion:=direccionIP; esNombreRegistro:=TRUE; exit; end;
  if (nombre='P3') then
  begin direccion:=direccionP3; esNombreRegistro:=TRUE; exit; end;
  if (nombre='IE') then
  begin direccion:=direccionIE; esNombreRegistro:=TRUE; exit; end;
  if (nombre='P2') then
  begin direccion:=direccionP2; esNombreRegistro:=TRUE; exit; end;
  if (nombre='SCON') then
  begin direccion:=direccionSCON; esNombreRegistro:=TRUE; exit; end;
  if (nombre='SBUF') then
  begin direccion:=direccionSBUF; esNombreRegistro:=TRUE; exit; end;
  if (nombre='P1') then
  begin direccion:=direccionP1; esNombreRegistro:=TRUE; exit; end;
  if (nombre='TCON') then
  begin direccion:=direccionTCON; esNombreRegistro:=TRUE; exit; end;
  if (nombre='TMOD') then
  begin direccion:=direccionTMOD; esNombreRegistro:=TRUE; exit; end;
  if (nombre='TL0') then
  begin direccion:=direccionTL0; esNombreRegistro:=TRUE; exit; end;
  if (nombre='TH0') then
  begin direccion:=direccionTH0; esNombreRegistro:=TRUE; exit; end;
  if (nombre='TL1') then
  begin direccion:=direccionTL1; esNombreRegistro:=TRUE; exit; end;
  if (nombre='TH1') then
  begin direccion:=direccionTH1; esNombreRegistro:=TRUE; exit; end;
  if (nombre='P0') then
  begin direccion:=direccionP0; esNombreRegistro:=TRUE; exit; end;
  if (nombre='SP') then
  begin direccion:=direccionSP; esNombreRegistro:=TRUE; exit; end;
  if (nombre='DPL') then
  begin direccion:=direccionDPL; esNombreRegistro:=TRUE; exit; end;
  if (nombre='DPH') then
  begin direccion:=direccionDPH; esNombreRegistro:=TRUE; exit; end;
  if (nombre='PCON') then
  begin direccion:=direccionPCON; esNombreRegistro:=TRUE; exit; end;

  if (nombre='T2CON') then
  begin direccion:=direccionT2CON; esNombreRegistro:=TRUE; exit; end;
  if (nombre='TL2') then
  begin direccion:=direccionTL2; esNombreRegistro:=TRUE; exit; end;
  if (nombre='TH2') then
  begin direccion:=direccionTH2; esNombreRegistro:=TRUE; exit; end;
  if (nombre='RCAP2L') then
  begin direccion:=direccionRCAP2L; esNombreRegistro:=TRUE; exit; end;
  if (nombre='RCAP2H') then
  begin direccion:=direccionRCAP2H; esNombreRegistro:=TRUE; exit; end;

  esNombreRegistro:=FALSE;

end;

function esDireccionRegistro(direccion:word;var nombre:cadena20):boolean;
begin
  if direccion=direccionACC then
  begin nombre:='ACC'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionB then
  begin nombre:='B'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionPSW then
  begin nombre:='PSW'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionIP then
  begin nombre:='IP'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionP3 then
  begin nombre:='P3'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionIE then
  begin nombre:='IE'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionP2 then
  begin nombre:='P2'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionSCON then
  begin nombre:='SCON'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionSBUF then
  begin nombre:='SBUF'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionP1 then
  begin nombre:='P1'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionTCON then
  begin nombre:='TCON'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionTMOD then
  begin nombre:='TMOD'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionTL0 then
  begin nombre:='TL0'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionTH0 then
  begin nombre:='TH0'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionTL1 then
  begin nombre:='TL1'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionTH1 then
  begin nombre:='TH1'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionP0 then
  begin nombre:='P0'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionSP then
  begin nombre:='SP'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionDPL then
  begin nombre:='DPL'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionDPH then
  begin nombre:='DPH'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionPCON then
  begin nombre:='PCON'; esDireccionRegistro:=TRUE; exit; end;

  if direccion=direccionT2CON then
  begin nombre:='T2CON'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionTL2 then
  begin nombre:='TL2'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionTH2 then
  begin nombre:='TH2'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionRCAP2L then
  begin nombre:='RCAP2L'; esDireccionRegistro:=TRUE; exit; end;
  if direccion=direccionRCAP2H then
  begin nombre:='RCAP2H'; esDireccionRegistro:=TRUE; exit; end;

  esDireccionRegistro:=FALSE;
end;

{Funciones de Puerto Serial}
{Sistema de Interrupciones}
function formarBit(entradaBit:byte):cadena2;
begin
  if entradaBit=0 then formarBit:='0'
  else formarBit:='1';
end;

function verBit(byteEntrada:byte;numeroBit:byte):byte;
begin
  verBit:=(byteEntrada shr numeroBit)and 1;
end;

function verBitDeWord(wordEntrada:word;numeroBit:byte):byte;
var
  wordUno:word;
begin
  wordUno:=1;
  verBitDeWord:=(wordEntrada shr numeroBit)and wordUno ;
end;

procedure ponerBit(var byteEntrada:byte;numeroBit,valorBit:byte);
begin
  if valorBit=0 then
  begin { Para resetear se usa la operacion logica AND }
    byteEntrada:=(not(1 shl numeroBit))and byteEntrada;
  end
  else
  begin { Para setear se usa la operacion logica OR }
    byteEntrada:=(1 shl numeroBit)or byteEntrada;
  end;
end;

procedure ponerBitEnWord(var wordEntrada:word;numeroBit,valorBit:byte);
var
  wordUno:word;
begin
  wordUno:=1;
  if valorBit=0 then
  begin { Para resetear se usa la operacion logica AND }
    wordEntrada:=(not(wordUno shl numeroBit))and wordEntrada;
  end
  else
  begin { Para setear se usa la operacion logica OR }
    wordEntrada:=(wordUno shl numeroBit)or wordEntrada;
  end;
end;

procedure negarBit(var byteEntrada:byte;numeroBit:byte);
var
  valorBit:byte;
begin
  valorBit:=verBit(byteEntrada,numeroBit);
  if valorBit=0 then
  begin{ Setear con la operacion logica OR }
    ponerBit(byteEntrada,numeroBit,1);
  end
  else
  begin{ Resetear con la operacion logica AND }
    ponerBit(byteEntrada,numeroBit,0);
  end;
end;

//Inicio Objeto TInfoPrograma

procedure TInfoPrograma.iniciar;
begin
  CodDec:=TObjetoCripto.create;
  CodDec.formarLlave;
end;

function TInfoPrograma.seConsiguioLeerDatos(rutaNombre:string):boolean;
var
  FromF: file;
  NumRead: Integer;
  Buf:Bloque60;
  i,contadorBloques:integer;
begin
  seConsiguioLeerDatos:=FALSE;
  if not(FileExists(rutaNombre)) then
  begin
    showMessage('No existe archivo: '+rutaNombre);
    exit;
  end;
//  AssignFile(FromF,vgMicroCon.RutaDePrograma+'/'+nombreArchivoInfoPrograma);
  AssignFile(FromF,rutaNombre);
  Reset(FromF, 1);	{ Record size = 1 }
  i:=0;
  contadorBloques:=0;
  repeat
    BlockRead(FromF, Buf, ANCHO_ARCHIVO_INFO_PROGRAMA + 2, NumRead);
    if (i < NUMERO_BLOQUES) then
    begin
      MatBloq[i]:=Buf;
      inc(contadorBloques);
    end;
    inc(i);
  until (NumRead = 0);
  CloseFile(FromF);
  if contadorBloques=NUMERO_BLOQUES then seConsiguioLeerDatos:=TRUE;
end;

function TInfoPrograma.seConsiguioEscribirDatos(rutaNombre:string):boolean;
var
  ToF: file;
  NumWritten: Integer;
  i,contadorBloques:integer;
begin
  seConsiguioEscribirDatos:=FALSE;
  if not(FileExists(rutaNombre)) then
  begin
    showMessage('Error al escribir archivo (Disco/disquete Protegido)');
    exit;
  end;
  AssignFile(ToF,rutaNombre);	{ Open output file }
  Rewrite(ToF, 1);	{ Record size = 1 }
  contadorBloques:=0;
  for i:=0 to NUMERO_BLOQUES - 1 do
  begin
    BlockWrite(ToF,MatBloq[i],ANCHO_ARCHIVO_INFO_PROGRAMA + 2,NumWritten);
    inc(contadorBloques);
  end;
  CloseFile(ToF);
  if contadorBloques=NUMERO_BLOQUES then seConsiguioEscribirDatos:=TRUE;
end;

procedure TInfoPrograma.actualizarDatosTemporales;
var
  codigo:integer;
  EtiquetaI:longint;
  cantidadUsos:longint;
  x:string;
begin
  //Actualiza Fecha
  x:=FormatDateTime('yyyy-mm-dd hh:nn:ss',now);
  EscribirFila(7,x);
  EscribirFila(7+30,x);
  //Actualiza Cantidad de Usos
  if seLeyoFila(9,EtiquetaI,x) then
  begin
    val(x,cantidadUsos,codigo);
    if codigo=0 then
    begin
      EscribirFila(9,IntToStr(cantidadUsos+1));
      EscribirFila(9+30,IntToStr(cantidadUsos+1));
    end
    else
    begin
      cancelarDatosTemporales;
    end;
  end
  else
  begin
    cancelarDatosTemporales;
  end;
end;

procedure TInfoPrograma.cancelarDatosTemporales;
var
  x:string;
  EtiquetaI:longint;
begin
  if seLeyoFila(6,EtiquetaI,x) then
  begin
    EscribirFila(7,x);
    EscribirFila(9,x);
  end;
  EscribirFila(7,x);
  EscribirFila(9,x);
end;

function TInfoPrograma.sonCorrectosDatosTemporales:boolean;
var
  codigo1,codigo2,i:integer;
  Info1Entero,Info2Entero:longint;
  Etiqueta1,Etiqueta2:longint;
  info1,info2:string;
begin
  //Verificar que existen duplicados
  for i:=0 to (NUMERO_BLOQUES div 2) - 1 do  // es -1
  begin
    if (not(seLeyoFila(i   ,Etiqueta1,Info1)))or
       (not(seLeyoFila(i+30,Etiqueta2,Info2)))  then
    begin
      sonCorrectosDatosTemporales:=FALSE;
      exit;
    end
    else
    begin
      if ((Etiqueta1+300)<>Etiqueta2)or(Info1<>Info2)then
      begin
        sonCorrectosDatosTemporales:=FALSE;
        exit;
      end;
    end;
  end;
  //Verificar Vencimiento
//     1060:2002-08-31 12:00:00
//     1070:2002-03-01 12:00:00
  if seLeyoFila(6,Etiqueta1,Info1)and seLeyoFila(7,Etiqueta2,Info2) then
  begin
    if (Info1<FormatDateTime('yyyy-mm-dd hh:nn:ss',now))or
       (Info2>FormatDateTime('yyyy-mm-dd hh:nn:ss',now))then
    begin
      sonCorrectosDatosTemporales:=FALSE;
      exit;
    end;
  end;
  //Verificar Cantidad de Usos
//     1080:200
//     1090:0
  if seLeyoFila(8,Etiqueta1,Info1)and seLeyoFila(9,Etiqueta2,Info2) then
  begin
    val(Info1,Info1Entero,codigo1);
    val(Info2,Info2Entero,codigo2);
    if (codigo1<>0)or(codigo2<>0)or(Info1Entero<=Info2Entero) then
    begin
      sonCorrectosDatosTemporales:=FALSE;
      exit;
    end;
  end;
  sonCorrectosDatosTemporales:=TRUE;
end;

function TInfoPrograma.esCorrectoTopeDeLineas(topeEntre20:integer):boolean;
var
  codigo1:integer;
  Info1Entero:longint;
  Etiqueta1:longint;
  info1:string;
  tope:longInt;
begin
//Verificar Tope de Lineas
//     1270:1000
//     1570:1000
  esCorrectoTopeDeLineas:=FALSE;
//  tope:=vgMicroCon.TopeDeLineasENTRE20*20;
  tope:=topeEntre20*20;
  if seLeyoFila(27,Etiqueta1,Info1) then
  begin
    val(Info1,Info1Entero,codigo1);
    if (codigo1=0)and(Info1Entero=tope) then
    begin
      esCorrectoTopeDeLineas:=TRUE;
    end;
  end;
end;

function TInfoPrograma.convertirBloque60Astring(x:Bloque60):string;
var
  i:integer;
  y:string;
begin
  y:='';
  for i:=1 to ANCHO_ARCHIVO_INFO_PROGRAMA do
  begin
    y:=y+chr(x[i]);
  end;
  EliminarEspaciosDeLaDerecha(y);
  convertirBloque60Astring:=y;
end;

function TInfoPrograma.convertirStringABloque60(cad:string):Bloque60;
var
  i:integer;
  y:Bloque60;
  tamano:integer;
begin
  tamano:=length(cad);

  for i:=1 to ANCHO_ARCHIVO_INFO_PROGRAMA do
  begin
    if i<=tamano then y[i]:=LOBYTE(Ord(cad[i])) else y[i]:=LOBYTE(Ord(' '));
  end;

  y[ANCHO_ARCHIVO_INFO_PROGRAMA + 1]:=$0A;
  y[ANCHO_ARCHIVO_INFO_PROGRAMA + 2]:=$0D;

  convertirStringABloque60:=y;
end;

function TInfoPrograma.SeLeyoFila(Fila:integer;var EtiquetaI:longint;
                                  var CadenaInfo:string):boolean;
var
  codigo:integer;
  x:Bloque60;
  y:string;
  EtiquetaC:cadena20;
begin
  x:=CodDec.codificar(Fila,MatBloq[Fila]);
  y:=convertirBloque60Astring(x);
  EtiquetaC:=copy(y,1,4);             //Tomar Etiqueta
  val(EtiquetaC,EtiquetaI,codigo);    //Convertir a longint
  CadenaInfo:=copy(y,6,53);           //Tomar Información

  if((codigo=0)and(EtiquetaI=EtiquetaDeFila(Fila)))then
  begin
    SeLeyoFila:=TRUE
  end
  else
  begin
    SeLeyoFila:=FALSE;
  end;
end;

procedure TInfoPrograma.EscribirFila(Fila:integer;
                                     CadenaInfo:string);
begin
  MatBloq[Fila]:=
    CodDec.codificar(Fila,
      convertirStringABloque60(IntToStr(EtiquetaDeFila(Fila))+
                               ':'+CadenaInfo));

end;

function TInfoPrograma.EtiquetaDeFila(Fila:integer):longint;
begin
  EtiquetaDeFila:=1000+(Fila*10);
end;
//Fin Objeto TInfoPrograma

//Inicio Objeto TConjuntoInstrucciones

function TConjuntoInstrucciones.seConsiguioLeerDatos:boolean;
var
  FromF: file;
  NumRead: Integer;
  Buf:Bloque60;
  i:integer;
  linha:string;
  linea14:cadena14;
  CodDec:TObjetoCripto;
  codigo,valorEntero:integer;
begin
  CodDec:=TObjetoCripto.create;
  CodDec.formarLlave;
  seConsiguioLeerDatos:=FALSE;

  if not(FileExists(nombreArchivoDeInstrucciones)) then
  begin
    showMessage('No existe archivo: '+nombreArchivoDeInstrucciones);
    exit;
  end;
  AssignFile(FromF, nombreArchivoDeInstrucciones);
  Reset(FromF, 1);	{ Record size = 1 }
  i:=0;
  repeat
    BlockRead(FromF, Buf, ANCHO_ARCHIVO_INSTRUCCIONES + 2, NumRead);
//    Buf:=CodDec.codificar(i,Buf);
    linha:=convertirBloque60Astring(Buf);
    if (linha<>'')and(i<256) then
    begin{Llenado del Juego de Instrucciones}
      linea14:=copy(linha,1,1);
      val(linea14,valorEntero,codigo);
      JuegoI[i].No_Operandos:=valorEntero;

      JuegoI[i].tipoO1:=linha[2];
      JuegoI[i].tipoO2:=linha[3];
      JuegoI[i].tipoO3:=linha[4];

      JuegoI[i].ayudaEns:=linha[6{1}];
      JuegoI[i].OC_hex:=copy(linha,8{3},2);
      linea14:=copy(linha,11{6},1);
      val(linea14,valorEntero,codigo);
      JuegoI[i].No_bytes:=valorEntero;
      linea14:=copy(linha,13{8},2);
      val(linea14,valorEntero,codigo);
      JuegoI[i].periodos:=valorEntero;
      JuegoI[i].mnemonic:=copy(linha,16{11},14);
    end;{Llenado del Juego de Instrucciones}
    inc(i);
  until (NumRead = 0);
  CodDec.destroy;
  CloseFile(FromF);
  if i>=256 then seConsiguioLeerDatos:=TRUE;
end;

function TConjuntoInstrucciones.convertirBloque60Astring(x:Bloque60):string;
var
  i:integer;
  y:string;
begin
  y:='';
  for i:=1 to ANCHO_ARCHIVO_INSTRUCCIONES do
  begin
    y:=y+chr(x[i]);
  end;
  EliminarEspaciosDeLaDerecha(y);
  convertirBloque60Astring:=y;
end;

//Fin Objeto TConjuntoInstrucciones

end.


