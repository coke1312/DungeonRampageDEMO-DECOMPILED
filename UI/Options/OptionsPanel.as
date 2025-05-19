package UI.Options
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Event.EventComponent;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.UI.UIButton;
   import Brain.UI.UIRadioButton;
   import DBGlobals.DBGlobal;
   import Events.UIHudChangeEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import Sound.DBSoundManager;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class OptionsPanel
   {
      
      private static const GRAPHICS_QUALITY_RADIO_BUTTON_GROUP:String = "GRAPHICS_QUALITY_RADIO_BUTTON_GROUP";
      
      private static const HUD_CHOICE_RADIO_BUTTON_GROUP:String = "HUD_CHOICE_RADIO_BUTTON_GROUP";
      
      private static var GRAPHICS_DIRTY:Boolean = false;
      
      private static var MUSIC_VOLUME_DIRTY:Boolean = false;
      
      private static var SFX_VOLUME_DIRTY:Boolean = false;
      
      private static var HUD_STYLE_DIRTY:Boolean = false;
      
      protected var mDBFacade:DBFacade;
      
      protected var mDBSoundManager:DBSoundManager;
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      protected var mSceneGraphComponent:SceneGraphComponent;
      
      protected var mEventComponent:EventComponent;
      
      private var mCurtainActive:Boolean = false;
      
      private var mCloseButton:UIButton;
      
      private var mTitleLabel:TextField;
      
      private var mSfxLabel:TextField;
      
      private var mSfxButton:UIButton;
      
      private var mMusicLabel:TextField;
      
      private var mMusicButton:UIButton;
      
      private var mGraphicsLabel:TextField;
      
      private var mGraphicsLowLabel:TextField;
      
      private var mGraphicsHighLabel:TextField;
      
      private var mGraphicsLowRadioButton:UIRadioButton;
      
      private var mGraphicsHighRadioButton:UIRadioButton;
      
      private var mHudLabel:TextField;
      
      private var mHudDefaultLabel:TextField;
      
      private var mHudCondensedLabel:TextField;
      
      private var mHudCondensedBlurbLabel:TextField;
      
      private var mHudDefaultBlurbLabel:TextField;
      
      private var mHudDefaultRadioButton:UIRadioButton;
      
      private var mHudCondensedRadioButton:UIRadioButton;
      
      private var mHudStyle:uint = 0;
      
      private var mRoot:MovieClip;
      
      public function OptionsPanel(param1:DBFacade)
      {
         super();
         mDBFacade = param1;
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mEventComponent = new EventComponent(mDBFacade);
         mDBSoundManager = mDBFacade.soundManager as DBSoundManager;
         readAccountDeetsToSetInitialValues();
         loadSwf();
      }
      
      private function readAccountDeetsToSetInitialValues() : void
      {
         var _loc6_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:String = mDBFacade.dbAccountInfo.getAttribute("optionsSFXVolume");
         if(_loc1_ != null)
         {
            _loc6_ = Number(_loc1_);
            mDBSoundManager.sfxVolumeScale = _loc6_;
         }
         var _loc3_:String = mDBFacade.dbAccountInfo.getAttribute("optionsMusicVolume");
         if(_loc3_ != null)
         {
            _loc5_ = Number(_loc3_);
            mDBSoundManager.musicVolumeScale = _loc5_;
         }
         var _loc4_:String = mDBFacade.dbAccountInfo.getAttribute("optionsGraphicsQuality");
         if(_loc4_ == "high" || _loc4_ == "low")
         {
            setQuality(_loc4_);
         }
         var _loc2_:String = mDBFacade.dbAccountInfo.getAttribute("optionsHudStyle");
         if(_loc2_ != null)
         {
            mHudStyle = uint(_loc2_);
         }
         else
         {
            mHudStyle = 0;
         }
      }
      
      private function loadSwf() : void
      {
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_town.swf"),swfLoaded);
      }
      
      private function swfLoaded(param1:SwfAsset) : void
      {
         var optionsPanelX:Number;
         var optionsPanelY:Number;
         var swfAsset:SwfAsset = param1;
         var optionsClass:Class = swfAsset.getClass("popup_options_01");
         mRoot = new optionsClass();
         mCloseButton = new UIButton(mDBFacade,mRoot.close);
         mCloseButton.releaseCallback = hide;
         mTitleLabel = mRoot.title_label as TextField;
         mTitleLabel.text = Locale.getString("OPTIONS_PANEL_TITLE");
         mMusicLabel = mRoot.music_label as TextField;
         mMusicLabel.text = Locale.getString("OPTIONS_PANEL_MUSIC");
         mMusicButton = new UIButton(mDBFacade,mRoot.music_checkbox);
         mMusicButton.releaseCallback = toggleMusic;
         if(mDBSoundManager.musicVolumeScale > 0)
         {
            musicButtonSelected(true);
         }
         mSfxLabel = mRoot.sfx_label as TextField;
         mSfxLabel.text = Locale.getString("OPTIONS_PANEL_SOUND_EFFECTS_LABEL");
         mSfxButton = new UIButton(mDBFacade,mRoot.sfx_checkbox);
         mSfxButton.releaseCallback = toggleSfx;
         if(mDBSoundManager.sfxVolumeScale > 0)
         {
            sfxButtonSelected(true);
         }
         mGraphicsLabel = mRoot.graphics_label as TextField;
         mGraphicsLabel.text = Locale.getString("OPTIONS_PANEL_GRAPHICS_QUALITY_LABEL");
         mGraphicsLowLabel = mRoot.gfx_low_label as TextField;
         mGraphicsLowLabel.text = Locale.getString("OPTIONS_PANEL_GRAPHICS_QUALITY_LOW_LABEL");
         mGraphicsHighLabel = mRoot.gfx_high_label as TextField;
         mGraphicsHighLabel.text = Locale.getString("OPTIONS_PANEL_GRAPHICS_QUALITY_HIGH_LABEL");
         mGraphicsLowRadioButton = new UIRadioButton(mDBFacade,mRoot.gfx_low_radio_button,"GRAPHICS_QUALITY_RADIO_BUTTON_GROUP");
         mGraphicsLowRadioButton.releaseCallback = function():void
         {
            setQuality("low");
         };
         mGraphicsHighRadioButton = new UIRadioButton(mDBFacade,mRoot.gfx_high_radio_button,"GRAPHICS_QUALITY_RADIO_BUTTON_GROUP");
         mGraphicsHighRadioButton.releaseCallback = function():void
         {
            setQuality("high");
         };
         mHudLabel = mRoot.hud_label as TextField;
         mHudLabel.text = Locale.getString("OPTIONS_PANEL_HUD_LABEL");
         mHudDefaultLabel = mRoot.legacy_label as TextField;
         mHudDefaultLabel.text = Locale.getString("OPTIONS_PANEL_DEFAULT_HUD_LABEL");
         mHudDefaultBlurbLabel = mRoot.legacy_label1 as TextField;
         mHudDefaultBlurbLabel.text = Locale.getString("OPTIONS_PANEL_DEFAULT_BLURB");
         mHudDefaultBlurbLabel.visible = false;
         mHudCondensedLabel = mRoot.new_label as TextField;
         mHudCondensedLabel.text = Locale.getString("OPTIONS_PANEL_CONDENSED_HUD_LABEL");
         mHudCondensedBlurbLabel = mRoot.new_label1 as TextField;
         mHudCondensedBlurbLabel.text = Locale.getString("OPTIONS_PANEL_CONDENSED_BLURB");
         mHudDefaultRadioButton = new UIRadioButton(mDBFacade,mRoot.legacy_radio_button,"HUD_CHOICE_RADIO_BUTTON_GROUP");
         mHudDefaultRadioButton.releaseCallback = function():void
         {
            setHud(0);
         };
         mHudCondensedRadioButton = new UIRadioButton(mDBFacade,mRoot.new_radio_button,"HUD_CHOICE_RADIO_BUTTON_GROUP");
         mHudCondensedRadioButton.releaseCallback = function():void
         {
            setHud(1);
         };
         optionsPanelX = mDBFacade.dbConfigManager.getConfigNumber("options_panel_x",550);
         optionsPanelY = mDBFacade.dbConfigManager.getConfigNumber("options_panel_y",100);
         mRoot.x = optionsPanelX;
         mRoot.y = optionsPanelY;
      }
      
      private function setQuality(param1:String) : void
      {
         if(mDBFacade.quality != param1)
         {
            mDBFacade.quality = param1;
            GRAPHICS_DIRTY = true;
         }
      }
      
      private function setHud(param1:uint) : void
      {
         mHudStyle = param1;
         HUD_STYLE_DIRTY = true;
         mEventComponent.dispatchEvent(new UIHudChangeEvent(mHudStyle));
      }
      
      private function sfxButtonSelected(param1:Boolean) : void
      {
         mSfxButton.selected = param1;
      }
      
      private function musicButtonSelected(param1:Boolean) : void
      {
         mMusicButton.selected = param1;
      }
      
      private function toggleSfx() : void
      {
         var _loc1_:Number = mDBSoundManager.sfxVolumeScale;
         if(_loc1_ > 0)
         {
            setSfxVolume(0);
            sfxButtonSelected(false);
         }
         else
         {
            setSfxVolume(1);
            sfxButtonSelected(true);
         }
      }
      
      private function setSfxVolume(param1:Number) : void
      {
         if(mDBSoundManager.sfxVolumeScale != param1)
         {
            mDBSoundManager.sfxVolumeScale = param1;
            SFX_VOLUME_DIRTY = true;
         }
      }
      
      private function toggleMusic() : void
      {
         var _loc1_:Number = mDBSoundManager.musicVolumeScale;
         if(_loc1_ > 0)
         {
            setMusicVolume(0);
            musicButtonSelected(false);
         }
         else
         {
            setMusicVolume(DBGlobal.MUSIC_VOLUME);
            musicButtonSelected(true);
         }
      }
      
      private function setMusicVolume(param1:Number) : void
      {
         if(mDBSoundManager.musicVolumeScale != param1)
         {
            mDBSoundManager.musicVolumeScale = param1;
            MUSIC_VOLUME_DIRTY = true;
         }
      }
      
      public function hide() : void
      {
         if(mRoot)
         {
            mSceneGraphComponent.removeChild(mRoot);
         }
         removeCurtain();
         saveValuesToDB();
      }
      
      private function saveValuesToDB() : void
      {
         if(GRAPHICS_DIRTY)
         {
            if(mDBFacade.dbAccountInfo.getAttribute("optionsGraphicsQuality") != mDBFacade.quality)
            {
               mDBFacade.dbAccountInfo.alterAttribute("optionsGraphicsQuality",mDBFacade.quality);
            }
         }
         if(SFX_VOLUME_DIRTY)
         {
            if(mDBFacade.dbAccountInfo.getAttribute("optionsSFXVolume") != mDBSoundManager.sfxVolumeScale.toString())
            {
               mDBFacade.dbAccountInfo.alterAttribute("optionsSFXVolume",mDBSoundManager.sfxVolumeScale.toString());
            }
         }
         if(MUSIC_VOLUME_DIRTY)
         {
            if(mDBFacade.dbAccountInfo.getAttribute("optionsMusicVolume") != mDBSoundManager.musicVolumeScale.toString())
            {
               mDBFacade.dbAccountInfo.alterAttribute("optionsMusicVolume",mDBSoundManager.musicVolumeScale.toString());
            }
         }
         if(HUD_STYLE_DIRTY)
         {
            if(mDBFacade.dbAccountInfo.getAttribute("optionsHudStyle") as uint != mHudStyle)
            {
               mDBFacade.dbAccountInfo.alterAttribute("optionsHudStyle",mHudStyle.toString());
            }
         }
         GRAPHICS_DIRTY = false;
         SFX_VOLUME_DIRTY = false;
         MUSIC_VOLUME_DIRTY = false;
         HUD_STYLE_DIRTY = false;
      }
      
      public function show() : void
      {
         if(mRoot)
         {
            if(mDBFacade.quality == "high")
            {
               mGraphicsHighRadioButton.selected = true;
            }
            else
            {
               mGraphicsLowRadioButton.selected = true;
            }
            switch(int(mHudStyle))
            {
               case 0:
                  mHudDefaultRadioButton.selected = true;
                  break;
               case 1:
                  mHudCondensedRadioButton.selected = true;
            }
            mSceneGraphComponent.addChild(mRoot,105);
            showCurtain();
         }
      }
      
      private function showCurtain() : void
      {
         if(!mCurtainActive)
         {
            mCurtainActive = true;
            mSceneGraphComponent.showPopupCurtain();
         }
      }
      
      private function removeCurtain() : void
      {
         if(mCurtainActive)
         {
            mCurtainActive = false;
            mSceneGraphComponent.removePopupCurtain();
         }
      }
      
      public function toggleVisible() : Boolean
      {
         if(mRoot)
         {
            if(mSceneGraphComponent.contains(mRoot,50))
            {
               this.hide();
               return false;
            }
            this.show();
            return true;
         }
         return false;
      }
      
      public function destroy() : void
      {
         hide();
         mCloseButton.destroy();
         mSfxButton.destroy();
         mMusicButton.destroy();
         mGraphicsLowRadioButton.destroy();
         mGraphicsHighRadioButton.destroy();
         mRoot = null;
         mSceneGraphComponent.destroy();
         mSceneGraphComponent = null;
         mAssetLoadingComponent.destroy();
         mAssetLoadingComponent = null;
         mDBFacade = null;
      }
   }
}

