const KIND_TITLE = 0;
const KIND_PRESS_SPACE = 1;
const KIND_STAGE1 = 2;
const KIND_STAGE2 = 3;
const KIND_FINAL_STAGE = 4;
const KIND_GAMEOVER = 5;
const KIND_CONGRATULATION = 6;

var kind;
var timeCountForTap;
var n;

function scripts(){
	whenFlagClicked(function(){
		hide();
	});
	
	whenIReceive(MSG_TITLE, function(){
		deleteThisClone();
		kind = KIND_TITLE;
		createCloneOf(CLONETARGET_MYSELF);
		kind = KIND_PRESS_SPACE;
		createCloneOf(CLONETARGET_MYSELF);		
	});
	
	whenIReceive(MSG_STAGE_CHANGED, function(){
		deleteThisClone();
		if (stageNum == 1) kind = KIND_STAGE1;
		if (stageNum == 2) kind = KIND_STAGE2;
		if (stageNum == 3) kind = KIND_FINAL_STAGE;		
		createCloneOf(CLONETARGET_MYSELF);
	});
	
	whenIReceive(MSG_GAMEOVER, function(){
		deleteThisClone();
		kind = KIND_GAMEOVER;
		createCloneOf(CLONETARGET_MYSELF);
	});
	
	whenIReceive(MSG_CLEAR, function(){
		deleteThisClone();
		kind = KIND_CONGRATULATION;
		createCloneOf(CLONETARGET_MYSELF);
	});
	
	whenIStartAsAClone(function(){
		goBackLayers(10);
		gotoXY(0, 0);
		if (kind == KIND_TITLE) switchCostumeTo("title");
		if (kind == KIND_PRESS_SPACE) switchCostumeTo("press-space");
		if (kind == KIND_STAGE1) switchCostumeTo("stage1");
		if (kind == KIND_STAGE2) switchCostumeTo("stage2");
		if (kind == KIND_FINAL_STAGE) switchCostumeTo("final-stage");
		if (kind == KIND_GAMEOVER) switchCostumeTo("gameover");
		if (kind == KIND_CONGRATULATION) switchCostumeTo("congratulation");
		show();
		if (kind == KIND_PRESS_SPACE) pressSpaceAnim();
		if (kind == KIND_STAGE1 || kind == KIND_STAGE2 || kind == KIND_FINAL_STAGE) stageAnim();
		if (kind == KIND_GAMEOVER) gameoverAnim();
		if (kind == KIND_CONGRATULATION) congratulationAnim();		
	});
}

function pressSpaceAnim() {
	ypos = -135;
	timeCountForTap = 0;
	forever(){
		n = (timeCountForTap % 30) / 30;
		if (n < 0.5){
			setEffectTo(EFFECT_GHOST, (n * 2) * 100);
		} else {
			setEffectTo(EFFECT_GHOST, (2 - n * 2) * 100);
		}
		timeCountForTap++;
	}
}	

function stageAnim() {
	setEffectTo(EFFECT_GHOST, 100);
	wait(0.5);
	repeat(10){
		changeEffectBy(EFFECT_GHOST, -10);
	}
	wait(2);
	repeat(10){
		changeEffectBy(EFFECT_GHOST, 10);
	}
	deleteThisClone();
}

function gameoverAnim() {
	setEffectTo(EFFECT_GHOST, 100);
	wait(0.5);
	repeat(50){
		changeEffectBy(EFFECT_GHOST, -2);
	}
}

function congratulationAnim() {
	setEffectTo(EFFECT_GHOST, 100);
	size = 150;
	wait(0.5);
	repeat(50){
		changeEffectBy(EFFECT_GHOST, -2);
		size -= 1;
	}
}



