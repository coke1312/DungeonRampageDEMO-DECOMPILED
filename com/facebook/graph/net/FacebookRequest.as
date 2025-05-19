package com.facebook.graph.net
{
   import flash.events.DataEvent;
   import flash.events.ErrorEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.FileReference;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   
   public class FacebookRequest extends AbstractFacebookRequest
   {
      
      protected var fileReference:FileReference;
      
      public function FacebookRequest()
      {
         super();
      }
      
      public function call(param1:String, param2:String = "GET", param3:Function = null, param4:* = null) : void
      {
         _url = param1;
         _requestMethod = param2;
         _callback = param3;
         var _loc5_:String = param1;
         urlRequest = new URLRequest(_loc5_);
         urlRequest.method = _requestMethod;
         if(param4 == null)
         {
            loadURLLoader();
            return;
         }
         var _loc6_:Object = extractFileData(param4);
         if(_loc6_ == null)
         {
            urlRequest.data = objectToURLVariables(param4);
            loadURLLoader();
            return;
         }
         if(_loc6_ is FileReference)
         {
            urlRequest.data = objectToURLVariables(param4);
            urlRequest.method = URLRequestMethod.POST;
            this.fileReference = _loc6_ as FileReference;
            this.fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,this.handleFileReferenceData,false,0,true);
            this.fileReference.addEventListener(IOErrorEvent.IO_ERROR,this.handelFileReferenceError,false,0,false);
            this.fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handelFileReferenceError,false,0,false);
            this.fileReference.upload(urlRequest);
            return;
         }
         urlRequest.data = createUploadFileRequest(_loc6_,param4).getPostData();
         urlRequest.method = URLRequestMethod.POST;
         loadURLLoader();
      }
      
      override public function close() : void
      {
         super.close();
         if(this.fileReference != null)
         {
            this.fileReference.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA,this.handleFileReferenceData);
            this.fileReference.removeEventListener(IOErrorEvent.IO_ERROR,this.handelFileReferenceError);
            this.fileReference.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handelFileReferenceError);
            try
            {
               this.fileReference.cancel();
            }
            catch(e:*)
            {
            }
            this.fileReference = null;
         }
      }
      
      protected function handleFileReferenceData(param1:DataEvent) : void
      {
         handleDataLoad(param1.data);
      }
      
      protected function handelFileReferenceError(param1:ErrorEvent) : void
      {
         _success = false;
         _data = param1;
         dispatchComplete();
      }
   }
}

