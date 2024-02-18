## Kolokwia Kuchta:

### Laby 6

#### Gr. B

##### Podgrupa 1:

- Zadanie 1: Policz adres fizyczny, (Podany jest segment oraz offset)
- Zadanie 2: Wpisz offset (podany w ax) do offset wektora nr 8.
- Zadanie 3: Napisz binarnie atrybut znaku tak aby uzyskać jasnoczerwony na brązowym tle.

##### Podgrupa 2:

- Zamiana kolejności zadań (najprawodpodobniej) oraz inny kolor.

### Laby 5

#### Gr. A

##### Podgrupa 1:

- Zadanie 1: Podaj wartości rejestrow koprocesora po poniższych operacjach:

  - Fld dword ptr dwa
  - Fld dword ptr trzy
  - Fsub st(0), st(1)

- Zadanie 2: Podaj rozkaz, który porówna dwa rejestry na koprocesorze i przepisze na znaczniki procesora (FCOMI).

##### Podgrupa 2:

- Zadanie 1: Podaj wartości rejestrow koprocesora po poniższych operacjach:

  - Fld dword ptr dwa
  - Fld dword ptr trzy
  - Fsubr st(0), st(1)

- Zadanie 2: Podaj rozkaz, który porówna dwa rejestry na koprocesorze i przepisze na znaczniki procesora (FCOMI).

#### Gr. B

##### Podgrupa 1:

- Zadanie 1: Wykonano rozkazy:

  - Fld dword ptr dwa
  - Fld dword ptr trzy
  - Fmul st(0), st(1)

  Podaj co będzie w rejestrach st(0)-st(7) (w tych, w których wiadomo, co będzie).

- Zadanie 2: W jaki sposób przekazywane są argumenty zmiennoprzecinkowe do funkcji.

##### Podgrupa 2:

- Zadanie 1: Wykonano rozkazy:

  - Fld dword ptr dwa
  - Fld dword ptr trzy
  - Fmul

  Podaj co będzie w rejestrach st(0)-st(7) (w tych, w których wiadomo, co będzie).
  (Pamiętać, że st(7) będzie miało wartość z st(0))

- Zadanie 2: Jak są zwracane wyniki zmiennoprzecinkowe w trybie 32 bitowym.

### Laby 4

#### Gr. A i Gr. B

##### Podgrupa 1:

- Zadanie 1:
  Względem esp narysować ramkę stosu z adresami. Wartość esp w poleceniu to wartość po wykonaniu (oczywiście).
  Funkcja w C: `int sum(int a, int b, int c)`
  Call + adres zajmują 5 bajtów.

- Zadanie 2:
  Ile należy dodać do esp po wykonaniu funkcji w stdcall.

##### Podgrupa 2:

- Zadanie 1:
  Względem esp narysować ramkę stosu z adresami.
  Funkcja w stdcall: `int sum(int a, int b, int c)`
  Call + adres zajmują 5 bajtów.

- Zadanie 2:
  Jak zwracany jest 64-bitowy wynik w trybie 32-bitowym.
