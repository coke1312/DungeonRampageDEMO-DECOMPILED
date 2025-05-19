package Brain.Logger
{
   import Brain.Clock.GameClock;
   import com.junkbyte.console.Cc;
   import com.junkbyte.console.KeyBind;
   import flash.display.Stage;
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   
   public class Logger
   {
      
      private static var mReentrentLock:Boolean = false;
      
      private static var mWantConsole:Boolean = false;
      
      private static var mWantCommandLine:Boolean = false;
      
      private static var mWantThrowErrors:Boolean = true;
      
      private static var mShowDebug:Boolean = true;
      
      private static var mShowInfo:Boolean = true;
      
      public static var errorCallback:Function;
      
      public static var customLoggerString:String;
      
      private static var mListSlashCommands:Array = [];
      
      public function Logger()
      {
         super();
      }
      
      public static function init(param1:Stage, param2:Boolean = false) : void
      {
         mWantConsole = param2;
         if(mWantConsole)
         {
            Cc.startOnStage(param1,"0");
         }
      }
      
      public static function displayConsole() : void
      {
         Cc.visible = true;
      }
      
      public static function hideConsole() : void
      {
         Cc.visible = false;
      }
      
      public static function isConsoleVisible() : Boolean
      {
         if(Cc.visible)
         {
            return true;
         }
         return false;
      }
      
      public static function enableCommandLine() : void
      {
         mWantCommandLine = true;
         Cc.config.commandLineAllowed = mWantCommandLine;
         mShowDebug = true;
         mShowInfo = true;
      }
      
      public static function setDebugMessages(param1:Boolean) : void
      {
         mShowDebug = param1;
      }
      
      public static function setInfoMessages(param1:Boolean) : void
      {
         mShowInfo = param1;
      }
      
      public static function addSlashCommand(param1:String, param2:Function, param3:String = "", param4:Boolean = true) : void
      {
         Cc.addSlashCommand(param1,param2,param3,param4);
         mListSlashCommands.push(param1);
      }
      
      public static function listSlashCommands() : void
      {
         for each(var _loc1_ in mListSlashCommands)
         {
            log(_loc1_);
         }
      }
      
      public static function bindKey(param1:KeyBind, param2:Function, param3:Array = null) : void
      {
         Cc.bindKey(param1,param2,param3);
      }
      
      public static function set CustomLoggerString(param1:String) : void
      {
         customLoggerString = param1;
      }
      
      private static function pad(param1:Number, param2:uint) : String
      {
         var _loc3_:String = param1.toString();
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
      
      public static function set errorsCanThrow(param1:Boolean) : void
      {
         mWantThrowErrors = param1;
      }
      
      public static function get errorsCanThrow() : Boolean
      {
         return mWantThrowErrors;
      }
      
      protected static function getDateString() : String
      {
         var _loc1_:Date = GameClock.date;
         return "[" + _loc1_.fullYear + "-" + pad(_loc1_.month + 1,2) + "-" + pad(_loc1_.date,2) + " " + pad(_loc1_.hours,2) + ":" + pad(_loc1_.minutes,2) + ":" + pad(_loc1_.seconds,2) + "." + pad(_loc1_.milliseconds,3) + "] ";
      }
      
      public static function log(param1:String) : void
      {
         param1 = "" + param1;
         trace(param1);
         if(mWantConsole)
         {
            Cc.log(param1);
         }
      }
      
      public static function debug(param1:String) : void
      {
         if(!mShowDebug || customLoggerString != null)
         {
            return;
         }
         param1 = "[DEBUG] " + getDateString() + param1;
         trace(param1);
         if(mWantConsole)
         {
            Cc.debug(param1);
         }
      }
      
      public static function info(param1:String) : void
      {
         if(!mShowInfo)
         {
            return;
         }
         param1 = "[INFO]  " + getDateString() + param1;
         trace(param1);
         if(mWantConsole)
         {
            Cc.info(param1);
         }
      }
      
      public static function warn(param1:String) : void
      {
         if(customLoggerString != null)
         {
            return;
         }
         param1 = "[WARN]  " + getDateString() + param1;
         trace(param1);
         if(mWantConsole)
         {
            Cc.warn(param1);
         }
      }
      
      public static function error(param1:String, param2:Error = null) : void
      {
         var _loc5_:Error = param2 ? param2 : new Error(param1);
         var _loc4_:String = _loc5_.hasOwnProperty("getStackTrace") ? _loc5_.getStackTrace() : null;
         var _loc3_:String = _loc4_ ? param1 + "\n" + _loc4_ : param1;
         tryErrorCallback(_loc3_);
         param1 = "[ERROR] " + getDateString() + _loc3_;
         trace(param1);
         if(mWantConsole)
         {
            Cc.error(param1);
         }
         if(mWantThrowErrors && Capabilities.isDebugger)
         {
            displayConsole();
            Cc.minimumPriority = 8;
            _loc5_.name = "LOGGED " + _loc5_.name;
            throw _loc5_;
         }
      }
      
      private static function tryErrorCallback(param1:String) : void
      {
         if(errorCallback != null && !mReentrentLock)
         {
            mReentrentLock = true;
            errorCallback(param1);
            mReentrentLock = false;
         }
      }
      
      public static function fatal(param1:String, param2:Error = null) : void
      {
         var _loc6_:Error = param2 ? param2 : new Error(param1);
         var _loc4_:String = _loc6_.hasOwnProperty("getStackTrace") ? _loc6_.getStackTrace() : null;
         param1 = "[FATAL] " + getDateString() + param1;
         var _loc3_:String = param1 + "\n" + _loc4_;
         trace(_loc3_);
         var _loc5_:XML = <script>
					<![CDATA[
						function reloadPage()
						{
							window.location.reload(true);
						}				
					]]>
			</script>;
         if(ExternalInterface.available)
         {
            ExternalInterface.call(_loc5_);
            ExternalInterface.call("reloadPage");
         }
         if(mWantConsole)
         {
            displayConsole();
            Cc.minimumPriority = 8;
            Cc.height = 250;
            Cc.warn(_loc3_);
            Cc.fatal(param1);
            Cc.warn("If you are reporting this error please click \'Sv\' at the top to copy the logs to your clipboard");
         }
         tryErrorCallback(param1);
         if(mWantThrowErrors)
         {
            _loc6_.name = "LOGGED " + _loc6_.name;
            throw _loc6_;
         }
      }
      
      public static function reloadPage() : void
      {
         var _loc1_:XML = <script>
					<![CDATA[
						function reloadPage()
						{
							window.location.reload(true);
						}				
					]]>
			</script>;
         if(ExternalInterface.available)
         {
            ExternalInterface.call(_loc1_);
            ExternalInterface.call("reloadPage");
         }
      }
      
      public static function custom(param1:String, param2:String) : void
      {
         if(customLoggerString != param1)
         {
            return;
         }
         param2 = "[" + customLoggerString + "]  " + getDateString() + param2;
         trace(param2);
         if(mWantConsole)
         {
            Cc.warn(param2);
         }
      }
   }
}

