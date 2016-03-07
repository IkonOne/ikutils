package ikutil.util;

import flambe.util.Config;

/**
 * @brief      Extension methods for working with Configs.
 */
class ConfigUtil {
	/**
	 * @brief      Gets the named Int from the config.
	 *
	 * @param      config  The config from which to load the Int.
	 * @param      path    The path to the Int.
	 *
	 * @return     The value of the requested Int.
	 */
	public static function getInt(config:Config, path:String):Int {
	    return Std.parseInt(config.get(path));
	}

	/**
	 * @brief      Gets the named Float from the config.
	 *
	 * @param      config  The config from which to load the Float.
	 * @param      path    The path to the Float.
	 *
	 * @return     The value of the requested Float.
	 */
	public static function getFloat(config:Config, path:String):Float {
	    return Std.parseFloat(config.get(path));
	}

	/**
	 * @brief      Gets an Int from an array within a config.
	 *
	 * @param      config  The config from which to load the Int.
	 * @param      path    The path to the array within the config.
	 * @param      index   The index of the Int within the array.
	 *
	 * @return     The value of the requested Int.
	 */
	public static function getArrayInt(config:Config, path:String, index:Int):Int {
	    return Std.parseInt(config.get(path).split(",")[index]);
	}

	/**
	 * @brief      Gets a Float from an array within a config.
	 *
	 * @param      config  The config from which to load the Float.
	 * @param      path    The path to the array within the config.
	 * @param      index   The index of the Float within the array.
	 *
	 * @return     The value of the requested Float.
	 */
	public static function getArrayFloat(config:Config, path:String, index:Int):Float {
	    return Std.parseFloat(config.get(path).split(",")[index]);
	}
}