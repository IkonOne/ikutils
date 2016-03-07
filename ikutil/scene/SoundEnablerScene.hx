package ikutil.scene;

import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.Sprite;
import flambe.scene.Scene;
import flambe.swf.Library;
import flambe.util.Signal1;
import ikutil.util.GameScaler;

/**
 * @brief      Displays a Flump "Scene" with a yes and no button and notifies which button was clicked.
 */
class SoundEnablerScene extends Scene {
	/**
	 * Triggered when a button is clicked.  The single boolean parameter will be true if yes was clicked and false if know whas clicked.
	 */
	public var onComplete:Signal1<Bool>;

	/**
	 * @brief      Creates a new SoundEnablerScene with the provided AssetPack and GameScaler.
	 *
	 * @param      pack    An AssetPack that contains a Flump Library named "SoundEnabler".  This library must have a movie anmed "enableSound" that has 2 layers named "buttonYes" and "buttonNo".  The "enableSound" movie should have a centered origin.
	 * @param      scaler  Optional GameScaler so that the scene is placed correctly on the screen if the game scaled.
	 */
	public function new(pack:AssetPack, scaler:GameScaler = null) {
		super(true);

		this.onComplete = new Signal1<Bool>();

		_scaler = scaler;
		_pack = pack;
	}

	override public function onStart():Void {
		var fill = new FillSprite(0, System.stage.width, System.stage.height);
		owner.addChild(new Entity()
			.add(fill)
		);

		_lib = new Library(_pack, "SoundEnabler");
		var screen = _lib.createMovie("enableSound");
		screen.x._ = _scaler != null ? _scaler.halfwidth : System.stage.width / 2;
		screen.y._ = _scaler != null ? _scaler.halfheight : System.stage.height / 2;
		screen.getLayer("buttonYes", true).get(Sprite)
			.pointerDown.connect(function(e) {
			onComplete.emit(true);
		});
		screen.getLayer("buttonNo", true).get(Sprite)
			.pointerDown.connect(function(e) {
				onComplete.emit(false);
		});

		owner.addChild(new Entity()
			.add(screen)
		);
	}

	private function onPackLoaded(pack:AssetPack) {
	    _pack = pack;
	}

	private var _scaler:GameScaler;
	private var _pack:AssetPack;
	private var _lib:Library;
	private var _loader:Dynamic;
}