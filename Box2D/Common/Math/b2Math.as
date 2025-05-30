package Box2D.Common.Math
{
   public class b2Math
   {
      
      public static const b2Vec2_zero:b2Vec2 = new b2Vec2(0,0);
      
      public static const b2Mat22_identity:b2Mat22 = b2Mat22.FromVV(new b2Vec2(1,0),new b2Vec2(0,1));
      
      public static const b2Transform_identity:b2Transform = new b2Transform(b2Vec2_zero,b2Mat22_identity);
      
      public function b2Math()
      {
         super();
      }
      
      public static function IsValid(param1:Number) : Boolean
      {
         return isFinite(param1);
      }
      
      public static function Dot(param1:b2Vec2, param2:b2Vec2) : Number
      {
         return param1.x * param2.x + param1.y * param2.y;
      }
      
      public static function CrossVV(param1:b2Vec2, param2:b2Vec2) : Number
      {
         return param1.x * param2.y - param1.y * param2.x;
      }
      
      public static function CrossVF(param1:b2Vec2, param2:Number) : b2Vec2
      {
         return new b2Vec2(param2 * param1.y,-param2 * param1.x);
      }
      
      public static function CrossFV(param1:Number, param2:b2Vec2) : b2Vec2
      {
         return new b2Vec2(-param1 * param2.y,param1 * param2.x);
      }
      
      public static function MulMV(param1:b2Mat22, param2:b2Vec2) : b2Vec2
      {
         return new b2Vec2(param1.col1.x * param2.x + param1.col2.x * param2.y,param1.col1.y * param2.x + param1.col2.y * param2.y);
      }
      
      public static function MulTMV(param1:b2Mat22, param2:b2Vec2) : b2Vec2
      {
         return new b2Vec2(Dot(param2,param1.col1),Dot(param2,param1.col2));
      }
      
      public static function MulX(param1:b2Transform, param2:b2Vec2) : b2Vec2
      {
         var _loc3_:b2Vec2 = null;
         _loc3_ = MulMV(param1.R,param2);
         _loc3_.x += param1.position.x;
         _loc3_.y += param1.position.y;
         return _loc3_;
      }
      
      public static function MulXT(param1:b2Transform, param2:b2Vec2) : b2Vec2
      {
         var _loc3_:b2Vec2 = null;
         var _loc4_:Number = NaN;
         _loc3_ = SubtractVV(param2,param1.position);
         _loc4_ = _loc3_.x * param1.R.col1.x + _loc3_.y * param1.R.col1.y;
         _loc3_.y = _loc3_.x * param1.R.col2.x + _loc3_.y * param1.R.col2.y;
         _loc3_.x = _loc4_;
         return _loc3_;
      }
      
      public static function AddVV(param1:b2Vec2, param2:b2Vec2) : b2Vec2
      {
         return new b2Vec2(param1.x + param2.x,param1.y + param2.y);
      }
      
      public static function SubtractVV(param1:b2Vec2, param2:b2Vec2) : b2Vec2
      {
         return new b2Vec2(param1.x - param2.x,param1.y - param2.y);
      }
      
      public static function Distance(param1:b2Vec2, param2:b2Vec2) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
      
      public static function DistanceSquared(param1:b2Vec2, param2:b2Vec2) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         return _loc3_ * _loc3_ + _loc4_ * _loc4_;
      }
      
      public static function MulFV(param1:Number, param2:b2Vec2) : b2Vec2
      {
         return new b2Vec2(param1 * param2.x,param1 * param2.y);
      }
      
      public static function AddMM(param1:b2Mat22, param2:b2Mat22) : b2Mat22
      {
         return b2Mat22.FromVV(AddVV(param1.col1,param2.col1),AddVV(param1.col2,param2.col2));
      }
      
      public static function MulMM(param1:b2Mat22, param2:b2Mat22) : b2Mat22
      {
         return b2Mat22.FromVV(MulMV(param1,param2.col1),MulMV(param1,param2.col2));
      }
      
      public static function MulTMM(param1:b2Mat22, param2:b2Mat22) : b2Mat22
      {
         var _loc3_:b2Vec2 = new b2Vec2(Dot(param1.col1,param2.col1),Dot(param1.col2,param2.col1));
         var _loc4_:b2Vec2 = new b2Vec2(Dot(param1.col1,param2.col2),Dot(param1.col2,param2.col2));
         return b2Mat22.FromVV(_loc3_,_loc4_);
      }
      
      public static function Abs(param1:Number) : Number
      {
         return param1 > 0 ? param1 : -param1;
      }
      
      public static function AbsV(param1:b2Vec2) : b2Vec2
      {
         return new b2Vec2(Abs(param1.x),Abs(param1.y));
      }
      
      public static function AbsM(param1:b2Mat22) : b2Mat22
      {
         return b2Mat22.FromVV(AbsV(param1.col1),AbsV(param1.col2));
      }
      
      public static function Min(param1:Number, param2:Number) : Number
      {
         return param1 < param2 ? param1 : param2;
      }
      
      public static function MinV(param1:b2Vec2, param2:b2Vec2) : b2Vec2
      {
         return new b2Vec2(Min(param1.x,param2.x),Min(param1.y,param2.y));
      }
      
      public static function Max(param1:Number, param2:Number) : Number
      {
         return param1 > param2 ? param1 : param2;
      }
      
      public static function MaxV(param1:b2Vec2, param2:b2Vec2) : b2Vec2
      {
         return new b2Vec2(Max(param1.x,param2.x),Max(param1.y,param2.y));
      }
      
      public static function Clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 < param2 ? param2 : (param1 > param3 ? param3 : param1);
      }
      
      public static function ClampV(param1:b2Vec2, param2:b2Vec2, param3:b2Vec2) : b2Vec2
      {
         return MaxV(param2,MinV(param1,param3));
      }
      
      public static function Swap(param1:Array, param2:Array) : void
      {
         var _loc3_:* = param1[0];
         param1[0] = param2[0];
         param2[0] = _loc3_;
      }
      
      public static function Random() : Number
      {
         return Math.random() * 2 - 1;
      }
      
      public static function RandomRange(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.random();
         return (param2 - param1) * _loc3_ + param1;
      }
      
      public static function NextPowerOfTwo(param1:uint) : uint
      {
         param1 |= param1 >> 1 & 0x7FFFFFFF;
         param1 |= param1 >> 2 & 0x3FFFFFFF;
         param1 |= param1 >> 4 & 0x0FFFFFFF;
         param1 |= param1 >> 8 & 0xFFFFFF;
         param1 |= param1 >> 16 & 0xFFFF;
         return param1 + 1;
      }
      
      public static function IsPowerOfTwo(param1:uint) : Boolean
      {
         return param1 > 0 && (param1 & param1 - 1) == 0;
      }
   }
}

