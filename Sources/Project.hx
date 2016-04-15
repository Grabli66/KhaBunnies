package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Assets;
import kha.Image;
import kha.Color;
import kha.Scaler;
import kha.input.Surface;
import kha.input.Mouse;

class Project {
	public static inline var SCREEN_WIDTH = 1024;
	public static inline var SCREEN_HEIGHT = 768;
	private static inline var BUNNY_COUNT = 50;	
	
	private static var bgColor = Color.fromValue(0xAAAAAA);
	private var initialized = false;
	private var backbuffer: Image;	
	private var bunnies: Array<Bunny>;	 
	
	public function new() {				
		Assets.loadEverything(loadFinish);		
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 30);
	}
	
	private function loadFinish() {
		initialized = true;
		
		backbuffer = Image.createRenderTarget(SCREEN_WIDTH, SCREEN_HEIGHT);		
		bunnies = new Array<Bunny>();										
		Surface.get().notify(touchStart, null, null);		
		Mouse.get().notify(touchStart, null, null, null);		
		addBunnies(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
	}
	
	private function addBunnies(x: Float, y: Float) {
		var asset = Assets.images.bunny;
		for (i in 0...BUNNY_COUNT) {		
			var bx = Math.round(x + Math.random() * 100);	
			var by = Math.round(y + Math.random() * 100);
			bunnies.push(new Bunny(bx, by, asset));
		}
	}
	
	private function touchStart(index: Int, x: Int, y: Int) {
		if (!initialized) {
			return;
		}	
		
		addBunnies(x, y);
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
