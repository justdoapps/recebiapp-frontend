import 'package:flutter/material.dart';

@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  final TextStyle veryLarge;
  final TextStyle veryLargeBold;
  final TextStyle large;
  final TextStyle largeBold;
  final TextStyle medium;
  final TextStyle mediumBold;
  final TextStyle small;
  final TextStyle smallBold;
  final TextStyle verySmall;
  final TextStyle verySmallBold;
  final TextStyle errorForm;

  const AppTypography({
    required this.veryLarge,
    required this.veryLargeBold,
    required this.large,
    required this.largeBold,
    required this.medium,
    required this.mediumBold,
    required this.small,
    required this.smallBold,
    required this.verySmall,
    required this.verySmallBold,
    required this.errorForm,
  });

  @override
  AppTypography copyWith({
    TextStyle? veryLarge,
    TextStyle? veryLargeBold,
    TextStyle? large,
    TextStyle? largeBold,
    TextStyle? medium,
    TextStyle? mediumBold,
    TextStyle? small,
    TextStyle? smallBold,
    TextStyle? verySmall,
    TextStyle? verySmallBold,
    TextStyle? errorForm,
  }) {
    return AppTypography(
      veryLarge: veryLarge ?? this.veryLarge,
      veryLargeBold: veryLargeBold ?? this.veryLargeBold,
      large: large ?? this.large,
      largeBold: largeBold ?? this.largeBold,
      medium: medium ?? this.medium,
      mediumBold: mediumBold ?? this.mediumBold,
      small: small ?? this.small,
      smallBold: smallBold ?? this.smallBold,
      verySmall: verySmall ?? this.verySmall,
      verySmallBold: verySmallBold ?? this.verySmallBold,
      errorForm: errorForm ?? this.errorForm,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      veryLarge: TextStyle.lerp(veryLarge, other.veryLarge, t)!,
      veryLargeBold: TextStyle.lerp(veryLargeBold, other.veryLargeBold, t)!,
      large: TextStyle.lerp(large, other.large, t)!,
      largeBold: TextStyle.lerp(largeBold, other.largeBold, t)!,
      medium: TextStyle.lerp(medium, other.medium, t)!,
      mediumBold: TextStyle.lerp(mediumBold, other.mediumBold, t)!,
      small: TextStyle.lerp(small, other.small, t)!,
      smallBold: TextStyle.lerp(smallBold, other.smallBold, t)!,
      verySmall: TextStyle.lerp(verySmall, other.verySmall, t)!,
      verySmallBold: TextStyle.lerp(verySmallBold, other.verySmallBold, t)!,
      errorForm: TextStyle.lerp(errorForm, other.errorForm, t)!,
    );
  }
}
