package Brain.Clock
{
   import com.greensock.TweenMax;
   import flash.utils.getTimer;
   
   public class GameClock
   {
      
      protected static var mServerTimeOffset:Number = 0;
      
      private static var mWebServerTimeString:String = "";
      
      private static var mWebServerDate:Date;
      
      private static var mWebServerLocalStartDate:Date;
      
      private static var mWebServerPingStartTime:Number = 0;
      
      private static var mWebServerPingTime:Number = 0;
      
      private static var mEpochDuration:int = 604800;
      
      private static var mEpochOffset:int = 0;
      
      private static var mUserTimeOffset:int = 0;
      
      private static var mTimeMinutes:int = 60;
      
      private static var mTimeHours:int = mTimeMinutes * 60;
      
      private static var mTimeDays:int = mTimeHours * 24;
      
      private static var mTimeWeeks:int = mTimeDays * 7;
      
      protected var mRealTimeLastFrame:int;
      
      protected var mRealTime:int = 0;
      
      protected var mTimeScale:Number = 1;
      
      protected var mGameTime:int = 0;
      
      protected var mTickLength:Number;
      
      protected var mFrame:uint = 0;
      
      public function GameClock(param1:Number)
      {
         super();
         mTickLength = param1;
         mRealTimeLastFrame = -1;
         mFrame = 0;
      }
      
      public static function parseW3CDTF(param1:String, param2:Boolean = false) : Date
      {
         var _loc4_:Date = null;
         var _loc8_:String = null;
         var _loc14_:String = null;
         var _loc19_:Array = null;
         var _loc10_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc22_:String = null;
         var _loc21_:Array = null;
         var _loc18_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc16_:Array = null;
         var _loc15_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc7_:String = null;
         try
         {
            _loc8_ = param1.substring(0,param1.indexOf("T"));
            _loc14_ = param1.substring(param1.indexOf("T") + 1,param1.length);
            _loc19_ = _loc8_.split("-");
            _loc10_ = Number(_loc19_.shift());
            _loc17_ = Number(_loc19_.shift());
            _loc3_ = Number(_loc19_.shift());
            if(_loc14_.indexOf("Z") != -1)
            {
               _loc12_ = 1;
               _loc20_ = 0;
               _loc6_ = 0;
               _loc14_ = _loc14_.replace("Z","");
            }
            else if(_loc14_.indexOf("+") != -1)
            {
               _loc12_ = 1;
               _loc22_ = _loc14_.substring(_loc14_.indexOf("+") + 1,_loc14_.length);
               _loc20_ = Number(_loc22_.substring(0,_loc22_.indexOf(":")));
               _loc6_ = Number(_loc22_.substring(_loc22_.indexOf(":") + 1,_loc22_.length));
               _loc14_ = _loc14_.substring(0,_loc14_.indexOf("+"));
            }
            else
            {
               _loc12_ = -1;
               _loc22_ = _loc14_.substring(_loc14_.indexOf("-") + 1,_loc14_.length);
               _loc20_ = Number(_loc22_.substring(0,_loc22_.indexOf(":")));
               _loc6_ = Number(_loc22_.substring(_loc22_.indexOf(":") + 1,_loc22_.length));
               _loc14_ = _loc14_.substring(0,_loc14_.indexOf("-"));
            }
            _loc21_ = _loc14_.split(":");
            _loc18_ = Number(_loc21_.shift());
            _loc13_ = Number(_loc21_.shift());
            _loc16_ = _loc21_.length > 0 ? String(_loc21_.shift()).split(".") : null;
            _loc15_ = _loc16_ != null && _loc16_.length > 0 ? Number(_loc16_.shift()) : 0;
            _loc5_ = _loc16_ != null && _loc16_.length > 0 ? 1000 * parseFloat("0." + _loc16_.shift()) : 0;
            _loc11_ = Date.UTC(_loc10_,_loc17_ - 1,_loc3_,_loc18_,_loc13_,_loc15_,_loc5_);
            _loc9_ = (_loc20_ * 3600000 + _loc6_ * 60000) * _loc12_;
            if(param2)
            {
               _loc4_ = new Date();
               _loc4_.fullYear = _loc10_;
               _loc4_.month = _loc17_ - 1;
               _loc4_.date = _loc3_;
               _loc4_.hours = _loc18_;
               _loc4_.minutes = _loc13_;
               _loc4_.seconds = _loc15_;
               _loc4_.milliseconds = _loc5_;
            }
            else
            {
               _loc4_ = new Date(_loc11_ - _loc9_);
            }
            if(_loc4_.toString() == "Invalid Date")
            {
               throw new Error("This date does not conform to W3CDTF.");
            }
         }
         catch(e:Error)
         {
            _loc7_ = "Unable to parse the string [" + param1 + "] into a date. ";
            _loc7_ = _loc7_ + ("The internal error was: " + e.toString());
            throw new Error(_loc7_);
         }
         return _loc4_;
      }
      
      public static function toW3CDTF(param1:Date, param2:Boolean = false, param3:Boolean = true) : String
      {
         var _loc4_:Number = Number(param1.getUTCDate());
         var _loc8_:Number = Number(param1.getUTCMonth());
         var _loc6_:Number = Number(param1.getUTCHours());
         var _loc9_:Number = Number(param1.getUTCMinutes());
         var _loc7_:Number = Number(param1.getUTCSeconds());
         var _loc5_:Number = Number(param1.getUTCMilliseconds());
         var _loc10_:String = new String();
         _loc10_ = _loc10_ + param1.getUTCFullYear();
         _loc10_ = _loc10_ + "-";
         if(_loc8_ + 1 < 10)
         {
            _loc10_ += "0";
         }
         _loc10_ += _loc8_ + 1;
         _loc10_ = _loc10_ + "-";
         if(_loc4_ < 10)
         {
            _loc10_ += "0";
         }
         _loc10_ += _loc4_;
         _loc10_ = _loc10_ + "T";
         if(_loc6_ < 10)
         {
            _loc10_ += "0";
         }
         _loc10_ += _loc6_;
         _loc10_ = _loc10_ + ":";
         if(_loc9_ < 10)
         {
            _loc10_ += "0";
         }
         _loc10_ += _loc9_;
         _loc10_ = _loc10_ + ":";
         if(_loc7_ < 10)
         {
            _loc10_ += "0";
         }
         _loc10_ += _loc7_;
         if(param2 && _loc5_ > 0)
         {
            _loc10_ += ".";
            _loc10_ = _loc10_ + _loc5_;
         }
         if(param3)
         {
            _loc10_ += "-00:00";
         }
         return _loc10_;
      }
      
      public static function get date() : Date
      {
         var _loc1_:Date = new Date();
         var _loc2_:Number = _loc1_.getTime() + mServerTimeOffset;
         _loc1_.setTime(_loc2_);
         return _loc1_;
      }
      
      public static function get serverTimeOffset() : Number
      {
         return mServerTimeOffset;
      }
      
      public static function computeServerTimeOffset(param1:Date) : void
      {
         var _loc2_:Date = new Date();
         var _loc3_:int = param1.getTime() - _loc2_.getTime();
         mServerTimeOffset = _loc3_;
      }
      
      public static function getWebServerTime() : Number
      {
         if(mWebServerLocalStartDate == null)
         {
            return 0;
         }
         var _loc2_:Date = new Date();
         var _loc1_:Number = _loc2_.getTime() - mWebServerLocalStartDate.getTime();
         var _loc3_:Date = new Date();
         _loc3_.setTime(mWebServerDate.getTime() + _loc1_);
         return mWebServerDate.getTime() + _loc1_ + mUserTimeOffset;
      }
      
      public static function getEpoch() : Number
      {
         var _loc1_:int = Math.floor(getWebServerTime() / 1000);
         var _loc2_:int = 0;
         return int((_loc1_ + mEpochOffset) / mEpochDuration);
      }
      
      public static function getTimeToEpoch() : Number
      {
         var _loc3_:int = getEpoch() + 1;
         var _loc4_:int = _loc3_ * mEpochDuration - mEpochOffset;
         var _loc1_:int = Math.floor(getWebServerTime() / 1000);
         return _loc4_ - _loc1_;
      }
      
      public static function getArrayTimeToEpoch() : Array
      {
         var _loc2_:Number = getTimeToEpoch();
         var _loc1_:int = Math.floor(_loc2_ / mTimeWeeks);
         _loc2_ -= _loc1_ * mTimeWeeks;
         var _loc5_:int = Math.floor(_loc2_ / mTimeDays);
         _loc2_ -= _loc5_ * mTimeDays;
         var _loc3_:int = Math.floor(_loc2_ / mTimeHours);
         _loc2_ -= _loc3_ * mTimeHours;
         var _loc4_:int = Math.floor(_loc2_ / mTimeMinutes);
         _loc2_ -= _loc4_ * mTimeMinutes;
         var _loc6_:int = _loc2_;
         return new Array(_loc6_,_loc4_,_loc3_,_loc5_,_loc1_);
      }
      
      public static function getWebServerDate() : Date
      {
         if(mWebServerLocalStartDate == null)
         {
            return null;
         }
         var _loc3_:Date = new Date();
         var _loc1_:Number = _loc3_.getTime() - mWebServerLocalStartDate.getTime();
         var _loc2_:Date = new Date();
         _loc2_.setTime(mWebServerDate.getTime() + _loc1_ + mUserTimeOffset);
         return _loc2_;
      }
      
      public static function getWebServerTimeStamp() : String
      {
         if(mWebServerLocalStartDate == null)
         {
            return "not set";
         }
         return toW3CDTF(getWebServerDate(),false,false);
      }
      
      public static function startSetWebServerTime() : void
      {
         var _loc1_:Date = new Date();
         mWebServerPingStartTime = _loc1_.getTime();
      }
      
      public static function finishSetWebServerTime(param1:Array) : void
      {
         var _loc2_:String = param1[0];
         mEpochDuration = param1[1];
         mEpochOffset = param1[2];
         var _loc3_:Date = new Date();
         mWebServerPingTime = _loc3_.getTime() - mWebServerPingStartTime;
         mWebServerLocalStartDate = new Date();
         mWebServerLocalStartDate.setTime(_loc3_.getTime() - mWebServerPingTime * 0.5);
         mWebServerTimeString = _loc2_;
         mWebServerDate = parseW3CDTF(_loc2_,true);
      }
      
      public static function setUserWebOffset(param1:int, param2:int, param3:int) : void
      {
         mUserTimeOffset = (param3 * 60 + param2 * 60 * 60 + param1 * 24 * 60 * 60) * 1000;
      }
      
      public function initTime() : void
      {
         mRealTime = getTimer();
         mRealTimeLastFrame = mRealTime;
      }
      
      public function update() : Number
      {
         mRealTime = getTimer();
         mFrame++;
         var _loc1_:Number = (mRealTime - mRealTimeLastFrame) * this.timeScale / 1000;
         mRealTimeLastFrame = mRealTime;
         return _loc1_;
      }
      
      public function get timeScale() : Number
      {
         return mTimeScale;
      }
      
      public function set timeScale(param1:Number) : void
      {
         mTimeScale = Math.min(10,Math.max(0.1,param1));
         TweenMax.globalTimeScale = mTimeScale;
      }
      
      public function get gameTime() : int
      {
         return mGameTime;
      }
      
      public function set gameTime(param1:int) : void
      {
         mGameTime = param1;
      }
      
      public function get frame() : uint
      {
         return mFrame;
      }
      
      public function get realTime() : int
      {
         return mRealTime;
      }
      
      public function get tickLength() : Number
      {
         return mTickLength * mTimeScale;
      }
   }
}

