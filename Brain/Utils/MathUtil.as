package Brain.Utils
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class MathUtil
   {
      
      private static var spare:Number;
      
      private static var spareReady:Boolean = false;
      
      public function MathUtil()
      {
         super();
      }
      
      public static function rand(param1:Number, param2:Number) : Number
      {
         return param1 + (param2 - param1) * Math.random();
      }
      
      public static function rad2deg(param1:Number) : Number
      {
         return param1 * 180 / 3.141592653589793;
      }
      
      public static function deg2rad(param1:Number) : Number
      {
         return param1 * 3.141592653589793 / 180;
      }
      
      public static function degreesBetweenPoints(param1:Point, param2:Point) : Number
      {
         return Math.atan2(param2.y - param1.y,param2.x - param1.x) * 180 / 3.141592653589793;
      }
      
      public static function degreesToFaceObject(param1:DisplayObject, param2:DisplayObject) : Number
      {
         return Math.atan2(param2.y - param1.y,param2.x - param1.x) * 180 / 3.141592653589793;
      }
      
      public static function getGaussian(param1:Number, param2:Number) : Number
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Number = NaN;
         if(spareReady)
         {
            spareReady = false;
            return spare * param2 + param1;
         }
         do
         {
            _loc4_ = Math.random() * 2 - 1;
            _loc5_ = Math.random() * 2 - 1;
            _loc3_ = _loc4_ * _loc4_ + _loc5_ * _loc5_;
         }
         while(_loc3_ >= 1 || _loc3_ == 0);
         
         spare = _loc5_ * Math.sqrt(-2 * Math.log(_loc3_) / _loc3_);
         spareReady = true;
         return param1 + param2 * _loc4_ * Math.sqrt(-2 * Math.log(_loc3_) / _loc3_);
      }
   }
}

