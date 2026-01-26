import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract class AppTexts {
  static final textTheme = GoogleFonts.robotoTextTheme();

  static const _defaultTypography = AppTypography(
    veryLarge: TextStyle(fontSize: 32, fontWeight: .w400),
    veryLargeBold: TextStyle(fontSize: 32, fontWeight: .w800),
    large: TextStyle(fontSize: 22, fontWeight: .w400),
    largeBold: TextStyle(fontSize: 22, fontWeight: .w800),
    medium: TextStyle(fontSize: 16, fontWeight: .w400),
    mediumBold: TextStyle(fontSize: 16, fontWeight: .w800),
    small: TextStyle(fontSize: 14, fontWeight: .w400),
    smallBold: TextStyle(fontSize: 14, fontWeight: .w800),
    verySmall: TextStyle(fontSize: 12, fontWeight: .w400),
    verySmallBold: TextStyle(fontSize: 12, fontWeight: .w800),
    errorForm: TextStyle(
      fontSize: 11,
      color: Colors.red,
      fontStyle: .italic,
      fontWeight: .w600,
    ),
  );

  static final darkTypography = _defaultTypography.copyWith(
    veryLarge: _defaultTypography.veryLarge.copyWith(
      color: AppColors.darkColorScheme.onSurface,
    ),
    veryLargeBold: _defaultTypography.veryLargeBold.copyWith(
      color: AppColors.darkColorScheme.onSurface,
    ),
    large: _defaultTypography.large.copyWith(
      color: AppColors.darkColorScheme.onSurface,
    ),
    largeBold: _defaultTypography.largeBold.copyWith(
      color: AppColors.darkColorScheme.onSurface,
    ),
    medium: _defaultTypography.medium.copyWith(
      color: AppColors.darkColorScheme.onSurface,
    ),
    mediumBold: _defaultTypography.mediumBold.copyWith(
      color: AppColors.darkColorScheme.onSurface,
    ),
    small: _defaultTypography.small.copyWith(
      color: AppColors.darkColorScheme.onSurface,
    ),
    smallBold: _defaultTypography.smallBold.copyWith(
      color: AppColors.darkColorScheme.onSurface,
    ),
    verySmall: _defaultTypography.verySmall.copyWith(
      color: AppColors.darkColorScheme.onSurface,
    ),
    verySmallBold: _defaultTypography.verySmallBold.copyWith(
      color: AppColors.darkColorScheme.onSurface,
    ),
    errorForm: _defaultTypography.errorForm,
  );

  static final lightTypography = _defaultTypography.copyWith(
    veryLarge: _defaultTypography.veryLarge.copyWith(
      color: AppColors.lightColorScheme.onSurface,
    ),
    veryLargeBold: _defaultTypography.veryLargeBold.copyWith(
      color: AppColors.lightColorScheme.onSurface,
    ),
    large: _defaultTypography.large.copyWith(
      color: AppColors.lightColorScheme.onSurface,
    ),
    largeBold: _defaultTypography.largeBold.copyWith(
      color: AppColors.lightColorScheme.onSurface,
    ),
    medium: _defaultTypography.medium.copyWith(
      color: AppColors.lightColorScheme.onSurface,
    ),
    mediumBold: _defaultTypography.mediumBold.copyWith(
      color: AppColors.lightColorScheme.onSurface,
    ),
    small: _defaultTypography.small.copyWith(
      color: AppColors.lightColorScheme.onSurface,
    ),
    smallBold: _defaultTypography.smallBold.copyWith(
      color: AppColors.lightColorScheme.onSurface,
    ),
    verySmall: _defaultTypography.verySmall.copyWith(
      color: AppColors.lightColorScheme.onSurface,
    ),
    verySmallBold: _defaultTypography.verySmallBold.copyWith(
      color: AppColors.lightColorScheme.onSurface,
    ),
    errorForm: _defaultTypography.errorForm,
  );
}
