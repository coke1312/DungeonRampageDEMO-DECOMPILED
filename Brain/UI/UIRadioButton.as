package Brain.UI
{
   import Brain.Facade.Facade;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class UIRadioButton extends UIButton
   {
      
      private static var mAllRadioButtons:Vector.<UIRadioButton> = new Vector.<UIRadioButton>();
      
      protected var mGroup:String;
      
      public function UIRadioButton(param1:Facade, param2:MovieClip, param3:String)
      {
         super(param1,param2);
         mGroup = param3;
         mAllRadioButtons.push(this);
      }
      
      protected static function deselectAllInGroup(param1:UIRadioButton) : void
      {
         for each(var _loc2_ in mAllRadioButtons)
         {
            if(_loc2_ != param1 && _loc2_.group == param1.group)
            {
               _loc2_.selected = false;
               _loc2_.enabled = _loc2_.enabled;
            }
         }
      }
      
      override public function destroy() : void
      {
         mAllRadioButtons.splice(mAllRadioButtons.indexOf(this),1);
         super.destroy();
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         mRoot.buttonMode = !param1;
         mRoot.tabEnabled = !param1;
         if(mSelected)
         {
            deselectAllInGroup(this);
         }
      }
      
      public function get group() : String
      {
         return mGroup;
      }
      
      public function set group(param1:String) : void
      {
         mGroup = param1;
      }
      
      override protected function onRelease(param1:MouseEvent) : void
      {
         this.selected = true;
         super.onRelease(param1);
      }
   }
}

