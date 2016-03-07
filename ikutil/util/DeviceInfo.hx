package ikutil.util;

import js.Browser;
import js.html.DOMWindow;

/**
 * @brief      Used to determine what type of device the program is running on.  (Currently only implemented for Javascript)
 */
class DeviceInfo {

    public static var instance(get, never):DeviceInfo;
    private static var _instance:DeviceInfo;
    private static function get_instance():DeviceInfo {
        if(_instance == null)
            _instance = new DeviceInfo();

        return _instance;
    }

	public var vita(default, null):Bool = false;
	public var kindle(default, null):Bool = false;
	public var android(default, null):Bool = false;
	public var chromeOS(default, null):Bool = false;
	public var iOS(default, null):Bool = false;
	public var iOSVersion(default, null):Int = -1;
	public var linux(default, null):Bool = false;
	public var macOS(default, null):Bool = false;
	public var windows(default, null):Bool = false;
	public var windowsPhone(default, null):Bool = false;
	public var desktop(default, null):Bool = false;
    public var mobile(default, null):Bool = false;

	private function new() {
	    checkOS();
	}

	private function checkOS():Void {
		var navigator = Browser.navigator;
	    var ua = navigator.userAgent;

	    if (~/Playstation Vita/.match(ua))
        {
            vita = true;
        }
        else if (~/Kindle/.match(ua) || ~/\bKF[A-Z][A-Z]+/.match(ua) || ~/Silk.*Mobile Safari/.match(ua))
        {
            kindle = true;
            // This will NOT detect early generations of Kindle Fire, I think there is no reliable way...
            // E.g. "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; en-us; Silk/1.1.0-80) AppleWebKit/533.16 (KHTML, like Gecko) Version/5.0 Safari/533.16 Silk-Accelerated=true"
        }
        else if (~/Android/.match(ua))
        {
            android = true;
        }
        else if (~/CrOS/.match(ua))
        {
            chromeOS = true;
        }
        else if (~/iP[ao]d|iPhone/i.match(ua))
        {
            iOS = true;
            // (navigator.appVersion).match(~/OS (\d+)/);
            // iOSVersion = parseInt(RegExp.$1, 10);
        }
        else if (~/Linux/.match(ua))
        {
            linux = true;
        }
        else if (~/Mac OS/.match(ua))
        {
            macOS = true;
        }
        else if (~/Windows/.match(ua))
        {
            windows = true;
        }

        if (~/Windows Phone/i.match(ua) || ~/IEMobile/i.match(ua))
        {
            android = false;
            iOS = false;
            macOS = false;
            windows = true;
            windowsPhone = true;
        }

        var silk = ~/Silk/.match(ua); // detected in browsers

        if (windows || macOS || (linux && !silk) || chromeOS)
        {
            desktop = true;
        }

        //  Windows Phone / Table reset
        if (windowsPhone || ((~/Windows NT/i.match(ua)) && (~/Touch/i.match(ua))))
        {
            desktop = false;
        }

        if(android || iOS || windowsPhone)
        {
            mobile = true;
        }
	}
}