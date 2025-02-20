import 'package:afa/path/path_url_afa.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:afa/providers/register_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnamesController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  @override
  void dispose() {
    _mailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnamesController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth * 0.9 > 700 ? 700 : screenWidth * 0.9;

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.blue,
          selectionColor: Colors.blueAccent,
          selectionHandleColor: Colors.blue,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          backgroundColor: const Color(0xFF063970),
          elevation: 2,
          shadowColor: Colors.black26,
          leadingWidth: 150,
          leading: TextButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            label: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Volver al inicio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Container(
                width: containerWidth,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF063970),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Contenido
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabeledField(
                              'Correo Electrónico:',
                              _buildMailField(registerProvider),
                            ),
                            const SizedBox(height: 15),
                            _buildLabeledField(
                              'Usuario:',
                              _buildTextField(_usernameController, 'cartogar64'),
                            ),
                            const SizedBox(height: 15),
                            _buildLabeledField(
                              'Contraseña:',
                              _buildPasswordField(_passwordController),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Datos Personales',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildLabeledField(
                              'Nombre:',
                              _buildTextField(_nameController, 'Carlos'),
                            ),
                            const SizedBox(height: 15),
                            _buildLabeledField(
                              'Apellidos:',
                              _buildTextField(_surnamesController, 'Toril García'),
                            ),
                            const SizedBox(height: 15),
                            _buildLabeledField(
                              'Teléfono:',
                              _buildTextField(_phoneController, '645323211',
                                  keyboardType: TextInputType.phone),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Dirección',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Calle y Código Postal
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Calle:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      _buildTextField(_streetController, 'Calle Leonardo Da Vinci, 40, 2ºE'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Código Postal:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      _buildTextField(_postalCodeController, '23740',
                                          keyboardType: TextInputType.number),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            // Provincia y Ciudad
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Provincia:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      _buildProvinceDropdown(registerProvider),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Ciudad:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      _buildCityDropdown(registerProvider),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Botón de registro
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Construir la dirección combinada
                                    String address = registerProvider.joinAddress(
                                      _streetController.text,
                                      registerProvider.selectedCity ?? "",
                                      registerProvider.selectedProvince ?? "",
                                      _postalCodeController.text,
                                    );
                                    try {
                                      await registerProvider.registerUser(
                                        mail: _mailController.text,
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        name: _nameController.text,
                                        surnames: _surnamesController.text,
                                        address: address,
                                        phoneNumber: _phoneController.text,
                                      );
                                      _showSubmittedDialog(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error al registrar: $e')),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[900],
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 50,
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Registrarse',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Navegación a inicio de sesión
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  context.go(PathUrlAfa().pathLogin);
                                },
                                child: const Text(
                                  '¿Ya tienes cuenta? Inicia sesión',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  // Helper para crear un campo con etiqueta
  Widget _buildLabeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        field,
      ],
    );
  }
  
  void _showSubmittedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.blue),
              SizedBox(width: 10),
              Text('Formulario enviado'),
            ],
          ),
          content: const Text(
            'Tu solicitud ha sido enviada al administrador. ¡Gracias!',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
  
  // Campo de texto estándar con controlador para validación
  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      cursorColor: Colors.blue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
  
  Widget _buildPasswordField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      cursorColor: Colors.blue,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        filled: true,
        fillColor: Colors.grey[200],
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue[700],
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
  
  Widget _buildMailField(RegisterProvider provider) {
    return TextFormField(
      controller: _mailController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Este campo es obligatorio";
        }
        if (!provider.isCorrectMail(value)) {
          return "Introduce un correo válido";
        }
        return null;
      },
      cursorColor: Colors.blue,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'ejemplo@correo.com',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
  
  // Dropdown para provincia usando el provider
  Widget _buildProvinceDropdown(RegisterProvider provider) {
    return DropdownButtonFormField<String>(
      value: provider.selectedProvince,
      items: provider.provincesNames.map((province) {
        return DropdownMenuItem<String>(
          value: province,
          child: Text(province),
        );
      }).toList(),
      onChanged: (newValue) async {
        if (newValue != null) {
          provider.setSelectedProvince(newValue);
        }
      },
      decoration: InputDecoration(
        hintText: 'Seleccione provincia',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione una provincia';
        }
        return null;
      },
    );
  }
  
  // Dropdown para ciudad usando el provider
  Widget _buildCityDropdown(RegisterProvider provider) {
    return DropdownButtonFormField<String>(
      value: provider.selectedCity,
      items: provider.cities.map((city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          provider.setSelectedCity(newValue);
        }
      },
      decoration: InputDecoration(
        hintText: 'Seleccione ciudad',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione una ciudad';
        }
        return null;
      },
    );
  }
}
