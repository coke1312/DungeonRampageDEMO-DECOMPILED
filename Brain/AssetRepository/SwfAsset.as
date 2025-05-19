package Brain.AssetRepository
{
   import Brain.Logger.Logger;
   import flash.display.MovieClip;
   import org.as3commons.collections.Map;
   
   public class SwfAsset extends Asset
   {
      
      protected var mRootClip:MovieClip;
      
      private var mSwfPath:String;
      
      public function SwfAsset(param1:MovieClip, param2:String)
      {
         mRootClip = param1;
         mSwfPath = param2;
         super();
      }
      
      override public function destroy() : void
      {
         mRootClip.loaderInfo.loader.unloadAndStop();
         mRootClip = null;
      }
      
      public function get swfPath() : String
      {
         return mSwfPath;
      }
      
      public function get root() : MovieClip
      {
         return mRootClip;
      }
      
      public function getClass(param1:String, param2:Boolean = false) : Class
      {
         if(!mRootClip.loaderInfo.applicationDomain.hasDefinition(param1))
         {
            if(!param2)
            {
               Logger.warn("Could not find class name: " + param1 + " in SwfAsset " + mRootClip.loaderInfo.url);
            }
            return null;
         }
         return mRootClip.loaderInfo.applicationDomain.getDefinition(param1) as Class;
      }
      
      public function getClasses(param1:Vector.<String>) : Map
      {
         return parseOutClasses(mRootClip,param1);
      }
      
      private function parseOutClasses(param1:MovieClip, param2:Vector.<String>) : Map
      {
         var _loc3_:Class = null;
         var _loc4_:Map = new Map();
         for each(var _loc5_ in param2)
         {
            _loc3_ = param1.loaderInfo.applicationDomain.getDefinition(_loc5_) as Class;
            _loc4_.add(_loc5_,_loc3_);
         }
         return _loc4_;
      }
   }
}

