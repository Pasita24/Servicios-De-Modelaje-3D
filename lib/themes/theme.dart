import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF3c096c), // Morado oscuro
      surfaceTint: Color(0xFF3c096c),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF5a189a), // Morado más claro
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: Color(0xFFF600DD), // Rosa brillante
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFff66f5), // Rosa más claro
      onSecondaryContainer: Color(0xFF3A3C3D), // Gris oscuro
      tertiary: Color(0xFF240046), // Morado más oscuro
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF3c096c),
      onTertiaryContainer: Color(0xFFFFFFFF),
      error: Color(0xFFBA1A1A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFFFFBFF),
      onSurface: Color(0xFF1D1B1E),
      onSurfaceVariant: Color(0xFF4A454E),
      outline: Color(0xFF7B757F),
      outlineVariant: Color(0xFFCBC4CF),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF322F33),
      inversePrimary: Color(0xFFD7B8FF), // Morado claro
      primaryFixed: Color(0xFFEADDFF),
      onPrimaryFixed: Color(0xFF24005A),
      primaryFixedDim: Color(0xFFD7B8FF),
      onPrimaryFixedVariant: Color(0xFF4F2B7A),
      secondaryFixed: Color(0xFFFFD8F4),
      onSecondaryFixed: Color(0xFF3B002F),
      secondaryFixedDim: Color(0xFFFFAEE8),
      onSecondaryFixedVariant: Color(0xFF7A0068),
      tertiaryFixed: Color(0xFFEADDFF),
      onTertiaryFixed: Color(0xFF24005A),
      tertiaryFixedDim: Color(0xFFD7B8FF),
      onTertiaryFixedVariant: Color(0xFF4F2B7A),
      surfaceDim: Color(0xFFDDDBDE),
      surfaceBright: Color(0xFFFFFBFF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF7F5F8),
      surfaceContainer: Color(0xFFF1EFF2),
      surfaceContainerHigh: Color(0xFFEBE9EC),
      surfaceContainerHighest: Color(0xFFE5E3E6),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFD7B8FF), // Morado claro
      surfaceTint: Color(0xFFD7B8FF),
      onPrimary: Color(0xFF3D006E),
      primaryContainer: Color(0xFF5600A3), // Morado medio
      onPrimaryContainer: Color(0xFFEADDFF),
      secondary: Color(0xFFFFAEE8), // Rosa claro
      onSecondary: Color(0xFF5C0051),
      secondaryContainer: Color(0xFF7A0068),
      onSecondaryContainer: Color(0xFFFFD8F4),
      tertiary: Color(0xFF3c096c), // Morado oscuro
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF240046),
      onTertiaryContainer: Color(0xFFEADDFF),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF141316),
      onSurface: Color(0xFFE5E3E6),
      onSurfaceVariant: Color(0xFFCBC4CF),
      outline: Color(0xFF958E99),
      outlineVariant: Color(0xFF4A454E),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE5E3E6),
      inversePrimary: Color(0xFF6F43A6), // Morado medio
      primaryFixed: Color(0xFFEADDFF),
      onPrimaryFixed: Color(0xFF24005A),
      primaryFixedDim: Color(0xFFD7B8FF),
      onPrimaryFixedVariant: Color(0xFF4F2B7A),
      secondaryFixed: Color(0xFFFFD8F4),
      onSecondaryFixed: Color(0xFF3B002F),
      secondaryFixedDim: Color(0xFFFFAEE8),
      onSecondaryFixedVariant: Color(0xFF7A0068),
      tertiaryFixed: Color(0xFFEADDFF),
      onTertiaryFixed: Color(0xFF24005A),
      tertiaryFixedDim: Color(0xFFD7B8FF),
      onTertiaryFixedVariant: Color(0xFF4F2B7A),
      surfaceDim: Color(0xFF141316),
      surfaceBright: Color(0xFF3B383D),
      surfaceContainerLowest: Color(0xFF0F0E11),
      surfaceContainerLow: Color(0xFF1D1B1E),
      surfaceContainer: Color(0xFF211F23),
      surfaceContainerHigh: Color(0xFF2C292D),
      surfaceContainerHighest: Color(0xFF373438),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,

    // Personalización adicional para coincidir con tu diseño
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF3c096c).withOpacity(0.8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF600DD),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black.withOpacity(0.7),
      selectedItemColor: const Color(0xFFF600DD),
      unselectedItemColor: Colors.white70,
    ),
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
