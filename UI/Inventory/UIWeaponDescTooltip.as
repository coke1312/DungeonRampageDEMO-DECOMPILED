package UI.Inventory
{
   import Facade.DBFacade;
   import GameMasterDictionary.GMWeaponItem;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class UIWeaponDescTooltip extends MovieClip
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mRoot:MovieClip;
      
      protected var mDescription:TextField;
      
      public function UIWeaponDescTooltip(param1:DBFacade, param2:Class)
      {
         super();
         mDBFacade = param1;
         mRoot = new param2();
         this.addChild(mRoot);
         mDescription = mRoot.description_label;
      }
      
      public function destroy() : void
      {
         mDBFacade = null;
         this.removeChild(mRoot);
         mRoot = null;
      }
      
      public function place(param1:int, param2:int) : void
      {
         mRoot.x = param1;
         mRoot.y = param2;
      }
      
      public function setWeaponItem(param1:GMWeaponItem, param2:uint, param3:Boolean = false) : void
      {
         mDescription.text = param1.getWeaponAesthetic(param2,param3).Description;
      }
   }
}

