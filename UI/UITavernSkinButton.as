package UI
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.UI.UIObject;
   import Brain.UI.UIRadioButton;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMSkin;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class UITavernSkinButton extends UIRadioButton
   {
      
      protected var mDBFacade:DBFacade;
      
      private var mGMSkin:GMSkin;
      
      private var mHeroRequired:MovieClip;
      
      private var mIcon:MovieClip;
      
      private var mClassicLabel:TextField;
      
      private var mShowSkinInTavernCallback:Function;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mAvatarIconSlot:MovieClip;
      
      private var mChosenClip:MovieClip;
      
      private var mHighlight:MovieClip;
      
      public function UITavernSkinButton(param1:DBFacade, param2:MovieClip, param3:Function)
      {
         mDBFacade = param1;
         super(param1,param2,"skin_selector_buttons");
         this.releaseCallback = clicked;
         mHeroRequired = mRoot.hero_required;
         mHeroRequired.visible = false;
         mHeroRequired.required_text.text = Locale.getString("TAVERN_SKIN_BUTTON_HERO_REQUIRED");
         mShowSkinInTavernCallback = param3;
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mAvatarIconSlot = mRoot.slot;
         mHighlight = mRoot.selected;
         mHighlight.visible = false;
         mChosenClip = mRoot.chosen;
         mChosenClip.visible = false;
         mClassicLabel = mRoot.classic_text;
         mClassicLabel.text = Locale.getString("TAVERN_SKIN_SLOT_HERO_LABEL");
      }
      
      public function set chosen(param1:Boolean) : void
      {
         mChosenClip.visible = param1;
      }
      
      public function set gmSkin(param1:GMSkin) : void
      {
         mGMSkin = param1;
         refresh();
      }
      
      private function refresh() : void
      {
         var hero:GMHero = mDBFacade.gameMaster.heroByConstant.itemFor(mGMSkin.ForHero);
         var swfPath:String = mGMSkin.UISwfFilepath;
         var iconName:String = mGMSkin.IconName;
         if(mIcon != null && mAvatarIconSlot.contains(mIcon))
         {
            mAvatarIconSlot.removeChild(mIcon);
         }
         while(mAvatarIconSlot.numChildren > 1)
         {
            mAvatarIconSlot.removeChildAt(mAvatarIconSlot.numChildren - 1);
         }
         mClassicLabel.visible = mGMSkin.Constant == hero.DefaultSkin;
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(swfPath),function(param1:SwfAsset):void
         {
            var _loc3_:Class = param1.getClass(iconName);
            mIcon = new _loc3_();
            var _loc2_:uint = mAvatarIconSlot.width < mAvatarIconSlot.height ? mAvatarIconSlot.width : mAvatarIconSlot.height;
            UIObject.scaleToFit(mIcon,_loc2_);
            mAvatarIconSlot.addChildAt(mIcon,1);
         });
      }
      
      private function clicked() : void
      {
         mShowSkinInTavernCallback(mGMSkin);
         var _loc1_:GMHero = mDBFacade.gameMaster.heroByConstant.itemFor(mGMSkin.ForHero);
         mDBFacade.metrics.log("StyleView",{
            "heroType":_loc1_.Id,
            "styleType":mGMSkin.Id
         });
         this.selected = true;
      }
   }
}

