package Collision
{
   import Box2D.Collision.Shapes.b2Shape;
   import DistributedObjects.Floor;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   
   public class HeroReviveSensor extends HeroOwnerSensor
   {
      
      protected var mCallback:Function;
      
      protected var mFinishedCallback:Function;
      
      public function HeroReviveSensor(param1:DBFacade, param2:Floor, param3:b2Shape, param4:uint)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function destroy() : void
      {
         mCallback = null;
         mFinishedCallback = null;
         super.destroy();
      }
      
      override public function enterContact(param1:uint) : void
      {
         var _loc2_:HeroGameObjectOwner = mDBFacade.gameObjectManager.getReferenceFromId(param1) as HeroGameObjectOwner;
         if(_loc2_ && _loc2_.heroStateMachine && _loc2_.heroStateMachine.currentStateName != "ActorReviveState")
         {
            mCallback(_loc2_);
         }
      }
      
      override public function exitContact(param1:uint) : void
      {
         var _loc2_:HeroGameObjectOwner = null;
         if(mDBFacade != null)
         {
            _loc2_ = mDBFacade.gameObjectManager.getReferenceFromId(param1) as HeroGameObjectOwner;
            if(_loc2_ != null)
            {
               if(mFinishedCallback != null)
               {
                  mFinishedCallback();
               }
            }
         }
      }
      
      public function set callback(param1:Function) : void
      {
         mCallback = param1;
      }
      
      public function set finishedCallback(param1:Function) : void
      {
         mFinishedCallback = param1;
      }
   }
}

