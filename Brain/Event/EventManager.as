package Brain.Event
{
   import Brain.Facade.Facade;
   import flash.display.Sprite;
   
   public class EventManager extends Sprite
   {
      
      public function EventManager(param1:Facade)
      {
         super();
         param1.addRootDisplayObject(this);
      }
   }
}

