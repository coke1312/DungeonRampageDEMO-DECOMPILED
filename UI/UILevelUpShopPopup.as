package UI
{
   import Account.AvatarInfo;
   import Account.StoreServicesController;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Render.MovieClipRenderController;
   import Brain.UI.UIObject;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMOffer;
   import GameMasterDictionary.GMWeaponAesthetic;
   import GameMasterDictionary.GMWeaponItem;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class UILevelUpShopPopup extends DBUIOneButtonPopup
   {
      
      protected static const SWF_PATH:String = "Resources/Art2D/UI/db_UI_screens.swf";
      
      protected static const POPUP_CLASS_NAME:String = "levelup_shop_popup";
      
      private var mAvatarInfo:AvatarInfo;
      
      private var mGMOffers:Vector.<GMOffer>;
      
      public function UILevelUpShopPopup(param1:DBFacade, param2:Function, param3:AvatarInfo, param4:Vector.<GMOffer>)
      {
         mAvatarInfo = param3;
         mGMOffers = param4;
         super(param1,Locale.getString("LEVELUPSHOP_POPUP_TITLE"),Locale.getString("LEVELUPSHOP_POPUP_MESSAGE"),Locale.getString("LEVELUPSHOP_POPUP_BUTTON"),param2,true,null);
         mDBFacade.metrics.log("LevelUpShopPopupPresented");
      }
      
      public static function getLevelUpWeaponUnlocks(param1:DBFacade, param2:AvatarInfo) : Vector.<GMOffer>
      {
         var _loc10_:GMOffer = null;
         var _loc7_:* = null;
         var _loc11_:* = 0;
         var _loc8_:* = 0;
         var _loc6_:String = null;
         var _loc9_:* = 0;
         var _loc4_:Vector.<GMOffer> = new Vector.<GMOffer>();
         var _loc3_:uint = param2.level;
         var _loc5_:Vector.<GMOffer> = param1.gameMaster.Offers;
         _loc9_ = 0;
         while(_loc9_ < _loc5_.length)
         {
            _loc10_ = _loc5_[_loc9_];
            if(_loc10_.Location == "STORE")
            {
               if(!_loc10_.Gift)
               {
                  if(!_loc10_.IsBundle)
                  {
                     if(_loc10_.Details[0].WeaponId)
                     {
                        _loc11_ = StoreServicesController.requiredHeroForWeapon(param1,_loc10_);
                        if(!(_loc11_ && _loc11_ != param2.avatarType))
                        {
                           _loc8_ = StoreServicesController.getOfferLevelReq(param1,_loc10_);
                           if(!(_loc8_ && _loc8_ != _loc3_))
                           {
                              _loc6_ = StoreServicesController.getWeaponMastertype(param1,_loc10_);
                              if(!(_loc6_ && !param2.gmHero.AllowedWeapons.hasKey(_loc6_)))
                              {
                                 _loc4_.push(_loc10_);
                              }
                           }
                        }
                     }
                  }
               }
            }
            _loc9_++;
         }
         return _loc4_;
      }
      
      override public function destroy() : void
      {
         mGMOffers = null;
         mAvatarInfo = null;
         super.destroy();
      }
      
      override protected function getSwfPath() : String
      {
         return "Resources/Art2D/UI/db_UI_screens.swf";
      }
      
      override protected function getClassName() : String
      {
         return "levelup_shop_popup";
      }
      
      override protected function centerButtonCallback() : void
      {
         mDBFacade.metrics.log("LevelUpShopPopupContinue");
         super.centerButtonCallback();
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         var offerUIs:Vector.<MovieClip>;
         var gmOffer:GMOffer;
         var offerUI:MovieClip;
         var gmWeaponItem:GMWeaponItem;
         var gmAesthetic:GMWeaponAesthetic;
         var i:uint;
         var swfAsset:SwfAsset = param1;
         var titleText:String = param2;
         var content:* = param3;
         var allowClose:Boolean = param4;
         var closeCallback:Function = param5;
         super.setupUI(swfAsset,titleText,content,allowClose,closeCallback);
         mAvatarInfo.loadHeroIcon(function(param1:MovieClip):void
         {
            if(mPopup)
            {
               UIObject.scaleToFit(param1,60);
               mPopup.avatar.addChild(param1);
            }
         });
         mPopup.hero_level_star_label.text = mAvatarInfo.level.toString();
         offerUIs = new Vector.<MovieClip>();
         offerUIs.push(mPopup.weapon_0);
         offerUIs.push(mPopup.weapon_1);
         offerUIs.push(mPopup.weapon_2);
         for each(offerUI in offerUIs)
         {
            offerUI.visible = false;
         }
         i = 0;
         while(i < mGMOffers.length && i < offerUIs.length)
         {
            offerUI = offerUIs[i];
            offerUI.visible = true;
            gmOffer = mGMOffers[i];
            gmWeaponItem = mDBFacade.gameMaster.weaponItemById.itemFor(gmOffer.Details[0].WeaponId);
            gmAesthetic = gmWeaponItem.getWeaponAesthetic(gmOffer.Details[0].Level);
            offerUI.weapon_label.text = gmAesthetic.Name.toUpperCase();
            this.loadWeaponIcon(offerUI.empty_slot,gmWeaponItem);
            offerUI.level_star_label.text = gmOffer.Details[0].Level.toString();
            i++;
         }
      }
      
      private function loadWeaponIcon(param1:DisplayObjectContainer, param2:GMWeaponItem) : void
      {
         var parent:DisplayObjectContainer = param1;
         var gmWeaponItem:GMWeaponItem = param2;
         var swfPath:String = gmWeaponItem.UISwfFilepath;
         var iconName:String = gmWeaponItem.IconName;
         if(swfPath && iconName)
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(swfPath),function(param1:SwfAsset):void
            {
               var _loc2_:MovieClip = null;
               var _loc3_:MovieClipRenderController = null;
               var _loc4_:Class = param1.getClass(iconName);
               if(_loc4_)
               {
                  _loc2_ = new _loc4_();
                  _loc3_ = new MovieClipRenderController(mDBFacade,_loc2_);
                  _loc3_.play(0,true);
                  _loc2_.scaleX = _loc2_.scaleY = 72 / 100;
                  parent.addChild(_loc2_);
               }
            });
         }
      }
   }
}

