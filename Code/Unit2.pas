unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Math, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus,
  Vcl.Imaging.jpeg, System.ImageList, Vcl.ImgList, Vcl.Buttons, Data.DB,
  Data.Win.ADODB, ShellAPI, Vcl.ExtDlgs;

type
  Tform_homepage = class(TForm)
    rightBorderImg: TImage;
    leftBorderImg: TImage;
    homepage_menuBar: TMainMenu;
    Homepage2: TMenuItem;
    Exit1: TMenuItem;
    buttonIcons_ImgList: TImageList;
    likeDeign_btn: TBitBtn;
    dislikeDesign_btm: TBitBtn;
    newDesign_btn: TBitBtn;
    BitBtn1: TBitBtn;
    hennaDesign_canvas: TImage;
    ADO_hennaDatabase: TADOConnection;
    ADT_elements: TADOTable;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    SavePictureDialog1: TSavePictureDialog;
    ADO_QueryUpdate: TADOQuery;
    ADT_templates: TADOTable;
    ADO_QueryTemplates: TADOQuery;
    ADT_Style_preferances: TADOTable;
    ResetPreferances1: TMenuItem;
    ApplicationManual1: TMenuItem;
    HennaApplicationGuide1: TMenuItem;
    ADOConnection1: TADOConnection;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CircleClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure APICall_buttonClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure likeDeign_btnClick(Sender: TObject);
    procedure dislikeDesign_btmClick(Sender: TObject);
    procedure newDesign_btnClick(Sender: TObject);
    procedure makeNewLabels();
    procedure createButtons();
    procedure Exit1Click(Sender: TObject);
    procedure ResetPreferances1Click(Sender: TObject);
    procedure template3_btnClick(Sender: TObject);
    procedure ApplicationManual1Click(Sender: TObject);
    procedure HennaApplicationGuide1Click(Sender: TObject);
  private
    { Private declarations }
     procedure youtubeAPI(Sender : TObject);
  public
    { Public declarations }

  end;

Type
 TCooridantes = record
     xCord : real ;
     yCord : real;
   end;
 TCooridantesBlock = record
     topLeft : TCooridantes ;
     topRight : TCooridantes ;
     bottomLeft : TCooridantes ;
     bottomRight: TCooridantes;
   end;
  TLinkedListItem = record
     item : string ;
     pointer : integer;
   end;
   TElementsDisplay = record
     labels : TLabel ;
     button : TButton ;
     image : TImage ;
   end;



var
  form_homepage: Tform_homepage;
  //deafult form variables
  bodyTextColour,defaultColour, deafultPenColour: TColor;
  defaultBrushStyle : TBrushStyle;
  defaultPenStyle : TPenStyle;
  //coordiantes
  handCentre : TCooridantes;
  wristMaxPoints, fingerMaxPoints, thumbMaxPoints : TCooridantesBlock;
  //dislay elements
  elementsLabels : array[0..30] of TLabel ;
  elementsLl : array[0..30] of TLinkedListItem ;
  elementsLlSp: integer;
  elementsTop,test : Integer;
  dispalyArray : array[0..30] of TElementsDisplay ;
  //templates
  tempIndex : integer ;
  currentTemplate : integer;
  templates : array [1..100] of Tprocedure;
implementation

{$R *.dfm}

uses Unit1;

//Display elements

procedure Tform_homepage.makeNewLabels(); //Dynamically creates new labels
var
i,j : integer;
begin
j := 0;
for i := 0 to 30 do
  begin
       dispalyArray[i].labels := TLabel.Create(self);
      dispalyArray[i].labels.Parent := self;
       dispalyArray[i].labels.Top := 100 + j;
       dispalyArray[i].labels.Left := 2000;
       dispalyArray[i].labels.Cursor := crHandPoint ;
      j := 50 + j;
  end;
end;

procedure Tform_homepage.createButtons();  //Dynamically creates new buttons
var
i,j: integer;
begin
  j := 0;
  for i := 0 to 30 do
  begin
    dispalyArray[i].button.Free;
  end;

  for i := 0 to 30 do
    begin
      dispalyArray[i].button := TButton.Create(Self);
      with    dispalyArray[i].button DO
      begin
      Visible := true;
      Caption :=  dispalyArray[i].labels.Caption;
      Parent := Self;
      Height := 23;
      Width := 23;
      Left := 2200;
      Top := 100 + j;
      if dispalyArray[i].labels.Caption <> '' then
       begin
        tempIndex := i;
        OnClick := youtubeAPI;
       end
      else
      begin
        visible := false;
      end;
      j := 50 + j;
    end;
  end;
end;



procedure populateElementLabels(); //Dynamically fills in the labels captions
var
index,i,j,p, splitIndex: Integer;
tempString1, tempString2 : string ;
begin
  i := 0;
  p := elementsLlSp;
  while p <> -1 do  //linked list traversal
  begin
  for index := 1 to (elementsLl[p].item.Length) do  //gets item in correct format
    begin
     if elementsLl[p].item[index] = upperCase(elementsLl[p].item[index]) then
      begin
        splitIndex :=  index;
      end ;
    end;
  tempString1 :=  elementsLl[p].item.Substring(1,splitIndex-2) ;
  tempString2 :=  elementsLl[p].item.Substring(splitIndex-1,elementsLl[p].item.Length-1) ;
  dispalyArray[i].labels.Caption :=  upperCase( elementsLl[p].item[1]) + tempString1 + ' ' + tempString2  ;
  p := elementsLl[p].pointer ; //item which current one points to
  i := i + 1;
  end;
  while i<=30 do //rest of labels are made 'invisible'
  begin
    dispalyArray[i].labels.Caption := '';
    i := i +1;
  end;
end;

//Canvas

procedure clearCanvas();

Var
bitmap : TBitmap;
  i:  Integer;
