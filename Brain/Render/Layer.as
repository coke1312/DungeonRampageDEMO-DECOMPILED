package Brain.Render
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import org.as3commons.collections.utils.ArrayUtils;
   
   public class Layer extends Sprite
   {
      
      private var mComparator:ChildComparator;
      
      private var mSortIndex:int;
      
      public function Layer(param1:int = 0)
      {
         super();
         mComparator = new ChildComparator();
         this.mouseEnabled = false;
         mSortIndex = param1;
      }
      
      public function get sortIndex() : int
      {
         return mSortIndex;
      }
      
      private function fixChildIndex(param1:DisplayObject, param2:int, param3:Array) : void
      {
         if(this.getChildAt(param2) != param1)
         {
            this.setChildIndex(param1,param2);
         }
      }
      
      public function sortLayer() : void
      {
         var _loc2_:* = 0;
         if(this.numChildren == 0)
         {
            return;
         }
         var _loc1_:Array = new Array(this.numChildren);
         _loc2_ = 0;
         while(_loc2_ < this.numChildren)
         {
            _loc1_[_loc2_] = getChildAt(_loc2_);
            _loc2_++;
         }
         ArrayUtils.insertionSort(_loc1_,mComparator);
         _loc1_.map(fixChildIndex,this);
      }
      
      public function render() : void
      {
      }
      
      public function destroy() : void
      {
         mComparator = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}

import org.as3commons.collections.framework.IComparator;

class ChildComparator implements IComparator
{
   
   public function ChildComparator()
   {
      super();
   }
   
   public function compare(param1:*, param2:*) : int
   {
      if(param1.y == param2.y)
      {
         if(param1.x == param2.x)
         {
            if(param1.height == param2.height)
            {
               return 0;
            }
            return param1.height > param2.height ? -1 : 1;
         }
         return param2.x < param1.x ? -1 : 1;
      }
      return param1.y < param2.y ? -1 : 1;
   }
}
