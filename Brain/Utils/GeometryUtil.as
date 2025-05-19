package Brain.Utils
{
   import Brain.Logger.Logger;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class GeometryUtil
   {
      
      public function GeometryUtil()
      {
         super();
      }
      
      public static function Vector3DBetweenPoints(param1:Point, param2:Point) : Vector3D
      {
         return new Vector3D(param2.x - param1.x,param2.y - param1.y);
      }
      
      public static function truncateVector3D(param1:Vector3D, param2:Number) : Boolean
      {
         var _loc3_:Number = param1.length;
         if(_loc3_ > param2)
         {
            param1.scaleBy(param2 / _loc3_);
            return true;
         }
         return false;
      }
      
      public static function DoLineSegmentsIntersect(param1:Point, param2:Point, param3:Point, param4:Point) : Boolean
      {
         var _loc6_:Point = param2.subtract(param1);
         var _loc7_:Point = param3.subtract(param4);
         var _loc5_:Point = new Point(-_loc6_.y,_loc6_.x);
         var _loc9_:Point = param1.subtract(param4);
         var _loc8_:Number = dotProduct(_loc9_,_loc5_) / dotProduct(_loc7_,_loc5_);
         if(_loc8_ <= 1 && _loc8_ >= 0)
         {
            Logger.debug(_loc8_.toString());
            return true;
         }
         Logger.debug("A: " + param1 + " B: " + param2 + " C: " + param4 + " D: " + param3);
         return false;
      }
      
      public static function crossProduct(param1:Point, param2:Point) : Number
      {
         return param1.x * param2.y - param1.y * param2.x;
      }
      
      public static function dotProduct(param1:Point, param2:Point) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
      
      public static function dotProduct2D(param1:Vector3D, param2:Vector3D) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
      
      public static function do_Lines_Intersect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Boolean
      {
         var _loc17_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         _loc17_ = param4 - param2;
         _loc15_ = param1 - param3;
         _loc14_ = param3 * param2 - param1 * param4;
         _loc10_ = _loc17_ * param5 + _loc15_ * param6 + _loc14_;
         _loc11_ = _loc17_ * param7 + _loc15_ * param8 + _loc14_;
         if(_loc10_ != 0 && _loc11_ != 0 && sameSigns(_loc10_,_loc11_))
         {
            return false;
         }
         _loc19_ = param8 - param6;
         _loc18_ = param5 - param7;
         _loc16_ = param7 * param6 - param5 * param8;
         _loc21_ = _loc19_ * param1 + _loc18_ * param2 + _loc16_;
         _loc9_ = _loc19_ * param3 + _loc18_ * param4 + _loc16_;
         if(_loc21_ != 0 && _loc9_ != 0 && sameSigns(_loc21_,_loc9_))
         {
            return false;
         }
         _loc20_ = _loc17_ * _loc18_ - _loc19_ * _loc15_;
         if(_loc20_ == 0)
         {
            return true;
         }
         _loc12_ = _loc20_ < 0 ? -_loc20_ / 2 : _loc20_ / 2;
         return true;
      }
      
      private static function sameSigns(param1:Number, param2:Number) : Boolean
      {
         if(param1 <= 0 && param2 <= 0 || param1 >= 0 && param2 >= 0)
         {
            return true;
         }
         return false;
      }
   }
}

