package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.ArrayList;
   import org.as3commons.collections.framework.IOrderedList;
   import org.as3commons.collections.framework.IOrderedListIterator;
   
   public class ArrayListIterator extends AbstractListIterator implements IOrderedListIterator
   {
      
      public function ArrayListIterator(param1:ArrayList, param2:uint = 0)
      {
         super(param1,param2);
      }
      
      public function addBefore(param1:*) : uint
      {
         var _loc2_:uint = 0;
         _current = -1;
         if(_next == -1)
         {
            _loc2_ = uint(this._arrayList.size);
         }
         else
         {
            _loc2_ = uint(_next);
            ++_next;
         }
         this._arrayList.addAt(_loc2_,param1);
         return _loc2_;
      }
      
      public function replace(param1:*) : Boolean
      {
         if(_current == -1)
         {
            return false;
         }
         return this._arrayList.replaceAt(_current,param1);
      }
      
      private function get _arrayList() : IOrderedList
      {
         return _list as IOrderedList;
      }
      
      public function addAfter(param1:*) : uint
      {
         var _loc2_:uint = 0;
         _current = -1;
         if(_next == -1)
         {
            _loc2_ = uint(this._arrayList.size);
            _next = _loc2_;
         }
         else
         {
            _loc2_ = uint(_next);
         }
         this._arrayList.addAt(_loc2_,param1);
         return _loc2_;
      }
   }
}

