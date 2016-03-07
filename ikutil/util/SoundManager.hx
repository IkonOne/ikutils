package ikutil.util;

import flambe.asset.AssetPack;
import flambe.sound.Sound;
import flambe.sound.Mixer;

typedef SoundDef = {
	var name:String;
	var volume:Float;
	var poolFunc:Void -> Sound;
}

/**
 * @brief      Manages game sound through the creation of definitions.
 */
class SoundManager {
	/**
	 * If the SFX are muted or not.
	 */
	public var mute(get, set):Bool;

	/**
	 * The music Sound object.
	 */
	public var music(default, null):Sound;

	/**
	 * @brief      Creates a new SoundManager
	 *
	 * @param      pack         AssetPack that contains the games sounds.
	 * @param      music        Name of the music sound.
	 * @param      musicVolume  Volume at which to play the music.
	 */
	public function new(pack:AssetPack, music:String = "", musicVolume:Float = 1) {
		_pack = pack;

		if(music != "") {
			this.music = pack.getSound(music);
			this.music.loop(musicVolume);
		}

		_sounds = new Map<String, SoundDef>();
	}

	/**
	 * @brief      Adds a new sound effect definition.
	 *
	 * @param      name       Name of the sound effect.
	 * @param      soundName  Name of the sound effect in the AssetPack.
	 * @param      volume     Volume to play the sound.
	 *
	 * @return     Returns this SoundManager (for chaining).
	 */
	public function addSound(name:String, soundName:String, volume:Float = 1):SoundManager {
	    var def = {
	    	name : name,
	    	volume : volume,
	    	poolFunc : function () {
	    		return _pack.getSound(soundName);
	    	}
	    }

	    _sounds.set(name, def);

	    return this;
	}

	/**
	 * @brief      Plays the sound effect with the given name.
	 *
	 * @param      name  Name of the sound effect to play.
	 *
	 * @return     Returns this SoundManager (for chaining).
	 */
	public function playSound(name:String):SoundManager {
		if(mute)
			return this;

		var def = _sounds.get(name);
		def.poolFunc().play(def.volume);

	    return this;
	}

	private function get_mute():Bool {
	    return _mute;
	}

	private function set_mute(value:Bool):Bool {
	    if(value == _mute)
	    	return _mute;

	    _mute = value;

	    return _mute;
	}

	var _pack:AssetPack;
	var _sounds:Map<String, SoundDef>;
	var _mute:Bool = false;
}