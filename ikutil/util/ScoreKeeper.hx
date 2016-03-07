package ikutil.util;

import flambe.System;
import flambe.util.Value;
import flambe.util.Signal0;

enum ScoreDirection {
	up;
	down;
}

/**
 * @brief      Utilty class to keep track of score and store it in the System.storage.
 */
class ScoreKeeper {
	/**
	 * The games current score.
	 */
	public var score(default, null):Value<Int>;

	/**
	 * The games current high score.
	 */
	public var highScore(get, never):Int;

	/**
	 * Triggered when the games score is reset with resetScore().
	 */
	public var onScoreReset(default, null):Signal0;

	/**
	 * @brief      Creates a new ScoreKeeper...
	 *
	 * @param      value      The initial value of the score.
	 * @param      direction  The direction the score "counts".
	 */
	public function new(value:Int = 0, direction:ScoreDirection = null) {
	    _direction = direction == null ? ScoreDirection.up : direction;
	    _highScore = System.storage.get("HighScore", 0);

	    score = new Value<Int>(value);

	    onScoreReset = new Signal0();
	}

	/**
	 * @brief      Add to the score.
	 *
	 * @param      The value to add to the score.
	 */
	public function addScore(value:Int):Void {
	    score._ += value;
	}

	/**
	 * @brief      Subract from the score.
	 *
	 * @param      The value to subtract from the score.
	 */
	public function subtractScore(value:Int):Void {
	    score._ -= value;
	}

	/**
	 * @brief      Resets the score to the desired value, triggereing onScoreReset.
	 *
	 * @param      value  { parameter_description }
	 *
	 * @return     { description_of_the_return_value }
	 */
	public function resetScore(value:Int = 0):Void {
	    onScoreReset.emit();
	    
	    score._ = value;
	}

	/**
	 * @brief      Checks if the current score is a high score.
	 *
	 * @return     Returns true if the score is a high score.
	 */
	public function checkHighScore():Bool {
	    switch (_direction) {
	    	case ScoreDirection.up:
	    		return score._ > _highScore;

	    	case ScoreDirection.down:
	    		return score._ < _highScore;
	    }

	    return false;
	}

	/**
	 * @brief      Sets the current score as the high score in System.storage.
	 *
	 * @return     True if the high score was set.
	 */
	public function setHighScore():Bool {
		if(!checkHighScore())
			return false;

		_highScore = score._;
		System.storage.set("HighScore", score._);

		return true;
	}

	private function get_highScore():Int {
	    return _highScore;
	}

	private var _direction:ScoreDirection;
	private var _highScore:Int;
}