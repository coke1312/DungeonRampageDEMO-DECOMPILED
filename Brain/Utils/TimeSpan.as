package Brain.Utils
{
   public class TimeSpan
   {
      
      public static const MILLISECONDS_IN_DAY:Number = 86400000;
      
      public static const MILLISECONDS_IN_HOUR:Number = 3600000;
      
      public static const MILLISECONDS_IN_MINUTE:Number = 60000;
      
      public static const MILLISECONDS_IN_SECOND:Number = 1000;
      
      private var _totalMilliseconds:Number;
      
      public function TimeSpan(param1:Number)
      {
         super();
         _totalMilliseconds = Math.floor(param1);
      }
      
      public static function fromDates(param1:Date, param2:Date) : TimeSpan
      {
         return new TimeSpan(param2.time - param1.time);
      }
      
      public static function fromMilliseconds(param1:Number) : TimeSpan
      {
         return new TimeSpan(param1);
      }
      
      public static function fromSeconds(param1:Number) : TimeSpan
      {
         return new TimeSpan(param1 * 1000);
      }
      
      public static function fromMinutes(param1:Number) : TimeSpan
      {
         return new TimeSpan(param1 * 60000);
      }
      
      public static function fromHours(param1:Number) : TimeSpan
      {
         return new TimeSpan(param1 * 3600000);
      }
      
      public static function fromDays(param1:Number) : TimeSpan
      {
         return new TimeSpan(param1 * 86400000);
      }
      
      public function get days() : int
      {
         return int(_totalMilliseconds / 86400000);
      }
      
      public function get hours() : int
      {
         return int(_totalMilliseconds / 3600000) % 24;
      }
      
      public function get minutes() : int
      {
         return int(_totalMilliseconds / 60000) % 60;
      }
      
      public function get seconds() : int
      {
         return int(_totalMilliseconds / 1000) % 60;
      }
      
      public function get milliseconds() : int
      {
         return int(_totalMilliseconds) % 1000;
      }
      
      public function get totalDays() : Number
      {
         return _totalMilliseconds / 86400000;
      }
      
      public function get totalHours() : Number
      {
         return _totalMilliseconds / 3600000;
      }
      
      public function get totalMinutes() : Number
      {
         return _totalMilliseconds / 60000;
      }
      
      public function get totalSeconds() : Number
      {
         return _totalMilliseconds / 1000;
      }
      
      public function get totalMilliseconds() : Number
      {
         return _totalMilliseconds;
      }
      
      public function getTimeBetweenTimeSpanAndNow(param1:Boolean = false) : String
      {
         var _loc5_:Date = new Date();
         var _loc6_:TimeSpan = new TimeSpan(this.totalMilliseconds - _loc5_.time);
         var _loc2_:String = Math.abs(_loc6_.hours).toString();
         if(_loc2_.length == 1)
         {
            _loc2_ = "0" + _loc2_;
         }
         var _loc4_:String = Math.abs(_loc6_.minutes).toString();
         if(_loc4_.length == 1)
         {
            _loc4_ = "0" + _loc4_;
         }
         var _loc3_:String = Math.abs(_loc6_.seconds).toString();
         if(_loc3_.length == 1)
         {
            _loc3_ = "0" + _loc3_;
         }
         if(param1 && _loc6_.totalMilliseconds < 0)
         {
            return "00:00:00";
         }
         return _loc2_ + ":" + _loc4_ + ":" + _loc3_;
      }
      
      public function add(param1:Date) : Date
      {
         var _loc2_:Date = new Date(param1.time);
         _loc2_.milliseconds += totalMilliseconds;
         return _loc2_;
      }
   }
}

