package StateMachine.MainStateMachine
{
   import Brain.Event.EventComponent;
   import Brain.StateMachine.State;
   import Events.DBAccountLoadedEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import UI.DBUIPopup;
   
   public class ReloadTownState extends State
   {
      
      public static const NAME:String = "ReloadTownState";
      
      protected var mDBFacade:DBFacade;
      
      protected var mPopup:DBUIPopup;
      
      protected var mEventComponent:EventComponent;
      
      public function ReloadTownState(param1:DBFacade, param2:Function = null)
      {
         super("ReloadTownState",param2);
         mDBFacade = param1;
      }
      
      override public function enterState() : void
      {
         super.enterState();
         mPopup = new DBUIPopup(mDBFacade,Locale.getString("RELOAD_TOWN_POPUP_TITLE"),null,false);
         mEventComponent = new EventComponent(mDBFacade);
         mEventComponent.addListener("DB_ACCOUNT_INFO_LOADED",accountLoaded);
         mDBFacade.dbAccountInfo.getUsersFullAccountInfo();
         mDBFacade.dbAccountInfo.checkFriendsHash();
      }
      
      override public function exitState() : void
      {
         mPopup.destroy();
         mPopup = null;
         mEventComponent.destroy();
         mEventComponent = null;
         super.exitState();
      }
      
      protected function accountLoaded(param1:DBAccountLoadedEvent) : void
      {
         if(mFinishedCallback != null)
         {
            mFinishedCallback();
         }
      }
   }
}

