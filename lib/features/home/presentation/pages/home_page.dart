import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expensego/features/auth/domain/entities/user_entity.dart';
import 'package:expensego/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:expensego/features/profile/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final primaryColor = Colors.indigo;

  @override
  Widget build(BuildContext context) {
    // Mengatur agar status bar ikon berwarna gelap (cocok untuk background terang)
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor:
            Colors.transparent, // transparan agar warna background terlihat
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return _buildDashboardContent(context, state.user);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, UserEntity user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(user),
          const SizedBox(height: 24),
          _buildBalanceCard(user),
          const SizedBox(height: 24),
          _buildDoughnutChartCard(),
        ],
      ),
    );
  }

  Widget _buildHeader(UserEntity user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              "${user.name ?? 'User'} 👋",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.indigo,
            backgroundImage:
                user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
            child:
                user.photoUrl == null
                    ? const Icon(Icons.person, size: 24, color: Colors.white)
                    : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(UserEntity user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Remaining Balance",
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            "Rp 2.350.000",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummary(
                color: Colors.greenAccent,
                label: "Income",
                amount: "3.000.000",
              ),
              _buildSummary(
                color: Colors.redAccent,
                label: "Expense",
                amount: "650.000",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary({
    required Color color,
    required String label,
    required String amount,
  }) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
            ),
            Text(
              "Rp $amount",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoughnutChartCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Expense Categories",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  sections: [
                    _pieChartSection('Makan', 45, Colors.indigo),
                    _pieChartSection('Transport', 25, Colors.orange),
                    _pieChartSection('Belanja', 20, Colors.green),
                    _pieChartSection('Lainnya', 10, Colors.redAccent),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  PieChartSectionData _pieChartSection(
    String title,
    double value,
    Color color,
  ) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: '${value.toInt()}%',
      radius: 50,
      titleStyle: GoogleFonts.poppins(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLegend() {
    final legends = [
      {'label': 'Makan', 'color': Colors.indigo},
      {'label': 'Transport', 'color': Colors.orange},
      {'label': 'Belanja', 'color': Colors.green},
      {'label': 'Lainnya', 'color': Colors.redAccent},
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children:
          legends.map((e) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 6, backgroundColor: e['color'] as Color),
                const SizedBox(width: 6),
                Text(
                  e['label'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
