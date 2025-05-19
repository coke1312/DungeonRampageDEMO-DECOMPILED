package com.facebook.graph.utils
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class PostRequest
   {
      
      public var boundary:String = "-----";
      
      protected var postData:ByteArray;
      
      public function PostRequest()
      {
         super();
         this.createPostData();
      }
      
      public function createPostData() : void
      {
         this.postData = new ByteArray();
         this.postData.endian = Endian.BIG_ENDIAN;
      }
      
      public function writePostData(param1:String, param2:String) : void
      {
         var _loc3_:String = null;
         this.writeBoundary();
         this.writeLineBreak();
         _loc3_ = "Content-Disposition: form-data; name=\"" + param1 + "\"";
         var _loc4_:uint = uint(_loc3_.length);
         var _loc5_:Number = 0;
         while(_loc5_ < _loc4_)
         {
            this.postData.writeByte(_loc3_.charCodeAt(_loc5_));
            _loc5_++;
         }
         this.writeLineBreak();
         this.writeLineBreak();
         this.postData.writeUTFBytes(param2);
         this.writeLineBreak();
      }
      
      public function writeFileData(param1:String, param2:ByteArray, param3:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         this.writeBoundary();
         this.writeLineBreak();
         _loc4_ = "Content-Disposition: form-data; name=\"" + param1 + "\"; filename=\"" + param1 + "\";";
         _loc5_ = _loc4_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.postData.writeByte(_loc4_.charCodeAt(_loc6_));
            _loc6_++;
         }
         this.postData.writeUTFBytes(param1);
         this.writeQuotationMark();
         this.writeLineBreak();
         _loc4_ = param3 || "application/octet-stream";
         _loc5_ = _loc4_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.postData.writeByte(_loc4_.charCodeAt(_loc6_));
            _loc6_++;
         }
         this.writeLineBreak();
         this.writeLineBreak();
         param2.position = 0;
         this.postData.writeBytes(param2,0,param2.length);
         this.writeLineBreak();
      }
      
      public function getPostData() : ByteArray
      {
         this.postData.position = 0;
         return this.postData;
      }
      
      public function close() : void
      {
         this.writeBoundary();
         this.writeDoubleDash();
      }
      
      protected function writeLineBreak() : void
      {
         this.postData.writeShort(3338);
      }
      
      protected function writeQuotationMark() : void
      {
         this.postData.writeByte(34);
      }
      
      protected function writeDoubleDash() : void
      {
         this.postData.writeShort(11565);
      }
      
      protected function writeBoundary() : void
      {
         this.writeDoubleDash();
         var _loc1_:uint = uint(this.boundary.length);
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            this.postData.writeByte(this.boundary.charCodeAt(_loc2_));
            _loc2_++;
         }
      }
   }
}

