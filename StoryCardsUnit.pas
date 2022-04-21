unit StoryCardsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.StdCtrls;

type
  TfoStoryCards = class(TForm)
    SpeedButton1: TSpeedButton;
    imDice01: TImage;
    imDice02: TImage;
    imDice03: TImage;
    imDice04: TImage;
    imDice05: TImage;
    imDice06: TImage;
    imDice07: TImage;
    imDice08: TImage;
    imDice00: TImage;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure RollDice(diceNum: integer);
    procedure tiControlTimer(Sender: TObject);
    procedure tiShuffleTimer(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure readStringLists();
    procedure resetScreen();

    function  fillStringList(thisPath: string; thisStringList: Tstringlist): Tstringlist;
    function  getRandomNumber(): integer;
    function  Right(myString: string; getLength: integer): string;
    procedure imDice01Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  foStoryCards: TfoStoryCards;

  slDice00: Tstringlist;
  slDice01: Tstringlist;
  slDice02: Tstringlist;
  slDice03: Tstringlist;
  slDice04: Tstringlist;
  slDice05: Tstringlist;
  slDice06: Tstringlist;
  slDice07: Tstringlist;
  slDice08: Tstringlist;
  slHistory: Tstringlist;
  tiShuffle: array[0..8] of tTimer;
  tiControl: array[0..8] of tTimer;
  startDir: string;

implementation

{$R *.dfm}


procedure TfoStoryCards.FormActivate(Sender: TObject);
var
  T: integer;
begin
   startDir := getCurrentDir();

   RadioGroup1.ItemIndex := 0;
   setCurrentDir( '.\basic\');

   readStringLists();

   for T := 0 to 8 do begin
      tiShuffle[T] := tTimer.Create(self);
      tiControl[T] := tTimer.Create(self);
      tiShuffle[T].Enabled := false;
      tiControl[T].Enabled := false;
      tiShuffle[T].Name := 'tiShuffle_' + Format('%.*d',[2, T]);
      tiControl[T].Name := 'tiControl_' + Format('%.*d',[2, T]);
      tiShuffle[T].OnTimer := tiShuffleTimer;
      tiControl[T].OnTimer := tiControlTimer;
   end;

end;

procedure TfoStoryCards.FormClick(Sender: TObject);
var
  pt : tPoint;
begin
  pt := ScreenToClient(Mouse.CursorPos);

  if ((pt.x >= 60) and (pt.x <= 243) and (pt.y >= 10) and(pt.y <= 193))  then imDice01.Visible := true;
  if ((pt.x >= 60) and (pt.x <= 243) and (pt.y >= 210) and(pt.y <= 393)) then imDice04.Visible := true;
  if ((pt.x >= 60) and (pt.x <= 243) and (pt.y >= 410) and(pt.y <= 593)) then imDice07.Visible := true;

  if ((pt.x >= 260) and (pt.x <= 443) and (pt.y >= 10) and(pt.y <= 193))  then imDice02.Visible := true;
  if ((pt.x >= 260) and (pt.x <= 443) and (pt.y >= 210) and(pt.y <= 393)) then imDice05.Visible := true;
  if ((pt.x >= 260) and (pt.x <= 443) and (pt.y >= 410) and(pt.y <= 593)) then imDice08.Visible := true;

  if ((pt.x >= 460) and (pt.x <= 643) and (pt.y >= 10) and(pt.y <= 193))  then imDice03.Visible := true;
  if ((pt.x >= 460) and (pt.x <= 643) and (pt.y >= 210) and(pt.y <= 393)) then imDice06.Visible := true;
  if ((pt.x >= 460) and (pt.x <= 643) and (pt.y >= 410) and(pt.y <= 593)) then imDice00.Visible := true;
end;

procedure TfoStoryCards.SpeedButton1Click(Sender: TObject);
var
  T: integer;
begin
   resetScreen();
   for T := 0 to 8 do begin
      tiShuffle[T].Interval := 40;
      ticontrol[T].Interval := getRandomNumber()  * 300 + 500;
      tiShuffle[T].Enabled := true;
      tiControl[T].Enabled := true;
   end;
   foStoryCards.Caption := 'Dice set: ' + RadioGroup1.Items[RadioGroup1.itemIndex];
end;

procedure TfoStoryCards.tiControlTimer(Sender: TObject);
var
  T: integer;
begin
   with (Sender as tTimer) do begin
      Enabled := false;
      T := StrToInt(Right(Name, 2));
      tiShuffle[T].Enabled := false;
   end;
end;

procedure TfoStoryCards.tiShuffleTimer(Sender: TObject);
var
  diceNum: integer;
begin
   with (Sender as tTimer) do begin
     diceNum := StrToInt(Right(Name, 2));
     RollDice(diceNum);
   end;
end;

function TfoStoryCards.fillStringList(thisPath: string; thisStringList: Tstringlist): Tstringlist;
var
  SR      : TSearchRec;
begin
  thisStringList := TStringList.Create;

  if FindFirst(thisPath + '*.png', faArchive, SR) = 0 then begin
    repeat
        thisStringList.Add(thisPath + SR.Name); //Fill the list
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;

  Result := thisStringList;
end;

function TfoStoryCards.getRandomNumber(): integer;
begin
  Randomize;
  Result := Random(6);
end;

procedure TfoStoryCards.imDice01Click(Sender: TObject);
begin
  if (foStoryCards.Caption <> 'StoryCards') then (Sender as TImage).visible := false
end;

procedure TfoStoryCards.RadioGroup1Click(Sender: TObject);
begin
  if (RadioGroup1.ItemIndex = 0) then begin
    setCurrentDir(startDir + '\basic\');
    resetScreen();
    readStringLists();
  end else begin
    setCurrentDir(startDir + '\actions\');
    resetScreen();
    readStringLists();
  end;
end;

function TfoStoryCards.Right(myString: string; getLength: integer): string;
begin
  Result := Copy(myString, length(myString) - (getLength - 1), getLength);
end;


procedure TfoStoryCards.RollDice(diceNum: integer);
begin
  case diceNum of
      0: imDice00.Picture.LoadFromFile(slDice00[getRandomNumber]);
      1: imDice01.Picture.LoadFromFile(slDice01[getRandomNumber]);
      2: imDice02.Picture.LoadFromFile(slDice02[getRandomNumber]);
      3: imDice03.Picture.LoadFromFile(slDice03[getRandomNumber]);
      4: imDice04.Picture.LoadFromFile(slDice04[getRandomNumber]);
      5: imDice05.Picture.LoadFromFile(slDice05[getRandomNumber]);
      6: imDice06.Picture.LoadFromFile(slDice06[getRandomNumber]);
      7: imDice07.Picture.LoadFromFile(slDice07[getRandomNumber]);
      8: imDice08.Picture.LoadFromFile(slDice08[getRandomNumber]);
  end;
end;

procedure TfoStoryCards.readStringLists();
begin
   slDice00 := fillStringList('.\dice00\', slDice00);
   slDice01 := fillStringList('.\dice01\', slDice01);
   slDice02 := fillStringList('.\Dice02\', slDice02);
   slDice03 := fillStringList('.\Dice03\', slDice03);
   slDice04 := fillStringList('.\Dice04\', slDice04);
   slDice05 := fillStringList('.\Dice05\', slDice05);
   slDice06 := fillStringList('.\Dice06\', slDice06);
   slDice07 := fillStringList('.\Dice07\', slDice07);
   slDice08 := fillStringList('.\Dice08\', slDice08);
end;

procedure TfoStoryCards.resetScreen();
var
  thisPic: string;
begin
    thisPic := '..\dice\dobbelsteen.png';
    imDice00.Picture.LoadFromFile(thisPic);
    imDice01.Picture.LoadFromFile(thisPic);
    imDice02.Picture.LoadFromFile(thisPic);
    imDice03.Picture.LoadFromFile(thisPic);
    imDice04.Picture.LoadFromFile(thisPic);
    imDice05.Picture.LoadFromFile(thisPic);
    imDice06.Picture.LoadFromFile(thisPic);
    imDice07.Picture.LoadFromFile(thisPic);
    imDice08.Picture.LoadFromFile(thisPic);

    imDice00.visible := true;
    imDice01.visible := true;
    imDice02.visible := true;
    imDice03.visible := true;
    imDice04.visible := true;
    imDice05.visible := true;
    imDice06.visible := true;
    imDice07.visible := true;
    imDice08.visible := true;
    foStoryCards.Caption := 'StoryCards';
end;


end.