begin
  //Loads hand template into canvas
  bitmap := TBitmap.Create;
  try
   Bitmap.LoadFromFile('handOutlineV5.bmp');
   form_homepage.hennaDesign_canvas.canvas.Brush.Bitmap := Bitmap;
   form_homepage.hennaDesign_canvas.canvas.FillRect(Rect(0,0,1000,1000));
  finally
    form_LoadScreen.Canvas.Brush.Bitmap := nil;
    Bitmap.Free;
  end;
end;

//New design specific

procedure resetVariables();
Var
index: integer;
begin //sets deafult values for LL
  elementsLlSp:= -1;
  elementsTop := -1;
  for index := 0 to 30 do
  begin
    elementsLl[index].pointer :=-1;
    elementsLl[index].item := '';
  end;
end;

procedure pickTemplate();
var
i, j,cummalativeWeighting, randomNumb,upperLimit, style : integer ;
styleInfo : array[1..3,0..2] of integer ;
numbFound, templateFound : bool;
styleName : string;
begin
  cummalativeWeighting := 0;
  with form_homepage.ADT_Style_preferances do
   begin
      open;
      for i:=1 to 3 do   //populates array with styles and their data ranges
      begin
      recno:=i;
      styleInfo[i,0] := i;
      styleInfo[i,1] := cummalativeWeighting + 1;
      cummalativeWeighting := cummalativeWeighting +  fieldvalues['User_Weighting'] ;
      styleInfo[i,2] := cummalativeWeighting;
      end;
     end;
   randomNumb := RandomRange(1,cummalativeWeighting) ;
   numbFound := false;
   j := 0;
   while numbFound = false do
   begin
     j := j + 1;
    upperLimit := styleInfo[j,2];
     if (upperLimit >= randomNumb)  then
     begin
      style := j;
      numbFound := true;
     end;
   end;
   with form_homepage.ADT_Style_preferances do  //selects a style
     begin
       open;
       recno:=style;
       styleName := fieldvalues['Category'] + ' Weight';
     end;
    templateFound := false;
   with form_homepage.ADT_templates do
     begin
     open;
      while templateFound = false do //repeats until template picked has picked style
      begin
       randomNumb := RandomRange(1, recordcount) ;
       recno:=randomNumb;
       if fieldvalues[styleName] = true then
       begin
        templateFound := true;
       end;
      end;
     end;
   currentTemplate := randomNumb;
end;





//Reccomedation

procedure changeElementWeighting(dampaningFactor:string);
 var
currentElement : string ;  //element weight changed according to dampening factor
i : integer ;
begin
for i := 0 to 30 do
begin
 currentElement := elementsLl[i].item;
 with form_homepage.ADO_QueryUpdate do
 begin
   Active:=False;
   SQL.Clear;
   SQL.Add('UPDATE Elements');
   SQL.Add('SET UserRating = (UserRating*'+ dampaningFactor +') WHERE ElementName = "' + currentElement + '"');
   ExecSQL ;
 end;
 form_homepage.ADT_Elements.open;
 form_homepage.ADT_Elements.Refresh;
end;
end;



procedure changeStyleWeighting(dampaningFactor:string);
var     //style weight changed according to dampening factor
i : integer;
SA,NA,ME : bool;
begin
   with form_homepage.ADT_Templates do
   begin
      open;
      for i:=1 to recordcount do    //checks what styles the template is
      begin
          recno:=i;
          if fieldvalues['TemplatesID'] = currentTemplate then
          begin
             SA :=  FieldValues['South Asian Weight'];
             NA := FieldValues['North African Weight'];
             ME :=  FieldValues['Middle Eastern Weight'];
          end;
      end;
   end;

   begin
   with form_homepage.ADO_QueryTemplates do  //for all styles used in template dampaning factor applied
   begin
     Active:=False;
     if SA = true then
     begin
       SQL.Clear;
       SQL.Add('UPDATE Style_Preferance');
       SQL.Add('SET User_Weighting = (User_Weighting*'+ dampaningFactor +') WHERE Category = "South Asian";');
       ExecSQL ;
     end;
     if NA = true then
     begin
       SQL.Clear;
       SQL.Add('UPDATE Style_Preferance');
       SQL.Add('SET User_Weighting = (User_Weighting*'+ dampaningFactor +') WHERE Category = "North African";');
       ExecSQL ;
     end;
     if ME = true then
     begin
       SQL.Clear;
       SQL.Add('UPDATE Style_Preferance');
       SQL.Add('SET User_Weighting = (User_Weighting*'+ dampaningFactor +') WHERE Category = "Middle Eastern";');
       ExecSQL ;
     end;
     end;
     form_homepage.ADT_Style_preferances.open;
     form_homepage.ADT_Style_preferances.Refresh;
   end;


end;

procedure Tform_homepage.dislikeDesign_btmClick(Sender: TObject);
begin //weightings decreased
  changeElementWeighting('0.9');
  changeStyleWeighting('0.9') ;
end;

procedure Tform_homepage.likeDeign_btnClick(Sender: TObject);
begin //weightings increased
changeElementWeighting('1.1');
changeStyleWeighting('1.1') ;
end;

//YouTube tutorials

procedure Tform_homepage.youtubeAPI(Sender : TObject);
begin
  with (Sender as TButton) do
  shellexecute(Application.Handle,'open',PChar('https://www.youtube.com/results?search_query=henna+tutorial+' + caption ),nil,nil,0);
end;

procedure Tform_homepage.APICall_buttonClick(Sender: TObject);
var
tempString,test : string;
tempPWide,test2 : PWideChar;
temp3 : wideString ;
begin
 temp3 := 'https://www.youtube.com/results?search_query=henna+henna+tutorial' + dispalyArray[tempIndex].labels.Caption ;
 shellexecute(Application.Handle,'open',PChar('https://www.youtube.com/results?search_query=henna+henna+tutorial' ),nil,nil,0);
 end;


