package ikutil.nape;

import flambe.Component;
import flambe.display.Sprite;
import flambe.math.FMath;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;

class NapeBody extends Component {
	public var body(default, null):Body;

	public function new(?x:Int, ?y:Int, ?type:BodyType) {
		body = new Body(
			(type != null ? type : null),
			(x != null & y != null ? new Vec2(x, y) : null)
		);
	}

	override public function onAdded():Void {
	    body.userData.owner = owner;
	}

	override public function onUpdate(dt:Float):Void {
	    if(owner.has(Sprite)) {
	    	var spr = owner.get(Sprite);
	    	spr.x._ = body.position.x;
	    	spr.y._ = body.position.y;
	    	spr.rotation._ = FMath.toDegrees(body.rotation);
	    }
	}

	override public function onRemoved():Void {
	    body.space = null;
	    body.userData.owner = null;
	}
}