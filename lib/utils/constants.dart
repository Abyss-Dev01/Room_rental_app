import 'package:flutter/material.dart';

final Shader mainTextGradient = LinearGradient(
  colors: <Color>[Color(0xFFCF1414), Color(0xFF109BDB)],
).createShader(
  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
);

final Shader subTextGradient = LinearGradient(
  colors: <Color>[Color(0xFF23D11D), Color(0xFFE98C13)],
).createShader(
  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
);

final Shader noticeTextGradient = LinearGradient(
  colors: <Color>[Color(0xFFB5DB0D), Color(0xFFEC12E1)],
).createShader(
  Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
);