//Linked list
procedure addToLinkedList(item:string;var linkedList:array of TLinkedListItem;var lastIndexUsed : integer; var SP : integer);  //passed by var as value needs to be changed
var //adds an item to a specifed linked list
tempIndex,p : integer;
placeFound, addItem : boolean;
begin
  if SP = -1 then //if list is empty added to beggining
    begin
     lastIndexUsed := lastIndexUsed +1;
     linkedList[lastIndexUsed].item := item;
     SP := lastIndexUsed;
     linkedList[lastIndexUsed].pointer := -1;
    end
  else if linkedList[SP].item = item then   //if item is same as SP item do not add
    begin
     addItem := false;
    end
  else if linkedList[SP].item > item then  //if item is bigger than SP item add at start of LL
    begin
     lastIndexUsed := lastIndexUsed +1;
     linkedList[lastIndexUsed].item := item;
     tempIndex := SP;
     SP := lastIndexUsed;
     linkedList[lastIndexUsed].pointer := tempIndex;
    end
  else
    begin
    placeFound := false;
    addItem := true;
    p := SP ;

    while (placeFound = false) AND (linkedList[p].pointer <> -1) AND(addItem = true)  do
      begin  //loop through till item duplicate founds, place is found or at end of LL
       if item = linkedList[linkedList[p].pointer].item then
         begin
           addItem := false;       //duplicate found then do not add item to LL
         end
       else if item > linkedList[linkedList[p].pointer].item then
         begin
           p := linkedList[p].pointer; //If item is bigger than current one move onto next item
         end
       else
        begin
          placeFound := true; //otherwise we have found our Ll place to add item
        end;
      end;
    if addItem = true then  //add item if no duplicate
     begin
         lastIndexUsed := lastIndexUsed +1;
         linkedList[lastIndexUsed].item := item;
         tempIndex := linkedList[p].pointer;
         linkedList[p].pointer := lastIndexUsed;
         linkedList[lastIndexUsed].pointer  := tempIndex;
     end;


    end;


end;

procedure clearLinkedList(length : integer; var LL : array of TLinkedListItem);
var index : integer;
begin  //reset Ll to original values
elementsLlSP := -1;
for index := 0 to length do
begin
  elementsLl[index].pointer :=-1;
  elementsLl[index].item := '' ;
end;
end;

//the following procedure can be used to find the API query for a paticular item
//procedure queryLLItems();
//var
//i,p : integer;
//begin
//with form_homepage.adt_elements do
//  begin
//    open ;
//    p := elementsLlSp;
//    while p <> -1 do
//      begin
//      for i := 1 to recordcount do
//       begin
//        recno := i;
//        if fieldvalues['ElementName'] = elementsLl[p].item then
//          begin
//          //form2.label2.Caption:= form2.label2.Caption + fieldvalues['APIquery'];
//          end;
//       end;
//       p := elementsLl[p].pointer;
//      end;
//    end;
//end;


//randomisations
function toDraw(): bool ;  //decides whether or not to draw an elements
begin
  if  random(2) =1 then
  begin
    toDraw := True ;
  end
  else
  begin
      toDraw := false ;
  end;
end;


function choosePenStyle(clearAllowed : bool): TPenStyle;
var  //Picks a random pen style
numStyles,p, pInterval : integer;
test : string;
selectedStyle : TPenStyle;
begin
  if clearAllowed = true then
    begin
    p :=  1 + Random(6);
    end
  else
    begin
     p :=  1 + Random(5);
    end;

  case p of
     1 : selectedStyle := psSolid;
     2 : selectedStyle := psDash;
     3 : selectedStyle := psDot;
     4 : selectedStyle := psDashDot;
     5 : selectedStyle := psDashDotDot;
     6 : selectedStyle := psClear;
  end ;

  if selectedStyle = psSolid  then //adds style to Ll
    begin
       addToLinkedList('solidStroke',elementsLl,elementsTop,elementsLlSp);
    end
  else if selectedStyle = psDash then
    begin
       addToLinkedList('dashedStroke',elementsLl,elementsTop,elementsLlSp);
    end
  else if  selectedStyle = psDot then
    begin
       addToLinkedList('dottedStroke',elementsLl,elementsTop,elementsLlSp);
    end
  else if selectedStyle <> psClear then
    begin
        addToLinkedList('dashedStroke',elementsLl,elementsTop,elementsLlSp);
        addToLinkedList('dottedStroke',elementsLl,elementsTop,elementsLlSp);
    end;

  choosePenStyle  :=   selectedStyle;
end;

function chooseStrokeStyle: TBrushStyle;
var    //Picks a random brush style
numStyles,p, pInterval : integer;
test : string;
selectedStyle : TBrushStyle;
begin
   p :=  1 + Random(8);

case p of
   1 : selectedStyle := bsSolid;
   2 : selectedStyle := bsHorizontal;
   3 : selectedStyle := bsVertical;
   4 : selectedStyle := bsFDiagonal;
   5 : selectedStyle := bsBDiagonal;
   6 : selectedStyle := bsCross;
   7 : selectedStyle := bsDiagCross;
   8 : selectedStyle := bsClear;
end ;

if selectedStyle = bsSolid  then //adds style to Ll
  begin
     addToLinkedList('solidFill',elementsLl,elementsTop,elementsLlSp);
  end
else if (selectedStyle = bsCross) or (selectedStyle = bsDiagCross) then
  begin
     addToLinkedList('crisscrossFill',elementsLl,elementsTop,elementsLlSp);
  end
else if selectedStyle <> bsClear then
  begin
      addToLinkedList('lineFill',elementsLl,elementsTop,elementsLlSp);
  end;

chooseStrokeStyle  :=   selectedStyle;
  end;

//elements
procedure basicLine(x1,y1,x2,y2:integer);
begin
form_homepage.hennaDesign_canvas.Canvas.MoveTo(x1,y1); //Moves pen to start position
form_homepage.hennaDesign_canvas.canvas.lineto(x2,y2) ;//Draws line to end position
addToLinkedList('basicLine',elementsLl,elementsTop,elementsLlSp);
end;

