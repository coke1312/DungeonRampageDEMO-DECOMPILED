package Brain.WorkLoop
{
   import Brain.Facade.Facade;
   
   public class PreRenderWorkComponent extends WorkComponent
   {
      
      public function PreRenderWorkComponent(param1:Facade)
      {
         super(param1,param1.preRenderWorkManager);
      }
   }
}

