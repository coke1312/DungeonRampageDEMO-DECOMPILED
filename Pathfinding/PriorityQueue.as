package Pathfinding
{
   public dynamic class PriorityQueue extends Array
   {
      
      public function PriorityQueue()
      {
         super();
      }
      
      override AS3 function push(... rest) : uint
      {
         var _loc2_:uint = super.push(rest[0]);
         this.sort(compare);
         return _loc2_;
      }
      
      public function front() : AstarGridNode
      {
         return this[0];
      }
      
      override AS3 function pop() : *
      {
         return splice(0,1);
      }
      
      public function contains(param1:AstarGridNode) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ != length)
         {
            if(this[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function compare(param1:AstarGridNode, param2:AstarGridNode) : int
      {
         if(param1.f < param2.f)
         {
            return -1;
         }
         if(param1.f > param2.f)
         {
            return 1;
         }
         return 0;
      }
   }
}

