package ikutil.swf;

import flambe.display.Sprite;
import flambe.input.PointerEvent;
import flambe.swf.MovieSprite;

/**
 * @brief      A collection of extension methods to be used with the flambe.swf.* clases.
 */
class FlumpUtil {
	/**
	 * @brief      Adds a callback to a given layer of a Flump Movie.
	 *
	 * @param      sprite    The MovieSprite to add the callback to.
	 * @param      layer     The layer of the MovieSprite that should receive the callback.
	 * @param      callback  The callback...
	 *
	 * @return     The MovieSprite passed in the parameters (for chaining).
	 */
	public static function createButton(sprite:MovieSprite, layer:String, callback:PointerEvent -> Void):MovieSprite {
	    var e = sprite.getLayer(layer);
	    var spr = e.get(Sprite);
	    spr.pointerDown.connect(callback);

	    return sprite;
	}
}