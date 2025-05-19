package UI
{
   import Account.BoosterInfo;
   import Account.CurrencyUpdatedAccountEvent;
   import Account.StoreServicesController;
   import Actor.Buffs.BuffGameObject;
   import Actor.Buffs.BuffHandler;
   import Actor.FloatingMessage;
   import Actor.Pets.PetPortraitUI;
   import Actor.Player.Input.DungeonBusterControlActivatedEvent;
   import Actor.Revealer;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.Render.MovieClipRenderController;
   import Brain.Render.MovieClipRenderer;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.UI.UIButton;
   import Brain.UI.UIObject;
   import Brain.UI.UIProgressBar;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import Combat.Weapon.ConsumableWeaponGameObject;
   import Combat.Weapon.WeaponGameObject;
   import DistributedObjects.HeroGameObjectOwner;
   import DistributedObjects.NPCGameObject;
   import Events.ActorInvulnerableEvent;
   import Events.BusterPointsEvent;
   import Events.ExperienceEvent;
   import Events.GameObjectEvent;
   import Events.HpEvent;
   import Events.ManaEvent;
   import Events.UIHudChangeEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import Floor.DungeonModifierHelper;
   import GameMasterDictionary.GMAttack;
   import GameMasterDictionary.GMRarity;
   import GameMasterDictionary.GMSkin;
   import GameMasterDictionary.GMStackable;
   import GameMasterDictionary.GMWeaponAesthetic;
   import GameMasterDictionary.GMWeaponItem;
   import UI.InfiniteIsland.II_UIExitDungeonPopUp;
   import UI.Inventory.UIWeaponTooltip;
   import UI.Options.OptionsPanel;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class UIHud
   {
      
      private static const CONDENSEDHUD_BUFF_ICON_X_STARTPOS:int = 300;
      
      private static const CONDENSEDHUD_BUFF_ICON_Y_STARTPOS:int = 490;
      
      private static const CONDENSEDHUD_BUFF_ICON_X_DISPLACEMENT:int = 35;
      
      private static const OLDHUD_BUFF_ICON_X_STARTPOS:int = 300;
      
      private static const OLDHUD_BUFF_ICON_Y_STARTPOS:int = 550;
      
      private static const OLDHUD_BUFF_ICON_X_DISPLACEMENT:int = 35;
      
      private static const MAX_CHAT_CHARS:uint = 44;
      
      private static const TEAMLOOT_POS:int = 40;
      
      private static const TEAMLOOT_VISIBLE_TIME:Number = 2;
      
      private static const TEAMLOOT_TWEEN_TIME:Number = 0.5;
      
      public static const UI_HUD_SWF_PATH:String = "Resources/Art2D/UI/db_UI_HUD.swf";
      
      public static const UI_HUD_CHANGE_EVENT:String = "UI_HUD_CHANGE_EVENT";
      
      private static const PET_PORTRAIT_SPACING:uint = 69;
      
      private static const PET_PORTRAIT_YPOS:uint = 85;
      
      private static const PET_PORTRAIT_START_XPOS:uint = 20;
      
      private static const ORIGINAL_COOLDOWN_ANIM_PLAY_TIME:Number = 4.1;
      
      public static const COMMON_CHEST_ID:uint = 60001;
      
      public static const UNCOMMON_CHEST_ID:uint = 60002;
      
      public static const RARE_CHEST_ID:uint = 60003;
      
      public static const LEGENDARY_CHEST_ID:uint = 60004;
      
      public static const SMALL_ITEM_BOX_ID:uint = 60005;
      
      public static const ROYAL_ITEM_BOX_ID:uint = 60006;
      
      private static const TEAM_DEFAULT:Vector3D = new Vector3D(45,150);
      
      private static const PROFILE_DEFAULT:Vector3D = new Vector3D(60,50);
      
      private static const COINS_DEFAULT:Vector3D = new Vector3D(285,40);
      
      private static const CASH_DEFAULT:Vector3D = new Vector3D(405,40);
      
      private static const EXP_DEFAULT:Vector3D = new Vector3D(570,45);
      
      private static const CROWD_DEFAULT:Vector3D = new Vector3D(735,570);
      
      private static const TEAM_CONDENSED:Vector3D = new Vector3D(45,150);
      
      private static const PROFILE_CONDENSED:Vector3D = new Vector3D(20,516);
      
      private static const COINS_CONDENSED:Vector3D = new Vector3D(72,549);
      
      private static const CASH_CONDENSED:Vector3D = new Vector3D(72,549);
      
      private static const EXP_CONDENSED:Vector3D = new Vector3D(20,516);
      
      private static const CROWD_CONDENSED:Vector3D = new Vector3D(596,508);
      
      private var mDBFacade:DBFacade;
      
      private var mHeroOwner:HeroGameObjectOwner;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mWantPets:Boolean = false;
      
      private var mAssetsLoaded:Boolean = false;
      
      private var mRoot:Sprite;
      
      private var mUIRoot:MovieClip;
      
      private var mAddCoinButton:UIButton;
      
      private var mAddCashButton:UIButton;
      
      private var mProfileBox:MovieClip;
      
      private var mProfileBulgeTask:Task;
      
      private var mFloaterTextClass:Class;
      
      private var mHpBar:UIProgressBar;
      
      private var mHpText:TextField;
      
      private var mFlashingHpBar:UIProgressBar;
      
      private var mHealthFullClip:TextField;
      
      private var mManaFullClip:TextField;
      
      private var mManaBar:UIProgressBar;
      
      private var mManaText:TextField;
      
      private var mBusterBar:UIProgressBar;
      
      private var mBusterValue:uint;
      
      private var mBusterRoot:MovieClip;
      
      private var mBasicCurrency:uint;
      
      private var mPremiumCurrency:uint;
      
      private var mBasicCurrencyUI:UIObject;
      
      private var mPremiumCurrencyUI:UIObject;
      
      private var mBasicCurrencyText:TextField;
      
      private var mPremiumCurrencyText:TextField;
      
      private var mLevelText:TextField;
      
      private var mXpObject:UIObject;
      
      private var mXpBar:UIProgressBar;
      
      private var mXpText:TextField;
      
      private var mXpGotInitialUpdate:Boolean;
      
      private var mXpBulgeTask:Task;
      
      private var mXpValue:uint;
      
      private var mTeamLootMC:MovieClipRenderController;
      
      private var mLootTween:TweenMax;
      
      private var mLootTask:Task;
      
      private var mLootMouseArea:Sprite;
      
      private var mCloseButton:UIButton;
      
      private var mWeaponZButton:UIButton;
      
      private var mWeaponXButton:UIButton;
      
      private var mWeaponCButton:UIButton;
      
      private var mWeaponButtons:Vector.<UIButton>;
      
      private var mConsumable1Button:UIButton;
      
      private var mConsumable2Button:UIButton;
      
      private var mConsumableWeaponButtons:Vector.<UIButton>;
      
      private var mCooldowns:Vector.<MovieClipRenderer>;
      
      private var mConsumableCooldowns:Vector.<MovieClipRenderer>;
      
      private var mDungeonBusterButton:UIButton;
      
      private var mBusterLabel:TextField;
      
      private var mBusterLabelOver:TextField;
      
      private var mBusterGlowMc:MovieClipRenderController;
      
      private var mXPBonusText:TextField;
      
      private var mCoinBonusText:TextField;
      
      private var mOptionsButton:UIButton;
      
      private var mOptionsPanel:OptionsPanel;
      
      private var mStacksHud:UIStacksHud;
      
      private var mEventComponent:EventComponent;
      
      protected var mUITask:Task;
      
      protected var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mSwfAsset:SwfAsset;
      
      protected var mOffScreenPlayerManager:UIOffScreenPlayerManager;
      
      private var mMaxBusterPoints:uint;
      
      private var mUIChatLog:UIChatLog;
      
      private var mSaleLabel:TextField;
      
      private var mHealthFullRevealer:Revealer;
      
      private var mManaFullRevealer:Revealer;
      
      private var mHealthFullFloater:FloatingMessage;
      
      private var mManaFullFloater:FloatingMessage;
      
      private var mPetPortraitRoot:MovieClip;
      
      private var mPetPortraitNoneRoot:MovieClip;
      
      private var mPetPortrait:PetPortraitUI;
      
      private var mFloorLabel:TextField;
      
      private var mDungeonModifer1:UIButton;
      
      private var mDungeonModifer2:UIButton;
      
      private var mDungeonModifer3:UIButton;
      
      private var mDungeonModifer4:UIButton;
      
      private var mTeamLootDestination:Vector3D;
      
      private var mProfileDestination:Vector3D;
      
      private var mCoinsDestination:Vector3D;
      
      private var mCashDestination:Vector3D;
      
      private var mExpDestination:Vector3D;
      
      private var mCrowdDestination:Vector3D;
      
      private var mBoosterTimer:Timer;
      
      private var mHudType:uint;
      
      private var mVerticalYClipping:Number;
      
      private var mBuffs:Vector.<BuffGameObject>;
      
      private var mBuffIconButtons:Vector.<UIButton>;
      
      private var mBuffCooldowns:Vector.<MovieClipRenderer>;
      
      public function UIHud(param1:DBFacade)
      {
         var facade:DBFacade = param1;
         super();
         mDBFacade = facade;
         mRoot = new Sprite();
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         mMaxBusterPoints = 4294967295;
         mOptionsPanel = new OptionsPanel(mDBFacade);
         mStacksHud = new UIStacksHud(mDBFacade);
         mEventComponent = new EventComponent(mDBFacade);
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_HUD.swf"),function(param1:SwfAsset):void
         {
            setupUI(param1,parseInt(mDBFacade.dbAccountInfo.getAttribute("optionsHudStyle")));
         });
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),setupOptions);
         mXpBulgeTask = null;
         mProfileBulgeTask = null;
         mBuffs = new Vector.<BuffGameObject>();
         mBuffIconButtons = new Vector.<UIButton>();
         mBuffCooldowns = new Vector.<MovieClipRenderer>();
      }
      
      public static function isThisAConsumbleChestId(param1:int) : Boolean
      {
         return param1 == 60005 || param1 == 60006;
      }
      
      private function switchHudEvent(param1:UIHudChangeEvent) : void
      {
         this.setupUI(mSwfAsset,param1.hudType);
         resetBuffButtonPositions();
      }
      
      private function determineSaleVisibility() : void
      {
         var _loc1_:Number = UICashPage.getCashSaleValue(mDBFacade);
         if(_loc1_ < 1)
         {
            mSaleLabel.visible = true;
         }
      }
      
      public function get chatLogContainer() : MovieClip
      {
         return mUIRoot.chatLogContainer;
      }
      
      public function get ownedHero() : HeroGameObjectOwner
      {
         return mHeroOwner;
      }
      
      public function get swfAsset() : SwfAsset
      {
         return mSwfAsset;
      }
      
      private function setupOptions(param1:SwfAsset) : void
      {
         var _loc2_:Class = param1.getClass("options_panel_button");
         var _loc7_:MovieClip = new _loc2_() as MovieClip;
         mOptionsButton = new UIButton(mDBFacade,_loc7_);
         mOptionsButton.releaseCallback = mOptionsPanel.toggleVisible;
         var _loc4_:Number = mDBFacade.dbConfigManager.getConfigNumber("in_game_options_button_x",735);
         var _loc3_:Number = mDBFacade.dbConfigManager.getConfigNumber("in_game_options_button_y",65);
         var _loc5_:Number = mDBFacade.dbConfigManager.getConfigNumber("in_game_options_button_scale_x",0.5);
         var _loc6_:Number = mDBFacade.dbConfigManager.getConfigNumber("in_game_options_button_scale_y",0.5);
         _loc7_.x = _loc4_;
         _loc7_.y = _loc3_;
         _loc7_.scaleX = _loc5_;
         _loc7_.scaleY = _loc6_;
         setOptionsBasedOnHud();
      }
      
      private function setDooberLocations(param1:uint) : void
      {
         switch(int(param1))
         {
            case 0:
               mTeamLootDestination = TEAM_DEFAULT;
               mProfileDestination = PROFILE_DEFAULT;
               mCoinsDestination = COINS_DEFAULT;
               mCashDestination = CASH_DEFAULT;
               mExpDestination = EXP_DEFAULT;
               mCrowdDestination = CROWD_DEFAULT;
               break;
            case 1:
               mTeamLootDestination = TEAM_CONDENSED;
               mProfileDestination = PROFILE_CONDENSED;
               mCoinsDestination = COINS_CONDENSED;
               mCashDestination = CASH_CONDENSED;
               mExpDestination = EXP_CONDENSED;
               mCrowdDestination = CROWD_CONDENSED;
               break;
            default:
               mTeamLootDestination = TEAM_DEFAULT;
               mProfileDestination = PROFILE_DEFAULT;
               mCoinsDestination = COINS_DEFAULT;
               mCashDestination = CASH_DEFAULT;
               mExpDestination = EXP_DEFAULT;
               mCrowdDestination = CROWD_DEFAULT;
         }
      }
      
      private function setupUI(param1:SwfAsset, param2:uint = 0) : void
      {
         var hudClassName:String;
         var hudClass:Class;
         var i:uint;
         var tooltipOffsset:Point;
         var swfAsset:SwfAsset = param1;
         var hudType:uint = param2;
         mHudType = hudType;
         if(mUIRoot && mRoot.contains(mUIRoot))
         {
            mRoot.removeChild(mUIRoot);
         }
         mSwfAsset = swfAsset;
         switch(int(hudType))
         {
            case 0:
               hudClassName = "ui_hud_old";
               mDBFacade.camera.offset = new Point(0,45);
               mVerticalYClipping = 0;
               break;
            case 1:
               hudClassName = "ui_hud";
               mDBFacade.camera.offset = new Point(0,0);
               mVerticalYClipping = 90;
               break;
            default:
               hudClassName = "ui_hud_old";
               mDBFacade.camera.offset = new Point(0,45);
               mVerticalYClipping = 0;
               Logger.warn("Unable to determine hud with type: " + hudType);
         }
         setOptionsBasedOnHud();
         setDooberLocations(mHudType);
         mDBFacade.camera.yCilppingFromBottom = mVerticalYClipping;
         mDBFacade.camera.forceRedraw();
         hudClass = swfAsset.getClass(hudClassName);
         mUIRoot = new hudClass();
         mRoot.addChild(mUIRoot);
         mFloaterTextClass = swfAsset.getClass("floater_text");
         mStacksHud.initializeHud(swfAsset.getClass("stacks_hud"));
         if(mUIChatLog)
         {
            mUIChatLog.destroy();
         }
         mUIChatLog = new UIChatLog(mDBFacade,mUIRoot.chatLogContainer,mUIRoot.UI_chat,mUIRoot.UI_chat.log_btn,mUIRoot.UI_chat.chat_btn);
         mCloseButton = new UIButton(mDBFacade,mUIRoot.close);
         mCloseButton.releaseCallback = function():void
         {
            var exitPopup:II_UIExitDungeonPopUp;
            var xpLoss:uint;
            var lootLossPopup:UILootLossPopup;
            var closeCallback:Function = function():void
            {
               var _loc1_:Object = {};
               _loc1_.buttonDesc = "UIHud Exit Button Clicked";
               _loc1_.areaType = "Dungeon";
               mDBFacade.metrics.log("ButtonClick",_loc1_);
               mUIChatLog.hideChatLog();
               mDBFacade.mDistributedObjectManager.mMatchMaker.RequestExit();
               mDBFacade.dbAccountInfo.dbAccountParams.flushParams();
            };
            if(mHeroOwner.distributedDungeonFloor.isInfiniteDungeon)
            {
               exitPopup = new II_UIExitDungeonPopUp(mDBFacade,closeCallback,null);
            }
            else
            {
               xpLoss = mHeroOwner.distributedDungeonFloor.completionXp;
               lootLossPopup = new UILootLossPopup(mDBFacade,xpLoss,mHeroOwner.distributedDungeonFloor.treasureCollected,closeCallback,null);
            }
         };
         if(mDBFacade.dbConfigManager.getConfigBoolean("want_pets",true))
         {
            mWantPets = true;
         }
         mProfileBox = mUIRoot.UI_profile;
         mHpBar = new UIProgressBar(mDBFacade,mUIRoot.UI_profile.HP_bar,mUIRoot.UI_profile.HP_bar_delta);
         mHpText = mUIRoot.UI_profile.HP_text;
         mHpText.x -= mHpBar.root.x;
         mHpText.y -= mHpBar.root.y;
         mHpBar.setTooltip(mHpText);
         mHpBar.tooltipDelay = 0;
         mFlashingHpBar = new UIProgressBar(mDBFacade,mUIRoot.UI_profile.HP_bar_invincible);
         mFlashingHpBar.visible = false;
         mFlashingHpBar.root.mouseEnabled = false;
         mManaBar = new UIProgressBar(mDBFacade,mUIRoot.UI_profile.mana_bar,mUIRoot.UI_profile.mana_bar_delta);
         mManaText = mUIRoot.UI_profile.mana_text;
         mManaText.x -= mManaBar.root.x;
         mManaText.y -= mManaBar.root.y;
         mManaBar.setTooltip(mManaText);
         mManaBar.tooltipDelay = 0;
         mHealthFullClip = mUIRoot.UI_profile.HP_full_text;
         mManaFullClip = mUIRoot.UI_profile.mana_full_text;
         mHealthFullClip.mouseEnabled = false;
         mManaFullClip.mouseEnabled = false;
         mHealthFullClip.visible = false;
         mManaFullClip.visible = false;
         mBusterRoot = mUIRoot.UI_buster;
         mBusterBar = new UIProgressBar(mDBFacade,mUIRoot.UI_buster.buster_bar);
         hideBustSign();
         mBasicCurrencyUI = new UIObject(mDBFacade,mUIRoot.UI_currency_coin);
         mBasicCurrencyUI.tooltipDelay = 0.4;
         mBasicCurrencyUI.tooltip.title_label.text = Locale.getString("COIN_TOOLTIP_TITLE");
         mBasicCurrencyUI.tooltip.description_label.text = Locale.getString("COIN_TOOLTIP_DESCRIPTION");
         mPremiumCurrencyUI = new UIObject(mDBFacade,mUIRoot.UI_currency_cash);
         mPremiumCurrencyUI.tooltipDelay = 0.4;
         mPremiumCurrencyUI.tooltip.title_label.text = Locale.getString("CASH_TOOLTIP_TITLE");
         mPremiumCurrencyUI.tooltip.description_label.text = Locale.getString("CASH_TOOLTIP_DESCRIPTION");
         mSaleLabel = mPremiumCurrencyUI.root.label_sale;
         mSaleLabel.visible = false;
         determineSaleVisibility();
         mBasicCurrencyText = mUIRoot.UI_currency_coin.game_currency_text;
         mBasicCurrencyText.mouseEnabled = false;
         mPremiumCurrencyText = mUIRoot.UI_currency_cash.cash_text;
         mPremiumCurrencyText.mouseEnabled = false;
         mAddCoinButton = new UIButton(mDBFacade,mUIRoot.UI_currency_coin.coin.add_coin_button);
         mAddCoinButton.releaseCallback = function():void
         {
            StoreServicesController.showCoinPage(mDBFacade);
         };
         mAddCashButton = new UIButton(mDBFacade,mUIRoot.UI_currency_cash.cash.add_cash_button);
         mAddCashButton.releaseCallback = function():void
         {
            mDBFacade.metrics.log("UIHudAddCash");
            StoreServicesController.showCashPage(mDBFacade,"inDungeonUIHudAddCash");
         };
         if(mDBFacade.dbAccountInfo)
         {
            setCurrency(mDBFacade.dbAccountInfo.basicCurrency,mDBFacade.dbAccountInfo.premiumCurrency);
         }
         mLevelText = mUIRoot.UI_XP.xp_level;
         mXpObject = new UIObject(mDBFacade,mUIRoot.UI_XP);
         mXpBar = new UIProgressBar(mDBFacade,mUIRoot.UI_XP.xp_bar,mUIRoot.UI_XP.xp_bar_delta);
         mUIRoot.UI_XP.xp_bar_delta.alpha = 0.3;
         mXpText = mUIRoot.UI_XP.xp_points;
         mXpObject.setTooltip(mXpText);
         mXpObject.tooltipDelay = 0;
         mXPBonusText = mUIRoot.UI_XP.doublexp_text;
         mCoinBonusText = mUIRoot.UI_currency_coin.doublecoin_text;
         mCoinBonusText.visible = false;
         mWeaponZButton = new UIButton(mDBFacade,mUIRoot.UI_weapons.weapon_z);
         mWeaponXButton = new UIButton(mDBFacade,mUIRoot.UI_weapons.weapon_x);
         mWeaponCButton = new UIButton(mDBFacade,mUIRoot.UI_weapons.weapon_c);
         mWeaponButtons = new <UIButton>[mWeaponZButton,mWeaponXButton,mWeaponCButton];
         i = 0;
         while(i < mWeaponButtons.length)
         {
            this.createWeaponTooltip(mWeaponButtons[i],i);
            ++i;
         }
         mCooldowns = new Vector.<MovieClipRenderer>();
         mCooldowns.push(new MovieClipRenderer(mDBFacade,mUIRoot.UI_weapons.weapon_z.cooldown));
         mUIRoot.UI_weapons.weapon_z.cooldown.visible = false;
         mCooldowns.push(new MovieClipRenderer(mDBFacade,mUIRoot.UI_weapons.weapon_x.cooldown));
         mUIRoot.UI_weapons.weapon_x.cooldown.visible = false;
         mCooldowns.push(new MovieClipRenderer(mDBFacade,mUIRoot.UI_weapons.weapon_c.cooldown));
         mUIRoot.UI_weapons.weapon_c.cooldown.visible = false;
         mConsumable1Button = new UIButton(mDBFacade,mUIRoot.consumables_01);
         mConsumable2Button = new UIButton(mDBFacade,mUIRoot.consumables_02);
         mConsumableWeaponButtons = new <UIButton>[mConsumable1Button,mConsumable2Button];
         mConsumableCooldowns = new Vector.<MovieClipRenderer>();
         mConsumableCooldowns.push(new MovieClipRenderer(mDBFacade,mUIRoot.consumables_01.cooldown));
         mUIRoot.consumables_01.cooldown.visible = false;
         mConsumableCooldowns.push(new MovieClipRenderer(mDBFacade,mUIRoot.consumables_02.cooldown));
         mUIRoot.consumables_02.cooldown.visible = false;
         mUIRoot.UI_center_message.visible = false;
         mPetPortraitRoot = mUIRoot.pet;
         if(mUIRoot.pet_none)
         {
            mPetPortraitNoneRoot = mUIRoot.pet_none;
         }
         mAssetsLoaded = true;
         mFloorLabel = mUIRoot.label_floor;
         tooltipOffsset = new Point(0,-15);
         mDungeonModifer1 = new UIButton(mDBFacade,mUIRoot.floor_modifier01);
         mDungeonModifer1.tooltip = mUIRoot.tooltip_modifier01;
         mDungeonModifer1.tooltipPos = tooltipOffsset;
         mDungeonModifer2 = new UIButton(mDBFacade,mUIRoot.floor_modifier02);
         mDungeonModifer2.tooltip = mUIRoot.tooltip_modifier02;
         mDungeonModifer2.tooltipPos = tooltipOffsset;
         mDungeonModifer3 = new UIButton(mDBFacade,mUIRoot.floor_modifier03);
         mDungeonModifer3.tooltip = mUIRoot.tooltip_modifier03;
         mDungeonModifer3.tooltipPos = tooltipOffsset;
         mDungeonModifer4 = new UIButton(mDBFacade,mUIRoot.floor_modifier04);
         mDungeonModifer4.tooltip = mUIRoot.tooltip_modifier04;
         mDungeonModifer4.tooltipPos = tooltipOffsset;
         if(mHeroOwner)
         {
            this.initializeHud(mHeroOwner);
         }
      }
      
      private function setOptionsBasedOnHud() : void
      {
         if(mOptionsPanel == null || mOptionsButton == null)
         {
            return;
         }
         var _loc2_:Point = new Point(0,0);
         var _loc1_:Point = new Point(1,1);
         switch(int(mHudType))
         {
            case 0:
               _loc2_ = new Point(735,65);
               _loc1_ = new Point(0.5,0.5);
               break;
            case 1:
               _loc2_ = new Point(712,19);
               _loc1_ = new Point(0.325,0.325);
               break;
            default:
               _loc2_ = new Point(735,65);
               _loc1_ = new Point(0.5,0.5);
               Logger.warn("Unable to determine hud with type: " + mHudType);
         }
         mOptionsButton.root.x = _loc2_.x;
         mOptionsButton.root.y = _loc2_.y;
         mOptionsButton.root.scaleX = _loc1_.x;
         mOptionsButton.root.scaleY = _loc1_.y;
      }
      
      private function mouseOverXpListener(param1:Event) : void
      {
         mUIRoot.UI_XP.xp_level_title.visible = false;
      }
      
      private function mouseOutXpListener(param1:Event) : void
      {
         mUIRoot.UI_XP.xp_level_title.visible = true;
      }
      
      public function showHealthFullMessage() : void
      {
         if(mHealthFullRevealer || mHealthFullFloater)
         {
            return;
         }
         mHealthFullClip.visible = true;
         mHealthFullClip.scaleX = 1;
         mHealthFullClip.scaleY = 1;
         mHealthFullRevealer = new Revealer(mHealthFullClip,mDBFacade,8,function():void
         {
            if(mHealthFullRevealer)
            {
               mHealthFullRevealer = null;
            }
            mHealthFullFloater = new FloatingMessage(mHealthFullClip,mDBFacade,2,16,1.125,0,null,function():void
            {
               mHealthFullClip.scaleX = 1;
               mHealthFullClip.scaleY = 1;
               mHealthFullFloater = null;
            },"DAMAGE_MOVEMENT_TYPE",true);
         },1);
      }
      
      public function showManaFullMessage() : void
      {
         if(mManaFullRevealer || mManaFullFloater)
         {
            return;
         }
         mManaFullClip.visible = true;
         mManaFullClip.scaleX = 1;
         mManaFullClip.scaleY = 1;
         mManaFullRevealer = new Revealer(mManaFullClip,mDBFacade,8,function():void
         {
            if(mManaFullRevealer)
            {
               mManaFullRevealer = null;
            }
            mManaFullFloater = new FloatingMessage(mManaFullClip,mDBFacade,2,16,1.125,0,null,function():void
            {
               mManaFullClip.scaleX = 1;
               mManaFullClip.scaleY = 1;
               mManaFullFloater = null;
            },"DAMAGE_MOVEMENT_TYPE",true);
         },1);
      }
      
      public function handleBoosterTimeUp(param1:TimerEvent) : void
      {
         if(mBoosterTimer != null)
         {
            mBoosterTimer.stop();
            mBoosterTimer = null;
         }
         showBonusXPEffects(null);
         showBonusCoinEffects(null);
         var _loc2_:int = mDBFacade.dbAccountInfo.inventoryInfo.timeTillNextBoosterExpire();
         if(_loc2_ >= 0)
         {
            mBoosterTimer = new Timer(_loc2_,0);
            mBoosterTimer.addEventListener("timer",handleBoosterTimeUp);
            mBoosterTimer.start();
         }
      }
      
      private function handleBoostersParsedEvent(param1:Event) : void
      {
         showBonusXPEffects(param1);
         showBonusCoinEffects(param1);
      }
      
      private function showBonusXPEffects(param1:Event) : void
      {
         var _loc2_:BoosterInfo = mDBFacade.dbAccountInfo.inventoryInfo.findHighestBoosterXP();
         if(mDBFacade.accountBonus.isXPBonusActive)
         {
            mXPBonusText.visible = true;
            mXPBonusText.text = mDBFacade.accountBonus.xpBonusText;
         }
         else if(_loc2_ != null && _loc2_.BuffInfo.Exp > 1)
         {
            mXPBonusText.visible = true;
            mXPBonusText.text = _loc2_.BuffInfo.Exp + Locale.getString("BOOSTER_XP");
         }
         else
         {
            mXPBonusText.visible = false;
         }
      }
      
      private function showBonusCoinEffects(param1:Event) : void
      {
         var _loc2_:BoosterInfo = mDBFacade.dbAccountInfo.inventoryInfo.findHighestBoosterGold();
         if(mDBFacade.accountBonus.isCoinBonusActive)
         {
            mCoinBonusText.visible = true;
            mCoinBonusText.text = mDBFacade.accountBonus.coinBonusText;
         }
         else if(_loc2_ != null && _loc2_.BuffInfo.Gold > 1)
         {
            mCoinBonusText.visible = true;
            mCoinBonusText.text = _loc2_.BuffInfo.Gold + Locale.getString("BOOSTER_GOLD");
         }
         else
         {
            mCoinBonusText.visible = false;
         }
      }
      
      public function registerPet(param1:NPCGameObject) : void
      {
         if(mPetPortrait)
         {
            mPetPortrait.destroy();
         }
         if(mWantPets)
         {
            mPetPortrait = new PetPortraitUI(mDBFacade,mPetPortraitRoot,mPetPortraitNoneRoot,param1);
         }
      }
      
      public function unregisterPet(param1:NPCGameObject) : void
      {
         if(mPetPortrait && mPetPortrait.petNPCGameObject == param1)
         {
            mPetPortrait.petDeath();
         }
      }
      
      private function createWeaponTooltip(param1:UIButton, param2:uint) : void
      {
         var button:UIButton = param1;
         var num:uint = param2;
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),function(param1:SwfAsset):void
         {
            var _loc2_:Class = num == 0 ? param1.getClass("DR_weapon_tooltip_z") : param1.getClass("DR_weapon_tooltip");
            var _loc4_:UIWeaponTooltip = new UIWeaponTooltip(mDBFacade,_loc2_);
            button.tooltip = _loc4_;
            var _loc3_:Point = new Point();
            _loc3_.y -= button.root.height * 0.5;
            button.tooltipPos = _loc3_;
            button.tooltipDelay = 0.4;
         });
      }
      
      public function openTeamLoot(param1:uint) : void
      {
         var _loc4_:String = "";
         switch(int(param1) - 60001)
         {
            case 0:
               _loc4_ = "UI_teamloot_basic";
               break;
            case 1:
               _loc4_ = "UI_teamloot_uncommon";
               break;
            case 2:
               _loc4_ = "UI_teamloot_rare";
               break;
            case 3:
               _loc4_ = "UI_teamloot_legendary";
               break;
            case 4:
               _loc4_ = "UI_teamloot_box_small";
               break;
            case 5:
               _loc4_ = "UI_teamloot_box_royal";
         }
         var _loc3_:Class = mSwfAsset.getClass(_loc4_);
         var _loc2_:MovieClip = new _loc3_() as MovieClip;
         mTeamLootMC = new MovieClipRenderController(mDBFacade,_loc2_);
         mUIRoot.addChild(mTeamLootMC.clip);
         mTeamLootMC.clip.x = -mTeamLootDestination.x;
         mTeamLootMC.clip.y = 130;
         if(mLootTween)
         {
            mLootTween.kill();
         }
         mTeamLootMC.play(0,true);
         mLootTween = TweenMax.to(mTeamLootMC.clip,0.5,{"x":40});
         if(mLootTask)
         {
            mLootTask.destroy();
         }
         mLootTask = mLogicalWorkComponent.doLater(2,closeTeamLoot);
      }
      
      public function closeTeamLoot(param1:GameClock = null) : void
      {
         var gameClock:GameClock = param1;
         var cleanupFunc:Function = function():void
         {
            mTeamLootMC.stop();
            mTeamLootMC.clip.visible = false;
         };
         if(mLootTask)
         {
            mLootTask.destroy();
         }
         if(mLootTween)
         {
            mLootTween.kill();
         }
         mLootTween = TweenMax.to(mTeamLootMC.clip,0.5,{
            "x":-40,
            "onComplete":cleanupFunc
         });
      }
      
      public function detachHero() : void
      {
         hide();
         hideBustSign();
         mOffScreenPlayerManager.destroy();
         mOffScreenPlayerManager = null;
         mHeroOwner = null;
         mEventComponent.removeAllListeners();
         mUIRoot.UI_XP.removeEventListener("mouseOver",mouseOverXpListener);
         mUIRoot.UI_XP.removeEventListener("mouseOut",mouseOutXpListener);
      }
      
      public function initializeHud(param1:HeroGameObjectOwner) : void
      {
         var boosterTime:int;
         var equippedWeapons:Vector.<WeaponGameObject>;
         var i:int;
         var equippedConsumableWeapons:Vector.<ConsumableWeaponGameObject>;
         var j:int;
         var gmSkin:GMSkin;
         var busterConstant:String;
         var busterAttack:GMAttack;
         var busterName:String;
         var heroOwner:HeroGameObjectOwner = param1;
         show();
         mHeroOwner = heroOwner;
         if(mAssetsLoaded && mHeroOwner != null)
         {
            mUIChatLog.heroOwner = mHeroOwner;
            mUIChatLog.enable();
            hideInvulnerable();
            setHp(mHeroOwner.hitPoints,mHeroOwner.maxHitPoints);
            setMana(mHeroOwner.manaPoints,mHeroOwner.maxManaPoints);
            setXp(mHeroOwner.experiencePoints);
            bulgeXpBar();
            bulgeProfileBox();
            setBusterPoints(mHeroOwner.dungeonBusterPoints);
            this.addListeners();
            boosterTime = mDBFacade.dbAccountInfo.inventoryInfo.timeTillNextBoosterExpire();
            if(boosterTime >= 0)
            {
               mBoosterTimer = new Timer(boosterTime,0);
               mBoosterTimer.addEventListener("timer",handleBoosterTimeUp);
               mBoosterTimer.start();
            }
            mOffScreenPlayerManager = new UIOffScreenPlayerManager(mDBFacade,mUIRoot,mHeroOwner);
            equippedWeapons = new Vector.<WeaponGameObject>();
            i = 0;
            while(i < mHeroOwner.weaponControllers.length)
            {
               equippedWeapons.push(mHeroOwner.weaponControllers[i] ? mHeroOwner.weaponControllers[i].weapon : null);
               i++;
            }
            this.setupWeaponUI(equippedWeapons);
            equippedConsumableWeapons = new Vector.<ConsumableWeaponGameObject>();
            j = 0;
            while(j < 2)
            {
               equippedConsumableWeapons.push(mHeroOwner.consumables[j] ? mHeroOwner.consumables[j] : null);
               j++;
            }
            this.setupConsumableWeaponUI(equippedConsumableWeapons);
            gmSkin = mHeroOwner.gmSkin;
            if(gmSkin == null)
            {
               Logger.error("GMSkin on hero is null.  HeroType: " + mHeroOwner.type + " AccountId: " + mDBFacade.accountId);
            }
            else
            {
               mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(gmSkin.UISwfFilepath),function(param1:SwfAsset):void
               {
                  var _loc3_:Class = param1.getClass(gmSkin.IconName);
                  var _loc2_:MovieClip = new _loc3_();
                  if(mUIRoot.UI_profile.avatar)
                  {
                     mUIRoot.UI_profile.avatar.addChild(_loc2_);
                  }
               });
            }
            mStacksHud.setupStacksUI();
            mDungeonBusterButton = new UIButton(mDBFacade,mUIRoot.UI_buster_active.buster_activated);
            mDungeonBusterButton.releaseCallback = handleBusterBarClickEvent;
            mBusterLabel = mUIRoot.UI_buster_active.buster_activated.up.name_mc.name_label;
            mBusterLabelOver = mUIRoot.UI_buster_active.buster_activated.over.mc.name_label;
            busterConstant = mHeroOwner.gMHero.DBuster1;
            busterAttack = mDBFacade.gameMaster.attackByConstant.itemFor(busterConstant);
            busterName = busterAttack ? busterAttack.Name : "BUSTER!";
            mBusterLabel.text = mBusterLabelOver.text = busterName.toUpperCase();
            mBusterGlowMc = new MovieClipRenderController(mDBFacade,mUIRoot.UI_buster_glow);
            mUIRoot.UI_buster_glow.buster_text.buster_text_label.name_label.text = busterName.toUpperCase();
            if(mDBFacade.dbAccountInfo)
            {
               setCurrency(mDBFacade.dbAccountInfo.basicCurrency,mDBFacade.dbAccountInfo.premiumCurrency);
            }
            mMaxBusterPoints = mHeroOwner.maxBusterPoints;
            setBusterPoints(mHeroOwner.dungeonBusterPoints);
            initializePetPortraits();
            setCurrentFloorLabel();
            setDungeonModifiers();
            mUIChatLog.heroOwner = mHeroOwner;
            mLogicalWorkComponent.doEveryFrame(updateBuffDisplay);
         }
      }
      
      private function setCurrentFloorLabel() : void
      {
         mFloorLabel.text = Locale.getString("UI_HUD_FLOOR_LABEL") + mHeroOwner.distributedDungeonFloor.getCurrentFloorNum().toString();
      }
      
      private function setDungeonModifiers() : void
      {
         var _loc1_:UIButton = null;
         var _loc2_:* = 0;
         mDungeonModifer1.visible = false;
         mDungeonModifer2.visible = false;
         mDungeonModifer3.visible = false;
         mDungeonModifer4.visible = false;
         _loc2_ = 0;
         while(_loc2_ < mHeroOwner.distributedDungeonFloor.activeGMDungeonModifiers.length)
         {
            switch(int(_loc2_))
            {
               case 0:
                  _loc1_ = mDungeonModifer1;
                  break;
               case 1:
                  _loc1_ = mDungeonModifer2;
                  break;
               case 2:
                  _loc1_ = mDungeonModifer3;
                  break;
               case 3:
                  _loc1_ = mDungeonModifer4;
                  break;
            }
            setupModifiers(_loc1_,mHeroOwner.distributedDungeonFloor.activeGMDungeonModifiers[_loc2_]);
            _loc2_++;
         }
      }
      
      private function setupModifiers(param1:UIButton, param2:DungeonModifierHelper) : void
      {
         var dungeonModButton:UIButton = param1;
         var gmDungeonModifier:DungeonModifierHelper = param2;
         dungeonModButton.tooltip.title_label.text = gmDungeonModifier.GMDungeonMod.Name;
         dungeonModButton.tooltip.description_label.text = gmDungeonModifier.GMDungeonMod.Description;
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(gmDungeonModifier.GMDungeonMod.IconFilepath),function(param1:SwfAsset):void
         {
            var _loc2_:Class = param1.getClass(gmDungeonModifier.GMDungeonMod.IconName);
            if(_loc2_ == null)
            {
               return;
            }
            var _loc3_:MovieClip = new _loc2_();
            UIObject.scaleToFit(_loc3_,dungeonModButton.root.width);
            dungeonModButton.root.addChild(_loc3_);
            dungeonModButton.root.visible = true;
         });
      }
      
      private function initializePetPortraits() : void
      {
         var _loc1_:NPCGameObject = null;
         if(mPetPortrait)
         {
            _loc1_ = mPetPortrait.petNPCGameObject;
         }
         registerPet(_loc1_);
      }
      
      public function show() : void
      {
         mSceneGraphComponent.addChild(mRoot,50);
         mSceneGraphComponent.addChild(mOptionsButton.root,50);
         mStacksHud.show();
         mDBFacade.camera.yCilppingFromBottom = mVerticalYClipping;
         initializePetPortraits();
      }
      
      public function hide() : void
      {
         mSceneGraphComponent.removeChild(mRoot);
         mSceneGraphComponent.removeChild(mOptionsButton.root);
         mDBFacade.camera.yCilppingFromBottom = 0;
         mDBFacade.camera.forceRedraw();
         mOptionsPanel.hide();
         mStacksHud.hide();
         if(mUIChatLog)
         {
            mUIChatLog.disable();
            mUIChatLog.hideChatLog();
         }
         if(mPetPortrait)
         {
            mPetPortrait.destroy();
            mPetPortrait = null;
         }
      }
      
      public function showStacks() : void
      {
         mStacksHud.show();
      }
      
      public function hideStacks() : void
      {
         mStacksHud.hide();
      }
      
      private function resetButtons(param1:Vector.<UIButton>) : void
      {
         var _loc3_:DisplayObject = null;
         for each(var _loc2_ in param1)
         {
            _loc2_.pressCallback = null;
            _loc2_.pressRollOutCallback = null;
            if(_loc2_.tooltip)
            {
               _loc2_.tooltip.visible = false;
            }
            if(_loc2_.root.graphic.numChildren > 0)
            {
               _loc2_.root.graphic.removeChildAt(0);
            }
            _loc3_ = _loc2_.root.getChildByName("rarityIcon");
            if(_loc3_)
            {
               _loc2_.root.removeChild(_loc3_);
            }
            _loc2_.root.selectionFrame.visible = false;
            _loc2_.enabled = true;
            _loc2_.root.filters = [];
         }
      }
      
      private function setupWeaponUI(param1:Vector.<WeaponGameObject>) : void
      {
         var weaponGameObject:WeaponGameObject;
         var gmWeapon:GMWeaponItem;
         var gmWeaponAesthetic:GMWeaponAesthetic;
         var weapon:MovieClip;
         var button:UIButton;
         var tooltip:UIWeaponTooltip;
         var i:uint;
         var makeCallback:Function;
         var equippedWeapons:Vector.<WeaponGameObject> = param1;
         var slotSize:Number = 56;
         resetButtons(mWeaponButtons);
         i = 0;
         while(i < equippedWeapons.length)
         {
            if(equippedWeapons[i])
            {
               weaponGameObject = equippedWeapons[i];
               gmWeapon = weaponGameObject.weaponData;
               gmWeaponAesthetic = weaponGameObject.weaponAesthetic;
               button = mWeaponButtons[i];
               button.root.weaponIndex = i;
               tooltip = UIWeaponTooltip(button.tooltip);
               tooltip.setWeaponItemFromWeaponGameObject(weaponGameObject);
               tooltip.visible = true;
               button.pressCallbackThis = function(param1:UIButton):void
               {
                  if(mHeroOwner.currentWeaponIndex != param1.root.weaponIndex)
                  {
                     mHeroOwner.currentWeaponIndex = param1.root.weaponIndex;
                  }
                  else
                  {
                     mHeroOwner.PlayerAttack.addToPotentialWeaponInputQueue(param1.root.weaponIndex,true,true);
                  }
               };
               button.releaseCallbackThis = function(param1:UIButton):void
               {
                  if(mHeroOwner.currentWeaponIndex == param1.root.weaponIndex)
                  {
                     mHeroOwner.PlayerAttack.addToPotentialWeaponInputQueue(param1.root.weaponIndex,false,true);
                  }
               };
               button.pressRollOutCallback = function():void
               {
                  mDBFacade.inputManager.onMouseDown(null);
               };
               makeCallback = function(param1:UIButton, param2:GMWeaponAesthetic, param3:GMRarity):Function
               {
                  var weaponButton:UIButton = param1;
                  var weaponAesthetic:GMWeaponAesthetic = param2;
                  var rarity:GMRarity = param3;
                  return function(param1:SwfAsset):void
                  {
                     var bgColoredExists:Boolean;
                     var bgSwfPath:String;
                     var bgIconName:String;
                     var swfAsset:SwfAsset = param1;
                     var weaponClass:Class = swfAsset.getClass(weaponAesthetic.IconName);
                     if(weaponClass == null)
                     {
                        return;
                     }
                     weapon = new weaponClass();
                     weapon.name = "weaponIcon";
                     weapon.scaleX = weapon.scaleY = 60 / 100;
                     weaponButton.root.graphic.addChildAt(weapon,0);
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
                              _loc3_.name = "rarityIcon";
                              weaponButton.root.addChildAt(_loc3_,2);
                              _loc3_.scaleX = _loc3_.scaleY = 0.85;
                              _loc3_.y -= 6;
                           }
                        });
                     }
                  };
               };
               mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(gmWeaponAesthetic.IconSwf),makeCallback(button,gmWeaponAesthetic,weaponGameObject.gmRarity));
            }
            i++;
         }
      }
      
      private function setupConsumableWeaponUI(param1:Vector.<ConsumableWeaponGameObject>) : void
      {
         var consumableWeaponGameObject:ConsumableWeaponGameObject;
         var gmWeapon:GMWeaponItem;
         var gmWeaponAesthetic:GMWeaponAesthetic;
         var weapon:MovieClip;
         var button:UIButton;
         var tooltip:MovieClip;
         var i:uint;
         var makeCallback:Function;
         var equippedConsumableWeapons:Vector.<ConsumableWeaponGameObject> = param1;
         var slotSize:Number = 56;
         resetButtons(mConsumableWeaponButtons);
         mUIRoot.consumable_tooltip01.visible = false;
         mUIRoot.consumable_tooltip02.visible = false;
         i = 0;
         while(i < equippedConsumableWeapons.length)
         {
            button = mConsumableWeaponButtons[i];
            button.root.quantity.visible = false;
            button.root.textx.visible = false;
            if(equippedConsumableWeapons[i])
            {
               consumableWeaponGameObject = equippedConsumableWeapons[i];
               gmWeapon = consumableWeaponGameObject.weaponData;
               button.root.weaponIndex = i;
               button.root.quantity.visible = true;
               button.root.textx.visible = true;
               button.root.quantity.text = consumableWeaponGameObject.getConsumableCount().toString();
               switch(int(i))
               {
                  case 0:
                     tooltip = mUIRoot.consumable_tooltip01;
                     break;
                  case 1:
                     tooltip = mUIRoot.consumable_tooltip02;
               }
               button.tooltip = tooltip;
               button.tooltip.description_label.text = consumableWeaponGameObject.getGMStackable().Description;
               tooltip.visible = true;
               button.setTooltipToBeParentedToStage();
               button.tooltipPos = new Point(button.root.x,button.root.y);
               button.releaseCallbackThis = function(param1:UIButton):void
               {
                  mHeroOwner.tryToUseConsumable(param1.root.weaponIndex);
               };
               makeCallback = function(param1:UIButton, param2:GMStackable):Function
               {
                  var weaponButton:UIButton = param1;
                  var gmStackable:GMStackable = param2;
                  return function(param1:SwfAsset):void
                  {
                     var _loc2_:Class = param1.getClass(gmStackable.IconName);
                     if(_loc2_ == null)
                     {
                        return;
                     }
                     weapon = new _loc2_();
                     weapon.name = "weaponIcon";
                     weapon.scaleX = weapon.scaleY = 60 / 100;
                     weaponButton.root.graphic.addChildAt(weapon,0);
                  };
               };
               mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(consumableWeaponGameObject.getGMStackable().UISwfFilepath),makeCallback(button,consumableWeaponGameObject.getGMStackable()));
            }
            i++;
         }
      }
      
      private function addListeners() : void
      {
         var heroOwnerId:uint;
         mEventComponent.removeAllListeners();
         heroOwnerId = mHeroOwner.id;
         mEventComponent.addListener("BONUS_XP_CHANGED_EVENT",showBonusXPEffects);
         showBonusXPEffects(new Event("BONUS_XP_CHANGED_EVENT"));
         mEventComponent.addListener("BONUS_COIN_CHANGED_EVENT",showBonusCoinEffects);
         showBonusCoinEffects(new Event("BONUS_COIN_CHANGED_EVENT"));
         mEventComponent.addListener("BoostersParsedEvent_BOOSTERS_PARSED_UPDATE",this.handleBoostersParsedEvent);
         mEventComponent.addListener(GameObjectEvent.uniqueEvent("HpEvent_HP_UPDATE",heroOwnerId),function(param1:HpEvent):void
         {
            setHp(param1.hp,param1.maxHp);
         });
         mEventComponent.addListener(GameObjectEvent.uniqueEvent("ManaEvent_MANA_UPDATE",heroOwnerId),function(param1:ManaEvent):void
         {
            setMana(param1.mana,param1.maxMana);
         });
         mEventComponent.addListener(GameObjectEvent.uniqueEvent("ExperienceEvent_EXPERIENCE_UPDATE",heroOwnerId),function(param1:ExperienceEvent):void
         {
            setXp(param1.experience);
         });
         mEventComponent.addListener(GameObjectEvent.uniqueEvent("BusterPointEvent_BUSTER_POINTS_UPDATE",heroOwnerId),handleBusterPointsEvent);
         mEventComponent.addListener("CurrencyUpdatedAccountEvent",function(param1:CurrencyUpdatedAccountEvent):void
         {
            setCurrency(param1.basicCurrency,param1.premiumCurrency);
         });
         mEventComponent.addListener(GameObjectEvent.uniqueEvent(BuffHandler.ACTOR_INVULNERABLE,heroOwnerId),function(param1:ActorInvulnerableEvent):void
         {
            if(param1.mIsInvulnerable)
            {
               showInvulnerable();
            }
            else
            {
               hideInvulnerable();
            }
         });
         mEventComponent.addListener("UI_HUD_CHANGE_EVENT",switchHudEvent);
         mUIRoot.UI_XP.addEventListener("mouseOver",mouseOverXpListener);
         mUIRoot.UI_XP.addEventListener("mouseOut",mouseOutXpListener);
      }
      
      private function handleBusterPointsEvent(param1:BusterPointsEvent) : void
      {
         mMaxBusterPoints = param1.maxBusterPoints;
         setBusterPoints(param1.busterPoints);
      }
      
      private function showInvulnerable() : void
      {
         mFlashingHpBar.value = mHpBar.value;
         mFlashingHpBar.visible = true;
         mHpBar.visible = false;
      }
      
      private function hideInvulnerable() : void
      {
         mFlashingHpBar.visible = false;
         mHpBar.visible = true;
      }
      
      public function get floaterTextClass() : Class
      {
         return mFloaterTextClass;
      }
      
      private function floaterCallback(param1:MovieClip) : Function
      {
         var clip:MovieClip = param1;
         return function():void
         {
            mDBFacade.sceneGraphManager.removeChild(clip);
         };
      }
      
      private function spawnFloater(param1:String, param2:Number, param3:Number, param4:uint, param5:Number, param6:uint, param7:uint, param8:Number, param9:Number) : void
      {
         var _loc10_:MovieClip = new mFloaterTextClass() as MovieClip;
         _loc10_.label.text = param1;
         _loc10_.label.textColor = param4;
         _loc10_.x = param2;
         _loc10_.y = param3;
         _loc10_.scaleX = param5;
         _loc10_.scaleY = param5;
         var _loc11_:FloatingMessage = new FloatingMessage(_loc10_,mDBFacade,param6,param7,param8,param9,null,floaterCallback(_loc10_));
         mDBFacade.sceneGraphManager.addChild(_loc10_,50);
      }
      
      public function setHp(param1:uint, param2:uint) : void
      {
         if(!mAssetsLoaded)
         {
            return;
         }
         var _loc3_:Number = param1 / param2;
         mHpBar.value = _loc3_;
         mFlashingHpBar.value = _loc3_;
         mHpText.text = param1.toString() + " / " + param2.toString();
      }
      
      public function setMana(param1:uint, param2:uint) : void
      {
         if(!mAssetsLoaded)
         {
            return;
         }
         mManaBar.value = param1 / param2;
         mManaText.text = param1.toString() + " / " + param2.toString();
      }
      
      private function spawnBusterFloater(param1:int, param2:Number) : void
      {
      }
      
      public function setBusterPoints(param1:uint) : void
      {
         if(!mAssetsLoaded)
         {
            return;
         }
         mBusterBar.value = param1 / mMaxBusterPoints;
         var _loc2_:int = param1 - mBusterValue;
         if(_loc2_ > 0)
         {
            spawnBusterFloater(_loc2_,mBusterBar.value * 75);
         }
         mBusterValue = param1;
         if(mBusterValue >= mMaxBusterPoints)
         {
            this.showBustSign();
         }
         else
         {
            this.hideBustSign();
         }
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
      
      private function spawnCoinFloater(param1:int) : void
      {
      }
      
      public function setBasicCurrency(param1:int) : void
      {
         if(!mAssetsLoaded)
         {
            return;
         }
         var _loc2_:int = param1 - mBasicCurrency;
         if(_loc2_ > 0)
         {
            spawnCoinFloater(_loc2_);
         }
         mBasicCurrencyText.text = param1.toString();
         mBasicCurrency = param1;
      }
      
      private function spawnCashFloater(param1:int) : void
      {
      }
      
      public function setPremiumCurrency(param1:int) : void
      {
         if(!mAssetsLoaded)
         {
            return;
         }
         var _loc2_:int = param1 - mPremiumCurrency;
         if(_loc2_ > 0)
         {
            spawnCashFloater(_loc2_);
         }
         mPremiumCurrencyText.text = param1.toString();
         mPremiumCurrency = param1;
      }
      
      private function spawnXpFloater(param1:int, param2:Number) : void
      {
      }
      
      public function setXp(param1:uint) : void
      {
         if(!mAssetsLoaded)
         {
            return;
         }
         var _loc5_:uint = mHeroOwner.level;
         var _loc4_:* = param1;
         var _loc2_:uint = uint(mHeroOwner.gMHero.getLevelIndex(param1));
         var _loc7_:uint = uint(_loc2_ > 0 ? mHeroOwner.gMHero.getExpFromIndex(_loc2_ - 1) : 0);
         var _loc6_:uint = mHeroOwner.gMHero.getExpFromIndex(_loc2_);
         mLevelText.text = _loc5_.toString();
         var _loc3_:Number = (_loc4_ - _loc7_) / (_loc6_ - _loc7_);
         mXpBar.value = _loc3_;
         mXpText.text = _loc4_.toString() + " / " + _loc6_.toString();
         spawnXpFloater(param1 - mXpValue,_loc3_ * 100);
         mXpValue = param1;
         if(!mXpGotInitialUpdate)
         {
            mXpGotInitialUpdate = true;
            bulgeXpBar();
         }
      }
      
      private function updateXpBulge(param1:GameClock) : void
      {
         var _loc3_:MovieClip = mXpObject.root;
         var _loc2_:Number = _loc3_.scaleX - 1;
         _loc2_ *= 0.75;
         _loc3_.scaleX = 1 + _loc2_;
         _loc3_.scaleY = 1 + _loc2_;
         if(_loc3_.scaleX <= 1.01)
         {
            _loc3_.scaleX = 1;
            _loc3_.scaleY = 1;
            mXpBulgeTask.destroy();
            mXpBulgeTask = null;
         }
      }
      
      public function bulgeXpBar() : void
      {
         mXpObject.root.scaleX *= 1.08;
         mXpObject.root.scaleY *= 1.08;
         if(mXpBulgeTask == null)
         {
            mXpBulgeTask = mLogicalWorkComponent.doEveryFrame(updateXpBulge);
         }
      }
      
      private function updateProfileBulge(param1:GameClock) : void
      {
         var _loc2_:Number = mProfileBox.scaleX - 1;
         _loc2_ *= 0.75;
         mProfileBox.scaleX = 1 + _loc2_;
         mProfileBox.scaleY = 1 + _loc2_;
         if(mProfileBox.scaleX <= 1.01)
         {
            mProfileBox.scaleX = 1;
            mProfileBox.scaleY = 1;
            mProfileBulgeTask.destroy();
            mProfileBulgeTask = null;
         }
      }
      
      public function bulgeProfileBox() : void
      {
         mProfileBox.scaleX *= 1.08;
         mProfileBox.scaleY *= 1.08;
         if(mProfileBulgeTask == null)
         {
            mProfileBulgeTask = mLogicalWorkComponent.doEveryFrame(updateProfileBulge);
         }
      }
      
      public function destroy() : void
      {
         var _loc2_:int = 0;
         var _loc1_:UIButton = null;
         mBuffs.splice(0,mBuffs.length);
         mBuffs = null;
         _loc2_ = 0;
         while(_loc2_ < mBuffIconButtons.length)
         {
            if(mBuffIconButtons[_loc2_])
            {
               mBuffIconButtons[_loc2_].destroy();
            }
            _loc2_++;
         }
         mBuffIconButtons = null;
         _loc2_ = 0;
         while(_loc2_ < mBuffCooldowns.length)
         {
            if(mBuffCooldowns[_loc2_])
            {
               mBuffCooldowns[_loc2_].destroy();
            }
            _loc2_++;
         }
         mBuffCooldowns = null;
         if(mBoosterTimer != null)
         {
            mBoosterTimer.stop();
            mBoosterTimer = null;
         }
         mDBFacade = null;
         mOptionsPanel.destroy();
         mOptionsPanel = null;
         mStacksHud.destroy();
         mStacksHud = null;
         if(mOffScreenPlayerManager)
         {
            mOffScreenPlayerManager.destroy();
            mOffScreenPlayerManager = null;
         }
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         mSceneGraphComponent.destroy();
         mSceneGraphComponent = null;
         mAssetLoadingComponent.destroy();
         mAssetLoadingComponent = null;
         mEventComponent.destroy();
         mEventComponent = null;
         mHeroOwner = null;
         mRoot = null;
         mUIRoot = null;
         if(mAddCoinButton)
         {
            mAddCoinButton.destroy();
         }
         mAddCoinButton = null;
         if(mAddCashButton)
         {
            mAddCashButton.destroy();
         }
         mAddCashButton = null;
         if(mProfileBulgeTask)
         {
            mProfileBulgeTask.destroy();
         }
         mProfileBulgeTask = null;
         if(mHpBar)
         {
            mHpBar.destroy();
         }
         mHpBar = null;
         if(mFlashingHpBar)
         {
            mFlashingHpBar.destroy();
         }
         mFlashingHpBar = null;
         if(mManaBar)
         {
            mManaBar.destroy();
         }
         mManaBar = null;
         if(mBusterBar)
         {
            mBusterBar.destroy();
         }
         mBusterBar = null;
         if(mXpBar)
         {
            mXpBar.destroy();
         }
         mXpBar = null;
         if(mXpBulgeTask)
         {
            mXpBulgeTask.destroy();
         }
         mXpBulgeTask = null;
         if(mLootTask)
         {
            mLootTask.destroy();
         }
         mLootTask = null;
         if(mCloseButton)
         {
            mCloseButton.destroy();
         }
         mCloseButton = null;
         if(mWeaponZButton)
         {
            mWeaponZButton.destroy();
         }
         mWeaponZButton = null;
         if(mWeaponXButton)
         {
            mWeaponXButton.destroy();
         }
         mWeaponXButton = null;
         if(mWeaponCButton)
         {
            mWeaponCButton.destroy();
         }
         mWeaponCButton = null;
         if(mConsumable1Button)
         {
            mConsumable1Button.destroy();
         }
         mConsumable1Button = null;
         if(mConsumable2Button)
         {
            mConsumable2Button.destroy();
         }
         mConsumable2Button = null;
         if(mDungeonBusterButton)
         {
            mDungeonBusterButton.destroy();
         }
         mDungeonBusterButton = null;
         if(mBusterGlowMc)
         {
            mBusterGlowMc.destroy();
         }
         mBusterGlowMc = null;
         if(mOptionsButton)
         {
            mOptionsButton.destroy();
         }
         mOptionsButton = null;
         if(mOptionsPanel)
         {
            mOptionsPanel.destroy();
         }
         mOptionsPanel = null;
         if(mStacksHud)
         {
            mStacksHud.destroy();
         }
         mStacksHud = null;
         if(mUITask)
         {
            mUITask.destroy();
         }
         mUITask = null;
         if(mUIChatLog)
         {
            mUIChatLog.destroy();
         }
         mUIChatLog = null;
         if(mPetPortrait)
         {
            mPetPortrait.destroy();
         }
         for each(_loc1_ in mWeaponButtons)
         {
            if(_loc1_)
            {
               _loc1_.destroy();
            }
            _loc1_ = null;
         }
         for each(_loc1_ in mConsumableWeaponButtons)
         {
            if(_loc1_)
            {
               _loc1_.destroy();
            }
            _loc1_ = null;
         }
         mSaleLabel = null;
         mProfileBox = null;
         mFloaterTextClass = null;
         mHpText = null;
         mManaText = null;
         mBusterRoot = null;
         mBasicCurrencyText = null;
         mPremiumCurrencyText = null;
         mLevelText = null;
         mXpObject = null;
         mXpText = null;
         mTeamLootMC.destroy();
         mTeamLootMC = null;
         mLootTween = null;
         mLootMouseArea = null;
         mBusterLabel = null;
         mBusterLabelOver = null;
         mSwfAsset = null;
      }
      
      public function get offScreenPlayerManager() : UIOffScreenPlayerManager
      {
         return mOffScreenPlayerManager;
      }
      
      public function showBustSign() : void
      {
         mUIRoot.UI_buster_glow.visible = true;
         mBusterGlowMc.play(1,false,function():void
         {
            mUIRoot.UI_buster_glow.visible = false;
            mUIRoot.UI_buster_active.visible = true;
            mUIRoot.UI_buster.buster_activated_glow.visible = true;
         });
      }
      
      public function hideBustSign() : void
      {
         mUIRoot.UI_buster_glow.visible = false;
         mUIRoot.UI_buster_active.visible = false;
         mUIRoot.UI_buster.buster_activated_glow.visible = false;
      }
      
      public function handleBusterBarClickEvent() : void
      {
         if(mHeroOwner && mHeroOwner.dungeonBusterPoints >= mHeroOwner.maxBusterPoints)
         {
            mEventComponent.dispatchEvent(new DungeonBusterControlActivatedEvent());
         }
      }
      
      public function setWeaponHighlight(param1:int) : void
      {
         for each(var _loc2_ in mWeaponButtons)
         {
            _loc2_.root.selectionFrame.visible = false;
         }
         mWeaponButtons[param1].root.selectionFrame.visible = true;
      }
      
      public function hideNotEnoughMana() : void
      {
         mUIRoot.UI_center_message.visible = false;
      }
      
      public function showNotEnoughMana() : void
      {
         mUIRoot.UI_center_message.visible = true;
         mUIRoot.UI_center_message.text = Locale.getString("NOT_ENOUGH_MANA");
      }
      
      public function get chatLog() : UIChatLog
      {
         return mUIChatLog;
      }
      
      public function isInCooldown() : void
      {
         showText("IS_IN_COOLDOWN");
      }
      
      public function startCooldown(param1:int, param2:Number) : void
      {
         mCooldowns[param1].clip.visible = true;
         mCooldowns[param1].playRate = 1 / param2 * 4.1;
         mCooldowns[param1].play();
         mWeaponButtons[param1].root.graphic.alpha = 0.5;
      }
      
      public function stopCooldown(param1:int) : void
      {
         var currentWeaponIndex:int = param1;
         mCooldowns[currentWeaponIndex].stop();
         mCooldowns[currentWeaponIndex].clip.visible = false;
         mWeaponButtons[currentWeaponIndex].root.graphic.alpha = 1;
         TweenMax.to(mWeaponButtons[currentWeaponIndex].root.graphic,0.25,{
            "scaleX":1.25,
            "scaleY":1.25,
            "tint":16777215,
            "onComplete":function():void
            {
               TweenMax.to(mWeaponButtons[currentWeaponIndex].root.graphic,0.25,{
                  "scaleX":1,
                  "scaleY":1,
                  "removeTint":true
               });
            }
         });
      }
      
      public function startConsumableCooldown(param1:int, param2:Number) : void
      {
         mConsumableCooldowns[param1].clip.visible = true;
         mConsumableCooldowns[param1].playRate = 1 / param2 * 4.1;
         mConsumableCooldowns[param1].play();
         mConsumableWeaponButtons[param1].root.graphic.alpha = 0.5;
      }
      
      public function stopConsumableCooldown(param1:int) : void
      {
         var currentWeaponIndex:int = param1;
         mConsumableCooldowns[currentWeaponIndex].stop();
         mConsumableCooldowns[currentWeaponIndex].clip.visible = false;
         mConsumableWeaponButtons[currentWeaponIndex].root.graphic.alpha = 1;
         TweenMax.to(mConsumableWeaponButtons[currentWeaponIndex].root.graphic,0.25,{
            "scaleX":1.25,
            "scaleY":1.25,
            "tint":16777215,
            "onComplete":function():void
            {
               TweenMax.to(mConsumableWeaponButtons[currentWeaponIndex].root.graphic,0.25,{
                  "scaleX":1,
                  "scaleY":1,
                  "removeTint":true
               });
            }
         });
      }
      
      public function decrementConsumableCount(param1:uint) : void
      {
         mConsumableWeaponButtons[param1].root.quantity.text = (int(mConsumableWeaponButtons[param1].root.quantity.text) - 1).toString();
      }
      
      public function totalConsumableCountReached(param1:uint) : void
      {
         mConsumableWeaponButtons[param1].enabled = false;
         mConsumableWeaponButtons[param1].root.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
      }
      
      public function showText(param1:String) : void
      {
         var localeTextName:String = param1;
         if(mUIRoot.UI_center_message.visible == false)
         {
            mUIRoot.UI_center_message.visible = true;
            mUIRoot.UI_center_message.text = Locale.getString(localeTextName);
            mLogicalWorkComponent.doLater(0.35,function():void
            {
               mUIRoot.UI_center_message.visible = false;
            });
         }
         else
         {
            mUIRoot.UI_center_message.text = Locale.getString(localeTextName);
         }
      }
      
      public function get teamLootDestination() : Vector3D
      {
         return mTeamLootDestination;
      }
      
      public function get profileDestination() : Vector3D
      {
         return mProfileDestination;
      }
      
      public function get coinsDestination() : Vector3D
      {
         return mCoinsDestination;
      }
      
      public function get cashDestination() : Vector3D
      {
         return mCashDestination;
      }
      
      public function get expDestination() : Vector3D
      {
         return mExpDestination;
      }
      
      public function get crowdDestination() : Vector3D
      {
         return mCrowdDestination;
      }
      
      public function showBuffDisplay(param1:BuffGameObject) : void
      {
         var buffGO:BuffGameObject = param1;
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(buffGO.buffData.IconSwf),function(param1:SwfAsset):void
         {
            var _loc6_:Class = param1.getClass(buffGO.buffData.IconName);
            var _loc5_:MovieClip = new _loc6_() as MovieClip;
            var _loc2_:Class = mSwfAsset.getClass("buff_cooldown_icon");
            var _loc4_:MovieClip = new _loc2_() as MovieClip;
            var _loc7_:MovieClipRenderer = new MovieClipRenderer(mDBFacade,_loc4_.cooldown);
            _loc5_.alpha = 0.75;
            _loc5_.scaleX = _loc5_.scaleY = 0.5;
            _loc4_.graphic.addChild(_loc5_);
            mRoot.addChild(_loc4_);
            var _loc3_:UIButton = new UIButton(mDBFacade,_loc4_);
            _loc3_.tooltip = _loc4_.tooltip;
            _loc4_.tooltip.title_label.text = buffGO.buffData.Name;
            _loc4_.tooltip.description_label.text = buffGO.buffData.Description + buffGO.buffData.getStacksDescription(buffGO.instanceCount);
            mBuffIconButtons.push(_loc3_);
            mBuffs.push(buffGO);
            mBuffCooldowns.push(_loc7_);
            _loc4_.quantity.text = buffGO.instanceCount;
            resetBuffButtonPositions();
            startBuffCooldown(mBuffIconButtons.length - 1,buffGO.buffData.Duration);
         });
      }
      
      public function startBuffCooldown(param1:int, param2:Number) : void
      {
         mBuffCooldowns[param1].playRate = 1 / param2 * 4.1;
         mBuffCooldowns[param1].play();
      }
      
      public function updateBuffDisplay(param1:GameClock) : void
      {
         var _loc3_:int = 0;
         var _loc2_:BuffGameObject = null;
         _loc3_ = 0;
         while(_loc3_ < mBuffs.length)
         {
            _loc2_ = mBuffs[_loc3_];
            if(_loc2_.isDestroyed)
            {
               mRoot.removeChild(mBuffIconButtons[_loc3_].root);
               mBuffIconButtons[_loc3_].destroy();
               mBuffCooldowns[_loc3_].destroy();
               mBuffs.splice(_loc3_,1);
               mBuffIconButtons.splice(_loc3_,1);
               mBuffCooldowns.splice(_loc3_,1);
            }
            _loc3_++;
         }
      }
      
      public function updateBuffInstance(param1:BuffGameObject) : void
      {
         var _loc2_:BuffGameObject = null;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < mBuffs.length)
         {
            _loc2_ = mBuffs[_loc3_];
            if(_loc2_ == param1)
            {
               mBuffIconButtons[_loc3_].root.quantity.text = _loc2_.instanceCount;
               mBuffIconButtons[_loc3_].root.tooltip.description_label.text = _loc2_.buffData.Description + _loc2_.buffData.getStacksDescription(_loc2_.instanceCount);
               startBuffCooldown(_loc3_,_loc2_.buffData.Duration);
               return;
            }
            _loc3_++;
         }
      }
      
      public function resetBuffButtonPositions() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < mBuffs.length)
         {
            if(mHudType == 1)
            {
               mBuffIconButtons[_loc1_].root.x = 300 + _loc1_ * 35;
               mBuffIconButtons[_loc1_].root.y = 490;
            }
            else
            {
               mBuffIconButtons[_loc1_].root.x = 300 + _loc1_ * 35;
               mBuffIconButtons[_loc1_].root.y = 550;
            }
            _loc1_++;
         }
      }
   }
}

