package Town
{
   import Facade.DBFacade;
   
   public class SkillsTownSubState extends TownSubState
   {
      
      public static const NAME:String = "SkillsTownSubState";
      
      public function SkillsTownSubState(param1:DBFacade, param2:TownStateMachine)
      {
         super(param1,param2,"SkillsTownSubState");
      }
      
      override protected function setupState() : void
      {
         super.setupState();
      }
      
      override public function enterState() : void
      {
         super.enterState();
         mTownStateMachine.townHeader.showCloseButton(true);
      }
   }
}

