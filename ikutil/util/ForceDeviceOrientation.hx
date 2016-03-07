package ikutil.util;

import flambe.Entity;
import flambe.SpeedAdjuster;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.display.FillSprite;
import flambe.display.Orientation;
import flambe.swf.Library;
import flambe.swf.MovieSprite;

/**
 * @brief      Displays a Flump animation as a notification screen to rotate a device to the correct orientation.  (Currently only implemented in Javascript)
 */
class ForceDeviceOrientation {
#if js
	/**
	 * The desired orientation of the device.
	 */
	public var orientation(default, null):Orientation = Orientation.Landscape;

	/**
	 * @brief      Creates a new ForceDeviceOrientation instance...
	 *
	 * @param      orientation  The desired orientation of the device.
	 * @param      toPause      The Entity to pause.  It is advisable not to use System.root.
	 * @param      pack         The assetpack containing the Flump animations.  The Library must be named "DeviceOrientation" and must contain the correct movie name(Either "landscape" or "portrait").
	 * @param      gameScale    Optional scale of te game to ensure that Flump movie fits.
	 */
	public function new(orientation:Orientation, toPause:Entity, pack:AssetPack, gameScale:Float = 1) {
		if(orientation != null)
	    	this.orientation = orientation;
	    _actualOrientation = System.stage.width > System.stage.height ? Orientation.Landscape : Orientation.Portrait;

	    _pauseEnt = toPause;

	    var lib = new Library(pack, "DeviceOrientation");
	    _orientationClip = lib.createMovie(
	    	(this.orientation == Orientation.Landscape ? "landscape" : "portrait")
	    );
	    _orientationClip.setScale(gameScale * 0.8);
	    _orientationEnt = new Entity()
	    	.add(_orientationClip);

	    _fill = new FillSprite(0, System.stage.width, System.stage.height);
	    new Entity()
	    	.add(_fill);

    	System.stage.resize.connect(onResize);
    	onOrientationChanged(_actualOrientation);
	}

	private function onResize():Void {
		if(System.stage.width > System.stage.height) {
			if(_actualOrientation != Orientation.Landscape)
				onOrientationChanged(Orientation.Landscape);
			_actualOrientation = Orientation.Landscape;
		}
		else if(System.stage.width < System.stage.height ) {
			if(_actualOrientation != Orientation.Portrait)
				onOrientationChanged(Orientation.Portrait);
			_actualOrientation = Orientation.Portrait;
		}

		_fill.setSize(System.stage.width, System.stage.height);
		_orientationClip.setXY(System.stage.width / 2, System.stage.height / 2);
	}

	private function onOrientationChanged(value:Orientation):Void {
		if(value == null)
			return;

		if(value != orientation) {
			if(_pauseEnt.has(SpeedAdjuster)) {
				_keepSpeedAdjuster = true;

				var sa = _pauseEnt.get(SpeedAdjuster);
				_prevSpeedAdjusterValue = sa.scale._;
				sa.scale._ = 0;
			}
			else {
				_keepSpeedAdjuster = false;

				var sa = new SpeedAdjuster(0);
				_pauseEnt.add(sa);
			}

			System.root.addChild(_fill.owner);
			System.root.addChild(_orientationEnt);
			_orientationClip.position = 0;
			_orientationClip.setXY(System.stage.width / 2, System.stage.height / 2);
		}
		else if(value == orientation) {
			if(_keepSpeedAdjuster) {
				var sa = _pauseEnt.get(SpeedAdjuster);
				sa.scale._ = _prevSpeedAdjusterValue;
			}
			else {
				var sa = _pauseEnt.get(SpeedAdjuster);
				_pauseEnt.remove(sa);
			}

			System.root.removeChild(_fill.owner);
			System.root.removeChild(_orientationEnt);
		}
	}

	private var _actualOrientation:Orientation;
	private var _orientationClip:MovieSprite;
	private var _orientationEnt:Entity;
	private var _pauseEnt:Entity;
	private var _keepSpeedAdjuster:Bool;
	private var _prevSpeedAdjusterValue:Float;
	private var _fill:FillSprite;

#else // not js
	public var orientation(default, null):Orientation = Orientation.Landscape;

	public function new(orientation:Orientation, toPause:Entity, pack:AssetPack) { }
#end
}
