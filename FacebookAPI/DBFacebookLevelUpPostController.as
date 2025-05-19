package FacebookAPI
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Event.EventComponent;
   import Brain.Render.MovieClipRenderController;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.UI.UIButton;
   import Events.FacebookLevelUpPostEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMFeedPosts;
   import GameMasterDictionary.GMSkin;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.as3commons.collections.Map;
   
   public class DBFacebookLevelUpPostController
   {
      
      public static const LEVEL_UP_BRAG:String = "LEVELUP";
      
      public static const TIME_TO_SHARE_LEVEL_UP_EVENT:String = "TIME_TO_SHARE_LEVEL_UP_EVENT";
      
      private var mDBFacade:DBFacade;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mEventComponent:EventComponent;
      
      private var mLevelUpFeedPostsMap:Map;
      
      private var mCurtain:Sprite;
      
      private var mSelectedLevelUpPost:GMFeedPosts;
      
      private var mFeedPostCallbackFunction:Function;
      
      public function DBFacebookLevelUpPostController(param1:DBFacade, param2:Function)
      {
         super();
         mDBFacade = param1;
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mEventComponent = new EventComponent(mDBFacade);
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mFeedPostCallbackFunction = param2;
         mLevelUpFeedPostsMap = new Map();
         mEventComponent.addListener("FacebookLevelUpPostEvent",setlevelUpPost);
         mEventComponent.addListener("TIME_TO_SHARE_LEVEL_UP_EVENT",checkToSharePopup);
      }
      
      public static function makeCurtain(param1:DBFacade, param2:SceneGraphComponent) : Sprite
      {
         if(!param1 || !param2)
         {
            return null;
         }
         var _loc3_:Sprite = new Sprite();
         _loc3_.alpha = 0.75;
         _loc3_.x = 0;
         _loc3_.y = 0;
         _loc3_.graphics.clear();
         _loc3_.graphics.beginFill(0);
         _loc3_.graphics.drawRect(0,0,param1.viewWidth,param1.viewHeight);
         _loc3_.graphics.endFill();
         param2.addChild(_loc3_,105);
         return _loc3_;
      }
      
      public static function removeCurtain(param1:Sprite, param2:SceneGraphComponent) : void
      {
         if(!param1 || !param2)
         {
            return;
         }
         if(param2.contains(param1,105))
         {
            param2.removeChild(param1);
         }
         param1 = null;
      }
      
      private function loadMap() : void
      {
         for each(var _loc1_ in mDBFacade.gameMaster.FeedPosts)
         {
            if(_loc1_.Category == "LEVELUP")
            {
               if(!mLevelUpFeedPostsMap.hasKey(_loc1_.LevelTrigger))
               {
                  mLevelUpFeedPostsMap.add(_loc1_.LevelTrigger,_loc1_);
               }
            }
         }
      }
      
      private function showPopup(param1:GMFeedPosts) : void
      {
         var levelUpPost:GMFeedPosts = param1;
         var gmSkin:GMSkin = mDBFacade.gameMaster.getSkinByType(mDBFacade.dbAccountInfo.activeAvatarInfo.skinId);
         var avatarPicScale:Number = 0.45;
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),function(param1:SwfAsset):void
         {
            var outerSwfAsset:SwfAsset = param1;
            var levelupPopupClass:Class = outerSwfAsset.getClass("UI_prompt_levelup");
            var levelupPopup:MovieClip = new levelupPopupClass();
            levelupPopup.x += 40;
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(gmSkin.PortraitName),function(param1:SwfAsset):void
            {
               var child:int;
               var levelUpButton:UIButton;
               var closeButton:UIButton;
               var swfAsset:SwfAsset = param1;
               var picClass:Class = swfAsset.getClass(gmSkin.IconName);
               var avatarPic:MovieClip = new picClass();
               var movieClipRenderer:MovieClipRenderController = new MovieClipRenderController(mDBFacade,avatarPic);
               movieClipRenderer.play();
               avatarPic.scaleX = avatarPic.scaleY = avatarPicScale;
               if(levelupPopup.avatar.numChildren > 0)
               {
                  child = levelupPopup.avatar.numChildren - 1;
                  while(child >= 0)
                  {
                     levelupPopup.avatar.removeChildAt(child);
                     child--;
                  }
               }
               levelupPopup.avatar.addChildAt(avatarPic,0);
               levelupPopup.level_text.text = levelUpPost.LevelTrigger;
               levelupPopup.congrats_label.text = Locale.getString("LEVEL_UP_SHARE_TITLE");
               levelupPopup.label.text = Locale.getString("LEVEL_UP_SHARE_TEXT") + levelUpPost.LevelTrigger;
               levelUpButton = new UIButton(mDBFacade,levelupPopup.share);
               if(mDBFacade.isDRPlayer)
               {
                  levelUpButton.label.text = Locale.getString("SWEET");
               }
               else
               {
                  levelUpButton.label.text = Locale.getString("LEVEL_UP_SHARE_BUTTON_TEXT");
               }
               closeButton = new UIButton(mDBFacade,levelupPopup.close);
               levelUpButton.releaseCallback = function():void
               {
                  closePopup(levelupPopup);
                  if(mDBFacade.isFacebookPlayer)
                  {
                     mFeedPostCallbackFunction(levelUpPost,"",gmSkin.FeedPostPicture);
                  }
               };
               closeButton.releaseCallback = function():void
               {
                  closePopup(levelupPopup);
               };
               mCurtain = makeCurtain(mDBFacade,mSceneGraphComponent);
               mSceneGraphComponent.addChild(levelupPopup,105);
               levelupPopup.x = mDBFacade.viewWidth / 2;
               levelupPopup.y = mDBFacade.viewHeight / 2;
            });
         });
      }
      
      private function closePopup(param1:MovieClip) : void
      {
         removeCurtain(mCurtain,mSceneGraphComponent);
         mSceneGraphComponent.removeChild(param1);
         param1 = null;
      }
      
      private function checkIfMapIsLoaded() : void
      {
         if(mLevelUpFeedPostsMap.size > 0)
         {
            return;
         }
         loadMap();
      }
      
      private function checkToSharePopup(param1:Event) : void
      {
         checkIfMapIsLoaded();
         if(mSelectedLevelUpPost)
         {
            showPopup(mSelectedLevelUpPost);
            mSelectedLevelUpPost = null;
         }
      }
      
      private function setlevelUpPost(param1:FacebookLevelUpPostEvent) : void
      {
         checkIfMapIsLoaded();
         if(mLevelUpFeedPostsMap.hasKey(param1.level))
         {
            mSelectedLevelUpPost = mLevelUpFeedPostsMap.itemFor(param1.level);
         }
      }
      
      public function destroy() : void
      {
         mDBFacade = null;
         mAssetLoadingComponent = null;
         mEventComponent = null;
         mSelectedLevelUpPost = null;
         mLevelUpFeedPostsMap.clear();
         mFeedPostCallbackFunction = null;
      }
   }
}

