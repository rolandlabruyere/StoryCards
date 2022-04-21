program Storycard;

uses
  Vcl.Forms,
  StoryCardsUnit in 'StoryCardsUnit.pas' {foStoryCards};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfoStoryCards, foStoryCards);
  Application.Run;
end.
