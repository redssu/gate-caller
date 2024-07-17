import "package:flutter/cupertino.dart";
import "package:gate_caller/sizes.dart";

class HSpace extends SizedBox {
  const HSpace(double space) : super(width: space);

  const HSpace.p4() : this(Sizes.p4);
  const HSpace.p8() : this(Sizes.p8);
  const HSpace.p12() : this(Sizes.p12);
  const HSpace.p16() : this(Sizes.p16);
  const HSpace.p20() : this(Sizes.p20);
  const HSpace.p24() : this(Sizes.p24);
  const HSpace.p32() : this(Sizes.p32);
  const HSpace.p48() : this(Sizes.p48);
  const HSpace.p64() : this(Sizes.p64);
}
