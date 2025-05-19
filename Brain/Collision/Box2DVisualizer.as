package Brain.Collision
{
   import Box2D.Dynamics.b2DebugDraw;
   import Box2D.Dynamics.b2World;
   import Brain.Clock.GameClock;
   import flash.display.Sprite;
   
   public class Box2DVisualizer
   {
      
      private var mB2World:b2World;
      
      private var mRootSprite:Sprite;
      
      protected var mDebugDraw:b2DebugDraw;
      
      protected var mWantAllCollisions:Boolean;
      
      protected var mWantNavigationCollisions:Boolean;
      
      protected var mWantCombatCollisions:Boolean;
      
      protected var mWantAStarVisuals:Boolean;
      
      public function Box2DVisualizer(param1:b2World, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false)
      {
         super();
         mB2World = param1;
         mRootSprite = new Sprite();
         mWantAllCollisions = param2;
         mWantNavigationCollisions = param4;
         mWantCombatCollisions = param3;
         mWantAStarVisuals = param5;
         setupDebugDraw();
      }
      
      private function setupDebugDraw() : void
      {
         mRootSprite = new Sprite();
         mDebugDraw = new b2DebugDraw();
         var _loc1_:Sprite = new Sprite();
         mRootSprite.addChild(_loc1_);
         mDebugDraw.SetSprite(mRootSprite);
         mDebugDraw.SetDrawScale(1);
         mDebugDraw.SetAlpha(1);
         mDebugDraw.SetFillAlpha(0.5);
         mDebugDraw.SetLineThickness(1);
         if(mWantAllCollisions || mWantNavigationCollisions)
         {
            mDebugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_controllerBit | b2DebugDraw.e_aabbBit | b2DebugDraw.e_pairBit | b2DebugDraw.e_centerOfMassBit);
         }
         mB2World.SetDebugDraw(mDebugDraw);
         mRootSprite.x = 0;
         mRootSprite.y = 0;
      }
      
      public function get rootSprite() : Sprite
      {
         return mRootSprite;
      }
      
      public function update(param1:GameClock) : void
      {
         mB2World.DrawDebugData();
      }
   }
}

