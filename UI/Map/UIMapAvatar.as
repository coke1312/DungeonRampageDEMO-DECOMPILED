package UI.Map
{
   import Facade.DBFacade;
   import com.maccherone.json.JSON;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLLoader;
   
   public class UIMapAvatar
   {
      
      private var mAvatar:MovieClip;
      
      private var mAvatarDropShadow:MovieClip;
      
      private var mAvatarMover:UIMapAvatarMover;
      
      private var mDBFacade:DBFacade;
      
      public function UIMapAvatar(param1:DBFacade, param2:MovieClip, param3:MovieClip, param4:Class)
      {
         super();
         mDBFacade = param1;
         mAvatar = param2;
         mAvatarDropShadow = param3;
         mAvatarMover = new param4(updatePosition) as UIMapAvatarMover;
         updatePlayerName();
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         mAvatarMover.moveTo(param1,param2);
      }
      
      public function destroy(param1:MovieClip) : void
      {
         if(mAvatar)
         {
            param1.removeChild(mAvatar);
         }
         if(mAvatarDropShadow)
         {
            param1.removeChild(mAvatarDropShadow);
         }
         if(mAvatarMover)
         {
            mAvatarMover.destroy();
            mAvatarMover = null;
         }
      }
      
      private function updatePosition(param1:Number, param2:Number) : void
      {
         mAvatar.x = param1;
         mAvatar.y = param2;
         mAvatarDropShadow.x = param1;
         mAvatarDropShadow.y = param2;
      }
      
      private function loadedPlayerName(param1:Event) : void
      {
         var _loc3_:URLLoader = URLLoader(param1.target);
         var _loc2_:Object = com.maccherone.json.JSON.decode(_loc3_.data);
         mAvatar.label.text = _loc2_["name"];
      }
      
      private function updatePlayerName() : void
      {
         mAvatar.label.text = mDBFacade.facebookAccountInfo.name ? mDBFacade.facebookAccountInfo.name : mDBFacade.dbAccountInfo.name;
      }
   }
}

