
const MAX_ENEMY_NUM = 15;

const KIND_NORMAL = 0;
const KIND_BULLET = 1;
const KIND_BOSS = 2;
const KIND_BOSS_SUB = 3;

var enemyNum;
var rate;
var n;
var b;
var debugMode = 0;
// for cannona and bullet
var cannonExploded = 0;
var kind = 0;
var enemyHP;
// for boss3
var boss3Radius, boss3Degree;
var boss3RotateDirection;
var boss3SubRad, boss3SubDeg;
var gameover;

function test(eneNum:int){
	enemyNum = eneNum;
	createCloneOf(CLONETARGET_MYSELF);
	wait(0.5);
}

function scripts(){
	whenIReceive(MSG_TITLE, function(){
		hide();
	});
	
	whenIReceive(MSG_STAGE_CHANGED, function(){
		enemyNum = 1;
		gameover = 0;
		wait(2);
		repeatUntil(enemyNum == MAX_ENEMY_NUM || gameover == 1){
			if (debugMode == 1) {
				debugTest();
			} else {
				appearCommon();
				enemyNum++;
			}
		}
		if (gameover == 0) {
			wait(2);
			broadcast(MSG_WARNING);
			wait(2);
			kind = KIND_BOSS;
			createCloneOf(CLONETARGET_MYSELF);
			kind = KIND_NORMAL;			
		}
	});
	
	whenIStartAsAClone(function(){
		clearGraphicEffects();
		if (kind != KIND_BULLET){
			ypos = 180;
			xpos = 0;
		}
		rate = 0;
		enemyHP = 1;
		if (enemyNum == 1 || enemyNum == 2) switchCostumeTo("enemy");
		if (enemyNum == 3 || enemyNum == 4) switchCostumeTo("enemy2");
		if (enemyNum == 5 || enemyNum == 6) switchCostumeTo("enemy3");
		if (enemyNum == 7 || enemyNum == 8) switchCostumeTo("enemy4");
		if (enemyNum == 9 || enemyNum == 10) switchCostumeTo("enemy5");
		if (enemyNum == 11 || enemyNum == 12) switchCostumeTo("enemy6");
		if (enemyNum == 13 || enemyNum == 14) switchCostumeTo("enemy7");
		if (kind == KIND_BULLET) switchCostumeTo("enemy_bullet");
		show();
		if (kind == KIND_BULLET || kind == KIND_BOSS || kind == KIND_BOSS_SUB) {
			if (kind == KIND_BULLET) bulletAnim();			
			if (kind == KIND_BOSS) whenBossCloned();
			if (kind == KIND_BOSS_SUB) boss3SubAnim();
		} else {
			repeatUntil(rate >= 1 || (touching("Shot") && rate > 0)){
				if (enemyNum == 1) straight(false);
				if (enemyNum == 2) straight(true);
				if (enemyNum == 3) snake(false);
				if (enemyNum == 4) snake(true);
				if (enemyNum == 5) cross(false);
				if (enemyNum == 6) cross(true);
				if (enemyNum == 7) zigzag(false);
				if (enemyNum == 8) zigzag(true);
				if (enemyNum == 9) round(false);
				if (enemyNum == 10) round(true);
				if (enemyNum == 11) spiral(false);
				if (enemyNum == 12) spiral(true);
				if (enemyNum == 13) cannon(false);
				if (enemyNum == 14) cannon(true);
			}
			if (!touching("Shot")) deleteThisClone();
		}
	});
	
	whenIStartAsAClone(function(){		
		if (kind != KIND_BULLET){
			waitUntil(enemyHP == 0);
			switchCostumeTo("enemy-crash");
			increaseScore();
			repeat(10){
				changeEffectBy(EFFECT_GHOST, 10);
			}
			if (kind == KIND_BOSS) broadcast(MSG_GOTO_NEXT_STAGE);
			deleteThisClone();
		}
	});
	
	whenIStartAsAClone(function(){
		if (kind != KIND_BULLET){
			repeatUntil(enemyHP == 0){
				waitUntil(touching("Shot"));
				enemyHP--;
				playSound("explode");
				if (enemyHP != 0){
					repeat(4){
						setEffectTo(EFFECT_BRIGHTNESS, 50);
						wait(0.1);
						setEffectTo(EFFECT_BRIGHTNESS, 10);
						wait(0.1);
					}
					clearGraphicEffects();					
				}
			}
			
		}
	});
	
	whenIReceive(MSG_GAMEOVER, function(){
		gameover = 1;
	});
	
	whenIReceive(MSG_CLEAR, function(){
		stop(STOPTARGET_OTHER_SCRIPTS);
		deleteThisClone();
	});
	
	whenIReceive(MSG_TITLE, function(){
		stop(STOPTARGET_OTHER_SCRIPTS);
		deleteThisClone();
	});
}

function debugTest(){
	if (keyPressed(1)) test(9);
	if (keyPressed(2)) test(10);
	if (keyPressed(3)) test(11);
	if (keyPressed(4)) test(12);
	if (keyPressed(5)) test(13);
	if (keyPressed(6)) test(14);
	if (keyPressed(7)) test(7);
	if (keyPressed(8)) test(8);	
}

// Appear
function appearCommon() {
	if (stageNum == 1) n = 5;
	if (stageNum == 2) n = 7;
	if (stageNum == 3) n = 9;	
	repeat(n){
		createCloneOf(CLONETARGET_MYSELF);
		if (stageNum == 1) wait(0.5);
		if (stageNum == 2) wait(0.4);
		if (stageNum == 3) wait(0.3);
	}
	wait(1);
}

