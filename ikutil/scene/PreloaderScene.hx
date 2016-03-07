package ikutil.scene;

import flambe.Component;
import flambe.Entity;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.scene.Scene;
import flambe.util.Promise;
import flambe.util.Signal2;
import ikutil.util.*;

// TODO:  Clean this up...

/**
 * @brief      A component that displays a loading bar and optional logo while loading a main AssetPack.
 */
class PreloaderScene extends Component {
	/**
	 * Signals when the main pack was loaded.
	 */
	public var onPackLoaded:Signal2<String, AssetPack>;

	/**
	 * @brief      Instantiates the Scene, initializing the loading of the AssetPacks.
	 *
	 * @param      packMain      The name of the main AssetPack to load.  onPackLoaded is called when completed.
	 * @param      packPreload   Optional preloader AssetPack to load.  This pack MUST contain an image asset named "logo".
	 * @param      onPackLoaded  Optional callback.  This is fired once the main AssetPack is loaded.
	 */
	public function new(packMain:String, ?packPreload:String = null, ?onPackLoaded:String -> AssetPack -> Void = null) {
		super();

		this.onPackLoaded = new Signal2<String, AssetPack>();
		if(onPackLoaded != null)
			this.onPackLoaded.connect(onPackLoaded);

		_packName = packMain;

		if(packPreload != null) {
			_preloadManifest = Manifest.fromAssets(packPreload, true);
		}

	    _scaler = new GameScaler(640, 960);
	    _bg = new FillSprite(0xCC00CC, System.stage.width, System.stage.height);
	    _barBG = new FillSprite(0xCCCCCC, _scaler.width * 0.8, 30);
	    _barFill = new FillSprite(0xFFFFFF, _barBG.width._ - 10, _barBG.height._ - 10);
	}

	override public function onStart():Void {
	    if(_preloadManifest != null) {
			_preloaderPromise = System.loadAssetPack(_preloadManifest);
			_preloaderPromise.get(onPreloadComplete);
		}
	    else {
	    	loadMain();
	    }

	    owner.add(_bg);
	    owner.addChild(new Entity()
	    	.add(_scaler)
	    );

	    loadMain();
	}

	/**
	 * @brief      Sets the colors of this PreloaderScene.
	 *
	 * @param      background     The color of the background.
	 * @param      barBackground  The color of the loading bar background.
	 * @param      barFill        The color of the loading bar fill.
	 */
	public function setColors(background:Int = 0, barBackground:Int = 0x333333, barFill:Int = 0xFFFFFF):Void {
	    _bg.color = background;
	    _barBG.color = barBackground;
	    _barFill.color = barFill;
	}

	private function loadMain():Void {
	    _barBG.centerAnchor();
	    _barBG.setXY(_scaler.width * 0.5, _scaler.height * 0.7);
	    _scaler.owner.addChild(new Entity()
	    	.add(_barBG)
	    );

	    _barFill.setXY(5, 5);
	    _barFill.width._ = 0;
	    _barBG.owner.addChild(new Entity()
	    	.add(_barFill)
	    );

		var manifest = Manifest.fromAssets(_packName, true);
		_packPromise = System.loadAssetPack(manifest);
		_packPromise.get(onSuccess);
		_packPromise.progressChanged.connect(onProgressChanged);
	}

	private function onSuccess(pack:AssetPack):Void {
		onPackLoaded.emit(_packName, pack);
	}

	private function onProgressChanged():Void {
		_barFill.width._ = _packPromise.progress / _packPromise.total * (_barBG.width._ - 10);
	}

	private function onPreloadComplete(pack:AssetPack):Void {
	    var logo = new ImageSprite(pack.getTexture("logo", true));
	    logo.centerAnchor()
	    	.setXY(_scaler.width * 0.5, _scaler.height * 0.25);
	    _scaler.owner.addChild(new Entity()
	    	.add(logo)
	    );
	}

	private var _scaler:GameScaler;
	private var _preloadManifest:Manifest;
	private var _preloaderPromise:Promise<AssetPack>;

	private var _packName:String;
	private var _packPromise:Promise<AssetPack>;

	private var _bg:FillSprite;
	private var _barBG:FillSprite;
	private var _barFill:FillSprite;
}