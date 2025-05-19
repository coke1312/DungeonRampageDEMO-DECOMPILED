package UI.EquipPicker
{
   import Account.ItemInfo;
   import Account.StackableInfo;
   import Facade.DBFacade;
   import GameMasterDictionary.GMStackable;
   import flash.display.MovieClip;
   
   public class ConsumableEquipElement extends AvatarEquipElement
   {
      
      private var mStackableInfo:StackableInfo;
      
      public function ConsumableEquipElement(param1:DBFacade, param2:String, param3:MovieClip, param4:Class, param5:Function, param6:Function, param7:uint, param8:Function = null, param9:Function = null, param10:Boolean = false)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
         mRoot.textx.visible = false;
         mRoot.quantity.visible = false;
      }
      
      override public function clear() : void
      {
         super.clear();
         mRoot.textx.visible = false;
         mRoot.quantity.visible = false;
      }
      
      public function init(param1:GMStackable, param2:uint, param3:uint) : void
      {
         var _loc4_:ItemInfo = null;
         clear();
         mStackableInfo = new StackableInfo(mDBFacade,null,param1);
         stackableInfo.setPropertiesAsConsumable(param1.Id,param2,param3);
         mItemInfo = stackableInfo;
         if(mItemInfo != null)
         {
            mRoot.frame.alpha = 1;
            loadItemIcon();
            _loc4_ = mItemInfo as ItemInfo;
            if(!_loc4_)
            {
            }
            draggable = true;
         }
         else
         {
            mRoot.frame.alpha = 0;
            draggable = false;
         }
         mRoot.textx.visible = true;
         mRoot.quantity.visible = true;
         mRoot.quantity.text = param3.toString();
      }
      
      public function get stackableInfo() : StackableInfo
      {
         return mStackableInfo;
      }
      
      override protected function resetDragUnequipFunc() : void
      {
         mUnequipCallback(mItemInfo,mEquipSlot,mEquipResponseCallback);
      }
   }
}

