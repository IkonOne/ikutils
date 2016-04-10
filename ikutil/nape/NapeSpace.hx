package ikutil.nape;

import flambe.Component;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.space.Space;
import ikutil.nape.NapeBody;

class NapeSpace extends Component {
	public var space(default, null):Space;

	public var velocityIterations:Int = 10;
	public var positionIterations:Int = 10;

	public function new(?gravity:Vec2) {
	    space = new Space(gravity);
	}

	override public function onUpdate(dt:Float):Void {
	    space.step(dt, velocityIterations, positionIterations);
	}

	public function addBody(napeBody:NapeBody):NapeSpace {
		napeBody.body.space = space;
		return this;
	}

	public function createCircle(x:Int = 0, y:Int = 0, radius:Float = 16, type:BodyType = null):NapeBody {
		var b = new NapeBody(x, y, type);
		b.body.shapes.add(new Circle(radius));

		return b;
	}
}