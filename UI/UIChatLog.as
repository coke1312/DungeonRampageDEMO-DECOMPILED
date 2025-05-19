package UI
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.Event.EventComponent;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.UI.UIButton;
   import Brain.UI.UIInputText;
   import Brain.UI.UISlider;
   import DistributedObjects.HeroGameObjectOwner;
   import Events.ChatEvent;
   import Events.ChatLogEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class UIChatLog
   {
      
      private static var JOINED_DUNGEON_COLOR:uint = 16063002;
      
      private static var LEFT_DUNGEON_COLOR:uint = 16063002;
      
      private static var FRIEND_STATUS_ONLINE_COLOR:uint = 16764232;
      
      private static var FRIEND_STATUS_OFFLINE_COLOR:uint = 16764232;
      
      private static var NAME_CHAT_COLOR:uint = 16764232;
      
      public static var JOINED_DUNGEON_TYPE:String = "JOINED_DUNGEON";
      
      public static var LEFT_DUNGEON_TYPE:String = "LEFT_DUNGEON";
      
      public static var FRIEND_STATUS_ONLINE_TYPE:String = "FRIEND_STATUS_ONLINE";
      
      public static var FRIEND_STATUS_OFFLINE_TYPE:String = "FRIEND_STATUS_OFFLINE";
      
      public static var CHAT_TYPE:String = "CHAT";
      
      private static var MAX_CHATS:uint = 50;
      
      private static const CHAT_FADE_DURATION:Number = 0.3;
      
      private static const MAX_CHAT_CHARS:uint = 169;
      
      private static var mChatLogXOffset:uint = 0;
      
      private static var mChatLogYOffset:uint = 0;
      
      private static var mChats:Vector.<ChatTextFieldHelper>;
      
      private var mDBFacade:DBFacade;
      
      private var mChatLog:TextField;
      
      private var mSlider:UISlider;
      
      private var mEventComponent:EventComponent;
      
      private var mChatLogContainer:MovieClip;
      
      private var mFadeTween:TweenMax;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mAutoShowChatLog:Boolean;
      
      private var mUserToggled:Boolean;
      
      private var mToggledOpen:Boolean = false;
      
      private var mPlayerSetSlider:Boolean = false;
      
      private var mChatLogButton:UIButton;
      
      private var mChatInputText:UIInputText;
      
      private var mChatSendButton:UIButton;
      
      private var mChatLogShowing:Boolean;
      
      private var mHeroOwner:HeroGameObjectOwner;
      
      private var mPreviousHeight:Number = 1;
      
      public function UIChatLog(param1:DBFacade, param2:MovieClip, param3:MovieClip, param4:MovieClip, param5:MovieClip)
      {
         super();
         mDBFacade = param1;
         if(mChats == null)
         {
            mChats = new Vector.<ChatTextFieldHelper>();
         }
         mPlayerSetSlider = false;
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mEventComponent = new EventComponent(mDBFacade);
         setupButtons(param3,param4,param5);
         setupLog(param2);
         mAutoShowChatLog = mDBFacade.dbConfigManager.getConfigBoolean("AUTO_SHOW_CHAT_LOG",true);
         constructAndRenderNewChat();
         enable();
      }
      
      public function set heroOwner(param1:HeroGameObjectOwner) : void
      {
         mHeroOwner = param1;
      }
      
      public function enable() : void
      {
         this.disable();
         mEventComponent.addListener("CHAT_LOG_EVENT",chatEventHandler);
         mChatInputText.root.addEventListener("focusIn",onChatTextFieldFocus);
         mChatInputText.root.addEventListener("focusOut",onChatTextFieldLoseFocus);
         mDBFacade.stageRef.addEventListener("keyDown",checkKeyEvent);
      }
      
      public function disable() : void
      {
         mEventComponent.removeListener("CHAT_LOG_EVENT");
         mChatInputText.root.removeEventListener("focusIn",onChatTextFieldFocus);
         mChatInputText.root.removeEventListener("focusOut",onChatTextFieldLoseFocus);
         mDBFacade.stageRef.removeEventListener("keyDown",checkKeyEvent);
      }
      
      private function onChatTextFieldFocus(param1:FocusEvent) : void
      {
         if(mHeroOwner)
         {
            mHeroOwner.showPlayerIsTyping(true);
         }
         chatTextFieldFocus();
      }
      
      private function onChatTextFieldLoseFocus(param1:FocusEvent) : void
      {
         if(mHeroOwner)
         {
            mHeroOwner.showPlayerIsTyping(false);
         }
         chatTextFieldLostFocus();
      }
      
      private function setupButtons(param1:MovieClip, param2:MovieClip, param3:MovieClip) : void
      {
         var chatTextField:MovieClip = param1;
         var chatLogButton:MovieClip = param2;
         var sendChatButton:MovieClip = param3;
         mChatInputText = new UIInputText(mDBFacade,chatTextField);
         mChatInputText.defaultText = Locale.getString("DEFAULT_CHAT_PROMPT");
         mChatInputText.enterCallback = sendChat;
         mChatInputText.textField.maxChars = 169;
         mChatLogButton = new UIButton(mDBFacade,chatLogButton);
         mChatLogButton.releaseCallback = toggleChatLog;
         mChatSendButton = new UIButton(mDBFacade,sendChatButton);
         mChatSendButton.releaseCallback = function():void
         {
            sendChat(mChatInputText.text);
         };
      }
      
      private function sendChat(param1:String) : void
      {
         mChatInputText.clear();
         mDBFacade.regainFocus();
         mDBFacade.inputManager.clear();
         if(param1)
         {
            mEventComponent.dispatchEvent(new ChatEvent("ChatEvent_OUTGOING_CHAT_UPDATE",0,param1));
         }
      }
      
      public function toggleChatLog() : void
      {
         if(mChatLogShowing)
         {
            mToggledOpen = false;
            hideChatLog();
         }
         else
         {
            mToggledOpen = true;
            showChatLog();
         }
      }
      
      private function chatTextFieldFocus() : void
      {
         if(mAutoShowChatLog)
         {
            showChatLog();
         }
      }
      
      private function chatTextFieldLostFocus() : void
      {
         if(mAutoShowChatLog && !mToggledOpen)
         {
            hideChatLog();
         }
      }
      
      private function checkKeyEvent(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            mDBFacade.stageRef.focus = mChatInputText.textField;
         }
         else if(param1.keyCode == 220 && mDBFacade.mainStateMachine.currentStateName == "RunState")
         {
            toggleChatLog();
         }
      }
      
      private function setupLog(param1:MovieClip) : void
      {
         mChatLogContainer = param1;
         mChatLog = mChatLogContainer.chatLog;
         mSlider = new UISlider(mDBFacade,mChatLogContainer.slider,1);
         mSlider.minimum = 100;
         mSlider.maximum = 0;
         mSlider.tick = 2;
         mSlider.value = 0;
         mSlider.updateCallback = sliderCallback;
         init();
      }
      
      private function sliderCallback(param1:Number) : void
      {
         mPlayerSetSlider = true;
         setChatLogPosition(param1);
      }
      
      private function init() : void
      {
         mChatLogContainer.y += mChatLogYOffset;
         mChatLogContainer.x += mChatLogXOffset;
         mChatLog.text = "";
         mChatLogContainer.visible = false;
         mSlider.visible = false;
      }
      
      private function chatEventHandler(param1:ChatLogEvent) : void
      {
         var _loc2_:uint = 0;
         switch(param1.chatLogType)
         {
            case JOINED_DUNGEON_TYPE:
               _loc2_ = JOINED_DUNGEON_COLOR;
               break;
            case LEFT_DUNGEON_TYPE:
               _loc2_ = LEFT_DUNGEON_COLOR;
               break;
            case FRIEND_STATUS_ONLINE_TYPE:
               _loc2_ = FRIEND_STATUS_ONLINE_COLOR;
               break;
            case FRIEND_STATUS_OFFLINE_TYPE:
               _loc2_ = FRIEND_STATUS_OFFLINE_COLOR;
         }
         addChatLog(param1.chat,_loc2_,param1.playerName);
      }
      
      private function addChatLog(param1:String, param2:uint, param3:String = "") : void
      {
         var _loc8_:ChatTextFieldHelper = null;
         var _loc6_:* = 0;
         if(!mChatLog)
         {
            return;
         }
         var _loc7_:ChatTextFieldHelper = new ChatTextFieldHelper();
         param1 += "\n";
         var _loc5_:uint = uint(mChatLog.length);
         _loc7_.chatText = param1;
         _loc7_.color = param2;
         _loc7_.playerName = param3;
         _loc7_.colorStartIndex = _loc5_;
         _loc7_.colorEndIndex = _loc5_ + param1.length;
         mChats.push(_loc7_);
         if(mChats.length > MAX_CHATS)
         {
            _loc8_ = mChats.shift();
            _loc6_ = uint(_loc8_.colorEndIndex - _loc8_.colorStartIndex);
            for each(var _loc4_ in mChats)
            {
               _loc4_.colorEndIndex -= _loc6_;
               _loc4_.colorStartIndex -= _loc6_;
            }
         }
         constructAndRenderNewChat();
      }
      
      private function constructAndRenderNewChat() : void
      {
         var _loc1_:TextFormat = null;
         var _loc2_:* = 0;
         mChatLog.text = "";
         for each(var _loc3_ in mChats)
         {
            mChatLog.text = mChatLog.text.concat(_loc3_.chatText);
         }
         for each(_loc3_ in mChats)
         {
            _loc2_ = _loc3_.colorStartIndex;
            if(_loc3_.playerName != "")
            {
               _loc1_ = new TextFormat();
               _loc1_.color = NAME_CHAT_COLOR;
               mChatLog.setTextFormat(_loc1_,_loc2_,_loc2_ + _loc3_.playerName.length + 1);
               _loc2_ += _loc3_.playerName.length + 1;
               _loc1_ = null;
            }
            if(_loc3_.color != 0)
            {
               _loc1_ = new TextFormat();
               _loc1_.color = _loc3_.color;
               mChatLog.setTextFormat(_loc1_,_loc2_,_loc3_.colorEndIndex);
            }
         }
         checkToShowSlider();
         adjustSlider();
      }
      
      private function adjustSlider() : void
      {
         var _loc1_:Boolean = false;
         if(mSlider.value == mSlider.minimum)
         {
            _loc1_ = true;
         }
         if(_loc1_ || !mPlayerSetSlider)
         {
            mSlider.value = mSlider.minimum;
         }
         else
         {
            mSlider.value = mPreviousHeight / mChatLog.textHeight * mSlider.value;
         }
         mPreviousHeight = mChatLog.textHeight;
         setChatLogPosition(mSlider.value);
      }
      
      private function setChatLogPosition(param1:Number) : void
      {
         var _loc2_:Number = Math.round((mChatLog.maxScrollV + 1) * param1 / 100);
         mChatLog.scrollV = _loc2_;
      }
      
      public function isShowing() : Boolean
      {
         return mChatLogContainer.visible;
      }
      
      public function hideChatLog() : void
      {
         if(!mChatLogShowing)
         {
            return;
         }
         mChatLogShowing = false;
         if(mFadeTween && mFadeTween.currentProgress != 1)
         {
            mFadeTween.complete();
         }
         mChatLogContainer.alpha = 1;
         mFadeTween = TweenMax.to(mChatLogContainer,0.3,{
            "alpha":0,
            "onComplete":function():void
            {
               mChatLogContainer.visible = false;
            }
         });
         mSlider.visible = false;
      }
      
      public function showChatLog() : void
      {
         if(mChatLogShowing)
         {
            return;
         }
         mChatLogShowing = true;
         if(mFadeTween && mFadeTween.currentProgress != 1)
         {
            mFadeTween.complete();
         }
         mChatLogContainer.visible = true;
         mChatLogContainer.alpha = 0;
         mFadeTween = TweenMax.to(mChatLogContainer,0.3,{"alpha":1});
         constructAndRenderNewChat();
         checkToShowSlider();
      }
      
      private function checkToShowSlider() : void
      {
         if(mChatLog.maxScrollV > 1)
         {
            mSlider.visible = true;
         }
      }
      
      public function destroy() : void
      {
         if(mFadeTween && mFadeTween.currentProgress != 1)
         {
            mFadeTween.complete();
         }
         disable();
         if(mAssetLoadingComponent)
         {
            mAssetLoadingComponent.destroy();
            mAssetLoadingComponent = null;
         }
         if(mSceneGraphComponent)
         {
            mSceneGraphComponent.destroy();
            mSceneGraphComponent = null;
         }
         if(mEventComponent)
         {
            mEventComponent.removeAllListeners();
            mEventComponent.destroy();
         }
         if(mSlider)
         {
            mSlider.destroy();
         }
         mSlider = null;
         if(mChatLogButton)
         {
            mChatLogButton.destroy();
         }
         mChatLogButton = null;
         mEventComponent = null;
         mDBFacade = null;
         mChatLog = null;
         mChatLogContainer = null;
      }
   }
}

class ChatTextFieldHelper
{
   
   public var chatText:String;
   
   public var color:uint;
   
   public var colorStartIndex:uint;
   
   public var colorEndIndex:uint;
   
   public var playerName:String;
   
   public function ChatTextFieldHelper()
   {
      super();
   }
}
