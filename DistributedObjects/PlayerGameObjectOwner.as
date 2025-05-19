package DistributedObjects
{
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Events.ChatEvent;
   import Events.GameObjectEvent;
   import Facade.DBFacade;
   import GeneratedCode.IPlayerGameObjectOwner;
   import GeneratedCode.PlayerGameObjectOwnerNetworkComponent;
   import flash.events.Event;
   
   public class PlayerGameObjectOwner extends PlayerGameObject implements IPlayerGameObjectOwner
   {
      
      public static const REQUEST_ENTRY_PLAYER_FLOOR:String = "REQUEST_ENTRY_PLAYER_FLOOR";
      
      public static const REQUEST_ENTRY_PLAYER_HERO:String = "REQUEST_ENTRY_PLAYER_HERO";
      
      protected var mEventComponent:EventComponent;
      
      protected var mBasicCurrency:uint;
      
      protected var mPlayerGameObjectOwnerNetworkComponent:PlayerGameObjectOwnerNetworkComponent;
      
      public function PlayerGameObjectOwner(param1:DBFacade, param2:uint = 0)
      {
         Logger.debug("New  PlayerGameObjectOwner******************************");
         super(param1,param2);
         mBasicCurrency = 0;
         mEventComponent = new EventComponent(param1);
         mEventComponent.addListener("REQUEST_ENTRY_PLAYER_FLOOR",event_request_entry);
         mEventComponent.addListener("REQUEST_ENTRY_PLAYER_HERO",event_request_entry_hero);
         mEventComponent.addListener(GameObjectEvent.uniqueEvent("ChatEvent_OUTGOING_CHAT_UPDATE",0),this.handleOutgoingChat);
      }
      
      private function event_request_entry_hero(param1:Event) : void
      {
         Logger.debug(" Sending Request Hero");
         mPlayerGameObjectOwnerNetworkComponent.send_requesthero();
      }
      
      private function event_request_entry(param1:Event) : void
      {
         Logger.debug(" Sending Request Entry Floor");
         mPlayerGameObjectOwnerNetworkComponent.send_requestentry();
      }
      
      public function setOwnerNetworkComponentPlayerGameObject(param1:PlayerGameObjectOwnerNetworkComponent) : void
      {
         mPlayerGameObjectOwnerNetworkComponent = param1;
      }
      
      private function handleOutgoingChat(param1:ChatEvent) : void
      {
         var _loc2_:String = this.screenName + ": " + param1.message;
         this.sendChat(_loc2_);
      }
      
      public function sendChat(param1:String) : void
      {
         this.Chat(param1);
         mPlayerGameObjectOwnerNetworkComponent.send_Chat(param1);
      }
      
      public function sendPlayerIsTyping(param1:Boolean) : void
      {
         if(param1)
         {
            this.ShowPlayerIsTyping(1);
            mPlayerGameObjectOwnerNetworkComponent.send_ShowPlayerIsTyping(1);
         }
         else
         {
            this.ShowPlayerIsTyping(0);
            mPlayerGameObjectOwnerNetworkComponent.send_ShowPlayerIsTyping(0);
         }
      }
      
      override public function get basicCurrency() : uint
      {
         return mBasicCurrency;
      }
      
      public function set basicCurrency(param1:uint) : void
      {
         mBasicCurrency = param1;
         if(mDBFacade.hud)
         {
            mDBFacade.hud.setBasicCurrency(mBasicCurrency);
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         mEventComponent.destroy();
         mEventComponent = null;
      }
   }
}

