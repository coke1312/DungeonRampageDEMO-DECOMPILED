package DistributedObjects
{
   import Account.AvatarInfo;
   import Account.BoosterInfo;
   import Account.ChestInfo;
   import Account.CurrencyUpdatedAccountEvent;
   import Account.DBInventoryInfo;
   import Account.KeyInfo;
   import Account.StoreServices;
   import Account.StoreServicesController;
   import Actor.ChatBalloon;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.GameObject.GameObject;
   import Brain.Logger.Logger;
   import Brain.Render.MovieClipRenderController;
   import Brain.Render.MovieClipRenderer;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.Sound.SoundAsset;
   import Brain.UI.UIButton;
   import Brain.UI.UIObject;
   import Brain.UI.UIProgressBar;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import Brain.jsonRPC.JSONRPCService;
   import DBGlobals.DBGlobal;
   import Events.ChatEvent;
   import Events.FacebookLevelUpPostEvent;
   import Events.FriendSummaryNewsFeedEvent;
   import Events.GameObjectEvent;
   import Events.PlayerExitEvent;
   import Events.PlayerIsTypingEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import FacebookAPI.DBFacebookBragFeedPost;
   import GameMasterDictionary.GMChest;
   import GameMasterDictionary.GMDoober;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMMapNode;
   import GameMasterDictionary.GMRarity;
   import GameMasterDictionary.GMSkin;
   import GameMasterDictionary.GMStackable;
   import GameMasterDictionary.GMWeaponAesthetic;
   import GameMasterDictionary.GMWeaponItem;
   import GeneratedCode.DistributedDungeonSummaryNetworkComponent;
   import GeneratedCode.DungeonReport;
   import GeneratedCode.IDistributedDungeonSummary;
   import Metrics.LifestreetTracker;
   import Metrics.PixelTracker;
   import Sound.DBSoundComponent;
   import Town.TownHeader;
   import UI.CountdownTextTimer;
   import UI.DBUIPopup;
   import UI.DBUITwoButtonPopup;
   import UI.Inventory.Chests.ChestBuyKeysPopUp;
   import UI.Inventory.Chests.ChestKeySlot;
   import UI.Inventory.Chests.ChestRevealPopUp;
   import UI.Inventory.UIInventory;
   import UI.Inventory.UIWeaponTooltip;
   import UI.UIChatLog;
   import UI.UIHud;
   import UI.UIVictoryBoosterPopup;
   import com.greensock.TweenMax;
   import com.maccherone.json.JSONParseError;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getQualifiedClassName;
   import org.as3commons.collections.Map;
   
   public class DistributedDungeonSummary extends GameObject implements IDistributedDungeonSummary
   {
      
      private static const SCORE_REPORT_PATH:String = "Resources/Art2D/UI/db_UI_score_report.swf";
      
      private static const TOWN_PATH:String = "Resources/Art2D/UI/db_UI_town.swf";
      
      private static const DOOBER_SWF_PATH:String = "Resources/Art2D/Doobers/db_items_doobers.swf";
      
      private static const ITEM_CARD_LEVEL_REQUIREMENT:String = "ITEM_CARD_LEVEL_REQUIREMENT";
      
      private static const TAKE_ALL_ID:uint = 1000;
      
      private static const DUNGEONS_COMPLETED:String = "DUNGEONS_COMPLETED";
      
      private static const REVEAL_STATE_BEGIN:uint = 1;
      
      private static const REVEAL_TROPHY_AWARD_STATE:uint = 20;
      
      private static const HIDE_TROPHY_AWARD_STATE:uint = 25;
      
      private static const MAP_NODE_DEFEATED_FEED_POST:uint = 30;
      
      private static const REVEAL_STATE_BONUS_XP:uint = 2;
      
      private static const REVEAL_STATE_BONUS_XP_TICK:uint = 3;
      
      private static const REVEAL_STATE_TEAM_BONUS_XP:uint = 4;
      
      private static const REVEAL_STATE_TEAM_BONUS_XP_TICK:uint = 5;
      
      private static const REVEAL_STATE_BOOSTER_TICK:uint = 6;
      
      private static const REVEAL_STATE_BOOSTER_BONUS_TICK:uint = 7;
      
      private static const REVEAL_STATE_KILLS:uint = 8;
      
      private static const REVEAL_STATE_KILLS_TICK:uint = 9;
      
      private static const REVEAL_STATE_TREASURE:uint = 10;
      
      private static const REVEAL_STATE_TREASURE_TICK:uint = 11;
      
      private static const REVEAL_STATE_DONE:uint = 12;
      
      private static const REVEAL_STATE_GOLD_BOOSTER_TICK:uint = 13;
      
      private static const REVEAL_STATE_GOLD_BOOSTER_BONUS_TICK:uint = 14;
      
      private static const REVEAL_TRANSITION_SPEED:Number = 0.45;
      
      private static const BONUS_TRANSITION_SPEED:Number = 0.45;
      
      private static const PRE_PLAYTEST:Boolean = false;
      
      private var mRarityMap:Map;
      
      private var mDBFacade:DBFacade;
      
      private var mDungeonReport:Vector.<DungeonReport>;
      
      private var mDungeonName:String;
      
      private var mSortedLootData:Array;
      
      private var mScoreReportRoot:MovieClip;
      
      private var mTownRoot:MovieClip;
      
      private var mUIInventory:UIInventory;
      
      private var mTownHeader:TownHeader;
      
      private var mItemCardX:Number;
      
      private var mItemCardY:Number;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mSoundComponent:DBSoundComponent;
      
      private var mEventComponent:EventComponent;
      
      private var mWorkComponent:LogicalWorkComponent;
      
      private var mBannerFadeTask:Task;
      
      private var mSurveyButton:UIButton;
      
      private var mXpBar:Array;
      
      private var mUIChatLog:UIChatLog;
      
      private var mChatEventComponent:EventComponent;
      
      private var mChatBalloon:Vector.<ChatBalloon>;
      
      private var mChatCloseTask:Vector.<Task>;
      
      private var mPlayerIsTypingNotification:MovieClip;
      
      private var mItemButtons:Array;
      
      private var mAddFriendButtons:Array;
      
      private var mBlockFriendButtons:Array;
      
      private var mSelectedItemSlot:uint;
      
      private var mSelectedGMChest:GMChest;
      
      private var mTookLastItem:Boolean;
      
      private var mItemCount:int;
      
      private var mBoosterPopup:UIVictoryBoosterPopup;
      
      private var mInfoPopup:DBUIPopup;
      
      private var mNetworkComponent:DistributedDungeonSummaryNetworkComponent;
      
      private var mXPBonusStarEffect:MovieClip;
      
      private var mXPBonusBarEffect:MovieClip;
      
      private var mXPBonusTextFlash:MovieClip;
      
      private var mXPBonusText:TextField;
      
      private var mRevealState:uint;
      
      private var mBoosterExpTick:uint;
      
      private var mBoosterGoldTick:uint;
      
      private var mBonusXPTick:Vector.<uint>;
      
      private var mTeamBonusXPTick:Vector.<uint>;
      
      private var mKillsTick:Vector.<uint>;
      
      private var mTreasureTick:uint;
      
      private var mTrophyGetMovieClipRenderer:MovieClipRenderer;
      
      private var mDungeonAchievementPanelMovieClipRenderer:MovieClipRenderer;
      
      private var mTransactionSuccessCallback:Function;
      
      private var mFacebookPicHolder:MovieClip;
      
      private var mFacebookPicMap:Map;
      
      private var mDungeonSuccess:Boolean;
      
      private var mDungeonCompleteBonusXP:uint = 0;
      
      private var mInDungeonXPEarned:uint = 0;
      
      private var mDRFriendBlockPopup:DBUITwoButtonPopup;
      
      private var mBgRenderer:MovieClipRenderController;
      
      private var mOpenKeyChestMC:MovieClip;
      
      private var mAbandonButton:UIButton;
      
      private var mKeepButton:UIButton;
      
      private var mOpenButton:UIButton;
      
      private var mChestRevealPopUp:ChestRevealPopUp;
      
      private var mChestRenderers:Vector.<MovieClipRenderer>;
      
      private var mChestKeySlots:Vector.<ChestKeySlot>;
      
      private var mOpenKeyChestRenderer:MovieClipRenderer;
      
      private var mKeyThatCanOpenChest:KeyInfo;
      
      private var mChestBuyKeysPopUp:ChestBuyKeysPopUp;
      
      private var mChestMovieClips:Array;
      
      private var mStorageFullPopUp:DBUITwoButtonPopup;
      
      private var mFromInventory:Boolean;
      
      private var mRevealedItemType:uint;
      
      private var mRevealedItemOfferId:uint;
      
      private var mRevealedItemCallEquip:Boolean;
      
      public var isSingleChestList:Vector.<Boolean>;
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mChestTransactionFailedPopup:DBUIPopup;
      
      private var mAbandonChestPopUp:DBUITwoButtonPopup;
      
      private var mCurrentMapNode:GMMapNode;
      
      private var mUILootSlotsTwoTreasures:Array;
      
      private var mUILootSlotsFourTreasures:Array;
      
      private var mUILootSlots:Array;
      
      private var mMapNodeId:uint;
      
      private var mWeapons:Array;
      
      private var mWeaponTooltips:Array;
      
      private var mSmashSfx:SoundAsset;
      
      private var mLevelSfx:SoundAsset;
      
      private var mBoosterXP:BoosterInfo;
      
      private var mBoosterGold:BoosterInfo;
      
      private var mCoinBoosterUI:UIObject;
      
      private var mXPBoosterUI:UIObject;
      
      private var mCountDownTextXP:CountdownTextTimer;
      
      private var mCountDownTextGold:CountdownTextTimer;
      
      private var mBoosterInfos:Array;
      
      private var mTeamBonusUI:Map;
      
      private var mDungeonMod1:uint;
      
      private var mDungeonMod2:uint;
      
      private var mDungeonMod3:uint;
      
      private var mDungeonMod4:uint;
      
      public function DistributedDungeonSummary(param1:DBFacade, param2:uint)
      {
         var dungeonsCompletedCount:uint;
         var k:int;
         var i:int;
         var j:int;
         var dbFacade:DBFacade = param1;
         var doid:uint = param2;
         mXpBar = [];
         Logger.warn("Start construction of DDS");
         super(dbFacade,doid);
         try
         {
            mDBFacade = dbFacade;
            mRarityMap = new Map();
            mRarityMap.add("COMMON",1);
            mRarityMap.add("UNCOMMON",4);
            mRarityMap.add("RARE",5);
            mRarityMap.add("LEGENDARY",6);
            mRarityMap.add("CONSUMABLE_SMALL",2);
            mRarityMap.add("CONSUMABLE_ROYAL",3);
            mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
            mRevealedItemType = 0;
            mRevealedItemOfferId = 0;
            mAddFriendButtons = [];
            mBlockFriendButtons = [];
            mBoosterInfos = [];
            mDBFacade.dbAccountInfo.incrementCompletedDungeons();
            dungeonsCompletedCount = mDBFacade.dbAccountInfo.getDungeonsCompleted();
            if(dungeonsCompletedCount == 1)
            {
               PixelTracker.tutorialComplete(mDBFacade);
            }
            if(mDBFacade.facebookController && dungeonsCompletedCount >= 1 && !mDBFacade.dbConfigManager.getConfigBoolean("FUFB",false))
            {
               Logger.debug("Attempting to updateGuestAchievement");
               mDBFacade.facebookController.updateGuestAchievement(1);
            }
            mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
            mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
            mSoundComponent = new DBSoundComponent(mDBFacade);
            mWorkComponent = new LogicalWorkComponent(mDBFacade);
            mEventComponent = new EventComponent(mDBFacade);
            mChatBalloon = new Vector.<ChatBalloon>(4);
            mChatCloseTask = new Vector.<Task>(4);
            mChatEventComponent = new EventComponent(dbFacade);
            mFacebookPicMap = new Map();
            isSingleChestList = new Vector.<Boolean>();
            isSingleChestList = new Vector.<Boolean>();
            k = 0;
            while(k < 4)
            {
               isSingleChestList.push(false);
               k++;
            }
            mChestRenderers = new Vector.<MovieClipRenderer>();
            mChestMovieClips = [];
            i = 0;
            while(i < 4)
            {
               mChestMovieClips.push([]);
               j = 0;
               while(j < 4)
               {
                  mChestMovieClips[i].push(new MovieClip());
                  j++;
               }
               i++;
            }
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_nametag.swf"),nametagSwfLoaded);
            mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),"HealthBomb1",function(param1:SoundAsset):void
            {
               mSmashSfx = param1;
            });
            mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),"LevelUp2",function(param1:SoundAsset):void
            {
               mLevelSfx = param1;
            });
            mTeamBonusUI = new Map();
         }
         catch(e:Error)
         {
            Logger.error("An error occurred while attempting to construct distributed dungeon summary.  Error: " + e.message);
         }
         Logger.warn("Finished construction of DDS");
      }
      
      private function nametagSwfLoaded(param1:SwfAsset) : void
      {
         var _loc2_:Class = param1.getClass("fb_avatar_holder");
         mFacebookPicHolder = new _loc2_();
         mSceneGraphComponent.addChild(mFacebookPicHolder,105);
         mFacebookPicHolder.visible = false;
      }
      
      public function setNetworkComponentDistributedDungeonSummary(param1:DistributedDungeonSummaryNetworkComponent) : void
      {
         mNetworkComponent = param1;
      }
      
      public function postGenerate() : void
      {
         mCurrentMapNode = mDBFacade.gameMaster.mapNodeById.itemFor(mMapNodeId);
         if(mCurrentMapNode == null)
         {
            Logger.error("Couldn\'t find GMMapNode for node id : " + mMapNodeId);
            return;
         }
         if(LifestreetTracker.IS_FUNCTIONAL && mCurrentMapNode.Id == LifestreetTracker.LIFESTREET_NODE_ID && !mDBFacade.dbAccountInfo.dbAccountParams.hasLifestreetParam())
         {
            PixelTracker.nodeCompleted(mDBFacade);
         }
         PixelTracker.nodeIndexCompleted(mDBFacade,mCurrentMapNode.BitIndex);
         mDungeonName = mCurrentMapNode.Name.toUpperCase();
         if(this.dungeonSuccess)
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_score_report.swf"),successScoreReportSwfLoaded);
         }
         else
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_score_report.swf"),failureScoreReportSwfLoaded);
         }
         mDBFacade.dbAccountInfo.dbAccountParams.flushParams();
      }
      
      private function setRevealState(param1:uint, param2:Number) : void
      {
         mRevealState = param1;
         mWorkComponent.doLater(param2,updateRevealState);
      }
      
      private function setUILootSlotsTwoTreasuresVisible(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         for each(var _loc2_ in mUILootSlotsTwoTreasures)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc2_[_loc3_].visible = param1;
               _loc3_++;
            }
         }
      }
      
      private function setUILootSlotsFourTreasuresVisible(param1:Boolean) : void
      {
         var _loc3_:int = 0;
         for each(var _loc2_ in mUILootSlotsFourTreasures)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc2_[_loc3_].visible = param1;
               _loc3_++;
            }
         }
      }
      
      private function updateRevealState(param1:GameClock) : void
      {
         var i:uint;
         var allFinished:Boolean;
         var loot:Array;
         var trophies:int;
         var trophyGetClipLength:uint;
         var bossFeedPosts:Boolean;
         var maxBonus:uint;
         var xp_bars:Array;
         var speed:Number;
         var gmHero:GMHero;
         var oldLevel:uint;
         var currentExp:uint;
         var level:uint;
         var levelIndex:uint;
         var lastLevelExp:uint;
         var max:uint;
         var animMcr:MovieClipRenderController;
         var textMcr:MovieClipRenderController;
         var teamBonusUI:UIObject;
         var maxBonusTeam:uint;
         var xp_barsTeam:Array;
         var speedTeam:Number;
         var gmHeroTeam:GMHero;
         var oldLevelTeam:uint;
         var currentExpTeam:uint;
         var levelTeam:uint;
         var levelIndexTeam:uint;
         var lastLevelExpTeam:uint;
         var maxTeam:uint;
         var teamBonusUITeam:UIObject;
         var animMcrTeam:MovieClipRenderController;
         var textMcrTeam:MovieClipRenderController;
         var maxKills:uint;
         var slot:uint;
         var localLoot:Array;
         var weapon_clip:MovieClip;
         var global_position:Point;
         var position:Vector3D;
         var totalXP:int;
         var local_i:uint;
         var tickingFilter:Array;
         var headerTitle:String;
         var go:GameObject;
         var player:PlayerGameObject;
         var treasureClips:Array;
         var j:int;
         var clock:GameClock = param1;
         var stats:Array = [mScoreReportRoot.stats_a,mScoreReportRoot.stats_b,mScoreReportRoot.stats_c,mScoreReportRoot.stats_d];
         Logger.debug("Starting on reveal state: " + mRevealState);
         switch(mRevealState)
         {
            case 1:
               i = 0;
               while(i < stats.length)
               {
                  if(mDungeonReport[i].valid)
                  {
                     stats[i].stats.xp_bar.bonus_xp_reveal.visible = false;
                     stats[i].stats.xp_bar.bonus_xp.visible = false;
                     stats[i].stats.kills.enemies_killed.visible = false;
                     stats[i].stats.kills.enemies_killed_reveal.visible = false;
                     stats[i].stats.treasure.visible = false;
                  }
                  ++i;
               }
               if(mDBFacade.accountBonus.isXPBonusActive)
               {
                  mXPBonusStarEffect.visible = true;
                  mXPBonusBarEffect.visible = true;
                  mXPBonusTextFlash.visible = true;
                  mXPBonusText.text = mDBFacade.accountBonus.xpBonusText;
               }
               setRevealState(20,0.45);
               break;
            case 20:
               Logger.debug("Start of REVEAL_TROPHY_AWARD_STATE");
               if(!mDungeonReport[0].receivedTrophy)
               {
                  setRevealState(2,0.45);
               }
               else
               {
                  Logger.debug("REVEAL_TROPHY_AWARD_STATE: Starting to play movie clip");
                  if(!mDungeonAchievementPanelMovieClipRenderer)
                  {
                     Logger.error("In state machine REVEAL_TROPHY_AWARD_STATE: mDungeonAchievementPanelMovieClipRenderer is null");
                  }
                  if(mDungeonAchievementPanelMovieClipRenderer && !mDungeonAchievementPanelMovieClipRenderer.clip)
                  {
                     Logger.error("In state machine REVEAL_TROPHY_AWARD_STATE: mDungeonAchievementPanelMovieClipRenderer.clip is null");
                  }
                  mDungeonAchievementPanelMovieClipRenderer.clip.visible = true;
                  Logger.debug("REVEAL_TROPHY_AWARD_STATE: after mDungeonAchievementPanelMovieClipRenderer.clip.visible = true");
                  mScoreReportRoot.stats_a.stats.trophies.filters = [new GlowFilter(16633879,1,8,8,10)];
                  trophies = int(mScoreReportRoot.stats_a.stats.trophies.trophies.text);
                  trophies++;
                  mScoreReportRoot.stats_a.stats.trophies.trophies.text = trophies.toString();
                  trophyGetClipLength = 4;
                  mDungeonAchievementPanelMovieClipRenderer.play();
                  Logger.debug("REVEAL_TROPHY_AWARD_STATE: after mDungeonAchievementPanelMovieClipRenderer.play");
                  if(mSmashSfx)
                  {
                     mSoundComponent.playSfxOneShot(mSmashSfx);
                  }
                  mLogicalWorkComponent.doLater(1.5833333333333333,function(param1:GameClock):void
                  {
                     if(mSmashSfx)
                     {
                        mSoundComponent.playSfxOneShot(mSmashSfx);
                     }
                  });
                  Logger.debug("REVEAL_TROPHY_AWARD_STATE: Before setRevealState");
                  setRevealState(25,trophyGetClipLength);
               }
               Logger.debug("End of REVEAL_TROPHY_AWARD_STATE");
               break;
            case 25:
               Logger.debug("Start of HIDE_TROPHY_AWARD_STATE");
               mDungeonAchievementPanelMovieClipRenderer.stop();
               mDungeonAchievementPanelMovieClipRenderer.clip.visible = false;
               setRevealState(30,0.45);
               Logger.debug("End of HIDE_TROPHY_AWARD_STATE");
               break;
            case 30:
               Logger.debug("Start of MAP_NODE_DEFEATED_FEED_POST");
               bossFeedPosts = mDBFacade.dbConfigManager.getConfigBoolean("boss_feed_posts",true);
               if(bossFeedPosts && mDungeonReport[0].receivedTrophy && mCurrentMapNode.Constant != "TUTORIAL")
               {
                  DBFacebookBragFeedPost.defeatMapNodeBrag(mDBFacade,mCurrentMapNode,mAssetLoadingComponent);
               }
               setRevealState(2,0.45);
               Logger.debug("End of MAP_NODE_DEFEATED_FEED_POST");
               break;
            case 2:
               if(mTrophyGetMovieClipRenderer != null)
               {
                  mTrophyGetMovieClipRenderer.clip.visible = false;
               }
               i = 0;
               while(i < stats.length)
               {
                  if(mDungeonReport[i].valid)
                  {
                     stats[i].stats.xp_bar.bonus_xp_reveal.visible = false;
                     stats[i].stats.xp_bar.bonus_xp.visible = false;
                  }
                  ++i;
               }
               setRevealState(3,0.45);
               break;
            case 3:
               allFinished = true;
               maxBonus = 0;
               xp_bars = [mScoreReportRoot.stats_a.stats.xp_bar.UI_XP,mScoreReportRoot.stats_b.stats.xp_bar.UI_XP,mScoreReportRoot.stats_c.stats.xp_bar.UI_XP,mScoreReportRoot.stats_d.stats.xp_bar.UI_XP];
               i = 0;
               while(i < stats.length)
               {
                  if(mDungeonReport[i].valid)
                  {
                     stats[i].stats.xp_bar.bonus_xp_reveal.visible = false;
                     stats[i].stats.xp_bar.bonus_xp.visible = true;
                     maxBonus = Math.max(maxBonus,mDungeonReport[i].xp_bonus);
                     speed = (maxBonus - mBonusXPTick[i]) / 10;
                     if(speed < 1 && maxBonus > mBonusXPTick[i])
                     {
                        speed = 1;
                     }
                     if(mBonusXPTick[i] < mDungeonReport[i].xp_bonus)
                     {
                        gmHero = mDBFacade.gameMaster.heroById.itemFor(mDungeonReport[i].type);
                        oldLevel = gmHero.getLevelFromExp(mDungeonReport[i].xp + mBonusXPTick[i]);
                        allFinished = false;
                        mBonusXPTick[i] += speed;
                        currentExp = mDungeonReport[i].xp + mBonusXPTick[i];
                        level = gmHero.getLevelFromExp(currentExp);
                        levelIndex = uint(gmHero.getLevelIndex(currentExp));
                        lastLevelExp = uint(levelIndex > 0 ? gmHero.getExpFromIndex(levelIndex - 1) : 0);
                        max = gmHero.getExpFromIndex(levelIndex);
                        mXpBar[i].value = (currentExp - lastLevelExp) / (max - lastLevelExp);
                        xp_bars[i].xp_level.text = level.toString();
                        stats[i].stats.xp_bar.bonus_xp.xp.text = mBonusXPTick[i].toString();
                        stats[i].stats.xp_bar.UI_XP.xp_points.text = currentExp.toString();
                        stats[i].stats.xp_bar.UI_XP.xp_level.text = level.toString();
                        if(oldLevel != level)
                        {
                           stats[i].stats.fx_level_up_text.visible = true;
                           stats[i].stats.fx_level_up_anim.visible = true;
                           animMcr = new MovieClipRenderController(mDBFacade,stats[i].stats.fx_level_up_anim);
                           animMcr.play(0,false,function():void
                           {
                              animMcr.destroy();
                           });
                           textMcr = new MovieClipRenderController(mDBFacade,stats[i].stats.fx_level_up_text);
                           textMcr.play(0,false,function():void
                           {
                              textMcr.destroy();
                           });
                           if(mLevelSfx)
                           {
                              mSoundComponent.playSfxOneShot(mLevelSfx);
                           }
                           if(i == 0)
                           {
                              mEventComponent.dispatchEvent(new FacebookLevelUpPostEvent("FacebookLevelUpPostEvent",level));
                           }
                        }
                     }
                  }
                  ++i;
               }
               if(allFinished)
               {
                  mDungeonCompleteBonusXP = mDungeonReport[0].xp_bonus;
                  mInDungeonXPEarned = mDungeonReport[0].xp_earned;
                  setRevealState(4,0.45);
               }
               else
               {
                  setRevealState(3,0.45 / maxBonus);
               }
               break;
            case 4:
               i = 0;
               while(i < stats.length)
               {
                  if(mDungeonReport[i].valid)
                  {
                     teamBonusUI = mTeamBonusUI.itemFor(i);
                     teamBonusUI.visible = true;
                  }
                  ++i;
               }
               setRevealState(5,0.45);
               break;
            case 5:
               allFinished = true;
               maxBonusTeam = 0;
               xp_barsTeam = [mScoreReportRoot.stats_a.stats.xp_bar.UI_XP,mScoreReportRoot.stats_b.stats.xp_bar.UI_XP,mScoreReportRoot.stats_c.stats.xp_bar.UI_XP,mScoreReportRoot.stats_d.stats.xp_bar.UI_XP];
               i = 0;
               while(i < stats.length)
               {
                  if(mDungeonReport[i].valid)
                  {
                     maxBonusTeam = Math.max(maxBonusTeam,mDungeonReport[i].team_xp_bonus);
                     speedTeam = (maxBonusTeam - mTeamBonusXPTick[i]) / 10;
                     if(speedTeam < 1 && maxBonusTeam > mTeamBonusXPTick[i])
                     {
                        speedTeam = 1;
                     }
                     if(mTeamBonusXPTick[i] < mDungeonReport[i].team_xp_bonus)
                     {
                        gmHeroTeam = mDBFacade.gameMaster.heroById.itemFor(mDungeonReport[i].type);
                        oldLevelTeam = gmHeroTeam.getLevelFromExp(mDungeonReport[i].xp + mBonusXPTick[i]);
                        allFinished = false;
                        mTeamBonusXPTick[i] += speedTeam;
                        currentExpTeam = mDungeonReport[i].xp + mBonusXPTick[i] + mTeamBonusXPTick[i];
                        levelTeam = gmHeroTeam.getLevelFromExp(currentExpTeam);
                        levelIndexTeam = uint(gmHeroTeam.getLevelIndex(currentExpTeam));
                        lastLevelExpTeam = uint(levelIndexTeam > 0 ? gmHeroTeam.getExpFromIndex(levelIndexTeam - 1) : 0);
                        maxTeam = gmHeroTeam.getExpFromIndex(levelIndexTeam);
                        mXpBar[i].value = (currentExpTeam - lastLevelExpTeam) / (maxTeam - lastLevelExpTeam);
                        xp_barsTeam[i].xp_level.text = levelTeam.toString();
                        teamBonusUITeam = mTeamBonusUI.itemFor(i);
                        teamBonusUITeam.root.xp.text = mTeamBonusXPTick[i].toString();
                        stats[i].stats.xp_bar.UI_XP.xp_points.text = currentExpTeam.toString();
                        stats[i].stats.xp_bar.UI_XP.xp_level.text = levelTeam.toString();
                        if(oldLevelTeam != levelTeam)
                        {
                           stats[i].stats.fx_level_up_text.visible = true;
                           stats[i].stats.fx_level_up_anim.visible = true;
                           animMcrTeam = new MovieClipRenderController(mDBFacade,stats[i].stats.fx_level_up_anim);
                           animMcrTeam.play(0,false,function():void
                           {
                              animMcrTeam.destroy();
                           });
                           textMcrTeam = new MovieClipRenderController(mDBFacade,stats[i].stats.fx_level_up_text);
                           textMcrTeam.play(0,false,function():void
                           {
                              textMcrTeam.destroy();
                           });
                           if(mLevelSfx)
                           {
                              mSoundComponent.playSfxOneShot(mLevelSfx);
                           }
                           if(i == 0)
                           {
                              mEventComponent.dispatchEvent(new FacebookLevelUpPostEvent("FacebookLevelUpPostEvent",levelTeam));
                           }
                        }
                     }
                  }
                  ++i;
               }
               if(allFinished)
               {
                  mDungeonCompleteBonusXP = mDungeonReport[0].xp_bonus + mDungeonReport[0].team_xp_bonus;
                  setRevealState(8,0.45);
               }
               else
               {
                  setRevealState(5,0.45 / maxBonusTeam);
               }
               break;
            case 8:
               i = 0;
               while(i < stats.length)
               {
                  if(mDungeonReport[i].valid)
                  {
                     stats[i].stats.kills.enemies_killed_reveal.visible = false;
                  }
                  ++i;
               }
               setRevealState(9,0);
               break;
            case 9:
               allFinished = true;
               maxKills = 0;
               i = 0;
               while(i < stats.length)
               {
                  if(mDungeonReport[i].valid)
                  {
                     maxKills = Math.max(maxKills,mDungeonReport[i].kills);
                     stats[i].stats.kills.enemies_killed_reveal.visible = false;
                     stats[i].stats.kills.enemies_killed.visible = true;
                     if(mKillsTick[i] < mDungeonReport[i].kills)
                     {
                        allFinished = false;
                        ++mKillsTick[i];
                        stats[i].stats.kills.enemies_killed.kills.text = mKillsTick[i];
                     }
                  }
                  ++i;
               }
               if(allFinished)
               {
                  setRevealState(10,0.45);
               }
               else
               {
                  setRevealState(9,0.45 / maxKills);
               }
               break;
            case 10:
               i = 0;
               while(i < stats.length)
               {
                  if(mDungeonReport[i].valid)
                  {
                     stats[i].stats.treasure.visible = true;
                  }
                  ++i;
               }
               setRevealState(11,0.45);
               break;
            case 11:
               slot = mTreasureTick++;
               i = 0;
               while(i < stats.length)
               {
                  if(mDungeonReport[i].valid)
                  {
                     if(mItemCount > 2)
                     {
                        loot = mUILootSlotsFourTreasures[i];
                        setUILootSlotsTwoTreasuresVisible(false);
                     }
                     else
                     {
                        loot = mUILootSlotsTwoTreasures[i];
                        setUILootSlotsFourTreasuresVisible(false);
                     }
                     if(i == 0)
                     {
                        localLoot = loot;
                     }
                     if(loot[slot].numChildren > 2)
                     {
                        weapon_clip = loot[slot].getChildAt(2);
                        if(weapon_clip)
                        {
                           weapon_clip.visible = true;
                           global_position = weapon_clip.localToGlobal(new Point(0,0));
                           position = new Vector3D(global_position.x,global_position.y + 16);
                        }
                     }
                  }
                  ++i;
               }
               if(mTreasureTick >= 2 || localLoot[slot + 1].numChildren < 2)
               {
                  openBoosterPopup();
                  if((mBoosterPopup.expStack || mBoosterPopup.goldStack) && this.dungeonSuccess)
                  {
                     setRevealState(6,0.45);
                  }
                  else
                  {
                     closeBoosterPopup();
                     setRevealState(12,0.1);
                  }
               }
               else
               {
                  setRevealState(11,0.45);
               }
               break;
            case 6:
               if(!mBoosterPopup)
               {
                  setRevealState(12,0.1);
                  break;
               }
               if(mBoosterPopup.expStack)
               {
                  maxBonus = Math.max(mDungeonReport[0].xp_bonus + mDungeonReport[0].team_xp_bonus,mDungeonReport[0].xp_earned);
                  totalXP = int(mDungeonReport[0].xp_bonus + mDungeonReport[0].team_xp_bonus + mDungeonReport[0].xp_earned);
                  mBoosterExpTick = totalXP * mBoosterPopup.expStack.ExpMult - totalXP;
                  if(mBoosterPopup)
                  {
                     mBoosterPopup.setExp(mBoosterExpTick);
                  }
                  mDungeonReport[0].xp_bonus += mBoosterExpTick;
               }
               if(mBoosterPopup.goldStack)
               {
                  mBoosterPopup.setGold(mDungeonReport[0].gold_earned * mBoosterPopup.goldStack.GoldMult - mDungeonReport[0].gold_earned);
               }
               setRevealState(7,0.45);
               break;
            case 7:
               if(!mBoosterPopup)
               {
                  setRevealState(12,0.1);
                  break;
               }
               allFinished = true;
               maxBonus = 0;
               xp_bars = [mScoreReportRoot.stats_a.stats.xp_bar.UI_XP,mScoreReportRoot.stats_b.stats.xp_bar.UI_XP,mScoreReportRoot.stats_c.stats.xp_bar.UI_XP,mScoreReportRoot.stats_d.stats.xp_bar.UI_XP];
               local_i = 0;
               stats[local_i].stats.xp_bar.bonus_xp_reveal.visible = false;
               stats[local_i].stats.xp_bar.bonus_xp.visible = true;
               maxBonus = Math.max(maxBonus,mDungeonReport[local_i].xp_bonus + mDungeonReport[local_i].team_xp_bonus);
               if(mBonusXPTick[local_i] < mDungeonReport[local_i].xp_bonus + mDungeonReport[local_i].team_xp_bonus)
               {
                  gmHero = mDBFacade.gameMaster.heroById.itemFor(mDungeonReport[local_i].type);
                  oldLevel = gmHero.getLevelFromExp(mDungeonReport[local_i].xp + mBonusXPTick[local_i]);
                  allFinished = false;
                  ++mBonusXPTick[local_i];
                  currentExp = mDungeonReport[local_i].xp + mBonusXPTick[local_i];
                  level = gmHero.getLevelFromExp(currentExp);
                  levelIndex = uint(gmHero.getLevelIndex(currentExp));
                  lastLevelExp = uint(levelIndex > 0 ? gmHero.getExpFromIndex(levelIndex - 1) : 0);
                  max = gmHero.getExpFromIndex(levelIndex);
                  mXpBar[local_i].value = (currentExp - lastLevelExp) / (max - lastLevelExp);
                  xp_bars[local_i].xp_level.text = level.toString();
                  stats[local_i].stats.xp_bar.bonus_xp.xp.text = mBonusXPTick[local_i].toString();
                  stats[local_i].stats.xp_bar.UI_XP.xp_points.text = currentExp.toString();
                  stats[local_i].stats.xp_bar.UI_XP.xp_level.text = level.toString();
                  if(oldLevel != level)
                  {
                     stats[local_i].stats.fx_level_up_text.visible = true;
                     stats[local_i].stats.fx_level_up_anim.visible = true;
                     animMcr = new MovieClipRenderController(mDBFacade,stats[local_i].stats.fx_level_up_anim);
                     animMcr.play(0,false,function():void
                     {
                        animMcr.destroy();
                     });
                     textMcr = new MovieClipRenderController(mDBFacade,stats[local_i].stats.fx_level_up_text);
                     textMcr.play(0,false,function():void
                     {
                        textMcr.destroy();
                     });
                     if(i == 0)
                     {
                        mEventComponent.dispatchEvent(new FacebookLevelUpPostEvent("FacebookLevelUpPostEvent",level));
                     }
                  }
               }
               if(allFinished)
               {
                  setRevealState(12,0.1);
                  applyGlowFilter(stats[0].stats.xp_bar.bonus_xp);
               }
               else
               {
                  tickingFilter = [];
                  tickingFilter.push(new GlowFilter(16777215,1,12,12,6));
                  stats[0].stats.xp_bar.bonus_xp.filters = tickingFilter;
                  stats[0].stats.xp_bar.bonus_xp.scaleX = 1.1;
                  stats[0].stats.xp_bar.bonus_xp.scaleY = 1.1;
                  setRevealState(7,0.45 / maxBonus);
               }
               break;
            case 12:
               fadeAwayTitle();
               mEventComponent.dispatchEvent(new Event("TIME_TO_SHARE_LEVEL_UP_EVENT"));
               mTownHeader = new TownHeader(mDBFacade,closeHeader);
               mTownHeader.animateHeader();
               if(mCurrentMapNode.InfiniteDungeon != null)
               {
                  headerTitle = Locale.getString("INFINITE_SUMMARY_HEADER_TITLE");
               }
               else
               {
                  headerTitle = this.dungeonSuccess ? Locale.getString("VICTORY") : Locale.getString("DUNGEON_FAILED");
               }
               mTownHeader.title = headerTitle;
               mTownHeader.showCloseButton(true);
               go = mFacade.gameObjectManager.getReferenceFromId(mDungeonReport[0].id);
               player = go as PlayerGameObject;
               mEventComponent.dispatchEvent(new CurrencyUpdatedAccountEvent(player.basicCurrency,mDBFacade.dbAccountInfo.premiumCurrency));
               if(mItemCount > 0 && mDungeonSuccess)
               {
                  loot = mUILootSlots;
                  treasureClips = [mScoreReportRoot.stats_a.stats.treasure,mScoreReportRoot.stats_b.stats.treasure,mScoreReportRoot.stats_c.stats.treasure,mScoreReportRoot.stats_d.stats.treasure];
                  i = 0;
                  while(i < 4)
                  {
                     if(isSingleChestList[i])
                     {
                        if(mChestMovieClips[i][2] != null && loot[i][2] != null)
                        {
                           treasureClips[i].addChild(mChestMovieClips[i][2]);
                           if(mDungeonReport[i].chest_type_1)
                           {
                              loot[i][2].visible = false;
                           }
                        }
                     }
                     else
                     {
                        j = 0;
                        while(j < 4)
                        {
                           if(mChestMovieClips[i][j] != null && loot[i][j] != null)
                           {
                              treasureClips[i].addChild(mChestMovieClips[i][j]);
                              if(j == 0 && mDungeonReport[i].chest_type_1 || j == 1 && mDungeonReport[i].chest_type_2)
                              {
                                 loot[i][j].visible = false;
                              }
                           }
                           j++;
                        }
                     }
                     i++;
                  }
               }
               loadNextChestPopUp();
         }
      }
      
      private function applyGlowFilter(param1:MovieClip) : void
      {
         var _loc2_:Array = [];
         _loc2_.push(new GlowFilter(16777215,1,9,9,4));
         param1.filters = _loc2_;
         param1.scaleX = 1;
         param1.scaleY = 1;
      }
      
      private function setUpTownScreen(param1:SwfAsset) : void
      {
         mTownRoot = param1.root;
         var _loc2_:MovieClipRenderController = new MovieClipRenderController(mDBFacade,mTownRoot);
         _loc2_.play(0,true);
         mSceneGraphComponent.addChild(mTownRoot,50);
      }
      
      private function setupPortraits() : void
      {
         var _loc2_:GMSkin = null;
         var _loc3_:* = 0;
         var _loc1_:TextField = null;
         mScoreReportRoot.stats_a.stats.player_name.text = mDungeonReport[0].name;
         mScoreReportRoot.stats_b.stats.player_name.text = mDungeonReport[1].name;
         mScoreReportRoot.stats_c.stats.player_name.text = mDungeonReport[2].name;
         mScoreReportRoot.stats_d.stats.player_name.text = mDungeonReport[3].name;
         var _loc5_:Array = [mScoreReportRoot.stats_a.stats.avatar,mScoreReportRoot.stats_b.stats.avatar,mScoreReportRoot.stats_c.stats.avatar,mScoreReportRoot.stats_d.stats.avatar];
         var _loc4_:Array = [mScoreReportRoot.stats_a,mScoreReportRoot.stats_b,mScoreReportRoot.stats_c,mScoreReportRoot.stats_d];
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            if(mDungeonReport[_loc3_].valid == true)
            {
               _loc1_ = _loc4_[_loc3_].stats.trophies.trophies;
               _loc1_.text = mDungeonReport[_loc3_].trophyCount.toString();
               _loc2_ = mDBFacade.gameMaster.getSkinByType(mDungeonReport[_loc3_].skin_type);
               if(_loc2_ == null)
               {
                  Logger.error("Could not find skin for skin_type: " + mDungeonReport[_loc3_].skin_type);
               }
               else
               {
                  loadPortraitForReport(mDungeonReport[_loc3_],_loc2_,_loc5_[_loc3_]);
               }
            }
            else
            {
               _loc5_[_loc3_].visible = false;
            }
            _loc3_++;
         }
      }
      
      private function loadPortraitForReport(param1:DungeonReport, param2:GMSkin, param3:MovieClip) : void
      {
         var dungeonReport:DungeonReport = param1;
         var skin:GMSkin = param2;
         var iconContainer:MovieClip = param3;
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(skin.UISwfFilepath),function(param1:SwfAsset):void
         {
            var _loc3_:Class = param1.getClass(skin.IconName);
            var _loc2_:MovieClip = new _loc3_();
            UIObject.scaleToFit(_loc2_,65);
            iconContainer.addChild(_loc2_);
            saveFacebookPicAndAchievement(dungeonReport.id,iconContainer);
         });
      }
      
      private function showFacebookPic(param1:uint) : void
      {
         if(!mFacebookPicHolder)
         {
            return;
         }
         var _loc2_:FacebookPicHelper = mFacebookPicMap.itemFor(param1);
         if(!_loc2_)
         {
            return;
         }
         mFacebookPicHolder.addChild(_loc2_.pic);
         mFacebookPicHolder.visible = true;
         var _loc3_:Point = _loc2_.root.localToGlobal(new Point(0,0));
         mFacebookPicHolder.x = _loc3_.x;
         mFacebookPicHolder.y = _loc3_.y - _loc2_.root.height / 2 - mFacebookPicHolder.height / 2;
      }
      
      private function hideFacebookPic(param1:uint) : void
      {
         if(!mFacebookPicHolder)
         {
            return;
         }
         mFacebookPicHolder.visible = false;
         var _loc2_:FacebookPicHelper = mFacebookPicMap.itemFor(param1);
         if(!_loc2_)
         {
            return;
         }
         if(mFacebookPicHolder.contains(_loc2_.pic))
         {
            mFacebookPicHolder.removeChild(_loc2_.pic);
         }
      }
      
      private function saveFacebookPicAndAchievement(param1:uint, param2:MovieClip) : void
      {
         var facebookId:String;
         var loader:Loader;
         var picUrl:String;
         var url:URLRequest;
         var lc:LoaderContext;
         var playerId:uint = param1;
         var root:MovieClip = param2;
         var go:GameObject = mFacade.gameObjectManager.getReferenceFromId(playerId);
         var player:PlayerGameObject = go as PlayerGameObject;
         if(!player || !player.facebookId || player.facebookId == "" || mDBFacade.isDRPlayer)
         {
            return;
         }
         Logger.error("ERROR: Inside saveFacebookPicAndAchievement when we shouldn\'t be!");
         if(mDBFacade.facebookController && player.isFriend && playerId != mDBFacade.accountId)
         {
            mDBFacade.facebookController.updateGuestAchievement(4);
         }
         facebookId = player.facebookId;
         loader = new Loader();
         picUrl = "https://graph.facebook.com/" + facebookId + "/picture";
         url = new URLRequest(picUrl);
         loader.contentLoaderInfo.addEventListener("ioError",function():void
         {
         });
         loader.contentLoaderInfo.addEventListener("securityError",function():void
         {
         });
         loader.contentLoaderInfo.addEventListener("complete",function(param1:Event):void
         {
            var facebookPic:DisplayObject;
            var helper:FacebookPicHelper;
            var e:Event = param1;
            if(!root)
            {
               return;
            }
            facebookPic = loader;
            facebookPic.x -= 25;
            facebookPic.y -= 25;
            helper = new FacebookPicHelper();
            helper.pic = facebookPic;
            helper.root = root;
            mFacebookPicMap.add(playerId,helper);
            root.addEventListener("rollOver",function(param1:MouseEvent):void
            {
               showFacebookPic(playerId);
            });
            root.addEventListener("rollOut",function(param1:MouseEvent):void
            {
               hideFacebookPic(playerId);
            });
         });
         lc = new LoaderContext(true);
         lc.checkPolicyFile = true;
         loader.load(url,lc);
      }
      
      private function setupXPBars() : void
      {
         var _loc7_:* = 0;
         var _loc4_:GMHero = null;
         var _loc5_:* = 0;
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         var _loc8_:* = 0;
         var _loc6_:* = 0;
         mScoreReportRoot.stats_a.stats.fx_level_up_text.visible = false;
         mScoreReportRoot.stats_b.stats.fx_level_up_text.visible = false;
         mScoreReportRoot.stats_c.stats.fx_level_up_text.visible = false;
         mScoreReportRoot.stats_d.stats.fx_level_up_text.visible = false;
         mScoreReportRoot.stats_a.stats.fx_level_up_anim.visible = false;
         mScoreReportRoot.stats_b.stats.fx_level_up_anim.visible = false;
         mScoreReportRoot.stats_c.stats.fx_level_up_anim.visible = false;
         mScoreReportRoot.stats_d.stats.fx_level_up_anim.visible = false;
         var _loc3_:Array = [mScoreReportRoot.stats_a.stats.xp_bar.UI_XP,mScoreReportRoot.stats_b.stats.xp_bar.UI_XP,mScoreReportRoot.stats_c.stats.xp_bar.UI_XP,mScoreReportRoot.stats_d.stats.xp_bar.UI_XP];
         _loc7_ = 0;
         while(_loc7_ < 4)
         {
            if(mDungeonReport[_loc7_].valid)
            {
               _loc4_ = mDBFacade.gameMaster.heroById.itemFor(mDungeonReport[_loc7_].type);
               _loc5_ = _loc4_.getLevelFromExp(mDungeonReport[_loc7_].xp);
               _loc2_ = mDungeonReport[_loc7_].xp;
               _loc1_ = uint(_loc4_.getLevelIndex(_loc2_));
               _loc8_ = uint(_loc1_ > 0 ? _loc4_.getExpFromIndex(_loc1_ - 1) : 0);
               _loc6_ = _loc4_.getExpFromIndex(_loc1_);
               mXpBar[_loc7_] = new UIProgressBar(mFacade,_loc3_[_loc7_].xp_bar);
               mXpBar[_loc7_].value = (_loc2_ - _loc8_) / (_loc6_ - _loc8_);
               _loc3_[_loc7_].xp_level.text = _loc5_.toString();
               _loc3_[_loc7_].xp_points.visible = true;
               _loc3_[_loc7_].xp_points.text = mDungeonReport[_loc7_].xp.toString();
            }
            else
            {
               _loc3_[_loc7_].visible = false;
            }
            _loc7_++;
         }
         mBoosterExpTick = 0;
         mBoosterGoldTick = 0;
      }
      
      public function TransactionResponse(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         var updateRevealPopupCallback:Function;
         var details:Object;
         var callbackHelper:Function;
         var account_id:uint = param1;
         var succeeded:uint = param2;
         var offer_id:uint = param3;
         var weapon_id:uint = param4;
         if(mDBFacade.accountId != account_id)
         {
            return;
         }
         closeBoosterPopup();
         updateRevealPopupCallback = function():void
         {
         };
         if(succeeded)
         {
            details = {};
            details.OfferId = offer_id;
            details.WeaponId = weapon_id;
            details.NewWeaponDetails = {};
            details.NewWeaponDetails.id = weapon_id;
            if(!mTookLastItem)
            {
               callbackHelper = function(param1:*):Function
               {
                  var details:* = param1;
                  return function():void
                  {
                     mChestRevealPopUp.updateRevealLoot(details);
                  };
               };
               updateRevealPopupCallback = callbackHelper(details);
            }
            if(mInfoPopup)
            {
               if(mSelectedItemSlot == 1000 && mItemCount > 0)
               {
                  mDBFacade.metrics.log("DungeonLootTakeAll",{"itemCount":mItemCount});
               }
               removeItemFromSlot(mSelectedItemSlot);
            }
            if(mTookLastItem)
            {
               removeItemFromSlot(mSelectedItemSlot);
               if(!mFromInventory)
               {
                  if(mOpenKeyChestMC != null)
                  {
                     closeKeyChestPopup();
                  }
                  loadNextChestPopUp();
               }
            }
         }
         else
         {
            if(mInfoPopup)
            {
               mInfoPopup.destroy();
               mInfoPopup = null;
            }
            mChestTransactionFailedPopup = new DBUIPopup(mDBFacade,Locale.getString("TRANSACTION_FAILED"));
            mLogicalWorkComponent.doLater(1.5,function():void
            {
               if(mChestTransactionFailedPopup)
               {
                  mChestTransactionFailedPopup.destroy();
                  mChestTransactionFailedPopup = null;
               }
            });
            if(!mTookLastItem)
            {
               if(mOpenKeyChestMC != null)
               {
                  closeKeyChestPopup();
               }
               mChestRevealPopUp.destroy();
               mChestRevealPopUp = null;
            }
            loadNextChestPopUp();
         }
         mEventComponent.addListener("DB_ACCOUNT_INFO_LOADED",function(param1:Event):void
         {
            mEventComponent.removeListener("DB_ACCOUNT_INFO_LOADED");
            if(mInfoPopup)
            {
               mInfoPopup.destroy();
               mInfoPopup = null;
            }
            updateRevealPopupCallback();
            if(mTransactionSuccessCallback != null)
            {
               mTransactionSuccessCallback();
            }
         });
         mDBFacade.dbAccountInfo.getUsersFullAccountInfo();
      }
      
      public function openBoosterPopup() : void
      {
         mBoosterPopup = new UIVictoryBoosterPopup(mDBFacade,Locale.getString("BOOSTER_POPUP"));
      }
      
      public function closeBoosterPopup() : void
      {
         if(mBoosterPopup)
         {
            mBoosterPopup.destroy();
            mBoosterPopup = null;
         }
      }
      
      private function loadChestIconCallback(param1:GMChest, param2:MovieClip, param3:uint, param4:uint, param5:uint, param6:DistributedDungeonSummary) : Function
      {
         var gmChest:GMChest = param1;
         var loot:MovieClip = param2;
         var loot_type:uint = param3;
         var player:uint = param4;
         var slot:uint = param5;
         var summary:DistributedDungeonSummary = param6;
         return function(param1:SwfAsset):void
         {
            var _loc2_:Class = param1.getClass(gmChest.IconName);
            if(_loc2_)
            {
               mItemButtons[player][slot] = new UIButton(mDBFacade,loot);
               mItemButtons[player][slot].rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
               mItemButtons[player][slot].enabled = player == 0;
               mItemButtons[player][slot].releaseCallback = chestPopupCallback(gmChest,slot);
            }
            else
            {
               Logger.error("Could not find asset class for loot item: " + loot_type.toString());
            }
         };
      }
      
      private function getPlayerSlotItemCount(param1:int) : int
      {
         var _loc3_:* = 0;
         var _loc5_:int = 0;
         var _loc4_:DungeonReport = mDungeonReport[param1];
         var _loc2_:Array = [_loc4_.chest_type_1,_loc4_.chest_type_2,_loc4_.chest_type_3,_loc4_.chest_type_4];
         if(_loc4_.valid == true)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_] != 0)
               {
                  _loc5_++;
               }
               _loc3_++;
            }
         }
         return _loc5_;
      }
      
      private function setupItemButtons() : void
      {
         var _loc2_:* = 0;
         var _loc7_:DungeonReport = null;
         var _loc1_:Array = null;
         var _loc6_:* = 0;
         var _loc4_:GMChest = null;
         var _loc5_:Array = [mScoreReportRoot.stats_a,mScoreReportRoot.stats_b,mScoreReportRoot.stats_c,mScoreReportRoot.stats_d];
         var _loc3_:Array = mUILootSlots;
         if(mUILootSlots == mUILootSlotsFourTreasures)
         {
            setUILootSlotsTwoTreasuresVisible(false);
         }
         if(mUILootSlots == mUILootSlotsTwoTreasures)
         {
            setUILootSlotsFourTreasuresVisible(false);
         }
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc7_ = mDungeonReport[_loc2_];
            _loc1_ = [_loc7_.loot_type_1,_loc7_.loot_type_2,_loc7_.loot_type_3,_loc7_.loot_type_4];
            if(_loc7_.valid == true)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc1_.length)
               {
                  if(_loc1_[_loc6_] != 0)
                  {
                     _loc4_ = mDBFacade.gameMaster.chestsById.itemFor(_loc1_[_loc6_]);
                     if(_loc4_ && _loc4_.IconName)
                     {
                        if(isSingleChestList[_loc2_])
                        {
                           _loc3_[_loc2_][2].visible = false;
                           mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(_loc4_.IconSwf),loadChestIconCallback(_loc4_,mChestMovieClips[_loc2_][2],_loc1_[_loc6_],_loc2_,_loc6_,this));
                        }
                        else
                        {
                           _loc3_[_loc2_][_loc6_].visible = false;
                           mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(_loc4_.IconSwf),loadChestIconCallback(_loc4_,mChestMovieClips[_loc2_][_loc6_],_loc1_[_loc6_],_loc2_,_loc6_,this));
                        }
                     }
                     else
                     {
                        Logger.error("Could not find GMChestItem for loot item: " + _loc1_[_loc6_].toString());
                     }
                  }
                  _loc6_++;
               }
            }
            else
            {
               _loc5_[_loc2_].visible = false;
            }
            _loc2_++;
         }
      }
      
      private function setupLoot() : void
      {
         var mcr:MovieClipRenderer;
         var loot:Array;
         var yScale:Number;
         for each(mcr in mChestRenderers)
         {
            mcr.destroy();
         }
         mChestRenderers.splice(0,mChestRenderers.length);
         mItemCount = 0;
         mBonusXPTick = new Vector.<uint>(4);
         mTeamBonusXPTick = new Vector.<uint>(4);
         mKillsTick = new Vector.<uint>(4);
         mItemCount = getPlayerSlotItemCount(0);
         yScale = 0.5;
         if(mItemCount > 2)
         {
            mUILootSlots = mUILootSlotsFourTreasures;
            yScale = 0.4;
         }
         else
         {
            mUILootSlots = mUILootSlotsTwoTreasures;
         }
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/Doobers/db_items_doobers.swf"),function(param1:SwfAsset):void
         {
            var _loc8_:* = 0;
            var _loc2_:Array = null;
            var _loc9_:* = 0;
            var _loc6_:GMDoober = null;
            var _loc7_:GMChest = null;
            var _loc5_:String = null;
            var _loc4_:String = null;
            var _loc10_:Point = null;
            var _loc3_:Array = null;
            loot = mUILootSlots;
            _loc8_ = 0;
            while(_loc8_ < 4)
            {
               _loc2_ = [mDungeonReport[_loc8_].chest_type_1,mDungeonReport[_loc8_].chest_type_2,mDungeonReport[_loc8_].chest_type_3,mDungeonReport[_loc8_].chest_type_4];
               _loc2_.sort(compareChestTypes);
               if(mDungeonReport[_loc8_].valid == true)
               {
                  _loc9_ = 0;
                  while(_loc9_ < 4)
                  {
                     if(!(_loc2_[_loc9_] == 0 || loot[_loc8_][_loc9_] == null))
                     {
                        _loc6_ = mDBFacade.gameMaster.dooberById.itemFor(_loc2_[_loc9_]);
                        if(_loc6_)
                        {
                           _loc7_ = mDBFacade.gameMaster.chestsById.itemFor(_loc6_.ChestId);
                           _loc5_ = _loc7_.IconSwf;
                           _loc4_ = _loc7_.IconName;
                           if(isSingleChestList[_loc8_])
                           {
                              _loc9_ = 2;
                           }
                           _loc10_ = new Point(loot[_loc8_][_loc9_].x,loot[_loc8_][_loc9_].y);
                           _loc3_ = mChestMovieClips;
                           ChestInfo.loadItemIcon(_loc5_,_loc4_,mChestMovieClips[_loc8_][_loc9_],mDBFacade,150,150,mAssetLoadingComponent);
                           mChestMovieClips[_loc8_][_loc9_].scaleX = mChestMovieClips[_loc8_][_loc9_].scaleY = yScale;
                           mChestMovieClips[_loc8_][_loc9_].x = _loc10_.x;
                           mChestMovieClips[_loc8_][_loc9_].y = _loc10_.y;
                        }
                     }
                     _loc9_++;
                  }
               }
               _loc8_++;
            }
         });
         setupItemButtons();
      }
      
      public function compareChestTypes(param1:uint, param2:uint) : int
      {
         if(param1 == 0)
         {
            return 1;
         }
         if(param2 == 0)
         {
            return -1;
         }
         var _loc3_:GMDoober = mDBFacade.gameMaster.dooberById.itemFor(param1);
         var _loc4_:GMDoober = mDBFacade.gameMaster.dooberById.itemFor(param2);
         if(mRarityMap.itemFor(_loc3_.Rarity) > mRarityMap.itemFor(_loc4_.Rarity))
         {
            return -1;
         }
         if(mRarityMap.itemFor(_loc4_.Rarity) > mRarityMap.itemFor(_loc3_.Rarity))
         {
            return 1;
         }
         return 0;
      }
      
      private function setupWeapons() : void
      {
         mWeapons = [];
         mWeaponTooltips = [];
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),function(param1:SwfAsset):void
         {
            var _loc2_:* = 0;
            var _loc3_:* = 0;
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               if(mDungeonReport[_loc2_].valid == true)
               {
                  mWeapons.push([]);
                  mWeaponTooltips.push([]);
                  _loc3_ = 0;
                  while(_loc3_ < 3)
                  {
                     if(!(_loc3_ == 0 && mDungeonReport[_loc2_].weapon_type_1 == 0))
                     {
                        if(!(_loc3_ == 1 && mDungeonReport[_loc2_].weapon_type_2 == 0))
                        {
                           if(!(_loc3_ == 2 && mDungeonReport[_loc2_].weapon_type_3 == 0))
                           {
                              setupWeaponUIForStat(param1,_loc2_,_loc3_);
                           }
                        }
                     }
                     _loc3_++;
                  }
               }
               _loc2_++;
            }
         });
      }
      
      private function setupWeaponUIForStat(param1:SwfAsset, param2:uint, param3:uint) : void
      {
         var tooltipClass:Class;
         var weaponTooltip:UIWeaponTooltip;
         var gmWeaponItem:GMWeaponItem;
         var gmWeaponAesthetic:GMWeaponAesthetic;
         var swfAsset:SwfAsset = param1;
         var statNum:uint = param2;
         var weaponSlotNum:uint = param3;
         var weaponButtons:Array = [[mScoreReportRoot.stats_a.stats.loot_slot_A1,mScoreReportRoot.stats_a.stats.loot_slot_A2,mScoreReportRoot.stats_a.stats.loot_slot_A3],[mScoreReportRoot.stats_b.stats.loot_slot_A1,mScoreReportRoot.stats_b.stats.loot_slot_A2,mScoreReportRoot.stats_b.stats.loot_slot_A3],[mScoreReportRoot.stats_c.stats.loot_slot_A1,mScoreReportRoot.stats_c.stats.loot_slot_A2,mScoreReportRoot.stats_c.stats.loot_slot_A3],[mScoreReportRoot.stats_d.stats.loot_slot_A1,mScoreReportRoot.stats_d.stats.loot_slot_A2,mScoreReportRoot.stats_d.stats.loot_slot_A3]];
         var weapon:UIObject = new UIObject(mDBFacade,weaponButtons[statNum][weaponSlotNum]);
         mWeapons.push(weapon);
         tooltipClass = swfAsset.getClass("DR_weapon_tooltip");
         weaponTooltip = new UIWeaponTooltip(mDBFacade,tooltipClass);
         mWeaponTooltips[statNum].push(weaponTooltip);
         switch(int(weaponSlotNum))
         {
            case 0:
               gmWeaponItem = mDBFacade.gameMaster.weaponItemById.itemFor(mDungeonReport[statNum].weapon_type_1);
               gmWeaponAesthetic = gmWeaponItem.getWeaponAesthetic(mDungeonReport[statNum].weapon_level_1,mDungeonReport[statNum].legendary_modifier_type_1 > 0);
               break;
            case 1:
               gmWeaponItem = mDBFacade.gameMaster.weaponItemById.itemFor(mDungeonReport[statNum].weapon_type_2);
               gmWeaponAesthetic = gmWeaponItem.getWeaponAesthetic(mDungeonReport[statNum].weapon_level_2,mDungeonReport[statNum].legendary_modifier_type_2 > 0);
               break;
            case 2:
               gmWeaponItem = mDBFacade.gameMaster.weaponItemById.itemFor(mDungeonReport[statNum].weapon_type_3);
               gmWeaponAesthetic = gmWeaponItem.getWeaponAesthetic(mDungeonReport[statNum].weapon_level_3,mDungeonReport[statNum].legendary_modifier_type_3 > 0);
         }
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(gmWeaponAesthetic.IconSwf),function(param1:SwfAsset):void
         {
            var rarity:GMRarity;
            var bgColoredExists:Boolean;
            var bgSwfPath:String;
            var bgIconName:String;
            var swfAsset:SwfAsset = param1;
            var weaponClass:Class = swfAsset.getClass(gmWeaponAesthetic.IconName);
            var weaponMC:MovieClip = new weaponClass() as MovieClip;
            weaponMC.scaleX = weaponMC.scaleY = 0.5;
            weapon.root.addChild(weaponMC);
            weapon.tooltip = weaponTooltip;
            switch(int(weaponSlotNum))
            {
               case 0:
                  rarity = mDBFacade.gameMaster.rarityById.itemFor(mDungeonReport[statNum].weapon_rarity_1);
                  break;
               case 1:
                  rarity = mDBFacade.gameMaster.rarityById.itemFor(mDungeonReport[statNum].weapon_rarity_2);
                  break;
               case 2:
                  rarity = mDBFacade.gameMaster.rarityById.itemFor(mDungeonReport[statNum].weapon_rarity_3);
            }
            bgColoredExists = rarity.HasColoredBackground;
            bgSwfPath = rarity.BackgroundSwf;
            bgIconName = rarity.BackgroundIcon;
            if(bgColoredExists)
            {
               mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(bgSwfPath),function(param1:SwfAsset):void
               {
                  var _loc3_:MovieClip = null;
                  var _loc2_:Class = param1.getClass(bgIconName);
                  if(_loc2_)
                  {
                     _loc3_ = new _loc2_() as MovieClip;
                     _loc3_.scaleX = _loc3_.scaleY = 0.65;
                     weapon.root.addChildAt(_loc3_,1);
                  }
               });
            }
            switch(int(weaponSlotNum))
            {
               case 0:
                  weaponTooltip.setWeaponItemFromData(gmWeaponAesthetic.Name,mDungeonReport[statNum].weapon_power_1,gmWeaponItem.TapIcon,gmWeaponItem.HoldIcon,mDungeonReport[statNum].modifier_type_1a,mDungeonReport[statNum].modifier_type_1b,mDungeonReport[statNum].legendary_modifier_type_1,mDungeonReport[statNum].weapon_rarity_1,mDungeonReport[statNum].weapon_level_1);
                  break;
               case 1:
                  weaponTooltip.setWeaponItemFromData(gmWeaponAesthetic.Name,mDungeonReport[statNum].weapon_power_2,gmWeaponItem.TapIcon,gmWeaponItem.HoldIcon,mDungeonReport[statNum].modifier_type_2a,mDungeonReport[statNum].modifier_type_2b,mDungeonReport[statNum].legendary_modifier_type_2,mDungeonReport[statNum].weapon_rarity_2,mDungeonReport[statNum].weapon_level_2);
                  break;
               case 2:
                  weaponTooltip.setWeaponItemFromData(gmWeaponAesthetic.Name,mDungeonReport[statNum].weapon_power_3,gmWeaponItem.TapIcon,gmWeaponItem.HoldIcon,mDungeonReport[statNum].modifier_type_3a,mDungeonReport[statNum].modifier_type_3b,mDungeonReport[statNum].legendary_modifier_type_3,mDungeonReport[statNum].weapon_rarity_3,mDungeonReport[statNum].weapon_level_3);
            }
         });
      }
      
      public function compareOnChestValues(param1:Array, param2:Array) : int
      {
         return compareChestTypes(param1[1],param2[1]);
      }
      
      public function loadNextChestPopUp() : void
      {
         var _loc1_:int = 0;
         var _loc8_:Array = null;
         var _loc4_:GMChest = null;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         mDBFacade.dbAccountInfo.getUsersFullAccountInfo();
         var _loc7_:DungeonReport = mDungeonReport[0];
         var _loc5_:Array = [_loc7_.chest_type_1,_loc7_.chest_type_2,_loc7_.chest_type_3,_loc7_.chest_type_4];
         var _loc3_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc8_ = [_loc1_,_loc5_[_loc1_]];
            _loc3_.push(_loc8_);
            _loc1_++;
         }
         _loc3_.sort(compareOnChestValues);
         if(_loc7_.valid)
         {
            if(_loc3_[0][1] != 0)
            {
               _loc6_ = int(_loc3_[0][0]);
               _loc2_ = int(_loc3_[0][1]);
               _loc4_ = mDBFacade.gameMaster.chestsById.itemFor(mDBFacade.gameMaster.dooberById.itemFor(_loc2_).ChestId);
               chestOpenPopUp(_loc4_,_loc6_);
               return;
            }
         }
      }
      
      private function chestOpenPopUp(param1:GMChest, param2:uint) : void
      {
         mSelectedItemSlot = param2;
         mSelectedGMChest = param1;
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_score_report.swf"),setupOpenKeyChest);
      }
      
      public function set dungeonSuccess(param1:uint) : void
      {
         if(param1 == 0)
         {
            mDungeonSuccess = false;
         }
         else if(param1 == 1)
         {
            mDungeonSuccess = true;
         }
         else
         {
            Logger.error("Unable to parse value to a bool.  Value: " + param1);
         }
      }
      
      public function get dungeonSuccess() : uint
      {
         return uint(mDungeonSuccess);
      }
      
      private function chestPopupCallback(param1:GMChest, param2:uint) : Function
      {
         var gmChest:GMChest = param1;
         var slot:uint = param2;
         return function():void
         {
            chestOpenPopUp(gmChest,slot);
         };
      }
      
      private function setupOpenKeyChest(param1:SwfAsset) : void
      {
         var openKeyChestClass:Class;
         var swfPath:String;
         var iconName:String;
         var rarity:GMRarity;
         var bgColoredExists:Boolean;
         var bgSwfPath:String;
         var bgIconName:String;
         var keys:Vector.<KeyInfo>;
         var i:int;
         var swfAsset:SwfAsset = param1;
         mSceneGraphComponent.showPopupCurtain();
         openKeyChestClass = UIHud.isThisAConsumbleChestId(mSelectedGMChest.Id) ? swfAsset.getClass("popup_itemBox") : swfAsset.getClass("popup_chest");
         mOpenKeyChestMC = new openKeyChestClass();
         mOpenKeyChestMC.x = 380;
         mOpenKeyChestMC.y = 240;
         mOpenKeyChestMC.title_label.text = Locale.getString("TREASURE_FOUND");
         swfPath = mSelectedGMChest.IconSwf;
         iconName = mSelectedGMChest.IconName;
         ChestInfo.loadItemIcon(swfPath,iconName,mOpenKeyChestMC.content,mDBFacade,150,150,mAssetLoadingComponent);
         rarity = mDBFacade.gameMaster.rarityByConstant.itemFor(mSelectedGMChest.Rarity);
         bgColoredExists = rarity.HasColoredBackground;
         bgSwfPath = rarity.BackgroundSwf;
         bgIconName = rarity.BackgroundIcon;
         if(bgColoredExists)
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(bgSwfPath),function(param1:SwfAsset):void
            {
               var _loc3_:MovieClip = null;
               var _loc2_:Class = param1.getClass(bgIconName);
               if(_loc2_)
               {
                  _loc3_ = new _loc2_() as MovieClip;
                  mOpenKeyChestMC.content.addChildAt(_loc3_,0);
                  _loc3_.scaleX = _loc3_.scaleY = 1.5;
               }
            });
         }
         mOpenKeyChestRenderer = new MovieClipRenderer(mDBFacade,mOpenKeyChestMC.content);
         mOpenKeyChestRenderer.play(0,true);
         mAbandonButton = new UIButton(mDBFacade,mOpenKeyChestMC.abandon_button);
         mAbandonButton.releaseCallback = abandonChestCallback;
         mAbandonButton.label.text = Locale.getString("ABANDON");
         mKeepButton = new UIButton(mDBFacade,mOpenKeyChestMC.keep_button);
         mKeepButton.releaseCallback = keepChestCallback;
         mKeepButton.label.text = Locale.getString("KEEP");
         mOpenButton = new UIButton(mDBFacade,mOpenKeyChestMC.open_button);
         mOpenButton.releaseCallback = openChestCallback;
         mOpenButton.label.text = Locale.getString("UNLOCK");
         mOpenKeyChestMC.close.visible = false;
         keys = mDBFacade.dbAccountInfo.inventoryInfo.keys;
         i = 0;
         while(i < keys.length)
         {
            if(mSelectedGMChest.Id == keys[i].gmKey.ChestId)
            {
               mKeyThatCanOpenChest = keys[i];
            }
            i++;
         }
         if(!UIHud.isThisAConsumbleChestId(mSelectedGMChest.Id))
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(mKeyThatCanOpenChest.gmKeyOffer.BundleSwfFilepath),loadKeyIconOnButton);
            refreshHeroInfoUI(mOpenKeyChestMC);
         }
         mSceneGraphComponent.addChild(mOpenKeyChestMC,105);
      }
      
      public function refreshHeroInfoUI(param1:MovieClip) : void
      {
         var mHeroInfo:AvatarInfo;
         var gmSkin:GMSkin;
         var chestMC:MovieClip = param1;
         chestMC.hero_label.text = Locale.getString("OPENING_WITH");
         mHeroInfo = mDBFacade.dbAccountInfo.activeAvatarInfo;
         gmSkin = mDBFacade.gameMaster.getSkinByType(mHeroInfo.skinId);
         if(gmSkin == null)
         {
            Logger.error("Unable to find gmSkin for ID: " + mHeroInfo.skinId);
         }
         else
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(gmSkin.IconSwfFilepath),function(param1:SwfAsset):void
            {
               var _loc3_:Class = param1.getClass(gmSkin.IconName);
               if(_loc3_ == null)
               {
                  return;
               }
               var _loc4_:MovieClip = new _loc3_();
               var _loc2_:MovieClipRenderController = new MovieClipRenderController(mDBFacade,_loc4_);
               _loc2_.play();
               if(chestMC.avatar.numChildren > 0)
               {
                  chestMC.avatar.removeChildAt(0);
               }
               chestMC.avatar.addChildAt(_loc4_,0);
               _loc4_.scaleX = _loc4_.scaleY = 1;
            });
         }
      }
      
      private function loadKeyIconOnButton(param1:SwfAsset) : void
      {
         var _loc3_:Class = param1.getClass(mKeyThatCanOpenChest.gmKeyOffer.BundleIcon);
         var _loc2_:MovieClip = new _loc3_() as MovieClip;
         _loc2_.scaleX = _loc2_.scaleY = 0.5;
         if(mOpenButton.root.pick.numChildren > 1)
         {
            mOpenButton.root.pick.removeChildAt(1);
         }
         mOpenButton.root.pick.addChild(_loc2_);
      }
      
      private function setupOpenKeylessChest(param1:SwfAsset) : void
      {
         mChestBuyKeysPopUp = new ChestBuyKeysPopUp(mDBFacade,mAssetLoadingComponent,mSceneGraphComponent,param1,mSelectedGMChest,chestBuyCoinCallback,chestBuyGemCallback,closeKeylessChestPopup,refreshHeroInfoUI,true);
      }
      
      private function createKeySlots(param1:MovieClip) : void
      {
         var _loc3_:int = 0;
         var _loc2_:MovieClip = null;
         mChestKeySlots = new Vector.<ChestKeySlot>();
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc2_ = param1.getChildByName("slot_" + _loc3_.toString()) as MovieClip;
            mChestKeySlots.push(new ChestKeySlot(mDBFacade,_loc2_,mDBFacade.dbAccountInfo.inventoryInfo.keys[_loc3_],mAssetLoadingComponent));
            if(mSelectedGMChest.Id == mChestKeySlots[_loc3_].keyInfo.gmKey.ChestId)
            {
               mChestKeySlots[_loc3_].setSelected(true);
            }
            else
            {
               mChestKeySlots[_loc3_].setSelected(false);
            }
            _loc3_++;
         }
      }
      
      private function chestBuyCoinCallback(param1:Number) : Function
      {
         var val:Number = param1;
         return function():void
         {
            var _loc1_:int = 0;
            var _loc2_:* = 0;
            mDBFacade.metrics.log("ChestUnlockCoinTry",{
               "chestId":mSelectedGMChest.Id,
               "rarity":mSelectedGMChest.Rarity,
               "category":"dungeonSummary"
            });
            if(mDBFacade.dbAccountInfo.basicCurrency >= val)
            {
               mDBFacade.metrics.log("ChestUnlockCoin",{
                  "chestId":mSelectedGMChest.Id,
                  "rarity":mSelectedGMChest.Rarity,
                  "category":"dungeonSummary"
               });
               closeKeylessChestPopup();
               closeKeyChestPopup();
               mInfoPopup = new DBUIPopup(mDBFacade,Locale.getString("PURCHASING..."));
               mSceneGraphComponent.addChild(mInfoPopup.root,105);
               _loc1_ = 0;
               while(_loc1_ < 6)
               {
                  if(mDBFacade.dbAccountInfo.inventoryInfo.keys[_loc1_].gmKey.ChestId == mSelectedGMChest.Id)
                  {
                     _loc2_ = mDBFacade.dbAccountInfo.inventoryInfo.keys[_loc1_].gmKeyOffer.CoinOfferId;
                     StoreServices.purchaseOffer(mDBFacade,_loc2_,boughtKey,boughtKeyError,0,false);
                     break;
                  }
                  _loc1_++;
               }
            }
            else
            {
               StoreServicesController.showCoinPage(mDBFacade);
            }
         };
      }
      
      private function chestBuyGemCallback(param1:Number) : Function
      {
         var val:Number = param1;
         return function():void
         {
            var _loc1_:int = 0;
            var _loc2_:* = 0;
            mDBFacade.metrics.log("ChestUnlockGemTry",{
               "chestId":mSelectedGMChest.Id,
               "rarity":mSelectedGMChest.Rarity,
               "category":"dungeonSummary"
            });
            if(mDBFacade.dbAccountInfo.premiumCurrency >= val)
            {
               mDBFacade.metrics.log("ChestUnlockGem",{
                  "chestId":mSelectedGMChest.Id,
                  "rarity":mSelectedGMChest.Rarity,
                  "category":"dungeonSummary"
               });
               closeKeylessChestPopup();
               closeKeyChestPopup();
               mInfoPopup = new DBUIPopup(mDBFacade,Locale.getString("PURCHASING..."));
               mSceneGraphComponent.addChild(mInfoPopup.root,105);
               _loc1_ = 0;
               while(_loc1_ < 6)
               {
                  if(mDBFacade.dbAccountInfo.inventoryInfo.keys[_loc1_].gmKey.ChestId == mSelectedGMChest.Id)
                  {
                     _loc2_ = mDBFacade.dbAccountInfo.inventoryInfo.keys[_loc1_].gmKeyOffer.Id;
                     StoreServices.purchaseOffer(mDBFacade,_loc2_,boughtKey,boughtKeyError,0,false);
                     break;
                  }
                  _loc1_++;
               }
            }
            else
            {
               StoreServicesController.showCashPage(mDBFacade,"chestOpenWithGemsAttemptDungeonSummary");
            }
         };
      }
      
      private function abandonChestCallback(param1:String = "dungeonSummaryChestPopUp") : void
      {
         var category:String = param1;
         mAbandonChestPopUp = new DBUITwoButtonPopup(mDBFacade,Locale.getString("ABANDON_CHEST_POPUP_TITLE"),Locale.getString("ABANDON_CHEST_POPUP_DESC"),Locale.getString("ABANDON_CHEST_POPUP_CANCEL"),closeAbandonChestPopUp,Locale.getString("ABANDON_CHEST_POPUP_CONFIRM"),function():void
         {
            mNetworkComponent.send_DropChest(mDBFacade.dbAccountInfo.id,mSelectedItemSlot);
            mDBFacade.metrics.log("ChestAbandoned",{
               "chestId":mSelectedGMChest.Id,
               "rarity":mSelectedGMChest.Rarity,
               "category":category
            });
            removeItemFromSlot(mSelectedItemSlot);
            closeKeyChestPopup();
            loadNextChestPopUp();
            closeAbandonChestPopUp();
         },false,null);
         mAbandonChestPopUp.root.y += 180;
      }
      
      private function closeAbandonChestPopUp() : void
      {
         if(mAbandonChestPopUp)
         {
            mAbandonChestPopUp.destroy();
            mAbandonChestPopUp = null;
         }
      }
      
      public function abandonChestFromInventory(param1:uint) : void
      {
         mNetworkComponent.send_DropChest(mDBFacade.dbAccountInfo.id,mSelectedItemSlot);
         removeItemFromSlot(param1);
         mUIInventory.refresh(true);
      }
      
      private function keepChestCallback() : void
      {
         if(mDBFacade.dbAccountInfo.inventoryInfo.isThereEmptySpaceInWeaponStorage())
         {
            closeKeyChestPopup();
            keepChestFromInventory(mSelectedItemSlot,false);
         }
         else
         {
            mStorageFullPopUp = new DBUITwoButtonPopup(mDBFacade,Locale.getString("GO_TO_INVENTORY_TITLE"),Locale.getString("GO_TO_INVENTORY_BODY"),Locale.getString("INVENTORY"),function():void
            {
               closeKeyChestPopup();
               openInventory();
            },Locale.getString("ABANDON"),function():void
            {
               abandonChestCallback("dungeonSummaryInventoryFullOnKeep");
            },true,null);
            mStorageFullPopUp.root.y += 180;
         }
      }
      
      public function keepChestFromInventory(param1:uint, param2:Boolean) : void
      {
         if(param2)
         {
            mDBFacade.metrics.log("ChestKept",{
               "chestId":mSelectedGMChest.Id,
               "rarity":mSelectedGMChest.Id,
               "category":"storageFromDungeonSummary"
            });
         }
         else
         {
            mDBFacade.metrics.log("ChestKept",{
               "chestId":mSelectedGMChest.Id,
               "rarity":mSelectedGMChest.Id,
               "category":"dungeonSummary"
            });
         }
         mSelectedItemSlot = param1;
         mFromInventory = param2;
         mTookLastItem = true;
         mNetworkComponent.send_TakeChest(mDBFacade.dbAccountInfo.id,mSelectedItemSlot);
         mInfoPopup = new DBUIPopup(mDBFacade,Locale.getString("TAKING_ITEM"));
      }
      
      private function openChestCallback() : void
      {
         var doesKeyExist:Boolean;
         var i:int;
         if(mDBFacade.dbAccountInfo.inventoryInfo.isThereEmptySpaceInWeaponStorage())
         {
            doesKeyExist = false;
            i = 0;
            while(i < 4)
            {
               if(mDBFacade.dbAccountInfo.inventoryInfo.keys[i].gmKey.ChestId == mSelectedGMChest.Id && mDBFacade.dbAccountInfo.inventoryInfo.keys[i].count > 0)
               {
                  doesKeyExist = true;
               }
               ++i;
            }
            if(doesKeyExist)
            {
               boughtKey(null);
            }
            else
            {
               mOpenKeyChestMC.visible = false;
               mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_score_report.swf"),setupOpenKeylessChest);
            }
         }
         else
         {
            mStorageFullPopUp = new DBUITwoButtonPopup(mDBFacade,Locale.getString("GO_TO_INVENTORY_TITLE"),Locale.getString("GO_TO_INVENTORY_BODY_OPEN"),Locale.getString("INVENTORY"),function():void
            {
               closeKeyChestPopup();
               openInventory();
            },Locale.getString("ABANDON"),function():void
            {
               abandonChestCallback("abandonFromUnlockOnChestWithFullInventory");
            },true,null);
            mStorageFullPopUp.root.y += 180;
         }
      }
      
      private function boughtKey(param1:*) : void
      {
         mDBFacade.metrics.log("ChestUnlockKey",{
            "chestId":mSelectedGMChest.Id,
            "rarity":mSelectedGMChest.Rarity,
            "category":"dungeonSummary"
         });
         if(mInfoPopup)
         {
            mSceneGraphComponent.removeChild(mInfoPopup.root);
            mInfoPopup.destroy();
            mInfoPopup = null;
         }
         openChestFromInventory(mSelectedGMChest,false);
      }
      
      public function findSlotForChest(param1:GMChest) : uint
      {
         var _loc4_:* = 0;
         var _loc3_:GMDoober = null;
         var _loc2_:Array = [mDungeonReport[0].chest_type_1,mDungeonReport[0].chest_type_2,mDungeonReport[0].chest_type_3,mDungeonReport[0].chest_type_4];
         if(mDungeonReport[0].valid == true)
         {
            _loc4_ = 0;
            while(_loc4_ < 4)
            {
               if(_loc2_[_loc4_] != 0)
               {
                  _loc3_ = mDBFacade.gameMaster.dooberById.itemFor(_loc2_[_loc4_]);
                  if(_loc3_.ChestId == param1.Id)
                  {
                     return _loc4_;
                  }
               }
               _loc4_++;
            }
         }
         return 0;
      }
      
      public function openChestFromInventory(param1:GMChest, param2:Boolean) : void
      {
         var _loc3_:uint = findSlotForChest(param1);
         mFromInventory = param2;
         mTookLastItem = false;
         mNetworkComponent.send_OpenChest(mDBFacade.dbAccountInfo.id,_loc3_);
         mSceneGraphComponent.fadeOut(0.5,0.75);
         if(param2)
         {
            mChestRevealPopUp = new ChestRevealPopUp(mDBFacade,param1,closeChestRevealPopUp,equipItemFromInventory);
         }
         else
         {
            mChestRevealPopUp = new ChestRevealPopUp(mDBFacade,param1,closeChestRevealPopUp,goToStorageChestRevealPopUp);
         }
         removeItemFromSlot(_loc3_);
         if(mOpenKeyChestMC != null)
         {
            closeKeyChestPopup();
         }
      }
      
      private function equipItemFromInventory(param1:uint, param2:uint, param3:Boolean) : void
      {
         mSceneGraphComponent.fadeIn(0.5);
         if(mChestRevealPopUp)
         {
            mChestRevealPopUp.destroy();
            mChestRevealPopUp = null;
         }
         if(mTownHeader != null)
         {
            mTownHeader.refreshKeyPanel();
         }
         mUIInventory.setRevealedState(param1,param2,param3);
         mUIInventory.refresh();
      }
      
      private function goToStorageChestRevealPopUp(param1:uint, param2:uint, param3:Boolean) : void
      {
         mRevealedItemType = param1;
         mRevealedItemOfferId = param2;
         mRevealedItemCallEquip = param3;
         mSceneGraphComponent.fadeIn(0.5);
         if(mChestRevealPopUp)
         {
            mChestRevealPopUp.destroy();
            mChestRevealPopUp = null;
         }
         if(mTownHeader != null)
         {
            mTownHeader.refreshKeyPanel();
         }
         openInventory();
      }
      
      private function boughtKeyError(param1:JSONParseError) : void
      {
         Logger.warn("Error buying keys from Reward Screen");
      }
      
      private function closeChestRevealPopUp(param1:uint, param2:uint, param3:Boolean) : void
      {
         mRevealedItemType = param1;
         mRevealedItemOfferId = param2;
         mSceneGraphComponent.fadeIn(0.5);
         if(mChestRevealPopUp)
         {
            mChestRevealPopUp.destroy();
            mChestRevealPopUp = null;
         }
         if(!mFromInventory)
         {
            loadNextChestPopUp();
         }
         else if(param3)
         {
            mUIInventory.setRevealedState(mRevealedItemType,mRevealedItemOfferId);
            mUIInventory.refresh();
         }
         if(mTownHeader != null)
         {
            mTownHeader.refreshKeyPanel();
         }
      }
      
      private function closeKeyChestPopup() : void
      {
         if(mOpenKeyChestMC)
         {
            mAbandonButton.destroy();
            mAbandonButton = null;
            mKeepButton.destroy();
            mKeepButton = null;
            mOpenButton.destroy();
            mOpenButton = null;
            mOpenKeyChestRenderer.destroy();
            mOpenKeyChestRenderer = null;
            mSceneGraphComponent.removeChild(mOpenKeyChestMC);
            mOpenKeyChestMC = null;
            mSceneGraphComponent.removePopupCurtain();
         }
      }
      
      private function closeKeylessChestPopup() : void
      {
         if(mChestBuyKeysPopUp)
         {
            mChestBuyKeysPopUp.destroy();
            mChestBuyKeysPopUp = null;
         }
         mOpenKeyChestMC.visible = true;
      }
      
      private function chatCallback(param1:uint) : Function
      {
         var playerIndex:uint = param1;
         return function(param1:ChatEvent):void
         {
            var event:ChatEvent = param1;
            mChatBalloon[playerIndex].showBalloon();
            mChatBalloon[playerIndex].text = event.message;
            if(mChatCloseTask[playerIndex])
            {
               mChatCloseTask[playerIndex].destroy();
            }
            mChatCloseTask[playerIndex] = mWorkComponent.doLater(5,function():void
            {
               mChatBalloon[playerIndex].hideBalloon();
            });
         };
      }
      
      private function typingCallback(param1:uint) : Function
      {
         var playerIndex:uint = param1;
         return function(param1:PlayerIsTypingEvent):void
         {
            if(param1.subtype == "CHAT_BOX_FOCUS_IN")
            {
               mChatBalloon[playerIndex].showPlayerTyping();
            }
            else
            {
               mChatBalloon[playerIndex].hidePlayerTyping();
            }
         };
      }
      
      private function setupChat() : void
      {
         var i:uint = 0;
         while(i < 4)
         {
            if(mDungeonReport[i].valid)
            {
               mChatBalloon[i] = new ChatBalloon();
               mChatBalloon[i].hideBalloon();
               mChatEventComponent.addListener(GameObjectEvent.uniqueEvent("ChatEvent_INCOMING_CHAT_UPDATE",mDungeonReport[i].id),chatCallback(i));
               mChatEventComponent.addListener(GameObjectEvent.uniqueEvent("PLAYER_IS_TYPING",mDungeonReport[i].id),typingCallback(i));
            }
            ++i;
         }
         mUIChatLog = new UIChatLog(mDBFacade,mScoreReportRoot.chatLogContainer,mScoreReportRoot.UI_chat,mScoreReportRoot.UI_chat.log_btn,mScoreReportRoot.UI_chat.chat_btn);
         mUIChatLog.hideChatLog();
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_nametag.swf"),function(param1:SwfAsset):void
         {
            var _loc3_:Class = null;
            var _loc2_:MovieClip = null;
            var _loc6_:Class = null;
            var _loc5_:Point = null;
            var _loc4_:Array = [mScoreReportRoot.stats_a,mScoreReportRoot.stats_b,mScoreReportRoot.stats_c,mScoreReportRoot.stats_d];
            i = 0;
            while(i < 4)
            {
               if(mDungeonReport[i].valid)
               {
                  _loc3_ = param1.getClass("UI_speechbubble");
                  _loc2_ = new _loc3_();
                  _loc2_.visible = false;
                  _loc6_ = param1.getClass("UI_speechbubble_typing");
                  mPlayerIsTypingNotification = new _loc6_();
                  mPlayerIsTypingNotification.visible = false;
                  mChatBalloon[i].initializeChatBalloon(param1,mPlayerIsTypingNotification);
                  mSceneGraphComponent.addChild(mChatBalloon[i],50);
                  mChatBalloon[i].text = "";
                  _loc5_ = _loc4_[i].stats.player_name.localToGlobal(new Point(0,0));
                  mChatBalloon[i].x = _loc5_.x + 69;
                  mChatBalloon[i].y = _loc5_.y + 32;
                  mChatBalloon[i].hideBalloon();
               }
               ++i;
            }
         });
      }
      
      private function sendChat(param1:String) : void
      {
         var value:String = param1;
         mDBFacade.regainFocus();
         if(value)
         {
            mChatBalloon[0].showBalloon();
            mChatBalloon[0].text = value;
            if(mChatCloseTask[0])
            {
               mChatCloseTask[0].destroy();
            }
            mChatCloseTask[0] = mWorkComponent.doLater(5,function():void
            {
               mChatBalloon[0].hideBalloon();
            });
            mEventComponent.dispatchEvent(new ChatEvent("ChatEvent_OUTGOING_CHAT_UPDATE",0,value));
         }
      }
      
      private function removeItemFromSlot(param1:uint) : void
      {
         var _loc3_:* = 0;
         var _loc5_:* = param1;
         _loc3_ = 0;
         while(_loc3_ < mSortedLootData.length)
         {
            if(mSortedLootData[_loc3_][0] == param1)
            {
               _loc5_ = _loc3_;
            }
            _loc3_++;
         }
         var _loc4_:uint = 0;
         switch(int(param1))
         {
            case 0:
               _loc4_ = mDungeonReport[0].chest_type_1;
               mDungeonReport[0].chest_type_1 = 0;
               break;
            case 1:
               _loc4_ = mDungeonReport[0].chest_type_2;
               mDungeonReport[0].chest_type_2 = 0;
               break;
            case 2:
               _loc4_ = mDungeonReport[0].chest_type_3;
               mDungeonReport[0].chest_type_3 = 0;
               break;
            case 3:
               _loc4_ = mDungeonReport[0].chest_type_4;
               mDungeonReport[0].chest_type_4 = 0;
         }
         if(_loc4_ == 0)
         {
            return;
         }
         --mItemCount;
         if(mTookLastItem)
         {
            mDBFacade.metrics.log("DungeonLootTookItem",{"itemId":_loc4_});
         }
         else
         {
            mDBFacade.metrics.log("DungeonLootSoldItem",{"itemId":_loc4_});
         }
         var _loc2_:Array = mUILootSlots[0];
         if(isSingleChestList[0])
         {
            param1 = 2;
         }
         _loc2_[_loc5_].visible = true;
         mChestMovieClips[0][_loc5_].visible = false;
         if(isSingleChestList[0])
         {
            if(mItemButtons[0][0])
            {
               mItemButtons[0][0].enabled = false;
            }
         }
         else if(mItemButtons[0][param1])
         {
            mItemButtons[0][param1].enabled = false;
         }
      }
      
      private function hideBanners() : void
      {
         mScoreReportRoot.stats_a.visible = false;
         mScoreReportRoot.stats_b.visible = false;
         mScoreReportRoot.stats_c.visible = false;
         mScoreReportRoot.stats_d.visible = false;
         mScoreReportRoot.empty_banner_b.visible = false;
         mScoreReportRoot.empty_banner_c.visible = false;
         mScoreReportRoot.empty_banner_d.visible = false;
         if(mCurrentMapNode.InfiniteDungeon != null)
         {
            mScoreReportRoot.banner_deco01.visible = false;
            mScoreReportRoot.banner_deco02.visible = false;
         }
      }
      
      private function updateBannerAlpha(param1:GameClock) : void
      {
         var _loc2_:Number = 1 - mScoreReportRoot.stats_a.alpha;
         _loc2_ = 1 - _loc2_ * _loc2_;
         mScoreReportRoot.stats_a.alpha = _loc2_;
         mScoreReportRoot.stats_b.alpha = _loc2_;
         mScoreReportRoot.stats_c.alpha = _loc2_;
         mScoreReportRoot.stats_d.alpha = _loc2_;
         mScoreReportRoot.empty_banner_b.alpha = _loc2_;
         mScoreReportRoot.empty_banner_c.alpha = _loc2_;
         mScoreReportRoot.empty_banner_d.alpha = _loc2_;
         if(mCurrentMapNode.InfiniteDungeon != null)
         {
            mScoreReportRoot.banner_deco02.alpha = _loc2_;
            mScoreReportRoot.banner_deco01.alpha = _loc2_;
         }
         if(mScoreReportRoot.stats_a.alpha >= 0.95)
         {
            mScoreReportRoot.stats_a.alpha = 1;
            mScoreReportRoot.stats_b.alpha = 1;
            mScoreReportRoot.stats_c.alpha = 1;
            mScoreReportRoot.stats_d.alpha = 1;
            mScoreReportRoot.empty_banner_b.alpha = 1;
            mScoreReportRoot.empty_banner_c.alpha = 1;
            mScoreReportRoot.empty_banner_d.alpha = 1;
            if(mCurrentMapNode.InfiniteDungeon != null)
            {
               mScoreReportRoot.banner_deco02.alpha = 1;
               mScoreReportRoot.banner_deco01.alpha = 1;
            }
            mBannerFadeTask.destroy();
            mBannerFadeTask = null;
         }
      }
      
      private function revealBanners(param1:GameClock) : void
      {
         mScoreReportRoot.stats_a.visible = mDungeonReport[0].valid;
         mScoreReportRoot.stats_b.visible = mDungeonReport[1].valid;
         mScoreReportRoot.stats_c.visible = mDungeonReport[2].valid;
         mScoreReportRoot.stats_d.visible = mDungeonReport[3].valid;
         mScoreReportRoot.empty_banner_b.visible = !mDungeonReport[1].valid;
         mScoreReportRoot.empty_banner_c.visible = !mDungeonReport[2].valid;
         mScoreReportRoot.empty_banner_d.visible = !mDungeonReport[3].valid;
         mScoreReportRoot.stats_a.alpha = 0.05;
         mScoreReportRoot.stats_b.alpha = 0.05;
         mScoreReportRoot.stats_c.alpha = 0.05;
         mScoreReportRoot.stats_d.alpha = 0.05;
         mScoreReportRoot.empty_banner_b.alpha = 0.05;
         mScoreReportRoot.empty_banner_c.alpha = 0.05;
         mScoreReportRoot.empty_banner_d.alpha = 0.05;
         if(mCurrentMapNode.InfiniteDungeon != null)
         {
            mScoreReportRoot.banner_deco01.visible = true;
            mScoreReportRoot.banner_deco02.visible = true;
            mScoreReportRoot.banner_deco01.alpha = 0.05;
            mScoreReportRoot.banner_deco02.alpha = 0.05;
         }
         if(mBannerFadeTask)
         {
            mBannerFadeTask.destroy();
            mBannerFadeTask = null;
         }
         mBannerFadeTask = mWorkComponent.doEveryFrame(updateBannerAlpha);
      }
      
      private function onPlayerExit(param1:PlayerExitEvent) : void
      {
         var _loc6_:* = 0;
         var _loc3_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc8_:Array = null;
         var _loc7_:Array = [mScoreReportRoot.stats_a,mScoreReportRoot.stats_b,mScoreReportRoot.stats_c,mScoreReportRoot.stats_d];
         var _loc2_:Array = [mScoreReportRoot.empty_banner_b,mScoreReportRoot.empty_banner_b,mScoreReportRoot.empty_banner_c,mScoreReportRoot.empty_banner_d];
         _loc6_ = 0;
         while(_loc6_ < 4)
         {
            if(mDungeonReport[_loc6_].valid && mDungeonReport[_loc6_].id == param1.id)
            {
               _loc3_ = 0.212671;
               _loc5_ = 0.71516;
               _loc4_ = 0.072169;
               _loc8_ = [];
               _loc8_ = _loc8_.concat([_loc3_,_loc5_,_loc4_,0,0]);
               _loc8_ = _loc8_.concat([_loc3_,_loc5_,_loc4_,0,0]);
               _loc8_ = _loc8_.concat([_loc3_,_loc5_,_loc4_,0,0]);
               _loc8_ = _loc8_.concat([0,0,0,1,0]);
               _loc7_[_loc6_].filters = [new ColorMatrixFilter(_loc8_)];
            }
            _loc6_++;
         }
      }
      
      private function failureScoreReportSwfLoaded(param1:SwfAsset) : void
      {
         var _loc2_:Class = param1.getClass("DRfriends_UI_score_report_defeat");
         mScoreReportRoot = new _loc2_() as MovieClip;
         mUILootSlotsTwoTreasures = [[mScoreReportRoot.stats_a.stats.treasure.loot_slot_A1,mScoreReportRoot.stats_a.stats.treasure.loot_slot_A2,mScoreReportRoot.stats_a.stats.treasure.loot_slot_A3],[mScoreReportRoot.stats_b.stats.treasure.loot_slot_A1,mScoreReportRoot.stats_b.stats.treasure.loot_slot_A2,mScoreReportRoot.stats_b.stats.treasure.loot_slot_A3],[mScoreReportRoot.stats_c.stats.treasure.loot_slot_A1,mScoreReportRoot.stats_c.stats.treasure.loot_slot_A2,mScoreReportRoot.stats_c.stats.treasure.loot_slot_A3],[mScoreReportRoot.stats_d.stats.treasure.loot_slot_A1,mScoreReportRoot.stats_d.stats.treasure.loot_slot_A2,mScoreReportRoot.stats_d.stats.treasure.loot_slot_A3]];
         mUILootSlotsFourTreasures = [[mScoreReportRoot.stats_a.stats.treasure.loot_slot_B1,mScoreReportRoot.stats_a.stats.treasure.loot_slot_B2,mScoreReportRoot.stats_a.stats.treasure.loot_slot_B3,mScoreReportRoot.stats_a.stats.treasure.loot_slot_B4],[mScoreReportRoot.stats_b.stats.treasure.loot_slot_B1,mScoreReportRoot.stats_b.stats.treasure.loot_slot_B2,mScoreReportRoot.stats_b.stats.treasure.loot_slot_B3,mScoreReportRoot.stats_b.stats.treasure.loot_slot_B4],[mScoreReportRoot.stats_c.stats.treasure.loot_slot_B1,mScoreReportRoot.stats_c.stats.treasure.loot_slot_B2,mScoreReportRoot.stats_c.stats.treasure.loot_slot_B3,mScoreReportRoot.stats_c.stats.treasure.loot_slot_B4],[mScoreReportRoot.stats_d.stats.treasure.loot_slot_B1,mScoreReportRoot.stats_d.stats.treasure.loot_slot_B2,mScoreReportRoot.stats_d.stats.treasure.loot_slot_B3,mScoreReportRoot.stats_d.stats.treasure.loot_slot_B4]];
         setupUI();
      }
      
      private function successScoreReportSwfLoaded(param1:SwfAsset) : void
      {
         var _loc2_:Class = null;
         mDBFacade.metrics.log("DungeonLootSummary");
         if(mCurrentMapNode.InfiniteDungeon != null)
         {
            _loc2_ = param1.getClass("UI_score_report_infinite_island");
         }
         else
         {
            _loc2_ = param1.getClass("DRfriends_UI_score_report");
         }
         mScoreReportRoot = new _loc2_() as MovieClip;
         mUILootSlotsTwoTreasures = [[mScoreReportRoot.stats_a.stats.treasure.loot_slot_A1,mScoreReportRoot.stats_a.stats.treasure.loot_slot_A2,mScoreReportRoot.stats_a.stats.treasure.loot_slot_A3],[mScoreReportRoot.stats_b.stats.treasure.loot_slot_A1,mScoreReportRoot.stats_b.stats.treasure.loot_slot_A2,mScoreReportRoot.stats_b.stats.treasure.loot_slot_A3],[mScoreReportRoot.stats_c.stats.treasure.loot_slot_A1,mScoreReportRoot.stats_c.stats.treasure.loot_slot_A2,mScoreReportRoot.stats_c.stats.treasure.loot_slot_A3],[mScoreReportRoot.stats_d.stats.treasure.loot_slot_A1,mScoreReportRoot.stats_d.stats.treasure.loot_slot_A2,mScoreReportRoot.stats_d.stats.treasure.loot_slot_A3]];
         mUILootSlotsFourTreasures = [[mScoreReportRoot.stats_a.stats.treasure.loot_slot_B1,mScoreReportRoot.stats_a.stats.treasure.loot_slot_B2,mScoreReportRoot.stats_a.stats.treasure.loot_slot_B3,mScoreReportRoot.stats_a.stats.treasure.loot_slot_B4],[mScoreReportRoot.stats_b.stats.treasure.loot_slot_B1,mScoreReportRoot.stats_b.stats.treasure.loot_slot_B2,mScoreReportRoot.stats_b.stats.treasure.loot_slot_B3,mScoreReportRoot.stats_b.stats.treasure.loot_slot_B4],[mScoreReportRoot.stats_c.stats.treasure.loot_slot_B1,mScoreReportRoot.stats_c.stats.treasure.loot_slot_B2,mScoreReportRoot.stats_c.stats.treasure.loot_slot_B3,mScoreReportRoot.stats_c.stats.treasure.loot_slot_B4],[mScoreReportRoot.stats_d.stats.treasure.loot_slot_B1,mScoreReportRoot.stats_d.stats.treasure.loot_slot_B2,mScoreReportRoot.stats_d.stats.treasure.loot_slot_B3,mScoreReportRoot.stats_d.stats.treasure.loot_slot_B4]];
         setupUI();
      }
      
      private function addFriendCallback(param1:UIButton, param2:uint) : Function
      {
         var button:UIButton = param1;
         var idx:uint = param2;
         return function():void
         {
            if(mDBFacade.dbConfigManager.getConfigBoolean("FUFB",false))
            {
               mDBFacade.errorPopup("INVITE CURRENTLY DISABLED","Sorry for the inconvenience, we are looking into resolving the issue.");
               return;
            }
            findCorrectIcon(mDungeonReport[idx],addFriend,button);
         };
      }
      
      private function blockFriendCallback(param1:UIButton, param2:uint) : Function
      {
         var button:UIButton = param1;
         var idx:uint = param2;
         return function():void
         {
            findCorrectIcon(mDungeonReport[idx],blockFriend,button);
         };
      }
      
      private function findCorrectIcon(param1:DungeonReport, param2:Function, param3:UIButton) : void
      {
         var DR:DungeonReport = param1;
         var callBackFunc:Function = param2;
         var button:UIButton = param3;
         var iconContainer:MovieClip = new MovieClip();
         var skin:GMSkin = mDBFacade.gameMaster.getSkinByType(DR.skin_type);
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(skin.UISwfFilepath),function(param1:SwfAsset):void
         {
            Logger.debug("Entering findCorrectIcon trying to load iconName");
            var _loc3_:Class = param1.getClass(skin.IconName);
            var _loc2_:MovieClip = new _loc3_();
            UIObject.scaleToFit(_loc2_,65);
            iconContainer.addChild(_loc2_);
            saveFacebookPicAndAchievement(DR.id,iconContainer);
            Logger.debug("Exiting findCorrectIcon");
            callBackFunc(DR.name,iconContainer,DR.id,button);
         });
      }
      
      private function fadeAwayTitle() : void
      {
         TweenMax.to(mBgRenderer.clip,1,{
            "alpha":0,
            "onComplete":killFadeAwayTitle
         });
      }
      
      private function killFadeAwayTitle() : void
      {
         mScoreReportRoot.bg.visible = false;
         mBgRenderer.destroy();
         mBgRenderer = null;
      }
      
      private function setupUI() : void
      {
         var movieClipRenderer:MovieClipRenderController;
         var panel_idx:Array;
         var stats_panels:Array;
         var invInfo:DBInventoryInfo;
         var i:uint;
         var teamBonusUI:UIObject;
         var titleText:String;
         Logger.debug("in setupUI");
         if(mDBFacade.hud)
         {
            mDBFacade.hud.hideStacks();
         }
         mBgRenderer = new MovieClipRenderController(mDBFacade,mScoreReportRoot.bg);
         mBgRenderer.play();
         movieClipRenderer = new MovieClipRenderController(mDBFacade,mScoreReportRoot.rays);
         movieClipRenderer.play();
         mSceneGraphComponent.addChild(mScoreReportRoot,50);
         setupPortraits();
         panel_idx = [0,1,2,3];
         stats_panels = [mScoreReportRoot.stats_a,mScoreReportRoot.stats_b,mScoreReportRoot.stats_c,mScoreReportRoot.stats_d];
         mAddFriendButtons = [];
         mBlockFriendButtons = [];
         mItemButtons = [];
         invInfo = mDBFacade.dbAccountInfo.inventoryInfo;
         mBoosterXP = invInfo.findHighestBoosterXP();
         mBoosterGold = invInfo.findHighestBoosterGold();
         i = 0;
         while(i < 4)
         {
            isSingleChestList[i] = mCurrentMapNode.MinTreasure == 1 && !mDungeonReport[i].receivedTrophy;
            isSingleChestList[i] = false;
            if((mDungeonReport[i].account_flags & 1) != 0)
            {
               stats_panels[i].pennant.visible = false;
            }
            if(isSingleChestList[i])
            {
               stats_panels[i].stats.treasure.loot_slot_A1.visible = false;
               stats_panels[i].stats.treasure.loot_slot_A2.visible = false;
               stats_panels[i].stats.treasure.loot_slot_A3.visible = true;
            }
            else
            {
               stats_panels[i].stats.treasure.loot_slot_A1.visible = true;
               stats_panels[i].stats.treasure.loot_slot_A2.visible = true;
               stats_panels[i].stats.treasure.loot_slot_A3.visible = false;
            }
            stats_panels[i].stats.xp_bar.bonus_xp_reveal.Bonus_XP.text = Locale.getString("SUMMARY_BONUS_XP");
            stats_panels[i].stats.kills.enemies_killed_reveal.Enemies_Killed.text = Locale.getString("SUMMARY_ENEMIES_KILLED");
            stats_panels[i].stats.treasure.treasure_text.text = Locale.getString("SUMMARY_TREASURE");
            if(i == 0)
            {
               stats_panels[i].stats.text_booster.text = Locale.getString("ACTIVE_BOOSTERS");
               stats_panels[i].stats.text_booster.visible = false;
               if(mBoosterXP)
               {
                  mXPBoosterUI = new UIObject(mDBFacade,stats_panels[i].stats.boosterXP);
                  stats_panels[i].stats.boosterXP.label.text = mBoosterXP.BuffInfo.Exp + "X";
                  stats_panels[i].stats.boosterXP.tooltip.title_label.text = mBoosterXP.StackInfo.Name;
                  stats_panels[i].stats.boosterXP.visible = true;
                  mCountDownTextXP = new CountdownTextTimer(mXPBoosterUI.tooltip.time_label,mBoosterXP.getEndDate(),GameClock.getWebServerDate,null,Locale.getString("BOOSTER_REMAINING"),"",Locale.getString("EXPIRED"));
                  mCountDownTextXP.start();
                  stats_panels[i].stats.text_booster.visible = true;
               }
               else
               {
                  stats_panels[i].stats.boosterXP.visible = false;
               }
               if(mBoosterGold)
               {
                  mCoinBoosterUI = new UIObject(mDBFacade,stats_panels[i].stats.boosterCoin);
                  stats_panels[i].stats.boosterCoin.label.text = mBoosterGold.BuffInfo.Gold + "X";
                  stats_panels[i].stats.boosterCoin.tooltip.title_label.text = mBoosterGold.StackInfo.Name;
                  stats_panels[i].stats.boosterCoin.visible = true;
                  mCountDownTextGold = new CountdownTextTimer(mCoinBoosterUI.tooltip.time_label,mBoosterGold.getEndDate(),GameClock.getWebServerDate,null,Locale.getString("BOOSTER_REMAINING"),"",Locale.getString("EXPIRED"));
                  mCountDownTextGold.start();
                  stats_panels[i].stats.text_booster.visible = true;
               }
               else
               {
                  stats_panels[i].stats.boosterCoin.visible = false;
               }
            }
            mTeamBonusUI.add(i,new UIObject(mDBFacade,stats_panels[i].stats.crewbonus));
            teamBonusUI = mTeamBonusUI.itemFor(i);
            teamBonusUI.tooltip.title_label.text = Locale.getString("TEAM_BONUS_TOOLTIP_TITLE");
            teamBonusUI.tooltip.description_label.text = Locale.getString("TEAM_BONUS_TOOLTIP_DESCRIPTION");
            teamBonusUI.root.header_crew_bonus_number.text = mDungeonReport[i].totalAvatarsOwned - 1;
            teamBonusUI.root.xp.text = "0";
            teamBonusUI.visible = false;
            stats_panels[i].stats.doublexp_effect.visible = false;
            stats_panels[i].stats.doublexp_effect_star.visible = false;
            stats_panels[i].stats.doublxp_effect_flash_text.visible = false;
            if(i > 0)
            {
               stats_panels[i].stats.add_button.visible = false;
               stats_panels[i].stats.block_button.visible = false;
               stats_panels[i].stats.friend_indicator_icon.visible = false;
               stats_panels[i].stats.boosterXP.visible = false;
               stats_panels[i].stats.boosterCoin.visible = false;
               if(mDungeonReport[i].boost_xp > 1)
               {
                  mBoosterInfos.push(new UIObject(mDBFacade,stats_panels[i].stats.boosterXP));
                  stats_panels[i].stats.boosterXP.visible = true;
                  stats_panels[i].stats.boosterXP.label.text = mDungeonReport[i].boost_xp + "X";
                  stats_panels[i].stats.boosterXP.tooltip.title_label.text = Locale.getString("BOOST_XP_SUMMARY_TITLE");
                  stats_panels[i].stats.boosterXP.tooltip.time_label.text = Locale.getString("BOOST_XP_SUMMARY_DESCRIPTION") + mDungeonReport[i].boost_xp + "X";
               }
               if(mDungeonReport[i].boost_gold > 1)
               {
                  mBoosterInfos.push(new UIObject(mDBFacade,stats_panels[i].stats.boosterCoin));
                  stats_panels[i].stats.boosterCoin.visible = true;
                  stats_panels[i].stats.boosterCoin.label.text = mDungeonReport[i].boost_gold + "X";
                  stats_panels[i].stats.boosterCoin.tooltip.title_label.text = Locale.getString("BOOST_GOLD_SUMMARY_TITLE");
                  stats_panels[i].stats.boosterCoin.tooltip.time_label.text = Locale.getString("BOOST_GOLD_SUMMARY_DESCRIPTION") + mDungeonReport[i].boost_gold + "X";
               }
            }
            stats_panels[i].stats.friend_name.visible = false;
            if(i > 0)
            {
               if(mDBFacade.dbAccountInfo.isFriend(mDungeonReport[i].id))
               {
                  stats_panels[i].stats.friend_indicator_icon.visible = true;
                  stats_panels[i].stats.friend_name.visible = true;
                  stats_panels[i].stats.friend_name.text = mDungeonReport[i].name;
                  stats_panels[i].stats.player_name.visible = false;
               }
               else
               {
                  stats_panels[i].stats.friend_indicator_icon.visible = false;
                  stats_panels[i].stats.friend_name.visible = false;
                  stats_panels[i].stats.player_name.visible = true;
               }
               if(!stats_panels[i].stats.friend_indicator_icon.visible)
               {
                  stats_panels[i].stats.add_button.visible = true;
                  stats_panels[i].stats.add_button.label.text = Locale.getString("ADD_FRIEND");
                  mAddFriendButtons.push(new UIButton(mDBFacade,stats_panels[i].stats.add_button));
                  mAddFriendButtons[mAddFriendButtons.length - 1].releaseCallback = addFriendCallback(mAddFriendButtons[mAddFriendButtons.length - 1],i);
                  stats_panels[i].stats.block_button.visible = true;
                  stats_panels[i].stats.block_button.label.text = Locale.getString("BLOCK");
                  mBlockFriendButtons.push(new UIButton(mDBFacade,stats_panels[i].stats.block_button));
                  mBlockFriendButtons[mBlockFriendButtons.length - 1].releaseCallback = blockFriendCallback(mBlockFriendButtons[mBlockFriendButtons.length - 1],i);
               }
            }
            if(i == 0)
            {
               mXPBonusStarEffect = stats_panels[i].stats.doublexp_effect_star;
               mXPBonusBarEffect = stats_panels[i].stats.doublexp_effect;
               mXPBonusTextFlash = stats_panels[i].stats.doublxp_effect_flash_text;
               mXPBonusText = mXPBonusTextFlash.doublexp_text;
            }
            stats_panels[i].visible = mDungeonReport[i].valid;
            stats_panels[i].stats.kills.enemies_killed.kills.text = mDungeonReport[i].kills.toString();
            stats_panels[i].stats.xp_bar.bonus_xp.xp.text = "0";
            stats_panels[i].stats.xp_bar.tooltip.visible = false;
            mItemButtons[i] = [];
            ++i;
         }
         mScoreReportRoot.bg.banner_text.dungeon_title.text = mDungeonName != null ? mDungeonName.toUpperCase() : "DUNGEON NAME";
         titleText = this.dungeonSuccess ? Locale.getString("VICTORY") : Locale.getString("DUNGEON_FAILED");
         if(mCurrentMapNode.InfiniteDungeon != null)
         {
            titleText = Locale.getString("CASHED_OUT");
         }
         mScoreReportRoot.bg.banner_text.title.text = titleText;
         setupXPBars();
         setupLoot();
         setupChat();
         setupWeapons();
         mEventComponent.addListener("PlayerExitEvent_str",onPlayerExit);
         hideBanners();
         mWorkComponent.doLater(0.625,revealBanners);
         mTreasureTick = 0;
         mRevealState = 1;
         updateRevealState(null);
         Logger.debug("in setupUI: Initializing mDungeonAchievementPanelMovieClipRenderer");
         mDungeonAchievementPanelMovieClipRenderer = new MovieClipRenderer(mDBFacade,mScoreReportRoot.achievement,destroyAchievementBossPanel);
         mDungeonAchievementPanelMovieClipRenderer.clip.visible = false;
         mScoreReportRoot.achievement.label.label.text = Locale.getString("DUNGEON_SUMMARY_REWARD_PANEL_LABEL");
         if(mCurrentMapNode.InfiniteDungeon != null)
         {
            mScoreReportRoot.achievement.label_boss.label.text = Locale.getString("DUNGEON_SUMMARY_REWARD_PANEL_LABEL_INFINITE");
         }
         else
         {
            mScoreReportRoot.achievement.label_boss.label.text = Locale.getString("DUNGEON_SUMMARY_REWARD_PANEL_LABEL_BOSS");
         }
         Logger.debug("in setupUI: Finished Initializing mDungeonAchievementPanelMovieClipRenderer");
         if(mDungeonReport[0].receivedTrophy)
         {
            Logger.debug("in setupUI: has mDungeonReport[0].receivedTrophy");
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/Doobers/db_items_doobers.swf"),function(param1:SwfAsset):void
            {
               var _loc4_:GMChest = null;
               var _loc3_:String = null;
               var _loc2_:String = null;
               var _loc5_:uint = mDungeonReport[0].loot_type_2 > 0 ? mDungeonReport[0].loot_type_2 : mDungeonReport[0].loot_type_1;
               if(_loc5_ && !mCurrentMapNode.InfiniteDungeon)
               {
                  _loc4_ = mDBFacade.gameMaster.chestsById.itemFor(_loc5_);
                  _loc3_ = _loc4_.IconSwf;
                  _loc2_ = _loc4_.IconName;
                  ChestInfo.loadItemIcon(_loc3_,_loc2_,mScoreReportRoot.achievement.chest,mDBFacade,400,150,mAssetLoadingComponent);
               }
            });
         }
         if(mScoreReportRoot.achievement.chest)
         {
            Logger.debug("in setupUI: has mScoreReportRoot.achievement.chest");
            mScoreReportRoot.achievement.chest.defaultPic.visible = false;
         }
      }
      
      private function destroyAchievementBossPanel() : void
      {
         Logger.debug("entering destroyAchievementBossPanel");
         if(!mDungeonAchievementPanelMovieClipRenderer)
         {
            Logger.error("destroyAchievementBossPanel: Would have tried to do something to a null mDungeonAchievementPanelMovieClipRenderer");
         }
         mDungeonAchievementPanelMovieClipRenderer.destroy();
         if(!mScoreReportRoot)
         {
            Logger.error("destroyAchievementBossPanel: Would have tried to do something to a null mScoreReportRoot");
         }
         if(mScoreReportRoot && !mScoreReportRoot.achievement)
         {
            Logger.error("destroyAchievementBossPanel: Would have tried to do something to a null mScoreReportRoot.achievement");
         }
         mScoreReportRoot.achievement.visible = false;
         Logger.debug("exiting destroyAchievementBossPanel");
      }
      
      private function parseJson(param1:*) : Object
      {
         var _loc2_:Array = null;
         var _loc4_:Object = null;
         var _loc3_:* = undefined;
         if(getQualifiedClassName(param1) == "Array")
         {
            _loc2_ = param1[0];
            _loc4_ = param1[1];
            _loc3_ = new Vector.<uint>();
            _loc3_.push(_loc4_.account_id);
            PresenceManager.instance().addFriends(_loc3_);
            mDBFacade.dbAccountInfo.addFriendCallback(_loc2_);
         }
         else
         {
            _loc4_ = param1 as Object;
         }
         Logger.debug("friendRequest: id:" + _loc4_.id + " from:" + _loc4_.account_id + " to:" + _loc4_.to_account_id + " state:" + _loc4_.curr_state);
         return _loc4_;
      }
      
      private function addFriend(param1:String, param2:MovieClip, param3:uint, param4:UIButton) : void
      {
         var personName:String = param1;
         var iconMC:MovieClip = param2;
         var personId:uint = param3;
         var button:UIButton = param4;
         var rpcFunc:Function = JSONRPCService.getFunction("DRFriendRequest",mDBFacade.rpcRoot + "friendrequests");
         var rpcSuccessCallback:Function = function(param1:*):void
         {
            var _loc2_:Object = null;
            if(param1 == null || param1.length <= 0)
            {
               Logger.warn("Komo?");
            }
            else
            {
               _loc2_ = parseJson(param1);
               Logger.debug("Successful add friend.");
               mEventComponent.dispatchEvent(new FriendSummaryNewsFeedEvent("FRIEND_SUMMARY_NEWS_FEED_MESSAGE_EVENT",Locale.getString("Friend_Request_Sent_to_"),iconMC,personName));
               mDBFacade.metrics.log("DRFriendRequest",{"friendId":_loc2_.to_account_id});
            }
            button.enabled = false;
         };
         rpcFunc(mDBFacade.dbAccountInfo.name,mDBFacade.dbAccountInfo.trophies,mDBFacade.dbAccountInfo.activeAvatarSkinId,mDBFacade.dbAccountInfo.facebookId,mDBFacade.dbAccountInfo.id,personId,mDBFacade.demographics,mDBFacade.validationToken,rpcSuccessCallback);
      }
      
      private function blockFriend(param1:String, param2:MovieClip, param3:uint, param4:UIButton) : void
      {
         var personName:String = param1;
         var iconMC:MovieClip = param2;
         var personId:uint = param3;
         var button:UIButton = param4;
         var rpcSuccessCallback:Function = function(param1:*):void
         {
            var _loc2_:String = null;
            if(param1 == null || param1.length <= 0)
            {
               Logger.warn("Komo?");
            }
            else
            {
               Logger.debug("Successful block friend");
               mEventComponent.dispatchEvent(new FriendSummaryNewsFeedEvent("FRIEND_SUMMARY_NEWS_FEED_MESSAGE_EVENT",Locale.getString("_has_been_blocked"),iconMC,personName,true));
               _loc2_ = param1;
               mDBFacade.metrics.log("DRFriendIgnore",{"friendId":_loc2_.substr(1,_loc2_.length - 2)});
            }
         };
         mDRFriendBlockPopup = new DBUITwoButtonPopup(mDBFacade,Locale.getString("BLOCK") + " " + personName + "?",personName + Locale.getString("VICTORY_SCREEN_BLOCK_POPUP_MESSAGE"),Locale.getString("BLOCK"),function():void
         {
            var _loc1_:Function = JSONRPCService.getFunction("IgnoreFriend",mDBFacade.rpcRoot + "friendrequests");
            _loc1_(mDBFacade.dbAccountInfo.id,personId,mDBFacade.validationToken,rpcSuccessCallback);
            button.enabled = false;
         },Locale.getString("CANCEL"),null);
         var tf:TextFormat = new TextFormat();
         tf.color = FriendSummaryNewsFeedEvent.FRIEND_NAME_HIGHLIGHT_COLOR;
         mDRFriendBlockPopup.colorizeMessage(tf,0,personName.length);
      }
      
      override public function destroy() : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:FacebookPicHelper = null;
         var _loc4_:* = 0;
         var _loc7_:* = 0;
         if(mCountDownTextXP != null)
         {
            mCountDownTextXP.destroy();
         }
         if(mCountDownTextGold != null)
         {
            mCountDownTextGold.destroy();
         }
         for each(var _loc3_ in mTeamBonusUI)
         {
            _loc3_.destroy();
         }
         mTeamBonusUI = null;
         mSmashSfx = null;
         mLevelSfx = null;
         if(mChestRevealPopUp)
         {
            mChestRevealPopUp.destroy();
            mChestRevealPopUp = null;
         }
         if(mChestKeySlots)
         {
            _loc5_ = 0;
            while(_loc5_ < mChestKeySlots.length)
            {
               mChestKeySlots[_loc5_].destroy();
               _loc5_++;
            }
         }
         mChestKeySlots = null;
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         mSoundComponent.destroy();
         mSoundComponent = null;
         if(mStorageFullPopUp != null)
         {
            mStorageFullPopUp.destroy();
            mStorageFullPopUp = null;
         }
         if(mUIInventory != null)
         {
            mUIInventory.destroy();
            mUIInventory = null;
         }
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            _loc6_ = 0;
            while(_loc6_ < 2)
            {
               mSceneGraphComponent.removeChild(mChestMovieClips[_loc4_][_loc6_]);
               _loc6_++;
            }
            _loc4_++;
         }
         mChestMovieClips = null;
         mDBFacade.regainFocus();
         if(mSceneGraphComponent.contains(mFacebookPicHolder,105))
         {
            mSceneGraphComponent.removeChild(mFacebookPicHolder);
         }
         mFacebookPicHolder = null;
         var _loc1_:Array = mFacebookPicMap.keysToArray();
         for each(var _loc8_ in _loc1_)
         {
            _loc2_ = mFacebookPicMap.itemFor(_loc8_);
            if(_loc2_)
            {
               _loc2_.destroy();
            }
            _loc2_ = null;
         }
         mFacebookPicMap.clear();
         closeBoosterPopup();
         mEventComponent.destroy();
         mWorkComponent.destroy();
         mChatEventComponent.destroy();
         mWorkComponent = null;
         mChatEventComponent = null;
         mBonusXPTick = null;
         mTeamBonusXPTick = null;
         mKillsTick = null;
         mXPBonusStarEffect = null;
         mXPBonusBarEffect = null;
         mXPBonusTextFlash = null;
         mXPBonusText = null;
         _loc4_ = 0;
         while(_loc4_ < mAddFriendButtons.length)
         {
            mAddFriendButtons[_loc4_].destroy();
            _loc4_++;
         }
         mAddFriendButtons = null;
         _loc4_ = 0;
         while(_loc4_ < mBlockFriendButtons.length)
         {
            mBlockFriendButtons[_loc4_].destroy();
            _loc4_++;
         }
         mBlockFriendButtons = null;
         _loc4_ = 0;
         while(_loc4_ < mBoosterInfos.length)
         {
            mBoosterInfos[_loc4_].destroy();
            _loc4_++;
         }
         mBoosterInfos = null;
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            _loc7_ = 0;
            while(_loc7_ < 2)
            {
               if(mItemButtons[_loc4_][_loc7_])
               {
                  mItemButtons[_loc4_][_loc7_].destroy();
                  mItemButtons[_loc4_][_loc7_] = null;
               }
               _loc7_++;
            }
            _loc4_++;
         }
         mItemButtons = null;
         if(mTownHeader)
         {
            mTownHeader.destroy();
            mTownHeader = null;
         }
         if(mAssetLoadingComponent)
         {
            mAssetLoadingComponent.destroy();
            mAssetLoadingComponent = null;
         }
         if(mScoreReportRoot)
         {
            mSceneGraphComponent.removeChild(mScoreReportRoot);
         }
         if(mSceneGraphComponent)
         {
            mSceneGraphComponent.destroy();
            mSceneGraphComponent = null;
         }
         mUIChatLog.destroy();
         _loc4_ = 0;
         while(_loc4_ < mChestRenderers.length)
         {
            mChestRenderers[_loc4_].destroy();
            _loc4_++;
         }
         mChestRenderers = null;
      }
      
      public function set dungeon_name(param1:String) : void
      {
         mDungeonName = param1;
      }
      
      public function set report(param1:Vector.<DungeonReport>) : void
      {
         var _loc4_:* = 0;
         var _loc2_:DungeonReport = null;
         var _loc3_:int = 0;
         var _loc6_:Array = null;
         mDungeonReport = param1;
         _loc4_ = 0;
         while(_loc4_ < 4)
         {
            if(mDungeonReport[_loc4_].id == mDBFacade.accountId)
            {
               _loc2_ = mDungeonReport[_loc4_];
               mDungeonReport[_loc4_] = mDungeonReport[0];
               mDungeonReport[0] = _loc2_;
               break;
            }
            _loc4_++;
         }
         var _loc5_:Array = [mDungeonReport[0].chest_type_1,mDungeonReport[0].chest_type_2,mDungeonReport[0].chest_type_3,mDungeonReport[0].chest_type_4];
         mSortedLootData = [];
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc6_ = [_loc3_,_loc5_[_loc3_]];
            mSortedLootData.push(_loc6_);
            _loc3_++;
         }
         mSortedLootData.sort(compareOnChestValues);
      }
      
      public function set map_node_id(param1:uint) : void
      {
         mMapNodeId = param1;
      }
      
      public function set dungeonMod1(param1:uint) : void
      {
         mDungeonMod1 = param1;
      }
      
      public function set dungeonMod2(param1:uint) : void
      {
         mDungeonMod2 = param1;
      }
      
      public function set dungeonMod3(param1:uint) : void
      {
         mDungeonMod3 = param1;
      }
      
      public function set dungeonMod4(param1:uint) : void
      {
         mDungeonMod4 = param1;
      }
      
      public function get report() : Vector.<DungeonReport>
      {
         return mDungeonReport;
      }
      
      private function trySurveyLink() : void
      {
         var popup:DBUITwoButtonPopup;
         var surveyName:String = "SURVEY_" + mDBFacade.dbConfigManager.getConfigString("survey_name","XHBQPFS");
         var surveyURL:String = mDBFacade.dbConfigManager.getConfigString("survey_url","");
         var alreadyCompleted:Boolean = mDBFacade.dbAccountInfo.getAttribute(surveyName) == "1";
         if(surveyURL && !alreadyCompleted)
         {
            surveyURL += "?c=" + mDBFacade.accountId;
            popup = new DBUITwoButtonPopup(mDBFacade,Locale.getString("SURVEY_POPUP_TITLE"),Locale.getString("SURVEY_POPUP_MESSAGE"),Locale.getString("SURVEY_CANCEL"),function():void
            {
               Logger.info("trySurveyLink cancel: " + surveyURL);
               returnToSplashScreen();
            },Locale.getString("SURVEY_GO"),function():void
            {
               var _loc1_:URLRequest = new URLRequest(surveyURL);
               navigateToURL(_loc1_,"_blank");
               Logger.info("trySurveyLink opened: " + surveyURL);
            });
            mDBFacade.dbAccountInfo.alterAttribute(surveyName,"1");
         }
         else
         {
            returnToSplashScreen();
         }
      }
      
      private function tryReturnToSplashScreen() : void
      {
         var _loc1_:DBUITwoButtonPopup = null;
         if(mItemCount > 0)
         {
            _loc1_ = new DBUITwoButtonPopup(mDBFacade,Locale.getString("ABANDON_ITEMS_TITLE"),Locale.getString("ABANDON_ITEMS_MESSAGE"),Locale.getString("ABANDON_YES"),trySurveyLink,Locale.getString("CANCEL"),null);
         }
         else
         {
            trySurveyLink();
         }
      }
      
      private function openInventory() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         mUIInventory = new UIInventory(mDBFacade,mTownHeader,this);
         mUIInventory.setRevealedState(mRevealedItemType,mRevealedItemOfferId,mRevealedItemCallEquip);
         mUIInventory.show(mSelectedGMChest);
         mTownHeader.showCloseButton(true);
         mScoreReportRoot.addChild(mUIInventory.root);
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = 0;
            while(_loc2_ < 2)
            {
               if(mChestMovieClips[_loc1_][_loc2_] != null)
               {
                  mChestMovieClips[_loc1_][_loc2_].visible = false;
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function closeHeader() : void
      {
         if(mUIInventory)
         {
            closeInventory();
         }
         else
         {
            tryReturnToSplashScreen();
         }
      }
      
      private function closeInventory() : void
      {
         var _loc2_:int = 0;
         mScoreReportRoot.removeChild(mUIInventory.root);
         mUIInventory.destroy();
         mUIInventory = null;
         mTownHeader.showCloseButton(true);
         mTownHeader.title = this.dungeonSuccess ? Locale.getString("VICTORY") : Locale.getString("DUNGEON_FAILED");
         var _loc1_:Array = [mDungeonReport[0].chest_type_1,mDungeonReport[0].chest_type_2,mDungeonReport[0].chest_type_3,mDungeonReport[0].chest_type_4];
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            if(mChestMovieClips[0][_loc2_])
            {
               if(_loc1_[_loc2_] == 0)
               {
                  mChestMovieClips[0][_loc2_].visible = false;
               }
               else
               {
                  mChestMovieClips[0][_loc2_].visible = true;
               }
            }
            _loc2_++;
         }
      }
      
      private function returnToSplashScreen() : void
      {
         mDBFacade.mDistributedObjectManager.mMatchMaker.RequestExit();
      }
   }
}

import flash.display.DisplayObject;
import flash.display.MovieClip;

class FacebookPicHelper
{
   
   public var pic:DisplayObject;
   
   public var root:MovieClip;
   
   public function FacebookPicHelper()
   {
      super();
   }
   
   public function destroy() : void
   {
      pic = null;
      root = null;
   }
}
