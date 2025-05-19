package Brain.Utils
{
   import flash.utils.Dictionary;
   
   public class ObjectPool
   {
      
      protected var mPool:Dictionary = new Dictionary();
      
      public function ObjectPool()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc2_:* = undefined;
         var _loc1_:String = "";
         for(var _loc3_ in mPool)
         {
            _loc2_ = mPool[_loc3_];
            _loc1_ += _loc2_.length.toString() + "\t: " + _loc3_ + "\n";
         }
         return _loc1_;
      }
      
      protected function construct(param1:Array) : IPoolable
      {
         return null;
      }
      
      protected function reset(param1:IPoolable, param2:Array) : void
      {
      }
      
      protected function getPoolKey(param1:Array) : String
      {
         return "";
      }
      
      private function getPool(param1:String) : Vector.<IPoolable>
      {
         var _loc2_:* = undefined;
         if(param1 in mPool)
         {
            return mPool[param1];
         }
         _loc2_ = new Vector.<IPoolable>();
         mPool[param1] = _loc2_;
         return _loc2_;
      }
      
      public function checkout(... rest) : IPoolable
      {
         var _loc2_:IPoolable = null;
         var _loc3_:Boolean = false;
         var _loc5_:String = getPoolKey(rest);
         var _loc4_:Vector.<IPoolable> = getPool(_loc5_);
         if(_loc4_.length)
         {
            _loc2_ = _loc4_.pop();
            reset(_loc2_,rest);
            _loc3_ = false;
         }
         else
         {
            _loc2_ = construct(rest);
            _loc3_ = true;
         }
         _loc2_.postCheckout(_loc3_);
         return _loc2_;
      }
      
      public function checkin(param1:IPoolable) : void
      {
         param1.postCheckin();
         var _loc2_:Vector.<IPoolable> = getPool(param1.getPoolKey());
         _loc2_.push(param1);
      }
      
      public function clear() : void
      {
         for each(var _loc1_ in mPool)
         {
            for each(var _loc2_ in _loc1_)
            {
               _loc2_.destroy();
            }
         }
         mPool = new Dictionary();
      }
      
      public function destroy() : void
      {
         this.clear();
         mPool = null;
      }
   }
}

