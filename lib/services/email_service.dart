import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async'; // Importación necesaria para TimeoutException

class EmailService {
  static Future<void> sendQuoteEmail({
    required String toEmail,
    required String userName,
    required Map<String, dynamic> quoteDetails,
    required int totalPrice,
  }) async {
    try {
      // Carga explícita del .env
      await dotenv.load(fileName: ".env");

      final username = dotenv.env['EMAIL_USERNAME'];
      final password = dotenv.env['EMAIL_PASSWORD'];

      if (username == null || password == null) {
        throw Exception('Credenciales no configuradas en .env');
      }

      print('Intentando enviar correo desde: $username');

      // Configuración SMTP (eliminado el timeout que causaba el error)
      final smtpServer = gmail(username, password);

      final message =
          Message()
            ..from = Address(username, 'Servicios de Modelaje 3D')
            ..recipients.add(toEmail)
            ..subject = 'Cotización de personaje 3D'
            ..html = _buildEmailHtml(userName, quoteDetails, totalPrice);

      // Envío con timeout a nivel de la operación send()
      final sendReport = await send(
        message,
        smtpServer,
      ).timeout(const Duration(seconds: 30));

      print('Correo enviado: ${sendReport.toString()}');
    } on MailerException catch (e) {
      print('Error SMTP: ${e.toString()}');
      print('Mensaje de error: ${e.message}');
      throw Exception('Error al enviar correo: ${e.message}');
    } on TimeoutException catch (e) {
      print('Tiempo de espera agotado: $e');
      throw Exception('Tiempo de espera agotado al enviar el correo');
    } catch (e) {
      print('Error inesperado: ${e.toString()}');
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  static String _buildEmailHtml(
    String userName,
    Map<String, dynamic> quoteDetails,
    int totalPrice,
  ) {
    final detailsList = quoteDetails.entries
        .map(
          (entry) => '<li><strong>${entry.key}:</strong> ${entry.value}</li>',
        )
        .join('');

    return '''
      <html>
        <body>
          <h2>Hola $userName,</h2>
          <p>Aquí está la cotización de tu personaje 3D:</p>
          <ul>
            $detailsList
          </ul>
          <h3>Total: \$$totalPrice</h3>
          <p>¡Gracias por usar nuestros servicios!</p>
          <p>Equipo de Modelaje 3D</p>
        </body>
      </html>
    ''';
  }

  static Future<void> sendSurveyResults({
    required String userName,
    required String userEmail,
    required Map<String, dynamic> responses,
  }) async {
    try {
      await dotenv.load(fileName: ".env");
      final adminEmail =
          dotenv.env['ADMIN_EMAIL'] ?? dotenv.env['EMAIL_USERNAME'];

      if (adminEmail == null) {
        throw Exception('Correo admin no configurado en .env');
      }

      final smtpServer = gmail(
        dotenv.env['EMAIL_USERNAME']!,
        dotenv.env['EMAIL_PASSWORD']!,
      );

      final htmlContent = '''
      <html>
        <body>
          <h2>Nueva encuesta recibida - Modelaje 3D</h2>
          <p><strong>Usuario:</strong> $userName ($userEmail)</p>
          <h3>Datos demográficos:</h3>
          <ul>
            <li><strong>Edad:</strong> ${responses['edad']}</li>
            <li><strong>Tipo de usuario:</strong> ${responses['tipo_usuario']}</li>
          </ul>
          
          <h3>Evaluación:</h3>
          <ul>
            <li><strong>Usabilidad:</strong> ${responses['usabilidad']}/5</li>
            <li><strong>Modelos 3D:</strong> ${responses['modelos']}/5</li>
            <li><strong>Visualización AR:</strong> ${responses['ar']}/5</li>
            <li><strong>Recomendación:</strong> ${responses['recomendacion']}/5</li>
          </ul>
          
          <h3>Comentarios:</h3>
          <p>${responses['comentarios']?.isNotEmpty == true ? responses['comentarios'] : 'Sin comentarios'}</p>
          
          <p>Fecha: ${DateTime.now().toString()}</p>
        </body>
      </html>
    ''';

      final message =
          Message()
            ..from = Address(
              dotenv.env['EMAIL_USERNAME']!,
              'Encuestas Modelaje 3D',
            )
            ..recipients.add(adminEmail)
            ..subject = 'Encuesta completada por $userName'
            ..html = htmlContent;

      await send(message, smtpServer);
    } catch (e) {
      print('Error enviando encuesta: $e');
      rethrow;
    }
  }
}
