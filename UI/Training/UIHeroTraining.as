package UI.Training
{
   import Account.AvatarInfo;
   import Account.StoreServicesController;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.Render.MovieClipRenderController;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.SceneGraph.SceneGraphManager;
   import Brain.UI.UIButton;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Events.DBAccountResponseEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMOffer;
   import GameMasterDictionary.GMSkin;
   import Town.TownHeader;
   import UI.EquipPicker.HeroWithEquipPicker;
   import UI.UIRetrainPopup;
   import UI.UITownTweens;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   
   public class UIHeroTraining
   {
      
      private static var RESPEC_OFFER_ID:uint = 51303;
      
      private var mDBFacade:DBFacade;
      
      private var mLastHeroId:uint;
      
      private var mFakeHeroInfo:AvatarInfo;
      
      private var mHeroInfo:AvatarInfo;
      
      private var mSelectedHero:GMHero;
      
      private var mHeroWithEquipPicker:HeroWithEquipPicker;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mAssetsLoaded:Boolean = false;
      
      private var mIconSwfAsset:SwfAsset;
      
      private var mUIRoot:MovieClip;
      
      private var mTownHeader:TownHeader;
      
      private var mHeroPortrait:MovieClip;
      
      private var mHeroPortraitText:TextField;
      
      private var mStatHelpers:Vector.<UIStatHelper>;
      
      private var mStatLevelPlusButtons:Vector.<UIButton>;
      
      private var mHeroLevel:uint;
      
      private var mBasicCurrencyText:TextField;
      
      private var mPremiumCurrencyText:TextField;
      
      private var mSpendButton:UIButton;
      
      private var mSpendAmount:int;
      
      private var mPendingDBWrite:Boolean;
      
      private var mResetButton:UIButton;
      
      protected var mGMOffer:GMOffer;
      
      protected var mLogicalWorkComponent:LogicalWorkComponent;
      
      protected var mEventComponent:EventComponent;
      
      public function UIHeroTraining(param1:DBFacade, param2:SwfAsset, param3:MovieClip, param4:TownHeader)
      {
         super();
         mDBFacade = param1;
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         mEventComponent = new EventComponent(mDBFacade);
         mTownHeader = param4;
         var _loc8_:Class = param2.getClass("DR_weapon_tooltip_z");
         var _loc6_:Class = param2.getClass("DR_weapon_tooltip");
         var _loc7_:Class = param2.getClass("avatar_tooltip");
         mHeroWithEquipPicker = new HeroWithEquipPicker(mDBFacade,param3.hero_picker,_loc6_,_loc8_,_loc7_,heroSelected);
         var _loc5_:Object = {"avatar_id":103};
         mFakeHeroInfo = new AvatarInfo(mDBFacade,_loc5_,null);
         this.setupUI(param3,param2.getClass("stat_tooltip"));
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/Icons/Stats/db_icon_stats.swf"),setupIcons);
         mGMOffer = mDBFacade.gameMaster.offerById.itemFor(RESPEC_OFFER_ID);
      }
      
      private function setupUI(param1:MovieClip, param2:Class) : void
      {
         var rootClip:MovieClip = param1;
         var tooltipClass:Class = param2;
         mUIRoot = rootClip.training_main;
         mHeroPortrait = rootClip.training_avatar;
         mHeroPortraitText = mUIRoot.hero_text;
         mStatHelpers = new Vector.<UIStatHelper>();
         mStatLevelPlusButtons = new Vector.<UIButton>();
         var createFunc:Function = function(param1:int):Function
         {
            var i:int = param1;
            return function():void
            {
               statPlusReleased(i);
            };
         };
         var listOfStatUpgrades:Array = [mUIRoot.UI_statupgrade1,mUIRoot.UI_statupgrade2,mUIRoot.UI_statupgrade3,mUIRoot.UI_statupgrade4];
         var listOfStatPlusButtons:Array = [mUIRoot.statupgrade1_plus_button,mUIRoot.statupgrade2_plus_button,mUIRoot.statupgrade3_plus_button,mUIRoot.statupgrade4_plus_button];
         var i:int = 0;
         while(i < 4)
         {
            mStatHelpers.push(new UIStatHelper(mDBFacade,tooltipClass,listOfStatUpgrades[i]));
            mStatLevelPlusButtons.push(new UIButton(mDBFacade,listOfStatPlusButtons[i]));
            mStatLevelPlusButtons[i].releaseCallback = createFunc(i);
            ++i;
         }
         mSpendButton = new UIButton(mDBFacade,mUIRoot.spend_button);
         mSpendButton.enabled = false;
         mResetButton = new UIButton(mDBFacade,mUIRoot.reset_button);
         mResetButton.label.text = Locale.getString("RETRAIN");
         mResetButton.releaseCallback = function():void
         {
            resetReleased();
         };
         disableHud();
      }
      
      public function animateEntry() : void
      {
         UITownTweens.avatarFadeInTweenSequence(mHeroPortrait);
         mTownHeader.rootMovieClip.visible = false;
         mLogicalWorkComponent.doLater(0.20833333333333334,function(param1:GameClock):void
         {
            mTownHeader.animateHeader();
         });
         mUIRoot.visible = false;
         mLogicalWorkComponent.doLater(0.16666666666666666,function(param1:GameClock):void
         {
            UITownTweens.rightPanelTweenSequence(mUIRoot,mDBFacade);
         });
         mHeroWithEquipPicker.visible = false;
         mLogicalWorkComponent.doLater(0.5,function(param1:GameClock):void
         {
            UITownTweens.footerTweenSequence(mHeroWithEquipPicker.root,mDBFacade);
         });
      }
      
      public function setupIcons(param1:SwfAsset) : void
      {
         mAssetsLoaded = true;
         mIconSwfAsset = param1;
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         mDBFacade = null;
         mFakeHeroInfo.destroy();
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            mStatHelpers[_loc1_].destroy();
            mStatLevelPlusButtons[_loc1_].destroy();
            _loc1_++;
         }
         mSpendButton.destroy();
         mResetButton.destroy();
         mHeroWithEquipPicker.destroy();
         mLogicalWorkComponent.destroy();
         mSceneGraphComponent.destroy();
         mAssetLoadingComponent.destroy();
         mEventComponent.destroy();
      }
      
      public function enableHud() : void
      {
         mTownHeader.title = Locale.getString("TRAINING_HEADER");
         mPendingDBWrite = false;
         mEventComponent.removeAllListeners();
         mEventComponent.addListener("DB_ACCOUNT_INFO_RESPONSE",dbAccountInfoUpdate);
         mHeroWithEquipPicker.refresh(true);
         mHeroInfo = mDBFacade.dbAccountInfo.activeAvatarInfo;
         mSelectedHero = mDBFacade.gameMaster.heroById.itemFor(mHeroInfo.avatarType);
         var _loc1_:Boolean = mDBFacade.dbAccountInfo.inventoryInfo.ownsItem(mSelectedHero.Id);
         this.heroSelected(mSelectedHero,_loc1_);
         mUIRoot.visible = true;
         mHeroPortrait.visible = true;
      }
      
      public function disableHud() : void
      {
         mEventComponent.removeAllListeners();
         mUIRoot.visible = false;
         mHeroPortrait.visible = false;
         mHeroWithEquipPicker.setAvatarAlert(false);
      }
      
      protected function greyHero(param1:Boolean) : void
      {
         var _loc4_:Vector.<DisplayObject> = new <DisplayObject>[mUIRoot];
         var _loc2_:ColorMatrixFilter = SceneGraphManager.getGrayScaleSaturationFilter(5);
         for each(var _loc3_ in _loc4_)
         {
            _loc3_.filters = param1 ? [_loc2_] : [];
         }
      }
      
      protected function shouldGreyHero(param1:GMHero) : Boolean
      {
         return false;
      }
      
      private function writeStatsToDatabase() : void
      {
         mHeroInfo.RPC_updateAvatarSlots(mStatHelpers[0].amount,mStatHelpers[1].amount,mStatHelpers[2].amount,mStatHelpers[3].amount,null,null);
         mPendingDBWrite = false;
      }
      
      private function heroSelected(param1:GMHero, param2:Boolean) : void
      {
         var gmSkin:GMSkin;
         var avatarJson:Object;
         var gmHero:GMHero = param1;
         var owned:Boolean = param2;
         if(gmHero == null)
         {
            return;
         }
         if(mPendingDBWrite)
         {
            writeStatsToDatabase();
         }
         greyHero(!owned);
         mSelectedHero = gmHero;
         mHeroInfo = mDBFacade.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(mSelectedHero.Id);
         if(mHeroInfo == null)
         {
            avatarJson = {"avatar_id":mSelectedHero.Id};
            mFakeHeroInfo.init(avatarJson);
            mHeroInfo = mFakeHeroInfo;
            gmSkin = mDBFacade.gameMaster.getSkinByConstant(mSelectedHero.DefaultSkin);
         }
         else
         {
            gmSkin = mDBFacade.gameMaster.getSkinByType(mHeroInfo.skinId);
         }
         mHeroLevel = mSelectedHero.getLevelFromExp(mHeroInfo.experience);
         if(gmSkin == null)
         {
            Logger.error("Unable to find gmSkin for ID: " + mHeroInfo.skinId);
         }
         else
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(gmSkin.PortraitName),function(param1:SwfAsset):void
            {
               var _loc3_:Class = param1.getClass(gmSkin.CardName);
               if(_loc3_ == null)
               {
                  return;
               }
               var _loc4_:MovieClip = new _loc3_();
               _loc4_.scaleX = _loc4_.scaleY = 0.7;
               _loc4_.x = 15;
               var _loc2_:MovieClipRenderController = new MovieClipRenderController(mDBFacade,_loc4_);
               _loc2_.play();
               if(mHeroPortrait.numChildren > 0)
               {
                  mHeroPortrait.removeChildAt(0);
               }
               mHeroPortrait.addChildAt(_loc4_,0);
            });
         }
         readSelectedHeroInfo();
         mHeroWithEquipPicker.setAvatarAlert(true);
         updateUIFromDB();
      }
      
      private function dbAccountInfoUpdate(param1:DBAccountResponseEvent) : void
      {
         mHeroInfo = param1.dbAccountInfo.inventoryInfo.getAvatarInfoForHeroType(mSelectedHero.Id);
         mHeroWithEquipPicker.setAvatarAlert(true);
         updateUIFromDB();
      }
      
      private function get spendAmount() : int
      {
         if(mHeroInfo == mFakeHeroInfo)
         {
            return 0;
         }
         return mHeroInfo.skillPointsAvailable;
      }
      
      private function get spendAmountClient() : int
      {
         if(mHeroInfo == mFakeHeroInfo)
         {
            return 0;
         }
         return Math.max(mHeroInfo.skillPointsEarned - (mStatHelpers[0].amount + mStatHelpers[1].amount + mStatHelpers[2].amount + mStatHelpers[3].amount),0);
      }
      
      private function updateResetButton() : void
      {
         var _loc1_:uint = mSelectedHero.getTotalStatFromExp(mHeroInfo.experience);
         var _loc2_:uint = uint(spendAmountClient);
         mResetButton.enabled = false;
         if(mHeroInfo != mFakeHeroInfo && _loc2_ != _loc1_)
         {
            mResetButton.enabled = true;
         }
      }
      
      public function readSelectedHeroInfo() : void
      {
         var _loc2_:int = 0;
         mHeroPortraitText.text = mSelectedHero.Name.toUpperCase();
         var _loc1_:Array = [mSelectedHero.StatUpgrade1,mSelectedHero.StatUpgrade2,mSelectedHero.StatUpgrade3,mSelectedHero.StatUpgrade4];
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            mStatHelpers[_loc2_].statName = _loc1_[_loc2_];
            mStatHelpers[_loc2_].refresh(mIconSwfAsset);
            _loc2_++;
         }
         mUIRoot.training_db_name.text = mDBFacade.gameMaster.attackByConstant.itemFor(mSelectedHero.DBuster1).Name.toUpperCase();
         mUIRoot.training_db_description.text = mDBFacade.gameMaster.attackByConstant.itemFor(mSelectedHero.DBuster1).Description;
         mUIRoot.xp_label.level_label.text = mHeroLevel;
      }
      
      private function updateUIClient() : void
      {
         var _loc4_:int = 0;
         var _loc3_:uint = 25;
         var _loc2_:uint = 50;
         var _loc1_:uint = 75;
         mPendingDBWrite = true;
         mSpendAmount = spendAmountClient;
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            mStatHelpers[_loc4_].updateUI();
            mStatLevelPlusButtons[_loc4_].enabled = false;
            _loc4_++;
         }
         mSpendButton.root.spend_amount_text.text = mSpendAmount;
         if(mSpendAmount <= 0)
         {
            mSpendAmount = 0;
            mHeroWithEquipPicker.disableAvatarAlertOnSelectedHero();
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               if(mStatHelpers[_loc4_].statAmount < _loc1_)
               {
                  mStatLevelPlusButtons[_loc4_].enabled = true;
               }
               _loc4_++;
            }
         }
         updateResetButton();
      }
      
      private function updateUIFromDB() : void
      {
         var _loc4_:int = 0;
         var _loc3_:uint = 25;
         var _loc2_:uint = 50;
         var _loc1_:uint = 75;
         var _loc5_:Array = [mHeroInfo.statUpgrade1,mHeroInfo.statUpgrade2,mHeroInfo.statUpgrade3,mHeroInfo.statUpgrade4];
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            mStatHelpers[_loc4_].statAmount = _loc5_[_loc4_];
            _loc4_++;
         }
         mHeroLevel = mSelectedHero.getLevelFromExp(mHeroInfo.experience);
         mSpendAmount = spendAmount;
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            mStatHelpers[_loc4_].updateUI();
            mStatLevelPlusButtons[_loc4_].enabled = false;
            _loc4_++;
         }
         mSpendButton.root.spend_amount_text.text = mSpendAmount;
         if(mSpendAmount <= 0)
         {
            mSpendAmount = 0;
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               if(mStatHelpers[_loc4_].statAmount < _loc1_)
               {
                  mStatLevelPlusButtons[_loc4_].enabled = true;
               }
               _loc4_++;
            }
         }
         updateResetButton();
      }
      
      public function setCurrency(param1:int, param2:int) : void
      {
         if(!mAssetsLoaded)
         {
            return;
         }
         mBasicCurrencyText.text = param1.toString();
         mPremiumCurrencyText.text = param2.toString();
      }
      
      public function setBasicCurrency(param1:int) : void
      {
         if(!mAssetsLoaded)
         {
            return;
         }
         mBasicCurrencyText.text = param1.toString();
      }
      
      public function setPremiumCurrency(param1:int) : void
      {
         if(!mAssetsLoaded)
         {
            return;
         }
         mPremiumCurrencyText.text = param1.toString();
      }
      
      private function statPlusReleased(param1:int) : void
      {
         mStatHelpers[param1].statAmount = mStatHelpers[param1].amount + 1;
         updateUIClient();
      }
      
      private function resetReleased() : void
      {
         var popup:UIRetrainPopup;
         if(mGMOffer)
         {
            popup = new UIRetrainPopup(mDBFacade,function():void
            {
               StoreServicesController.tryBuyOffer(mDBFacade,mGMOffer,function(param1:*):void
               {
                  var _loc2_:int = 0;
                  _loc2_ = 0;
                  while(_loc2_ < 4)
                  {
                     mStatHelpers[_loc2_].statAmount = 0;
                     _loc2_++;
                  }
                  updateUIClient();
               });
            },mGMOffer.Price);
         }
      }
      
      public function processChosenAvatar() : void
      {
         if(mHeroWithEquipPicker.currentlySelectedHero == null)
         {
            return;
         }
         if(mPendingDBWrite)
         {
            writeStatsToDatabase();
         }
         var _loc1_:uint = mHeroWithEquipPicker.currentlySelectedHero.Id;
         if(mDBFacade.dbAccountInfo.activeAvatarInfo.gmHero.Id != _loc1_)
         {
            mDBFacade.dbAccountInfo.changeActiveAvatarRPC(_loc1_);
         }
      }
   }
}

