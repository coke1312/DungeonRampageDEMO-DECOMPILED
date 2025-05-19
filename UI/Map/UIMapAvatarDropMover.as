package UI.Map
{
   public class UIMapAvatarDropMover implements UIMapAvatarMover
   {
      
      private var mUpdatePosition:Function;
      
      public function UIMapAvatarDropMover(param1:Function)
      {
         super();
         mUpdatePosition = param1;
      }
      
      public function moveTo(param1:Number, param2:Number) : void
      {
         mUpdatePosition(param1,param2);
      }
      
      public function destroy() : void
      {
      }
   }
}

