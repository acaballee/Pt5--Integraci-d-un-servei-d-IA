import 'package:flutter/material.dart';
import 'config/api_keys.dart';
import 'models/receipt_data.dart';
import 'strategies/ai_context.dart';
import 'strategies/gemini_strategy.dart';
import 'strategies/groq_strategy.dart';
import 'widgets/example_buttons.dart';
import 'widgets/results_card.dart';

void main() {
  runApp(const SmartReceiptApp());
}

class SmartReceiptApp extends StatelessWidget {
  const SmartReceiptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartReceipt AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
          error: Color(0xFFEF4444),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _receiptController = TextEditingController();
  final AIContext _aiContext = AIContext();

  String _selectedProvider = 'gemini';
  bool _isLoading = false;
  String? _errorMsg;
  ReceiptData? _resultData;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _receiptController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _processReceipt() async {
    final text = _receiptController.text.trim();
    if (text.isEmpty) {
      setState(() => _errorMsg = "Si us plau, introdueix el text del tiquet.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      // Aplicar patró Strategy
      if (_selectedProvider == 'gemini') {
        _aiContext.setStrategy(GeminiStrategy(ApiKeys.geminiKey));
      } else {
        _aiContext.setStrategy(GroqStrategy(ApiKeys.groqKey));
      }

      final data = await _aiContext.process(text);
      setState(() {
        _resultData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // Contingut principal
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildLeftColumn()),
                          const SizedBox(width: 20),
                          Expanded(child: _buildRightColumn()),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildLeftColumn(),
                          const SizedBox(height: 20),
                          _buildRightColumn(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.white, Color(0xFF6366F1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'SmartReceipt ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PT5 IA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA5B4FC),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Converteix els teus tiquets en dades estructurades amb el poder de la IA.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      children: [
        // Card Configuració
        _buildCard(
          icon: Icons.settings_outlined,
          title: 'Configuració',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Proveïdor de IA (Strategy)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.5),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedProvider,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E293B),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    items: const [
                      DropdownMenuItem(
                        value: 'gemini',
                        child: Text('Google Gemini (Flash 1.5)'),
                      ),
                      DropdownMenuItem(
                        value: 'groq',
                        child: Text('Groq (Llama 3)'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedProvider = value!;
                        _errorMsg = null;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Card Entrada de Tiquet
        _buildCard(
          icon: Icons.description_outlined,
          title: 'Entrada de Tiquet',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Text del tiquet (OCR Simulat)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.5),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _receiptController,
                  maxLines: 8,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText:
                        'Enganxa aquí el text extret del tiquet...\nEx: REPSOL Tortosa, 45.50€...',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.25),
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Botons d'exemple
              ExampleButtons(
                onExampleSelected: (text) {
                  _receiptController.text = text;
                  setState(() => _errorMsg = null);
                },
              ),
              const SizedBox(height: 20),

              // Botó Processar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _processReceipt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: const Color(
                      0xFF6366F1,
                    ).withValues(alpha: 0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Processar amb IA',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),

              // Error
              if (_errorMsg != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMsg!,
                  style: const TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightColumn() {
    return _resultData != null
        ? ResultsCard(data: _resultData!)
        : _buildCard(
            icon: Icons.inventory_2_outlined,
            title: 'Dades Extretes',
            minHeight: 350,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Esperant dades per analitzar...',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required Widget child,
    double minHeight = 0,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
