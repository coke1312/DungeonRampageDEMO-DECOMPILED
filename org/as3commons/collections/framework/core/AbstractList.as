package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.framework.IDataProvider;
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.IList;
   
   use namespace as3commons_collections;
   
   public class AbstractList implements IList, IDataProvider
   {
      
      protected var _array:Array;
      
      public function AbstractList()
      {
         super();
         this._array = new Array();
      }
      
      public function firstIndexOf(param1:*) : int
      {
         return this._array.indexOf(param1);
      }
      
      public function set array(param1:Array) : void
      {
         this._array = param1.concat();
      }
      
      public function get size() : uint
      {
         return this._array.length;
      }
      
      public function removeLast() : *
      {
         return this._array.pop();
      }
      
      public function remove(param1:*) : Boolean
      {
         var _loc2_:int = int(this._array.indexOf(param1));
         if(_loc2_ == -1)
         {
            return false;
         }
         this._array.splice(_loc2_,1);
         this.itemRemoved(_loc2_,param1);
         return true;
      }
      
      public function removeFirst() : *
      {
         return this._array.shift();
      }
      
      public function clear() : Boolean
      {
         if(!this._array.length)
         {
            return false;
         }
         this._array = new Array();
         return true;
      }
      
      public function removeAllAt(param1:uint, param2:uint) : Array
      {
         return this._array.splice(param1,param2);
      }
      
      protected function itemRemoved(param1:uint, param2:*) : void
      {
      }
      
      public function removeAt(param1:uint) : *
      {
         return this._array.splice(param1,1)[0];
      }
      
      public function get last() : *
      {
         return this._array[this._array.length - 1];
      }
      
      public function count(param1:*) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = this._array.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this._array[_loc4_] === param1)
            {
               _loc2_++;
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function add(param1:*) : uint
      {
         this._array.push(param1);
         return this._array.length - 1;
      }
      
      public function lastIndexOf(param1:*) : int
      {
         var _loc2_:int = this._array.length - 1;
         while(_loc2_ >= 0)
         {
            if(param1 === this._array[_loc2_])
            {
               return _loc2_;
            }
            _loc2_--;
         }
         return -1;
      }
      
      public function toArray() : Array
      {
         return this._array.concat();
      }
      
      public function itemAt(param1:uint) : *
      {
         return this._array[param1];
      }
      
      public function has(param1:*) : Boolean
      {
         return this.firstIndexOf(param1) > -1;
      }
      
      as3commons_collections function get array_internal() : Array
      {
         return this._array;
      }
      
      public function iterator(param1:* = undefined) : IIterator
      {
         var _loc2_:uint = param1 is uint ? param1 : 0;
         return new AbstractListIterator(this,_loc2_);
      }
      
      public function get first() : *
      {
         return this._array[0];
      }
      
      public function removeAll(param1:*) : uint
      {
         var _loc2_:uint = this._array.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._array[_loc3_] === param1)
            {
               this._array.splice(_loc3_,1);
               this.itemRemoved(_loc3_,param1);
               _loc3_--;
            }
            _loc3_++;
         }
         return _loc2_ - this._array.length;
      }
   }
}

