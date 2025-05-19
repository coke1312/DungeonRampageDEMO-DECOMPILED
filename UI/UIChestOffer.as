package UI
{
   import Account.AvatarInfo;
   import Account.StoreServicesController;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import GameMasterDictionary.GMChest;
   import UI.Inventory.Chests.ChestRevealPopUp;
   
   public class UIChestOffer extends UIShopBundleOffer
   {
      
      private static const TOWN_PATH:String = "Resources/Art2D/UI/db_UI_town.swf";
      
      private static const CHEST_SHOP_POPUP_CLASS:String = "chest_shop_popup";
      
      private var mConfirmPurchaseChestPopup:DBUIConfirmChestPurchasePopup;
      
      private var mGMChest:GMChest;
      
      private var mSelectedAvatarInfo:AvatarInfo;
      
      public function UIChestOffer(param1:DBFacade, param2:Class, param3:AvatarInfo, param4:Function = null)
      {
         super(param1,param2,param4);
         mSelectedAvatarInfo = param3;
      }
      
      override protected function buyButtonCallback() : void
      {
         mGMChest = mDBFacade.gameMaster.chestsById.itemFor(this.offer.Details[0].ChestId);
         if(mGMChest == null)
         {
            Logger.error("Unable to find GMChest for chestId: " + this.offer.Details[0].ChestId);
         }
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),function(param1:SwfAsset):void
         {
            var _loc2_:Class = param1.getClass("chest_shop_popup");
            if(!_loc2_)
            {
               Logger.error("Unable to find class: chest_shop_popup in: Resources/Art2D/UI/db_UI_town.swf");
               return;
            }
            mConfirmPurchaseChestPopup = new DBUIConfirmChestPurchasePopup(mDBFacade,new _loc2_(),purchaseChest,close,offer,mSelectedAvatarInfo.skinId,true,null);
         });
      }
      
      private function purchaseChest() : void
      {
         StoreServicesController.tryBuyOffer(mDBFacade,this.offer,workAroundForOfferBeingDestroyed(mDBFacade,mGMChest),mSelectedAvatarInfo.id);
      }
      
      private function workAroundForOfferBeingDestroyed(param1:DBFacade, param2:GMChest) : Function
      {
         var dbFacade:DBFacade = param1;
         var gmChest:GMChest = param2;
         return function(param1:*):void
         {
            var details:* = param1;
            var selfManagedPopup:ChestRevealPopUp = new ChestRevealPopUp(dbFacade,gmChest,function():void
            {
               selfManagedPopup.destroy();
            },null);
            selfManagedPopup.updateRevealLoot(details);
         };
      }
      
      private function close() : void
      {
         mConfirmPurchaseChestPopup.destroy();
      }
      
      override public function destroy() : void
      {
         if(mConfirmPurchaseChestPopup)
         {
            mConfirmPurchaseChestPopup.destroy();
         }
         super.destroy();
      }
   }
}