procedure basicCircle(topLeftX,topLeftY,bottomRightX,bottomRightY:integer);
begin  //Uses inbuilt ellipse function with equal x and y distance to make a circle
form_homepage.hennaDesign_canvas.canvas.Ellipse(topLeftX,topLeftY,bottomRightX,bottomRightY);
addToLinkedList('basicCircle',elementsLl,elementsTop,elementsLlSp);
end;

procedure filledCircle(topLeftX,topLeftY,bottomRightX,bottomRightY:integer);
begin
with  form_homepage.hennaDesign_canvas.Canvas do
begin
form_homepage.hennaDesign_canvas.Canvas.Brush.Style := chooseStrokeStyle;
brush.color := defaultColour;  //changes brush colour to black so whole shape drawn is in this colour
basicCircle(topLeftX,topLeftY,bottomRightX,bottomRightY);
brush.Color := clWhite; //changes brush colour back to deafult
form_homepage.hennaDesign_canvas.Canvas.Brush.Style := defaultBrushStyle;
addToLinkedList('filledCircle',elementsLl,elementsTop,elementsLlSp);
end;
end;

procedure dashedCircle(topLeftX,topLeftY,bottomRightX,bottomRightY:integer);
var
 test : TPenStyle;
begin
with  form_homepage.hennaDesign_canvas.Canvas do
begin
pen.style := (psDot); // chnages pen style - affects how border is draw
basicCircle(topLeftX,topLeftY,bottomRightX,bottomRightY);
test := psSolid;
pen.style := (test); // changed back to deafult
end;
addToLinkedList('basicCircle',elementsLl,elementsTop,elementsLlSp);
end;


procedure circleEightPoints(topLeftX,topLeftY,bottomRightX,bottomRightY:integer; var coordinates :array of TCooridantes) ;//passed by refeerence - so changes values
var  //0 starts from the one directly above the centre, then counted clockwise
centre : TCooridantes;
radius : real;
begin
  addToLinkedList('basicCircle',elementsLl,elementsTop,elementsLlSp);
  addToLinkedList('basicLine',elementsLl,elementsTop,elementsLlSp);
 centre.xCord := (topLeftX + bottomRightX) / 2;
 centre.yCord := (topLeftY + bottomRightY ) /2;
 radius := bottomRightY - centre.yCord  ;
 coordinates[0].xCord := centre.xCord;
 coordinates[0].yCord := topLeftY;
 coordinates[1].xCord := centre.xCord + radius * cos((7*PI)/4);
 coordinates[1].yCord := centre.yCord + radius * sin((7*PI)/4);
 coordinates[2].xCord := bottomRightX ;
 coordinates[2].yCord := centre.yCord;
 coordinates[3].xCord := centre.xCord + radius * cos((1*PI)/4);
 coordinates[3].yCord := centre.yCord + radius * sin((1*PI)/4);
 coordinates[4].xCord := centre.xCord ;
 coordinates[4].yCord := bottomRightY;
 coordinates[5].xCord := centre.xCord + radius * cos((3*PI)/4);
 coordinates[5].yCord := centre.yCord + radius * sin((3*PI)/4);
 coordinates[6].xCord := topLeftX ;
 coordinates[6].yCord := centre.yCord;
 coordinates[7].xCord := centre.xCord + radius * cos((5*PI)/4);
 coordinates[7].yCord := centre.yCord + radius * sin((5*PI)/4);
end;

procedure innerReflectionCircle(topLeftX,topLeftY,bottomRightX,bottomRightY:integer) ;//passed by refeerence - so changes values
 //0 starts from the one directly above the centre, then counted clockwise
 Var
 miniCircleCenters : array[0..7] of TCooridantes;
 i, arrayHalfWay : integer;
 begin
   basicCircle(topLeftX,topLeftY,bottomRightX,bottomRightY);
   circleEightPoints(topLeftX,topLeftY,bottomRightX,bottomRightY,miniCircleCenters) ;
   arrayHalfWay := (length(miniCircleCenters)DIV 2)-1 ;
   for i := 0 to arrayHalfWay do
   begin
     basicLine(trunc(miniCircleCenters[i].xCord),trunc(miniCircleCenters[i].yCord),trunc(miniCircleCenters[i+4].xCord),trunc(miniCircleCenters[i + 4].yCord))
   end;
 addToLinkedList('basicCircle',elementsLl,elementsTop,elementsLlSp);
  addToLinkedList('basicLine',elementsLl,elementsTop,elementsLlSp);
end;

procedure miniCircleBorder(topLeftX,topLeftY,bottomRightX,bottomRightY:integer) ;//passed by refeerence - so changes values
 //0 starts from the one directly above the centre, then counted clockwise
 Var
 miniCircleCenters : array[0..7] of TCooridantes;
 i, arrayHalfWay : integer;
 centre : TCooridantes;
radius,miniRadius : real;
 begin
   centre.yCord := (topLeftY + bottomRightY ) /2;
    radius := bottomRightY - centre.yCord  ;
    miniRadius := radius/10;
   basicCircle(topLeftX,topLeftY,bottomRightX,bottomRightY);
   circleEightPoints(topLeftX,topLeftY,bottomRightX,bottomRightY,miniCircleCenters) ;
   arrayHalfWay := (length(miniCircleCenters)DIV 2)-1 ;
   for i := 0 to 7 do
   begin
     filledCircle(trunc(miniCircleCenters[i].xCord-miniRadius),trunc(miniCircleCenters[i].yCord-miniRadius),trunc(miniCircleCenters[i].xCord+miniRadius),trunc(miniCircleCenters[i].yCord+miniRadius))
   end;
addToLinkedList('basicCircle',elementsLl,elementsTop,elementsLlSp);
addToLinkedList('filledCircle',elementsLl,elementsTop,elementsLlSp);
end;


Procedure basicTriangle(x1,y1,x2,y2,x3,y3:integer);
begin //draws a basic trangle with corners x1,y1,x2,y2,x3,y3
  basicLine(x1,y1,x2,y2);
  basicLine(x1,y1,x3,y3);
  basicLine(x2,y2,x3,y3);
  addToLinkedList('basicTriangle',elementsLl,elementsTop,elementsLlSp);
