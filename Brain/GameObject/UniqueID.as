package Brain.GameObject
{
   import Brain.Facade.Facade;
   
   public class UniqueID
   {
      
      private var mId:uint = 0;
      
      public function UniqueID(param1:Facade, param2:uint, param3:GameObject)
      {
         super();
         mId = param2;
         param1.gameObjectManager.addIdReference(param2,param3);
      }
      
      public function get id() : uint
      {
         return mId;
      }
      
      public function destroy(param1:Facade) : void
      {
         param1.gameObjectManager.removeIdReference(this);
         mId = 0;
      }
   }
}

