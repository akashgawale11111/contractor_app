import 'package:contractor_app/language/lib/l10n/app_localizations.dart';
import 'package:contractor_app/language/lib/l10n/language_provider.dart';
import 'package:contractor_app/logic/Apis/provider.dart';
import 'package:contractor_app/ui_screens/home/menu_bar/custom_drawer.dart';
import 'package:contractor_app/ui_screens/home/verificationScreen/map_screen/map_screen.dart';
import 'package:contractor_app/ui_screens/home/nav_bar.dart/navbar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isPunchedIn = false;
  bool _isPunchedOut = false;

  final Map<String, String> languageMap = const {
    'English': 'en',
    'Marathi': 'mr',
    'Hindi': 'hi',
  };

  final List<String> languages = const ['English', 'Marathi', 'Hindi'];

  String getLanguageFromCode(String code) {
    for (var entry in languageMap.entries) {
      if (entry.value == code) {
        return entry.key;
      }
    }
    return 'English'; // default fallback
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final currentLocaleCode = ref.watch(localeProvider).languageCode;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final projectsAsync = ref.watch(projectProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontFamily: 'Source Sans 3'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        // Replace default drawer icon
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
      ),
      bottomNavigationBar: const Navbar2(),
      drawer: CustomDrawer(),
      body: projectsAsync.when(
        data: (projectModel) {
          final projects = projectModel.totalProjects ?? [];
          if (projects.isEmpty) {
            return const Center(child: Text("No projects available"));
          }
          return ListView.builder(
            padding: EdgeInsets.all(width * 0.03),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Container(
                margin: EdgeInsets.only(bottom: height * 0.02),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.028),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        project.projectImageUrl != null
                            ? Image.network(
                              project.projectImageUrl!,
                              width: width * 0.25,
                              height: height * 0.16,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (ctx, err, stack) =>
                                      const Icon(Icons.broken_image, size: 60),
                            )
                            : Image.asset(
                              'assets/images/Elevation1.png',
                              width: width * 0.25,
                              height: height * 0.16,
                              fit: BoxFit.cover,
                            ),
                        SizedBox(width: width * 0.035),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.name ?? "Untitled Project",
                                style: TextStyle(
                                  fontSize: width * 0.037,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE85426),
                                  fontFamily: 'Source Sans 3',
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                project.address ?? "No Address",
                                style: TextStyle(
                                  fontSize: width * 0.029,
                                  color: Colors.black54,
                                  fontFamily: 'Source Sans 3',
                                ),
                              ),
                              SizedBox(height: height * 0.012),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed:
                                        _isPunchedIn
                                            ? null
                                            : () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const PermissionScreen(),
                                                ),
                                              );
                                              setState(() {
                                                _isPunchedIn = true;
                                                _isPunchedOut = false;
                                              });
                                            },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _isPunchedIn
                                              ? Colors.grey
                                              : const Color(0xFFE85426),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                        vertical: height * 0.012,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      "Punch In",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Source Sans 3',
                                        fontSize: width * 0.032,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        _isPunchedIn && !_isPunchedOut
                                            ? () {
                                              setState(() {
                                                _isPunchedOut = true;
                                                _isPunchedIn = false;
                                              });
                                            }
                                            : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _isPunchedOut
                                              ? Colors.grey
                                              : const Color(0xFFE85426),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                        vertical: height * 0.012,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      "Punch Out",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Source Sans 3',
                                        fontSize: width * 0.032,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
