package UI
{
   import Brain.AssetRepository.SwfAsset;
   import Facade.DBFacade;
   import Facade.Locale;
   
   public class UIRetrainPopup extends DBUITwoButtonPopup
   {
      
      protected static const SWF_PATH:String = "Resources/Art2D/UI/db_UI_town.swf";
      
      protected static const POPUP_CLASS_NAME:String = "popup_retrain";
      
      private var mPrice:uint;
      
      public function UIRetrainPopup(param1:DBFacade, param2:Function, param3:uint)
      {
         mPrice = param3;
         super(param1,Locale.getString("RETRAIN_POPUP_TITLE"),Locale.getString("RETRAIN_POPUP_MESSAGE"),Locale.getString("RETRAIN_BUY"),param2,Locale.getString("CANCEL"),null,true,null);
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         super.setupUI(param1,param2,param3,param4,param5);
         mLeftButton.label.text = mPrice.toString();
      }
      
      override protected function getSwfPath() : String
      {
         return "Resources/Art2D/UI/db_UI_town.swf";
      }
      
      override protected function getClassName() : String
      {
         return "popup_retrain";
      }
   }
}

