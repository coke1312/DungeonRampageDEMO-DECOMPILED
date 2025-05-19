package UI
{
   import Account.AvatarInfo;
   import Brain.AssetRepository.SwfAsset;
   import Brain.UI.UIObject;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMOffer;
   import GameMasterDictionary.GMOfferDetail;
   import GameMasterDictionary.GMRarity;
   import GameMasterDictionary.GMWeaponItem;
   import UI.Inventory.UITapHoldTooltip;
   import UI.Inventory.UIWeaponDescTooltip;
   import UI.Modifiers.UIModifier;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class UIShopWeaponOffer extends UIShopOffer
   {
      
      public static const WEAPON_CARD_ROLL_OVER_SCALE:Number = 1.025;
      
      protected var mTapIcon:UIObject;
      
      protected var mTapTooltip:UITapHoldTooltip;
      
      protected var mHoldIcon:UIObject;
      
      protected var mHoldTooltip:UITapHoldTooltip;
      
      protected var mPower:MovieClip;
      
      protected var mPowerLabel:TextField;
      
      protected var mGMOfferDetail:GMOfferDetail;
      
      protected var mGMWeaponItem:GMWeaponItem;
      
      protected var mRollOverCallback:Function;
      
      protected var mRollOutCallback:Function;
      
      protected var mWeaponDescTooltip:UIWeaponDescTooltip;
      
      protected var mUIModifierList:Vector.<UIModifier>;
      
      protected var mRibbonA:MovieClip;
      
      protected var mRibbonB:MovieClip;
      
      public function UIShopWeaponOffer(param1:DBFacade, param2:Class, param3:Class, param4:Class, param5:Function = null)
      {
         super(param1,param2,param5);
         mRibbonA = mRoot.ribbon_A;
         mRibbonB = mRoot.ribbon_B;
         mRibbonA.visible = false;
         mRibbonB.visible = false;
         mPower = mRoot.power;
         if(mPower != null)
         {
            mPowerLabel = mPower.label;
         }
         mTapIcon = new UIObject(mDBFacade,mRoot.tap_icon);
         mTapTooltip = new UITapHoldTooltip(mDBFacade,param4);
         mTapIcon.tooltip = mTapTooltip;
         mTapTooltip.visible = false;
         mHoldIcon = new UIObject(mDBFacade,mRoot.hit_icon);
         mHoldTooltip = new UITapHoldTooltip(mDBFacade,param4);
         mHoldIcon.tooltip = mHoldTooltip;
         mHoldTooltip.visible = false;
         mWeaponDescTooltip = new UIWeaponDescTooltip(mDBFacade,param3);
         mIconParent.tooltip = mWeaponDescTooltip;
         mWeaponDescTooltip.visible = false;
         mRoot.label_tap.text = Locale.getString("TAP");
         mRoot.label_charge.text = Locale.getString("HOLD");
         mRoot.label_modifier.text = Locale.getString("MODIFIERS");
         mUIModifierList = new Vector.<UIModifier>();
      }
      
      override public function destroy() : void
      {
         mTapTooltip.destroy();
         mTapIcon.destroy();
         mTapIcon = null;
         mHoldTooltip.destroy();
         mHoldIcon.destroy();
         mHoldIcon = null;
         mRollOverCallback = null;
         mRollOutCallback = null;
         mWeaponDescTooltip.destroy();
         if(mUIModifierList)
         {
            for each(var _loc1_ in mUIModifierList)
            {
               _loc1_.destroy();
            }
         }
         mUIModifierList = null;
         super.destroy();
      }
      
      override protected function get nativeIconSize() : Number
      {
         return 100;
      }
      
      public function setRolloverCallbacks(param1:Function, param2:Function) : void
      {
         mRollOverCallback = param1;
         mRollOutCallback = param2;
      }
      
      override protected function onRollOver(param1:MouseEvent) : void
      {
         super.onRollOver(param1);
         if(mRollOverCallback != null)
         {
            mRollOverCallback(mGMWeaponItem,mGMOfferDetail.WeaponPower);
         }
         mRoot.scaleX = mRoot.scaleY = 1.025;
      }
      
      override protected function onRollOut(param1:MouseEvent) : void
      {
         super.onRollOut(param1);
         if(mRollOutCallback != null)
         {
            mRollOutCallback(mGMWeaponItem,mGMOfferDetail.WeaponPower);
         }
      }
      
      override protected function shouldGreyOffer(param1:GMHero) : Boolean
      {
         return false;
      }
      
      override public function showOffer(param1:GMOffer, param2:GMHero) : void
      {
         var stagePos:Point;
         var weaponName:String;
         var swfPath:String;
         var iconName:String;
         var swfPath1:String;
         var iconName1:String;
         var preNameModifiers:String;
         var i:int;
         var avatarInfo:AvatarInfo;
         var format:TextFormat;
         var sizeMult:Number;
         var rarity:GMRarity;
         var gmOffer:GMOffer = param1;
         var gmHero:GMHero = param2;
         this.offer = gmOffer;
         mGMOfferDetail = this.offer.Details[0];
         mGMWeaponItem = mDBFacade.gameMaster.weaponItemById.itemFor(mGMOfferDetail.WeaponId);
         super.showOffer(gmOffer,gmHero);
         weaponName = "";
         weaponName = gmOffer.getDisplayName(mDBFacade.gameMaster);
         mWeaponDescTooltip.setWeaponItem(mGMWeaponItem,mGMOfferDetail.Level);
         mWeaponDescTooltip.visible = true;
         stagePos = new Point();
         stagePos.y += mIconParent.root.height * 0.5;
         mIconParent.tooltipPos = stagePos;
         if(mGMWeaponItem.TapIcon && mGMWeaponItem.TapIcon != "")
         {
            mTapIcon.visible = true;
            swfPath = "Resources/Art2D/Icons/weapon_ability/db_icons_weapon_ability.swf";
            iconName = mGMWeaponItem.TapIcon;
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
                     mTapIcon.root.addChild(_loc2_);
                     mTapTooltip.setValues(mGMWeaponItem.TapTitle,mGMWeaponItem.TapDescription);
                     mTapTooltip.visible = true;
                     stagePos = new Point();
                     stagePos.y += mTapIcon.root.height * 0.5;
                     mTapIcon.tooltipPos = stagePos;
                  }
               });
            }
         }
         if(mGMWeaponItem.HoldIcon && mGMWeaponItem.HoldIcon != "")
         {
            mHoldIcon.visible = true;
            swfPath1 = "Resources/Art2D/Icons/weapon_ability/db_icons_weapon_ability.swf";
            iconName1 = mGMWeaponItem.HoldIcon;
            if(swfPath1 && iconName1)
            {
               mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(swfPath1),function(param1:SwfAsset):void
               {
                  var _loc2_:MovieClip = null;
                  var _loc4_:String = null;
                  var _loc3_:Class = param1.getClass(iconName1);
                  if(_loc3_)
                  {
                     _loc2_ = new _loc3_();
                     _loc2_.scaleX = _loc2_.scaleY = 0.5;
                     mHoldIcon.root.addChild(_loc2_);
                     _loc4_ = mGMWeaponItem.WeaponController != null ? Locale.getString(mGMWeaponItem.WeaponController) : mGMWeaponItem.HoldTitle;
                     mHoldTooltip.setValues(_loc4_,mGMWeaponItem.HoldDescription);
                     mHoldTooltip.visible = true;
                     stagePos = new Point();
                     stagePos.y += mHoldIcon.root.height * 0.5;
                     mHoldIcon.tooltipPos = stagePos;
                  }
               });
            }
         }
         mPower.visible = true;
         mPowerLabel.text = mGMOfferDetail.WeaponPower.toString();
         if(mGMOfferDetail.Modifier1 != null)
         {
            mUIModifierList.push(new UIModifier(mDBFacade,mRoot.modifier_icon_1,mGMOfferDetail.Modifier1));
         }
         if(mGMOfferDetail.Modifier2 != null)
         {
            mUIModifierList.push(new UIModifier(mDBFacade,mRoot.modifier_icon_2,mGMOfferDetail.Modifier2));
         }
         if(mGMOfferDetail.Modifier3 != null)
         {
            mUIModifierList.push(new UIModifier(mDBFacade,mRoot.modifier_icon_3,mGMOfferDetail.Modifier3));
         }
         preNameModifiers = "";
         i = 0;
         while(i < mUIModifierList.length)
         {
            preNameModifiers += mUIModifierList[i].gmModifier.Name.toUpperCase() + " ";
            ++i;
         }
         weaponName = preNameModifiers + mTitle.text;
         if(this.offer.EndDate || this.offer.StartDate)
         {
            if(this.offer.LimitedQuantity > 0)
            {
               mRibbonA.visible = false;
               mRibbonB.visible = true;
               mRibbonB.timer.text = getDateString();
               mRibbonB.limit_label.text = getQuantityString();
            }
            else
            {
               mRibbonA.visible = true;
               mRibbonB.visible = false;
               mRibbonA.timer.text = getDateString();
            }
         }
         avatarInfo = mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(gmHero.Id);
         if(!avatarInfo || avatarInfo.level < mGMOfferDetail.Level)
         {
            mLevelStarLabel.textColor = mRequiresLabel.textColor = 15535124;
         }
         format = new TextFormat();
         sizeMult = 0.1;
         if(weaponName.length <= 32)
         {
            format.size = 13;
            sizeMult = weaponName.length < 16 ? 0.2 : 0.1;
            mTitle.y = mTitleY + mTitle.height * sizeMult;
         }
         else
         {
            format.size = 11;
            mTitle.y = mTitleY;
         }
         mTitle.defaultTextFormat = format;
         mTitle.text = weaponName;
         rarity = mDBFacade.gameMaster.rarityByConstant.itemFor(mGMOfferDetail.Rarity);
         if(rarity != null && rarity.TextColor)
         {
            mTitle.textColor = rarity.TextColor;
         }
      }
      
      override protected function get offerDescription() : String
      {
         return mGMWeaponItem ? mGMWeaponItem.getWeaponAesthetic(mGMOfferDetail.Level).Description : "";
      }
      
      override protected function get offerIconName() : String
      {
         return mGMWeaponItem ? mGMWeaponItem.getWeaponAesthetic(mGMOfferDetail.Level).IconName : "";
      }
      
      override protected function get offerSwfPath() : String
      {
         return mGMWeaponItem ? mGMWeaponItem.getWeaponAesthetic(mGMOfferDetail.Level).IconSwf : "";
      }
      
      override protected function hasRequirements() : Boolean
      {
         if(mGMOfferDetail)
         {
            if(mGMOfferDetail.Level > 0)
            {
               mRequiresLabel.appendText(mGMOfferDetail.Level.toString());
               return true;
            }
         }
         return false;
      }
      
      override protected function requirementsMetForPurchase() : Boolean
      {
         return true;
      }
   }
}

