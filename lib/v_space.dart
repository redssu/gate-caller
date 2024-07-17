import "package:flutter/cupertino.dart";
import "package:gate_caller/sizes.dart";

class VSpace extends SizedBox {
  const VSpace(double space) : super(height: space);

  const VSpace.p4() : this(Sizes.p4);
  const VSpace.p8() : this(Sizes.p8);
  const VSpace.p12() : this(Sizes.p12);
  const VSpace.p16() : this(Sizes.p16);
  const VSpace.p20() : this(Sizes.p20);
  const VSpace.p24() : this(Sizes.p24);
  const VSpace.p32() : this(Sizes.p32);
  const VSpace.p48() : this(Sizes.p48);
  const VSpace.p64() : this(Sizes.p64);
}
