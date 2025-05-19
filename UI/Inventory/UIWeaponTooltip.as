package UI.Inventory
{
   import Account.ItemInfo;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Combat.Weapon.WeaponGameObject;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMModifier;
   import GameMasterDictionary.GMRarity;
   import UI.Modifiers.UIModifier;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class UIWeaponTooltip extends MovieClip
   {
      
      public static const TAP_HOLD_ICONS_SWF:String = "Resources/Art2D/Icons/weapon_ability/db_icons_weapon_ability.swf";
      
      protected var mDBFacade:DBFacade;
      
      protected var mRoot:MovieClip;
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      protected var mNameLabel:TextField;
      
      protected var mPowerLabel:TextField;
      
      protected var mLevelLabel:TextField;
      
      protected var mTapIcon:MovieClip;
      
      protected var mHoldIcon:MovieClip;
      
      protected var mModifiersList:Vector.<UIModifier>;
      
      public function UIWeaponTooltip(param1:DBFacade, param2:Class)
      {
         super();
         mDBFacade = param1;
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mRoot = new param2();
         this.addChild(mRoot);
         mNameLabel = mRoot.title_label;
         mPowerLabel = mRoot.power.label;
         mTapIcon = mRoot.tap_icon;
         mHoldIcon = mRoot.icon;
         mLevelLabel = mRoot.level_label;
         mModifiersList = new Vector.<UIModifier>();
      }
      
      public function destroy() : void
      {
         mAssetLoadingComponent.destroy();
         mDBFacade = null;
         this.removeChild(mRoot);
         mRoot = null;
      }
      
      public function setWeaponItemFromWeaponGameObject(param1:WeaponGameObject) : void
      {
         var _loc3_:int = 0;
         clearAllIcons();
         mNameLabel.text = param1.name.toUpperCase();
         var _loc6_:GMRarity = mDBFacade.gameMaster.rarityById.itemFor(param1.rarity);
         var _loc4_:uint = uint(_loc6_ != null && _loc6_.TextColor ? _loc6_.TextColor : 15463921);
         mNameLabel.textColor = _loc4_;
         mPowerLabel.text = param1.power.toString();
         mLevelLabel.text = Locale.getString("ITEM_CARD_LEVEL_REQUIREMENT") + param1.requiredLevel;
         loadIcon(param1.weaponData.TapIcon,mTapIcon);
         loadIcon(param1.weaponData.HoldIcon,mHoldIcon);
         var _loc2_:String = "";
         var _loc5_:Vector.<GMModifier> = param1.modifierList;
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            mModifiersList.push(new UIModifier(mDBFacade,mRoot.getChildByName("modifier_icon_" + (_loc3_ + 1).toString()) as MovieClip,_loc5_[_loc3_].Constant));
            _loc2_ += _loc5_[_loc3_].Name.toUpperCase() + " ";
            _loc3_++;
         }
         mNameLabel.text = _loc2_ + mNameLabel.text;
         if(param1.legendaryModifier)
         {
            mModifiersList.push(new UIModifier(mDBFacade,mRoot.getChildByName("modifier_icon_3") as MovieClip,"",0,true,param1.legendaryModifier.Id));
            mNameLabel.text = param1.weaponData.getWeaponAesthetic(0,true).Name;
         }
         mNameLabel.text = mNameLabel.text.toUpperCase();
      }
      
      public function setWeaponItemFromItemInfo(param1:ItemInfo) : void
      {
         var _loc3_:int = 0;
         clearAllIcons();
         mNameLabel.text = param1.Name.toUpperCase();
         mNameLabel.textColor = param1.getTextColor();
         mPowerLabel.text = param1.power.toString();
         mLevelLabel.text = Locale.getString("ITEM_CARD_LEVEL_REQUIREMENT") + param1.requiredLevel;
         loadIcon(param1.gmWeaponItem.TapIcon,mTapIcon);
         loadIcon(param1.gmWeaponItem.HoldIcon,mHoldIcon);
         var _loc2_:String = "";
         var _loc4_:Vector.<GMModifier> = param1.modifiers;
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            mModifiersList.push(new UIModifier(mDBFacade,mRoot.getChildByName("modifier_icon_" + (_loc3_ + 1).toString()) as MovieClip,_loc4_[_loc3_].Constant));
            _loc2_ += _loc4_[_loc3_].Name.toUpperCase() + " ";
            _loc3_++;
         }
         mNameLabel.text = _loc2_ + mNameLabel.text;
         if(param1.legendaryModifier)
         {
            mModifiersList.push(new UIModifier(mDBFacade,mRoot.getChildByName("modifier_icon_3") as MovieClip,"",0,true,param1.legendaryModifier));
            mNameLabel.text = param1.gmWeaponItem.getWeaponAesthetic(0,true).Name;
         }
         mNameLabel.text = mNameLabel.text.toUpperCase();
      }
      
      public function setWeaponItemFromData(param1:String, param2:uint, param3:String, param4:String, param5:uint, param6:uint, param7:uint, param8:uint, param9:uint) : void
      {
         var _loc10_:int = 0;
         clearAllIcons();
         mNameLabel.text = param1.toUpperCase();
         var _loc14_:GMRarity = mDBFacade.gameMaster.rarityById.itemFor(param8);
         var _loc11_:uint = uint(_loc14_ != null && _loc14_.TextColor ? _loc14_.TextColor : 15463921);
         mNameLabel.textColor = _loc11_;
         mPowerLabel.text = param2.toString();
         mLevelLabel.text = Locale.getString("ITEM_CARD_LEVEL_REQUIREMENT") + param9;
         loadIcon(param3,mTapIcon);
         loadIcon(param4,mHoldIcon);
         var _loc13_:String = "";
         var _loc12_:Vector.<GMModifier> = new Vector.<GMModifier>();
         if(param5 > 0)
         {
            _loc12_.push(mDBFacade.gameMaster.modifiersById.itemFor(param5));
         }
         if(param6 > 0)
         {
            _loc12_.push(mDBFacade.gameMaster.modifiersById.itemFor(param6));
         }
         _loc10_ = 0;
         while(_loc10_ < _loc12_.length)
         {
            mModifiersList.push(new UIModifier(mDBFacade,mRoot.getChildByName("modifier_icon_" + (_loc10_ + 1).toString()) as MovieClip,_loc12_[_loc10_].Constant));
            _loc13_ += _loc12_[_loc10_].Name.toUpperCase() + " ";
            _loc10_++;
         }
         if(param7)
         {
            mModifiersList.push(new UIModifier(mDBFacade,mRoot.getChildByName("modifier_icon_3") as MovieClip,"",0,true,param7));
         }
         else
         {
            mNameLabel.text = _loc13_ + mNameLabel.text;
         }
         mNameLabel.text = mNameLabel.text.toUpperCase();
      }
      
      private function clearAllIcons() : void
      {
         var _loc1_:int = 0;
         if(mTapIcon.numChildren > 1)
         {
            mTapIcon.removeChildAt(1);
         }
         if(mHoldIcon.numChildren > 1)
         {
            mHoldIcon.removeChildAt(1);
         }
         if(mModifiersList.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < mModifiersList.length)
            {
               mModifiersList[_loc1_].destroy();
               _loc1_++;
            }
            mModifiersList.splice(0,mModifiersList.length);
         }
      }
      
      private function loadIcon(param1:String, param2:MovieClip) : void
      {
         var swfPath:String;
         var iconName:String = param1;
         var parentMC:MovieClip = param2;
         if(iconName == null || iconName == "")
         {
            return;
         }
         swfPath = "Resources/Art2D/Icons/weapon_ability/db_icons_weapon_ability.swf";
         if(swfPath && iconName)
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(swfPath),function(param1:SwfAsset):void
            {
               var _loc2_:MovieClip = null;
               var _loc3_:Class = param1.getClass(iconName);
               if(_loc3_)
               {
                  _loc2_ = new _loc3_();
                  _loc2_.scaleX = _loc2_.scaleY = 0.5;
                  parentMC.addChildAt(_loc2_,1);
               }
            });
         }
      }
   }
}

