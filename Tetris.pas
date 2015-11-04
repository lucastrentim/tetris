///////////////////////////////////////////////////////////
///				T3 - Algoritmos I - Tetris				///
///		Aluno:											///
//		Lucas Trentim Navarro de Almeida				///
///////////////////////////////////////////////////////////}
Program Tetris;
Uses crt;

Const 
	BGC = LightGray;
	TC = Black;

type  R3 = Array[1..10,1..25,1..2] of byte;
 
var Matriz  	: R3;
	Next		: Array[1..4,1..4,1..2] of byte;
	Pecas 		: array[0..6,1..4,1..4,1..2] of byte;

	Pontuacao 	: longint;
	Nivel 		: byte;
	Fim			: boolean;


{//////////////////////////////////////////////////////
///					Configurações					///
///////////////////////////////////////////////////////}
procedure Configuracao;
var Info	: array[1..2] of byte;
	i, j, k	: byte;
	
Begin
	// Limpa os arrays e as variáveis para garantir o bom funcionamento do jogo.
	Pontuacao 	:= 0;
	Nivel		:= 0;
	Fim		 	:= false;
	TextBackground( BGC );
	TextColor( TC );
	
	// Info[1] = Tipo do Bloco
	// 0 : Bloco Vazio
	// 1 : Bloco Estático
	// 2 : Bloco Móvel
	// Info[2] = Cor do Bloco	
	Info[1] := 0; Info[2] := 0;

	// Matriz tetradimensional de Peças
	for i:= 0 to 6 do for j:= 1 to 4 do
	for k:= 1 to 4 do Pecas[ i, j, k ] := Info;
	
	// Matriz tridimensional de coordenadas
	for i:= 1 to 10 do for j:= 1 to 25 do Matriz[ i, j ] := Info;

	
	Info[1] := 2;
	{Z}
	Info[2] := LightRed; //12;
	Pecas[0, 1, 3]:= Info;
	Pecas[0, 2, 2]:= Info;
	Pecas[0, 2, 3]:= Info;
	Pecas[0, 3, 2]:= Info;

	{Cubo}
	Info[2] := Yellow;//2;
	Pecas[1, 2, 2]:= Info;
	Pecas[1, 2, 3]:= Info;
	Pecas[1, 3, 2]:= Info;
	Pecas[1, 3, 3]:= Info;

	{L}
	Info[2] := LightCyan;//5;
	Pecas[2, 1, 2]:= Info;
	Pecas[2, 2, 2]:= Info;
	Pecas[2, 3, 2]:= Info;
	Pecas[2, 3, 3]:= Info;

	{J}
	Info[2] := Blue;//6;
	Pecas[3, 1, 3]:= Info;
	Pecas[3, 2, 3]:= Info;
	Pecas[3, 3, 2]:= Info;
	Pecas[3, 3, 3]:= Info;

	{T}
	Info[2] := Magenta;//3;
	Pecas[4, 2, 1]:= Info;
	Pecas[4, 2, 2]:= Info;
	Pecas[4, 2, 3]:= Info;
	Pecas[4, 3, 2]:= Info;

	{linha}
	Info[2] := LightBlue;//4;
	Pecas[5, 2, 1]:= Info;
	Pecas[5, 2, 2]:= Info;
	Pecas[5, 2, 3]:= Info;
	Pecas[5, 2, 4]:= Info;

	{S}
	Info[2] := LightGreen;//9;
	Pecas[6, 2, 3]:= Info;
	Pecas[6, 2, 2]:= Info;
	Pecas[6, 3, 2]:= Info;
	Pecas[6, 3, 1]:= Info;

	// Para a aleatorização das peças
	Randomize;
	cursoroff;

End;

{//////////////////////////////////////////////////
///					Interface					///
///////////////////////////////////////////////////}
{
	ASCII art utilizada no menu inicial.
}
Procedure Header;
begin
		Window( 1, 1, 80, 25 );
		ClrScr;
		GoToXY(13,3); writeln(' _______  _______  _______  _______    _____   _____  ');
		GoToXY(13,4); writeln('|  ___  | | ___  ||  ___  | |_  __ |  |_   _| /   _  \');
		GoToXY(13,5); writeln('|_|| ||_| | |_ |_||_|| ||_|  | |_/ |    | |   \  / \_/');
		GoToXY(13,6); writeln('   | |    |   |      | |     | _  /     | |    \  \   ');
		GoToXY(13,7); writeln('   | |    |  _| _    | |     | |\ \     | |   _ \  \  ');
		GoToXY(13,8); writeln('  _| |_   | |__| |  _| |_    | | \ \__ _| |_ | \_/  \ ');
		GoToXY(13,9); writeln(' |_____|  |______| |_____|   |_|  \___|_____| \_____/ ');
end;

{
	Janela de Ajuda.
}
Procedure Ajuda;
begin
		Header;
		GoToXY(5,14);  write('Seu objetivo e alinhar as pecas em linhas completas. Voce pode girar');
		GoToXY(4,15);  write('as pecas usando a seta para cima do teclado, move-las com as setas para');
		GoToXY(6,16);  write('os lados, usar a seta para baixo para derrubar a peca mais rapido e');
		GoToXY(12,17); write('a tecla espaco para manda-la direto para o fim da tela.');
		GoToXY(15,18); write('Voce pode pausar a qualquer momento com a tecla P');
		GoToXY(37,20); write('[x] OK');
		
		ReadKey;
end;

{
	Desenha automaticamente uma janela
	Parâmetros:
	Sx, Sy : Inicio
	Fx, Fy : Fim
	Título : String posicionada automaticamente no centro do topo da janela
}
Procedure Janela( Sx, Sy, Fx, Fy : byte; titulo : string );
var i, j: byte;
begin
	TextBackground( BGC );
	TextColor( TC );
	
	for j:= Sy to Fy do
	begin
		GotoXY( Sx, j );
		for i:= Sx to Fx do
			if ( i = Sx ) and ( j = Sy ) then Write( chr(201) ) else 
			if ( i = Sx ) and ( j = Fy ) then Write( chr(200) ) else 
			if ( i = Fx ) and ( j = Sy ) then Write( chr(187) ) else 
			if ( i = Fx ) and ( j = Fy ) then Write( chr(188) ) else 
			if ( i = Sx ) or  ( i = Fx ) then Write( chr(186) ) else 
			if ( j = Sy ) or  ( j = Fy ) then Write( chr(205) ) else 
			Write( ' ' );
	end;
	
	if titulo <> '' then
	begin
		GotoXY( ( ( Sx + Fx ) div 2 ) - ( Length(titulo) div 2 ) , Sy + 1 );
		Write( titulo );
	end;

	GotoXY(Sx + 2, Sy + 2);
end;

{
	Janela do fim de jogo, mostrando a pontuação e o nível final.
}
Procedure JanelaFim;
begin
		Window( 1, 1, 80, 25 );
		clrscr;
		Janela( 15, 5 , 65, 20, 'Fim de Jogo!' );
		
		Window( 25, 11, 55, 14 );
		Writeln( 'Pontuacao : ', Pontuacao  );
		Writeln( 'Nivel : ', Nivel  );
		Readkey;
end;

{
	Janela do canto inferior direito, mostra o nível.
}
Procedure JanelaNivel;
begin
		Window( 1, 1, 80, 25 );
		GotoXY( 54, 15 );
		Write('Nivel');
		Janela( 50, 16, 62, 22, '' );
		Window( 52, 19, 60, 20 );
		Write( Nivel );
end;

{
	Janela do canto superior direito, mostra a Pontuação.
}
Procedure JanelaPontuacao;
begin
		Window( 1, 1, 80, 25 );
		GotoXY( 52, 6 );
		Write('Pontuacao');
		Janela( 50, 7, 62, 13, '' );
		Window( 52, 10, 60, 11 );
		Write( Pontuacao );
end;

{
	Janela do canto esquerdo, mostra a proxima peça.
}
Procedure JanelaProximo;
begin
		Window( 1, 1, 80, 25 );
		GotoXY( 21, 6 );
		Write('Proxima');
		Janela( 20, 7, 28, 13, '' );
		Window( 24, 8, 27, 11 );
end;

{
	Janela central, onde ocorre o jogo.
}
Procedure JanelaJogo;
begin
		Window( 1, 1, 80, 25 );
		Janela( 34, 2, 45, 23, '' );
end;

{
	Cria automaticamente um menu com as strings passadas num array como parâmetro, retornando
	a opção escolhida numericamente ( byte ).
	Parâmetros:
	Opcoes : Array de Strings contendo as opções
	Sx, Sy : Inicio
	Fx, Fy : Fim
	Título : String posicionada automaticamente no centro do topo da janela
}
function Menu( Opcoes : array of string; Sx, Sy : byte; titulo : string ) : byte;
var i, MaxLength, Fx, Fy, Curs 	: byte;
	chr							: char;
begin
	for i:= Low( Opcoes ) to High( Opcoes ) do
		if Length( Opcoes[i] ) > MaxLength then MaxLength := Length( Opcoes[i] );

	Fx := Sx + MaxLength + 8;
	if titulo = '' then Fy := Sy + Length( Opcoes ) + 3 else Fy := Sy + Length( Opcoes ) + 4;
	Curs := Low( Opcoes );
		
	Janela( Sx, Sy, Fx, Fy, titulo );

	if titulo = '' then Window( Sx + 2, Sy + 2, Fx - 2 , Fy - 1) else Window( Sx + 2, Sy + 3, Fx - 2 , Fy - 1);

	repeat
		clrscr;
		for i:= Low( Opcoes ) to High( Opcoes ) do
		begin
			if Curs = i then Write( '[x] ' ) else Write( '[ ] ' );
			Writeln( Opcoes[i] );
		end;

		chr:=ReadKey;
		case chr of
			#0 : 
			begin
				chr := ReadKey;
				case chr of
					#72 : if Curs > Low( Opcoes ) then Dec(Curs) else Curs := High( Opcoes );//cima
					#80 : if Curs < High( Opcoes ) then Inc(Curs) else Curs := Low( Opcoes );//baixo
				end;
			end;
		end;
	until chr = #13;
	
	Menu := Curs;
end;

{
	Atualiza o estado do jogo graficamente.
}
Procedure Imprime();
var x, y : byte;
begin
	Window( 35, 3, 44, 22 );
	clrscr;
	Window( 35, 3, 44, 23 );
	for y := 1 to 20 do
		for x:= 1 to 10 do
			if Matriz[x,y,1] <> 0 then
			begin
				GotoXY( x, ( 21 - y ));
				TextColor( Matriz[x,y,2] );
				write( chr(254) );
			end;
			
	TextBackground( BGC );
	TextColor( TC );
end;

{
	Atualiza a próxima peça.
}
Procedure ImprimeProxima();
var x, y : byte;
begin
	Window( 23, 9, 26, 12 );
	clrscr;
	Window( 23, 9, 26, 13 );

	for y := 1 to 4 do
		for x:= 1 to 4 do
			if Next[x,y,1] = 2 then
			begin
				GotoXY( x, y );
				TextColor( Next[x,y,2] );
				write( chr(254) );
			end;

	TextBackground( BGC );
	TextColor( TC );
end;

{
	Atualiza o valor da Pontuação.
}
Procedure ImprimePontos( Pontos : integer );
begin
		Inc( Pontuacao, Pontos );
		Window( 1, 1, 80, 25 );
		Window( 52, 10, 60, 11 );
		clrscr;
		Write( Pontuacao );
end;

{
	Atualiza o valor do Nivel.
}
Procedure ImprimeNivel();
begin
		Window( 1, 1, 80, 25 );
		Window( 52, 20, 60, 21 );
		clrscr;
		Write( Nivel );
end;

{//////////////////////////////////////////////
///					Engine					///
///////////////////////////////////////////////}
{
	Vasculha o array de coordenadas, buscando por blocos do tipo 2 e delimitando-os no
	Retângulo formado pelos pontos (Sx, Sy), (Sx, Fy), (Fx, Fy) e (Fx, Sy).
	Parâmetros:
	Sx, Sy : Inicio
	Fx, Fy : Fim
}
function EncontraPeca( var Xs, Xf, Ys, Yf : byte ) : boolean;
var x, y : byte;
	VarSet : boolean;
begin
	Xs := 0;
	Xf := 0;
	Ys := 0;
	Yf := 0;
	VarSet := false;

	for y := 1 to 25 do
		for x:= 1 to 10 do
			if Matriz[x,y,1] = 2 then
			begin
				if not VarSet then
				begin
					Xs := x;
					Xf := x;
					Ys := y;
					Yf := y;
					VarSet := true;
				end
				else
				begin
					if x < Xs then Xs := x;
					if x > Xf then Xf := x;
					if y < Ys then Ys := y;
					if y > Yf then Yf := y;
				end;
			end;
	EncontraPeca := VarSet;
end;

{
	Calcula o bloco a partir dos pontos, calcula sua rotação no sentido horário,
	checa por colisões, calcula uma saída e imprime	o bloco rotacionado.
}
Procedure RotacionaMatriz;
var Xs, Xf, Ys, Yf, x, y, i, j, AuxCor : byte; 
	MatRot	: array of array of array[1..2] of byte;	
	Colisao : boolean;
begin
	if EncontraPeca( Xs, Xf, Ys, Yf ) then
	begin
		SetLength( MatRot, (Xf - Xs) + 1, (Yf - Ys) + 1 );
		j := 0;
		for y:= Ys to Yf do
		begin
			i:=0;
			for x:= Xs to Xf do
			begin
				MatRot[ i, j ] := Matriz[ x, y ];
				if Matriz[ x, y, 1 ] = 2 then Matriz[ x, y, 1 ] := 0;
				inc( i );
			end;
			inc( j );
		end;

		repeat
			Colisao := false;
			i:=0;
			While ( i <= high( MatRot ) ) and not Colisao do
			begin
				j:=0;
				While ( j <= high( MatRot[0] ) ) and not Colisao do
				begin
					Colisao := (( Matriz[ Xs + j, Ys - i, 1 ] = 1 ) or ( Xs + j > 10 ) or ( Ys - i < 1 )  ) and ( MatRot[i,j,1] = 2 );

					Inc( j );
				end;
				Inc( i );
			end;
			
			if Colisao then if Xs < 5 then Inc( Xs ) else if Xs > 5 then Dec( Xs ) else Inc( Ys );
		 until not Colisao;	

		 for i:= 0 to high( MatRot ) do
				for j:= 0 to high( MatRot[0] ) do
					Matriz[ Xs + j, Ys - i ] := MatRot[i,j];
	end;
end;

{
	Calcula se houve colisão do bloco no sentido passado por parâmetros.
	Parâmetros:
	ModX : Checa por colisões no eixo X (a esquerda (-) e a direita (+) do bloco ) 
	ModY : Checa por colisões no eixo Y (abaixo (-) e acima (+) do bloco )
}
Function Colisao( ModX, ModY : smallint ) : boolean;
var Col : boolean;
var x, y : byte;
begin
	Col := false;
	y := 1;
	
	while ( y <= 25 ) and not Col do
	begin
		x := 1;
		while ( x <= 10 ) and not Col do
		begin
			if Matriz[x,y,1] = 2 then
				if ModY = 0 then
					Col := ( ( Matriz[x + ModX, y + ModY, 1] = 1 ) or not ( ( x + ModX ) in [1..10] ))
				else
					Col := ( Matriz[x + ModX, y + ModY, 1] = 1 ) or ( y = 1 );
			
			Inc(x);
		end;
		Inc(y);
	end;
	
	Colisao := Col;
end;

{
	Escolhe aleatoriamente uma nova peça do array de peças.
}
procedure Proxima;
Begin
	Randomize;
	Next := Pecas[Random(7)];
End;
    
{
	Insere a peça armazenada na matriz Next no topo da área de jogo.
}
procedure TrocaPeca;
var x,y: byte;
Begin
	For y:=1 to 4 do
		For x:=1 to 4 do
				Matriz[3+x,24-y]:=Next[x,y];

	Proxima;
	ImprimeProxima;
End;

{
	Realiza as transformações na matriz do jogo, incluindo a eliminação
	de linhas completas e a transformação de blocos móveis em blocos 
	estáticos, além de calcular a pontuação baseado no número de linhas
	completadas de uma só vez.
}
Procedure Transforma;
var x, y, k, Linhas		: byte;
	cheia				: boolean;
	Pontos 				: integer;

Begin
	Pontos := 1;
	Linhas:= 0;
	
	For y:=20 downto 1 do
	begin
		cheia:=true;
		For x:=1 to 10 do
		begin
			case Matriz[x,y,1] of
				0 : cheia:=false;
				2 :
				begin
					Matriz[x,y,1] := 1;
					Fim := y >= 19;
				end;
			end;
		end;
		
		if cheia then
		begin
			for k:= y to 20 do
				For x:=1 to 10 do
					Matriz[x, k] := Matriz[x, k + 1];
			
			Inc( Linhas );
		end;
	end;

	if Linhas > 0 then
	begin
		for k:= Linhas downto 1 do Pontos := Pontos * k;

		Pontos := Pontos * 50;
		
		ImprimePontos( Pontos );
		
		Nivel := Pontuacao div 2500;
		if Nivel < 0 then Nivel := 0 else if Nivel > 25 then Nivel := 25;
	end;
	
	TrocaPeca;
End;

{
	Move o bloco para a esquerda.
}
Procedure MoveEsq;
var x, y : byte;
begin
	if not Colisao( -1, 0 ) then
	for y := 1 to 25 do
		for x:= 1 to 10 do
			if ( Matriz[x,y,1] = 2 ) and ( Matriz[x - 1,y,1] = 0 ) and ( x > 1 ) then
			begin
				Matriz[x - 1, y ,1] := 2;
				Matriz[x - 1, y ,2] := Matriz[x, y , 2];
				Matriz[x, y ,1] := 0;
				Matriz[x, y ,2] := 0;
			end;
end;

{
	Move o bloco para a direita.
}
Procedure MoveDir;
var x, y : byte;
begin
	if not Colisao( 1, 0 ) then
	for y := 1 to 25 do
		for x:= 10 downto 1 do
			if ( Matriz[x,y,1] = 2 ) and ( x < 10 ) then
			begin
				Matriz[x + 1, y ,1] := 2;
				Matriz[x + 1, y ,2] := Matriz[x, y , 2];
				Matriz[x, y ,1] := 0;
				Matriz[x, y ,2] := 0;
			end;
end;

{
	Move o bloco para baixo.
}
Procedure MoveBaixo;
var x, y : byte;
begin
	if Colisao( 0, -1 ) then
		Transforma
	else
		for y := 1 to 25 do
			for x:= 1 to 10 do
				if Matriz[x,y,1] = 2 then
				begin
					Matriz[x, y - 1 ,1] := 2;
					Matriz[x, y - 1 ,2] := Matriz[x, y , 2];
					Matriz[x, y ,1] := 0;
					Matriz[x, y ,2] := 0;
				end
end;

{
	Programa principal do jogo, estabelece as ações e reações.
}
Procedure StartGame;
var Contador : byte;
begin
		Configuracao;

		Window( 1, 1, 80, 25 );
		ClrScr;

		JanelaNivel;
		JanelaPontuacao;
		JanelaProximo;
		JanelaJogo;
		
		Proxima;
		TrocaPeca;

		repeat
			delay( 20 );
			Inc(Contador);
			
			if ( Contador  >= ( 25 - Nivel ) ) then
			begin
				MoveBaixo;
				Contador := 0;
				Imprime();		
			end;
			
			if KeyPressed then
			begin
				case Readkey of
					#0: case (readkey) of
							#72 : RotacionaMatriz; 	// Cima
							#77 : MoveDir; 			// Direita
							#75 : MoveEsq;			// Esquerda
							#80 : MoveBaixo; 		// Baixo
						end;
					#27: Fim := true;				// Esc
				end;
				Imprime();
			end;
		until Fim;
		
		JanelaFim();
end;

{
	Tela de inicio.
}
Procedure TelaInicial;
var MenuInicio 	: array of string;
	Opcao		: byte;
begin
		TextBackground( BGC );
		TextColor( TC );
		cursoroff;

		Repeat
			Header;
			
			SetLength( MenuInicio, 3 );
			MenuInicio[0] := 'Iniciar';
			MenuInicio[1] := 'Ajuda';
			MenuInicio[2] := 'Sair';
			
			Opcao := Menu( MenuInicio, 32, 13, '');
			
			case Opcao of 
				0 : StartGame;
				1 : Ajuda;
			end;
		until Opcao = 2;
end;
{
	Corpo do programa.
}
begin
	Telainicial;
end.