package FacebookAPI
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.ImageAsset;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Render.MovieClipRenderController;
   import Brain.Render.MovieClipRenderer;
   import Brain.UI.UIObject;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMFeedPosts;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMMapNode;
   import GameMasterDictionary.GMNpc;
   import GameMasterDictionary.GMSkin;
   import Town.TownHeader;
   import UI.DBUIOneButtonPopup;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public class DBFacebookBragFeedPost
   {
      
      public function DBFacebookBragFeedPost()
      {
         super();
      }
      
      public static function buyHeroSuccess(param1:TownHeader, param2:GMHero, param3:DBFacade, param4:AssetLoadingComponent) : void
      {
         var gloatPopup:MovieClip;
         var popupCenterButtonText:String;
         var townHeader:TownHeader = param1;
         var gmHero:GMHero = param2;
         var facade:DBFacade = param3;
         var assetLoadingComponent:AssetLoadingComponent = param4;
         var popupTitle:String = Locale.getString("BRAG_BUY_HERO_SUCCESS_POPUP_TITLE");
         var avatarPicScale:Number = 0.4;
         if(facade.isDRPlayer)
         {
            popupCenterButtonText = Locale.getString("SWEET");
         }
         else
         {
            popupCenterButtonText = Locale.getString("BRAG_BUY_HERO_SUCCESS_POPUP_BUTTON");
         }
         assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),function(param1:SwfAsset):void
         {
            var swfAsset:SwfAsset = param1;
            var tooltipClass:Class = swfAsset.getClass("weapon_tavern_tooltip");
            var gloatPopupClassName:String = "avatar_purchase_popup";
            var gloatPopupClass:Class = swfAsset.getClass(gloatPopupClassName);
            gloatPopup = new gloatPopupClass();
            gloatPopup.x += 40;
            assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(gmHero.PortraitName),function(param1:SwfAsset):void
            {
               var TeamBonusUI:UIObject;
               var teamBonusUIMCRenderer:MovieClipRenderer;
               var TeamBonusUIHeader:UIObject;
               var teamBonusUIHeaderMCRenderer:MovieClipRenderer;
               var onCompleteFunc:Function;
               var onCompleteHeaderFunc:Function;
               var popup:DBUIOneButtonPopup;
               var swfAsset:SwfAsset = param1;
               var picClass:Class = swfAsset.getClass(gmHero.IconName);
               var avatarPic:MovieClip = new picClass();
               var movieClipRenderer:MovieClipRenderController = new MovieClipRenderController(facade,avatarPic);
               movieClipRenderer.play();
               avatarPic.scaleX = avatarPic.scaleY = avatarPicScale;
               if(gloatPopup.avatar.numChildren > 0)
               {
                  gloatPopup.avatar.removeChildAt(0);
               }
               gloatPopup.avatar.addChildAt(avatarPic,0);
               gloatPopup.gloat_text.text = Locale.getString("BRAG_BUY_HERO_SUCCESS_POPUP_TEXT") + gmHero.Name.toUpperCase();
               TeamBonusUI = new UIObject(facade,gloatPopup.crewbonus);
               TeamBonusUI.tooltip.title_label.text = Locale.getString("TEAM_BONUS_TOOLTIP_TITLE");
               TeamBonusUI.tooltip.description_label.text = Locale.getString("TEAM_BONUS_TOOLTIP_DESCRIPTION");
               TeamBonusUI.root.header_crew_bonus_number.text = facade.dbAccountInfo.inventoryInfo.getTotalHeroesOwned() - 2;
               teamBonusUIMCRenderer = new MovieClipRenderer(facade,TeamBonusUI.root.header_crew_bonus_anim,onCompleteFunc);
               teamBonusUIMCRenderer.play();
               TeamBonusUIHeader = new UIObject(facade,gloatPopup.crewbonus_header);
               TeamBonusUIHeader.tooltip.title_label.text = Locale.getString("TEAM_BONUS_TOOLTIP_TITLE");
               TeamBonusUIHeader.tooltip.description_label.text = Locale.getString("TEAM_BONUS_TOOLTIP_DESCRIPTION");
               TeamBonusUIHeader.root.header_crew_bonus_number.text = facade.dbAccountInfo.inventoryInfo.getTotalHeroesOwned() - 2;
               teamBonusUIHeaderMCRenderer = new MovieClipRenderer(facade,TeamBonusUIHeader.root.header_crew_bonus_anim,onCompleteHeaderFunc);
               teamBonusUIHeaderMCRenderer.play();
               onCompleteFunc = function():void
               {
                  TeamBonusUI.root.header_crew_bonus_number.text = facade.dbAccountInfo.inventoryInfo.getTotalHeroesOwned() - 1;
               };
               onCompleteHeaderFunc = function():void
               {
                  TeamBonusUIHeader.root.header_crew_bonus_number.text = facade.dbAccountInfo.inventoryInfo.getTotalHeroesOwned() - 1;
               };
               TweenMax.to(TeamBonusUI.root.header_crew_bonus_number,1.4,{"onComplete":onCompleteFunc});
               TweenMax.to(TeamBonusUIHeader.root.header_crew_bonus_number,1.4,{"onComplete":onCompleteHeaderFunc});
               popup = new DBUIOneButtonPopup(facade,popupTitle,gloatPopup,popupCenterButtonText,function():void
               {
                  if(!facade.isDRPlayer)
                  {
                     facade.facebookController.purchaseFeedPost(gmHero.Id);
                  }
                  TeamBonusUI.destroy();
                  TeamBonusUI = null;
                  TeamBonusUIHeader.destroy();
                  TeamBonusUIHeader = null;
               });
               avatarPic.y -= avatarPic.height / 2;
               avatarPic.x -= 150 * avatarPicScale;
               townHeader.updateTeamBonusUI();
            });
         });
      }
      
      public static function buySkinSuccess(param1:GMSkin, param2:DBFacade, param3:AssetLoadingComponent) : void
      {
         var gloatPopup:MovieClip;
         var popupCenterButtonText:String;
         var gmSkin:GMSkin = param1;
         var facade:DBFacade = param2;
         var assetLoadingComponent:AssetLoadingComponent = param3;
         var popupTitle:String = Locale.getString("BRAG_BUY_HERO_SUCCESS_POPUP_TITLE");
         var avatarPicScale:Number = 0.45;
         if(facade.isDRPlayer)
         {
            popupCenterButtonText = Locale.getString("SWEET");
         }
         else
         {
            popupCenterButtonText = Locale.getString("BRAG_BUY_HERO_SUCCESS_POPUP_BUTTON");
         }
         assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),function(param1:SwfAsset):void
         {
            var swfAsset:SwfAsset = param1;
            var tooltipClass:Class = swfAsset.getClass("weapon_tavern_tooltip");
            var gloatPopupClass:Class = swfAsset.getClass("tavern_gloat");
            gloatPopup = new gloatPopupClass();
            gloatPopup.x += 40;
            assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(gmSkin.PortraitName),function(param1:SwfAsset):void
            {
               var popup:DBUIOneButtonPopup;
               var swfAsset:SwfAsset = param1;
               var picClass:Class = swfAsset.getClass(gmSkin.IconName);
               var avatarPic:MovieClip = new picClass();
               var movieClipRenderer:MovieClipRenderController = new MovieClipRenderController(facade,avatarPic);
               movieClipRenderer.play();
               avatarPic.scaleX = avatarPic.scaleY = avatarPicScale;
               avatarPic.y -= avatarPic.height / 2;
               avatarPic.x -= 150 * avatarPicScale;
               if(gloatPopup.avatar.numChildren > 0)
               {
                  gloatPopup.avatar.removeChildAt(0);
               }
               gloatPopup.avatar.addChildAt(avatarPic,0);
               gloatPopup.gloat_text.text = Locale.getString("BRAG_BUY_HERO_SUCCESS_POPUP_TEXT") + gmSkin.Name.toUpperCase();
               popup = new DBUIOneButtonPopup(facade,popupTitle,gloatPopup,popupCenterButtonText,function():void
               {
                  if(!facade.isDRPlayer)
                  {
                     facade.facebookController.purchaseFeedPost(gmSkin.Id);
                  }
               });
            });
         });
      }
      
      public static function buyPetSuccess(param1:GMNpc, param2:DBFacade, param3:AssetLoadingComponent) : void
      {
         var gloatPopup:MovieClip;
         var popupCenterButtonText:String;
         var gmPet:GMNpc = param1;
         var facade:DBFacade = param2;
         var assetLoadingComponent:AssetLoadingComponent = param3;
         var popupTitle:String = Locale.getString("BRAG_BUY_PET_SUCCESS_POPUP_TITLE");
         var avatarPicScale:Number = 1;
         if(facade.isDRPlayer)
         {
            popupCenterButtonText = Locale.getString("SWEET");
         }
         else
         {
            popupCenterButtonText = Locale.getString("BRAG_BUY_PET_SUCCESS_POPUP_BUTTON");
         }
         assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),function(param1:SwfAsset):void
         {
            var swfAsset:SwfAsset = param1;
            var tooltipClass:Class = swfAsset.getClass("weapon_tavern_tooltip");
            var gloatPopupClass:Class = swfAsset.getClass("tavern_gloat");
            gloatPopup = new gloatPopupClass();
            gloatPopup.x += 40;
            assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(gmPet.IconSwfFilepath),function(param1:SwfAsset):void
            {
               var popup:DBUIOneButtonPopup;
               var swfAsset:SwfAsset = param1;
               var picClass:Class = swfAsset.getClass(gmPet.IconName);
               var avatarPic:MovieClip = new picClass();
               var movieClipRenderer:MovieClipRenderController = new MovieClipRenderController(facade,avatarPic);
               movieClipRenderer.play();
               avatarPic.scaleX = avatarPic.scaleY = avatarPicScale;
               avatarPic.y -= avatarPic.height / 2;
               avatarPic.x = 0;
               if(gloatPopup.avatar.numChildren > 0)
               {
                  gloatPopup.avatar.removeChildAt(0);
               }
               gloatPopup.avatar.addChildAt(avatarPic,0);
               gloatPopup.gloat_text.text = Locale.getString("BRAG_BUY_PET_SUCCESS_POPUP_TEXT") + gmPet.Name.toUpperCase();
               popup = new DBUIOneButtonPopup(facade,popupTitle,gloatPopup,popupCenterButtonText,function():void
               {
                  if(!facade.isDRPlayer)
                  {
                     facade.facebookController.purchaseFeedPost(gmPet.Id);
                  }
               });
            });
         });
      }
      
      public static function openChestBrag(param1:DBFacade, param2:String, param3:String, param4:MovieClip, param5:String, param6:uint, param7:AssetLoadingComponent) : void
      {
         var gloatPopup:MovieClip;
         var popupCenterButtonText:String;
         var facade:DBFacade = param1;
         var shortItemName:String = param2;
         var fullItemName:String = param3;
         var itemPic:MovieClip = param4;
         var imagePath:String = param5;
         var itemType:uint = param6;
         var assetLoadingComponent:AssetLoadingComponent = param7;
         var popupTitle:String = Locale.getString("BRAG_CHEST_OPEN_POPUP_TITLE");
         var picScale:Number = 1;
         if(facade.isDRPlayer)
         {
            popupCenterButtonText = Locale.getString("SWEET");
         }
         else
         {
            popupCenterButtonText = Locale.getString("BRAG_CHEST_OPEN_POPUP_BUTTON");
         }
         assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),function(param1:SwfAsset):void
         {
            var movieClipRenderer:MovieClipRenderController;
            var popup:DBUIOneButtonPopup;
            var swfAsset:SwfAsset = param1;
            var tooltipClass:Class = swfAsset.getClass("weapon_tavern_tooltip");
            var gloatPopupClass:Class = swfAsset.getClass("tavern_gloat");
            gloatPopup = new gloatPopupClass();
            gloatPopup.x += 40;
            movieClipRenderer = new MovieClipRenderController(facade,itemPic);
            movieClipRenderer.play();
            itemPic.scaleX = itemPic.scaleY = picScale;
            itemPic.y = 0;
            itemPic.x = 0;
            if(gloatPopup.avatar.numChildren > 0)
            {
               gloatPopup.avatar.removeChildAt(0);
            }
            gloatPopup.avatar.addChildAt(itemPic,0);
            gloatPopup.gloat_text.text = Locale.getString("BRAG_CHEST_OPEN_POPUP_TEXT") + fullItemName.toUpperCase();
            popup = new DBUIOneButtonPopup(facade,popupTitle,gloatPopup,popupCenterButtonText,function():void
            {
               if(!facade.isDRPlayer)
               {
                  facade.facebookController.chestUnlockFeedPost(itemType,shortItemName,fullItemName,imagePath);
               }
            });
         });
      }
      
      public static function defeatMapNodeBrag(param1:DBFacade, param2:GMMapNode, param3:AssetLoadingComponent) : void
      {
         var gloatPopup:MovieClip;
         var popupTitle:String;
         var popupCenterButtonText:String;
         var picScale:Number;
         var itemPic:Bitmap;
         var facade:DBFacade = param1;
         var gmMapNode:GMMapNode = param2;
         var assetLoadingComponent:AssetLoadingComponent = param3;
         var feedPosts:Vector.<GMFeedPosts> = DBFacebookAPIController.getFeedPosts(facade,gmMapNode.Id,"MAP_NODE_DEFEATED");
         if(feedPosts.length == 0)
         {
            return;
         }
         popupTitle = Locale.getString("BRAG_MAP_NODE_DEFEATED_POPUP_TITLE");
         picScale = 1.25;
         if(facade.isDRPlayer)
         {
            popupCenterButtonText = Locale.getString("SWEET");
         }
         else
         {
            popupCenterButtonText = Locale.getString("BRAG_MAP_NODE_DEFEATED_POPUP_BUTTON");
         }
         assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),function(param1:SwfAsset):void
         {
            var feedPosts:Vector.<GMFeedPosts>;
            var swfAsset:SwfAsset = param1;
            var tooltipClass:Class = swfAsset.getClass("weapon_tavern_tooltip");
            var gloatPopupClass:Class = swfAsset.getClass("tavern_gloat");
            gloatPopup = new gloatPopupClass();
            gloatPopup.x += 40;
            feedPosts = DBFacebookAPIController.getFeedPosts(facade,gmMapNode.Id,"MAP_NODE_DEFEATED");
            assetLoadingComponent.getImageAsset(DBFacade.buildFullDownloadPath(feedPosts[0].FeedImageLink),function(param1:ImageAsset):void
            {
               var popup:DBUIOneButtonPopup;
               var imageAsset:ImageAsset = param1;
               itemPic = imageAsset.image;
               itemPic.scaleX = itemPic.scaleY = picScale;
               itemPic.y = -itemPic.height * 0.5;
               itemPic.x = -itemPic.width * 0.5;
               if(gloatPopup.avatar.numChildren > 0)
               {
                  gloatPopup.avatar.removeChildAt(0);
               }
               gloatPopup.avatar.addChildAt(itemPic,0);
               gloatPopup.gloat_text.text = Locale.getString("BRAG_MAP_NODE_DEFEATED_POPUP_TEXT") + gmMapNode.Name.toUpperCase();
               popup = new DBUIOneButtonPopup(facade,popupTitle,gloatPopup,popupCenterButtonText,function():void
               {
                  if(!facade.isDRPlayer)
                  {
                     facade.facebookController.mapNodeDefeatedFeedPost(gmMapNode.Id,gmMapNode.Name);
                  }
               });
            });
         });
      }
   }
}

