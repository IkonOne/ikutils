package ikutil.fsm;

import ikutil.fsm.StateMachine;

interface IState {
	public var machine(default, null):StateMachine;
	public function onStart(machine:StateMachine):Void;
	public function onUpdate(dt:Float):Void;
	public function onStop():Void;
}