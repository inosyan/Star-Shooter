
function scripts(){
	whenFlagClicked(function(){
		hide();
	});
	
	whenIReceive(MSG_WARNING, function(){
		setEffectTo(EFFECT_GHOST, 100);
		show();
		repeat(4){
			repeat(10){
				changeEffectBy(EFFECT_GHOST, -5);
			}
			repeat(10){
				changeEffectBy(EFFECT_GHOST, 5);
			}			
		}
		hide();
	});
}