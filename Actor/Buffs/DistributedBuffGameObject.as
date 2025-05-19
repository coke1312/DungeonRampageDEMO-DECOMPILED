package Actor.Buffs
{
   import Actor.ActorGameObject;
   import Brain.Facade.Facade;
   import Brain.GameObject.GameObject;
   import GeneratedCode.DistributedBuffGameObjectNetworkComponent;
   import GeneratedCode.IDistributedBuffGameObject;
   
   public class DistributedBuffGameObject extends GameObject implements IDistributedBuffGameObject
   {
      
      private var mType:uint;
      
      private var mEffectedActor:uint;
      
      public var buffHandler:BuffHandler;
      
      public function DistributedBuffGameObject(param1:Facade, param2:uint = 0)
      {
         super(param1,param2);
      }
      
      public function setNetworkComponentDistributedBuffGameObject(param1:DistributedBuffGameObjectNetworkComponent) : void
      {
      }
      
      public function postGenerate() : void
      {
         var _loc2_:GameObject = mFacade.gameObjectManager.getReferenceFromId(mEffectedActor);
         var _loc1_:ActorGameObject = _loc2_ as ActorGameObject;
         if(_loc1_)
         {
            _loc1_.buffHandler.addBuff(this);
            _loc1_.ponderBuffChanges();
         }
      }
      
      override public function destroy() : void
      {
         if(buffHandler)
         {
            buffHandler.removeBuff(this);
            super.destroy();
         }
      }
      
      public function get type() : uint
      {
         return this.mType;
      }
      
      public function set effectedActor(param1:uint) : void
      {
         mEffectedActor = param1;
      }
      
      public function set type(param1:uint) : void
      {
         mType = param1;
      }
   }
}