end;

//templates

procedure template1(middleCord : TCooridantes); // so acutal data never changed - saftey measure
var
initalRadius,currentRadius : integer;
begin
currentTemplate := 1;
with  form_homepage.hennaDesign_canvas.Canvas do
  begin
  initalRadius  := 20;
  if toDraw() = true then  //draws the middle circle
    filledCircle(trunc(middleCord.xCord-initalRadius),trunc(middleCord.yCord-initalRadius),trunc(middleCord.xCord+initalRadius),trunc(middleCord.yCord+initalRadius));
  currentRadius := initalRadius*3;
  if toDraw() = true then  //draws the next circle
   basicCircle(trunc(middleCord.xCord-currentRadius),trunc(middleCord.yCord-currentRadius),trunc(middleCord.xCord+currentRadius),trunc(middleCord.yCord+currentRadius));
  currentRadius := initalRadius*4;
  if toDraw() = true then   //draws the next circle
    miniCircleBorder(trunc(middleCord.xCord-currentRadius),trunc(middleCord.yCord-currentRadius),trunc(middleCord.xCord+currentRadius),trunc(middleCord.yCord+currentRadius));
  currentRadius := initalRadius*5;
  if toDraw() = true then
  begin  //draws the next circle with a solis fill between the prvious one
   basicCircle(trunc(middleCord.xCord-currentRadius),trunc(middleCord.yCord-currentRadius),trunc(middleCord.xCord+currentRadius),trunc(middleCord.yCord+currentRadius));
  Brush.Style := bsSolid;
  Brush.Color := clWhite;
   FloodFill(trunc((middleCord.xCord-currentRadius)+(initalRadius*2.50)),trunc((middleCord.yCord-currentRadius)+((initalRadius)*2.5)), clWhite, fsBorder);
  Brush.Style := defaultBrushStyle;
  end;

  currentRadius := initalRadius*6;
  if toDraw() = true then
  begin     //draws the next circle
    pen.Style := choosePenStyle(false);
    basicCircle(trunc(middleCord.xCord-currentRadius),trunc(middleCord.yCord-currentRadius),trunc(middleCord.xCord+currentRadius),trunc(middleCord.yCord+currentRadius));
  end;
   pen.Style := defaultPenStyle;
  if toDraw() = true then
  begin    //fills in wrist section
    basicLine(trunc(wristMaxPoints.topLeft.xCord), trunc(wristMaxPoints.topLeft.yCord),trunc(wristMaxPoints.topRight.xCord),trunc(wristMaxPoints.topRight.yCord));
    basicLine(trunc(wristMaxPoints.bottomLeft.xCord), trunc(wristMaxPoints.bottomLeft.yCord),trunc(wristMaxPoints.bottomRight.xCord),trunc(wristMaxPoints.bottomRight.yCord));
    basicLine(trunc(wristMaxPoints.topLeft.xCord), trunc(wristMaxPoints.topLeft.yCord),trunc(wristMaxPoints.bottomLeft.xCord), trunc(wristMaxPoints.bottomLeft.yCord));
    basicLine(trunc(wristMaxPoints.topRight.xCord), trunc(wristMaxPoints.topRight.yCord),trunc(wristMaxPoints.bottomRight.xCord),trunc(wristMaxPoints.bottomRight.yCord));
    Brush.Style := chooseStrokeStyle;
    Brush.Color := clWhite;
    FloodFill(trunc((wristMaxPoints.topLeft.xCord)+10),trunc((wristMaxPoints.topLeft.yCord+10)), clWhite, fsBorder);
  end;
   if toDraw() = true then
   begin  //fills in finger section
    pen.Color := clBlack;
    repeat
      Brush.Style := chooseStrokeStyle;
    until (Brush.Style <> bsSolid) ;
    rectangle(trunc(fingerMaxPoints.topLeft.xCord),trunc(fingerMaxPoints.topLeft.yCord) ,trunc(fingerMaxPoints.bottomRight.xCord),trunc(fingerMaxPoints.bottomRight.yCord ));
    FloodFill(trunc((fingerMaxPoints.topLeft.xCord)+10),trunc((fingerMaxPoints.topLeft.yCord+10)), clBlack, fsBorder);
    pen.Color := defaultColour;
    rectangle(trunc(fingerMaxPoints.topLeft.xCord),trunc(fingerMaxPoints.topLeft.yCord) ,trunc(fingerMaxPoints.bottomRight.xCord),trunc(fingerMaxPoints.bottomRight.yCord ));
     pen.Color := clBlack;
   rectangle(trunc(thumbMaxPoints.topLeft.xCord),trunc(thumbMaxPoints.topLeft.yCord) ,trunc(thumbMaxPoints.bottomRight.xCord),trunc(thumbMaxPoints.bottomRight.yCord ));
    FloodFill(trunc((thumbMaxPoints.topLeft.xCord)+10),trunc((thumbMaxPoints.topLeft.yCord+10)), clBlack, fsBorder);
    pen.Color := defaultColour;
    rectangle(trunc(thumbMaxPoints.topLeft.xCord),trunc(thumbMaxPoints.topLeft.yCord) ,trunc(thumbMaxPoints.bottomRight.xCord),trunc(thumbMaxPoints.bottomRight.yCord ));
    Brush.Style := defaultBrushStyle;
   end;
  end;
  end;

procedure template2(middleCord : TCooridantes);
var
  heightDif,widthDif,widthInterval : real;
  i : integer;
