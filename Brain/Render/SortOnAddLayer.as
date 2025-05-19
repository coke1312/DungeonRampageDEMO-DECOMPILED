package Brain.Render
{
   import flash.display.DisplayObject;
   
   public class SortOnAddLayer extends Layer
   {
      
      private var mNeedsSort:Boolean = false;
      
      public function SortOnAddLayer(param1:int = 0)
      {
         super(param1);
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         super.addChild(param1);
         mNeedsSort = true;
         return param1;
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         super.addChildAt(param1,param2);
         mNeedsSort = true;
         return param1;
      }
      
      override public function render() : void
      {
         if(mNeedsSort)
         {
            this.sortLayer();
            mNeedsSort = false;
         }
      }
   }
}

