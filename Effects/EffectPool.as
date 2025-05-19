package Effects
{
   import Brain.Utils.IPoolable;
   import Brain.Utils.ObjectPool;
   import Facade.DBFacade;
   
   public class EffectPool extends ObjectPool
   {
      
      public function EffectPool()
      {
         super();
      }
      
      override protected function getPoolKey(param1:Array) : String
      {
         var _loc3_:DBFacade = param1[0];
         var _loc2_:String = param1[1];
         var _loc4_:String = param1[2];
         return _loc2_ + ":" + _loc4_;
      }
      
      override protected function reset(param1:IPoolable, param2:Array) : void
      {
         var _loc3_:EffectGameObject = param1 as EffectGameObject;
         _loc3_.setAssetLoadedCallback(param2[3]);
      }
      
      override protected function construct(param1:Array) : IPoolable
      {
         var _loc3_:DBFacade = param1[0];
         var _loc2_:String = param1[1];
         var _loc4_:String = param1[2];
         var _loc5_:Function = param1[3];
         return new EffectGameObject(_loc3_,_loc2_,_loc4_,1,0,_loc5_);
      }
   }
}

