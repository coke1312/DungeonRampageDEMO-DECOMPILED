package Dungeon
{
   import Brain.Render.MovieClipRenderController;
   import Facade.DBFacade;
   import Floor.FloorView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class PropView extends FloorView
   {
      
      private var mBody:MovieClip;
      
      public function PropView(param1:DBFacade, param2:Prop)
      {
         super(param1,param2);
         mRoot.name = "PropView_" + param2.id;
         mRoot.mouseEnabled = false;
         mRoot.mouseChildren = false;
      }
      
      public function set body(param1:MovieClip) : void
      {
         mBody = param1;
         mRoot.addChild(mBody);
         for each(var _loc2_ in FloorView.findNavCollisions(mBody))
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         for each(var _loc3_ in FloorView.findCombatCollisions(mBody))
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         mMovieClipRenderer = new MovieClipRenderController(mFacade,mBody);
         mMovieClipRenderer.play(0,true);
      }
      
      override public function destroy() : void
      {
         mBody = null;
         super.destroy();
      }
   }
}

