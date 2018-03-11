// イベント
const MSG_START = "msgStart";
const MSG_GAMEOVER = "msgGameOver";
const MSG_TITLE = "msgTitle";
const MSG_CLEAR = "msgClear";
const MSG_WARNING = "msgWarning";
const MSG_STAGE_CHANGED = "msgStageChanged";
const MSG_SHIP_APPEAR = "msgShipAppear";
const MSG_GOTO_NEXT_STAGE = "msgGotoNextStage";

const MAX_STAGE = 3;

var isGhost;
var stageNum;
var boss3PosX, boss3PosY;

[Variable(name="SHIP", visible=false, x=10, y=10, mode=1, sliderMin=0, sliderMax=100)]
var shipCount;
[Variable(name="SCORE", visible=false, x=100, y=10, mode=1, sliderMin=0, sliderMax=100)]
var score;

[Variable(name="DEBUG", visible=true, x=10, y=30, mode=1, sliderMin=0, sliderMax=100)]
var debug;

function scripts(){	
	whenIReceive(MSG_TITLE, function(){
		hideVariable(shipCount);
		hideVariable(score);
	});
	
	whenIReceive(MSG_START, function(){
		showVariable(shipCount);
		showVariable(score);
	});	
}