begin
  currentTemplate := 2;
  with  form_homepage.hennaDesign_canvas.Canvas do
    begin
     widthDif := wristMaxPoints.topRight.xCord - wristMaxPoints.topLeft.xCord ;
      widthInterval := widthDif / 10 ;
      if toDraw() = true then
      begin   //does wrist border
       basicLine(trunc(wristMaxPoints.topLeft.xCord), trunc(wristMaxPoints.topLeft.yCord),trunc(wristMaxPoints.topRight.xCord),trunc(wristMaxPoints.topRight.yCord));
       basicLine(trunc(wristMaxPoints.bottomLeft.xCord), trunc(wristMaxPoints.bottomLeft.yCord),trunc(wristMaxPoints.bottomRight.xCord),trunc(wristMaxPoints.bottomRight.yCord));
      end;
      if toDraw() = true then
      begin //does wrist triangle fill
          for i := 0 to 9 do
            begin
              basicTriangle((trunc( wristMaxPoints.topLeft.xCord + (widthInterval *i))),trunc(wristMaxPoints.bottomLeft.yCord),trunc((widthInterval/2)+( wristMaxPoints.topLeft.xCord )+ (widthInterval *i)),trunc(wristMaxPoints.topLeft.yCord),trunc(wristMaxPoints.topLeft.xCord + (widthInterval *(i+1))),trunc(wristMaxPoints.bottomLeft.yCord)) ;
            end;
      end;
      if toDraw() = true then
      begin
        for i := 0 to 10 do
        begin //does circles on traingle border
          basicCircle((trunc( wristMaxPoints.topLeft.xCord + (widthInterval *i)-10)),trunc(wristMaxPoints.bottomLeft.yCord-10),(trunc( wristMaxPoints.topLeft.xCord + (widthInterval *i)+10)),trunc(wristMaxPoints.bottomLeft.yCord+10));
          basicCircle((trunc( wristMaxPoints.bottomLeft.xCord + (widthInterval *i)-10)),trunc(wristMaxPoints.topLeft.yCord - 10),(trunc( wristMaxPoints.bottomLeft.xCord + (widthInterval *i)+10)),trunc(wristMaxPoints.topLeft.yCord)+10);
        end;
      end;

      if toDraw() = true then
      begin  //does filled circles on traingle border
      for i := 0 to 10 do
      begin
          filledCircle((trunc( wristMaxPoints.topLeft.xCord + (widthInterval *i)-10)),trunc(wristMaxPoints.bottomLeft.yCord-10),(trunc( wristMaxPoints.topLeft.xCord + (widthInterval *i)+10)),trunc(wristMaxPoints.bottomLeft.yCord+10));
          filledCircle((trunc( wristMaxPoints.bottomLeft.xCord + (widthInterval *i)-10)),trunc(wristMaxPoints.topLeft.yCord - 10),(trunc( wristMaxPoints.bottomLeft.xCord + (widthInterval *i)+10)),trunc(wristMaxPoints.topLeft.yCord)+10);
      end;
      end;

  end;
end;

procedure template3();
var
i, element,tempNum : integer;
middleCord : TCooridantes ;
begin
  for i := 1 to 20 do  //does max 20 elements
  begin
     if toDraw() = true then
     begin
        form_homepage.hennaDesign_canvas.canvas.pen.style := choosePenStyle(true) ;
        form_homepage.hennaDesign_canvas.canvas.brush.Style := chooseStrokeStyle() ;
        middleCord.xCord :=  Random(form_homepage.hennaDesign_canvas.Width-200)+100;  // random number  but ensures wont be outside canvas
        middleCord.yCord :=  Random(form_homepage.hennaDesign_canvas.height-200)+100;
        element := random(7)+1;
        tempNum := random(100) ;
      case element of //picks a random element
        1 : basicLine(Random(form_homepage.hennaDesign_canvas.Width),Random(form_homepage.hennaDesign_canvas.height),Random(form_homepage.hennaDesign_canvas.Width),Random(form_homepage.hennaDesign_canvas.height));
        2 : basicCircle(trunc(middleCord.xCord-random(100)),trunc(middleCord.yCord-random(100)),trunc(middleCord.xCord+random(100)),trunc(middleCord.yCord+random(100)));
        3 : filledCircle(trunc(middleCord.xCord-random(100)),trunc(middleCord.yCord-random(100)),trunc(middleCord.xCord+random(100)),trunc(middleCord.yCord+random(100)));
        4 : dashedCircle (trunc(middleCord.xCord-random(100)),trunc(middleCord.yCord-random(100)),trunc(middleCord.xCord+random(100)),trunc(middleCord.yCord+random(100)));
        5 : basicTriangle(Random(form_homepage.hennaDesign_canvas.Width),Random(form_homepage.hennaDesign_canvas.height),Random(form_homepage.hennaDesign_canvas.Width),Random(form_homepage.hennaDesign_canvas.height),Random(form_homepage.hennaDesign_canvas.Width),Random(form_homepage.hennaDesign_canvas.height));
        6 : innerReflectionCircle(trunc(middleCord.xCord-tempNum),trunc(middleCord.yCord-tempNum),trunc(middleCord.xCord+tempNum),trunc(middleCord.yCord+tempNum));
        7 : miniCircleBorder(trunc(middleCord.xCord-tempNum),trunc(middleCord.yCord-tempNum),trunc(middleCord.xCord+tempNum),trunc(middleCord.yCord+tempNum));
      end;
     end;

  end;

end;

procedure runTemplate();
begin
  case currentTemplate of
    1 : template1(handCentre) ;
    2 : template2(handCentre);
    3 : template3();
  end;
end;

procedure Tform_homepage.BitBtn1Click(Sender: TObject);
begin
  messagedlg('Do not use a prexsiting filename',mtWarning , mbOKCancel, 0);
  if SavePictureDialog1.Execute then
  begin
    if SavePictureDialog1.FileName<>'' then
    begin
      hennaDesign_canvas.Picture.SaveToFile(SavePictureDialog1.FileName);
    end;
  end;
end;

//menu bar

procedure Tform_homepage.ApplicationManual1Click(Sender: TObject);
begin //loads a pop up with the instruction guide
  showmessage('New Design : This button will generate a new henna design '+#13#10+#13#10+
              'Save Design : This button will allow you to save the henna design to your computer'+#13#10+#13#10+
              'Like and Dislike Buttons : This will rate the design and help cutomise designs to your taste'+#13#10+ #13#10+
              'YouTube Tutoirals : If you click the button next to each elements name, you will be taken to a YouTube tutorial for it'+#13#10+#13#10+
              'Henna Application Instructions : Click the option in the menu bar'+#13#10+ #13#10+
              'Reset preferances : Go to menu bar -> settings -> reset' +#13#10+#13#10+
              'Element Trend : To view what elements you like the most and least you can open the Access database in the project file and view this');
