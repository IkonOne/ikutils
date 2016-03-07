package ikutil.input;

import flambe.System;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.input.TouchPoint;
import flambe.math.Rectangle;

/**
 * @brief      A button that takes a list of keys and a screen area.
 */
class GameButton {
	/**
	 * True if the button is down.
	 */
	public var isDown(get, never):Bool;

	/**
	 * A list of keys that trigger this button.
	 */
	public var keys(default, null):Array<Key>;

	/**
	 * Dimensions of the button on the touchscreen.
	 */
	public var dims(default, null):Rectangle;

	/**
	 * @brief      Instantiates a button with the provided dimensions.
	 *
	 * @param      x       x position of the touch screen dimensions.
	 * @param      y       y position of the touch screen dimensions.
	 * @param      width   width of the button on the touchscreen.
	 * @param      height  height of the button on the touchscreen.
	 */
	public function new(x:Float = 0, y:Float = 0, width:Float = 1, height:Float = 1) {
	    keys = new Array<Key>();
	    dims = new Rectangle(x, y, width, height);

	    _activeKeys = new Map<Key, Bool>();
	    _touchIDs = new Array<Int>();

	    System.keyboard.down.connect(onKeyDown);
	    System.keyboard.up.connect(onKeyUp);

	    System.touch.down.connect(onTouchDown);
	    System.touch.up.connect(onTouchUp);
	    System.touch.move.connect(onTouchMove);
	}

	public function update():Void {
		_isDown = _touchIDs.length > 0;

	   	 for (key in keys) {
	   	 	if(!_activeKeys.exists(key)) {
	   	 		_activeKeys.set(key, false);
	   	 		continue;
	   	 	}

	   	 	_isDown = _isDown || _activeKeys.get(key);
	   	 }
	}

	private function onKeyDown(event:KeyboardEvent):Void {
	    if(keys.indexOf(event.key) == -1)
	    	return;

    	_activeKeys.set(event.key, true);

	    update();
	}

	private function onKeyUp(event:KeyboardEvent):Void {
	    if(keys.indexOf(event.key) == -1)
	    	return;

	    _activeKeys.set(event.key, false);

	    update();
	}

	private function onTouchDown(point:TouchPoint):Void {
		if(dims.contains(point.viewX, point.viewY))
			_touchIDs.push(point.id);

		update();
	}

	private function onTouchUp(point:TouchPoint):Void {
	    if(dims.contains(point.viewX, point.viewY) && _touchIDs.indexOf(point.id) != -1)
	    	_touchIDs.remove(point.id);

	    update();
	}

	private function onTouchMove(point:TouchPoint):Void {
	    if(_touchIDs.indexOf(point.id) != -1) {
	    	if(!dims.contains(point.viewX, point.viewY))
	    		_touchIDs.remove(point.id);
	    }
	    else {
	    	if(dims.contains(point.viewX, point.viewY))
	    		_touchIDs.push(point.id);
	    }

	    update();
	}

	private function get_isDown():Bool {
	    return _isDown;
	}

	private var _isDown:Bool = false;
	private var _activeKeys:Map<Key, Bool>;
	private var _touchIDs:Array<Int>;
}