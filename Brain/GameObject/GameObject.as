package Brain.GameObject
{
   import Brain.Facade.Facade;
   
   public class GameObject
   {
      
      protected var mFacade:Facade;
      
      protected var mId:UniqueID;
      
      protected var mIsInitialized:Boolean = false;
      
      protected var mIsDestroyed:Boolean = false;
      
      public function GameObject(param1:Facade, param2:uint = 0)
      {
         super();
         if(param2 == 0)
         {
            mId = new LocalUniqueID(param1,this);
         }
         else
         {
            mId = new UniqueID(param1,param2,this);
         }
         mFacade = param1;
      }
      
      public function get isInitialized() : Boolean
      {
         return mIsInitialized;
      }
      
      public function get isDestroyed() : Boolean
      {
         return mIsDestroyed;
      }
      
      public function init() : void
      {
         mIsInitialized = true;
      }
      
      public function getTrueObject() : GameObject
      {
         return this;
      }
      
      public function destroy() : void
      {
         if(!mIsDestroyed)
         {
            mId.destroy(mFacade);
            mId = null;
            mFacade = null;
            mIsDestroyed = true;
         }
      }
      
      public function get id() : uint
      {
         return mId.id;
      }
      
      public function newNetworkChild(param1:GameObject) : void
      {
      }
      
      public function InterestClosure() : void
      {
      }
   }
}

