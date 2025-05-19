package Brain.UI
{
   import Brain.Facade.Facade;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class UIToggleButton extends UIButton
   {
      
      private var m_id:uint;
      
      private var selectionChangeCallback:Function;
      
      public function UIToggleButton(param1:Facade, param2:uint, param3:MovieClip, param4:Boolean, param5:Function, param6:int = 0)
      {
         super(param1,param3,param6);
         m_id = param2;
         selectionChangeCallback = param5;
         this.selected = param4;
      }
      
      override protected function onRelease(param1:MouseEvent) : void
      {
         this.selected = !this.selected;
         selectionChangeCallback(m_id,this.selected);
         super.onRelease(param1);
      }
   }
}

