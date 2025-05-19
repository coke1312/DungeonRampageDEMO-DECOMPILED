package Brain.GameObject
{
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import org.as3commons.collections.Map;
   
   public class GameObjectManager
   {
      
      private var mGameObjects:Map = new Map();
      
      protected var mFacade:Facade;
      
      public function GameObjectManager(param1:Facade)
      {
         super();
         mFacade = param1;
      }
      
      public function isIdActive(param1:uint) : Boolean
      {
         return mGameObjects.hasKey(param1);
      }
      
      public function removeIdReference(param1:UniqueID) : void
      {
         if(mGameObjects.hasKey(param1.id))
         {
            mGameObjects.removeKey(param1.id);
         }
         else
         {
            Logger.error("GameObjectManager:removeIdReference Removing id not existing " + param1);
         }
      }
      
      public function addIdReference(param1:uint, param2:GameObject) : void
      {
         if(mGameObjects.hasKey(param1))
         {
            Logger.error("GameObjectManager:addIdReference Adding Id That Already Exists " + param1);
         }
         mGameObjects.add(param1,param2);
      }
      
      public function getReferenceFromId(param1:uint) : GameObject
      {
         return mGameObjects.itemFor(param1);
      }
   }
}

