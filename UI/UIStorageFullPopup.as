package UI
{
   import Brain.AssetRepository.SwfAsset;
   import Facade.DBFacade;
   import Facade.Locale;
   
   public class UIStorageFullPopup extends DBUITwoButtonPopup
   {
      
      public static const STORAGE_POPUP_CLASS_NAME:String = "popup_add_storage";
      
      public function UIStorageFullPopup(param1:DBFacade, param2:String, param3:*, param4:String, param5:Function, param6:String, param7:Function, param8:Boolean = true, param9:Function = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9);
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         super.setupUI(param1,param2,param3,param4,param5);
         mPopup.title_label.text = Locale.getString("STORAGE_FULL_TITLE");
         mPopup.message_label.text = Locale.getString("STORAGE_FULL_DESCRIPTION");
      }
      
      override protected function getClassName() : String
      {
         return "popup_add_storage";
      }
   }
}

