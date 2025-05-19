package Account
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import GameMasterDictionary.GMInventoryBase;
   import GameMasterDictionary.GMLegendaryModifier;
   import GameMasterDictionary.GMModifier;
   import GameMasterDictionary.GMNpc;
   import GameMasterDictionary.GMOffer;
   import GameMasterDictionary.GMRarity;
   import GameMasterDictionary.GMWeaponAesthetic;
   import GameMasterDictionary.GMWeaponItem;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class ItemInfo extends InventoryBaseInfo
   {
      
      private var mAvatarId:uint;
      
      private var mAvatarSlot:uint;
      
      private var mCreated:String;
      
      private var mPower:uint;
      
      private var mGMWeapon:GMWeaponItem;
      
      private var mModifiers:Vector.<GMModifier> = new Vector.<GMModifier>();
      
      private var mLegendaryModifier:uint = 0;
      
      private var mRarity:Number;
      
      private var mGMRarity:GMRarity;
      
      private var mRequiredLevel:Number;
      
      public function ItemInfo(param1:DBFacade, param2:Object)
      {
         super(param1,param2);
         mGMWeapon = mDBFacade.gameMaster.weaponItemById.itemFor(mGMId);
         if(mGMWeapon == null)
         {
            Logger.error("GMWeapon is null cannot find item for ID: " + mGMId);
         }
         mGMInventoryBase = mGMWeapon;
         mGMRarity = mDBFacade.gameMaster.rarityById.itemFor(mRarity);
      }
      
      public static function loadItemIconFromId(param1:uint, param2:DisplayObjectContainer, param3:DBFacade, param4:uint, param5:uint, param6:AssetLoadingComponent = null) : void
      {
         var _loc7_:GMNpc = null;
         var _loc8_:GMInventoryBase = param3.gameMaster.stackableById.itemFor(param1);
         if(_loc8_ == null)
         {
            _loc7_ = param3.gameMaster.npcById.itemFor(param1);
            if(_loc7_ == null)
            {
               Logger.error("Unable to find gmItem for item id: " + param1);
               return;
            }
            loadItemIcon(_loc7_.IconSwfFilepath,_loc7_.IconName,param2,param3,param4,param5,param6);
            return;
         }
         loadItemIcon(_loc8_.UISwfFilepath,_loc8_.IconName,param2,param3,param4,param5,param6);
      }
      
      public static function loadItemIconFromItemInfo(param1:ItemInfo, param2:DisplayObjectContainer, param3:DBFacade, param4:uint, param5:uint, param6:AssetLoadingComponent = null) : void
      {
         var bgColoredExists:Boolean;
         var bgSwfPath:String;
         var bgIconName:String;
         var itemInfo:ItemInfo = param1;
         var container:DisplayObjectContainer = param2;
         var dbFacade:DBFacade = param3;
         var desiredSize:uint = param4;
         var iconsNativeSize:uint = param5;
         var assetLoadingComponent:AssetLoadingComponent = param6;
         loadItemIcon(itemInfo.uiSwfFilepath,itemInfo.iconName,container,dbFacade,desiredSize,iconsNativeSize,assetLoadingComponent);
         bgColoredExists = itemInfo.hasColoredBackground;
         bgSwfPath = itemInfo.backgroundSwfPath;
         bgIconName = itemInfo.backgroundIconName;
         if(bgColoredExists)
         {
            assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(bgSwfPath),function(param1:SwfAsset):void
            {
               var _loc3_:MovieClip = null;
               var _loc2_:Class = param1.getClass(bgIconName);
               if(_loc2_)
               {
                  _loc3_ = new _loc2_() as MovieClip;
                  _loc3_.scaleX = _loc3_.scaleY = 0.85;
                  container.addChildAt(_loc3_,0);
               }
            });
         }
      }
      
      public static function loadItemIcon(param1:String, param2:String, param3:DisplayObjectContainer, param4:DBFacade, param5:uint, param6:uint, param7:AssetLoadingComponent = null, param8:Function = null) : void
      {
         var swfPath:String = param1;
         var iconName:String = param2;
         var container:DisplayObjectContainer = param3;
         var dbFacade:DBFacade = param4;
         var desiredSize:uint = param5;
         var iconsNativeSize:uint = param6;
         var assetLoadingComponent:AssetLoadingComponent = param7;
         var onCompletionCallback:Function = param8;
         var destroyAssetLoaderOnCompletion:Boolean = false;
         if(assetLoadingComponent == null)
         {
            assetLoadingComponent = new AssetLoadingComponent(dbFacade);
            destroyAssetLoaderOnCompletion = true;
         }
         if(swfPath == null || swfPath == "")
         {
            Logger.error("swfPath provided to ItemInfo::loadItemIcon is empty or null.");
         }
         assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(swfPath),function(param1:SwfAsset):void
         {
            var _loc3_:Class = param1.getClass(iconName);
            if(_loc3_ == null)
            {
               Logger.error("Unable to get iconClass for iconName: " + iconName);
               return;
            }
            var _loc2_:MovieClip = new _loc3_();
            if(iconsNativeSize == 0)
            {
               iconsNativeSize = _loc2_.width;
            }
            _loc2_.scaleX = _loc2_.scaleY = desiredSize / iconsNativeSize;
            container.addChild(_loc2_);
            if(destroyAssetLoaderOnCompletion)
            {
               assetLoadingComponent.destroy();
            }
            if(onCompletionCallback != null)
            {
               onCompletionCallback();
            }
         });
      }
      
      override public function get Description() : String
      {
         var _loc1_:GMWeaponAesthetic = this.gmWeaponAesthetic;
         return _loc1_ ? _loc1_.Description : "";
      }
      
      override public function get iconScale() : Number
      {
         return 100;
      }
      
      public function get power() : uint
      {
         return mPower;
      }
      
      public function get gmWeaponItem() : GMWeaponItem
      {
         return mGMWeapon;
      }
      
      public function get gmWeaponAesthetic() : GMWeaponAesthetic
      {
         return mGMWeapon.getWeaponAesthetic(requiredLevel,mLegendaryModifier > 0);
      }
      
      public function get requiredLevel() : uint
      {
         return mRequiredLevel;
      }
      
      public function get rarity() : GMRarity
      {
         return mGMRarity;
      }
      
      override public function get uiSwfFilepath() : String
      {
         var _loc1_:GMWeaponAesthetic = this.gmWeaponAesthetic;
         return _loc1_ ? _loc1_.IconSwf : null;
      }
      
      override public function get iconName() : String
      {
         var _loc1_:GMWeaponAesthetic = this.gmWeaponAesthetic;
         return _loc1_ ? _loc1_.IconName : null;
      }
      
      override public function get isEquipped() : Boolean
      {
         return this.gmWeaponItem && this.avatarId != 0;
      }
      
      public function get avatarId() : uint
      {
         return mAvatarId;
      }
      
      public function set avatarId(param1:uint) : void
      {
         mAvatarId = param1;
      }
      
      public function get avatarSlot() : uint
      {
         return mAvatarSlot;
      }
      
      public function set avatarSlot(param1:uint) : void
      {
         mAvatarSlot = param1;
      }
      
      override protected function parseJson(param1:Object) : void
      {
         var _loc4_:GMModifier = null;
         var _loc2_:GMModifier = null;
         var _loc3_:GMLegendaryModifier = null;
         if(param1 == null)
         {
            return;
         }
         mGMId = param1.item_id as uint;
         mAccountId = param1.account_id as uint;
         mAvatarId = param1.avatar_id as uint;
         mDatabaseId = param1.id as uint;
         mAvatarSlot = param1.avatar_slot as uint;
         mCreated = param1.created as String;
         mPower = param1.power as uint;
         mIsNew = false;
         mRarity = param1.rarity;
         mRequiredLevel = param1.requiredlevel;
         if(param1.modifier1 > 0)
         {
            _loc4_ = mDBFacade.gameMaster.modifiersById.itemFor(param1.modifier1);
            if(_loc4_)
            {
               mModifiers.push(_loc4_);
            }
            else
            {
               Logger.error("Bad modifier id: " + param1.modifier1);
            }
         }
         if(param1.modifier2 > 0)
         {
            _loc2_ = mDBFacade.gameMaster.modifiersById.itemFor(param1.modifier2);
            if(_loc2_)
            {
               mModifiers.push(_loc2_);
            }
            else
            {
               Logger.error("Bad modifier id: " + param1.modifier2);
            }
         }
         if(param1.legendarymodifier > 0)
         {
            _loc3_ = mDBFacade.gameMaster.legendaryModifiersById.itemFor(param1.legendarymodifier);
            if(_loc3_)
            {
               mLegendaryModifier = _loc3_.Id;
            }
            else
            {
               Logger.error("Bad modifier id: " + param1.legendarymodifier);
            }
         }
      }
      
      override public function get sellCoins() : int
      {
         var _loc7_:GMWeaponItem = mGMWeapon;
         var _loc3_:GMRarity = mGMRarity;
         var _loc8_:GMOffer = mDBFacade.gameMaster.offerById.itemFor(_loc3_.KeyOfferId);
         if(_loc8_.CoinOffer)
         {
            _loc8_ = _loc8_.CoinOffer;
         }
         var _loc2_:Number = 0;
         var _loc4_:Number = 1;
         if(_loc3_.NumberOfModifiers > 0)
         {
            _loc4_ = _loc3_.NumberOfModifiers * 3;
            for each(var _loc5_ in mModifiers)
            {
               _loc2_ += _loc5_.MODIFIER_LEVEL;
            }
         }
         var _loc6_:Number = mRequiredLevel / 100 * _loc3_.LevelWeight + _loc2_ * 1 / _loc4_ * _loc3_.ModifierWeight;
         var _loc1_:Number = _loc8_.Price;
         return Math.round(((_loc3_.MaxSellPercent - _loc3_.MinSellPercent) * _loc6_ + _loc3_.MinSellPercent) * _loc1_);
      }
      
      public function hasModifier(param1:String) : Boolean
      {
         for each(var _loc2_ in mModifiers)
         {
            if(_loc2_.Constant == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get modifiers() : Vector.<GMModifier>
      {
         return mModifiers;
      }
      
      public function get legendaryModifier() : uint
      {
         return mLegendaryModifier;
      }
      
      override public function getTextColor() : uint
      {
         var _loc1_:GMRarity = mDBFacade.gameMaster.rarityById.itemFor(mRarity);
         return _loc1_ != null && _loc1_.TextColor ? _loc1_.TextColor : 15463921;
      }
      
      override public function get hasColoredBackground() : Boolean
      {
         var _loc1_:GMRarity = mDBFacade.gameMaster.rarityById.itemFor(mRarity);
         return _loc1_ != null ? _loc1_.HasColoredBackground : false;
      }
      
      override public function get backgroundIconName() : String
      {
         var _loc1_:GMRarity = mDBFacade.gameMaster.rarityById.itemFor(mRarity);
         return _loc1_ != null ? _loc1_.BackgroundIcon : "";
      }
      
      override public function get backgroundSwfPath() : String
      {
         var _loc1_:GMRarity = mDBFacade.gameMaster.rarityById.itemFor(mRarity);
         return _loc1_ != null ? _loc1_.BackgroundSwf : "";
      }
      
      override public function get backgroundIconBorderName() : String
      {
         var _loc1_:GMRarity = mDBFacade.gameMaster.rarityById.itemFor(mRarity);
         return _loc1_ != null ? _loc1_.BackgroundIconBorder : "";
      }
      
      override public function get Name() : String
      {
         return gmWeaponAesthetic.Name;
      }
   }
}

