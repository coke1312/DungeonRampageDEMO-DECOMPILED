package Brain.WorkLoop
{
   import Brain.Facade.Facade;
   
   public class LogicalWorkComponent extends WorkComponent
   {
      
      public function LogicalWorkComponent(param1:Facade)
      {
         super(param1,param1.logicalWorkManager);
      }
   }
}

