package org.as3commons.collections.utils
{
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.IComparator;
   import org.as3commons.collections.framework.IMap;
   
   public class ArrayUtils
   {
      
      public function ArrayUtils()
      {
         super();
      }
      
      public static function shuffle(param1:Array) : Boolean
      {
         var _loc3_:uint = 0;
         var _loc4_:* = undefined;
         var _loc2_:uint = param1.length;
         if(_loc2_ < 2)
         {
            return false;
         }
         while(--_loc2_)
         {
            _loc3_ = Math.floor(Math.random() * (_loc2_ + 1));
            _loc4_ = param1[_loc2_];
            param1[_loc2_] = param1[_loc3_];
            param1[_loc3_] = _loc4_;
         }
         return true;
      }
      
      public static function arraysEqual(param1:Array, param2:Array) : Boolean
      {
         if(param1 == param2)
         {
            return true;
         }
         var _loc3_:Number = param1.length;
         if(_loc3_ != param2.length)
         {
            return false;
         }
         while(_loc3_--)
         {
            if(param1[_loc3_] !== param2[_loc3_])
            {
               return false;
            }
         }
         return true;
      }
      
      public static function arraysMatch(param1:Array, param2:Array) : Boolean
      {
         if(param1 == param2)
         {
            return true;
         }
         var _loc3_:Number = param1.length;
         if(_loc3_ != param2.length)
         {
            return false;
         }
         var _loc4_:IMap = new Map();
         while(_loc3_--)
         {
            if(_loc4_.hasKey(param1[_loc3_]))
            {
               _loc4_.replaceFor(param1[_loc3_],_loc4_.itemFor(param1[_loc3_]) + 1);
            }
            else
            {
               _loc4_.add(param1[_loc3_],1);
            }
         }
         _loc3_ = param2.length;
         while(_loc3_--)
         {
            if(!_loc4_.hasKey(param2[_loc3_]))
            {
               return false;
            }
            if(_loc4_.itemFor(param2[_loc3_]) == 1)
            {
               _loc4_.removeKey(param2[_loc3_]);
            }
            else
            {
               _loc4_.replaceFor(param2[_loc3_],_loc4_.itemFor(param2[_loc3_]) - 1);
            }
         }
         return _loc4_.size == 0;
      }
      
      public static function insertionSort(param1:Array, param2:IComparator) : Boolean
      {
         var _loc5_:* = undefined;
         var _loc6_:uint = 0;
         if(param1.length < 2)
         {
            return false;
         }
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 1;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc4_;
            while(_loc6_ > 0 && param2.compare(param1[_loc6_ - 1],_loc5_) == 1)
            {
               param1[_loc6_] = param1[_loc6_ - 1];
               _loc6_--;
            }
            param1[_loc6_] = _loc5_;
            _loc4_++;
         }
         return true;
      }
      
      public static function mergeSort(param1:Array, param2:IComparator) : Boolean
      {
         if(param1.length < 2)
         {
            return false;
         }
         var _loc3_:uint = Math.floor(param1.length / 2);
         var _loc4_:uint = uint(param1.length - _loc3_);
         var _loc5_:Array = new Array(_loc3_);
         var _loc6_:Array = new Array(_loc4_);
         var _loc7_:uint = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc3_)
         {
            _loc5_[_loc7_] = param1[_loc7_];
            _loc7_++;
         }
         _loc7_ = _loc3_;
         while(_loc7_ < _loc3_ + _loc4_)
         {
            _loc6_[_loc7_ - _loc3_] = param1[_loc7_];
            _loc7_++;
         }
         mergeSort(_loc5_,param2);
         mergeSort(_loc6_,param2);
         _loc7_ = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         while(_loc5_.length != _loc8_ && _loc6_.length != _loc9_)
         {
            if(param2.compare(_loc5_[_loc8_],_loc6_[_loc9_]) != 1)
            {
               param1[_loc7_] = _loc5_[_loc8_];
               _loc7_++;
               _loc8_++;
            }
            else
            {
               param1[_loc7_] = _loc6_[_loc9_];
               _loc7_++;
               _loc9_++;
            }
         }
         while(_loc5_.length != _loc8_)
         {
            param1[_loc7_] = _loc5_[_loc8_];
            _loc7_++;
            _loc8_++;
         }
         while(_loc6_.length != _loc9_)
         {
            param1[_loc7_] = _loc6_[_loc9_];
            _loc7_++;
            _loc9_++;
         }
         return true;
      }
   }
}

