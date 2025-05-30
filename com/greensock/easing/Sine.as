package com.greensock.easing
{
   public class Sine
   {
      
      private static const _HALF_PI:Number = Math.PI * 0.5;
      
      public function Sine()
      {
         super();
      }
      
      public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return param3 * Math.sin(param1 / param4 * _HALF_PI) + param2;
      }
      
      public static function easeIn(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * Math.cos(param1 / param4 * _HALF_PI) + param3 + param2;
      }
      
      public static function easeInOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * 0.5 * (Math.cos(Math.PI * param1 / param4) - 1) + param2;
      }
   }
}

