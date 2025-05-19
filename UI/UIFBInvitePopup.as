package UI
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import Facade.Locale;
   import flash.display.Sprite;
   
   public class UIFBInvitePopup extends DBUIOneButtonPopup
   {
      
      protected static const SWF_PATH:String = "Resources/Art2D/UI/db_UI_screens.swf";
      
      protected static const POPUP_CLASS_NAME:String = "invite_popup";
      
      public function UIFBInvitePopup(param1:DBFacade, param2:Function)
      {
         super(param1,Locale.getString("INVITE_POPUP_TITLE"),Locale.getString("INVITE_POPUP_MESSAGE"),Locale.getString("INVITE_POPUP_BUTTON"),param2,true,null);
         mDBFacade.metrics.log("InvitePopupPresented");
      }
      
      override protected function getSwfPath() : String
      {
         return "Resources/Art2D/UI/db_UI_screens.swf";
      }
      
      override protected function getClassName() : String
      {
         return "invite_popup";
      }
      
      override protected function centerButtonCallback() : void
      {
         mDBFacade.metrics.log("InvitePopupContinue");
         super.centerButtonCallback();
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         super.setupUI(param1,param2,param3,param4,param5);
         mPopup.player_name_label.text = mDBFacade.dbAccountInfo.name;
         mPopup.chatBalloon.chatMessage.text = Locale.getString("INVITE_POPUP_CHAT");
         mPopup.nametag_1.visible = false;
         mPopup.nametag_2.visible = false;
         mPopup.nametag_3.visible = false;
         mDBFacade.facebookAccountInfo.loadFriends(this.loadedFriends);
      }
      
      private function loadedFriends(param1:Array) : void
      {
         var _loc2_:* = 0;
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         if(param1.length >= 3)
         {
            Logger.debug("UIInvitePopup showing friends");
            mPopup.nametag_1.visible = true;
            mPopup.nametag_2.visible = true;
            mPopup.nametag_3.visible = true;
            _loc2_ = Math.floor(Math.random() * param1.length);
            _loc4_ = Math.floor(Math.random() * param1.length);
            while(_loc4_ == _loc2_)
            {
               _loc4_ = Math.floor(Math.random() * param1.length);
            }
            _loc3_ = Math.floor(Math.random() * param1.length);
            while(_loc3_ == _loc4_ || _loc3_ == _loc2_)
            {
               _loc3_ = Math.floor(Math.random() * param1.length);
            }
            mPopup.nametag_1.name_label.text = param1[_loc2_].name;
            mPopup.nametag_2.name_label.text = param1[_loc4_].name;
            mPopup.nametag_3.name_label.text = param1[_loc3_].name;
            Sprite(mPopup.nametag_1.pic_bg).addChild(mDBFacade.facebookAccountInfo.loadFriendProfilePic(param1[_loc2_].id));
            Sprite(mPopup.nametag_2.pic_bg).addChild(mDBFacade.facebookAccountInfo.loadFriendProfilePic(param1[_loc4_].id));
            Sprite(mPopup.nametag_3.pic_bg).addChild(mDBFacade.facebookAccountInfo.loadFriendProfilePic(param1[_loc3_].id));
         }
         else
         {
            Logger.debug("UIInvitePopup: not enough friends to show");
         }
      }
   }
}

