package Town
{
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.jsonRPC.JSONRPCService;
   import Facade.DBFacade;
   import Facade.Locale;
   import UI.FriendManager.UIFriendManager;
   
   public class SocialSubState extends TownSubState
   {
      
      public static const NAME:String = "FriendTownSubState";
      
      private var mEventComponent:EventComponent;
      
      private var mUIFriendManager:UIFriendManager;
      
      private var mTabCategory:uint;
      
      private var mPendingFriendRequest:Boolean = false;
      
      public function SocialSubState(param1:DBFacade, param2:TownStateMachine)
      {
         super(param1,param2,"FriendTownSubState");
         mEventComponent = new EventComponent(mDBFacade);
      }
      
      override public function enterState() : void
      {
         super.enterState();
         mPendingFriendRequest = false;
         if(mUIFriendManager)
         {
            mUIFriendManager.init(mTabCategory);
            mUIFriendManager.animateEntry();
         }
         mTownStateMachine.townHeader.title = Locale.getString("FM_HEADER");
         mTownStateMachine.townHeader.showCloseButton(true);
      }
      
      public function setTabCategory(param1:uint) : void
      {
         mTabCategory = param1;
      }
      
      override public function exitState() : void
      {
         super.exitState();
         if(mUIFriendManager)
         {
            mUIFriendManager.cleanUp();
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(mEventComponent)
         {
            mEventComponent.destroy();
         }
         mEventComponent = null;
         if(mUIFriendManager)
         {
            mUIFriendManager.destroy();
            mUIFriendManager = null;
         }
      }
      
      override protected function setupState() : void
      {
         super.setupState();
         mUIFriendManager = new UIFriendManager(mDBFacade,mTownStateMachine,mRootMovieClip);
         setTabCategory(1);
         checkForFriendMessages();
      }
      
      private function checkForFriendMessages() : void
      {
         var rpcFunc:Function = JSONRPCService.getFunction("DRFriendRequestPending",mDBFacade.rpcRoot + "friendrequests");
         var rpcSuccessCallback:Function = function(param1:*):void
         {
            var pendingRequests:* = param1;
            if(pendingRequests)
            {
               mPendingFriendRequest = true;
               mUIFriendManager.setPendingList(pendingRequests as Array);
               setTabCategory(2);
               if(mTownStateMachine.leaderboard && mTownStateMachine.leaderboard.initialized)
               {
                  mTownStateMachine.leaderboard.alert = mPendingFriendRequest;
               }
               else
               {
                  Logger.debug("leaderboard not set or not initialized yet: use an event listener");
                  if(mEventComponent)
                  {
                     mEventComponent.addListener("LEADERBOARD_INITIALIZED_EVENT",(function():*
                     {
                        var setPending:Function;
                        return setPending = function():void
                        {
                           mTownStateMachine.leaderboard.alert = mPendingFriendRequest;
                        };
                     })());
                  }
               }
            }
         };
         rpcFunc(mDBFacade.dbAccountInfo.id,mDBFacade.validationToken,rpcSuccessCallback);
      }
   }
}

