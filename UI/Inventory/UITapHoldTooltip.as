package UI.Inventory
{
   import Facade.DBFacade;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class UITapHoldTooltip extends MovieClip
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mRoot:MovieClip;
      
      protected var mTitle:TextField;
      
      protected var mDescription:TextField;
      
      public function UITapHoldTooltip(param1:DBFacade, param2:Class)
      {
         super();
         mDBFacade = param1;
         mRoot = new param2();
         this.addChild(mRoot);
         mTitle = mRoot.title_label;
         mDescription = mRoot.charge_description_label;
      }
      
      public function destroy() : void
      {
         mDBFacade = null;
         this.removeChild(mRoot);
         mRoot = null;
      }
      
      public function setValues(param1:String, param2:String) : void
      {
         mTitle.text = param1.toUpperCase();
         mDescription.text = param2;
      }
   }
}

