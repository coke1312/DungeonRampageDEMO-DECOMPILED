package StateMachine.MainStateMachine
{
   import Brain.StateMachine.State;
   import Facade.DBFacade;
   import Facade.Locale;
   import UI.DBUIOneButtonPopup;
   import flash.desktop.NativeApplication;
   
   public class SocketErrorState extends State
   {
      
      public static const NAME:String = "SocketErrorState";
      
      private var mDBFacade:DBFacade;
      
      public function SocketErrorState(param1:DBFacade, param2:Function = null)
      {
         mDBFacade = param1;
         super("SocketErrorState",param2);
      }
      
      override public function enterState() : void
      {
         super.enterState();
      }
      
      override public function exitState() : void
      {
         super.exitState();
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      private function errorDialogResponce() : void
      {
         NativeApplication.nativeApplication.exit();
      }
      
      public function enterReason(param1:uint, param2:String = "") : DBUIOneButtonPopup
      {
         var _loc3_:DBUIOneButtonPopup = null;
         if(param1 == 60)
         {
            _loc3_ = new DBUIOneButtonPopup(mDBFacade,Locale.getString("SOCKET_CLOSE_60_HEADER"),Locale.getString("SOCKET_CLOSE_60_TEXT"),Locale.getString("EXIT"),errorDialogResponce,false);
         }
         else
         {
            _loc3_ = new DBUIOneButtonPopup(mDBFacade,Locale.getString("SOCKET_UNEXPECT_CLOSE"),Locale.getError(param1) + "\n" + param2,Locale.getString("CENTER_BUTTON_POPUP_RELOAD_TEXT"),errorDialogResponce,false);
         }
         mDBFacade.enteringSocketError();
         return _loc3_;
      }
   }
}

