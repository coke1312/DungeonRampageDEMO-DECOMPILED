package UI.Training
{
   import Brain.UI.UIProgressBar;
   import Facade.DBFacade;
   import flash.display.MovieClip;
   
   public class UIStatProgressBar
   {
      
      private var mDBFacade:DBFacade;
      
      private var mProgressBar:UIProgressBar;
      
      private var mCompletedClip:MovieClip;
      
      public function UIStatProgressBar(param1:DBFacade, param2:MovieClip, param3:MovieClip)
      {
         super();
         mDBFacade = param1;
         mProgressBar = new UIProgressBar(mDBFacade,param2.training_bar);
         mProgressBar.enabled = false;
         mCompletedClip = param3;
         completed = false;
      }
      
      public function get progressBar() : UIProgressBar
      {
         return mProgressBar;
      }
      
      public function set value(param1:Number) : void
      {
         mProgressBar.value = param1;
      }
      
      public function set completed(param1:Boolean) : void
      {
         mCompletedClip.visible = param1;
      }
      
      public function destroy() : void
      {
         mProgressBar.destroy();
      }
   }
}

