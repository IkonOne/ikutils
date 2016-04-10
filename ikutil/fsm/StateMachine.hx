package ikutil.fsm;

import flambe.Component;
import flambe.util.Value;
import ikutil.fsm.IState;

class StateMachine {
	public var current:Value<IState>;

	public function new() {
	    current = new Value<IState>(null);
	}

	public function onUpdate(dt:Float):Void {
	    if(_next != null) {
	    	// switch state
	    	if(current._ != null)
	    		current._.onStop();

	    	current._ = _next;
	    	_next = null;
	    	current._.onStart(this);
	    	current._.onUpdate(dt);
	    }

	    if(current._ != null)
	    	current._.onUpdate(dt);
	}

	public function switchState(next:IState):Void {
	    if(current._ == next)
	    	return;

	    _next = next;
	}

	var _next:IState;
}