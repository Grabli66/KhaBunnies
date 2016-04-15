package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Assets;
import kha.Image;
import kha.Color;
import kha.Scaler;

class Project {
	public static inline var SCREEN_WIDTH = 1024;
	public static inline var SCREEN_HEIGHT = 768;
	
	private static var bgColor = Color.fromValue(0xAAAAAA);
	
	private var lastTime: Float;
	private var currentTime: Float;
	
	private var initialized = false;
	private var backbuffer: Image;
	
	private var bunnies: Array<Bunny>; 
	
	public function new() {
		lastTime = 0;
		currentTime = 0;
		
		Assets.loadEverything(loadFinish);
		
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 30);
	}
	
	private function loadFinish() {
		backbuffer = Image.createRenderTarget(SCREEN_WIDTH, SCREEN_HEIGHT);
		
		bunnies = new Array<Bunny>();
		var asset = Assets.images.bunny;
		for (i in 0...3000) {		
			var x = Math.round(Math.random() * (SCREEN_WIDTH - asset.width));	
			var y = Math.round(Math.random() * (SCREEN_HEIGHT - asset.height));
			bunnies.push(new Bunny(x, y, asset));
		}
				
		initialized = true;
	}

	function update(): Void {
		if (!initialized) {
			return;
		}	
		
		for (b in bunnies) {
			b.update();
		}			
	}

	function render(framebuffer: Framebuffer): Void {
		if (!initialized) {
			return;
		}		
		
		var g = backbuffer.g2;

		// clear and draw to our backbuffer
		g.begin(bgColor);
		for (b in bunnies) {
			b.render(g);
		}	
		g.end();

		// draw our backbuffer onto the active framebuffer
		framebuffer.g2.begin();
		Scaler.scale(backbuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();
	}
}