end;

procedure Tform_homepage.Exit1Click(Sender: TObject);
begin    //application ends itself
  Application.Terminate;
end;

procedure Tform_homepage.HennaApplicationGuide1Click(Sender: TObject);
begin
shellexecute(Application.Handle,'open',PChar('https://www.wikihow.com/Do-a-Henna-Tattoo' ),nil,nil,0);
end;

procedure Tform_homepage.ResetPreferances1Click(Sender: TObject);
var
i : integer ; //resets to inital values
begin
  with form_homepage.adoquery1 do
   begin
    SQL.Clear;
    SQL.Add('UPDATE Elements');
    SQL.Add('SET UserRating = 100');
    ExecSQL ;
    end;

  with form_homepage.adoquery1 do
   begin
    SQL.Clear;
    SQL.Add('UPDATE Style_Preferance');
    SQL.Add('SET User_Weighting = 100');
    ExecSQL ;
    end;
end;


//form loading

procedure Tform_homepage.FormCreate(Sender: TObject);
Var
bitmap : TBitmap;
  i,index: Integer;
begin
  makeNewLabels();
  //Loads hand template into canvas
  bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromFile('handOutlineV5.bmp');
   form_homepage.hennaDesign_canvas.canvas.Brush.Bitmap := Bitmap;
    hennaDesign_canvas.canvas.FillRect(Rect(0,0,1000,1000));
  finally
    form_LoadScreen.Canvas.Brush.Bitmap := nil;
    Bitmap.Free;
  end;

  //sets values of golbal cordiante values
  handCentre.xCord := 325;
  handCentre.yCord := 550;
  wristMaxPoints.topLeft.xCord :=212;
  wristMaxPoints.topLeft.yCord :=800;
  wristMaxPoints.bottomLeft.xCord :=212;
  wristMaxPoints.bottomLeft.yCord :=900;
  wristMaxPoints.topRight.xCord :=425;
  wristMaxPoints.topRight.yCord :=800;
  wristMaxPoints.bottomRight.xCord :=420;
  wristMaxPoints.bottomRight.yCord :=900;


  fingerMaxPoints.topLeft.xCord :=2;
  fingerMaxPoints.topLeft.yCord :=75;
  fingerMaxPoints.bottomLeft.xCord :=2;
  fingerMaxPoints.bottomLeft.yCord :=385;
  fingerMaxPoints.topRight.xCord :=438;
  fingerMaxPoints.topRight.yCord :=75;
  fingerMaxPoints.bottomRight.xCord :=438;
  fingerMaxPoints.bottomRight.yCord :=385;

  thumbMaxPoints.topLeft.xCord :=471;
  thumbMaxPoints.topLeft.yCord :=330;
  thumbMaxPoints.bottomLeft.xCord :=471;
  thumbMaxPoints.bottomLeft.yCord :=445;
  thumbMaxPoints.topRight.xCord :=617;
  thumbMaxPoints.topRight.yCord :=350;
  thumbMaxPoints.bottomRight.xCord :=617;
  thumbMaxPoints.bottomRight.yCord :=465;

  //sets deafult styles
  defaultBrushStyle :=  bsClear;
  defaultPenStyle :=  psSolid;
  defaultColour :=   ClWhite;
  form_homepage.hennaDesign_canvas.Canvas.Brush.Color :=  defaultColour;
  form_homepage.hennaDesign_canvas.Canvas.pen.Color :=  defaultColour;
  form_homepage.hennaDesign_canvas.Canvas.Brush.Style := defaultBrushStyle;

  //sets deafult values for BST
  elementsLlSp:= -1;
  elementsTop := -1;
  for index := 0 to 30 do
  begin
    elementsLl[index].pointer :=-1;
  end;
end;

//new deisgn - at end as requires many other procedures
procedure Tform_homepage.newDesign_btnClick(Sender: TObject);
begin
clearCanvas();
resetVariables();
clearLinkedList(30,elementsLl) ;
pickTemplate();
runTemplate();
populateElementLabels();
createButtons();
end;




//test buttons - these buttons were used for unit testing
//they have been left in case of the need to debug future errors

procedure Tform_homepage.template3_btnClick(Sender: TObject);
begin
template3();
end;

procedure Tform_homepage.Button10Click(Sender: TObject);
begin
  template1(handCentre);
end;

procedure Tform_homepage.Button11Click(Sender: TObject);
begin
template2(handCentre);
end;

procedure Tform_homepage.Button12Click(Sender: TObject);
var
i : integer;
begin
//label1.Caption := '';
for i := 0 to 30 do
begin
  //label1.Caption := label1.Caption +  ' ' +  elementsLl[i].item;
end;

end;

procedure Tform_homepage.Button13Click(Sender: TObject);
begin
clearLinkedList(30,elementsLl)  ;
end;

procedure Tform_homepage.Button14Click(Sender: TObject);
begin
 if 'filledCircle' > 'basicLine' then
 begin
   //label1.Caption := 'works';
 end
 else
 begin
    //label1.Caption := 'nope';
 end;
end;

procedure Tform_homepage.Button15Click(Sender: TObject);
var
  i,p: Integer;
begin
//label1.caption:= '';
p := elementsLlSp;
while p <> -1 do
  begin
  //label1.Caption := label1.Caption +  ' ' +  elementsLl[p].item;
  p := elementsLl[p].pointer
  end;
end;

procedure Tform_homepage.Button16Click(Sender: TObject);
var
testLabel : TLabel ;
begin
    testLabel := TLabel.Create(self);
    testLabel.Parent := self;
    testLabel.Top := 20;
    testLabel.Left := 20;
    testLabel.Caption := 'test label';
