package ikutil.util;

import flambe.asset.File;
import flambe.util.Signal0;
import haxe.Json;

/**
 * @brief      Class to facilitate live config reloading using Json.
 */
class LiveJsonAsset {
	/**
	 * Called each time the Json asset is reloaded.
	 */
	public var onReload:Signal0;

	/**
	 * @brief      Creates a new LiveJsonAsset...
	 *
	 * @param      file  The File asset to be tracked.
	 */
	public function new(file:File) {
	    _file = file;

	    _data = Json.parse(_file.toString());
	    onReload = new Signal0();

	    _file.reloadCount.watch(onFileReloaded);
	}

	/**
	 * @brief      Get a Dynamic value from the config.  Excellent when used in conjunction with a typedef.
	 *
	 * @param      value     Value to retrieve fromthe config.
	 *
	 * @return     { description_of_the_return_value }
	 */
	public function getValue(value:String):Dynamic {
		return Reflect.field(_data, value);
	}

	public function getInt(value:String):Int {
	    return Std.parseInt(getValue(value));
	}

	public function getFloat(value:String):Float {
	    return Std.parseFloat(getValue(value));
	}

	private function onFileReloaded(current:Int, previous:Int):Void {
		_data = Json.parse(_file.toString());
	    onReload.emit();
	}

	var _file:File;
	var _data:Dynamic;
}