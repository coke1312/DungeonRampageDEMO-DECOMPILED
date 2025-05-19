package UI.EquipPicker
{
   import Brain.UI.UIObject;
   import Facade.DBFacade;
   import flash.display.MovieClip;
   
   public class EquipSlot extends UIObject
   {
      
      private var mEquipPicker_handleItemDrop:Function;
      
      private var mEquipSlot:uint;
      
      public function EquipSlot(param1:DBFacade, param2:MovieClip, param3:Function, param4:uint)
      {
         super(param1,param2);
         mEquipPicker_handleItemDrop = param3;
         mEquipSlot = param4;
      }
      
      override public function handleDrop(param1:UIObject) : Boolean
      {
         return mEquipPicker_handleItemDrop(param1,null,mEquipSlot);
      }
   }
}

