package Brain.SceneGraph
{
   import Brain.Component.Component;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import org.as3commons.collections.Set;
   import org.as3commons.collections.framework.ISetIterator;
   
   public class SceneGraphComponent extends Component
   {
      
      private static var mFadeSprite:Sprite;
      
      private static var mFadeTween:TweenMax;
      
      protected var mDisplayObjects:Set;
      
      private var mCurtainActive:Boolean = false;
      
      public function SceneGraphComponent(param1:Facade)
      {
         super(param1);
         mDisplayObjects = new Set();
      }
      
      public static function bringToFront(param1:DisplayObject) : void
      {
         if(param1.parent)
         {
            param1.parent.addChildAt(param1,param1.parent.numChildren);
         }
      }
      
      public static function sendToBack(param1:DisplayObject) : void
      {
         if(param1.parent)
         {
            param1.parent.addChildAt(param1,0);
         }
      }
      
      public static function buildFadeSprite(param1:Facade) : void
      {
         mFadeSprite = new Sprite();
         mFadeSprite.graphics.beginFill(0,1);
         mFadeSprite.graphics.drawRect(0,0,param1.viewWidth,param1.viewHeight);
         mFadeSprite.graphics.endFill();
         mFadeSprite.mouseEnabled = true;
         mFadeSprite.mouseChildren = false;
      }
      
      public function addChild(param1:DisplayObject, param2:uint) : DisplayObject
      {
         if(!mDisplayObjects.has(param1))
         {
            mDisplayObjects.add(param1);
         }
         return mFacade.sceneGraphManager.addChild(param1,param2);
      }
      
      public function addChildAt(param1:DisplayObject, param2:uint, param3:uint) : DisplayObject
      {
         if(!mDisplayObjects.has(param1))
         {
            mDisplayObjects.add(param1);
         }
         return mFacade.sceneGraphManager.addChildAt(param1,param2,param3);
      }
      
      public function showPopupCurtain() : void
      {
         if(!mCurtainActive)
         {
            mFacade.sceneGraphManager.showPopupCurtain();
            mCurtainActive = true;
         }
      }
      
      public function removePopupCurtain() : void
      {
         if(mCurtainActive)
         {
            mFacade.sceneGraphManager.removePopupCurtain();
            mCurtainActive = false;
         }
      }
      
      public function removeChild(param1:DisplayObject) : DisplayObject
      {
         if(param1 == null)
         {
            Logger.warn("SceneGraphComponent:removeChild child is null");
            return null;
         }
         mDisplayObjects.remove(param1);
         return mFacade.sceneGraphManager.removeChild(param1);
      }
      
      public function contains(param1:DisplayObject, param2:uint) : Boolean
      {
         return mDisplayObjects.has(param1);
      }
      
      private function killFadeTween() : void
      {
         if(mFadeTween != null)
         {
            mFadeTween.kill();
            mFadeTween = null;
         }
      }
      
      public function fadeIn(param1:Number) : void
      {
         if(mFadeSprite == null)
         {
            buildFadeSprite(mFacade);
         }
         killFadeTween();
         if(param1 == 0)
         {
            this.removeChild(mFadeSprite);
            return;
         }
         this.addChild(mFadeSprite,100);
         mFadeTween = TweenMax.to(mFadeSprite,param1,{
            "alpha":0,
            "onComplete":finishFadeIn
         });
      }
      
      private function finishFadeIn() : void
      {
         this.removeChild(mFadeSprite);
      }
      
      private function finishFadeOut() : void
      {
      }
      
      public function fadeOut(param1:Number, param2:Number = 1) : void
      {
         if(mFadeSprite == null)
         {
            buildFadeSprite(mFacade);
         }
         killFadeTween();
         this.addChild(mFadeSprite,100);
         if(param1 == 0)
         {
            mFadeSprite.alpha = 1;
            return;
         }
         mFadeTween = TweenMax.to(mFadeSprite,param1,{
            "alpha":param2,
            "onComplete":finishFadeOut
         });
      }
      
      public function saturateLayers(param1:Number, param2:Array) : void
      {
         mFacade.sceneGraphManager.saturateLayers(param1,param2);
      }
      
      public function cleanBackgroundLayer() : void
      {
         mFacade.sceneGraphManager.cleanBackgroundLayer();
      }
      
      override public function destroy() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:ISetIterator = mDisplayObjects.iterator() as ISetIterator;
         while(_loc2_.hasNext())
         {
            _loc1_ = _loc2_.next() as DisplayObject;
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
         mDisplayObjects.clear();
         mDisplayObjects = null;
         removePopupCurtain();
         super.destroy();
      }
   }
}

