package Effects
{
   import Brain.Utils.IPoolable;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import Floor.FloorView;
   import flash.geom.Vector3D;
   
   public class EffectGameObject extends FloorObject implements IPoolable
   {
      
      protected var mEffectView:EffectView;
      
      public var swfPath:String;
      
      public var className:String;
      
      protected var mAssetLoadedCallback:Function;
      
      public function EffectGameObject(param1:DBFacade, param2:String, param3:String, param4:Number, param5:uint = 0, param6:Function = null)
      {
         this.swfPath = param2;
         this.className = param3;
         mAssetLoadedCallback = param6;
         super(param1,param5);
         this.layer = 20;
         this.init();
         mEffectView.setPlayRate(param4);
      }
      
      public function setAssetLoadedCallback(param1:Function) : void
      {
         mAssetLoadedCallback = param1;
      }
      
      public function postCheckout(param1:Boolean) : void
      {
         if(!param1 && mAssetLoadedCallback != null)
         {
            view.movieClipRenderer.clip.gotoAndStop(0);
            mAssetLoadedCallback(view.movieClipRenderer.clip);
         }
      }
      
      public function postCheckin() : void
      {
         mEffectView.stop();
      }
      
      public function getPoolKey() : String
      {
         return swfPath + ":" + className;
      }
      
      override public function set position(param1:Vector3D) : void
      {
         super.position = param1;
         mEffectView.position = param1;
      }
      
      override protected function buildView() : void
      {
         mEffectView = new EffectView(mDBFacade,this,mAssetLoadedCallback);
         this.view = mEffectView as FloorView;
      }
      
      public function get rotation() : Number
      {
         return mFloorView.rotation;
      }
      
      public function set rotation(param1:Number) : void
      {
         this.view.rotation = param1;
      }
      
      override public function destroy() : void
      {
         mEffectView = null;
         super.destroy();
      }
   }
}

