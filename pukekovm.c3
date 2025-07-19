module pukekovm;

import std::collections::map;

typedef ObjId = usz;

alias ObjStore = HashMap {ObjId, Obj*};
struct VM {
  ObjStore store;
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
  String name;

  Iface* owner;

  Iface*[] type_params; // from 128 to 256
  char[] ins;
  char out;
}

alias VTable = HashMap {FnDecl, Fn};
struct Type {
  VTable vtable;
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
  FN_CALL,
}

union OpInner {
  OpFnCall fn_call;
}

struct OpFnCall {
  Obj* obj;
  Decl* decl;
}
