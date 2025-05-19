package UI.Inventory
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMNpc;
   import GameMasterDictionary.GMOffer;
   import GameMasterDictionary.GMOfferDetail;
   import GameMasterDictionary.GMSkin;
   import GameMasterDictionary.GMWeaponAesthetic;
   import GameMasterDictionary.GMWeaponItem;
   import UI.DBUITwoButtonPopup;
   import flash.display.MovieClip;
   
   public class UIPurchaseOfferPopup extends DBUITwoButtonPopup
   {
      
      private var mPopupClassName:String;
      
      private var mGMOffer:GMOffer;
      
      public function UIPurchaseOfferPopup(param1:DBFacade, param2:String, param3:String, param4:GMOffer, param5:String, param6:Function, param7:String, param8:Function, param9:Boolean = true, param10:Function = null)
      {
         mGMOffer = param4;
         mPopupClassName = param2;
         super(param1,param3,null,param5,param6,param7,param8,param9,param10);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override protected function getClassName() : String
      {
         return mPopupClassName;
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         var swfPath:String;
         var iconName:String;
         var offerName:String;
         var offerDetail:GMOfferDetail;
         var weaponItem:GMWeaponItem;
         var weaponAesthetic:GMWeaponAesthetic;
         var hero:GMHero;
         var defaultSkin:GMSkin;
         var pet:GMNpc;
         var skin:GMSkin;
         var swfAsset:SwfAsset = param1;
         var titleText:String = param2;
         var content:* = param3;
         var allowClose:Boolean = param4;
         var closeCallback:Function = param5;
         super.setupUI(swfAsset,titleText,content,allowClose,closeCallback);
         offerName = "";
         mPopup.power.visible = false;
         if(mGMOffer.IsBundle)
         {
            offerName = mGMOffer.BundleName;
            swfPath = mGMOffer.BundleSwfFilepath;
            iconName = mGMOffer.BundleIcon;
         }
         else
         {
            offerDetail = mGMOffer.Details[0];
            if(offerDetail.WeaponId)
            {
               weaponItem = mDBFacade.gameMaster.weaponItemById.itemFor(offerDetail.WeaponId);
               weaponAesthetic = weaponItem.getWeaponAesthetic(offerDetail.Level);
               offerName = weaponAesthetic.Name;
               swfPath = weaponAesthetic.IconSwf;
               iconName = weaponAesthetic.IconName;
               mPopup.power.visible = true;
               mPopup.power.label.text = offerDetail.WeaponPower;
            }
            else if(offerDetail.HeroId)
            {
               hero = mDBFacade.gameMaster.heroById.itemFor(offerDetail.HeroId);
               defaultSkin = mDBFacade.gameMaster.getSkinByConstant(hero.DefaultSkin);
               if(defaultSkin)
               {
                  offerName = hero.Name;
                  swfPath = defaultSkin.UISwfFilepath;
                  iconName = defaultSkin.IconName;
               }
            }
            else if(offerDetail.PetId)
            {
               pet = mDBFacade.gameMaster.npcById.itemFor(offerDetail.PetId);
               offerName = pet.Name;
               swfPath = pet.IconSwfFilepath;
               iconName = pet.IconName;
            }
            else if(offerDetail.SkinId)
            {
               skin = mDBFacade.gameMaster.getSkinByType(offerDetail.SkinId);
               offerName = skin.Name;
               swfPath = skin.UISwfFilepath;
               iconName = skin.IconName;
            }
         }
         if(swfPath && iconName)
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(swfPath),function(param1:SwfAsset):void
            {
               var _loc3_:Class = param1.getClass(iconName);
               if(_loc3_ == null)
               {
                  Logger.error("Unable to get iconClass for iconName: " + iconName);
                  return;
               }
               var _loc2_:MovieClip = new _loc3_();
               _loc2_.scaleX = _loc2_.scaleY = 70 / 100;
               mPopup.item_icon.addChild(_loc2_);
            });
         }
         if(mPopup.message_label != null)
         {
            mPopup.message_label.text = offerName;
         }
         mPopup.cash.visible = mGMOffer.Price > 0 && mGMOffer.CurrencyType == "PREMIUM";
         mPopup.coin.visible = mGMOffer.Price > 0 && mGMOffer.CurrencyType == "BASIC";
         mPopup.price.text = mGMOffer.Price > 0 ? mGMOffer.Price.toString() : Locale.getString("SHOP_FREE");
      }
   }
}

