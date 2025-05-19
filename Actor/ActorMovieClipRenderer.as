package Actor
{
   import Brain.Render.IRenderer;
   import Brain.Render.MovieClipRenderController;
   import Facade.DBFacade;
   import Floor.FloorView;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class ActorMovieClipRenderer extends MovieClipRenderController implements IRenderer
   {
      
      public static var MOVIE_CLIP_RENDERER_TYPE:String = "MovieClipRenderer";
      
      protected var mDBFacade:DBFacade;
      
      protected var mHeading:Number;
      
      public function ActorMovieClipRenderer(param1:DBFacade, param2:MovieClip)
      {
         super(param1,param2);
         mDBFacade = param1;
         for each(var _loc3_ in FloorView.findNavCollisions(param2))
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         for each(var _loc4_ in FloorView.findCombatCollisions(param2))
         {
            _loc4_.parent.removeChild(_loc4_);
         }
      }
      
      public function get displayObject() : DisplayObject
      {
         return mClip;
      }
      
      public function get rendererType() : String
      {
         return MOVIE_CLIP_RENDERER_TYPE;
      }
      
      public function set heading(param1:Number) : void
      {
         mHeading = param1;
      }
      
      override public function destroy() : void
      {
         mDBFacade = null;
         super.destroy();
      }
   }
}

