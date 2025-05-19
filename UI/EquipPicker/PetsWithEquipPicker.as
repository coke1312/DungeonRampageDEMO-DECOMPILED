package UI.EquipPicker
{
   import Account.AvatarInfo;
   import Account.InventoryBaseInfo;
   import Account.PetInfo;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.UI.UIButton;
   import Brain.UI.UIObject;
   import Brain.UI.UIPopup;
   import Events.DBAccountResponseEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMHero;
   import UI.Inventory.UIInventoryItem;
   import flash.display.MovieClip;
   
   public class PetsWithEquipPicker extends UIObject
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mEventComponent:EventComponent;
      
      private var mHeroSlots:Vector.<HeroElement>;
      
      private var mEquipElements:Vector.<AvatarEquipElement>;
      
      private var mEquipSlots:Vector.<EquipSlot>;
      
      private var mClickedEquippedPetCallback:Function;
      
      private var mSetSelectedHeroCallback:Function;
      
      private var mGetSelectedHeroCallback:Function;
      
      private var mCurrentStartIndex:uint = 0;
      
      private var mEquipResponseCallback:Function;
      
      private var mTotalGMHeroes:uint;
      
      private var mSelectedHeroIndex:int = -1;
      
      private var mShiftLeft:UIButton;
      
      private var mShiftRight:UIButton;
      
      public function PetsWithEquipPicker(param1:DBFacade, param2:MovieClip, param3:Class, param4:Class, param5:Function = null, param6:Function = null, param7:Function = null, param8:Function = null, param9:Boolean = false)
      {
         var dbFacade:DBFacade = param1;
         var root:MovieClip = param2;
         var weaponTooltipClass:Class = param3;
         var heroTooltipClass:Class = param4;
         var clickedEquippedPetCallback:Function = param5;
         var getSelectedHeroIndexCallback:Function = param6;
         var setSelectedHeroIndexCallback:Function = param7;
         var equipResponseFinishedCallback:Function = param8;
         var allowEquipmentSwapping:Boolean = param9;
         super(dbFacade,root);
         mDBFacade = dbFacade;
         mEventComponent = new EventComponent(mDBFacade);
         mClickedEquippedPetCallback = clickedEquippedPetCallback;
         mEquipResponseCallback = equipResponseFinishedCallback;
         mSetSelectedHeroCallback = setSelectedHeroIndexCallback;
         mGetSelectedHeroCallback = getSelectedHeroIndexCallback;
         mEquipElements = new Vector.<AvatarEquipElement>();
         mEquipElements.push(new AvatarEquipElement(mDBFacade,"",mRoot.UI_pet.equip_slot_1,weaponTooltipClass,unequipPet,handleItemDrop,0,equippedPetClicked,equipResponseFinishedCallback,allowEquipmentSwapping));
         mRoot.UI_pet.equip_slot_0.visible = false;
         mRoot.UI_pet.equip_slot_2.visible = false;
         mRoot.empty_z.visible = false;
         mRoot.empty_c.visible = false;
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
      
      private function heroClicked(param1:HeroElement, param2:Boolean) : void
      {
         var _loc3_:uint = mHeroSlots.indexOf(param1) + mCurrentStartIndex;
         if(selectedHeroIndex == _loc3_)
         {
            return;
         }
         selectedHeroIndex = _loc3_;
         determineSelectedElement();
         refresh();
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
      
      private function equippedPetClicked(param1:AvatarEquipElement) : void
      {
         deselectEquipment();
         if(mClickedEquippedPetCallback != null && param1.itemInfo != null)
         {
            param1.select();
            mClickedEquippedPetCallback(param1.itemInfo);
         }
      }
      
      override public function destroy() : void
      {
         mEventComponent.destroy();
         mDBFacade = null;
         super.destroy();
      }
      
      public function show() : void
      {
         mRoot.visible = true;
      }
      
      public function hide() : void
      {
         mRoot.visible = false;
      }
      
      public function refresh(param1:Boolean = false) : void
      {
         if(selectedHeroIndex == -1 || param1)
         {
            setActiveAvatarAsCurrentSelection();
         }
         setEquipSlots();
         populateHeroSlots();
      }
      
      private function setActiveAvatarAsCurrentSelection() : void
      {
         var _loc2_:Array = null;
         var _loc1_:AvatarInfo = mDBFacade.dbAccountInfo.activeAvatarInfo;
         if(_loc1_ == null)
         {
            Logger.warn("No active avatar set on account id: " + mDBFacade.accountId);
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
      
      private function setCurrentIndexToShowSelectedHero() : void
      {
         if(selectedHeroIndex < mHeroSlots.length)
         {
            mCurrentStartIndex = 0;
            return;
         }
         mCurrentStartIndex = selectedHeroIndex - (mHeroSlots.length - 1);
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
      
      private function setEquipSlots() : void
      {
         var _loc3_:* = 0;
         _loc3_ = 0;
         while(_loc3_ < mEquipElements.length)
         {
            mEquipElements[_loc3_].clear();
            _loc3_++;
         }
         var _loc1_:AvatarInfo = mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(mDBFacade.gameMaster.Heroes[selectedHeroIndex].Id);
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:Vector.<PetInfo> = mDBFacade.dbAccountInfo.inventoryInfo.getEquipedPetsOnAvatar(_loc1_.id);
         if(_loc2_.length > 3)
         {
            Logger.warn("Avatar has more than three equipped pets.  Equipping first three.");
         }
         _loc3_ = 0;
         while(_loc3_ < mEquipElements.length)
         {
            if(_loc3_ >= _loc2_.length)
            {
               break;
            }
            if(_loc2_.length > _loc3_)
            {
               if(mEquipElements[_loc3_].itemInfo != null)
               {
                  Logger.warn("Equipped items contains multiple items assigned to the same slot. First itemId: " + mEquipElements[_loc3_].itemInfo.gmId + ". Second itemId: " + _loc2_[_loc3_].gmId);
               }
               else
               {
                  mEquipElements[_loc3_].itemInfo = _loc2_[_loc3_];
               }
            }
            _loc3_++;
         }
      }
      
      public function equipPetOnCurrentAvatar(param1:InventoryBaseInfo, param2:Function = null, param3:Function = null) : void
      {
         var doEquip:Function;
         var equippedItems:Vector.<PetInfo>;
         var info:InventoryBaseInfo = param1;
         var responseFinishedCallback:Function = param2;
         var errorCallback:Function = param3;
         var avatarInfo:AvatarInfo = mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(mHeroSlots[selectedHeroIndex].gmHero.Id);
         if(avatarInfo)
         {
            doEquip = function():void
            {
               var equipServiceResponse:Function = function():void
               {
                  equippingModal.destroy();
                  if(responseFinishedCallback != null)
                  {
                     responseFinishedCallback();
                  }
               };
               var equippingModal:UIPopup = UIPopup.show(mDBFacade,Locale.getString("EQUIPPING_MODAL"));
               var avatarId:uint = avatarInfo.id;
               mDBFacade.dbAccountInfo.inventoryInfo.equipPetOnAvatar(avatarId,info.databaseId,equipServiceResponse,errorCallback);
            };
            equippedItems = mDBFacade.dbAccountInfo.inventoryInfo.getEquipedPetsOnAvatar(avatarInfo.id);
            if(equippedItems.length > 0)
            {
               unequipPet(equippedItems[0],doEquip,errorCallback);
            }
            else
            {
               doEquip();
            }
         }
      }
      
      public function unequipPet(param1:PetInfo, param2:Function = null, param3:Function = null) : void
      {
         var info:PetInfo = param1;
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
         mDBFacade.dbAccountInfo.inventoryInfo.unequipPet(info,equipServiceResponse,errorCallback);
      }
      
      public function highlightItem(param1:InventoryBaseInfo) : void
      {
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
      
      public function handleItemDrop(param1:UIObject, param2:InventoryBaseInfo, param3:uint) : Boolean
      {
         var uiInvItem:UIInventoryItem;
         var equipElement:AvatarEquipElement;
         var dropObject:UIObject = param1;
         var petInfo:InventoryBaseInfo = param2;
         var equipSlot:uint = param3;
         if(dropObject == null)
         {
            this.equipPetOnCurrentAvatar(petInfo,mEquipResponseCallback);
            return true;
         }
         uiInvItem = dropObject as UIInventoryItem;
         if(uiInvItem && uiInvItem.info != null && uiInvItem.info is PetInfo)
         {
            this.equipPetOnCurrentAvatar(PetInfo(uiInvItem.info),mEquipResponseCallback);
            uiInvItem.dragSwapItem(petInfo);
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
            this.equipPetOnCurrentAvatar(equipElement.itemInfo,function():void
            {
               if(petInfo)
               {
                  equipPetOnCurrentAvatar(petInfo,mEquipResponseCallback);
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

