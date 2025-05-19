package Brain.Render
{
   import flash.display.DisplayObject;
   
   public interface IRenderer
   {
      
      function get rendererType() : String;
      
      function play(param1:uint = 0, param2:Boolean = true, param3:Function = null) : void;
      
      function stop() : void;
      
      function get currentFrame() : uint;
      
      function get loop() : Boolean;
      
      function setFrame(param1:uint) : void;
      
      function get displayObject() : DisplayObject;
      
      function set heading(param1:Number) : void;
      
      function destroy() : void;
      
      function get durationInSeconds() : Number;
      
      function get frameCount() : Number;
      
      function get playRate() : Number;
      
      function set playRate(param1:Number) : void;
      
      function get isPlaying() : Boolean;
   }
}

