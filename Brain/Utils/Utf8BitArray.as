package Brain.Utils
{
   import flash.utils.ByteArray;
   
   public class Utf8BitArray
   {
      
      public var decodedByteArray:ByteArray;
      
      public function Utf8BitArray()
      {
         super();
         decodedByteArray = new ByteArray();
      }
      
      public function init(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(param1 == null)
         {
            decodedByteArray = new ByteArray();
         }
         else
         {
            decodedByteArray = new ByteArray();
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = Number(param1.charCodeAt(_loc2_));
               decodedByteArray.writeByte(_loc3_);
               if(_loc3_ >> 8 != 0)
               {
                  decodedByteArray.writeByte(_loc3_ >> 8);
               }
               _loc2_++;
            }
         }
      }
      
      public function destroy() : void
      {
         decodedByteArray = null;
      }
      
      public function setBit(param1:uint) : void
      {
      }
      
      public function getBit(param1:uint) : Boolean
      {
         var _loc2_:uint = param1 / 8;
         var _loc3_:uint = 7 - param1 % 8;
         if(_loc2_ < decodedByteArray.length)
         {
            return (decodedByteArray[_loc2_] & 1 << _loc3_) != 0;
         }
         return false;
      }
      
      public function getLength() : uint
      {
         return decodedByteArray.length * 8;
      }
   }
}

