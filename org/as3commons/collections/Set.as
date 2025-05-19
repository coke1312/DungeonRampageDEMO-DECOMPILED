package org.as3commons.collections
{
   import flash.utils.Dictionary;
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.ISet;
   import org.as3commons.collections.framework.core.SetIterator;
   
   public class Set implements ISet
   {
      
      private var _size:uint = 0;
      
      private var _items:Dictionary;
      
      private var _stringItems:Object;
      
      public function Set()
      {
         super();
         this._items = new Dictionary();
         this._stringItems = new Object();
      }
      
      public function get size() : uint
      {
         return this._size;
      }
      
      public function remove(param1:*) : Boolean
      {
         if(param1 is String)
         {
            if(this._stringItems[param1] === undefined)
            {
               return false;
            }
            delete this._stringItems[param1];
         }
         else
         {
            if(this._items[param1] === undefined)
            {
               return false;
            }
            delete this._items[param1];
         }
         --this._size;
         return true;
      }
      
      public function clear() : Boolean
      {
         if(!this._size)
         {
            return false;
         }
         this._items = new Dictionary();
         this._stringItems = new Object();
         this._size = 0;
         return true;
      }
      
      public function iterator(param1:* = undefined) : IIterator
      {
         return new SetIterator(this);
      }
      
      public function add(param1:*) : Boolean
      {
         if(param1 is String)
         {
            if(this._stringItems[param1] !== undefined)
            {
               return false;
            }
            this._stringItems[param1] = param1;
         }
         else
         {
            if(this._items[param1] !== undefined)
            {
               return false;
            }
            this._items[param1] = param1;
         }
         ++this._size;
         return true;
      }
      
      public function has(param1:*) : Boolean
      {
         if(param1 is String)
         {
            return this._stringItems[param1] !== undefined;
         }
         return this._items[param1] !== undefined;
      }
      
      public function toArray() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._stringItems)
         {
            _loc1_.push(_loc2_);
         }
         for each(_loc2_ in this._items)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
   }
}

