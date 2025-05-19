package UI.EquipPicker
{
   import Account.AvatarInfo;
   import Account.InventoryBaseInfo;
   import Account.ItemInfo;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.UI.UIButton;
   import Brain.UI.UIObject;
   import Brain.UI.UIPopup;
   import Events.DBAccountResponseEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMWeaponItem;
   import UI.Inventory.UIInventoryItem;
   import flash.display.MovieClip;
   
   public class HeroWithEquipPicker extends UIObject
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mEventComponent:EventComponent;
      
      private var mHeroSlots:Vector.<HeroElement>;
      
      private var mEquipElements:Vector.<AvatarEquipElement>;
      
      private var mEquipSlots:Vector.<EquipSlot>;
      
      private var mShiftLeft:UIButton;
      
      private var mShiftRight:UIButton;
      
      private var mHeroSelectedCallback:Function;
      
      private var mClickedEquippedWeaponCallback:Function;
      
      private var mSetSelectedHeroCallback:Function;
      
      private var mGetSelectedHeroCallback:Function;
      
      private var mCurrentStartIndex:uint = 0;
      
      private var mTotalGMHeroes:uint;
      
      private var mEquipResponseCallback:Function;
      
      private var mAllowSelectingUnownedHeroes:Boolean = true;
      
      private var mSelectedHeroIndex:int = -1;
      
      public function HeroWithEquipPicker(param1:DBFacade, param2:MovieClip, param3:Class, param4:Class, param5:Class, param6:Function, param7:Function = null, param8:Function = null, param9:Function = null, param10:Function = null, param11:Boolean = false, param12:Boolean = true)
      {
         var dbFacade:DBFacade = param1;
         var root:MovieClip = param2;
         var weaponTooltipClass:Class = param3;
         var weaponTooltipZClass:Class = param4;
         var heroTooltipClass:Class = param5;
         var heroSelectedCallback:Function = param6;
         var clickedEquippedWeaponCallback:Function = param7;
         var getSelectedHeroIndexCallback:Function = param8;
         var setSelectedHeroIndexCallback:Function = param9;
         var equipResponseFinishedCallback:Function = param10;
         var allowEquipmentSwapping:Boolean = param11;
         var allowSelectingUnownedHeroes:Boolean = param12;
         super(dbFacade,root);
         mDBFacade = dbFacade;
         mAllowSelectingUnownedHeroes = allowSelectingUnownedHeroes;
         mEventComponent = new EventComponent(mDBFacade);
         mHeroSelectedCallback = heroSelectedCallback;
         mClickedEquippedWeaponCallback = clickedEquippedWeaponCallback;
         mEquipResponseCallback = equipResponseFinishedCallback;
         mSetSelectedHeroCallback = setSelectedHeroIndexCallback;
         mGetSelectedHeroCallback = getSelectedHeroIndexCallback;
         mEquipElements = new Vector.<AvatarEquipElement>();
         mEquipElements.push(new AvatarEquipElement(mDBFacade,"Z",mRoot.UI_weapons.equip_slot_0,weaponTooltipZClass,unequipItem,handleItemDrop,0,equippedWeaponClicked,equipResponseFinishedCallback,allowEquipmentSwapping));
         mEquipElements.push(new AvatarEquipElement(mDBFacade,"X",mRoot.UI_weapons.equip_slot_1,weaponTooltipClass,unequipItem,handleItemDrop,1,equippedWeaponClicked,equipResponseFinishedCallback,allowEquipmentSwapping));
         mEquipElements.push(new AvatarEquipElement(mDBFacade,"C",mRoot.UI_weapons.equip_slot_2,weaponTooltipClass,unequipItem,handleItemDrop,2,equippedWeaponClicked,equipResponseFinishedCallback,allowEquipmentSwapping));
         mEquipSlots = new Vector.<EquipSlot>();
         mEquipSlots.push(new EquipSlot(mDBFacade,mRoot.empty_z,this.handleItemDrop,0));
         mEquipSlots.push(new EquipSlot(mDBFacade,mRoot.empty_x,this.handleItemDrop,1));
         mEquipSlots.push(new EquipSlot(mDBFacade,mRoot.empty_c,this.handleItemDrop,2));
         mHeroSlots = new Vector.<HeroElement>();
         mHeroSlots.push(new HeroElement(mDBFacade,mRoot.hero_slot_0,heroTooltipClass,heroClicked));
         mHeroSlots.push(new HeroElement(mDBFacade,mRoot.hero_slot_1,heroTooltipClass,heroClicked));
         mHeroSlots.push(new HeroElement(mDBFacade,mRoot.hero_slot_2,heroTooltipClass,heroClicked));
         mHeroSlots.push(new HeroElement(mDBFacade,mRoot.hero_slot_3,heroTooltipClass,heroClicked));
         mHeroSlots.push(new HeroElement(mDBFacade,mRoot.hero_slot_4,heroTooltipClass,heroClicked));
         mHeroSlots.push(new HeroElement(mDBFacade,mRoot.hero_slot_5,heroTooltipClass,heroClicked));
         mHeroSlots.push(new HeroElement(mDBFacade,mRoot.hero_slot_6,heroTooltipClass,heroClicked));
         mHeroSlots.push(new HeroElement(mDBFacade,mRoot.hero_slot_7,heroTooltipClass,heroClicked));
         mHeroSlots.push(new HeroElement(mDBFacade,mRoot.hero_slot_8,heroTooltipClass,heroClicked));
         mHeroSlots.push(new HeroElement(mDBFacade,mRoot.hero_slot_8,heroTooltipClass,heroClicked));
         mShiftLeft = new UIButton(mDBFacade,mRoot.shift_left);
         mShiftLeft.releaseCallback = shiftLeft;
         mShiftRight = new UIButton(mDBFacade,mRoot.shift_right);
         mShiftRight.releaseCallback = shiftRight;
         mTotalGMHeroes = mDBFacade.gameMaster.Heroes.length;
         mEventComponent.addListener("DB_ACCOUNT_INFO_RESPONSE",function(param1:DBAccountResponseEvent):void
         {
            refresh();
         });
      }
      
      private function get selectedHeroIndex() : int
      {
         if(mGetSelectedHeroCallback != null)
         {
            mSelectedHeroIndex = mGetSelectedHeroCallback();
         }
         return mSelectedHeroIndex;
      }
      
      private function set selectedHeroIndex(param1:int) : void
      {
         mSelectedHeroIndex = param1;
         if(mSetSelectedHeroCallback != null)
         {
            mSetSelectedHeroCallback(mSelectedHeroIndex);
         }
      }
      
      private function equippedWeaponClicked(param1:AvatarEquipElement) : void
      {
         deselectEquipment();
         if(mClickedEquippedWeaponCallback != null && param1.itemInfo != null)
         {
            param1.select();
            mClickedEquippedWeaponCallback(param1.itemInfo);
         }
      }
      
      public function showWeaponComparison(param1:GMWeaponItem, param2:uint) : void
      {
         for each(var _loc3_ in mHeroSlots)
         {
            _loc3_.showWeaponComparison(param1,param2);
         }
      }
      
      public function hideWeaponComparison() : void
      {
         for each(var _loc1_ in mHeroSlots)
         {
            _loc1_.hideWeaponComparison();
         }
      }
      
      public function show() : void
      {
         mRoot.visible = true;
      }
      
      public function hide() : void
      {
         mRoot.visible = false;
      }
      
      public function get currentlySelectedHero() : GMHero
      {
         return selectedHeroIndex != -1 ? mHeroSlots[selectedHeroIndex].gmHero : null;
      }
      
      public function get currentlySelectedAvatarInfo() : AvatarInfo
      {
         var _loc1_:GMHero = this.currentlySelectedHero;
         return _loc1_ ? mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(_loc1_.Id) : null;
      }
      
      override public function destroy() : void
      {
         mEventComponent.destroy();
         mDBFacade = null;
         mShiftLeft.destroy();
         mShiftRight.destroy();
         mHeroSelectedCallback = null;
         super.destroy();
      }
      
      private function setActiveAvatarAsCurrentSelection() : void
      {
         var _loc2_:Array = null;
         var _loc1_:AvatarInfo = mDBFacade.dbAccountInfo.activeAvatarInfo;
         if(_loc1_ == null)
         {
            Logger.warn("No active avatar set on account id: " + mDBFacade.accountId);
            if(mDBFacade.dbAccountInfo.inventoryInfo.avatars == null)
            {
               Logger.error("setActiveAvatarAsCurrentSelection() - mDBFacade.dbAccountInfo.inventoryInfo.avatars == null on account id: " + mDBFacade.accountId);
            }
            _loc2_ = mDBFacade.dbAccountInfo.inventoryInfo.avatars.keysToArray();
            if(_loc2_ == null)
            {
               Logger.error("No avatars found on account id: " + mDBFacade.accountId);
               return;
            }
            _loc1_ = mDBFacade.dbAccountInfo.inventoryInfo.avatars.itemFor(_loc2_[0]) as AvatarInfo;
            if(_loc1_ == null)
            {
               Logger.fatal("Could not get avatar info for key: " + _loc2_[0] + " Unable to get active avatar.");
               return;
            }
         }
         selectedHeroIndex = findHeroIndex(_loc1_.avatarType);
      }
      
      public function setAvatarAlert(param1:Boolean) : void
      {
         var _loc2_:AvatarInfo = null;
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < mHeroSlots.length)
         {
            if(param1)
            {
               if(mHeroSlots[_loc3_].gmHero)
               {
                  _loc2_ = mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(mHeroSlots[_loc3_].gmHero.Id) as AvatarInfo;
                  if(_loc2_ && _loc2_.skillPointsAvailable > 0)
                  {
                     mHeroSlots[_loc3_].alert = param1;
                  }
                  else
                  {
                     mHeroSlots[_loc3_].alert = false;
                  }
               }
            }
            else
            {
               mHeroSlots[_loc3_].alert = param1;
            }
            _loc3_++;
         }
      }
      
      public function disableAvatarAlertOnSelectedHero() : void
      {
         if(selectedHeroIndex > -1)
         {
            mHeroSlots[selectedHeroIndex].alert = false;
         }
      }
      
      public function refresh(param1:Boolean = false) : void
      {
         if(selectedHeroIndex == -1 || param1)
         {
            setActiveAvatarAsCurrentSelection();
         }
         hideWeaponComparison();
         setCurrentIndexToShowSelectedHero();
         populateHeroSlots();
         setEquipWeaponSlots();
      }
      
      private function populateHeroSlots() : void
      {
         var _loc2_:* = 0;
         var _loc3_:Vector.<GMHero> = mDBFacade.gameMaster.Heroes;
         var _loc1_:uint = mCurrentStartIndex;
         _loc2_ = 0;
         while(_loc2_ < mHeroSlots.length)
         {
            mHeroSlots[_loc2_].clear();
            if(_loc1_ < _loc3_.length && (!_loc3_[_loc1_].Hidden || mDBFacade.dbConfigManager.getConfigBoolean("want_hidden_heroes",false)))
            {
               mHeroSlots[_loc2_].gmHero = _loc3_[_loc1_];
            }
            else
            {
               mHeroSlots[_loc2_].enabled = false;
            }
            _loc1_++;
            _loc2_++;
         }
         updateShiftButtons();
         determineSelectedElement();
      }
      
      private function setCurrentIndexToShowSelectedHero() : void
      {
         if(selectedHeroIndex < mHeroSlots.length)
         {
            mCurrentStartIndex = 0;
            return;
         }
         mCurrentStartIndex = selectedHeroIndex - (mHeroSlots.length - 1);
      }
      
      private function shiftLeft() : void
      {
         mCurrentStartIndex--;
         populateHeroSlots();
      }
      
      private function shiftRight() : void
      {
         mCurrentStartIndex++;
         populateHeroSlots();
      }
      
      private function determineSelectedElement() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < mHeroSlots.length)
         {
            if(_loc1_ + mCurrentStartIndex == selectedHeroIndex)
            {
               mHeroSlots[_loc1_].select();
            }
            else
            {
               mHeroSlots[_loc1_].deselect();
            }
            _loc1_++;
         }
      }
      
      private function findHeroIndex(param1:uint) : uint
      {
         var _loc2_:* = 0;
         var _loc3_:Vector.<GMHero> = mDBFacade.gameMaster.Heroes;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(param1 == _loc3_[_loc2_].Id)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         Logger.error("Unable to find gmHero for active avatar Id: " + param1);
         return 0;
      }
      
      private function updateShiftButtons() : void
      {
         if(mCurrentStartIndex == 0)
         {
            mShiftLeft.enabled = false;
         }
         else
         {
            mShiftLeft.enabled = true;
         }
         var _loc1_:uint = mCurrentStartIndex + mHeroSlots.length;
         if(_loc1_ < mTotalGMHeroes)
         {
            mShiftRight.enabled = true;
         }
         else
         {
            mShiftRight.enabled = false;
         }
      }
      
      private function heroClicked(param1:HeroElement, param2:Boolean) : void
      {
         if(!mAllowSelectingUnownedHeroes && !param2)
         {
            return;
         }
         var _loc3_:uint = mHeroSlots.indexOf(param1) + mCurrentStartIndex;
         if(selectedHeroIndex == _loc3_)
         {
            return;
         }
         selectedHeroIndex = _loc3_;
         determineSelectedElement();
         setEquipWeaponSlots();
         if(mHeroSelectedCallback != null)
         {
            mHeroSelectedCallback(param1.gmHero,param2);
         }
      }
      
      public function setEquipWeaponSlots() : void
      {
         var _loc4_:* = 0;
         var _loc1_:int = 0;
         if(selectedHeroIndex >= mDBFacade.gameMaster.Heroes.length)
         {
            return;
         }
         var _loc2_:AvatarInfo = mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(mDBFacade.gameMaster.Heroes[selectedHeroIndex].Id);
         if(_loc2_ == null)
         {
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < mEquipElements.length)
         {
            mEquipElements[_loc4_].clear();
            _loc4_++;
         }
         var _loc3_:Vector.<ItemInfo> = mDBFacade.dbAccountInfo.inventoryInfo.getEquipedItemsOnAvatar(_loc2_.id);
         if(_loc3_.length > 3)
         {
            Logger.warn("Avatar has more than three equipped items.  Equipping first three.");
         }
         _loc4_ = 0;
         while(_loc4_ < mEquipElements.length)
         {
            if(_loc4_ >= _loc3_.length)
            {
               break;
            }
            _loc1_ = int(_loc3_[_loc4_].avatarSlot);
            if(_loc1_ >= mEquipElements.length)
            {
               Logger.warn("Item instance id: " + _loc3_[_loc4_].databaseId + " is equipped to an invalid slot: " + _loc3_[_loc4_].avatarSlot);
            }
            else if(_loc3_.length > _loc4_)
            {
               if(mEquipElements[_loc1_].itemInfo != null)
               {
                  Logger.warn("Equipped items contains multiple items assigned to the same slot. First itemId: " + mEquipElements[_loc1_].itemInfo.gmId + ". Second itemId: " + _loc3_[_loc4_].gmId + ".  Slot: " + _loc3_[_loc4_].avatarSlot);
               }
               else
               {
                  mEquipElements[_loc1_].itemInfo = _loc3_[_loc4_];
               }
            }
            _loc4_++;
         }
      }
      
      public function equipItemOnCurrentAvatar(param1:InventoryBaseInfo, param2:uint, param3:Function = null, param4:Function = null) : void
      {
         var equipServiceResponse:Function;
         var equippingModal:UIPopup;
         var avatarId:uint;
         var info:InventoryBaseInfo = param1;
         var itemSlot:uint = param2;
         var responseFinishedCallback:Function = param3;
         var errorCallback:Function = param4;
         var avatarInfo:AvatarInfo = mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(mHeroSlots[selectedHeroIndex].gmHero.Id);
         if(avatarInfo)
         {
            equipServiceResponse = function():void
            {
               equippingModal.destroy();
               if(responseFinishedCallback != null)
               {
                  responseFinishedCallback();
               }
            };
            equippingModal = UIPopup.show(mDBFacade,Locale.getString("EQUIPPING_MODAL"));
            avatarId = avatarInfo.id;
            mDBFacade.dbAccountInfo.inventoryInfo.equipItemOnAvatar(avatarId,info.databaseId,itemSlot,equipServiceResponse,errorCallback);
         }
      }
      
      public function unequipItem(param1:InventoryBaseInfo, param2:Function = null, param3:Function = null) : void
      {
         var info:InventoryBaseInfo = param1;
         var responseFinishedCallback:Function = param2;
         var errorCallback:Function = param3;
         var equippingModal:UIPopup = UIPopup.show(mDBFacade,Locale.getString("EQUIPPING_MODAL"));
         var equipServiceResponse:Function = function():void
         {
            equippingModal.destroy();
            if(responseFinishedCallback != null)
            {
               responseFinishedCallback();
            }
         };
         mDBFacade.dbAccountInfo.inventoryInfo.unequipItemOffAvatar(info,equipServiceResponse,errorCallback);
      }
      
      public function highlightItem(param1:InventoryBaseInfo) : void
      {
         var _loc2_:AvatarEquipElement = null;
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < mEquipElements.length)
         {
            _loc2_ = mEquipElements[_loc3_];
            if(param1 && _loc2_.itemInfo == param1)
            {
               mEquipElements[_loc3_].select();
            }
            else
            {
               mEquipElements[_loc3_].deselect();
            }
            _loc3_++;
         }
      }
      
      public function deselectEquipment() : void
      {
         var _loc1_:* = 0;
         _loc1_ = 0;
         while(_loc1_ < mEquipElements.length)
         {
            mEquipElements[_loc1_].deselect();
            _loc1_++;
         }
      }
      
      public function handleItemDrop(param1:UIObject, param2:InventoryBaseInfo, param3:uint) : Boolean
      {
         var equipElement:AvatarEquipElement;
         var dropObject:UIObject = param1;
         var itemInfo:InventoryBaseInfo = param2;
         var equipSlot:uint = param3;
         var uiInvItem:UIInventoryItem = dropObject as UIInventoryItem;
         if(uiInvItem && uiInvItem.info != null && uiInvItem.info is ItemInfo)
         {
            this.equipItemOnCurrentAvatar(ItemInfo(uiInvItem.info),equipSlot,mEquipResponseCallback);
            uiInvItem.dragSwapItem(itemInfo);
            return true;
         }
         equipElement = dropObject as AvatarEquipElement;
         if(equipElement && equipElement.itemInfo != null)
         {
            equipElement.reset();
            if(equipElement.equipSlot == equipSlot)
            {
               return true;
            }
            this.equipItemOnCurrentAvatar(equipElement.itemInfo,equipSlot,function():void
            {
               if(itemInfo)
               {
                  equipItemOnCurrentAvatar(itemInfo,equipElement.equipSlot,mEquipResponseCallback);
               }
               else
               {
                  mEquipResponseCallback();
               }
            },mEquipResponseCallback);
            return true;
         }
         return false;
      }
   }
}