// Boss
function whenBossCloned(){
	if (stageNum == 1) {
		enemyHP = 10;
		switchCostumeTo("boss1");
		boss1Anim();
	}
	if (stageNum == 2) {
		enemyHP = 15;
		switchCostumeTo("boss2");
		boss2Anim();
	}
	if (stageNum == 3) {
		enemyHP = 20;
		prepareBoss3();
		boss3Anim();
	}
}

// Score
function increaseScore(){
	if (kind == KIND_BOSS) {
		score += 1000;
	} else {
		score += 100;
	}
}

function moveCommonStraightDownY(){
	ypos = 180 - 360 * rate;
}

function moveCommonAfter(posX:int, isReverse:Boolean, rateIncrease:Number){
	xpos = posX;
	if (isReverse) xpos *= -1;
	rate += rateIncrease;
}

function snake(isReverse:Boolean){
	moveCommonStraightDownY();
	moveCommonAfter((mathSin(ypos) * 200), isReverse, 0.02);
}

function straight(isReverse:Boolean){
	moveCommonStraightDownY();
	moveCommonAfter(100, isReverse, 0.02);
}

function cross(isReverse: Boolean) {
	moveCommonStraightDownY();
	moveCommonAfter(150 - 300 * rate, isReverse, 0.02);
}

function zigzag(isReverse: Boolean) {
	moveCommonStraightDownY();
	b = isReverse;
	if (rate * 2 % 1 > 0.5){
		b = !isReverse;
	}
	moveCommonAfter(200 - (400 * (rate * 4 % 1)), b, 0.01);
}

function round(isReverse: Boolean) {
	xpos = mathSin(360 * 1.5 * rate) * 180;
	if (isReverse) xpos *= -1;
	ypos = mathCos(360 * 1.5 * rate) * 180;
	rate += 0.01;	
}

function spiral(isReverse: Boolean) {
	xpos = mathSin(360 * 3.25 * rate) * 180;
	if (isReverse) xpos *= -1;
	ypos = mathCos(360 * 3.25 * rate) * 90 + 90 - 270 * rate;
	rate += 0.01;
}

function cannon(isReverse: Boolean) {
	xpos = 100;
	if (isReverse) xpos *= -1;
	if (rate < 0.3) {
		ypos = 180 - 120 * rate / 0.3;
	} else {
		if (cannonExploded == 0){
			kind = KIND_BULLET;
			explodeBullets(6);			
			kind = KIND_NORMAL;
			cannonExploded = 1;
		}
		if (rate > 0.6) {
			ypos = 60 - 240 * (rate - 0.6) / 0.4;
		}
	}
	rate += 0.01;
}

[ProcDef(fastmode="true")]
function explodeBullets(bulletNum:int){
	repeat(bulletNum){
		turnRight(360 / bulletNum);
		createCloneOf(CLONETARGET_MYSELF);
	}
}

function bulletAnim(){
	repeatUntil(touching(TOUCHTARGET_EDGE)){
		move(5);		
	}
	deleteThisClone();
}

function bossExplodeBullets(bulletNum:int) {
	kind = KIND_BULLET;
	explodeBullets(bulletNum);
	kind = KIND_BOSS;
}

function boss1Anim(){
	ypos = 200;
	repeat(70){
		move(2);
	}
	n = 0;
	forever(){
		wait(1);
		n = n % 4;
		if (n == 0 || n == 3) direction = 90;
		if (n == 1 || n == 2) direction = -90;
		repeat(50){
			move(2);
		}
		bossExplodeBullets(12);
		n++;
	}
}

function boss2Anim(){
	ypos = 200;
	repeat(20){
		move(2);
	}
	n = 0;
	forever(){
		wait(1);
		n = n % 4;
		if (n == 0) direction = 120;
		if (n == 1) direction = -120;
		if (n == 2) direction = -60;
		if (n == 3) direction = 60;
		repeat(80){
			move(3);
		}
		bossExplodeBullets(15);
		n++;
	}
}

// Boss3
[ProcDef(fastmode="true")]
function prepareBoss3(){
	boss3PosX = xpos;
	boss3PosY = ypos;
	boss3SubDeg = 0;
	boss3SubRad = 40;
	kind = KIND_BOSS_SUB;
	switchCostumeTo("boss3-2");
	repeat(8){
		createCloneOf(CLONETARGET_MYSELF);
		boss3SubDeg += 45;
	}
	boss3SubRad = 70;
	repeat(12){
		createCloneOf(CLONETARGET_MYSELF);
		boss3SubDeg += 30;
	}	
	kind = KIND_BOSS;
	switchCostumeTo("boss3-1");
}

function boss3Anim(){
	ypos = 200;
	repeat(50){
		move(4);
		boss3PosX = xpos;
		boss3PosY = ypos;
	}
	wait(1);
	boss3Degree = 0;
	boss3Radius = 0;
	n = 1;
	boss3RotateDirection = 1;
	forever(){
		boss3Degree = boss3Degree % 360;
		if (boss3Radius >= 180) n = -1;
		if (boss3Radius <= 0){
			n = 1;
			boss3RotateDirection *= -1;
		}
		xpos = mathCos(boss3Degree) * boss3Radius;
		ypos = mathSin(boss3Degree) * boss3Radius;
		boss3PosX = xpos;
		boss3PosY = ypos;
		boss3Degree += 4 * boss3RotateDirection;
		boss3Radius += 1 * n;
		if (boss3Degree % 360 == 0){
			if (enemyHP < 10){
				bossExplodeBullets(15);				
			} else {
				bossExplodeBullets(12);
			}
		} 
	}
}

function boss3SubAnim() {
	forever(){
		xpos = boss3PosX + mathCos(boss3SubDeg) * boss3SubRad;
		ypos = boss3PosY + mathSin(boss3SubDeg) * boss3SubRad;
		boss3SubDeg += 4;
	}
}




