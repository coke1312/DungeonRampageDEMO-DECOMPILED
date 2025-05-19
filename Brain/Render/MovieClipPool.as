package Brain.Render
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.Facade.Facade;
   import Brain.Utils.IPoolable;
   import Brain.Utils.ObjectPool;
   
   public class MovieClipPool extends ObjectPool
   {
      
      public function MovieClipPool()
      {
         super();
      }
      
      override protected function getPoolKey(param1:Array) : String
      {
         var _loc3_:Facade = param1[0];
         var _loc2_:String = SwfAsset(param1[1]).swfPath;
         var _loc4_:String = param1[2];
         return _loc2_ + ":" + _loc4_;
      }
      
      override protected function construct(param1:Array) : IPoolable
      {
         var _loc3_:Facade = param1[0];
         var _loc4_:SwfAsset = param1[1];
         var _loc2_:String = _loc4_.swfPath;
         var _loc5_:String = param1[2];
         var _loc6_:Class = _loc4_.getClass(_loc5_);
         var _loc7_:MovieClipRenderController = new MovieClipRenderController(_loc3_,new _loc6_());
         _loc7_.swfPath = _loc2_;
         _loc7_.className = _loc5_;
         return _loc7_;
      }
   }
}

