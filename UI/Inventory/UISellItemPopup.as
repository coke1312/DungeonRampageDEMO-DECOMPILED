package UI.Inventory
{
   import Account.InventoryBaseInfo;
   import Account.ItemInfo;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import UI.DBUITwoButtonPopup;
   import flash.display.MovieClip;
   
   public class UISellItemPopup extends DBUITwoButtonPopup
   {
      
      protected static const POPUP_CLASS_NAME:String = "item_popup";
      
      private var mInfo:InventoryBaseInfo;
      
      public function UISellItemPopup(param1:DBFacade, param2:String, param3:InventoryBaseInfo, param4:String, param5:Function, param6:String, param7:Function, param8:Boolean = true, param9:Function = null)
      {
         mInfo = param3;
         super(param1,param2,null,param4,param5,param6,param7,param8,param9);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override protected function getClassName() : String
      {
         return "item_popup";
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         var itemInfo:ItemInfo;
         var swfPath:String;
         var iconName:String;
         var swfAsset:SwfAsset = param1;
         var titleText:String = param2;
         var content:* = param3;
         var allowClose:Boolean = param4;
         var closeCallback:Function = param5;
         super.setupUI(swfAsset,titleText,content,allowClose,closeCallback);
         itemInfo = mInfo as ItemInfo;
         mPopup.power.visible = itemInfo != null;
         if(itemInfo)
         {
            mPopup.power.label.text = itemInfo.power.toString();
         }
         swfPath = mInfo.uiSwfFilepath;
         iconName = mInfo.iconName;
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(swfPath),function(param1:SwfAsset):void
         {
            var _loc3_:Class = param1.getClass(iconName);
            if(_loc3_ == null)
            {
               Logger.error("Unable to get iconClass for iconName: " + iconName);
               return;
            }
            var _loc2_:MovieClip = new _loc3_();
            _loc2_.scaleX = _loc2_.scaleY = 70 / mInfo.iconScale;
            mPopup.item_icon.addChild(_loc2_);
         });
         mPopup.coin.visible = true;
         mPopup.coin.mouseEnabled = false;
         mPopup.coin.mouseChildren = false;
         mPopup.price.text = mInfo.sellCoins.toString();
         mPopup.price.mouseEnabled = false;
      }
   }
}

