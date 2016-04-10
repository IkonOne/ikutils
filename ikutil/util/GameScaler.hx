package ikutil.util;

import flambe.System;
import flambe.display.Sprite;
import flambe.math.FMath;
import flambe.math.Point;
import flambe.math.Rectangle;

/**
 * @brief      Utilty Sprite that automatically scales based on desired dimensions of the game and the actual size of the game.
 */
class GameScaler extends Sprite {
	/**
	 * Desired width of the game.
	 */
	public var width(get, set):Int;

	/**
	 * Desired height of the game.
	 */
	public var height(get, set):Int;

	/**
	 * Half the desired width of the game.
	 */
	public var halfwidth(get, never):Float;

	/**
	 * Half the desired height of the game.
	 */
	public var halfheight(get, never):Float;

	/**
	 * Offset of the game on the screen.  Used to "letterbox" the game with the aspect ratios don't line up.
	 */
	public var offset(default, null):Point;

	/**
	 * The current scale of the game.
	 */
	public var scale(get, never):Float;

	public function new(width:Int = 320, height:Int = 480) {
		super();
	    _width = width;
	    _height = height;
	    offset = new Point();
	}

	override public function onStart():Void {
	    System.stage.resize.connect(onResize);
	    onResize();
	}

	private function onResize() {
	    // Specifies that the entire application be scaled for the specified target area while maintaining the original aspect ratio.
	    _scale = FMath.min(System.stage.width / _width, System.stage.height / _height);
	    // if (scale > 1) scale = 1; // You could choose to never scale up.

	    // re-scale and center the sprite of the container to the middle of the screen.
	    offset.set((System.stage.width - _width * _scale) / 2, (System.stage.height - _height * _scale) / 2);
	    setScale(_scale);
	    setXY(offset.x, offset.y);

	    // You can even mask so you cannot look outside of the container
	    scissor = new Rectangle(0, 0, _width, _height);
	}

	private function get_scale():Float {
		return _scale;
	}

	private function get_width():Int {
		return _width;
	}

	private function set_width(value:Int):Int {
		if(_width == value)
			return _width;

		_width = value;
		onResize();

		return _width;
	}	

	private function get_height():Int {
	    return _height;
	}

	private function set_height(value:Int):Int {
	    if(_height == value)
	    	return _height;

	    _height = value;
	    onResize();

	    return _height;
	}

	private function get_halfwidth():Float {
	    return width * 0.5;
	}

	private function get_halfheight():Float {
		return height * 0.5;
	}

	private var _scale:Float = 1;
	private var _width:Int;
	private var _height:Int;
}