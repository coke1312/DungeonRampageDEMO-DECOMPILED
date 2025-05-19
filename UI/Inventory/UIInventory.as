package UI.Inventory
{
   import Account.AvatarInfo;
   import Account.ChestInfo;
   import Account.DBInventoryInfo;
   import Account.InventoryBaseInfo;
   import Account.ItemInfo;
   import Account.PetInfo;
   import Account.StackableInfo;
   import Account.StoreServicesController;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.UI.UIButton;
   import Brain.UI.UIRadioButton;
   import Brain.WorkLoop.LogicalWorkComponent;
   import DBGlobals.DBGlobal;
   import DistributedObjects.DistributedDungeonSummary;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMChest;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMNpc;
   import GameMasterDictionary.GMOffer;
   import GameMasterDictionary.GMOfferDetail;
   import GameMasterDictionary.GMStackable;
   import GameMasterDictionary.GMWeaponItem;
   import Town.TownHeader;
   import UI.DBUIOneButtonPopup;
   import UI.DBUITwoButtonPopup;
   import UI.EquipPicker.HeroWithEquipPicker;
   import UI.EquipPicker.PetsWithEquipPicker;
   import UI.EquipPicker.StacksWithEquipPicker;
   import UI.EquipPicker.StuffWithEquipPicker;
   import UI.Inventory.Chests.ChestInfoCard;
   import UI.UIHud;
   import UI.UIPagingPanel;
   import UI.UITownTweens;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class UIInventory
   {
      
      private static const BUY_KEY_POPUP_SWF_PATH:String = "Resources/Art2D/UI/db_UI_score_report.swf";
      
      private static const SELECTED_TAB_SCALE:Number = 1.15;
      
      private static const NUM_GRID_ELEMENTS:uint = 15;
      
      private static const INV_SLOT_CLASS_NAME:String = "inv_slot";
      
      private static const WEAPON_TOOLTIP_Z_CLASS_NAME:String = "DR_weapon_tooltip_z";
      
      private static const WEAPON_TOOLTIP_CLASS_NAME:String = "DR_weapon_tooltip";
      
      public static const CHARGE_TOOLTIP_CLASS_NAME:String = "DR_charge_tooltip";
      
      public static const EQUIPPABLE_TRUE:uint = 1;
      
      public static const EQUIPPABLE_NOT_YET:uint = 2;
      
      public static const EQUIPPABLE_NEVER:uint = 3;
      
      private static const CATEGORY_ARRAY:Array = new Array("WEAPON","POWERUP","PET","STUFF");
      
      private var mDBFacade:DBFacade;
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mRoot:Sprite;
      
      private var mInventoryRoot:MovieClip;
      
      private var mSwfAsset:SwfAsset;
      
      private var mTownHeader:TownHeader;
      
      private var mDungeonRewardPanel:DungeonRewardPanel;
      
      private var mTabButtons:Map;
      
      private var mPagination:UIPagingPanel;
      
      private var mCurrentPage:uint = 0;
      
      private var mCurrentTab:String;
      
      private var mWantPets:Boolean = false;
      
      private var mItems:Vector.<UIInventoryItem>;
      
      private var mInventoryGridElements:Vector.<MovieClip>;
      
      private var mCategorizedItems:Map;
      
      private var mAddStorageButton:UIButton;
      
      private var mInfoCard:ItemInfoCard;
      
      private var mDungeonSummary:DistributedDungeonSummary;
      
      private var mNewItemIds:Array;
      
      private var mNewChestIds:Array;
      
      private var mNewStackableIds:Array;
      
      private var mNewPetIds:Array;
      
      private var mHeroWithEquipPicker:HeroWithEquipPicker;
      
      private var mStacksWithEquipPicker:StacksWithEquipPicker;
      
      private var mPetsWithEquipPicker:PetsWithEquipPicker;
      
      private var mStuffWithEquipPicker:StuffWithEquipPicker;
      
      private var mSelectedItemInfo:InventoryBaseInfo;
      
      private var mSelectedAvatar:uint;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mChestCard:ChestInfoCard;
      
      private var mAbandonChestPopUp:DBUITwoButtonPopup;
      
      private var mChestOpenFullPopUp:DBUIOneButtonPopup;
      
      private var mEventComponent:EventComponent;
      
      private var mRevealedItemType:uint;
      
      private var mRevealedItemOfferId:uint;
      
      private var mRevealedShowEquip:Boolean;
      
      private var mConsumableChestCard:ChestInfoCard;
      
      private var mBoosterCard:BoosterInfoCard;
      
      public function UIInventory(param1:DBFacade, param2:TownHeader = null, param3:DistributedDungeonSummary = null)
      {
         super();
         mDBFacade = param1;
         mTownHeader = param2;
         mDungeonSummary = param3;
         mRevealedItemType = 0;
         mRevealedItemOfferId = 0;
         mRoot = new Sprite();
         if(mDBFacade.dbConfigManager.getConfigBoolean("want_pets",true))
         {
            mWantPets = true;
         }
         mTabButtons = new Map();
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mInventoryGridElements = new Vector.<MovieClip>();
         mItems = new Vector.<UIInventoryItem>();
         mNewItemIds = [];
         mNewChestIds = [];
         mNewStackableIds = [];
         mNewPetIds = [];
         mEventComponent = new EventComponent(mDBFacade);
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),swfLoaded);
      }
      
      public function setRevealedState(param1:uint, param2:uint, param3:Boolean = false) : void
      {
         mRevealedItemType = param1;
         mRevealedItemOfferId = param2;
         mRevealedShowEquip = param3;
      }
      
      private function setSelectedAvatar(param1:int) : void
      {
         mSelectedAvatar = param1;
      }
      
      private function getSelectedAvatar() : int
      {
         return mSelectedAvatar;
      }
      
      public function get root() : Sprite
      {
         return mRoot;
      }
      
      private function swfLoaded(param1:SwfAsset) : void
      {
         mSwfAsset = param1;
         var _loc2_:Class = mSwfAsset.getClass("DR_UI_town_inventory");
         mInventoryRoot = new _loc2_() as MovieClip;
         mRoot.addChild(mInventoryRoot);
         var _loc6_:Class = param1.getClass("DR_weapon_tooltip_z");
         var _loc3_:Class = param1.getClass("DR_weapon_tooltip");
         var _loc4_:Class = param1.getClass("avatar_tooltip");
         mInventoryRoot.pet_picker.visible = false;
         mInventoryRoot.potion_picker.visible = false;
         mInventoryRoot.stuff_picker.visible = false;
         mHeroWithEquipPicker = new HeroWithEquipPicker(mDBFacade,mInventoryRoot.weapon_picker,_loc3_,_loc6_,_loc4_,heroSelected,itemSelected,getSelectedAvatar,setSelectedAvatar,refresh,true);
         mStacksWithEquipPicker = new StacksWithEquipPicker(mDBFacade,mInventoryRoot.potion_picker,_loc3_,_loc4_,itemSelected,refresh,true,getSelectedAvatar,setSelectedAvatar);
         if(mWantPets)
         {
            mPetsWithEquipPicker = new PetsWithEquipPicker(mDBFacade,mInventoryRoot.pet_picker,_loc3_,_loc4_,itemSelected,getSelectedAvatar,setSelectedAvatar,refresh,true);
         }
         mStuffWithEquipPicker = new StuffWithEquipPicker(mDBFacade,mInventoryRoot.stuff_picker,_loc4_,getSelectedAvatar,setSelectedAvatar);
         mInventoryRoot.close.visible = false;
         var _loc5_:MovieClip = mInventoryRoot.treasure;
         if(mDungeonSummary)
         {
            mDungeonRewardPanel = new DungeonRewardPanel(mDBFacade,_loc5_,mDungeonSummary,itemSelected);
            _loc5_.label.text = Locale.getString("LOOT");
         }
         else
         {
            _loc5_.visible = false;
         }
         buildCategories();
         setupUI(mInventoryRoot);
         mEventComponent.addListener("DB_ACCOUNT_INFO_RESPONSE",accountInfoUpdated);
      }
      
      private function accountInfoUpdated(param1:Event) : void
      {
         refresh(false);
      }
      
      public function hide() : void
      {
         mRoot.visible = false;
      }
      
      public function show(param1:GMChest) : void
      {
         mRoot.visible = true;
         mBoosterCard.hide();
         refresh(true);
         if(mDungeonSummary)
         {
            mDungeonRewardPanel.setChestAsSelected(param1);
         }
      }
      
      private function heroSelected(param1:GMHero, param2:Boolean) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc3_:GMHero = mDBFacade.gameMaster.Heroes[mSelectedAvatar];
         if(_loc3_.Id != param1.Id)
         {
            mDBFacade.dbAccountInfo.changeActiveAvatarRPC(param1.Id);
         }
         var _loc4_:AvatarInfo = mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(param1.Id);
         if(_loc4_ && mSelectedItemInfo is ChestInfo)
         {
            mChestCard.selectedHeroId = mSelectedAvatar;
            mChestCard.refreshHeroInfoUI();
            refresh(false,true);
         }
         else
         {
            refresh(false);
         }
      }
      
      private function determineEquippableItems(param1:GMHero) : void
      {
         var _loc7_:InventoryBaseInfo = null;
         var _loc6_:ItemInfo = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:DBInventoryInfo = mDBFacade.dbAccountInfo.inventoryInfo;
         var _loc2_:AvatarInfo = _loc5_.getAvatarInfoForHeroType(param1.Id);
         _loc4_ = 0;
         while(_loc4_ < mItems.length)
         {
            _loc7_ = mItems[_loc4_].info;
            _loc6_ = _loc7_ as ItemInfo;
            if(_loc7_ && _loc6_ && _loc6_.gmWeaponItem)
            {
               _loc3_ = 1;
               if(_loc2_ == null)
               {
                  _loc3_ = 3;
               }
               else if(!_loc5_.canAvatarEquipThisMasterType(_loc2_,_loc6_.gmWeaponItem.MasterType))
               {
                  _loc3_ = 3;
               }
               else if(_loc2_.level < _loc6_.requiredLevel)
               {
                  _loc3_ = 2;
               }
               mItems[_loc4_].equippable = _loc3_;
            }
            _loc4_++;
         }
      }
      
      private function sellItem(param1:InventoryBaseInfo) : void
      {
         var info:InventoryBaseInfo = param1;
         if(info != null)
         {
            if(info is ItemInfo || info is StackableInfo || info is PetInfo)
            {
               StoreServicesController.trySellItem(mDBFacade,info,function():void
               {
                  var _loc1_:int = 0;
                  if(info is ItemInfo)
                  {
                     _loc1_ = int(mNewItemIds.indexOf(info.databaseId));
                     if(_loc1_ != -1)
                     {
                        mNewItemIds.splice(_loc1_,1);
                     }
                  }
                  else if(info is StackableInfo)
                  {
                     _loc1_ = int(mNewStackableIds.indexOf(info.databaseId));
                     if(_loc1_ != -1)
                     {
                        mNewStackableIds.splice(_loc1_,1);
                     }
                  }
                  else if(info is PetInfo)
                  {
                     _loc1_ = int(mNewPetIds.indexOf(info.databaseId));
                     if(_loc1_ != -1)
                     {
                        mNewPetIds.splice(_loc1_,1);
                     }
                  }
                  refresh();
               });
            }
            mSelectedItemInfo = null;
         }
         else
         {
            Logger.error("Trying to sell null item info.");
         }
      }
      
      private function takeItemCallback() : void
      {
         mSelectedItemInfo = null;
      }
      
      private function setupUI(param1:MovieClip) : void
      {
         var chargeTooltipClass:Class;
         var group:String;
         var tabButton:UIRadioButton;
         var iter:IMapIterator;
         var itemTemplateClass:Class;
         var weaponTooltipClass:Class;
         var uiInventoryItem:UIInventoryItem;
         var i:uint;
         var root:MovieClip = param1;
         mInventoryRoot = root;
         if(mPagination)
         {
            mPagination.destroy();
            mPagination = null;
         }
         mPagination = new UIPagingPanel(mDBFacade,this.numPagesInCurrentCategory(),mInventoryRoot.grid_widget.pagination,mSwfAsset.getClass("pagination_button"),this.setCurrentPage);
         chargeTooltipClass = mSwfAsset.getClass("DR_charge_tooltip");
         mInfoCard = new ItemInfoCard(mDBFacade,root.item_card,chargeTooltipClass,mHeroWithEquipPicker,mPetsWithEquipPicker,refresh,mDungeonSummary,false,sellItem,takeItemCallback);
         mInfoCard.visible = false;
         if(mChestCard)
         {
            mChestCard.destroy();
            mChestCard = null;
         }
         mChestCard = new ChestInfoCard(mDBFacade,mSceneGraphComponent,root.inv_chests,abandonChest,openChest,abandonChestDS,openChestDS,keepChestDS);
         if(mConsumableChestCard)
         {
            mConsumableChestCard.destroy();
            mConsumableChestCard = null;
         }
         mConsumableChestCard = new ChestInfoCard(mDBFacade,mSceneGraphComponent,root.inv_consumable,abandonChest,openChest,abandonChestDS,openChestDS,keepChestDS);
         if(mBoosterCard)
         {
            mBoosterCard.destroy();
            mBoosterCard = null;
         }
         mBoosterCard = new BoosterInfoCard(mDBFacade,mSceneGraphComponent,root.booster_card);
         group = "UIInventoryTabGroup";
         mTabButtons.add("WEAPON",new UIRadioButton(mDBFacade,mInventoryRoot.grid_widget.tab_weapons,group));
         mInventoryRoot.grid_widget.tab_weapons.label.text = Locale.getString("TAB_LOOT");
         mTabButtons.add("POWERUP",new UIRadioButton(mDBFacade,mInventoryRoot.grid_widget.tab_potions,group));
         mInventoryRoot.grid_widget.tab_potions.label.text = Locale.getString("TAB_POWERUPS");
         if(mWantPets)
         {
            mTabButtons.add("PET",new UIRadioButton(mDBFacade,mInventoryRoot.grid_widget.tab_pets,group));
            mInventoryRoot.grid_widget.tab_pets.label.text = Locale.getString("TAB_PETS");
         }
         mTabButtons.add("STUFF",new UIRadioButton(mDBFacade,mInventoryRoot.grid_widget.tab_stuff,group));
         mInventoryRoot.grid_widget.tab_stuff.label.text = Locale.getString("TAB_STUFF");
         iter = mTabButtons.iterator() as IMapIterator;
         while(iter.hasNext())
         {
            tabButton = iter.next();
            tabButton.root.new_label.text = Locale.getString("INV_NEW");
            tabButton.root.new_label.visible = this.categoryHasAnyNewItems(iter.key);
            tabButton.root.category = iter.key;
            tabButton.releaseCallbackThis = function(param1:UIButton):void
            {
               showTab(param1.root.category);
            };
            tabButton.rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
            tabButton.selectedFilter = DBGlobal.UI_SELECTED_FILTER;
         }
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_0);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_1);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_2);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_3);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_4);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_5);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_6);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_7);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_8);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_9);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_10);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_11);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_12);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_13);
         mInventoryGridElements.push(mInventoryRoot.grid_widget.slot_14);
         itemTemplateClass = mSwfAsset.getClass("inv_slot");
         weaponTooltipClass = mSwfAsset.getClass("DR_weapon_tooltip");
         i = 0;
         while(i < mItems.length)
         {
            mItems[i].destroy();
            ++i;
         }
         mItems.splice(0,mItems.length);
         i = 0;
         while(i < 15)
         {
            uiInventoryItem = new UIInventoryItem(mDBFacade,mInventoryGridElements[i],itemTemplateClass,weaponTooltipClass,itemSelected);
            mItems.push(uiInventoryItem);
            uiInventoryItem.visible = false;
            ++i;
         }
         mAddStorageButton = new UIButton(mDBFacade,mInventoryRoot.grid_widget.add_storage_button);
         mAddStorageButton.rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
         mAddStorageButton.label.text = Locale.getString("INV_ADD_STORAGE");
         mAddStorageButton.releaseCallback = function():void
         {
            StoreServicesController.showStoragePage(mDBFacade);
         };
         mAddStorageButton.visible = false;
      }
      
      private function closeEquipButton() : void
      {
      }
      
      private function abandonChest(param1:ChestInfo) : void
      {
         var chestInfo:ChestInfo = param1;
         mAbandonChestPopUp = new DBUITwoButtonPopup(mDBFacade,Locale.getString("ABANDON_CHEST_POPUP_TITLE"),Locale.getString("ABANDON_CHEST_POPUP_DESC"),Locale.getString("ABANDON_CHEST_POPUP_CANCEL"),closeAbandonChestPopUp,Locale.getString("ABANDON_CHEST_POPUP_CONFIRM"),function():void
         {
            mDBFacade.metrics.log("ChestAbandoned",{
               "chestId":chestInfo.gmChestInfo.Id,
               "rarity":chestInfo.rarity,
               "category":"storage"
            });
            mDBFacade.dbAccountInfo.inventoryInfo.dropChest(chestInfo.databaseId,dropChestSuccessfullCallback,abandonChestFailedPopUp);
            closeAbandonChestPopUp();
         },false,null);
         var index:int = int(mNewChestIds.indexOf(chestInfo.databaseId));
         if(index != -1)
         {
            mNewChestIds.splice(index,1);
         }
      }
      
      private function closeAbandonChestPopUp() : void
      {
         mAbandonChestPopUp = null;
      }
      
      private function dropChestSuccessfullCallback(param1:uint, param2:*) : void
      {
         removeChestFromInventory(param1);
         refresh(true);
      }
      
      private function returnFromOpenFullPopUp() : void
      {
         if(mChestOpenFullPopUp)
         {
            mSceneGraphComponent.removeChild(mChestOpenFullPopUp.root);
            mChestOpenFullPopUp = null;
         }
      }
      
      private function openChest(param1:ChestInfo) : void
      {
         var _loc4_:* = 0;
         var _loc6_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:ChestInfoCard = mChestCard;
         if(UIHud.isThisAConsumbleChestId(param1.gmChestInfo.Id))
         {
            _loc3_ = mConsumableChestCard;
         }
         if(_loc3_.canChestBeOpened())
         {
            if(param1.isFromDungeonSummary())
            {
               mDungeonSummary.openChestFromInventory(param1.gmChestInfo,true);
            }
            else
            {
               _loc3_.createRevealPopUp(closeRevealPopUp,goToStorage);
               _loc4_ = mHeroWithEquipPicker.currentlySelectedHero.Id;
               _loc6_ = mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(_loc4_).id;
               _loc2_ = mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(_loc4_).skinId;
               mDBFacade.dbAccountInfo.inventoryInfo.openChest(param1.databaseId,_loc6_,_loc2_,updateRevealLoot,openChestFailedPopUp);
            }
         }
         else
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_score_report.swf"),_loc3_.showBuyKeysPopUp);
         }
         var _loc5_:int = int(mNewChestIds.indexOf(param1.databaseId));
         if(_loc5_ != -1)
         {
            mNewChestIds.splice(_loc5_,1);
         }
      }
      
      public function goToStorage(param1:uint, param2:uint, param3:Boolean) : void
      {
         mConsumableChestCard.closeChestRevealPopUp();
         mChestCard.closeChestRevealPopUp();
         mRevealedItemType = param1;
         mRevealedItemOfferId = param2;
         mRevealedShowEquip = param3;
         refresh();
      }
      
      private function closeRevealPopUp(param1:uint, param2:uint, param3:Boolean) : void
      {
         mRevealedItemType = param1;
         mRevealedItemOfferId = param2;
         mConsumableChestCard.closeChestRevealPopUp();
         mChestCard.closeChestRevealPopUp();
         refresh();
      }
      
      private function updateRevealLoot(param1:uint, param2:*) : void
      {
         mConsumableChestCard.updateRevealLoot(param2);
         mChestCard.updateRevealLoot(param2);
         removeChestFromInventory(param1);
      }
      
      private function abandonChestDS(param1:ChestInfo) : void
      {
         var chestInfo:ChestInfo = param1;
         mAbandonChestPopUp = new DBUITwoButtonPopup(mDBFacade,Locale.getString("ABANDON_CHEST_POPUP_TITLE"),Locale.getString("ABANDON_CHEST_POPUP_DESC"),Locale.getString("ABANDON_CHEST_POPUP_CANCEL"),closeAbandonChestPopUp,Locale.getString("ABANDON_CHEST_POPUP_CONFIRM"),function():void
         {
            mDBFacade.metrics.log("ChestAbandoned",{
               "chestId":chestInfo.gmChestInfo.Id,
               "rarity":chestInfo.rarity,
               "category":"storageFromDungeonSummary"
            });
            var _loc1_:uint = mDungeonSummary.findSlotForChest(chestInfo.gmChestInfo);
            mDungeonSummary.abandonChestFromInventory(_loc1_);
            closeAbandonChestPopUp();
         },false,null);
      }
      
      private function openChestDS(param1:ChestInfo) : void
      {
         if(mDungeonSummary && !mDBFacade.dbAccountInfo.inventoryInfo.isThereEmptySpaceInWeaponStorage())
         {
            mChestOpenFullPopUp = new DBUIOneButtonPopup(mDBFacade,Locale.getString("STORAGE_FULL"),Locale.getString("CLEAR_INVENTORY"),Locale.getString("RETURN"),returnFromOpenFullPopUp,true,returnFromOpenFullPopUp);
            mSceneGraphComponent.addChild(mChestOpenFullPopUp.root,105);
            return;
         }
         openChest(param1);
      }
      
      private function keepChestDS(param1:ChestInfo) : void
      {
         if(mDungeonSummary && !mDBFacade.dbAccountInfo.inventoryInfo.isThereEmptySpaceInWeaponStorage())
         {
            mChestOpenFullPopUp = new DBUIOneButtonPopup(mDBFacade,Locale.getString("STORAGE_FULL"),Locale.getString("CLEAR_INVENTORY"),Locale.getString("RETURN"),returnFromOpenFullPopUp,true,returnFromOpenFullPopUp);
            mSceneGraphComponent.addChild(mChestOpenFullPopUp.root,105);
            return;
         }
         var _loc2_:uint = mDungeonSummary.findSlotForChest(param1.gmChestInfo);
         mDungeonSummary.keepChestFromInventory(_loc2_,true);
      }
      
      private function abandonChestFailedPopUp() : void
      {
         mConsumableChestCard.closeChestRevealPopUp();
         mChestCard.closeChestRevealPopUp();
      }
      
      private function openChestFailedPopUp() : void
      {
         mConsumableChestCard.closeChestRevealPopUp();
         mChestCard.closeChestRevealPopUp();
         refresh();
      }
      
      private function removeChestFromInventory(param1:uint) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < mDBFacade.dbAccountInfo.inventoryInfo.chests.length)
         {
            if(mDBFacade.dbAccountInfo.inventoryInfo.chests[_loc2_].gmId == param1)
            {
               mDBFacade.dbAccountInfo.inventoryInfo.chests.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
         takeItemCallback();
      }
      
      private function categoryHasAnyNewItems(param1:String) : Boolean
      {
         var _loc2_:Vector.<InventoryBaseInfo> = mCategorizedItems.itemFor(param1);
         if(_loc2_ == null)
         {
            Logger.error("categoryHasAnyNewItems invalid category: " + param1);
         }
         for each(var _loc3_ in _loc2_)
         {
            if(_loc3_.isNew)
            {
               return true;
            }
         }
         return false;
      }
      
      public function animateEntry() : void
      {
         if(mTownHeader != null)
         {
            mTownHeader.rootMovieClip.visible = false;
            mLogicalWorkComponent.doLater(0.20833333333333334,function(param1:GameClock):void
            {
               mTownHeader.animateHeader();
            });
         }
         mInventoryRoot.grid_widget.visible = false;
         mLogicalWorkComponent.doLater(0.16666666666666666,function(param1:GameClock):void
         {
            UITownTweens.rightPanelTweenSequence(mInventoryRoot.grid_widget,mDBFacade);
         });
         if(mCurrentTab != "WEAPON")
         {
            return;
         }
         mHeroWithEquipPicker.root.visible = false;
         mLogicalWorkComponent.doLater(0.5,function(param1:GameClock):void
         {
            UITownTweens.footerTweenSequence(mHeroWithEquipPicker.root,mDBFacade);
         });
      }
      
      private function buildCategories() : void
      {
         var _loc7_:String = null;
         var _loc9_:* = undefined;
         var _loc10_:InventoryBaseInfo = null;
         var _loc5_:IMapIterator = null;
         mCategorizedItems = new Map();
         for each(_loc7_ in CATEGORY_ARRAY)
         {
            mCategorizedItems.add(_loc7_,new Vector.<InventoryBaseInfo>());
         }
         var _loc8_:Map = mDBFacade.dbAccountInfo.inventoryInfo.items;
         var _loc6_:Vector.<ChestInfo> = mDBFacade.dbAccountInfo.inventoryInfo.chests;
         var _loc3_:Map = mDBFacade.dbAccountInfo.inventoryInfo.stackables;
         var _loc1_:Map = mDBFacade.dbAccountInfo.inventoryInfo.pets;
         for each(var _loc4_ in [_loc8_,_loc3_,_loc1_])
         {
            _loc5_ = _loc4_.iterator() as IMapIterator;
            while(_loc5_.hasNext())
            {
               _loc10_ = _loc5_.next();
               if(_loc10_.gmInventoryBase)
               {
                  _loc7_ = _loc10_.gmInventoryBase.ItemCategory;
               }
               else
               {
                  _loc7_ = "PET";
               }
               _loc9_ = mCategorizedItems.itemFor(_loc7_);
               if(_loc9_ == null)
               {
                  Logger.error("No inventory category exists for weapon class type: " + _loc7_);
               }
               else
               {
                  _loc9_.push(_loc10_);
               }
            }
         }
         for each(var _loc2_ in _loc6_)
         {
            if(_loc2_.gmChestInfo)
            {
               _loc7_ = "WEAPON";
               _loc9_ = mCategorizedItems.itemFor(_loc7_);
               if(_loc9_ == null)
               {
                  Logger.error("No inventory category exists for weapon class type: " + _loc7_);
               }
               else
               {
                  _loc9_.push(_loc2_);
               }
            }
         }
         sortCategories();
      }
      
      private function inventorySortComparator(param1:Vector.<String>, param2:InventoryBaseInfo, param3:InventoryBaseInfo) : int
      {
         var _loc4_:GMWeaponItem = null;
         var _loc5_:GMWeaponItem = null;
         var _loc6_:AvatarInfo = null;
         var _loc11_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc10_:int = 0;
         var _loc12_:int = 0;
         if(param2.isEquipped && !param3.isEquipped)
         {
            return 1;
         }
         if(param3.isEquipped && !param2.isEquipped)
         {
            return -1;
         }
         if(param2 is ItemInfo && param3 is ItemInfo)
         {
            _loc4_ = ItemInfo(param2).gmWeaponItem;
            _loc5_ = ItemInfo(param3).gmWeaponItem;
            _loc6_ = this.mHeroWithEquipPicker.currentlySelectedAvatarInfo;
            if(_loc6_)
            {
               _loc11_ = mDBFacade.dbAccountInfo.inventoryInfo.canAvatarEquipThisMasterType(_loc6_,_loc4_.MasterType);
               _loc8_ = mDBFacade.dbAccountInfo.inventoryInfo.canAvatarEquipThisMasterType(_loc6_,_loc5_.MasterType);
               if(_loc11_ && !_loc8_)
               {
                  return -1;
               }
               if(_loc8_ && !_loc11_)
               {
                  return 1;
               }
               _loc9_ = mDBFacade.dbAccountInfo.inventoryInfo.canThisAvatarEquipThisItem(_loc6_,ItemInfo(param2));
               _loc7_ = mDBFacade.dbAccountInfo.inventoryInfo.canThisAvatarEquipThisItem(_loc6_,ItemInfo(param3));
               if(_loc9_ && !_loc7_)
               {
                  return -1;
               }
               if(_loc7_ && !_loc9_)
               {
                  return 1;
               }
            }
            if(param1)
            {
               _loc10_ = int(param1.indexOf(_loc4_.MasterType));
               _loc12_ = int(param1.indexOf(_loc5_.MasterType));
               if(_loc10_ != _loc12_)
               {
                  return _loc10_ - _loc12_;
               }
            }
            return ItemInfo(param3).requiredLevel - ItemInfo(param2).requiredLevel;
         }
         return param3.gmId - param2.gmId;
      }
      
      private function weaponSortComparator(param1:InventoryBaseInfo, param2:InventoryBaseInfo) : int
      {
         return this.inventorySortComparator(GMWeaponItem.ALL_WEAPON_SORT,param1,param2);
      }
      
      private function basicSortComparator(param1:InventoryBaseInfo, param2:InventoryBaseInfo) : int
      {
         return this.inventorySortComparator(null,param1,param2);
      }
      
      private function sortCategories() : void
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc1_:IMapIterator = mCategorizedItems.iterator() as IMapIterator;
         while(_loc1_.hasNext())
         {
            _loc3_ = _loc1_.next();
            _loc2_ = _loc1_.key;
            var _loc4_:* = _loc2_;
            if("WEAPON" !== _loc4_)
            {
               _loc3_.sort(basicSortComparator);
            }
            else
            {
               _loc3_.sort(weaponSortComparator);
            }
         }
      }
      
      public function refresh(param1:Boolean = false, param2:Boolean = false) : void
      {
         var currentTabIsValidCategory:Boolean;
         var tabButton:UIRadioButton;
         var iter:IMapIterator;
         var gmHero:GMHero;
         var itemInfo:ItemInfo;
         var canEquip:Boolean;
         var resync:Boolean = param1;
         var dontRefreshChestSelection:Boolean = param2;
         if(resync)
         {
            mBoosterCard.hide();
         }
         if(mTownHeader != null)
         {
            mTownHeader.title = Locale.getString("INVENTORY_HEADER");
            mTownHeader.refreshKeyPanel();
         }
         mHeroWithEquipPicker.refresh(resync);
         mStacksWithEquipPicker.refresh(resync);
         if(mWantPets)
         {
            mPetsWithEquipPicker.refresh(resync);
         }
         mStuffWithEquipPicker.refresh(resync);
         buildCategories();
         if(mDungeonRewardPanel)
         {
            mDungeonRewardPanel.refresh();
         }
         currentTabIsValidCategory = Boolean(CATEGORY_ARRAY.some(function(param1:*, param2:uint, param3:Array):Boolean
         {
            if(mCurrentTab == param1 as String)
            {
               return true;
            }
            return false;
         }));
         if(!currentTabIsValidCategory)
         {
            mCurrentTab = "WEAPON";
         }
         if(!dontRefreshChestSelection)
         {
            mSelectedItemInfo = checkIfRevealedWeaponExists();
         }
         if(mSelectedItemInfo != null && mSelectedItemInfo is ItemInfo)
         {
            jumpToWeaponOffer(mSelectedItemInfo);
         }
         else
         {
            this.showTab(mCurrentTab,mCurrentPage);
         }
         if(!dontRefreshChestSelection)
         {
            this.populateDetailInfoCard();
            this.populateDetailChestCard();
            this.highLightSelectedItem();
         }
         this.lookForNewEquippedItems();
         iter = mTabButtons.iterator() as IMapIterator;
         while(iter.hasNext())
         {
            tabButton = iter.next();
            tabButton.root.new_label.visible = this.categoryHasAnyNewItems(iter.key);
         }
         if(mSelectedItemInfo != null && !dontRefreshChestSelection)
         {
            itemSelected(mSelectedItemInfo);
            if(mRevealedShowEquip && mSelectedItemInfo is ItemInfo)
            {
               gmHero = mDBFacade.gameMaster.Heroes[mSelectedAvatar];
               itemInfo = mSelectedItemInfo as ItemInfo;
               canEquip = gmHero.AllowedWeapons.hasKey(itemInfo.gmWeaponItem.MasterType);
               if(canEquip)
               {
                  mInfoCard.loadEquipOnAvatarPopup();
               }
               mRevealedShowEquip = false;
            }
         }
      }
      
      public function jumpToWeaponOffer(param1:InventoryBaseInfo) : void
      {
         var _loc4_:String = "WEAPON";
         var _loc5_:Vector.<InventoryBaseInfo> = mCategorizedItems.itemFor("WEAPON");
         var _loc2_:int = int(_loc5_.indexOf(param1));
         if(_loc2_ == -1)
         {
            Logger.warn("Index not found for item in Storage");
         }
         var _loc3_:uint = Math.floor(_loc2_ / 15);
         this.showTab(_loc4_,_loc3_);
      }
      
      private function checkIfRevealedWeaponExists() : InventoryBaseInfo
      {
         var _loc6_:* = null;
         var _loc1_:GMWeaponItem = null;
         var _loc4_:* = 0;
         var _loc5_:GMOffer = null;
         var _loc3_:GMStackable = null;
         if(mRevealedItemType == 0)
         {
            return null;
         }
         if(mRevealedItemType == 1)
         {
            mCurrentTab = "WEAPON";
            mRevealedItemOfferId %= 100000;
            _loc1_ = mDBFacade.gameMaster.weaponItemById.itemFor(mRevealedItemOfferId);
            for each(_loc6_ in mCategorizedItems.itemFor(mCurrentTab))
            {
               if(_loc6_ is ItemInfo)
               {
                  _loc4_ = (_loc6_ as ItemInfo).gmWeaponItem.Id;
                  if(_loc4_ == _loc1_.Id && _loc6_.isNew)
                  {
                     mRevealedItemType = mRevealedItemOfferId = 0;
                     return _loc6_;
                  }
               }
            }
         }
         else if(mRevealedItemType == 2)
         {
            _loc5_ = mDBFacade.gameMaster.offerById.itemFor(mRevealedItemOfferId);
            var _loc10_:int = 0;
            var _loc9_:* = _loc5_.Details;
            for each(var _loc2_ in _loc9_)
            {
               _loc3_ = mDBFacade.gameMaster.stackableById.itemFor(_loc2_.StackableId);
            }
            if(_loc3_ != null)
            {
               mCurrentTab = "POWERUP";
               for each(_loc6_ in mCategorizedItems.itemFor(mCurrentTab))
               {
                  if(_loc6_.gmId == _loc3_.Id)
                  {
                     mRevealedItemType = mRevealedItemOfferId = 0;
                     return _loc6_;
                  }
               }
            }
         }
         mRevealedItemType = mRevealedItemOfferId = 0;
         return null;
      }
      
      private function lookForNewEquippedItems() : void
      {
         var _loc2_:IMapIterator = null;
         var _loc3_:ItemInfo = null;
         var _loc4_:StackableInfo = null;
         var _loc1_:PetInfo = null;
         _loc2_ = mDBFacade.dbAccountInfo.inventoryInfo.items.iterator() as IMapIterator;
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next();
            if(_loc3_.isEquipped && _loc3_.isNew && mNewItemIds.indexOf(_loc3_.databaseId) == -1)
            {
               mNewItemIds.push(_loc3_.databaseId);
            }
         }
         _loc2_ = mDBFacade.dbAccountInfo.inventoryInfo.stackables.iterator() as IMapIterator;
         while(_loc2_.hasNext())
         {
            _loc4_ = _loc2_.next();
            if(_loc4_.isEquipped && _loc4_.isNew && mNewStackableIds.indexOf(_loc4_.databaseId) == -1)
            {
               mNewStackableIds.push(_loc4_.databaseId);
            }
         }
         _loc2_ = mDBFacade.dbAccountInfo.inventoryInfo.pets.iterator() as IMapIterator;
         while(_loc2_.hasNext())
         {
            _loc1_ = _loc2_.next();
            if(_loc1_.isEquipped && _loc1_.isNew && mNewPetIds.indexOf(_loc1_.databaseId) == -1)
            {
               mNewPetIds.push(_loc1_.databaseId);
            }
         }
      }
      
      private function markItemsNotNew() : void
      {
         if(mNewChestIds.length || mNewItemIds.length || mNewStackableIds.length || mNewPetIds.length)
         {
            mDBFacade.dbAccountInfo.inventoryInfo.markItemsNotNew();
            mNewItemIds.length = 0;
            mNewStackableIds.length = 0;
            mNewPetIds.length = 0;
            mNewChestIds.length = 0;
         }
      }
      
      public function exitState() : void
      {
         this.markItemsNotNew();
         this.processChosenAvatar();
      }
      
      private function numElementsInCurrentCategory() : uint
      {
         var _loc1_:uint = 0;
         switch(mCurrentTab)
         {
            case "WEAPON":
               _loc1_ = mDBFacade.dbAccountInfo.inventoryLimitWeapons;
               break;
            case "POWERUP":
               _loc1_ = mDBFacade.dbAccountInfo.stackableCount;
               if(_loc1_ % 15 != 0)
               {
                  _loc1_ += 15 - _loc1_ % 15;
               }
               break;
            default:
               _loc1_ = 0;
         }
         return _loc1_;
      }
      
      private function numPagesInCurrentCategory() : uint
      {
         return Math.ceil(numElementsInCurrentCategory() / 15);
      }
      
      private function displayCategoryPage() : void
      {
         var _loc11_:InventoryBaseInfo = null;
         var _loc3_:UIInventoryItem = null;
         var _loc7_:int = 0;
         var _loc4_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Vector.<InventoryBaseInfo> = mCategorizedItems.itemFor(mCurrentTab);
         if(mDungeonRewardPanel)
         {
            mDungeonRewardPanel.hide();
         }
         if(mCurrentTab == "WEAPON")
         {
            mStacksWithEquipPicker.hide();
            if(mWantPets)
            {
               mPetsWithEquipPicker.hide();
            }
            mStuffWithEquipPicker.hide();
            mAddStorageButton.visible = true;
            mHeroWithEquipPicker.refresh(false);
            mHeroWithEquipPicker.show();
            if(mDungeonRewardPanel)
            {
               mDungeonRewardPanel.show();
            }
         }
         else if(mCurrentTab == "POWERUP")
         {
            mHeroWithEquipPicker.hide();
            if(mWantPets)
            {
               mPetsWithEquipPicker.hide();
            }
            mStuffWithEquipPicker.hide();
            mAddStorageButton.visible = false;
            mStacksWithEquipPicker.refresh(false);
            mStacksWithEquipPicker.show();
         }
         else if(mWantPets && mCurrentTab == "PET")
         {
            mHeroWithEquipPicker.hide();
            mStacksWithEquipPicker.hide();
            mStuffWithEquipPicker.hide();
            mAddStorageButton.visible = false;
            mPetsWithEquipPicker.refresh(false);
            mPetsWithEquipPicker.show();
         }
         else if(mWantPets && mCurrentTab == "STUFF")
         {
            mHeroWithEquipPicker.hide();
            mStacksWithEquipPicker.hide();
            if(mWantPets)
            {
               mPetsWithEquipPicker.hide();
            }
            mAddStorageButton.visible = false;
            mStuffWithEquipPicker.refresh(false);
            mStuffWithEquipPicker.show();
         }
         _loc7_ = 0;
         while(_loc7_ < 15)
         {
            _loc3_ = mItems[_loc7_];
            _loc3_.deSelect();
            _loc3_.visible = false;
            _loc7_++;
         }
         var _loc1_:uint = mCurrentPage * 15;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc7_ = 0;
         while(_loc7_ < mInventoryGridElements.length)
         {
            mInventoryGridElements[_loc7_].visible = true;
            _loc7_++;
         }
         var _loc2_:Boolean = false;
         var _loc8_:uint = numElementsInCurrentCategory();
         if(_loc1_ + 15 > _loc8_ && numElementsInCurrentCategory())
         {
            _loc4_ = _loc1_ + 15 - numElementsInCurrentCategory();
            _loc9_ = mInventoryGridElements.length - _loc4_;
            _loc7_ = mInventoryGridElements.length - 1;
            while(_loc7_ >= _loc9_)
            {
               if(_loc7_ < mInventoryGridElements.length)
               {
                  mInventoryGridElements[_loc7_].visible = false;
               }
               else
               {
                  _loc2_ = true;
               }
               _loc7_--;
            }
         }
         _loc7_ = 0;
         while(_loc7_ < _loc1_ && _loc5_ < _loc10_.length)
         {
            _loc11_ = _loc10_[_loc5_];
            if(!_loc11_.isEquipped)
            {
               _loc7_++;
            }
            _loc5_++;
         }
         while(_loc6_ < 15 && _loc5_ < _loc10_.length)
         {
            _loc11_ = _loc10_[_loc5_];
            if(!_loc11_.isEquipped && _loc11_.hasGMPropertySetup())
            {
               _loc3_ = mItems[_loc6_];
               _loc3_.info = _loc11_;
               _loc3_.root.visible = true;
               if(_loc11_.isNew)
               {
                  if(_loc11_ is ChestInfo && mNewChestIds.indexOf(_loc11_.databaseId) == -1)
                  {
                     mNewChestIds.push(_loc11_.databaseId);
                  }
                  else if(_loc11_ is ItemInfo && mNewItemIds.indexOf(_loc11_.databaseId) == -1)
                  {
                     mNewItemIds.push(_loc11_.databaseId);
                  }
                  else if(_loc11_ is StackableInfo && mNewStackableIds.indexOf(_loc11_.databaseId) == -1)
                  {
                     mNewStackableIds.push(_loc11_.databaseId);
                  }
                  else if(_loc11_ is PetInfo && mNewPetIds.indexOf(_loc11_.databaseId) == -1)
                  {
                     mNewPetIds.push(_loc11_.databaseId);
                  }
               }
               _loc6_++;
            }
            _loc5_++;
         }
         determineEquippableItems(mHeroWithEquipPicker.currentlySelectedHero);
      }
      
      private function showTab(param1:String, param2:uint = 0) : void
      {
         var _loc4_:UIRadioButton = null;
         mCurrentTab = param1;
         var _loc5_:IMapIterator = mTabButtons.iterator() as IMapIterator;
         while(_loc5_.hasNext())
         {
            _loc4_ = _loc5_.next();
            _loc4_.enabled = true;
         }
         _loc4_ = mTabButtons.itemFor(mCurrentTab);
         _loc4_.selected = true;
         _loc4_.enabled = false;
         _loc4_.label.visible = true;
         var _loc3_:uint = this.numPagesInCurrentCategory();
         param2 = Math.min(_loc3_,param2);
         mPagination.currentPage = mCurrentPage = param2;
         mPagination.numPages = _loc3_;
         mPagination.visible = _loc3_ > 1;
         displayCategoryPage();
      }
      
      private function setCurrentPage(param1:uint) : void
      {
         mCurrentPage = param1;
         displayCategoryPage();
      }
      
      public function get infoCard() : ItemInfoCard
      {
         return mInfoCard;
      }
      
      public function get chestCard() : ChestInfoCard
      {
         return mChestCard;
      }
      
      public function set currentTab(param1:String) : void
      {
         mCurrentTab = param1;
      }
      
      private function itemSelected(param1:InventoryBaseInfo) : void
      {
         var _loc2_:StackableInfo = null;
         mSelectedItemInfo = param1;
         var _loc3_:Boolean = false;
         if(param1 is StackableInfo)
         {
            _loc2_ = param1 as StackableInfo;
            if(_loc2_.gmStackable.AccountBooster)
            {
               populateDetailBoosterCard();
               _loc3_ = true;
            }
         }
         if(!_loc3_)
         {
            mBoosterCard.hide();
            if(mSelectedItemInfo.gmChestInfo)
            {
               populateDetailChestCard();
            }
            else
            {
               populateDetailInfoCard();
            }
         }
         highLightSelectedItem();
      }
      
      private function highLightSelectedItem() : void
      {
         if(mSelectedItemInfo as ChestInfo)
         {
            highLightSelectedChestItem();
         }
         else if(mSelectedItemInfo as ItemInfo)
         {
            highLightSelectedAvatarItem();
         }
         else if(mSelectedItemInfo as StackableInfo)
         {
            highLightSelectedAccountItem();
         }
         else if(mWantPets && mSelectedItemInfo as PetInfo)
         {
            highLightSelectedPet();
         }
      }
      
      private function highLightSelectedChestItem() : void
      {
         var _loc2_:UIInventoryItem = null;
         var _loc3_:* = 0;
         if(mDungeonRewardPanel)
         {
            mDungeonRewardPanel.clearHighlights();
         }
         var _loc1_:ChestInfo = mSelectedItemInfo as ChestInfo;
         if(_loc1_.isFromDungeonSummary())
         {
            _loc3_ = 0;
            while(_loc3_ < 15)
            {
               mItems[_loc3_].deSelect();
               _loc3_++;
            }
            mDungeonRewardPanel.highlightChest(_loc1_);
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < 15)
         {
            _loc2_ = mItems[_loc3_];
            if(mSelectedItemInfo && _loc2_.info == mSelectedItemInfo)
            {
               _loc2_.select();
            }
            else
            {
               _loc2_.deSelect();
            }
            _loc3_++;
         }
      }
      
      private function highLightSelectedAvatarItem() : void
      {
         var _loc2_:GMWeaponItem = null;
         var _loc4_:* = 0;
         var _loc1_:UIInventoryItem = null;
         var _loc3_:* = 0;
         if(mDungeonRewardPanel)
         {
            mDungeonRewardPanel.clearHighlights();
         }
         var _loc5_:ItemInfo = mSelectedItemInfo as ItemInfo;
         mHeroWithEquipPicker.deselectEquipment();
         if(mHeroWithEquipPicker.highlightItem(mSelectedItemInfo))
         {
            _loc2_ = _loc5_.gmWeaponItem;
            _loc4_ = _loc5_.power;
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 15)
            {
               _loc1_ = mItems[_loc3_];
               if(mSelectedItemInfo && _loc1_.info == mSelectedItemInfo)
               {
                  _loc1_.select();
                  if(_loc5_)
                  {
                     _loc2_ = _loc5_.gmWeaponItem;
                     _loc4_ = _loc5_.power;
                  }
               }
               else
               {
                  _loc1_.deSelect();
               }
               _loc3_++;
            }
         }
         if(_loc2_ != null)
         {
            mHeroWithEquipPicker.showWeaponComparison(_loc2_,_loc4_);
         }
      }
      
      private function highLightSelectedAccountItem() : void
      {
         var _loc4_:GMStackable = null;
         var _loc5_:int = 0;
         var _loc2_:UIInventoryItem = null;
         var _loc3_:* = 0;
         var _loc1_:StackableInfo = mSelectedItemInfo as StackableInfo;
         mStacksWithEquipPicker.deselectEquipment();
         if(mStacksWithEquipPicker.highlightItem(mSelectedItemInfo))
         {
            _loc4_ = _loc1_.gmStackable;
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 15)
            {
               _loc2_ = mItems[_loc3_];
               if(mSelectedItemInfo && _loc2_.info == mSelectedItemInfo)
               {
                  _loc2_.select();
                  if(_loc1_)
                  {
                     _loc4_ = _loc1_.gmStackable;
                  }
               }
               else
               {
                  _loc2_.deSelect();
               }
               _loc3_++;
            }
         }
         if(_loc4_ != null)
         {
         }
      }
      
      private function highLightSelectedPet() : void
      {
         var _loc1_:GMNpc = null;
         var _loc3_:UIInventoryItem = null;
         var _loc4_:* = 0;
         var _loc2_:PetInfo = mSelectedItemInfo as PetInfo;
         mPetsWithEquipPicker.deselectEquipment();
         if(mPetsWithEquipPicker.highlightItem(mSelectedItemInfo))
         {
            _loc1_ = _loc2_.gmNpc;
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < 15)
            {
               _loc3_ = mItems[_loc4_];
               if(mSelectedItemInfo && _loc3_.info == mSelectedItemInfo)
               {
                  _loc3_.select();
                  if(_loc2_)
                  {
                     _loc1_ = _loc2_.gmNpc;
                  }
               }
               else
               {
                  _loc3_.deSelect();
               }
               _loc4_++;
            }
         }
      }
      
      private function populateDetailBoosterCard() : void
      {
         mConsumableChestCard.hide();
         mChestCard.hide();
         mInfoCard.visible = false;
         mBoosterCard.info = mSelectedItemInfo as StackableInfo;
      }
      
      private function populateDetailInfoCard() : void
      {
         mConsumableChestCard.hide();
         mChestCard.hide();
         mInfoCard.info = mSelectedItemInfo;
      }
      
      private function populateDetailChestCard() : void
      {
         mInfoCard.info = null;
         if(mSelectedItemInfo == null)
         {
            mConsumableChestCard.hide();
            mChestCard.hide();
            mChestCard.selectedHeroId = mSelectedAvatar;
            return;
         }
         if(UIHud.isThisAConsumbleChestId(mSelectedItemInfo.gmId))
         {
            mConsumableChestCard.info = mSelectedItemInfo;
            mChestCard.hide();
            mBoosterCard.hide();
         }
         else
         {
            mChestCard.selectedHeroId = mSelectedAvatar;
            mChestCard.info = mSelectedItemInfo;
            mConsumableChestCard.hide();
            mBoosterCard.hide();
         }
      }
      
      public function destroy() : void
      {
         var _loc2_:UIRadioButton = null;
         if(mDungeonRewardPanel)
         {
            mDungeonRewardPanel.destroy();
         }
         mDungeonRewardPanel = null;
         mEventComponent.removeListener("DB_ACCOUNT_INFO_RESPONSE");
         mEventComponent = null;
         mSceneGraphComponent = null;
         if(mInfoCard)
         {
            mInfoCard.destroy();
            mInfoCard = null;
         }
         if(mChestCard)
         {
            mChestCard.destroy();
            mChestCard = null;
         }
         if(mConsumableChestCard)
         {
            mConsumableChestCard.destroy();
            mConsumableChestCard = null;
         }
         var _loc1_:IMapIterator = mTabButtons.iterator() as IMapIterator;
         while(_loc1_.hasNext())
         {
            _loc2_ = _loc1_.next();
            _loc2_.destroy();
         }
         mTabButtons.clear();
         mTabButtons = null;
         mPagination.destroy();
         mLogicalWorkComponent.destroy();
         mDBFacade = null;
         if(mDungeonSummary)
         {
            mDungeonSummary.loadNextChestPopUp();
         }
      }
      
      private function processChosenAvatar() : void
      {
         if(mHeroWithEquipPicker.currentlySelectedHero == null)
         {
            return;
         }
         var _loc1_:uint = mHeroWithEquipPicker.currentlySelectedHero.Id;
         if(mDBFacade.dbAccountInfo.activeAvatarInfo.gmHero.Id != _loc1_)
         {
            mDBFacade.dbAccountInfo.changeActiveAvatarRPC(_loc1_);
         }
      }
   }
}

