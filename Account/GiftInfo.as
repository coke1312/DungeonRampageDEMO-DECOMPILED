package Account
{
   import Facade.DBFacade;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class GiftInfo
   {
      
      private var mFromAccountId:uint;
      
      private var mOfferId:uint;
      
      private var mRequestId:String;
      
      private var mProfilePic:DisplayObject;
      
      private var mDBFacade:DBFacade;
      
      private var mResponseCallback:Function;
      
      public function GiftInfo(param1:DBFacade, param2:Object, param3:Function = null)
      {
         super();
         mDBFacade = param1;
         mResponseCallback = param3;
         parseJson(param2);
      }
      
      private function parseJson(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         mFromAccountId = param1.from_account_id as uint;
         mOfferId = param1.offer_id as uint;
         mRequestId = param1.request_id as String;
         if(mResponseCallback != null)
         {
            mResponseCallback();
         }
      }
      
      private function ignoreIOError(param1:Event) : void
      {
      }
      
      public function get pic() : DisplayObject
      {
         return mProfilePic;
      }
      
      public function set pic(param1:DisplayObject) : void
      {
         mProfilePic = param1;
      }
      
      public function get fromAccountId() : uint
      {
         return mFromAccountId;
      }
      
      public function get requestId() : String
      {
         return mRequestId;
      }
      
      public function get offerId() : uint
      {
         return mOfferId;
      }
   }
}

