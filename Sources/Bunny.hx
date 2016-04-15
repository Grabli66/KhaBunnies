import kha.Image;
import kha.graphics2.Graphics;

class Bunny {
	private var speedX: Int;	
	private var speedY: Int;
	
	private var x : Int;
	private var y : Int;
	private var Img : Image;
	
	public function new(x: Int, y: Int, img: Image) {
		var dirX = 1; 
		var dirY = 1;
		if ((Math.random() * 100) > 50) {
			dirX = -1;
		} 
		
		if ((Math.random() * 100) > 50) {
			dirY = -1;
		}
		
		speedX = dirX + Math.round(Math.random() * 4) * dirX;		
		speedY = dirY + Math.round(Math.random() * 4) * dirY;
		this.x = x;
		this.y = y;
		Img = img;
	}
	
	public function update() {
		if ((x > Project.SCREEN_WIDTH - Img.width) || (x < 0))  {
			speedX *= -1;
		}
		
		if ((y > Project.SCREEN_HEIGHT - Img.height) || (y < 0))  {
			speedY *= -1;
		}
		
		x += speedX;
		y += speedY;
	}
	
	public function render(g: Graphics) {
		g.drawImage(Img, x, y);
	}
}