module pukekovm;

import std::collections::map;
typedef ObjId = usz;

alias ObjStore = HashMap {ObjId, Obj*};
alias IfaceStore = HashMap {String, Iface*};
struct VM {
  ObjStore obj_store;
  IfaceStore iface_store;
}

alias DeclTable = HashMap {FnDecl, bool} // TODO: rewrite to custom HashSet
struct Iface {
  String hash;

  Iface*[] type_params; // from 0 to 127

  DeclTable decl_table;
}

struct Obj {
  ObjId id;

  Type* type;
}

struct FnDecl {
  String hash;

  Iface* owner;

  Iface*[] type_params; // from 128 to 256
  char[] ins;
  char out;
}

alias VTable = HashMap {FnDecl, Fn};
alias IfaceTable = HashMap {String, Iface};
struct Type {
  IfaceTable vtable;
}

struct Fn {
  FnDecl* decl;

  Op[] body;
}

struct Op {
  OpKind discriminant;

  OpInner inner;
}

enum OpKind {
  OBJ,
  IFACE,

}

enum OpNativeKind {
  NATIVE_FN,
}

union OpInner {
  OpFnCall fn_call;
}

union OpNativeInner {
  NativeFn native_fn;
}

struct OpFnCall {
  Obj* obj;
  Decl* decl;
}

alias NativeFn = fn Obj* (Obj*[]);
