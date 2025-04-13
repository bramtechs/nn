# `nn`: Non-nullable pointers for C++

`nn` is a type that helps you enforce at compile time the contract that a given pointer
can't be null. It wraps around raw pointers or smart pointers, and works particularly
well out of the box with `std::unique_ptr` and `std::shared_ptr`.

Here's an example:

```cpp
class Widget : public WidgetBase {
public:
  Widget(nn_shared_ptr<Gadget> gadget) : m_gadget(move(gadget)) {}
  // ...
private:
  nn_shared_ptr<Gadget> m_gadget;
};

// nn_make_unique and nn_make_shared always return non-null values
nn_unique_ptr<Widget> my_widget = nn_make_unique<Widget>(nn_make_shared<Gadget>());

// but what if we have a pointer already and we don't know if it's null?
shared_ptr<Gadget> this_might_be_null = ...
my_widget = nn_make_unique<Widget>(this_might_be_null);

// implicit nn_unique_ptr -> nn_shared_ptr works just like unique_ptr -> shared_ptr
nn_shared_ptr<Widget> shared_widget = move(my_widget);

// the `nn` implicitly casts away if needed
void save_ownership_somewhere(shared_ptr<Widget>);
save_ownership_somewhere(shared_widget);

// implicit upcasts work too
nn_shared_ptr<WidgetBase> base_ptr = shared_widget;

// Working with weak pointers
nn_weak_ptr<Widget> weak_widget = nn_make_weak(shared_widget);
// Safely lock the weak pointer - throws if expired
nn_shared_ptr<Widget> locked_widget = nn_lock_throw(weak_widget);
// Or use nn_lock which asserts if expired
nn_shared_ptr<Widget> locked_widget2 = nn_lock(weak_widget);
// For safe checking, use nn_lock_safe which returns a nullable shared_ptr
shared_ptr<Widget> maybe_widget = nn_lock_safe(weak_widget);

// Getting non-null pointers to objects
Widget widget;
nn<Widget*> widget_ptr = nn_addr(widget);

// Pointer casting
nn_shared_ptr<WidgetBase> base_widget = nn_make_shared<Widget>();
// Static cast - always succeeds
nn_shared_ptr<Widget> derived_widget = nn_static_pointer_cast<Widget>(base_widget);
// Dynamic cast - returns nullable pointer
shared_ptr<Widget> maybe_derived = nn_dynamic_pointer_cast<Widget>(base_widget);
// Const cast
const nn_shared_ptr<const Widget> const_widget = nn_make_shared<Widget>();
nn_shared_ptr<Widget> non_const = nn_const_pointer_cast<Widget>(const_widget);

// Using nn_enable_shared_from_this
class MyClass : public nn_enable_shared_from_this<MyClass> {
public:
    nn_shared_ptr<MyClass> get_self() {
        return nn_shared_from_this();
    }
};

// Converting nullable pointers to non-nullable
shared_ptr<Widget> maybe_null = ...;
// Assert if null
nn_shared_ptr<Widget> not_null = NN_CHECK_ASSERT(maybe_null);
// Or throw if null
nn_shared_ptr<Widget> not_null2 = NN_CHECK_THROW(maybe_null);
```
