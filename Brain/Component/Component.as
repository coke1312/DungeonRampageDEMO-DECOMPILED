package Brain.Component
{
   import Brain.Facade.Facade;
   
   public class Component
   {
      
      protected var mFacade:Facade;
      
      public function Component(param1:Facade)
      {
         super();
         mFacade = param1;
      }
      
      public function destroy() : void
      {
         mFacade = null;
      }
   }
}

