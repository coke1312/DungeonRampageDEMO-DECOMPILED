package Brain.GameObject
{
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.Render.MovieClipRenderController;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Vector3D;
   import flash.utils.getQualifiedClassName;
   
   public class View
   {
      
      protected var mFacade:Facade;
      
      protected var mRoot:Sprite;
      
      protected var mSceneGraphComponent:SceneGraphComponent;
      
      protected var mMovieClipRenderer:MovieClipRenderController;
      
      private var mWorkComponent:LogicalWorkComponent;
      
      private var mFadeResetTask:Task;
      
      private var mFading:Boolean;
      
      public function View(param1:Facade)
      {
         super();
         mFacade = param1;
         mSceneGraphComponent = new SceneGraphComponent(mFacade);
         mWorkComponent = new LogicalWorkComponent(mFacade);
         mRoot = new Sprite();
         mFading = false;
      }
      
      private static function recursiveFindChildrenOfClass(param1:Array, param2:DisplayObject, param3:Array) : void
      {
         var _loc5_:int = 0;
         var _loc6_:String = getQualifiedClassName(param2);
         if(param3.indexOf(_loc6_) != -1)
         {
            param1.push(param2);
         }
         var _loc4_:DisplayObjectContainer = param2 as DisplayObjectContainer;
         if(_loc4_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.numChildren)
            {
               recursiveFindChildrenOfClass(param1,_loc4_.getChildAt(_loc5_),param3);
               _loc5_++;
            }
         }
      }
      
      public static function findChildrenOfClass(param1:DisplayObjectContainer, param2:Array) : Array
      {
         var _loc3_:Array = [];
         recursiveFindChildrenOfClass(_loc3_,param1,param2);
         return _loc3_;
      }
      
      public function init() : void
      {
      }
      
      public function unFade() : void
      {
         mRoot.alpha = 1;
         mFadeResetTask.destroy();
         mFadeResetTask = null;
         mFading = false;
      }
      
      public function updateFade(param1:GameClock) : void
      {
         var _loc2_:Number = NaN;
         if(mFading)
         {
            mRoot.alpha *= 0.85;
            if(mRoot.alpha <= 0.3)
            {
               mFading = false;
               mRoot.alpha = 0.3;
            }
         }
         else
         {
            _loc2_ = 1 - mRoot.alpha;
            mRoot.alpha = 1 - _loc2_ * _loc2_;
            if(mRoot.alpha > 0.975)
            {
               unFade();
            }
         }
      }
      
      public function doFade() : void
      {
         mFading = true;
         if(!mFadeResetTask)
         {
            mFadeResetTask = mWorkComponent.doEveryFrame(updateFade);
         }
      }
      
      public function get movieClipRenderer() : MovieClipRenderController
      {
         return mMovieClipRenderer;
      }
      
      public function get position() : Vector3D
      {
         return new Vector3D(mRoot.x,mRoot.y);
      }
      
      public function set position(param1:Vector3D) : void
      {
         mRoot.x = param1.x;
         mRoot.y = param1.y;
      }
      
      public function get rotation() : Number
      {
         return mRoot.rotation;
      }
      
      public function set rotation(param1:Number) : void
      {
         mRoot.rotation = param1;
      }
      
      public function get rotationX() : Number
      {
         return mRoot.rotationX;
      }
      
      public function set rotationX(param1:Number) : void
      {
         mRoot.rotationX = param1;
      }
      
      public function get rotationY() : Number
      {
         return mRoot.rotationY;
      }
      
      public function set rotationY(param1:Number) : void
      {
         mRoot.rotationY = param1;
      }
      
      public function get rotationZ() : Number
      {
         return mRoot.rotationZ;
      }
      
      public function set rotationZ(param1:Number) : void
      {
         mRoot.rotationZ = param1;
      }
      
      public function get root() : Sprite
      {
         return mRoot;
      }
      
      public function destroy() : void
      {
         if(mSceneGraphComponent)
         {
            mSceneGraphComponent.destroy();
            mSceneGraphComponent = null;
         }
         if(mFadeResetTask)
         {
            mFadeResetTask.destroy();
            mFadeResetTask = null;
         }
         if(mWorkComponent)
         {
            mWorkComponent.destroy();
            mWorkComponent = null;
         }
         if(mRoot.parent)
         {
            mRoot.parent.removeChild(mRoot);
         }
         if(mMovieClipRenderer)
         {
            mMovieClipRenderer.destroy();
            mMovieClipRenderer = null;
         }
         mRoot = null;
         mFacade = null;
      }
   }
}

