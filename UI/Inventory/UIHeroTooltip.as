package UI.Inventory
{
   import Account.AvatarInfo;
   import Facade.DBFacade;
   import GameMasterDictionary.GMHero;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class UIHeroTooltip extends MovieClip
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mRoot:MovieClip;
      
      protected var mLabel:TextField;
      
      protected var mLevelLabel:TextField;
      
      protected var mDescriptionLabel:TextField;
      
      protected var mStar:MovieClip;
      
      public function UIHeroTooltip(param1:DBFacade, param2:Class)
      {
         super();
         mDBFacade = param1;
         mRoot = new param2();
         this.addChild(mRoot);
         mLabel = mRoot.title_label;
         mLevelLabel = mRoot.level_star_label;
         mDescriptionLabel = mRoot.description_label;
         mStar = mRoot.star;
      }
      
      public function destroy() : void
      {
         mDBFacade = null;
         this.removeChild(mRoot);
         mRoot = null;
      }
      
      public function set ownedHero(param1:AvatarInfo) : void
      {
         mLabel.text = param1.gmHero.Name.toUpperCase();
         mLevelLabel.text = param1.level.toString();
         mLevelLabel.visible = true;
         mStar.visible = true;
         mDescriptionLabel.visible = false;
      }
      
      public function set unownedHero(param1:GMHero) : void
      {
         mLabel.text = param1.Name.toUpperCase();
         mLevelLabel.visible = false;
         mStar.visible = false;
         mDescriptionLabel.text = "Not Unlocked";
         mDescriptionLabel.visible = true;
      }
   }
}

