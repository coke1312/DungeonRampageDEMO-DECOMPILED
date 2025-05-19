package Town
{
   import Brain.Event.EventComponent;
   import Brain.UI.UIButton;
   import Events.DBAccountResponseEvent;
   import Facade.DBFacade;
   import UI.UITavern;
   
   public class TavernTownSubState extends TownSubState
   {
      
      private static const NAME:String = "TavernTownSubState";
      
      private var mBackButton:UIButton;
      
      private var mTavernUI:UITavern;
      
      private var mEventComponent:EventComponent;
      
      public function TavernTownSubState(param1:DBFacade, param2:TownStateMachine)
      {
         super(param1,param2,"TavernTownSubState");
         mEventComponent = new EventComponent(mDBFacade);
      }
      
      override public function destroy() : void
      {
         if(mTavernUI)
         {
            mTavernUI.destroy();
            mTavernUI = null;
         }
         mEventComponent.destroy();
         super.destroy();
      }
      
      override protected function setupState() : void
      {
         super.setupState();
         mTavernUI = new UITavern(mDBFacade,mRootMovieClip,mTownStateMachine.townHeader);
      }
      
      override public function enterState() : void
      {
         super.enterState();
         mEventComponent.addListener("DB_ACCOUNT_INFO_RESPONSE",function(param1:DBAccountResponseEvent):void
         {
            mTavernUI.refresh();
         });
         mTavernUI.refresh();
         mTownStateMachine.townHeader.showCloseButton(true);
         mTavernUI.animateEntry();
      }
      
      override public function exitState() : void
      {
         mTavernUI.processChosenAvatar();
         mEventComponent.removeListener("DB_ACCOUNT_INFO_RESPONSE");
         super.exitState();
      }
   }
}

