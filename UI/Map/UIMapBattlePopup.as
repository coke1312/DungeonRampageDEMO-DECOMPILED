package UI.Map
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.Render.MovieClipRenderController;
   import Brain.UI.UIButton;
   import Brain.UI.UIObject;
   import Brain.UI.UIProgressBar;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMColiseumTier;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMMapNode;
   import GameMasterDictionary.GMSkin;
   import UI.DBUIPopup;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   
   public class UIMapBattlePopup extends DBUIPopup
   {
      
      protected static const SWF_PATH:String = "Resources/Art2D/UI/db_UI_screens.swf";
      
      protected static const POPUP_CLASS_NAME:String = "battle_popup";
      
      protected static const POPUP_CLASS_NAME_CONSUMABLES:String = "battle_popup_consumables";
      
      private static const BATTLE_POPUP_POSITION:Point = new Point(0,0);
      
      private var mActiveStacks:Vector.<UIButton>;
      
      private var mActiveHeroPortrait:MovieClip;
      
      private var mMapNodeOpen:Boolean = false;
      
      protected var mCurrentDungeon:GMMapNode;
      
      private var mBattleButton:UIButton;
      
      private var mChangeHeroButton:UIButton;
      
      private var mChangeStatButton:UIButton;
      
      private var mChangeStatReleaseCallback:Function;
      
      private var mChangeHeroReleaseCallback:Function;
      
      private var mChangeShopReleaseCallback:Function;
      
      private var mBattleReleaseCallback:Function;
      
      private var mPrivateButton:UIButton;
      
      public var IsPrivate:Boolean = false;
      
      private var mTeamBonusUI:UIObject;
      
      public function UIMapBattlePopup(param1:DBFacade, param2:Function, param3:Function, param4:Function, param5:Function, param6:String)
      {
         mBattleReleaseCallback = param5;
         mChangeHeroReleaseCallback = param2;
         mChangeStatReleaseCallback = param3;
         mChangeShopReleaseCallback = param4;
         super(param1,param6,null,true,false);
      }
      
      override protected function getSwfPath() : String
      {
         return "Resources/Art2D/UI/db_UI_screens.swf";
      }
      
      override protected function getClassName() : String
      {
         return "battle_popup_consumables";
      }
      
      private function togglePrivate() : void
      {
         IsPrivate = !IsPrivate;
         mPrivateButton.selected = IsPrivate;
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         var activeHeroSkin:GMSkin;
         var gmHero:GMHero;
         var currentXp:int;
         var level:uint;
         var levelIndex:uint;
         var lastLevelExp:uint;
         var max:uint;
         var xpBar:UIProgressBar;
         var swfAsset:SwfAsset = param1;
         var titleText:String = param2;
         var content:* = param3;
         var allowClose:Boolean = param4;
         var closeCallback:Function = param5;
         super.setupUI(swfAsset,titleText,content,allowClose,closeCallback);
         mPopup.visible = false;
         if(mPopup.text_activeBooster)
         {
            mPopup.text_activeBooster.text = Locale.getString("WORLD_MAP_STATS");
         }
         if(mPopup.text_victorRewards)
         {
            mPopup.text_victorRewards.text = Locale.getString("WORLD_MAP_VICTORY_REWARDS");
         }
         mPopup.private_dungeon_label.text = Locale.getString("PRIVATE_DUNGEON_LABEL");
         mPrivateButton = new UIButton(mDBFacade,mPopup.radio_button);
         mPrivateButton.releaseCallback = togglePrivate;
         mPrivateButton.selected = IsPrivate;
         activeHeroSkin = mDBFacade.gameMaster.getSkinByType(mDBFacade.dbAccountInfo.activeAvatarInfo.skinId);
         gmHero = mDBFacade.gameMaster.heroByConstant.itemFor(activeHeroSkin.ForHero);
         mPopup.txt_avatar.text = gmHero.Name.toUpperCase();
         mActiveHeroPortrait = mPopup.avatarContainer.avatar;
         currentXp = int(mDBFacade.dbAccountInfo.activeAvatarInfo.experience);
         level = gmHero.getLevelFromExp(currentXp);
         levelIndex = uint(gmHero.getLevelIndex(currentXp));
         lastLevelExp = uint(levelIndex > 0 ? gmHero.getExpFromIndex(levelIndex - 1) : 0);
         max = gmHero.getExpFromIndex(levelIndex);
         if(currentXp < max)
         {
            xpBar = new UIProgressBar(mFacade,mPopup.UI_XP.xp_bar);
            mPopup.UI_XP.xp_bar_delta.visible = false;
            mPopup.UI_XP.xp_points.text = currentXp + "/" + max;
            xpBar.maximum = max;
            xpBar.minimum = lastLevelExp;
            xpBar.value = currentXp;
         }
         else
         {
            mPopup.UI_XP.xp_points.text = currentXp.toString();
         }
         mPopup.UI_XP.xp_level.text = level;
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(activeHeroSkin.PortraitName),function(param1:SwfAsset):void
         {
            var _loc3_:Class = param1.getClass(activeHeroSkin.CardName);
            if(_loc3_ == null)
            {
               return;
            }
            var _loc4_:MovieClip = new _loc3_();
            var _loc2_:MovieClipRenderController = new MovieClipRenderController(mDBFacade,_loc4_);
            _loc2_.play();
            if(mActiveHeroPortrait.numChildren > 0)
            {
               mActiveHeroPortrait.removeChildAt(0);
            }
            mActiveHeroPortrait.addChildAt(_loc4_,0);
         });
         mChangeHeroButton = new UIButton(mDBFacade,mPopup.button_swapAvatar);
         mChangeHeroButton.dontKillMyChildren = true;
         mChangeHeroButton.releaseCallback = mChangeHeroReleaseCallback;
         mChangeHeroButton.rollOverCursor = "POINT";
         mPopup.button_battle.battle_text.mouseChildren = false;
         mPopup.button_battle.battle_text.mouseEnabled = false;
         mBattleButton = new UIButton(mDBFacade,mPopup.button_battle);
         mBattleButton.dontKillMyChildren = true;
         if(mDBFacade.dbAccountInfo.inventoryInfo.getEquipedItemsOnAvatar(mDBFacade.dbAccountInfo.activeAvatarInfo.id).length == 0)
         {
            mDBFacade.errorPopup("Warning","Cannot enter dungeon with no weapons equipped.");
            mBattleButton.releaseCallback = function():void
            {
               mDBFacade.errorPopup("Warning","Cannot enter dungeon with no weapons equipped.");
               mDBFacade.metrics.log("NoWeaponsEquippedWarning");
            };
         }
         else
         {
            mBattleButton.releaseCallback = mBattleReleaseCallback;
         }
         mBattleButton.rollOverCursor = "POINT";
         if(mCloseButton)
         {
            mCloseButton.dontKillMyChildren = true;
            mCloseButton.releaseCallback = this.animatePopupOut;
            mCloseButton.rollOverCursor = "POINT";
         }
         if(mPopup.crewbonus)
         {
            mTeamBonusUI = new UIObject(mDBFacade,mPopup.crewbonus);
            mTeamBonusUI.tooltip.title_label.text = Locale.getString("TEAM_BONUS_TOOLTIP_TITLE");
            mTeamBonusUI.tooltip.description_label.text = Locale.getString("TEAM_BONUS_TOOLTIP_DESCRIPTION");
            mTeamBonusUI.root.header_crew_bonus_number.text = mDBFacade.dbAccountInfo.inventoryInfo.getTotalHeroesOwned() - 1;
            mPopup.crewBonus_label.text = ((mDBFacade.dbAccountInfo.inventoryInfo.getTotalHeroesOwned() - 1) * 5).toString() + Locale.getString("TEAM_BONUS_BATTLE_POPUP_TEXT");
         }
         setDungeonDetails();
      }
      
      override protected function handleKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 27)
         {
            this.animatePopupOut();
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(mTeamBonusUI)
         {
            mTeamBonusUI.destroy();
         }
         if(mBattleButton)
         {
            mBattleButton.destroy();
            mBattleButton = null;
         }
         if(mChangeHeroButton)
         {
            mChangeHeroButton.destroy();
            mChangeHeroButton = null;
         }
         if(mChangeStatButton)
         {
            mChangeStatButton.destroy();
            mChangeStatButton = null;
         }
      }
      
      public function get battleButton() : UIButton
      {
         return mBattleButton;
      }
      
      public function setTitle(param1:String) : void
      {
         if(mPopup && mPopup.title_label)
         {
            mPopup.title_label.text = param1;
         }
      }
      
      public function setDifficulty(param1:String) : void
      {
         if(mPopup && mPopup.text_recommendedLevel)
         {
            mPopup.text_recommendedLevel.text = param1;
         }
      }
      
      public function set mapNodeOpen(param1:Boolean) : void
      {
         mMapNodeOpen = param1;
      }
      
      public function set currentDungeon(param1:GMMapNode) : void
      {
         mCurrentDungeon = param1;
      }
      
      public function setDungeonDetails() : void
      {
         var _loc2_:GMColiseumTier = null;
         var _loc1_:String = null;
         if(mCurrentDungeon == null || mPopup == null)
         {
            return;
         }
         if(mDBFacade && mDBFacade.gameMaster && mDBFacade.gameMaster.coliseumTierByConstant)
         {
            _loc2_ = mDBFacade.gameMaster.coliseumTierByConstant.itemFor(mCurrentDungeon.TierRank);
         }
         if(_loc2_ && mPopup.dungeonXp_label)
         {
            mPopup.dungeonXp_label.text = mCurrentDungeon.CompletionXPBonus.toString() + Locale.getString("WORLD_MAP_BONUS_XP");
         }
         mPopup.button_battle.battle_text.battle_text.text = Locale.getString("WORLD_MAP_UNLOCK");
         setTitle(mCurrentDungeon.Name.toUpperCase());
         if(_loc2_.TotalFloors > 0 && mCurrentDungeon.NodeType != "BOSS")
         {
            _loc1_ = _loc2_.TotalFloors > 1 ? Locale.getString("FLOORS").toUpperCase() : Locale.getString("FLOOR").toUpperCase();
            if(_loc2_.TotalFloors >= 50)
            {
               setDifficulty("INFINITE " + _loc1_);
            }
            else
            {
               setDifficulty(_loc2_.TotalFloors.toString() + " " + _loc1_);
            }
         }
         else
         {
            setDifficulty(mCurrentDungeon.DifficultyName);
         }
      }
      
      public function get keyCostClip() : MovieClip
      {
         if(mPopup)
         {
            return mPopup.basic_key_icon;
         }
         return null;
      }
      
      public function animatePopupIn() : void
      {
         if(mPopup == null)
         {
            return;
         }
         mPopup.visible = true;
         if(!mCurtainActive)
         {
            makeCurtain();
         }
         var _loc1_:Number = BATTLE_POPUP_POSITION.x;
         var _loc2_:Number = BATTLE_POPUP_POSITION.y;
         mPopup.x = 480;
         mPopup.y = _loc2_;
         TweenMax.killTweensOf(mPopup);
         new TimelineMax({
            "tweens":[TweenMax.to(mPopup,0.25,{
               "x":_loc1_,
               "y":_loc2_
            })],
            "align":"sequence"
         });
      }
      
      public function animatePopupOut(param1:Boolean = false) : void
      {
         var destX:Number;
         var destY:Number;
         var startX:Number;
         var hidePopup:Function;
         var keepCurtain:Boolean = param1;
         if(mPopup == null)
         {
            return;
         }
         if(mCurtainActive && !keepCurtain)
         {
            removeCurtain();
         }
         destX = 800;
         destY = BATTLE_POPUP_POSITION.y;
         startX = BATTLE_POPUP_POSITION.x;
         mPopup.x = startX;
         mPopup.y = destY;
         hidePopup = function():void
         {
            if(mPopup)
            {
               mPopup.visible = false;
            }
         };
         TweenMax.killTweensOf(mPopup);
         new TimelineMax({
            "tweens":[TweenMax.to(mPopup,0.25,{
               "x":destX,
               "y":destY,
               "onComplete":hidePopup
            })],
            "align":"sequence"
         });
      }
   }
}

