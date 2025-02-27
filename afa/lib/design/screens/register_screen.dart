import 'package:afa/operations/providers/user_register_provider.dart';
import 'package:afa/operations/router/path/path_url_afa.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _termsAccepted = false;
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

  Future<Position?> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está activado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El servicio de ubicación está desactivado.')),
      );
      return null;
    }

    // Verificar el estado de los permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Los permisos de ubicación fueron denegados.')),
        );
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Los permisos de ubicación están permanentemente denegados.')),
      );
      return null;
    }
    // Si se conceden los permisos, obtenemos la ubicación
    return await Geolocator.getCurrentPosition();
  }

  void _registerUser(UserRegisterProvider userRegisterProvider) async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar los términos y condiciones.')),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      // Solicitar permisos de ubicación y obtener la posición
      Position? position = await _requestLocationPermission();
      if (position == null) return;
      
      // Construir la dirección combinada
      String address = userRegisterProvider.joinAddress(
        _streetController.text,
        userRegisterProvider.selectedCity ?? "",
        userRegisterProvider.selectedProvince ?? "",
        _postalCodeController.text,
      );
      try {
        await userRegisterProvider.registerUser(
          mail: _mailController.text,
          username: _usernameController.text,
          password: _passwordController.text,
          name: _nameController.text,
          surnames: _surnamesController.text,
          address: address,
          phoneNumber: _phoneController.text,
        );
        showSubmittedDialog(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final userRegisterProvider = Provider.of<UserRegisterProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    // Definimos anchos fijos:
    const double formWidth = 700;
    const double imageWidth = 300;
    const double spacing = 40;
    // Usamos layout en fila solo si el ancho es suficiente para ambos elementos
    final bool isLargeScreen = screenWidth >= (formWidth + imageWidth + spacing);

    return Scaffold(
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
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: isLargeScreen
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Formulario de registro (pegado a la izquierda)
                        Container(
                          width: formWidth,
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
                          child: _buildRegisterForm(userRegisterProvider),
                        ),
                        // Imagen (pegada a la derecha)
                        Image.asset(
                          'assets/images/logo.png',
                          width: imageWidth,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        width: screenWidth * 0.9,
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
                        child: _buildRegisterForm(userRegisterProvider),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/images/logo.png',
                        width: imageWidth,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm(UserRegisterProvider userRegisterProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Título del formulario
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
              'Registro',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Contenedor con los campos
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
                _buildFloatingTextField(
                  label: 'Correo Electrónico',
                  hint: 'ejemplo@correo.com',
                  controller: _mailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    if (!userRegisterProvider.isCorrectMail(value)) {
                      return "Introduce un correo válido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildFloatingTextField(
                  label: 'Usuario',
                  hint: 'cartogar64',
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildFloatingPasswordField(_passwordController, userRegisterProvider),
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
                _buildFloatingTextField(
                  label: 'Nombre',
                  hint: 'Carlos',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildFloatingTextField(
                  label: 'Apellidos',
                  hint: 'Toril García',
                  controller: _surnamesController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                _buildFloatingTextField(
                  label: 'Teléfono',
                  hint: '645323211',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
                      return "El teléfono debe tener 9 dígitos";
                    }
                    return null;
                  },
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
                Row(
                  children: [
                    Expanded(
                      child: _buildFloatingTextField(
                        label: 'Calle',
                        hint: 'Calle Leonardo Da Vinci, 40, 2ºE',
                        controller: _streetController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Este campo es obligatorio";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildFloatingTextField(
                        label: 'Código Postal',
                        hint: '23740',
                        controller: _postalCodeController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Este campo es obligatorio";
                          }
                          if (!RegExp(r'^[0-9]{5}$').hasMatch(value)) {
                            return "El código postal debe tener 5 dígitos";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _buildFloatingDropdown(
                        label: 'Provincia',
                        hint: 'Seleccione provincia',
                        value: userRegisterProvider.selectedProvince,
                        items: userRegisterProvider.provincesNames,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            userRegisterProvider.setSelectedProvince(newValue);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleccione una provincia';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildFloatingDropdown(
                        label: 'Ciudad',
                        hint: 'Seleccione ciudad',
                        value: userRegisterProvider.selectedCity,
                        items: userRegisterProvider.cities,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            userRegisterProvider.setSelectedCity(newValue);
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Seleccione una ciudad';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Checkbox de términos y condiciones
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Acepto los términos y condiciones',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Botón de registro
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      _registerUser(userRegisterProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showSubmittedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: Colors.blue,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildFloatingPasswordField(TextEditingController controller, UserRegisterProvider userRegisterProvider) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.blue,
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Este campo es obligatorio";
        }
        if (!userRegisterProvider.isSecurePassword(value)) {
          return "La contraseña no es segura. Debe tener al menos 8 caracteres, \n"
                 "incluir mayúsculas, minúsculas, dígitos y un carácter especial.";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Contraseña',
        hintText: 'Contraseña',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(),
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

  Widget _buildFloatingDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(),
      ),
    );
  }
}