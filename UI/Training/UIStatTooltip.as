package UI.Training
{
   import Facade.DBFacade;
   import GameMasterDictionary.GMStat;
   import GameMasterDictionary.GMSuperStat;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class UIStatTooltip extends MovieClip
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mRoot:MovieClip;
      
      protected var mGMStatItem:GMStat;
      
      protected var mGMSuperStatItem:GMSuperStat;
      
      protected var mTitleLabel:TextField;
      
      protected var mDescription:TextField;
      
      public function UIStatTooltip(param1:DBFacade, param2:Class)
      {
         super();
         mDBFacade = param1;
         mRoot = new param2();
         this.addChild(mRoot);
         mTitleLabel = mRoot.title_label;
         mDescription = mRoot.stat_description_label;
      }
      
      public function destroy() : void
      {
         mDBFacade = null;
         this.removeChild(mRoot);
         mRoot = null;
      }
      
      public function set statItem(param1:GMStat) : void
      {
         mGMStatItem = param1;
         mTitleLabel.text = mGMStatItem.Name.toUpperCase();
         mDescription.text = mGMStatItem.Description;
      }
      
      public function set superStatItem(param1:GMSuperStat) : void
      {
         mGMSuperStatItem = param1;
         mTitleLabel.text = mGMSuperStatItem.Name.toUpperCase();
         mDescription.text = mGMSuperStatItem.Description;
      }
   }
}

