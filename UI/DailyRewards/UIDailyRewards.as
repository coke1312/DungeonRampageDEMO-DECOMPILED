package UI.DailyRewards
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   import Brain.Render.MovieClipRenderController;
   import Brain.Sound.SoundAsset;
   import Brain.UI.UIButton;
   import Brain.jsonRPC.JSONRPCService;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMOffer;
   import Sound.DBSoundComponent;
   import UI.DBUIPopup;
   import UI.UICashPage;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   
   public class UIDailyRewards extends DBUIPopup
   {
      
      public static const UI_DAILY_REWARD_SWF_PATH:String = "Resources/Art2D/UI/db_UI_daily_reward.swf";
      
      public static const DAILY_REWARD_GOLD_POPUP_CLASS_NAME:String = "UI_daily_rewards";
      
      public static const DAILY_REWARD_MYSTERY_BOX_POPUP_CLASS_NAME:String = "UI_daily_rewards_mysterybox";
      
      public static const DAILY_REWARD_SLOT_MOVIE_CLASS_NAME:String = "reveal_storageBox_slotMachine";
      
      public static const UI_ICON_SWF_PATH:String = "Resources/Art2D/Icons/Items/db_icons_items.swf";
      
      public static const COIN_SMALL_CLASS_NAME:String = "db_items_coins_small";
      
      public static const COIN_MEDIUM_CLASS_NAME:String = "db_items_coins_medium_static";
      
      public static const COIN_LARGE_CLASS_NAME:String = "db_items_coins_large_static";
      
      public static const COIN_SMALL_ANIM_CLASS_NAME:String = "db_items_coins_small_anim";
      
      public static const COIN_MEDIUM_ANIM_CLASS_NAME:String = "db_items_coins_medium";
      
      public static const COIN_LARGE_ANIM_CLASS_NAME:String = "db_items_coins_large";
      
      public static const MYSTERY_BOX_CLASS_NAME:String = "db_items_box_mystery";
      
      public static const millisecondsPerMinute:int = 60000;
      
      public static const millisecondsPerHour:int = 3600000;
      
      public static const millisecondsPerDay:int = 86400000;
      
      private var mTownRoot:MovieClip;
      
      private var mDailyRewardGoldPopup:MovieClip;
      
      private var mDailyRewardMysteryBoxPopup:MovieClip;
      
      private var mSlotMovie:MovieClip;
      
      private var mCrewBonusController:MovieClipRenderController;
      
      private var mSlotMovieController:MovieClipRenderController;
      
      private var mRedeemRewardsButton:UIButton;
      
      private var mAcceptButton:UIButton;
      
      private var mExitButton:UIButton;
      
      private var mReplayButton:UIButton;
      
      private var mCrewButton:UIButton;
      
      private var mBoxArray:Array;
      
      private var mRewardArray:Array;
      
      private var mDisplayOffers:Vector.<GMOffer>;
      
      private var mBoxPicked:int;
      
      private var mRewardInfo:Array;
      
      private var mCountGold:int;
      
      private var mCountCrew:int;
      
      private var mRewardIcon0:MovieClip;
      
      private var mRewardIcon1:MovieClip;
      
      private var mRewardIcon2:MovieClip;
      
      private var mBox0:MovieClip;
      
      private var mBox1:MovieClip;
      
      private var mBox2:MovieClip;
      
      private var mBoxButton0:UIButton;
      
      private var mBoxButton1:UIButton;
      
      private var mBoxButton2:UIButton;
      
      private var mTimerTarget:Number;
      
      private var mCountdownTimer:Timer;
      
      private var mTimerTargetDate:Date;
      
      private var mRewardName:String;
      
      private var mPaytoReplay:Boolean;
      
      private var mGotRefund:Boolean;
      
      private var mSkipGoldCount:Boolean = false;
      
      private var mForceOpen:Boolean = forceOpen;
      
      private var mWindowGoldDisplayed:Boolean = false;
      
      private var mWindowMysteryDisplayed:Boolean = false;
      
      private var mGoldStartY:int = 200;
      
      private var mGoldEndY:int;
      
      private var mGoldCount:int;
      
      private var mGoldSlideTimer:Timer;
      
      private var mGoldCountTimer:Timer;
      
      private var mGoldCountTotal:int;
      
      private var mGoldPerCrew:int;
      
      private var mGoldPerCount:int;
      
      private var mGoldDarkTimer:Timer;
      
      private var mMysteryStartY:int = 500;
      
      private var mMysteryEndY:int;
      
      private var mMysterySlideTimer:Timer;
      
      private var mMysteryFadeTimer:Timer;
      
      private var mBoxAlpha:Number;
      
      private var mRewardAlpha:Number;
      
      private var mSoundGoldPlunk:SoundAsset;
      
      private var mSoundGoldStart:SoundAsset;
      
      private var mSoundBox:SoundAsset;
      
      private var mSoundComponent:DBSoundComponent;
      
      private var mTimeToNext:int;
      
      private var mCostPlay:int;
      
      public function UIDailyRewards(param1:DBFacade, param2:Function, param3:Boolean)
      {
         var dbFacade:DBFacade = param1;
         var closeCallback:Function = param2;
         var forceOpen:Boolean = param3;
         mDBFacade = dbFacade;
         mCloseCallback = closeCallback;
         super(dbFacade,"",null,true,true,function():void
         {
            if(closeCallback != null)
            {
               closeCallback();
            }
         },false);
         mPopup.visible = false;
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mSoundComponent = new DBSoundComponent(mDBFacade);
         mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),"ExpCollectSound",function(param1:SoundAsset):void
         {
            mSoundGoldPlunk = param1;
         });
         mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),"TEMP_DooberGoldLarge1",function(param1:SoundAsset):void
         {
            mSoundGoldStart = param1;
         });
         mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),"DailyRewardShred",function(param1:SoundAsset):void
         {
            mSoundBox = param1;
         });
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_daily_reward.swf"),dailyRewardPopupLoaded);
      }
      
      private function displayWindow() : void
      {
         if(mWindowGoldDisplayed == false)
         {
            mRoot.addChild(mDailyRewardGoldPopup);
            mGoldEndY = mDailyRewardGoldPopup.y;
            mDailyRewardGoldPopup.y = mGoldStartY;
            mWindowGoldDisplayed = true;
            mGoldSlideTimer = new Timer(16);
            mGoldSlideTimer.addEventListener("timer",goldSlideTimerTick);
            mDailyRewardGoldPopup.alpha = 0;
            mGoldSlideTimer.start();
            mDBFacade.mInDailyReward = true;
         }
      }
      
      private function goldSlideTimerTick(param1:TimerEvent) : void
      {
         mDailyRewardGoldPopup.y -= 5 + 0.1 * Math.abs(mDailyRewardGoldPopup.y - mGoldEndY);
         mDailyRewardGoldPopup.alpha += 0.1;
         if(mDailyRewardGoldPopup.y <= mGoldEndY)
         {
            mDailyRewardGoldPopup.alpha = 1;
            mDailyRewardGoldPopup.y = mGoldEndY;
            mGoldSlideTimer.removeEventListener("timer",goldSlideTimerTick);
            mGoldSlideTimer.stop();
            startGoldCount();
         }
      }
      
      private function startGoldCount() : void
      {
         mCountGold = 0;
         mCountCrew = 0;
         var _loc1_:int = 10 / mRewardInfo[1] + 2;
         mGoldCountTimer = new Timer(50);
         mGoldCountTimer.addEventListener("timer",goldCountTimerTick);
         mGoldCountTotal = mRewardInfo[2][mRewardInfo[0] - 1] * mRewardInfo[1];
         mGoldPerCount = 5 + 0.5 * (mGoldCountTotal / 30);
         mGoldPerCrew = mRewardInfo[2][mRewardInfo[0] - 1];
         if(mSkipGoldCount)
         {
            startMysterySlide();
         }
         else
         {
            mGoldCountTimer.start();
         }
         if(mSoundGoldStart != null)
         {
            mSoundComponent.playSfxOneShot(mSoundGoldStart);
         }
      }
      
      private function goldCountTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:GlowFilter = null;
         if(mDBFacade == null)
         {
            mGoldCountTimer.removeEventListener("timer",goldCountTimerTick);
            mGoldCountTimer.stop();
            return;
         }
         mCountGold += mGoldPerCount;
         mDailyRewardGoldPopup.label_number.text = mCountGold;
         if(mCountGold >= mGoldPerCrew * (mCountCrew + 1) && mCountCrew < mRewardInfo[1] - 1)
         {
            if(mSoundGoldPlunk != null)
            {
               mSoundComponent.playSfxOneShot(mSoundGoldPlunk);
            }
            if(mSoundGoldStart != null)
            {
               mSoundComponent.playSfxOneShot(mSoundGoldStart);
            }
            mCountCrew += 1;
            mDailyRewardGoldPopup.crewBonus_anim.crewBonus.header_crew_bonus_number.text = mCountCrew;
            _loc2_ = new GlowFilter(16777215,1,5,5,1,1,false,false);
            _loc2_.quality = 2;
            mDailyRewardGoldPopup.label_number.filters = [_loc2_];
            mDailyRewardGoldPopup.crewBonus_anim.crewBonus.header_crew_bonus_number.filters = [_loc2_];
            mGoldDarkTimer = new Timer(100);
            mGoldDarkTimer.addEventListener("timer",darkenGoldText);
            mGoldDarkTimer.start();
         }
         if(mCountGold >= mGoldCountTotal)
         {
            mDailyRewardGoldPopup.label_number.text = mGoldCountTotal;
            mDailyRewardGoldPopup.crewBonus_anim.crewBonus.header_crew_bonus_number.text = mRewardInfo[1] - 1;
            mGoldCountTimer.removeEventListener("timer",goldCountTimerTick);
            mGoldCountTimer.stop();
            startMysterySlide();
         }
      }
      
      private function darkenGoldText(param1:TimerEvent) : void
      {
         if(mDBFacade == null)
         {
            return;
         }
         var _loc2_:GlowFilter = new GlowFilter(0,1,2,2,4,1,false,false);
         _loc2_.quality = 2;
         mDailyRewardGoldPopup.label_number.filters = [_loc2_];
         mDailyRewardGoldPopup.crewBonus_anim.crewBonus.header_crew_bonus_number.filters = [_loc2_];
         mGoldDarkTimer.removeEventListener("timer",goldCountTimerTick);
         mGoldDarkTimer.stop();
      }
      
      private function startMysterySlide() : void
      {
         if(mWindowMysteryDisplayed == false)
         {
            mRoot.addChild(mDailyRewardMysteryBoxPopup);
            mWindowMysteryDisplayed = true;
         }
         mMysteryEndY = mDailyRewardMysteryBoxPopup.y;
         mDailyRewardMysteryBoxPopup.y = mMysteryStartY;
         mMysterySlideTimer = new Timer(16);
         mMysterySlideTimer.addEventListener("timer",mysterySlideTimerTick);
         mDailyRewardMysteryBoxPopup.alpha = 0;
         mMysterySlideTimer.start();
      }
      
      private function mysterySlideTimerTick(param1:TimerEvent) : void
      {
         mDailyRewardMysteryBoxPopup.alpha += 0.1;
         mDailyRewardMysteryBoxPopup.y -= 5 + 0.1 * Math.abs(mDailyRewardMysteryBoxPopup.y - mMysteryEndY);
         if(mDailyRewardMysteryBoxPopup.y <= mMysteryEndY)
         {
            mDailyRewardMysteryBoxPopup.y = mMysteryEndY;
            mMysterySlideTimer.removeEventListener("timer",mysterySlideTimerTick);
            mMysterySlideTimer.stop();
            mDailyRewardMysteryBoxPopup.alpha = 1;
         }
      }
      
      private function startBoxFade() : void
      {
         mMysteryFadeTimer = new Timer(16);
         mBoxAlpha = 1;
         mRewardAlpha = 0;
         mMysteryFadeTimer.addEventListener("timer",mysteryFadeTimerTick);
         mMysteryFadeTimer.start();
      }
      
      private function mysteryFadeTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         if(mBoxAlpha > 0)
         {
            mBoxAlpha = Math.max(mBoxAlpha - 0.15,0);
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               if(mBoxPicked == _loc2_)
               {
                  mBoxArray[_loc2_].alpha = mBoxAlpha;
               }
               else
               {
                  mBoxArray[_loc2_].alpha = mBoxAlpha;
                  mRewardArray[_loc2_].alpha = mRewardAlpha;
               }
               _loc2_++;
            }
         }
         else if(mRewardAlpha < 1)
         {
            mRewardAlpha = Math.min(mRewardAlpha + 0.15,1);
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               if(mBoxPicked == _loc2_)
               {
                  mBoxArray[_loc2_].alpha = mBoxAlpha;
               }
               else
               {
                  mBoxArray[_loc2_].alpha = mBoxAlpha;
                  mRewardArray[_loc2_].alpha = mRewardAlpha;
               }
               _loc2_++;
            }
         }
         else
         {
            mMysteryFadeTimer.removeEventListener("timer",mysteryFadeTimerTick);
            mMysteryFadeTimer.stop();
            mBoxArray[0].visible = false;
            mBoxArray[1].visible = false;
            mBoxArray[2].visible = false;
            startTimer(mTimeToNext);
         }
      }
      
      private function dailyRewardPopupLoaded(param1:SwfAsset) : void
      {
         var popupGoldClass:Class;
         var popupMysteryBoxClass:Class;
         var slotMovieClass:Class;
         var swfAsset:SwfAsset = param1;
         if(mDBFacade == null)
         {
            return;
         }
         popupGoldClass = swfAsset.getClass("UI_daily_rewards");
         popupMysteryBoxClass = swfAsset.getClass("UI_daily_rewards_mysterybox");
         slotMovieClass = swfAsset.getClass("reveal_storageBox_slotMachine");
         mDailyRewardGoldPopup = new popupGoldClass();
         mDailyRewardMysteryBoxPopup = new popupMysteryBoxClass();
         mSlotMovie = new slotMovieClass();
         mCrewBonusController = new MovieClipRenderController(mDBFacade,mDailyRewardGoldPopup.crewBonus_anim);
         mCrewBonusController.loop = false;
         mCrewBonusController.stop();
         mDailyRewardGoldPopup.crewBonus_anim.visible = false;
         mDailyRewardGoldPopup.title_label.text = Locale.getString("DAILY_REWARDS_POPUP_TITLE");
         mDailyRewardGoldPopup.label_message1.text = Locale.getString("DAILY_REWARDS_WELCOME");
         mDailyRewardGoldPopup.checkbox01.label_day.text = Locale.getString("DAILY_REWARDS_DAY1");
         mDailyRewardGoldPopup.checkbox02.label_day.text = Locale.getString("DAILY_REWARDS_DAY2");
         mDailyRewardGoldPopup.checkbox03.label_day.text = Locale.getString("DAILY_REWARDS_DAY3");
         mDailyRewardGoldPopup.crewBonus_anim.crewBonus.header_crew_bonus_number.text = "";
         mDailyRewardGoldPopup.crewBonus_anim.crewBonus.tooltip.title_label.text = Locale.getString("TEAM_BONUS_TOOLTIP_TITLE");
         mDailyRewardGoldPopup.crewBonus_anim.crewBonus.tooltip.description_label.text = Locale.getString("TEAM_BONUS_TOOLTIP_DESCRIPTION");
         mDailyRewardGoldPopup.inv_empty_slot01.coin.visible = false;
         mDailyRewardGoldPopup.inv_empty_slot02.coin.visible = false;
         mDailyRewardGoldPopup.inv_empty_slot03.coin.visible = false;
         mDailyRewardGoldPopup.checkbox01.selected.visible = false;
         mDailyRewardGoldPopup.checkbox02.selected.visible = false;
         mDailyRewardGoldPopup.checkbox03.selected.visible = false;
         mDailyRewardGoldPopup.label_number01.visible = false;
         mDailyRewardGoldPopup.label_number02.visible = false;
         mDailyRewardGoldPopup.label_number03.visible = false;
         mDailyRewardGoldPopup.label_number.visible = false;
         mDailyRewardMysteryBoxPopup.x = 392;
         mDailyRewardMysteryBoxPopup.y = mDailyRewardGoldPopup.height + 26;
         mDailyRewardMysteryBoxPopup.button_accept.label.text = Locale.getString("DAILY_REWARDS_ACCEPT");
         mDailyRewardMysteryBoxPopup.button_replay.label.text = Locale.getString("DAILY_REWARDS_REPLAY");
         mDailyRewardMysteryBoxPopup.label_message2.text = Locale.getString("DAILY_REWARDS_SELECT");
         mDailyRewardMysteryBoxPopup.label_message3.text = Locale.getString("DAILY_REWARDS_COMEBACK");
         mDailyRewardGoldPopup.crewBonus_anim.crewBonus.plus.text = Locale.getString("DAILY_REWARDS_WITH");
         mDailyRewardGoldPopup.label_dailybonus.text = Locale.getString("DAILY_REWARDS_BONUS");
         mAcceptButton = new UIButton(mDBFacade,mDailyRewardMysteryBoxPopup.button_accept);
         mReplayButton = new UIButton(mDBFacade,mDailyRewardMysteryBoxPopup.button_replay);
         mDailyRewardMysteryBoxPopup.button_replay.l_numberabel.text = "";
         mExitButton = new UIButton(mDBFacade,mDailyRewardGoldPopup.close);
         mExitButton.releaseCallback = function():void
         {
            exitButtonPushed();
         };
         mCrewButton = new UIButton(mDBFacade,mDailyRewardGoldPopup.crewBonus_anim.crewBonus);
         mSlotMovieController = new MovieClipRenderController(mDBFacade,mSlotMovie);
         mAcceptButton.visible = false;
         mReplayButton.visible = false;
         mPaytoReplay = false;
         stopTimer();
         askAboutDailyReward();
         mDailyRewardGoldPopup.arrow01.visible = false;
         mDailyRewardGoldPopup.arrow02.visible = false;
      }
      
      private function mouseOverCrewListener(param1:Event) : void
      {
         mDailyRewardGoldPopup.crewBonus_anim.crewBonus.tooltip.visible = true;
      }
      
      private function mouseOutCrewListener(param1:Event) : void
      {
         mDailyRewardGoldPopup.crewBonus_anim.crewBonus.tooltip.visible = false;
      }
      
      private function stopTimer() : void
      {
         if(mDailyRewardMysteryBoxPopup == null)
         {
            return;
         }
         mDailyRewardMysteryBoxPopup.label_timer.visible = false;
         mDailyRewardMysteryBoxPopup.label_remaining.visible = false;
         mDailyRewardMysteryBoxPopup.label_message3.visible = false;
         mDailyRewardMysteryBoxPopup.timer_clock.visible = false;
         if(mCountdownTimer != null)
         {
            mCountdownTimer.removeEventListener("timer",timerTick);
            mCountdownTimer.stop();
            mCountdownTimer = null;
         }
      }
      
      private function getNextDay() : Date
      {
         var _loc1_:Date = GameClock.getWebServerDate();
         _loc1_.setTime(_loc1_.getTime() + 86400000 - (_loc1_.seconds * 1000 + _loc1_.minutes * 60000 + _loc1_.hours * 3600000));
         return _loc1_;
      }
      
      private function startTimer(param1:int) : void
      {
         var now:Date;
         var secondsToGo:int = param1;
         if(mCountdownTimer != null)
         {
            return;
         }
         mDailyRewardMysteryBoxPopup.label_timer.visible = true;
         mDailyRewardMysteryBoxPopup.label_remaining.visible = true;
         mDailyRewardMysteryBoxPopup.label_message3.visible = true;
         mDailyRewardMysteryBoxPopup.timer_clock.visible = true;
         now = GameClock.getWebServerDate();
         mTimerTargetDate = GameClock.getWebServerDate();
         mTimerTargetDate.setTime(mTimerTargetDate.getTime() + 1000 * secondsToGo);
         mDailyRewardMysteryBoxPopup.label_timer.text = "";
         mCountdownTimer = new Timer(1000);
         mCountdownTimer.addEventListener("timer",timerTick);
         mCountdownTimer.start();
         mAcceptButton.visible = true;
         mReplayButton.visible = true;
         mBoxButton0.enabled = false;
         mBoxButton1.enabled = false;
         mBoxButton2.enabled = false;
         mAcceptButton.releaseCallback = function():void
         {
            destroy();
         };
         mReplayButton.releaseCallback = function():void
         {
            playAgain();
         };
      }
      
      private function playAgain() : void
      {
         var _loc1_:UICashPage = null;
         if(mDBFacade.dbAccountInfo.premiumCurrency < mCostPlay)
         {
            mDBFacade.metrics.log("ShopCashPagePresented");
            _loc1_ = new UICashPage(mDBFacade,null,null);
         }
         else
         {
            mDBFacade.metrics.log("DailyRewardsHitReplay");
            resetMysteryBox(true);
         }
      }
      
      private function timerTick(param1:TimerEvent) : void
      {
         var _loc6_:Date = GameClock.getWebServerDate();
         var _loc7_:Date = new Date();
         var _loc2_:Date = new Date();
         _loc2_.setTime(3600000 * 8);
         _loc7_.setTime(_loc2_.getTime() + mTimerTargetDate.getTime() - _loc6_.getTime());
         var _loc3_:int = mTimerTargetDate.seconds - _loc6_.seconds;
         var _loc5_:int = mTimerTargetDate.minutes - _loc6_.minutes;
         var _loc4_:int = mTimerTargetDate.hours - _loc6_.hours;
         mDailyRewardMysteryBoxPopup.label_timer.text = _loc7_.hours.toString() + ":" + zeroPad(_loc7_.minutes,2) + ":" + zeroPad(_loc7_.seconds,2);
         if(mTimerTargetDate.getTime() <= _loc6_.getTime())
         {
            resetMysteryBox();
            askAboutDailyReward();
         }
      }
      
      public function zeroPad(param1:int, param2:int) : String
      {
         var _loc3_:String = "" + param1;
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
      
      public function resetMysteryBox(param1:Boolean = false) : void
      {
         stopTimer();
         mAcceptButton.visible = false;
         mReplayButton.visible = false;
         mPaytoReplay = param1;
         mBoxButton0.enabled = true;
         mBoxButton1.enabled = true;
         mBoxButton2.enabled = true;
         if(mRewardIcon0 != null)
         {
            mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box01.removeChild(mRewardIcon0);
            mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box02.removeChild(mRewardIcon1);
            mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box03.removeChild(mRewardIcon2);
         }
         mBox0.visible = true;
         mBox0.alpha = 1;
         mBoxButton0.root.filters = null;
         mBox1.visible = true;
         mBox1.alpha = 1;
         mBoxButton1.root.filters = null;
         mBox2.visible = true;
         mBox2.alpha = 1;
         mBoxButton2.root.filters = null;
         mDailyRewardMysteryBoxPopup.label_message3.visible = false;
         mDailyRewardMysteryBoxPopup.timer_clock.visible = false;
         mDailyRewardMysteryBoxPopup.label_message2.text = Locale.getString("DAILY_REWARDS_SELECT");
         mRewardIcon0 = null;
         mRewardIcon1 = null;
         mRewardIcon2 = null;
      }
      
      private function exitButtonPushed() : void
      {
         mDBFacade.metrics.log("DailyRewardCancel");
         if(mCountdownTimer == null)
         {
            mDBFacade.metrics.log("DailyRewardsExitedWithoutRedeeming");
         }
         destroy();
      }
      
      override public function destroy() : void
      {
         stopTimer();
         if(mMysterySlideTimer)
         {
            mMysterySlideTimer.stop();
         }
         if(mCountdownTimer)
         {
            mCountdownTimer.stop();
         }
         if(mGoldSlideTimer)
         {
            mGoldSlideTimer.stop();
         }
         if(mGoldCountTimer)
         {
            mGoldCountTimer.stop();
         }
         if(mGoldDarkTimer)
         {
            mGoldDarkTimer.stop();
         }
         if(mMysteryFadeTimer)
         {
            mMysteryFadeTimer.stop();
         }
         if(mWindowGoldDisplayed == true)
         {
            if(mRoot && mDailyRewardGoldPopup)
            {
               mRoot.removeChild(mDailyRewardGoldPopup);
            }
         }
         if(mWindowMysteryDisplayed == true)
         {
            if(mRoot && mDailyRewardMysteryBoxPopup)
            {
               mRoot.removeChild(mDailyRewardMysteryBoxPopup);
            }
         }
         mDailyRewardGoldPopup = null;
         mDailyRewardMysteryBoxPopup = null;
         mTownRoot = null;
         if(mCloseButton)
         {
            mCloseButton.destroy();
         }
         mCloseButton = null;
         if(mCloseCallback != null)
         {
            mCloseCallback();
         }
         mCloseCallback = null;
         mDBFacade.mInDailyReward = false;
         super.destroy();
         mDBFacade = null;
      }
      
      public function askAboutDailyReward() : void
      {
         var requestFunc:Function = JSONRPCService.getFunction("AskAboutDailyReward",mDBFacade.rpcRoot + "store");
         requestFunc(mDBFacade.dbAccountInfo.id,mDBFacade.validationToken,mDBFacade.demographics,function(param1:Array):void
         {
            mRewardInfo = param1;
            if(mRewardInfo[3] > 0 && mForceOpen == false)
            {
               Logger.info("UIDailyRewards: Already Redeemed Closings Daily Reward Info: " + param1);
               destroy();
            }
            else
            {
               Logger.info("UIDailyRewards: success - got Daily Reward Info: " + param1);
               mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/Icons/Items/db_icons_items.swf"),coinsLoaded);
            }
         },function(param1:Error):void
         {
            Logger.info("UIDailyRewards: asking about daily rewards: ERROR:" + param1.toString());
         });
      }
      
      private function coinsLoaded(param1:SwfAsset) : void
      {
         var mysteryBoxClass:Class;
         var smallCoinClass:Class;
         var mediumCoinClass:Class;
         var largeCoinClass:Class;
         var swfAsset:SwfAsset = param1;
         if(mDBFacade == null)
         {
            return;
         }
         mysteryBoxClass = swfAsset.getClass("db_items_box_mystery");
         mBox0 = new mysteryBoxClass();
         mBox1 = new mysteryBoxClass();
         mBox2 = new mysteryBoxClass();
         mBoxButton0 = new UIButton(mDBFacade,mBox0);
         mBoxButton1 = new UIButton(mDBFacade,mBox1);
         mBoxButton2 = new UIButton(mDBFacade,mBox2);
         mBoxButton0.releaseCallback = function():void
         {
            requestDailyRewards(0);
         };
         mBoxButton1.releaseCallback = function():void
         {
            requestDailyRewards(1);
         };
         mBoxButton2.releaseCallback = function():void
         {
            requestDailyRewards(2);
         };
         mBoxButton0.rollOverCallback = function():void
         {
            hilightButton(mBoxButton0);
         };
         mBoxButton1.rollOverCallback = function():void
         {
            hilightButton(mBoxButton1);
         };
         mBoxButton2.rollOverCallback = function():void
         {
            hilightButton(mBoxButton2);
         };
         mBoxButton0.rollOutCallback = function():void
         {
            unhilightButton(mBoxButton0);
         };
         mBoxButton1.rollOutCallback = function():void
         {
            unhilightButton(mBoxButton1);
         };
         mBoxButton2.rollOutCallback = function():void
         {
            unhilightButton(mBoxButton2);
         };
         mBoxButton0.enabled = true;
         mBoxButton1.enabled = true;
         mBoxButton2.enabled = true;
         mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box01.storage_box.visible = false;
         mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box02.storage_box.visible = false;
         mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box03.storage_box.visible = false;
         mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box01.addChild(mBox0);
         mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box02.addChild(mBox1);
         mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box03.addChild(mBox2);
         mBoxArray = new Array(mBox0,mBox1,mBox2);
         smallCoinClass = swfAsset.getClass("db_items_coins_small");
         mediumCoinClass = swfAsset.getClass("db_items_coins_medium_static");
         largeCoinClass = swfAsset.getClass("db_items_coins_large_static");
         if(mRewardInfo[0] == 1)
         {
            smallCoinClass = swfAsset.getClass("db_items_coins_small_anim");
         }
         else if(mRewardInfo[0] == 2)
         {
            mediumCoinClass = swfAsset.getClass("db_items_coins_medium");
         }
         else if(mRewardInfo[0] == 3)
         {
            largeCoinClass = swfAsset.getClass("db_items_coins_large");
         }
         setRewardAmounts(mRewardInfo[0],mRewardInfo[1],mRewardInfo[2],mRewardInfo[3],mRewardInfo[4],smallCoinClass,mediumCoinClass,largeCoinClass);
      }
      
      private function hilightButton(param1:UIButton) : void
      {
         var _loc2_:GlowFilter = new GlowFilter(16763972,1,7,7,3,1,false,false);
         _loc2_.quality = 2;
         param1.root.filters = [_loc2_];
      }
      
      private function unhilightButton(param1:UIButton) : void
      {
         var _loc2_:GlowFilter = new GlowFilter(0,0,5,5,1,1,false,false);
         _loc2_.quality = 2;
         param1.root.filters = null;
      }
      
      private function setRewardAmounts(param1:int, param2:int, param3:Array, param4:int, param5:int, param6:Class, param7:Class, param8:Class) : void
      {
         var _loc9_:Array = null;
         displayWindow();
         mDailyRewardGoldPopup.label_number01.visible = true;
         mDailyRewardGoldPopup.label_number02.visible = true;
         mDailyRewardGoldPopup.label_number03.visible = true;
         mDailyRewardGoldPopup.label_number.visible = true;
         mDailyRewardGoldPopup.label_number01.text = param3[0];
         mDailyRewardGoldPopup.label_number02.text = param3[1];
         mDailyRewardGoldPopup.label_number03.text = param3[2];
         mCostPlay = param5;
         mDailyRewardMysteryBoxPopup.button_replay.l_numberabel.text = param5;
         if(param4 > 0 && 1)
         {
            mSkipGoldCount = true;
            mDailyRewardGoldPopup.label_number.text = param3[param1 - 1] * param2;
            mDailyRewardGoldPopup.crewBonus_anim.crewBonus.header_crew_bonus_number.text = (param2 - 1).toString();
         }
         else
         {
            mDailyRewardGoldPopup.label_number.text = 0;
            mDailyRewardGoldPopup.crewBonus_anim.crewBonus.header_crew_bonus_number.text = 0;
         }
         mDailyRewardGoldPopup.crewBonus_anim.visible = true;
         mCrewBonusController.play();
         var _loc14_:MovieClip = new param6();
         var _loc15_:MovieClip = new param7();
         var _loc16_:MovieClip = new param8();
         var _loc12_:MovieClipRenderController = new MovieClipRenderController(mDBFacade,_loc14_);
         var _loc10_:MovieClipRenderController = new MovieClipRenderController(mDBFacade,_loc15_);
         var _loc11_:MovieClipRenderController = new MovieClipRenderController(mDBFacade,_loc16_);
         _loc12_.loop = true;
         _loc10_.loop = true;
         _loc11_.loop = true;
         _loc12_.play(0,true);
         _loc10_.play(0,true);
         _loc11_.play(0,true);
         var _loc13_:GlowFilter = new GlowFilter(16777215,1,25,25,1,1,false,false);
         _loc13_.quality = 2;
         mDailyRewardGoldPopup.inv_empty_slot01.addChild(_loc14_);
         mDailyRewardGoldPopup.inv_empty_slot02.addChild(_loc15_);
         mDailyRewardGoldPopup.inv_empty_slot03.addChild(_loc16_);
         if(param1 == 1)
         {
            mDailyRewardGoldPopup.checkbox01.selected.visible = true;
            mDailyRewardGoldPopup.inv_empty_slot01.filters = [_loc13_];
            _loc15_.scaleX = 0.75;
            _loc15_.scaleY = 0.75;
            _loc16_.scaleX = 0.75;
            _loc16_.scaleY = 0.75;
         }
         else if(param1 == 2)
         {
            mDailyRewardGoldPopup.checkbox01.selected.visible = true;
            mDailyRewardGoldPopup.checkbox02.selected.visible = true;
            mDailyRewardGoldPopup.arrow01.visible = true;
            mDailyRewardGoldPopup.inv_empty_slot02.filters = [_loc13_];
            _loc14_.scaleX = 0.75;
            _loc14_.scaleY = 0.75;
            _loc16_.scaleX = 0.75;
            _loc16_.scaleY = 0.75;
         }
         else if(param1 == 3)
         {
            mDailyRewardGoldPopup.checkbox01.selected.visible = true;
            mDailyRewardGoldPopup.checkbox02.selected.visible = true;
            mDailyRewardGoldPopup.checkbox03.selected.visible = true;
            mDailyRewardGoldPopup.arrow01.visible = true;
            mDailyRewardGoldPopup.arrow02.visible = true;
            mDailyRewardGoldPopup.inv_empty_slot03.filters = [_loc13_];
            _loc14_.scaleX = 0.75;
            _loc14_.scaleY = 0.75;
            _loc15_.scaleX = 0.75;
            _loc15_.scaleY = 0.75;
         }
         if(param4 > 0)
         {
            _loc9_ = new Array(0,0,0);
            displayRewards(0,_loc9_,param4,false);
         }
      }
      
      private function requestDailyRewards(param1:int) : void
      {
         var requestFunc:Function;
         var boxPicked:int = param1;
         mBoxButton0.enabled = false;
         mBoxButton1.enabled = false;
         mBoxButton2.enabled = false;
         requestFunc = JSONRPCService.getFunction("RequestRedeemDailyRewards",mDBFacade.rpcRoot + "store");
         requestFunc(mDBFacade.dbAccountInfo.id,mDBFacade.validationToken,boxPicked,mPaytoReplay,mDBFacade.demographics,function(param1:Array):void
         {
            var _loc2_:Array = null;
            Logger.info("UIDailyRewards: success - Redeemed Daily Reward: " + param1 + " Picked:" + boxPicked);
            if(param1[0] == 0 && param1[1] == 0)
            {
               _loc2_ = new Array(0,0,0);
               displayRewards(boxPicked,_loc2_,param1[2],false);
            }
            else
            {
               displayRewards(boxPicked,param1[0],param1[2],param1[3]);
               mDBFacade.dbAccountInfo.parseResponse(param1[1]);
            }
         },function(param1:Error):void
         {
            Logger.info("UIDailyRewards: Redeemed daily rewards: ERROR:" + param1.toString());
         });
         mPaytoReplay = false;
      }
      
      private function displayRewards(param1:int, param2:Array, param3:int, param4:Boolean) : void
      {
         var offer0:GMOffer;
         var offer1:GMOffer;
         var offer2:GMOffer;
         var boxPicked:int = param1;
         var rewards:Array = param2;
         var timeToNext:int = param3;
         var gotRefund:Boolean = param4;
         if(mDBFacade == null)
         {
            return;
         }
         mBoxPicked = boxPicked;
         mGotRefund = gotRefund;
         mDisplayOffers = new Vector.<GMOffer>();
         if(rewards[0] == 0)
         {
            mDailyRewardMysteryBoxPopup.label_message2.text = Locale.getString("DAILY_REWARDS_ALREADY");
            mDailyRewardGoldPopup.label_message1.text = Locale.getString("DAILY_REWARDS_ALREADY_GOLD");
            startTimer(timeToNext);
            return;
         }
         while(rewards.length > 0)
         {
            mDisplayOffers.push(mDBFacade.gameMaster.offerById.itemFor(rewards.pop()));
         }
         mDisplayOffers.reverse();
         if(mDisplayOffers.length == 3)
         {
            mSlotMovieController.loop = false;
            mSlotMovie.play();
            mSlotMovieController.playRate = 2.65;
            mSlotMovieController.play(0);
            mSlotMovie.visible = true;
            if(mSoundBox != null)
            {
               mSoundComponent.playSfxOneShot(mSoundBox);
            }
            offer0 = mDisplayOffers[0];
            offer1 = mDisplayOffers[1];
            offer2 = mDisplayOffers[2];
            if(offer0.BundleSwfFilepath != "" && offer0.BundleIcon != "")
            {
               mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(offer0.BundleSwfFilepath),function(param1:SwfAsset):void
               {
                  var rewardController0:MovieClipRenderController;
                  var swfAsset:SwfAsset = param1;
                  var rewardIconClass0:Class = swfAsset.getClass(offer0.BundleIcon);
                  mRewardIcon0 = new rewardIconClass0();
                  mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box01.addChild(mRewardIcon0);
                  rewardController0 = new MovieClipRenderController(mDBFacade,mRewardIcon0);
                  rewardController0.play(0,true);
                  if(boxPicked == 0)
                  {
                     mBox0.visible = false;
                     mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box01.addChild(mSlotMovie);
                     mSlotMovieController.finishedCallback = function():void
                     {
                        finalRewardReveal(0,timeToNext);
                     };
                     mRewardName = offer0.BundleName;
                     mRewardIcon0.visible = false;
                  }
                  else
                  {
                     mRewardIcon0.alpha = 0;
                  }
               });
            }
            if(offer1.BundleSwfFilepath != "" && offer1.BundleIcon != "")
            {
               mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(offer1.BundleSwfFilepath),function(param1:SwfAsset):void
               {
                  var rewardController1:MovieClipRenderController;
                  var swfAsset:SwfAsset = param1;
                  var rewardIconClass1:Class = swfAsset.getClass(offer1.BundleIcon);
                  mRewardIcon1 = new rewardIconClass1();
                  mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box02.addChild(mRewardIcon1);
                  rewardController1 = new MovieClipRenderController(mDBFacade,mRewardIcon1);
                  rewardController1.play(0,true);
                  if(boxPicked == 1)
                  {
                     mBox1.visible = false;
                     mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box02.addChild(mSlotMovie);
                     mSlotMovieController.finishedCallback = function():void
                     {
                        finalRewardReveal(1,timeToNext);
                     };
                     mRewardName = offer1.BundleName;
                     mRewardIcon1.visible = false;
                  }
                  else
                  {
                     mRewardIcon1.alpha = 0;
                  }
               });
            }
            if(offer2.BundleSwfFilepath != "" && offer2.BundleIcon != "")
            {
               mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(offer2.BundleSwfFilepath),function(param1:SwfAsset):void
               {
                  var rewardController2:MovieClipRenderController;
                  var swfAsset:SwfAsset = param1;
                  var rewardIconClass2:Class = swfAsset.getClass(offer2.BundleIcon);
                  mRewardIcon2 = new rewardIconClass2();
                  mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box03.addChild(mRewardIcon2);
                  rewardController2 = new MovieClipRenderController(mDBFacade,mRewardIcon2);
                  rewardController2.play(0,true);
                  if(boxPicked == 2)
                  {
                     mBox2.visible = false;
                     mDailyRewardMysteryBoxPopup.inv_empty_slot_storage_box03.addChild(mSlotMovie);
                     mSlotMovieController.finishedCallback = function():void
                     {
                        finalRewardReveal(2,timeToNext);
                     };
                     mRewardName = offer2.BundleName;
                     mRewardIcon2.visible = false;
                  }
                  else
                  {
                     mRewardIcon2.alpha = 0;
                  }
               });
            }
            mRewardArray = new Array(mRewardIcon0,mRewardIcon1,mRewardIcon2);
         }
         mDailyRewardMysteryBoxPopup.label_message2.text = Locale.getString("DAILY_REWARDS_YOU_GOT");
      }
      
      public function desaturate(param1:DisplayObject) : void
      {
         var _loc2_:Number = 0.212671;
         var _loc5_:Number = 0.71516;
         var _loc3_:Number = 0.072169;
         var _loc6_:Number = 0.7;
         var _loc4_:Number = 0.6;
         var _loc7_:Number = 0.5;
         var _loc8_:Array = [_loc2_ * _loc6_,_loc5_ * _loc6_,_loc3_ * _loc6_,0,0,_loc2_ * _loc4_,_loc5_ * _loc4_,_loc3_ * _loc4_,0,0,_loc2_ * _loc7_,_loc5_ * _loc7_,_loc3_ * _loc7_,0,0,0,0,0,1,0];
         param1.filters = [new ColorMatrixFilter(_loc8_)];
      }
      
      private function finalRewardReveal(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            if(param1 != _loc3_)
            {
               desaturate(mRewardArray[_loc3_]);
            }
            _loc3_++;
         }
         mRewardArray[0].visible = true;
         mRewardArray[1].visible = true;
         mRewardArray[2].visible = true;
         mRewardArray[param1].visible = true;
         mSlotMovie.visible = false;
         startBoxFade();
         if(mGotRefund)
         {
            mDailyRewardMysteryBoxPopup.label_message2.text = Locale.getString("DAILY_REWARDS_YOU_GOT_REFUND") + mRewardName.toUpperCase() + Locale.getString("DAILY_REWARDS_YOU_GOT_NOCHARGE");
         }
         else
         {
            mDailyRewardMysteryBoxPopup.label_message2.text = Locale.getString("DAILY_REWARDS_YOU_GOT") + mRewardName.toUpperCase();
         }
         mTimeToNext = param2;
      }
   }
}

