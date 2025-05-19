package Town
{
   import Facade.DBFacade;
   import UI.Training.UIHeroTraining;
   
   public class TrainTownSubState extends TownSubState
   {
      
      public static const NAME:String = "TrainTownSubState";
      
      private var mUIHeroTraining:UIHeroTraining;
      
      public function TrainTownSubState(param1:DBFacade, param2:TownStateMachine)
      {
         super(param1,param2,"TrainTownSubState");
      }
      
      override protected function setupState() : void
      {
         super.setupState();
         mUIHeroTraining = new UIHeroTraining(mDBFacade,mTownStateMachine.townSwf,mRootMovieClip,mTownStateMachine.townHeader);
      }
      
      override public function enterState() : void
      {
         super.enterState();
         if(mUIHeroTraining)
         {
            mUIHeroTraining.enableHud();
         }
         mTownStateMachine.townHeader.showCloseButton(true);
         mUIHeroTraining.animateEntry();
      }
      
      override public function destroy() : void
      {
         if(mUIHeroTraining)
         {
            mUIHeroTraining.destroy();
            mUIHeroTraining = null;
         }
         super.destroy();
      }
      
      override public function exitState() : void
      {
         if(mUIHeroTraining)
         {
            mUIHeroTraining.processChosenAvatar();
            mUIHeroTraining.disableHud();
         }
         super.exitState();
      }
   }
}

