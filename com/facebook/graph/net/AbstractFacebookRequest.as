package com.facebook.graph.net
{
   import com.adobe.images.PNGEncoder;
   import com.adobe.serialization.json.JSON;
   import com.facebook.graph.utils.PostRequest;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.FileReference;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   
   public class AbstractFacebookRequest
   {
      
      protected var urlLoader:URLLoader;
      
      protected var urlRequest:URLRequest;
      
      protected var _rawResult:String;
      
      protected var _data:Object;
      
      protected var _success:Boolean;
      
      protected var _url:String;
      
      protected var _requestMethod:String;
      
      protected var _callback:Function;
      
      public function AbstractFacebookRequest()
      {
         super();
      }
      
      public function get rawResult() : String
      {
         return this._rawResult;
      }
      
      public function get success() : Boolean
      {
         return this._success;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function callURL(param1:Function, param2:String = "", param3:String = null) : void
      {
         var _loc4_:URLVariables = null;
         this._callback = param1;
         this.urlRequest = new URLRequest(param2.length ? param2 : this._url);
         if(param3)
         {
            _loc4_ = new URLVariables();
            _loc4_.locale = param3;
            this.urlRequest.data = _loc4_;
         }
         this.loadURLLoader();
      }
      
      public function set successCallback(param1:Function) : void
      {
         this._callback = param1;
      }
      
      protected function isValueFile(param1:Object) : Boolean
      {
         return param1 is FileReference || param1 is Bitmap || param1 is BitmapData || param1 is ByteArray;
      }
      
      protected function objectToURLVariables(param1:Object) : URLVariables
      {
         var _loc3_:String = null;
         var _loc2_:URLVariables = new URLVariables();
         if(param1 == null)
         {
            return _loc2_;
         }
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      public function close() : void
      {
         if(this.urlLoader != null)
         {
            this.urlLoader.removeEventListener(Event.COMPLETE,this.handleURLLoaderComplete);
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.handleURLLoaderIOError);
            this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleURLLoaderSecurityError);
            try
            {
               this.urlLoader.close();
            }
            catch(e:*)
            {
            }
            this.urlLoader = null;
         }
      }
      
      protected function loadURLLoader() : void
      {
         this.urlLoader = new URLLoader();
         this.urlLoader.addEventListener(Event.COMPLETE,this.handleURLLoaderComplete,false,0,false);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleURLLoaderIOError,false,0,true);
         this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleURLLoaderSecurityError,false,0,true);
         this.urlLoader.load(this.urlRequest);
      }
      
      protected function handleURLLoaderComplete(param1:Event) : void
      {
         this.handleDataLoad(this.urlLoader.data);
      }
      
      protected function handleDataLoad(param1:Object, param2:Boolean = true) : void
      {
         var result:Object = param1;
         var dispatchCompleteEvent:Boolean = param2;
         this._rawResult = result as String;
         this._success = true;
         try
         {
            this._data = com.adobe.serialization.json.JSON.decode(this._rawResult);
         }
         catch(e:*)
         {
            _data = _rawResult;
            _success = false;
         }
         this.handleDataReady();
         if(dispatchCompleteEvent)
         {
            this.dispatchComplete();
         }
      }
      
      protected function handleDataReady() : void
      {
      }
      
      protected function dispatchComplete() : void
      {
         if(this._callback != null)
         {
            this._callback(this);
         }
         this.close();
      }
      
      protected function handleURLLoaderIOError(param1:IOErrorEvent) : void
      {
         var event:IOErrorEvent = param1;
         this._success = false;
         this._rawResult = (event.target as URLLoader).data;
         if(this._rawResult != "")
         {
            try
            {
               this._data = com.adobe.serialization.json.JSON.decode(this._rawResult);
            }
            catch(e:*)
            {
               _data = {
                  "type":"Exception",
                  "message":_rawResult
               };
            }
         }
         else
         {
            this._data = event;
         }
         this.dispatchComplete();
      }
      
      protected function handleURLLoaderSecurityError(param1:SecurityErrorEvent) : void
      {
         var event:SecurityErrorEvent = param1;
         this._success = false;
         this._rawResult = (event.target as URLLoader).data;
         try
         {
            this._data = com.adobe.serialization.json.JSON.decode((event.target as URLLoader).data);
         }
         catch(e:*)
         {
            _data = event;
         }
         this.dispatchComplete();
      }
      
      protected function extractFileData(param1:Object) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         if(param1 == null)
         {
            return null;
         }
         if(this.isValueFile(param1))
         {
            _loc2_ = param1;
         }
         else if(param1 != null)
         {
            for(_loc3_ in param1)
            {
               if(this.isValueFile(param1[_loc3_]))
               {
                  _loc2_ = param1[_loc3_];
                  delete param1[_loc3_];
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      protected function createUploadFileRequest(param1:Object, param2:Object = null) : PostRequest
      {
         var _loc4_:String = null;
         var _loc5_:ByteArray = null;
         var _loc3_:PostRequest = new PostRequest();
         if(param2)
         {
            for(_loc4_ in param2)
            {
               _loc3_.writePostData(_loc4_,param2[_loc4_]);
            }
         }
         if(param1 is Bitmap)
         {
            param1 = (param1 as Bitmap).bitmapData;
         }
         if(param1 is ByteArray)
         {
            _loc3_.writeFileData(param2.fileName,param1 as ByteArray,param2.contentType);
         }
         else if(param1 is BitmapData)
         {
            _loc5_ = PNGEncoder.encode(param1 as BitmapData);
            _loc3_.writeFileData(param2.fileName,_loc5_,"image/png");
         }
         _loc3_.close();
         this.urlRequest.contentType = "multipart/form-data; boundary=" + _loc3_.boundary;
         return _loc3_;
      }
      
      public function toString() : String
      {
         return this.urlRequest.url + (this.urlRequest.data == null ? "" : "?" + unescape(this.urlRequest.data.toString()));
      }
   }
}

