package UI
{
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMHints;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class UIHints
   {
      
      private var mDBFacade:DBFacade;
      
      private var mHintBox:MovieClip;
      
      private var mHintTitle:TextField;
      
      private var mHintText:TextField;
      
      public function UIHints(param1:DBFacade, param2:MovieClip)
      {
         super();
         mDBFacade = param1;
         mHintBox = param2;
         mHintText = param2.hint_text;
         mHintTitle = param2.hint_title;
         mHintTitle.text = Locale.getString("HINT_TITLE");
         getNewHint();
      }
      
      private function getNewHint() : void
      {
         var _loc2_:Vector.<GMHints> = new Vector.<GMHints>();
         var _loc5_:uint = mDBFacade.dbAccountInfo.activeAvatarInfo.level;
         for each(var _loc4_ in mDBFacade.gameMaster.Hints)
         {
            if(_loc4_.MinLevel <= _loc5_ && _loc4_.MaxLevel >= _loc5_)
            {
               _loc2_.push(_loc4_);
            }
         }
         if(_loc2_.length == 0)
         {
            return;
         }
         var _loc1_:uint = Math.floor(Math.random() * _loc2_.length);
         var _loc3_:GMHints = _loc2_[_loc1_];
         if(!_loc3_)
         {
            return;
         }
         mHintText.text = _loc3_.HintText;
      }
      
      public function destroy() : void
      {
         mDBFacade = null;
         mHintBox = null;
         mHintTitle = null;
         mHintText = null;
      }
   }
}

