package DistributedObjects
{
   import Brain.Event.EventComponent;
   import Brain.GameObject.GameObject;
   import Brain.Logger.Logger;
   import Events.ClientExitCompleteEvent;
   import Events.MatchMakerLoadedEvent;
   import Events.RequestEntryFailedEvent;
   import Facade.DBFacade;
   import GeneratedCode.GameServerPartyMember;
   import GeneratedCode.IMatchMaker;
   import GeneratedCode.InfiniteMapNodeDetail;
   import GeneratedCode.MatchMakerNetworkComponent;
   import flash.events.Event;
   import org.as3commons.collections.Map;
   
   public class MatchMaker extends GameObject implements IMatchMaker
   {
      
      public static var EPOCH_ROLL_OVER_EVENT_NAME:String = "EPOCH_ROLL_OVER_EVENT_NAME";
      
      private var netIface:MatchMakerNetworkComponent;
      
      private var mDBFacade:DBFacade;
      
      private var mEventComponent:EventComponent;
      
      private var mInfiniteMapNodeDetails:Vector.<InfiniteMapNodeDetail>;
      
      private var mInfiniteDungeonDetails:Map;
      
      public function MatchMaker(param1:DBFacade, param2:uint = 0)
      {
         mDBFacade = param1;
         super(param1,param2);
         mEventComponent = new EventComponent(mDBFacade);
      }
      
      public function setNetworkComponentMatchMaker(param1:MatchMakerNetworkComponent) : void
      {
         netIface = param1;
      }
      
      public function InfiniteDetails(param1:Vector.<InfiniteMapNodeDetail>) : void
      {
         mInfiniteMapNodeDetails = param1;
         setInfiniteDungeonDetails();
         mEventComponent.dispatchEvent(new Event(EPOCH_ROLL_OVER_EVENT_NAME));
      }
      
      private function setInfiniteDungeonDetails() : void
      {
         var _loc1_:* = null;
         mInfiniteDungeonDetails = new Map();
         for each(_loc1_ in mInfiniteMapNodeDetails)
         {
            if(_loc1_)
            {
               mInfiniteDungeonDetails.add(_loc1_.nodeId,_loc1_);
            }
         }
      }
      
      public function ClientInformPartyComposition(param1:Vector.<GameServerPartyMember>) : void
      {
         trace("ClientInformPartyComposition");
         for each(var _loc2_ in param1)
         {
            trace("Member Id:" + _loc2_.id + " Status:" + _loc2_.status);
         }
      }
      
      public function postGenerate() : void
      {
         mDBFacade.mDistributedObjectManager.mMatchMaker = this;
         mEventComponent.dispatchEvent(new MatchMakerLoadedEvent(this));
      }
      
      public function RequestExit() : void
      {
         Logger.info("MatchMaker:RequestExit");
         netIface.send_RequestExit(0);
      }
      
      public function RequestEntry(param1:uint, param2:uint, param3:uint, param4:uint, param5:String) : void
      {
         Logger.info("MatchMaker:RequestEntry");
         netIface.send_ClientRequestEntry(mDBFacade.demographicsJson,mDBFacade.sCode,param1,param2,param3,param4,param5);
      }
      
      public function ClientRequestEntryResponce(param1:uint, param2:uint) : void
      {
         Logger.info("MatchMaker:ClientRequestEntryResponce");
         if(param1 != 0)
         {
            mEventComponent.dispatchEvent(new RequestEntryFailedEvent(param1));
         }
      }
      
      public function RequestPartyMemberInvite(param1:uint) : void
      {
         Logger.info("MatchMaker:RequestPartyMemberInvite");
         netIface.send_ClientRequestPartyMemberInvite(mDBFacade.demographicsJson,param1);
      }
      
      override public function destroy() : void
      {
         mDBFacade.mDistributedObjectManager.mMatchMaker = null;
         mInfiniteMapNodeDetails = null;
         mInfiniteDungeonDetails = null;
         if(mEventComponent)
         {
            mEventComponent.destroy();
         }
         super.destroy();
      }
      
      public function ClientExitComplete(param1:uint) : void
      {
         Logger.info("MatchMaker:ClientExitComplete" + param1.toString());
         mEventComponent.dispatchEvent(new ClientExitCompleteEvent());
      }
      
      public function getInfiniteDungeonDetailForNodeId(param1:uint) : InfiniteMapNodeDetail
      {
         return mInfiniteDungeonDetails.itemFor(param1);
      }
   }
}

