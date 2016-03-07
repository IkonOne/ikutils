package ikutil.ui;

import ikutil.util.ScoreKeeper;
import flambe.Component;
import flambe.Entity;
import flambe.display.TextSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.FillSprite;
import flambe.display.Texture;
import flambe.display.Font;

/**
 * @brief      A label that displays the score in conjuction with a ScoreKeeper.
 */
class ScoreLabel extends Component {
	/**
	 * The text label.
	 */
	public var label(default, null):TextSprite;

	/**
	 * The padding of the label within a background.
	 */
	public var padding:Float;

	/**
	 * @brief      Creates a new ScoreLabel
	 *
	 * @param      scoreKeeper  The ScoreKeepr to used to track the score.
	 * @param      font         The font to use for the text label.
	 * @param      padding      The padding of the text within a sprite background.
	 */
	public function new(scoreKeeper:ScoreKeeper, font:Font, padding:Float = 20) {
	    _scoreKeeper = scoreKeeper;
	    _scoreKeeper.score.changed.connect(onScoreChanged);

	    this.padding = padding;

	    label = new TextSprite(font, "0");
	    label.pixelSnapping = true;
	    label.setAlign(TextAlign.Right);
	}

	override public function onStart():Void {
	    owner.add(label);
	    var background = owner.parent.get(Sprite);
	    label.x._ = background.getNaturalWidth() - padding;
	    label.y._ = background.getNaturalHeight() / 2 - label.getNaturalHeight() / 2;
	}

	private function onScoreChanged(newScore:Int, oldScore:Int):Void {
		label.text = Std.string(newScore);
	}

	private var _scoreKeeper:ScoreKeeper;

	private var _lblEnt:Entity;
	private var _bgEnt:Entity;
}