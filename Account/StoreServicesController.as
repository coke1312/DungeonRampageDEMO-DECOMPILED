package Account
{
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMOffer;
   import GameMasterDictionary.GMOfferDetail;
   import GameMasterDictionary.GMStackable;
   import GameMasterDictionary.GMWeaponItem;
   import UI.DBUIOneButtonPopup;
   import UI.DBUIPopup;
   import UI.DBUITwoButtonPopup;
   import UI.Inventory.UIPurchaseOfferPopup;
   import UI.Inventory.UISellItemPopup;
   import UI.UICashPage;
   import UI.UICoinPage;
   import UI.UIGiftPage;
   import UI.UIOfferPopup;
   import UI.UIStorageFullPopup;
   import org.as3commons.collections.Map;
   
   public class StoreServicesController
   {
      
      public static const MAX_INVENTORY_SLOTS:uint = 120;
      
      public static const CONFIRM_PREMIUM_PURCHASES:Boolean = false;
      
      public static const CONFIRM_BASIC_PURCHASES:Boolean = false;
      
      public static const CONFIRM_ALREADY_OWN:Boolean = true;
      
      public static const BASIC_KEY_OFFERS:Vector.<uint> = new <uint>[51201,51203,51205];
      
      public static const PREMIUM_KEY_OFFERS:Vector.<uint> = new <uint>[51211,51212,51213];
      
      public static const COIN_OFFERS:Vector.<uint> = new <uint>[51102,51103,51104];
      
      public static const STORAGE_OFFERS:Vector.<uint> = new <uint>[51401,51402,51403];
      
      public static const GIFT_OFFERS:Vector.<uint> = new <uint>[51301,51399,51398];
      
      public static const HERO_OFFERS:Vector.<uint> = new <uint>[51012,51013,51014,51015];
      
      public function StoreServicesController()
      {
         super();
      }
      
      public static function getOfferMetrics(param1:DBFacade, param2:GMOffer) : Object
      {
         var _loc3_:Object = {};
         _loc3_.offerId = param2.Id;
         _loc3_.offerName = param2.getDisplayName(param1.gameMaster,Locale.getString("SHOP_UNKNOWN_NAME"));
         _loc3_.price = param2.Price;
         _loc3_.currencyType = param2.CurrencyType;
         return _loc3_;
      }
      
      private static function getSellMetrics(param1:DBFacade, param2:InventoryBaseInfo) : Object
      {
         var _loc3_:Object = {};
         _loc3_.itemId = param2.gmId;
         _loc3_.itemName = param2.Name.toUpperCase();
         _loc3_.price = param2.sellCoins;
         _loc3_.currencyType = "BASIC";
         return _loc3_;
      }
      
      public static function tryBuyOffer(param1:DBFacade, param2:GMOffer, param3:Function, param4:uint = 0) : void
      {
         param1.metrics.log("ShopPurchaseTry",getOfferMetrics(param1,param2));
         if(StoreServicesController.stackableLimitWouldOverflow(param1,param2))
         {
            StoreServicesController.stackableLimitPopup(param1,param2);
         }
         else if(StoreServicesController.weaponInventoryWouldOverflow(param1,param2))
         {
            StoreServicesController.weaponInventoryFullPopup(param1,param2);
         }
         else if(StoreServicesController.weaponStorageWouldOverflow(param1,param2))
         {
            StoreServicesController.weaponStorageLimitPopup(param1,param2);
         }
         else if(alreadyOwns(param1,param2))
         {
            StoreServicesController.confirmAlreadyOwnsPopup(param1,param2,param3,param4);
         }
         else if(StoreServicesController.getOfferLevelReq(param1,param2) > param1.dbAccountInfo.highestAvatarLevel)
         {
            StoreServicesController.notHighEnoughLevelPopup(param1,param2);
         }
         else if(weaponRestrictedAndHeroNotOwned(param1,param2))
         {
            StoreServicesController.doesntOwnHeroPopup(param1,param2);
         }
         else if(param2.CurrencyType == "PREMIUM" && param1.dbAccountInfo.premiumCurrency < param2.Price)
         {
            StoreServicesController.showCashPage(param1,"tryBuyOffer",param2,param3,null,param4);
         }
         else if(param2.CurrencyType == "BASIC" && param1.dbAccountInfo.basicCurrency < param2.Price)
         {
            StoreServicesController.notEnoughCoinsPopup(param1,param2);
         }
         else if(false && param2.CurrencyType == "PREMIUM")
         {
            StoreServicesController.confirmPurchasePopup(param1,param2,param3,param4);
         }
         else if(false && param2.CurrencyType == "BASIC")
         {
            StoreServicesController.confirmPurchasePopup(param1,param2,param3,param4);
         }
         else
         {
            StoreServicesController.buyOffer(param1,param2,param3,param4);
         }
      }
      
      public static function trySellItem(param1:DBFacade, param2:InventoryBaseInfo, param3:Function = null, param4:Function = null) : void
      {
         param1.metrics.log("TrySell",StoreServicesController.getSellMetrics(param1,param2));
         if(param2.isEquipped)
         {
            StoreServicesController.itemIsEquippedPopup(param1,param2,param3,param4);
         }
         else
         {
            StoreServicesController.confirmSell(param1,param2,param3,param4);
         }
      }
      
      public static function getOfferLevelReq(param1:DBFacade, param2:GMOffer) : uint
      {
         if(param2.IsBundle)
         {
            return 0;
         }
         var _loc3_:GMOfferDetail = param2.Details[0];
         if(_loc3_.Level)
         {
            return _loc3_.Level;
         }
         return 0;
      }
      
      public static function getWeaponMastertype(param1:DBFacade, param2:GMOffer) : String
      {
         var _loc3_:GMWeaponItem = null;
         if(param2.IsBundle)
         {
            return null;
         }
         var _loc4_:GMOfferDetail = param2.Details[0];
         if(_loc4_.WeaponId)
         {
            _loc3_ = param1.gameMaster.weaponItemById.itemFor(_loc4_.WeaponId);
            return _loc3_.MasterType;
         }
         return null;
      }
      
      public static function getHeroId(param1:DBFacade, param2:GMOffer) : uint
      {
         if(param2.IsBundle)
         {
            return 0;
         }
         var _loc3_:GMOfferDetail = param2.Details[0];
         return _loc3_.HeroId;
      }
      
      public static function getSkinId(param1:DBFacade, param2:GMOffer) : uint
      {
         if(param2.IsBundle)
         {
            return 0;
         }
         var _loc3_:GMOfferDetail = param2.Details[0];
         return _loc3_.SkinId;
      }
      
      public static function alreadyOwns(param1:DBFacade, param2:GMOffer) : Boolean
      {
         var _loc3_:DBInventoryInfo = param1.dbAccountInfo.inventoryInfo;
         for each(var _loc4_ in param2.Details)
         {
            if(_loc4_.HeroId && _loc3_.ownsItem(_loc4_.HeroId))
            {
               return true;
            }
            if(_loc4_.PetId && _loc3_.ownsItem(_loc4_.PetId))
            {
               return true;
            }
            if(_loc4_.WeaponId && _loc3_.ownsExactWeapon(_loc4_))
            {
               return true;
            }
            if(_loc4_.SkinId && _loc3_.ownsItem(_loc4_.SkinId))
            {
               return true;
            }
         }
         return false;
      }
      
      public static function weaponRestrictedAndHeroNotOwned(param1:DBFacade, param2:GMOffer) : Boolean
      {
         var _loc3_:uint = requiredHeroForWeapon(param1,param2);
         if(_loc3_ && !param1.dbAccountInfo.inventoryInfo.ownsItem(_loc3_))
         {
            return true;
         }
         return false;
      }
      
      public static function weaponInventoryWouldOverflow(param1:DBFacade, param2:GMOffer) : Boolean
      {
         var _loc4_:uint = 0;
         for each(var _loc5_ in param2.Details)
         {
            if(_loc5_.WeaponId != 0)
            {
               _loc4_++;
            }
            else if(_loc5_.ChestId != 0 && (_loc5_.ChestId != 60005 && _loc5_.ChestId != 60006))
            {
               _loc4_++;
            }
         }
         return _loc4_ && _loc4_ + param1.dbAccountInfo.unequippedWeaponCount > param1.dbAccountInfo.inventoryLimitWeapons;
      }
      
      public static function stackableLimitWouldOverflow(param1:DBFacade, param2:GMOffer) : Boolean
      {
         var _loc8_:* = null;
         var _loc4_:* = 0;
         var _loc9_:* = 0;
         var _loc5_:* = 0;
         var _loc3_:* = 0;
         var _loc6_:GMStackable = null;
         var _loc7_:Map = new Map();
         for each(_loc8_ in param2.Details)
         {
            _loc4_ = uint(_loc8_.StackableId);
            if(_loc4_)
            {
               if(_loc7_.hasKey(_loc4_))
               {
                  _loc9_ = _loc7_.itemFor(_loc4_);
                  _loc7_.replaceFor(_loc4_,_loc9_ + _loc8_.StackableCount);
               }
               else
               {
                  _loc7_.add(_loc4_,_loc8_.StackableCount);
               }
            }
         }
         for each(_loc8_ in param2.Details)
         {
            _loc4_ = uint(_loc8_.StackableId);
            if(_loc4_)
            {
               _loc5_ = param1.dbAccountInfo.inventoryInfo.getStackCount(_loc4_);
               _loc3_ = _loc7_.itemFor(_loc4_);
               _loc6_ = param1.gameMaster.stackableById.itemFor(_loc4_);
               if(_loc5_ + _loc3_ > _loc6_.StackLimit)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function weaponStorageWouldOverflow(param1:DBFacade, param2:GMOffer) : Boolean
      {
         var _loc5_:uint = 0;
         for each(var _loc4_ in param2.Details)
         {
            _loc5_ += _loc4_.WeaponSlots;
         }
         if(_loc5_ == 0)
         {
            return false;
         }
         return _loc5_ + param1.dbAccountInfo.inventoryLimitWeapons > 120;
      }
      
      public static function requiredHeroForWeapon(param1:DBFacade, param2:GMOffer) : uint
      {
         return 0;
      }
      
      public static function itemIsEquippedPopup(param1:DBFacade, param2:InventoryBaseInfo, param3:Function, param4:Function) : void
      {
         var popup:UISellItemPopup;
         var dbFacade:DBFacade = param1;
         var info:InventoryBaseInfo = param2;
         var buySuccessCallback:Function = param3;
         var errorCallback:Function = param4;
         dbFacade.metrics.log("ItemEquippedDuringSell",StoreServicesController.getSellMetrics(dbFacade,info));
         popup = new UISellItemPopup(dbFacade,Locale.getString("ITEM_CONFIRM_SELL"),info,Locale.getString("CANCEL"),null,Locale.getString("ITEM_SELL_BUTTON"),function():void
         {
            sellItem(dbFacade,info,buySuccessCallback,errorCallback);
         });
      }
      
      public static function confirmSell(param1:DBFacade, param2:InventoryBaseInfo, param3:Function, param4:Function) : void
      {
         var popup:UISellItemPopup;
         var dbFacade:DBFacade = param1;
         var info:InventoryBaseInfo = param2;
         var buySuccessCallback:Function = param3;
         var errorCallback:Function = param4;
         dbFacade.metrics.log("ConfirmSell",StoreServicesController.getSellMetrics(dbFacade,info));
         popup = new UISellItemPopup(dbFacade,Locale.getString("ITEM_CONFIRM_SELL"),info,Locale.getString("CANCEL"),null,Locale.getString("ITEM_SELL_BUTTON"),function():void
         {
            sellItem(dbFacade,info,buySuccessCallback,errorCallback);
         });
      }
      
      public static function notEnoughCashPopup(param1:DBFacade, param2:GMOffer) : void
      {
         var popup:DBUITwoButtonPopup;
         var dbFacade:DBFacade = param1;
         var gmOffer:GMOffer = param2;
         dbFacade.metrics.log("ShopPurchaseNotEnoughCash",getOfferMetrics(dbFacade,gmOffer));
         popup = new DBUITwoButtonPopup(dbFacade,Locale.getString("SHOP_NOT_ENOUGH_CASH_TITLE"),Locale.getString("SHOP_NOT_ENOUGH_CASH_MESSAGE"),Locale.getString("SHOP_GET_CASH"),function():void
         {
            showCashPage(dbFacade,"notEnoughGemsPopup");
         },Locale.getString("CANCEL"),null);
      }
      
      public static function notEnoughCoinsPopup(param1:DBFacade, param2:GMOffer) : void
      {
         var popup:DBUITwoButtonPopup;
         var dbFacade:DBFacade = param1;
         var gmOffer:GMOffer = param2;
         dbFacade.metrics.log("ShopPurchaseNotEnoughCoins",getOfferMetrics(dbFacade,gmOffer));
         popup = new DBUITwoButtonPopup(dbFacade,Locale.getString("SHOP_NOT_ENOUGH_COINS_TITLE"),Locale.getString("SHOP_NOT_ENOUGH_COINS_MESSAGE"),Locale.getString("SHOP_GET_COINS"),function():void
         {
            showCoinPage(dbFacade);
         },Locale.getString("CANCEL"),null);
      }
      
      public static function notHighEnoughLevelPopup(param1:DBFacade, param2:GMOffer) : void
      {
         var popup:DBUITwoButtonPopup;
         var dbFacade:DBFacade = param1;
         var gmOffer:GMOffer = param2;
         dbFacade.metrics.log("ShopPurchaseNotHighLevel",getOfferMetrics(dbFacade,gmOffer));
         popup = new DBUITwoButtonPopup(dbFacade,Locale.getString("SHOP_NOT_HIGH_LEVEL_TITLE"),Locale.getString("SHOP_NOT_HIGH_LEVEL_MESSAGE"),Locale.getString("SHOP_BUY_ANYWAYS"),function():void
         {
            buyOffer(dbFacade,gmOffer,null);
         },Locale.getString("CANCEL"),null);
      }
      
      public static function weaponInventoryFullPopup(param1:DBFacade, param2:GMOffer) : void
      {
         var popup:DBUITwoButtonPopup;
         var dbFacade:DBFacade = param1;
         var gmOffer:GMOffer = param2;
         dbFacade.metrics.log("ShopPurchaseWeaponInventoryFull",getOfferMetrics(dbFacade,gmOffer));
         popup = new UIStorageFullPopup(dbFacade,Locale.getString("SHOP_WEAPON_INVENTORY_FULL_TITLE"),Locale.getString("SHOP_WEAPON_INVENTORY_FULL_MESSAGE"),Locale.getString("SHOP_GET_STORAGE"),function():void
         {
            showStoragePage(dbFacade);
         },Locale.getString("CANCEL"),null);
      }
      
      public static function stackableLimitPopup(param1:DBFacade, param2:GMOffer) : void
      {
         param1.metrics.log("ShopPurchaseStackLimit",getOfferMetrics(param1,param2));
         var _loc3_:DBUIOneButtonPopup = new DBUIOneButtonPopup(param1,Locale.getString("SHOP_STACK_LIMIT_TITLE"),Locale.getString("SHOP_STACK_LIMIT_MESSAGE"),Locale.getString("CANCEL"),null);
      }
      
      public static function weaponStorageLimitPopup(param1:DBFacade, param2:GMOffer) : void
      {
         param1.metrics.log("ShopPurchaseWeaponStorageLimit",getOfferMetrics(param1,param2));
         var _loc3_:DBUIOneButtonPopup = new DBUIOneButtonPopup(param1,Locale.getString("SHOP_WEAPON_STORAGE_LIMIT_TITLE"),Locale.getString("SHOP_WEAPON_STORAGE_LIMIT_MESSAGE"),Locale.getString("CANCEL"),null);
      }
      
      public static function doesntOwnHeroPopup(param1:DBFacade, param2:GMOffer) : void
      {
         var popup:DBUITwoButtonPopup;
         var dbFacade:DBFacade = param1;
         var gmOffer:GMOffer = param2;
         dbFacade.metrics.log("ShopPurchaseDoesntOwnHero",getOfferMetrics(dbFacade,gmOffer));
         popup = new DBUITwoButtonPopup(dbFacade,Locale.getString("SHOP_HERO_NOT_OWNED"),null,Locale.getString("SHOP_BUY_ANYWAYS"),function():void
         {
            buyOffer(dbFacade,gmOffer,null);
         },Locale.getString("CANCEL"),null);
      }
      
      public static function confirmPurchasePopup(param1:DBFacade, param2:GMOffer, param3:Function, param4:uint = 0) : void
      {
         var popup:UIPurchaseOfferPopup;
         var dbFacade:DBFacade = param1;
         var gmOffer:GMOffer = param2;
         var buySuccessCallback:Function = param3;
         var forHeroId:uint = param4;
         dbFacade.metrics.log("ShopPurchaseConfirm",getOfferMetrics(dbFacade,gmOffer));
         popup = new UIPurchaseOfferPopup(dbFacade,"purchase_popup",Locale.getString("SHOP_CONFIRM_BUY"),gmOffer,Locale.getString("SHOP_BUY"),function():void
         {
            buyOffer(dbFacade,gmOffer,buySuccessCallback,forHeroId);
         },Locale.getString("CANCEL"),null);
      }
      
      public static function confirmAlreadyOwnsPopup(param1:DBFacade, param2:GMOffer, param3:Function, param4:uint = 0) : void
      {
         var popup:UIPurchaseOfferPopup;
         var dbFacade:DBFacade = param1;
         var gmOffer:GMOffer = param2;
         var buySuccessCallback:Function = param3;
         var forHeroId:uint = param4;
         dbFacade.metrics.log("ShopPurchaseConfirmAlreadyOwns",getOfferMetrics(dbFacade,gmOffer));
         popup = new UIPurchaseOfferPopup(dbFacade,"purchase_popup",Locale.getString("SHOP_CONFIRM_DUPLICATE_BUY"),gmOffer,Locale.getString("SHOP_BUY_ANOTHER"),function():void
         {
            buyOffer(dbFacade,gmOffer,buySuccessCallback,forHeroId);
         },Locale.getString("CANCEL"),null);
      }
      
      public static function waitForPurchaseServicePopup(param1:DBFacade) : DBUIPopup
      {
         return new DBUIPopup(param1,Locale.getString("SHOP_PURCHASING"),null,false);
      }
      
      public static function waitForSellServicePopup(param1:DBFacade) : DBUIPopup
      {
         return new DBUIPopup(param1,Locale.getString("SHOP_SELLING"),null,false);
      }
      
      public static function buyOffer(param1:DBFacade, param2:GMOffer, param3:Function, param4:uint = 0) : void
      {
         var popup:DBUIPopup;
         var dbFacade:DBFacade = param1;
         var gmOffer:GMOffer = param2;
         var buySuccessCallback:Function = param3;
         var forHeroId:uint = param4;
         dbFacade.metrics.log("ShopPurchase",getOfferMetrics(dbFacade,gmOffer));
         popup = StoreServicesController.waitForPurchaseServicePopup(dbFacade);
         StoreServices.purchaseOffer(dbFacade,gmOffer.Id,function(param1:*):void
         {
            popup.destroy();
            if(gmOffer.CurrencyType == "PREMIUM" && dbFacade.facebookController != null)
            {
               dbFacade.facebookController.updateGuestAchievement(5);
            }
            StoreServices.getLimitedOfferUsage(dbFacade,param1,null,null);
            if(buySuccessCallback != null)
            {
               buySuccessCallback(param1);
            }
         },function(param1:Error):void
         {
            popup.destroy();
            showErrorPopup(dbFacade,param1);
         },forHeroId);
      }
      
      public static function sellItem(param1:DBFacade, param2:InventoryBaseInfo, param3:Function = null, param4:Function = null) : void
      {
         var popup:DBUIPopup;
         var sellFunc:Function;
         var dbFacade:DBFacade = param1;
         var info:InventoryBaseInfo = param2;
         var buySuccessCallback:Function = param3;
         var errorCallback:Function = param4;
         dbFacade.metrics.log("SellItem",StoreServicesController.getSellMetrics(dbFacade,info));
         popup = StoreServicesController.waitForSellServicePopup(dbFacade);
         if(info is ItemInfo)
         {
            sellFunc = StoreServices.sellWeapon;
         }
         else if(info is StackableInfo)
         {
            sellFunc = StoreServices.sellStackable;
         }
         else
         {
            if(!(info is PetInfo))
            {
               Logger.error("Unknown item type in SellItem");
               return;
            }
            sellFunc = StoreServices.sellPet;
         }
         sellFunc(dbFacade,info.databaseId,function(param1:*):void
         {
            popup.destroy();
            if(buySuccessCallback != null)
            {
               buySuccessCallback(param1);
            }
         },function(param1:Error):void
         {
            popup.destroy();
            showErrorPopup(dbFacade,param1);
            if(errorCallback != null)
            {
               errorCallback();
            }
         });
      }
      
      public static function useAccountBooster(param1:DBFacade, param2:InventoryBaseInfo, param3:Function = null, param4:Function = null) : void
      {
         StoreServices.useAccountBooster(param1,param2.gmId,param3,param4);
      }
      
      public static function getWebServerTimestamp(param1:DBFacade, param2:Function = null, param3:Function = null) : void
      {
         trace("getWebServerTimestamp");
         StoreServices.getWebServerTimestamp(param1,param2,param3);
      }
      
      public static function showErrorPopup(param1:DBFacade, param2:Error) : void
      {
         param1.metrics.log("ShopError",{"error":param2.errorID});
         param1.errorPopup(Locale.getString("SHOP_ERROR") + ": " + param2.errorID,param2.message);
      }
      
      public static function showCashPage(param1:DBFacade, param2:String, param3:GMOffer = null, param4:Function = null, param5:Function = null, param6:uint = 0) : void
      {
         var cashPage:UICashPage;
         var dbFacade:DBFacade = param1;
         var openedFrom:String = param2;
         var attemptedOffer:GMOffer = param3;
         var successCallback:Function = param4;
         var closeCallback:Function = param5;
         var forHeroId:uint = param6;
         var metricsData:Object = {};
         metricsData.openedFrom = openedFrom;
         dbFacade.metrics.log("ShopCashPagePresented",metricsData);
         cashPage = new UICashPage(dbFacade,function(param1:uint):void
         {
            if(attemptedOffer)
            {
               StoreServicesController.confirmPurchasePopup(dbFacade,attemptedOffer,successCallback);
            }
         },closeCallback);
      }
      
      public static function showCoinPage(param1:DBFacade) : void
      {
         param1.metrics.log("ShopCoinPagePresented");
         var _loc2_:UICoinPage = new UICoinPage(param1,null,null);
      }
      
      public static function showStoragePage(param1:DBFacade) : void
      {
         param1.metrics.log("ShopStoragePagePresented");
         var _loc2_:UIOfferPopup = new UIOfferPopup(param1,Locale.getString("SHOP_STORAGE_PAGE_TITLE"),STORAGE_OFFERS,null,null);
      }
      
      public static function showGiftPage(param1:DBFacade, param2:Function) : void
      {
         param1.metrics.log("ShopGiftPagePresented");
         var _loc3_:UIGiftPage = new UIGiftPage(param1,param2,null);
      }
   }
}