end;

procedure Tform_homepage.Button17Click(Sender: TObject);
var
index,i,p, splitIndex: Integer;
tempString1, tempString2 : string ;
begin
  i := 0;
  p := elementsLlSp;
  while p <> -1 do
    begin
    for index := 1 to (elementsLl[p].item.Length) do
      begin
       if elementsLl[p].item[index] = upperCase(elementsLl[p].item[index]) then
        begin
          splitIndex :=  index;
        end ;
      end;
    tempString1 :=  elementsLl[p].item.Substring(1,splitIndex-2) ;
    tempString2 :=  elementsLl[p].item.Substring(splitIndex-1,elementsLl[p].item.Length-1) ;
    dispalyArray[i].labels.Caption :=  upperCase( elementsLl[p].item[1]) + tempString1 + ' ' + tempString2  ;
    p := elementsLl[p].pointer ;
    i := i + 1;
    end;
  while i<=30 do
  begin
    dispalyArray[i].labels.Caption := '';
    i := i +1;
  end;
end;

procedure Tform_homepage.Button18Click(Sender: TObject);
var
i,j : integer;
begin
j := 0;
for i := 0 to 30 do
  begin
       dispalyArray[i].labels := TLabel.Create(self);
      dispalyArray[i].labels.Parent := self;
       dispalyArray[i].labels.Top := 100 + j;
       dispalyArray[i].labels.Left := 2000;
       dispalyArray[i].labels.Cursor := crHandPoint ;
      j := 50 + j;
      //labels[i].Caption := 'test' ;
  end;
end;

procedure Tform_homepage.Button19Click(Sender: TObject);
begin
 with ADOQuery1 do
 begin
 Active := false;
 SQL.Clear;
 SQL.Add('SELECT APIquery FROM Elements WHERE ElementName = "basicCircle" ;');
 Active := true;
 end;
end;

procedure Tform_homepage.Button1Click(Sender: TObject);
begin
  hennaDesign_canvas.Canvas.Pen.Color := clBlack;
   basicTriangle(10,10,20,20,10,30) ;
end;

procedure Tform_homepage.Button20Click(Sender: TObject);
begin
  with adt_elements do
    begin
      open ;
      if fieldvalues['ElementName'] = 'basicCircle'then
      begin
        //label2.Caption:=  fieldvalues['APIquery'];
      end;
    end;

end;

procedure Tform_homepage.Button21Click(Sender: TObject);
begin
//queryLLItems;
end;

procedure Tform_homepage.Button22Click(Sender: TObject);
begin
var
i,j: integer;
begin
j := 0;
for i := 0 to 30 do
  begin
    dispalyArray[i].button := TButton.Create(Self);
    with    dispalyArray[i].button DO
    begin
    Visible := true;
    Caption := dispalyArray[i].labels.Caption;
    Parent := Self;
    Height := 23;
    Width := 100;
    Left := 2200;
    Top := 100 + j;
    if dispalyArray[i].labels.Caption <> '' then
     begin
      tempIndex := i;
      OnClick := youtubeAPI;
     end;
    end;
//    dispalyArray[i].button.OnClick := shellexecute(handle,'open','https://www.youtube.com/results?search_query=simple+circle+henna',nil,nil,0);
//    //try assinging it to an invisible buttons code
    // dispalyArray[i].button.OnClick := (Handle, 'open', PChar('http://www.google.com/'), nil, nil, SW_SHOW);
  //    dispalyArray[i].button.Click := shellexecute(handle,'open','https://www.youtube.com/results?search_query=simple+circle+henna',nil,nil,0);

    j := 50 + j;
  end;
end;
end;

//procedure TForm2.Button23Click(Sender: TObject);
//var
//i,j,k,p: integer;
//begin
//j := 0;
//   with form2.adt_elements do
//    begin
//    open ;
//    p := elementsLlSp;
//    while p <> -1 do
//      begin
//      for i := 1 to recordcount do
//       begin
//        recno := i;
//        if fieldvalues['ElementName'] = elementsLl[p].item then
//          begin
//          dispalyArray[i].image:=  fieldvalues['Images'];
//          end;
//       end;
//       p := elementsLl[p].pointer;
//      end;
//    end;
//end;
//
//    dispalyArray[i].image :=  TImage.Create(self)   ;
//    with    dispalyArray[i].image DO
//    begin
//     dispalyArray[i].image := TImage.Create(self);
//     dispalyArray[i].image.Picture := ;
//     dispalyArray[i].image.Parent := PageControl1.ActivePage;
//      if dispalyArray[i].labels.Caption <> '' then
//     begin
//      tempIndex := i;
//      OnClick := youtubeAPI;
//     end;
//    end;
//
//    j := 50 + j;
//  end;
//end;
//end;


procedure Tform_homepage.Button2Click(Sender: TObject);
begin
   filledCircle(10,10,200,200);
end;

procedure Tform_homepage.Button3Click(Sender: TObject);
begin
   dashedCircle(10,10,200,200);
end;

procedure Tform_homepage.Button4Click(Sender: TObject);
begin
 form_homepage.hennaDesign_canvas.canvas.pen.Style := choosePenStyle(true);
 basicLine(10,10,10,1000) ;
 form_homepage.hennaDesign_canvas.canvas.pen.Style := psSolid;

end;

procedure Tform_homepage.Button5Click(Sender: TObject);
var
coordinates : array[0..7] of TCooridantes;
begin
 circleEightPoints (10,10,10,1000,coordinates);

end;

procedure Tform_homepage.Button6Click(Sender: TObject);
begin
innerReflectionCircle(10,10,200,200);
end;

procedure Tform_homepage.Button7Click(Sender: TObject);
begin
miniCircleBorder(10,10,200,200);
end;

procedure Tform_homepage.Button8Click(Sender: TObject);
begin
  //skeletonLeaf(100,800,300,100);
end;

procedure Tform_homepage.CircleClick(Sender: TObject);
begin
  basicCircle(10,10,200,200)
end;




end.
